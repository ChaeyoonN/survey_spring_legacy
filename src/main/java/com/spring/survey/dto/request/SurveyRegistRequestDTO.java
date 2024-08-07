package com.spring.survey.dto.request;

import java.time.LocalDateTime;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter
@ToString @EqualsAndHashCode
@NoArgsConstructor
@AllArgsConstructor
public class SurveyRegistRequestDTO {
    // 제목
    private String surTitle;
    
    // 문제수
    private String queCnt;
    
    // 설문시작일자
    private LocalDateTime surSatDate;
    
    // 설문종료일자
    private LocalDateTime surEndDate;
    
    // 작성자
    private String writer;
    
    // 등록자
    private String regName;
    
    // 수정자
    private String udtName;
}
