package com.spring.survey.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.web.multipart.MultipartFile;

import com.spring.survey.dto.page.Page;
import com.spring.survey.dto.request.SurveyRegistRequestDTO;
import com.spring.survey.dto.request.SurveyResponseDTO;
import com.spring.survey.dto.request.SurveyResultOnlyDTO;
import com.spring.survey.dto.response.SurveyFileResponseDTO;
import com.spring.survey.dto.response.SurveyListDTO;
import com.spring.survey.dto.response.SurveyRegistResponseDTO;
import com.spring.survey.dto.response.SurveyResultResponseDTO;
import com.spring.survey.entity.Member;
import com.spring.survey.entity.Option;
import com.spring.survey.entity.Question;
import com.spring.survey.entity.Survey;
import com.spring.survey.entity.SurveyFile;

public interface ISurveyService {
	//글 등록
	void regist(SurveyRegistRequestDTO dto);
	
//	void regist(String writer, String password, String title, String content, List<MultipartFile> files);
//	void registFile(List<MultipartFile> list);
	void createSurveyWithQuestionsAndOptions(Survey survey, 
											List<Question> questions, 
											List<List<Option>> optionsList,
											HttpSession httpSession, 
											List<MultipartFile> files) throws Exception;
	
	void insertSurveyFile(SurveyFile surveyFile);
	void saveFiles(Long surveyId, List<MultipartFile> files) throws IOException;
	
	// 총 게시물 개수
	int getTotal(Page page);
	// 목록
	List<SurveyListDTO> getList(Page page);

	List<SurveyListDTO> convertToSurveyListDTO(List<Survey> surveys);

	// 로그인 시 아이디로 회원정보 조회
	Member findByUserId(String userId);
	// 비번 암호화해서 넣는 메서드
	void insertPw(String userId, String secretPw);

	// 상세 보기 위한 id로 설문 찾기
	Survey findById(Long surveyId);
	// 상세 보기 위한 설문id로 file들 찾기
	List<SurveyFile> filesBySurveyId(Long surveyId);

	// 삭제
	boolean deleteSurvey(Long surveyId);
	

	// 수정
	boolean editSurvey(Survey survey, 
			List<Question> questions, 
			List<List<Option>> extractOptionsList, 
			List<MultipartFile> files,
			List<Long> existingFileIds);

	// 설문 응답 등록
	void saveSurveyResults(SurveyResponseDTO surveyResponseDTO, String userId);

	// 설문 응답 등록 전 응답이력 확인
	boolean hasUserParticipated(Long surveyId, String userId);

	// 설문 결과만 조회
	List<SurveyResultOnlyDTO> selectSurveyResults(Long surveyId);
	// 설문 질문별 옵션 응답 수 집계
	List<Map<String, Object>> getResponsesPerOption(Long surveyId);
	List<Map<String, Object>> getResponsesByQuestion(Long surveyId);
	
	// 설문 결과 함께 조회
	SurveyResultResponseDTO getSurveyResults(Long surveyId);
	
	// 설문의 모든 질문의 옵션 얻기
	List<Map<String, Object>> getAllOptionsForSurvey(Long surveyId);
	//상세보기
	//FreeContentResponseDTO getContent(int bno);

	// 설문의 참여자수 얻기
	int getParticipantCount(Long surveyId);

	// 파일 다운로드
	SurveyFileResponseDTO getFile(Long fileId);
	// 엑셀 다운로드
	List<Object> listExcelDownload();
	
	List<Survey> getExcelList(Page page);

	Workbook createSurveyExcel(List<Survey> surveys);

	// 나의 설문
	int getMyTotal(String userId, Page page);
	List<SurveyListDTO> getMyList(String userId, Page page);
}



