package com.spring.survey.entity;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Alias("survey_file")
public class SurveyFile {
	private Long fileId;
	private Long surveyId;
    private String fileName;
    private String filePath;
    private Long fileSize;
    private Date createdAt;
    private String originFileName;
}
