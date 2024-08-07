package com.spring.survey.controller;

import org.springframework.http.HttpHeaders;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.spring.survey.dto.page.Page;
import com.spring.survey.dto.page.PageCreator;
import com.spring.survey.dto.request.OptionDTO;
import com.spring.survey.dto.request.QuestionDTO;
import com.spring.survey.dto.request.SurveyDTO;
import com.spring.survey.dto.request.SurveyResponseDTO;
import com.spring.survey.dto.request.SurveyResultOnlyDTO;
import com.spring.survey.dto.response.SurveyFileResponseDTO;
import com.spring.survey.dto.response.SurveyRegistResponseDTO;
import com.spring.survey.entity.Member;
import com.spring.survey.entity.Option;
import com.spring.survey.entity.Question;
import com.spring.survey.entity.Survey;
import com.spring.survey.entity.SurveyFile;
import com.spring.survey.service.ISurveyService;
import com.spring.survey.utils.DateUtils;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/particiation")
@RequiredArgsConstructor
public class SurveyController {
	
	private final ISurveyService service;
	private final BCryptPasswordEncoder encoder;
	
	//목록 확인
	@GetMapping("/researchList")
	public void freeList(Page page, Model model, HttpServletRequest request) {
		System.out.println("/particiation/researchList: GET!");
		System.out.println("페이지:"+page);
		PageCreator creator;
		int totalCount = service.getTotal(page);
		model.addAttribute("msg", "showList");
		
		if(page.getCondition() != null && page.getKeyword() != null) { // 검색한 경우
			page.setSearchFlag(true);
			if(totalCount == 0) { // 검색 결과 없음
				model.addAttribute("msg", "searchFail");
			}
		}
		
		if(totalCount == 0) { // 게시글 없는경우
			if(!page.isSearchFlag()) { // 원래 게시글 없음
				model.addAttribute("msg", "zeroBoard");
			} else { 
				model.addAttribute("msg", "searchFail");
			}
			page.setKeyword(null);
			page.setCondition(null);
			creator = new PageCreator(page, service.getTotal(page));
			
		}else {
			creator = new PageCreator(page, totalCount);
			
		} // if문 끝
		
		model.addAttribute("boardList", service.getList(page)); //void이므로 ~List.jsp로 전달
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("pc", creator);
		model.addAttribute("myPage", false);
		System.out.println("=======================");
		System.out.println(request.getHeader("referer"));
		System.out.println(request.getHeaderNames());
		System.out.println("=======================");
	}
	// 나의 페이지 이동 요청
	@GetMapping("/researchMyList")
	public String myList(Page page, Model model, @RequestParam String userId) {
		System.out.println("/particiation/researchMyList: GET! userId="+userId);
		System.out.println("페이지:"+page);
		PageCreator creator;
		int totalCount = service.getMyTotal(userId, page);
		model.addAttribute("msg", "showList");
		
		if(page.getCondition() != null && page.getKeyword() != null) { // 검색한 경우
			page.setSearchFlag(true);
			if(totalCount == 0) { // 검색 결과 없음
				model.addAttribute("msg", "searchFail");
			}
		}
		
		if(totalCount == 0) { // 게시글 없는경우
			if(!page.isSearchFlag()) { // 원래 게시글 없음
				model.addAttribute("msg", "zeroBoard");
			} else { 
				model.addAttribute("msg", "searchFail");
			}
			page.setKeyword(null);
			page.setCondition(null);
			creator = new PageCreator(page, service.getMyTotal(userId, page));
			
		}else {
			creator = new PageCreator(page, totalCount);
			
		} // if문 끝
		
		model.addAttribute("boardList", service.getMyList(userId, page));
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("pc", creator);
		model.addAttribute("myPage", true);
		return "/particiation/researchList";
	}
	
	//글쓰기 페이지를 열어주는 메서드
	@GetMapping("/researchCreate")
	public String registPage(HttpServletRequest request, RedirectAttributes redirectAttributes) {
		 HttpSession session = request.getSession(false);
		    if (session == null || session.getAttribute("loginUser") == null) {
		        // 로그인하지 않은 경우
		        redirectAttributes.addFlashAttribute("message", "loginRequired");
		        return "redirect:/particiation/researchList";
		    } else {
		    	// 로그인한 경우 등록 페이지로 이동
		    	return "/particiation/researchCreate";
		    }
	}
	
	//로그인 페이지를 열어주는 메서드
	@GetMapping("/login")
	public void loginPage() {
		
	}
	
	// 테스트 페이지로 이동
	@GetMapping("/test")
	public void testPage() {
		
	}
	
	// (임시) 특정 아이디 가진 해당 회원정보에 비밀번호 암호화해서 디비에 넣기
	@GetMapping("/password")
	public String insertPw(@RequestParam("userId") String userId, @RequestParam("password") String password, HttpServletRequest request) {
	   // Member member = service.findByUserId(userId); // 사용자 아이디로 회원 정보 조회
	    String secretPw = encoder.encode(password);
	    service.insertPw(userId, secretPw);
	    return "redirect:/particiation/login";
	}
	//로그인
    @PostMapping("/login")
    public String login(@RequestParam("userId") String userId, @RequestParam("password") String password, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        Member member = service.findByUserId(userId); // 사용자 아이디로 회원 정보 조회
        if (member != null && encoder.matches(password, member.getPassword())) { // 비밀번호 검증
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", member); // 세션에 사용자 정보 저장
            
            String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
            if (redirectAfterLogin != null) {
                session.removeAttribute("redirectAfterLogin");
                return "redirect:/particiation" + redirectAfterLogin;
            } else {
            	return "redirect:/"; // 로그인 성공 시 홈으로 리다이렉트
            }
        } else {
            redirectAttributes.addFlashAttribute("loginFailed", true);
            return "redirect:/particiation/login"; // 로그인 실패 시 로그인 페이지로 다시 이동
        }
    }
	//로그아웃
	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
	    HttpSession session = request.getSession(false);
	    if (session != null) {
	        session.invalidate(); // 세션 무효화
	    }
	    return "redirect:/"; // 홈으로 리다이렉트
	}
	
	//글 등록 처리
	@PostMapping("/researchCreate")
	@ResponseBody
	public ResponseEntity<?> createSurvey(@RequestPart SurveyDTO surveyDTO,
			@RequestPart(value="file", required = false) List<MultipartFile> files, 
			BindingResult bindingResult, 
			HttpServletRequest request) {
		System.out.println("dto:"+surveyDTO);
	    if (bindingResult.hasErrors()) {
	        // 에러 처리 로직
	        return new ResponseEntity<>(bindingResult.getAllErrors(), HttpStatus.BAD_REQUEST);
	    }
        Survey survey = convertToEntity(surveyDTO);
        HttpSession session = request.getSession(); // HttpServletRequest를 통해 HttpSession을 가져옴.
        System.out.println(files);
        // 설문 및 첨부파일 등록
        try {
        	service.createSurveyWithQuestionsAndOptions(survey, 
        			survey.getQuestions(), 
        			extractOptionsList(survey.getQuestions()),
        			session, 
        			files
        			);
        } catch (MaxUploadSizeExceededException e) {
        	System.out.println("1111");
            return new ResponseEntity<>("파일 크기가 너무 큽니다. 최대 1GB까지 업로드할 수 있습니다.", HttpStatus.PAYLOAD_TOO_LARGE);
        } catch (Exception e) {
        	System.out.println("22222");
        	return new ResponseEntity<>("파일 업로드 중 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>("등록되었습니다.", HttpStatus.OK);
    }
	
    public Survey convertToEntity(SurveyDTO surveyDTO) {
        Survey survey = new Survey();
        survey.setTitle(surveyDTO.getTitle());
        survey.setStartDate(LocalDate.parse(surveyDTO.getStartDate()));
        survey.setEndDate(LocalDate.parse(surveyDTO.getEndDate()));
        if(surveyDTO.getSurveyId() != null) {
        	survey.setSurveyId(surveyDTO.getSurveyId());
        }
        // creator, createdAt, updatedAt는 여기서 설정하지 않았다.
        // 질문 변환
        List<Question> questions = surveyDTO.getQuestions().stream()
                                             .map(this::convertQuestion)
                                             .collect(Collectors.toList());
        survey.setQuestions(questions);

        return survey;
    }

    private Question convertQuestion(QuestionDTO questionDTO) {
        Question question = new Question();
        question.setQuestionText(questionDTO.getQuestionText());
        List<Option> options = questionDTO.getOptions().stream()
                                          .map(this::convertOption)
                                          .collect(Collectors.toList());
        question.setOptions(options);

        return question;
    }

    private Option convertOption(OptionDTO optionDTO) {
        Option option = new Option();
        option.setOptionText(optionDTO.getOptionText());

        return option;
    }

    // Question 엔티티들로부터 Option 리스트 추출
    private List<List<Option>> extractOptionsList(List<Question> questions) {
        return questions.stream()
                        .map(Question::getOptions)
                        .collect(Collectors.toList());
    }
    
	//뷰 페이지를 열어주는 메서드
	@GetMapping("/researchView")
	public String viewPage(@RequestParam("id") Long id, @RequestParam(value="myPage", defaultValue="false") boolean myPage,
			Model model, @ModelAttribute Page page) {
		// @ModelAttribute("p") Page page 객체에 HTTP로 넘어 온 값들을 바인딩 -> jsp에서 p로 사용
		System.out.println("/researchView?id=: "+id+", page객체: "+page);
		Survey survey = service.findById(id);
		List<SurveyFile> files = service.filesBySurveyId(id);
		System.out.println("survey의 실체: " + survey);
		System.out.println("files의 실체: " + files);
		System.out.println("myPage 여부: " + myPage);
        
		if(files.isEmpty()) {
			System.out.println("이 설문은 첨부 파일이 없습니다.");
		}
		// SurveyFile 리스트를 SurveyFileDTO 리스트로 변환
		List<SurveyFileResponseDTO> fileDTOs = files.stream()
				.map(SurveyFileResponseDTO::new)
				.collect(Collectors.toList());
		SurveyRegistResponseDTO surveyResponseDTO = new SurveyRegistResponseDTO(survey);
		model.addAttribute("board", surveyResponseDTO);
		model.addAttribute("files", fileDTOs);
		model.addAttribute("myPage", myPage);
		System.out.println(fileDTOs);
		return "/particiation/researchView"; // 폴더명/파일명
	}
	// 파일 다운로드 요청 처리
	@GetMapping("/download")
	@ResponseBody
	public ResponseEntity<Resource> downloadBoardFile(@RequestParam("fileId") Long fileId,@RequestParam("surveyId")Long surveyId) {
	    System.out.println("fileId: "+fileId+", surveyId: "+surveyId+" 인 파일 다운로드 요청 받음!");
	    
	    SurveyFileResponseDTO fileDto = service.getFile(fileId);
	    
	    try {
            Path filePath = Paths.get(fileDto.getFilePath());
            Resource resource = new UrlResource(filePath.toUri());
            if (resource.exists() || resource.isReadable()) {
                return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                    .body(resource);
            } else {
                throw new RuntimeException("Could not read the file!");
            }
        } catch (Exception e) {
            throw new RuntimeException("Error: " + e.getMessage());
        }
	}
	
	// 글 수정 페이지 이동 요청
	@GetMapping("/researchEdit")
	public void modifyPage(@RequestParam("id") Long id, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
		System.out.println("/researchEdit?id="+id);
		Survey survey = service.findById(id);
		List<SurveyFile> files = service.filesBySurveyId(id);
		if(files.isEmpty()) {
			System.out.println("이 설문은 첨부 파일이 없습니다.");
		}
		List<SurveyFileResponseDTO> fileDTOs = files.stream()
				.map(SurveyFileResponseDTO::new)
				.collect(Collectors.toList());
		SurveyRegistResponseDTO surveyResponseDTO = new SurveyRegistResponseDTO(survey);
    	model.addAttribute("board", surveyResponseDTO);
    	model.addAttribute("files", fileDTOs);
	}
	
	/************* 설문 참여 ****************/
	// 설문 응답 페이지 이동 요청 (목록에서)
	@GetMapping("/researchDo")
	public String surveyDoPage(@RequestParam("id") Long id, Model model, @ModelAttribute Page page, HttpServletRequest request, RedirectAttributes redirectAttributes) {
		System.out.println("/researchDo?id="+id);
		 HttpSession session = request.getSession(false);
		    if (session == null || session.getAttribute("loginUser") == null) {
		        // 로그인하지 않은 경우
		    	redirectAttributes.addFlashAttribute("message", "loginRequired");
		        return "redirect:/particiation/researchList";
		    } 
	    // 사용자가 이미 참여했는지 확인
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    boolean hasParticipated = service.hasUserParticipated(id, loginUser.getUserId());
	    if (hasParticipated) {
	        redirectAttributes.addFlashAttribute("message", "alreadyParticipated");
	        return "redirect:/particiation/researchList";
	    }
		Survey survey = service.findById(id);
		List<SurveyFile> files = service.filesBySurveyId(id);
		if(files.isEmpty()) {
			System.out.println("이 설문은 첨부 파일이 없습니다.");
		}
		List<SurveyFileResponseDTO> fileDTOs = files.stream()
				.map(SurveyFileResponseDTO::new)
				.collect(Collectors.toList());
		SurveyRegistResponseDTO surveyResponseDTO = new SurveyRegistResponseDTO(survey);
		
		//System.out.println("board 확인: "+surveyResponseDTO);
    	model.addAttribute("board", surveyResponseDTO);
    	model.addAttribute("files", fileDTOs);
		return "/particiation/researchDo";
	}
	// 설문 응답 페이지 이동 요청 (상세에서)
		@GetMapping("/researchDoInView")
		public String surveyDoInViewPage(@RequestParam("id") Long id, Model model, @ModelAttribute Page page, HttpServletRequest request, RedirectAttributes redirectAttributes) {
			System.out.println("/researchDoInView?id="+id);
			 HttpSession session = request.getSession(false);
			    if (session == null || session.getAttribute("loginUser") == null) {
			        // 로그인하지 않은 경우
			    	redirectAttributes.addFlashAttribute("message", "loginRequired");
			        return "redirect:/particiation/researchList";
			    } 
		    // 사용자가 이미 참여했는지 확인
		    Member loginUser = (Member) session.getAttribute("loginUser");
		    boolean hasParticipated = service.hasUserParticipated(id, loginUser.getUserId());
		    if (hasParticipated) {
		        redirectAttributes.addFlashAttribute("message", "alreadyParticipated");
		        return "redirect:/particiation/researchView?id="+id;
		    }
			Survey survey = service.findById(id);
			List<SurveyFile> files = service.filesBySurveyId(id);
			if(files.isEmpty()) {
				System.out.println("이 설문은 첨부 파일이 없습니다.");
			}
			List<SurveyFileResponseDTO> fileDTOs = files.stream()
					.map(SurveyFileResponseDTO::new)
					.collect(Collectors.toList());
			SurveyRegistResponseDTO surveyResponseDTO = new SurveyRegistResponseDTO(survey);
			//System.out.println("board 확인: "+surveyResponseDTO);
	    	model.addAttribute("board", surveyResponseDTO);
	    	model.addAttribute("files", fileDTOs);
			return "/particiation/researchDo";
		}
	
	// 참여자의 설문 응답 등록
	@PostMapping("/researchDo") // Spring MVC에서는 한 메서드에서 두 개 이상의 @RequestBody를 사용할 수 없다. 요청 본문을 한 번만 읽을 수 있기 때문
    public String submitSurvey(@RequestBody SurveyResponseDTO surveyResponseDTO, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        System.out.println("======researchDo 요청 받음!"+ surveyResponseDTO.getUserId() + "의 dto: "+ surveyResponseDTO);
        service.saveSurveyResults(surveyResponseDTO, surveyResponseDTO.getUserId());
        return "redirect:/particiation/researchList";
    }
	/*********** 설문 참여 끝 ************/
	// 수정 화면에서 첨부파일 삭제
	@PostMapping("/particiation/deleteFile")
	@ResponseBody
	public Map<String, Object> deleteFile(@RequestParam("fileId") Long fileId, @RequestParam("surveyId") Long surveyId) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        // 파일 삭제 로직 수행
	        //service.deleteFile(fileId, surveyId);
	        response.put("success", true);
	    } catch (Exception e) {
	        response.put("success", false);
	    }
	    return response;
	}

	// 수정
	@PostMapping("/researchEdit")
	@ResponseBody
	public ResponseEntity<Map<String, String>> editSurvey(
			@RequestPart(value = "surveyDTO", required = true) SurveyDTO surveyDTO, 
			@RequestParam(value = "existingFileIds", required = false) List<String> existingFileIds,
			@RequestPart(value = "file", required = false) List<MultipartFile> files, 
			BindingResult bindingResult, 
			HttpServletRequest request) {
	    Map<String, String> response = new HashMap<>();
	    System.out.println("수정을 위한 dto:" + surveyDTO);
	    System.out.println("수정을 위한 files: " + files);
	    System.out.println("수정을 위한 existingFileIds: " + existingFileIds);
	    if (bindingResult.hasErrors()) {
	        // 에러 처리 로직
	        response.put("msgForEdit", "validationError");
	        return ResponseEntity.badRequest().body(response);
	    }
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("loginUser") == null) {
	        // 로그인하지 않은 경우
	        response.put("msgForEdit", "loginRequired");
	        return ResponseEntity.ok(response);
	    } else {
	        Survey survey = convertToEntity(surveyDTO);
	        Member loginUser = (Member) session.getAttribute("loginUser");
	        survey.setCreator(loginUser.getUserId());
	        boolean isAdminOrCreator = loginUser.getAdminYn().equals("0") || loginUser.getUserId().equals(survey.getCreator());
	        
	        if (!isAdminOrCreator) { // 등록자가 아니라 수정 권한이 없는 경우
	            response.put("msgForEdit", "noAuthority");
	            return ResponseEntity.ok(response);
	        }
	        boolean editFlag;
	        if(existingFileIds != null && !existingFileIds.isEmpty()) {
	            List<Long> prev = existingFileIds.stream()
	                    .map(Long::parseLong)
	                    .collect(Collectors.toList());
	            editFlag = service.editSurvey(survey, 
	                    survey.getQuestions(), 
	                    extractOptionsList(survey.getQuestions()), 
	                    files, 
	                    prev);
	        } else {
	            editFlag = service.editSurvey(survey, 
	                    survey.getQuestions(), 
	                    extractOptionsList(survey.getQuestions()), 
	                    files, 
	                    Collections.emptyList());
	        }
            // 현재 로그인한 사용자가 관리자나 등록자이고, 설문이 예정 상태인 경우
            if (editFlag) {
                response.put("msgForEdit", "editSuccess");
            } else {
                response.put("msgForEdit", "editFailed");
            }
	        return ResponseEntity.ok(response);
	    }
	}
	
	// 삭제
	@PostMapping("/researchDelete")
	@ResponseBody
	public ResponseEntity<Map<String, String>> deleteSurvey(@RequestParam("surveyId") Long id,
			HttpServletRequest request, RedirectAttributes redirectAttributes) {
	    Map<String, String> response = new HashMap<>();
        System.out.println("/researchDelete?id=: "+id);
        Survey survey = service.findById(id);
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("loginUser") == null) {
            // 로그인하지 않은 경우
            response.put("msgForDelete", "loginRequired");
            return ResponseEntity.ok(response);
        } else {
            Member loginUser = (Member) session.getAttribute("loginUser");
            boolean isAdminOrCreator = loginUser.getAdminYn().equals("0") || loginUser.getUserId().equals(survey.getCreator());
            
            LocalDate currentDate = LocalDate.now();
            //boolean isSurveyActive = survey.getStartDate().isBefore(currentDate) && survey.getEndDate().isAfter(currentDate);
            boolean isSurveyActive = DateUtils.isSurveyActive(currentDate, survey.getStartDate(), survey.getEndDate());
            
            if (!isAdminOrCreator) { // 관리자나 등록자 본인 아닌 경우
                response.put("msgForDelete", "noAuthority");
                return ResponseEntity.ok(response);
            }
            if (isSurveyActive) { // 진행중 설문인 경우
                response.put("msgForDelete", "surveyOngoing");
                return ResponseEntity.ok(response);
            }
            // 충족 시 삭제
            boolean deleteFlag = service.deleteSurvey(id);
            if (deleteFlag) {
                response.put("msgForDelete", "deleteSuccess");
            } else {
                response.put("msgForDelete", "deleteFailed");
            }
            return ResponseEntity.ok(response);
        }
	}
	
	// 결과보기 팝업 페이지로 이동
	@GetMapping("/researchPopup")
	public String researchPopupPage(@RequestParam("id") Long id, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
		System.out.println("================/researchPopup?id="+id);
		
		HttpSession session = request.getSession(true);
        if (session.getAttribute("loginUser") == null) {
            // 로그인하지 않은 경우 로그인 페이지로 이동하고, 로그인하면 원래 가려던 "/particiation/pop"으로 이동
            session.setAttribute("redirectAfterLogin", "/researchPopup?id=" + id);
            return "redirect:/particiation/login";
        } else {
        	Survey survey = service.findById(id);
	    
		    List<SurveyResultOnlyDTO> results = service.selectSurveyResults(id);
		    List<Map<String, Object>> countPerOption = service.getResponsesPerOption(id);
		    // 모든 질문의 옵션 가져오기 (옵션id,questionId, optionText)
		    List<Map<String, Object>> options = service.getAllOptionsForSurvey(id); 
		    // 참여자수
		    int participants = service.getParticipantCount(id); 
		    
		    Gson gson = new Gson();
		    // List를 JSON 문자열로 변환
	        String results_json = gson.toJson(results);
	        String countPerOption_json = gson.toJson(countPerOption);
	        String options_json = gson.toJson(options); // 새로 추가한 것
	        
	        System.out.println("List<SurveyResultDTO>을 json으로!!!!!: "+results_json);
	        System.out.println("List<Map<String, Object>>을 json으로!!!!!: "+countPerOption_json);
		    
		    model.addAttribute("board", survey);
		    model.addAttribute("results", results_json);
		    model.addAttribute("responses", countPerOption_json);
		    model.addAttribute("options", options_json); // 옵션을 모델에 추가
		    model.addAttribute("participants", participants); // 참여자수
		    return "/particiation/pop"; // 결과를 보여줄 뷰의 이름
        }
	}
	
	// 사유전체보기 팝업 페이지로 이동
	@GetMapping("/researchChoiceReasonPopup")
	public void researchReasonPopupPage(@RequestParam("id") Long id, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
		System.out.println("================/researchPopup?id="+id);
		Survey survey = service.findById(id);
		// 참여자수
	    int participants = service.getParticipantCount(id); 
	    
	    List<SurveyResultOnlyDTO> results = service.selectSurveyResults(id);
	    List<Map<String, Object>> countPerOption = service.getResponsesPerOption(id);
	    Gson gson = new Gson();
	    // List를 JSON 문자열로 변환
        String results_json = gson.toJson(results);
        String countPerOption_json = gson.toJson(countPerOption);
        System.out.println("List<SurveyResultDTO>을 json으로!!!!!: "+results_json);
        System.out.println("List<Map<String, Object>>을 json으로!!!!!: "+countPerOption_json);
	    
	    model.addAttribute("board", survey);
	    model.addAttribute("results", results_json);
	    model.addAttribute("countPerOption", countPerOption_json);
	    model.addAttribute("participants", participants); // 참여자수
//	    return "/particiation/researchChoiceReasonPopup"; // 결과를 보여줄 뷰의 이름
	}
	
	/**
	 * 엑셀 다운로드
	 * @param request
	 * @param response
	 * @param model
	 * @param page
	 * @throws Exception
	 */
	@RequestMapping("/excelDownload")
	public void excelDownload(HttpServletRequest request, 
			HttpServletResponse response, 
			Model model,
			Page page
            )
			throws Exception {
		// 페이지 객체를 설정하여 검색 조건 반영

        System.out.println("페이지:"+page);
        
	    page.setSearchFlag(page.getCondition() != null && page.getKeyword() != null);
	    List<Survey> surveys = service.getExcelList(page);
	    Workbook workbook = service.createSurveyExcel(surveys);
		
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=surveyList.xlsx");

        workbook.write(response.getOutputStream());
        workbook.close();
		}
	
	// 결과팝업 클릭 시 -> 로그인 창 -> 로그인 안하고 끌 때 세션값 지우는 메서드
	@PostMapping("/removeRedirectAfterLogin")
    public void removeRedirectAfterLogin(HttpSession session) {
        session.removeAttribute("redirectAfterLogin");
    }
	
	
}



