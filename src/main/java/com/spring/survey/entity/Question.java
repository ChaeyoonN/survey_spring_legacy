package com.spring.survey.entity;

import java.util.List;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("survey_question")
public class Question {
    private Long questionId;
    private Long surveyId;
    private String questionText;
    private List<Option> options;
}
