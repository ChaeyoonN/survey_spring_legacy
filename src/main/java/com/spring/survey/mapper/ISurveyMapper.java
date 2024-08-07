package com.spring.survey.mapper;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.survey.dto.page.Page;
import com.spring.survey.dto.response.SurveyFileResponseDTO;
import com.spring.survey.dto.response.SurveyResultResponseDTO;
import com.spring.survey.entity.InterMember;
import com.spring.survey.entity.Member;
import com.spring.survey.entity.Option;
import com.spring.survey.entity.Question;
import com.spring.survey.entity.Survey;
import com.spring.survey.entity.SurveyFile;
import com.spring.survey.entity.SurveyResult;
@Mapper
public interface ISurveyMapper {
	/**
	 * MyBatis의 매퍼 인터페이스 메소드의 리턴 타입을 int로 설정하면, 
	 * 해당 메소드가 실행된 후 영향을 받은 행(row)의 개수가 리턴된다. 
	 * 이는 등록, 삭제, 수정 작업에 모두 적용된다. 
	 * 예를 들어, update, delete, insert 메소드가 성공적으로 실행되면, 
	 * 해당 SQL 문에 의해 영향을 받은 행의 수가 반환됨.
	 */
	//글 등록
	int regist(Survey Survey);
	void insertFile(Map<String, Object> fileMap);
	
    void createSurvey(Survey survey);
    int createQuestion(Question question);
    int createOption(Option option);
    
    // 첨부파일 등록
    void insertSurveyFile(SurveyFile surveyFile);
	
	//글 목록
	List<Survey> getList(Page page);
	
	//총 게시물 개수 구하기
	int getTotal(Page page);
	
	//아이디로 회원정보 조회
	Member findByUserId(String userId);
	// 특정 설문의 등록자 아닌 회원 조회
	List<Member> findAllExceptCreator(String userId);
	// 아이디에 따른 회원의 비번을 암호화해서 디비에 넣기
	void insertPw(Map<String, String> map);
	
	// 글 상세보기: id로 설문 얻기
	Optional<Survey> findById(Long surveyId);
	List<SurveyFile> filesBySurveyId(Long surveyId);
	
	// 파일 다운로드
	SurveyFileResponseDTO findByFileId(Long fileId);
	
	// 글 삭제
    int deleteSurveyResultBySurveyId(Long surveyId); // 설문 결과 삭제
    int deleteSurveyOptionsBySurveyId(Long surveyId);
    int deleteSurveyQuestionsBySurveyId(Long surveyId);
    int deleteSurveyById(Long surveyId);
    
    // 첨부파일 삭제
    int deleteFileBySurveyId(Long surveyId);
    int deleteFileByFileId(Long fileId);
    
    // 기존 파일 ID 목록이 있으면 해당 파일들만 제외하고 삭제
    void deleteFilesExcept(@Param("surveyId") Long surveyId, 
    		@Param("existingFileIds") List<Long> existingFileIds);
	
    // 글 수정
    int updateSurvey(Survey survey);
    
    // 설문 응답 등록
	void insertSurveyResult(SurveyResult surveyResult);
	
	// 설문 응답 등록 전 응답 이력 조회
	boolean hasUserParticipated(Map<String, Object> params);
	
	// 설문 결과 조회
	SurveyResultResponseDTO getSurveyResults(Long surveyId);
	
	// 설문 결과만 조회
	List<SurveyResult> selectSurveyResults(Long surveyId);
	
	// 설문 질문별 옵션 응답 수 집계 : 각 행을 <Map<String, Object>>로 리스트로 만들어줌.
	/**
	 * @param surveyId
	 * @return
	 * [
	    {"surveyId": 1, "questionId": 1, "optionId": 1, "responseCount": 10},
	    {"surveyId": 1, "questionId": 1, "optionId": 2, "responseCount": 20},
	    ...
		]
	 */
	List<Map<String, Object>> countResponsesPerOption(Long surveyId);
	List<Map<String, Object>> countResponsesByQuestion(Long surveyId);
	
	// 설문의 모든 질문의 옵션 얻기
	List<Map<String, Object>> selectAllOptionsForSurvey(Long surveyId);
	// 특정 설문의 참여자수 얻기
	int getParticipantCount(Long surveyId);
	
	// 엑셀 다운로드 위한 조회
	List<Survey> selectAllSurveys();
	List<Survey> getExcelList(Page page);
	
	// 설문에 참여한 회원들의 이메일 주소 조회
	List<Member> findPhoneEmailBySurveyId(Long surveyId);
	/**
     * 이메일 발송 여부를 업데이트.
     * @param surveyId 설문조사의 ID
     * @param finEmailSent 이메일 발송 여부 ('0'은 미발송, '1'은 발송)
     */
    void updateEmailSentStatus(@Param("surveyId") Long surveyId, @Param("finEmailSent") String finEmailSent);
    
    /**
     * 특정 설문조사의 이메일 발송 여부를 조회.
     * @param surveyId 설문조사의 ID
     * @return 이메일 발송 여부 ('0'은 미발송, '1'은 발송)
     */
    String checkEmailSentStatus(@Param("surveyId") Long surveyId);
    
    // spring batch
    List<Member> selectAllMembers();
    // 인터페이스 멤버 테이블 쿼리
    List<Member> selectAllInterfaceMembers();
    int insertMember(Member member);
    int updateMember(Member member);
    void deleteAllMember();
    void deleteMember(Member member);
    List<Member> selectMembersInTb00();
    List<Member> selectMembersNotInTb00();
    
    // 나의 설문 조회
    int getMyTotal(@Param("userId") String userId, @Param("page") Page page);
    List<Survey> getMyList(@Param("userId") String userId, @Param("page") Page page);
    
    
}
