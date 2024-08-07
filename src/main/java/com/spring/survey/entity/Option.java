package com.spring.survey.entity;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("survey_option")
public class Option {
    private Long optionId;
    private Long questionId;
    private String optionText;
}
