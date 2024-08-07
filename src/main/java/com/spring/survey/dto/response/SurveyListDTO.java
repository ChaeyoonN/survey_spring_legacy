package com.spring.survey.dto.response;

import java.time.LocalDate;

import com.spring.survey.entity.Survey;
import com.spring.survey.utils.DateUtils;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SurveyListDTO {
    private Long surveyId;
    private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private String creator;

    public SurveyListDTO(Long surveyId, String title, LocalDate startDate, LocalDate endDate, String creator) {
        this.surveyId = surveyId;
        this.title = title;
        this.startDate = startDate;
        this.endDate = endDate;
        this.creator = creator;
    }

	public SurveyListDTO(Survey survey) {
        this.surveyId = survey.getSurveyId();
        this.title = survey.getTitle();
        this.startDate = survey.getStartDate();
        this.endDate = survey.getEndDate();
        this.creator = survey.getCreator();
	}

    // 필요에 따라 추가 생성자 및 메소드 구현
    public boolean isSurveyActive(LocalDate currentDate) {
        return DateUtils.isAfterOrEqual(currentDate, this.startDate) && DateUtils.isBeforeOrEqual(currentDate, this.endDate);
    }
}
