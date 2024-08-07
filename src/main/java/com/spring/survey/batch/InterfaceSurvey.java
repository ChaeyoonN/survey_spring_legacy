package com.spring.survey.batch;

import java.time.LocalDate;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("Interface_Survey")
public class InterfaceSurvey {
	private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private String creator;
}
