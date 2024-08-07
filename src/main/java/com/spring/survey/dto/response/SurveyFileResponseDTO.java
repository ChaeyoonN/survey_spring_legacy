package com.spring.survey.dto.response;

import com.spring.survey.entity.SurveyFile;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
/**
 * argument type mismatch의 원인: MyBatis로 DB에 접근해서 객체로 리턴 받으려는 경우에 이와 같은 에러가 발생했다면 매핑을 시도하려는 클래스에 기본 생성자가 선언이 되어 있는지 확인 !
 */
public class SurveyFileResponseDTO {
	private Long fileId;
	private Long surveyId;
	private String fileName;
	private String filePath;
	private Long fileSize;
	private String originFileName;
	
	public SurveyFileResponseDTO(SurveyFile surveyFile) {
        this.fileId = surveyFile.getFileId();
		this.surveyId = surveyFile.getSurveyId();
        this.fileName = surveyFile.getFileName();
        this.filePath = surveyFile.getFilePath();
        this.fileSize = surveyFile.getFileSize();
        this.originFileName = surveyFile.getOriginFileName();
    }
	
	
}


