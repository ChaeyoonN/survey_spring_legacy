package com.spring.survey.entity;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;
/**
 * CREATE TABLE Survey_Result (
	result_id NUMBER PRIMARY KEY,
    survey_id NUMBER,
    question_id NUMBER, -- 문제번호 (survey_question테이블의 question_id fk)
    option_id NUMBER, -- 옵션번호 (옵션테이블의 옵션아이디 fk)
    sel_option_num NUMBER, -- 선택한 옵션의 순번 (1~5)
    reason VARCHAR2(255),  -- 선택 사유
    user_id VARCHAR2(50 BYTE),
    response_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (survey_id) REFERENCES Survey(survey_id),
    FOREIGN KEY (question_id) REFERENCES survey_Question(question_id),
    FOREIGN KEY (option_id) REFERENCES survey_Option(option_id),
    FOREIGN KEY (user_id) REFERENCES TB_00_MEMBER(USER_ID)
	);

 * CREATE SEQUENCE result_seq START WITH 1;
 */
@Getter
@Setter
@ToString
//@RequiredArgsConstructor // 초기화 되지않은 final 필드나, @NonNull 이 붙은 필드에 대해 생성자를 생성
@NoArgsConstructor
@AllArgsConstructor
@Alias("survey_result")
public class SurveyResult {
    private Long resultId; // pk
    private Long surveyId; // fk
    private Long questionId; // fk
    private Long optionId; // fk
    private Long selOptionNum; // 응답자가 선택한 문제당 옵션순번
    private String reason; // 선택사유
    private String userId; // fk
    private Date responseDate;
}



