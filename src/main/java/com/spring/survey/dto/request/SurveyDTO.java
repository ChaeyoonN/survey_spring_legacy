package com.spring.survey.dto.request;

import java.util.List;

import lombok.Data;

@Data
public class SurveyDTO {
    private Long surveyId;
    private String title;
    private String startDate;
    private String endDate;
    private List<QuestionDTO> questions;
}

