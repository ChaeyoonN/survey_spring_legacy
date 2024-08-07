package com.spring.survey.service;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.mail.MessagingException;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.spring.survey.config.BatchConfig;
import com.spring.survey.dto.page.Page;
import com.spring.survey.dto.request.SurveyRegistRequestDTO;
import com.spring.survey.dto.request.SurveyResponseDTO;
import com.spring.survey.dto.request.SurveyResultOnlyDTO;
import com.spring.survey.dto.response.SurveyFileResponseDTO;
import com.spring.survey.dto.response.SurveyListDTO;
import com.spring.survey.dto.response.SurveyResultResponseDTO;
import com.spring.survey.entity.Member;
import com.spring.survey.entity.Option;
import com.spring.survey.entity.Question;
import com.spring.survey.entity.Survey;
import com.spring.survey.entity.SurveyFile;
import com.spring.survey.entity.SurveyResult;
import com.spring.survey.mapper.ISurveyMapper;
import com.spring.survey.utils.DateUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SurveyService implements ISurveyService {
	private final ISurveyMapper mapper;
	private final EmailService emailService;
	private final SmsService smsService;
	
	// 일반 글
	@Override
	public int getTotal(Page page) {
		return mapper.getTotal(page);
	}
	@Override
	public List<SurveyListDTO> getList(Page page) {
		List<Survey> list = mapper.getList(page);
		
		return convertToSurveyListDTO(list);
	}
	// 나의 글
	@Override
	public int getMyTotal(String userId, Page page) {
		return mapper.getMyTotal(userId, page);
	}
	@Override
	public List<SurveyListDTO> getMyList(String userId, Page page) {
		List<Survey> list = mapper.getMyList(userId, page);
		
		return convertToSurveyListDTO(list);
	}
	
	@Override
	public List<Survey> getExcelList(Page page) {
		List<Survey> list = mapper.getExcelList(page);
		
		return list;
	}
	
	@Override
	public List<SurveyListDTO> convertToSurveyListDTO(List<Survey> surveys) {
	    List<SurveyListDTO> surveyListDTOs = new ArrayList<>();
	    for (Survey survey : surveys) {
	        surveyListDTOs.add(new SurveyListDTO(
	            survey.getSurveyId(),
	            survey.getTitle(),
	            survey.getStartDate(),
	            survey.getEndDate(),
	            survey.getCreator()
	        ));
	    }
	    return surveyListDTOs;
	}


	@Override
	public void regist(SurveyRegistRequestDTO dto) {
		System.out.println("service: regist dto: "+dto);
//		mapper.regist(Survey.builder()
//						.surTitle(dto.getSurTitle())
//						.queCnt(dto.getQueCnt())
//						.surSatDate(dto.getSurSatDate())
//						.surEndDate(dto.getSurEndDate())
//						.writer(dto.getWriter())
//						.regName(dto.getRegName())
//						.udtName(dto.getUdtName())
//						.build());
		
	}
	
	@Override
	public void insertSurveyFile(SurveyFile surveyFile) {
		mapper.insertSurveyFile(surveyFile);
		
	}
	
	@Override
    public void createSurveyWithQuestionsAndOptions(Survey survey, List<Question> questions, List<List<Option>> optionsList
    		, HttpSession session, List<MultipartFile> files) throws Exception {
		// 현재 로그인한 사용자 정보 가져오기
		Member currentUser = (Member) session.getAttribute("loginUser");
		if(currentUser != null) {
			survey.setCreator(currentUser.getUserId());
		}
		mapper.createSurvey(survey);
        int questionIndex = 0;
        for (Question question : questions) {
        	question.setSurveyId(survey.getSurveyId());
            mapper.createQuestion(question);
            List<Option> options = optionsList.get(questionIndex++);
            for (Option option : options) {
            	option.setQuestionId(question.getQuestionId());
                mapper.createOption(option);
            }
        }
        // 설문에 첨부된 파일도 등록하기
        saveFiles(survey.getSurveyId(), files);
    }
	
	@Override
	 public void saveFiles(Long surveyId, List<MultipartFile> files) throws IOException {
        if (files == null || files.isEmpty()) return;

        Path dirPath = Paths.get("uploads");
        if (!Files.exists(dirPath)) {
        	try {
                Files.createDirectories(dirPath);
            } catch (IOException e) {
                throw new IOException("Failed to create directory for file uploads", e);
            }
        }

        for (MultipartFile file : files) {
            if (file.getSize() > 0) {
            	String fileName = StringUtils.cleanPath(file.getOriginalFilename());
	            // 파일 이름 처리 로직 추가
	            if (fileName.contains("..")) { // 디렉토리 트래버설 공격 예방
	                throw new IOException("Invalid file path sequence in file name: " + fileName);
	            }
	            String uniqueFileName = System.currentTimeMillis() + "_" + fileName; // 파일명 유니크하게 변경
	            
	            // 파일 저장
	            Path filePath = dirPath.resolve(uniqueFileName); // 파일의 전체 경로를 생성
	            try (InputStream inputStream = file.getInputStream()) {
	                Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
	            } catch (IOException e) {
	                throw new IOException("Failed to save file: " + fileName, e);
	            }
	
	            // DB에 파일 정보 저장
	            SurveyFile surveyFile = new SurveyFile();
	            surveyFile.setSurveyId(surveyId);
	            surveyFile.setFileName(uniqueFileName);
	            surveyFile.setOriginFileName(fileName);
	            surveyFile.setFilePath(filePath.toString());
	            surveyFile.setFileSize(file.getSize());
	            System.out.println("SurveyFile: "+surveyFile);
	
	            try {
	                mapper.insertSurveyFile(surveyFile);
	            } catch (Exception e) {
	                throw new IOException("Failed to insert file information into the database", e);
	            }
            }
         	
        }
    }
	
	// 수정
	@Override
	@Transactional
	public boolean editSurvey(Survey survey, 
			List<Question> questions, 
			List<List<Option>> extractOptionsList,
			List<MultipartFile> files,
			List<Long> existingFileIds) {
	    // 1. 기존 설문 결과 삭제
	    mapper.deleteSurveyResultBySurveyId(survey.getSurveyId());
	    // 2. 기존 옵션 삭제
	    mapper.deleteSurveyOptionsBySurveyId(survey.getSurveyId());
	    // 3. 기존 질문 삭제
	    mapper.deleteSurveyQuestionsBySurveyId(survey.getSurveyId());
	    
	    // 4. 설문 정보 업데이트
	    if (mapper.updateSurvey(survey) == 0) {
	        // 업데이트 실패 시 false 반환
	        return false;
	    }
	    
	    // 5. 새로운 질문 및 옵션 삽입
	    for (int questionIndex = 0; questionIndex < questions.size(); questionIndex++) {
	        Question question = questions.get(questionIndex);
	        question.setSurveyId(survey.getSurveyId()); // 설문 ID 설정
	        if (mapper.createQuestion(question) == 0) {
	            // 질문 생성 실패 시 false 반환
	            return false;
	        }
	        
	        List<Option> options = extractOptionsList.get(questionIndex);
	        for (Option option : options) {
	            option.setQuestionId(question.getQuestionId()); // 질문 ID 설정
	            if (mapper.createOption(option) == 0) {
	                // 옵션 생성 실패 시 false 반환
	                return false;
	            }
	        }
	    }
	    // 6. 첨부파일 업데이트 (삭제 및 등록)
	    try {
	    	// 기존 파일 유지 및 새 파일 저장
	        if (files != null && !files.isEmpty() && files.stream().anyMatch(file -> file.getSize() > 0)) {
	        	deleteFiles(survey.getSurveyId(), existingFileIds);
	            saveFiles(survey.getSurveyId(), files);
	        } else { // 새로 등록할 첨부파일 존재하지 않음
	        	deleteFiles(survey.getSurveyId(), existingFileIds);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	    
	    // 모든 과정이 성공적으로 완료되면 true 반환
	    return true;
	}

	@Override
	public Member findByUserId(String userId) {
		return mapper.findByUserId(userId);
	}

	@Override
	@Transactional
	public void insertPw(String userId, String secretPw) {
//		Member member = mapper.findByUserId(userId);
//		member.setPassword(secretPw);
		Map<String, String> params = new HashMap<>();
	    params.put("userId", userId);
	    params.put("secretPw", secretPw);
	    mapper.insertPw(params);
	}

	@Override
	public  Survey findById(Long surveyId) {
		// ID를 사용하여 설문조사 찾기
        return mapper.findById(surveyId).orElseThrow();
	}
	@Override
	public  List<SurveyFile> filesBySurveyId(Long surveyId) {
		// ID를 사용하여 설문조사에 첨부된 첨부파일 찾기
        return mapper.filesBySurveyId(surveyId);
	}
	
	// 첨부파일 삭제 (저장공간 및 디비에서 삭제)
	private void deleteFiles(Long surveyId, List<Long> existingFileIds) {
	    // 데이터베이스에서 해당 설문조사와 연관된 모든 파일 정보 조회
	    List<SurveyFile> surveyFiles = mapper.filesBySurveyId(surveyId);

	    // 파일 삭제 대상 선정
	    List<SurveyFile> filesToDelete;
	    if (existingFileIds == null || existingFileIds.isEmpty()) {
	        // 기존 파일 ID 목록이 없으면 모든 파일을 삭제 대상으로 함
	        filesToDelete = surveyFiles;
	        // 데이터베이스에서 해당 설문조사의 모든 파일 정보 삭제
	        mapper.deleteFileBySurveyId(surveyId);
	    } else {
	        // 기존 파일 ID 목록이 있으면 해당 파일들을 제외한 나머지를 삭제 대상으로 함
	        filesToDelete = surveyFiles.stream()
	                .filter(file -> !existingFileIds.contains(file.getFileId()))
	                .collect(Collectors.toList());
	        // 데이터베이스에서 해당 파일들만 제외하고 삭제
	        mapper.deleteFilesExcept(surveyId, existingFileIds);
	    }

	    // 실제 파일 시스템에서 삭제 대상 파일들을 삭제
	    for (SurveyFile file : filesToDelete) {
	        Path path = Paths.get(file.getFilePath());
	        try {
	            Files.deleteIfExists(path);
	        } catch (IOException e) {
	            // 파일 삭제 실패 예외 처리. 실패 로그를 남기고 계속 진행할 수 있다.
	            e.printStackTrace();
	        }
	    }
	}
	
	// 삭제
	@Override
	@Transactional
	public boolean deleteSurvey(Long surveyId) {
	    // 데이터베이스에서 해당 설문조사와 연관된 파일 정보 조회
	    List<SurveyFile> surveyFiles = mapper.filesBySurveyId(surveyId);
	    
	    for (SurveyFile surveyFile : surveyFiles) {
	        Path path = Paths.get(surveyFile.getFilePath());
	        // 실제 파일 시스템에서 파일 삭제
	        try {
	            Files.deleteIfExists(path);
	        } catch (IOException e) {
	            // 파일 삭제 실패 예외를 던짐
	            throw new RuntimeException("Failed to delete file: " + path, e);
	        }
	        // 데이터베이스에서 파일 정보 삭제
	        mapper.deleteFileByFileId(surveyFile.getFileId());
	    }
	    
	    // survey_result, survey_option, survey_question, survey 삭제
	    mapper.deleteSurveyResultBySurveyId(surveyId);
	    mapper.deleteSurveyOptionsBySurveyId(surveyId);
	    mapper.deleteSurveyQuestionsBySurveyId(surveyId);
	    int countSurveyDeleted = mapper.deleteSurveyById(surveyId);
	    if(countSurveyDeleted > 0) {
	        return true;
	    } else {
	        // 설문 삭제 실패 예외
	        throw new RuntimeException("Failed to delete survey");
	    }
	}

	// 설문 응답 등록
	@Override
	public void saveSurveyResults(SurveyResponseDTO surveyResponseDTO, String userId) {
        for (SurveyResponseDTO.QuestionResponseDTO questionResponse : surveyResponseDTO.getQuestions()) {
            SurveyResult surveyResult = new SurveyResult();
            surveyResult.setSurveyId(surveyResponseDTO.getSurveyId());
            surveyResult.setQuestionId(questionResponse.getQuestionId());
            surveyResult.setSelOptionNum(questionResponse.getSelOptionNum()); // 선택옵션 순번
            surveyResult.setReason(questionResponse.getReason());
            surveyResult.setUserId(userId);
            // surveyResult.setOptionId 에는 SelOptionNum번째 optionId 넣기
            int selOptionNum = questionResponse.getSelOptionNum().intValue(); // 선택옵션 순번을 int로 변환
            if (selOptionNum > 0 && selOptionNum <= questionResponse.getOptions().size()) {
                surveyResult.setOptionId(questionResponse.getOptions().get(selOptionNum - 1).getOptionId());
            } else {
                throw new IllegalArgumentException("선택옵션 순번이 옵션의 범위를 벗어났습니다.");
            }
            mapper.insertSurveyResult(surveyResult);
        }
	}

	// 응답 등록 전 응답 이력 확인
	@Override
	public boolean hasUserParticipated(Long id, String userId) {
	    Map<String, Object> p = new HashMap<>();
	    p.put("surveyId", id);
	    p.put("userId", userId);
	    return mapper.hasUserParticipated(p);
	}
	/********* 설문 결과 ************/
	// 설문 결과만 조회
	@Override
	public List<SurveyResultOnlyDTO> selectSurveyResults(Long surveyId) {
		List<SurveyResult> resultList = mapper.selectSurveyResults(surveyId);
		   return resultList.stream()
                   .map(result -> new SurveyResultOnlyDTO(result))
                   .collect(Collectors.toList());
    }
	// 설문 질문별 옵션 응답 수 집계
	@Override
    public List<Map<String, Object>> getResponsesPerOption(Long surveyId) {
        return mapper.countResponsesPerOption(surveyId);
    }
	@Override
	public List<Map<String, Object>> getResponsesByQuestion(Long surveyId) {
		return mapper.countResponsesByQuestion(surveyId);
	}
    
	// 설문 결과 
	@Override
	public SurveyResultResponseDTO getSurveyResults(Long id) {
	    Survey survey = findById(id);
	    
	    //new SurveyResultResponseDTO(survey, mapper.getSurveyResults(id).getResults());
	    return mapper.getSurveyResults(id);
	}

	// 설문의 모든 질문에 대한 옵션 얻기
	@Override
	public List<Map<String, Object>> getAllOptionsForSurvey(Long surveyId) {
		return mapper.selectAllOptionsForSurvey(surveyId);
	}

	// 설문의 참여자수 조회
	@Override
	public int getParticipantCount(Long surveyId) {
		return mapper.getParticipantCount(surveyId);
	}

	/** 파일 다운로드 **/
	@Override
	public SurveyFileResponseDTO getFile(Long fileId) {
		return mapper.findByFileId(fileId);
	}

	@Override
	public List<Object> listExcelDownload() {
		// TODO Auto-generated method stub
		return null;
	}
	/** 엑셀 다운로드 **/
	@Override
	public Workbook createSurveyExcel(List<Survey> surveys) {
	    
		System.out.println("======데이터길이: "+surveys.size());
		 LocalDate currentDate = LocalDate.now(); // 현재 날짜 가져오기

	        Workbook workbook = new XSSFWorkbook();
	        Sheet sheet = workbook.createSheet("Survey List");
	        CellStyle style = workbook.createCellStyle(); // 셀 스타일을 위한 변수
			style.setAlignment(CellStyle.ALIGN_CENTER); // 글 위치를 중앙으로 설정
			
			// 굵은 글씨를 위한 폰트 객체 생성 및 설정
			CellStyle titleStyle = workbook.createCellStyle();
			Font titleFont = workbook.createFont();
			titleFont.setBold(true); // 글씨를 굵게 설정
			titleStyle.setFont(titleFont); // 폰트를 스타일에 적용
			titleStyle.setAlignment(CellStyle.ALIGN_CENTER); // 중앙 정렬
			
			// 날짜 형식 설정
		    CreationHelper createHelper = workbook.getCreationHelper();
		    CellStyle dateStyle = workbook.createCellStyle();
		    dateStyle.setDataFormat(createHelper.createDataFormat().getFormat("yyyy-mm-dd"));
			dateStyle.setAlignment(CellStyle.ALIGN_CENTER); // 날짜도 중앙 정렬
		    
			sheet.setColumnWidth(0,1000);
			sheet.setColumnWidth(1,8000);
			sheet.setColumnWidth(2,4000);
			sheet.setColumnWidth(3,4000);
	        int rowNum = 0;
	        Row row = sheet.createRow(rowNum++);
	        // 헤더 행의 각 셀 생성 및 스타일 적용
	        Cell cell = row.createCell(0);
	        cell.setCellValue("NO");
	        cell.setCellStyle(titleStyle);

	        cell = row.createCell(1);
	        cell.setCellValue("제목");
	        cell.setCellStyle(titleStyle);

	        cell = row.createCell(2);
	        cell.setCellValue("시작일");
	        cell.setCellStyle(titleStyle);

	        cell = row.createCell(3);
	        cell.setCellValue("마감일");
	        cell.setCellStyle(titleStyle);

	        cell = row.createCell(4);
	        cell.setCellValue("완료여부");
	        cell.setCellStyle(titleStyle);
	        // 다른 필드 추가...

	        for (Survey survey : surveys) {
	            row = sheet.createRow(rowNum++);
	            
	            Cell numCell = row.createCell(0);
	            // 내림차순 번호 할당: 총 개수에서 현재 행 번호를 뺀 값으로 설정
	            numCell.setCellValue(surveys.size() - rowNum + 2);
	            numCell.setCellStyle(style); // 번호 셀에 스타일 적용
	            
	            row.createCell(1).setCellValue(survey.getTitle());
	            
	            Cell startDateCell = row.createCell(2);
	            row.createCell(2).setCellValue(Date.valueOf(survey.getStartDate()));
	            startDateCell.setCellStyle(dateStyle); // 날짜 형식 스타일 적용
	            
	            Cell endDateCell = row.createCell(3);
	            row.createCell(3).setCellValue(Date.valueOf(survey.getEndDate()));
	            endDateCell.setCellStyle(dateStyle); // 날짜 형식 스타일 적용
	            
	            // 완료여부 판단 및 셀 설정
	            Cell statusCell = row.createCell(4);
	            String status;
	            if (currentDate.isAfter(survey.getEndDate())) {
	                status = "완료";
	            } else if (currentDate.isBefore(survey.getStartDate())) {
	                status = "진행예정";
	            } else {
	                status = "진행중";
	            }
	            statusCell.setCellValue(status);
	            statusCell.setCellStyle(style); // 완료여부 셀에 스타일 적용
	            // 다른 필드 값 설정...
	        }

	        return workbook;
	}
	/** 이메일, sms 발송 **/
    public void sendCompletionEmailsIfSurveyEnded(Long surveyId, LocalDate stDate, LocalDate endDate) {
        LocalDate currentDate = LocalDate.now();
        
        // 설문 종료 여부 확인 및 이메일 발송 여부 확인
        if (DateUtils.isSurveyOutsidePeriod(currentDate, stDate, endDate) && mapper.checkEmailSentStatus(surveyId).equals("0")) {
            // 설문에 참여한 회원들의 전화번호, 이메일 주소 조회
            List<Member> memList = mapper.findPhoneEmailBySurveyId(surveyId);
            System.out.println("==== 참가자 전번,이메일 리스트: "+memList+" ====");
            Survey survey = mapper.findById(surveyId).orElseThrow();
            // 설문 제목이 10자를 초과하는 경우 말줄임표 처리
            String surveyTitle = survey.getTitle();
            String trimmedTitle = surveyTitle.length() > 10 ? surveyTitle.substring(0, 10) + "..." : surveyTitle;
            
            // 이메일 발송
            for (Member member : memList) {
            	String email = member.getEmail();
            	String phone = member.getPhone();
            	String emailSubject = String.format("[%s] 설문 조사 완료", trimmedTitle);
            	String smsContent = String.format("'%s' 설문 조사가 완료되었습니다. 참여해주셔서 감사합니다.", surveyTitle);
            	String emailContent = String.format(
            		    "<body style='font-family: Arial, sans-serif; background-color: #f5f5f5; text-align: center; padding: 20px;'>"
            		    + "<div style='background-image: url(\"https://gongu.copyright.or.kr/gongu/wrt/cmmn/wrtFileImageView.do?wrtSn=13221558&filePath=L2Rpc2sxL25ld2RhdGEvMjAxOS8yMS9DTFMxMDAwNC8xMzIyMTU1OF9XUlRfMjAxOTExMjFfMQ==&thumbAt=Y&thumbSe=b_tbumb&wrtTy=10004\"); background-repeat: no-repeat; background-size: cover; background-position: center; border-radius: 8px; padding: 20px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); max-width: 600px; margin: 0 auto;'>"
            		    + "    <div style='background-color: rgba(255, 255, 255, 0.8); border-radius: 8px; padding: 20px;'>"
            		    + "        <h3 style='color: #333;'>안녕하세요, '%s'님</h3>"
            		    + "        <p style='color: #666; margin-bottom: 20px;'> '%s' 설문조사가 완료되었습니다.</p>"
            		    + "        <p style='color: #666; margin-bottom: 20px;'>참여해 주셔서 감사합니다.</p>"
            		    + "        <a href='http://192.168.123.12:8080/particiation/researchPopup?id=%d'>"
            		    + "            <button type='button' style='background-color: #FC5230; color: white; padding: 10px 20px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px; margin-top: 20px; border-radius: 4px; cursor: pointer; border: none;'>결과 보러가기</button>"
            		    + "        </a>"
            		    + "    </div>"
            		    + "</div></body>",
            		    member.getUserId(), surveyTitle, surveyId
            		);
            	try {
					emailService.sendEmail(member.getEmail(), emailSubject, emailContent); // 이메일 발송
				} catch (UnsupportedEncodingException | MessagingException e) {
					e.printStackTrace();
				}
            	// smsService.sendSms(phone, smsContent); // sms 발송
            }
            
            // 이메일 발송 여부 업데이트
            mapper.updateEmailSentStatus(surveyId, "1");
        }
    }
    
    //@Scheduled(cron = "0 0 12 * * ?") // 매일 정오에 실행
    @Scheduled(cron = "0 */5 * * * *") // 매 5분마다 실행
    public void checkAndSendCompletionEmails() {
        // 모든 설문에 대해 종료 여부를 확인하고 이메일을 발송.
        List<Survey> surveys = mapper.selectAllSurveys(); // 모든 설문을 조회
        
        // 각 설문에 대해 이메일 발송 여부 결정
        for (Survey survey : surveys) {
            sendCompletionEmailsIfSurveyEnded(survey.getSurveyId(), survey.getStartDate(), survey.getEndDate());
        }
        //emailService.sendEmail("cynam@credif.co.kr", "제목이다.", "내용이다.");
    	
    }
    
	
}



