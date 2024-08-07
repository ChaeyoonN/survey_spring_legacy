package com.spring.survey.dto.request;

import java.util.Date;

import com.spring.survey.entity.SurveyResult;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SurveyResultOnlyDTO {
    
    private Long resultId;
    private Long surveyId;
    private Long questionId;
    private Long optionId;
    private Long selOptionNum;
    private String reason;
    private String userId;
    private Date responseDate;

    // 기본 생성자
    public SurveyResultOnlyDTO() {}
    
    // 모든 필드를 포함한 생성자
    public SurveyResultOnlyDTO(Long resultId, Long surveyId, Long questionId, Long optionId, Long selOptionNum, String reason, String userId, Date responseDate) {
        this.resultId = resultId;
        this.surveyId = surveyId;
        this.questionId = questionId;
        this.optionId = optionId;
        this.selOptionNum = selOptionNum;
        this.reason = reason;
        this.userId = userId;
        this.responseDate = responseDate;
    }

	public SurveyResultOnlyDTO(SurveyResult result) {
		this.resultId = result.getResultId();
        this.surveyId = result.getSurveyId();
        this.questionId = result.getQuestionId();
        this.optionId = result.getOptionId();
        this.selOptionNum = result.getSelOptionNum();
        this.reason = result.getReason();
        this.userId = result.getUserId();
        this.responseDate = result.getResponseDate();
	}

}


