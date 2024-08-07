package com.spring.survey.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.Date;

import org.apache.ibatis.type.Alias;
/**
 *   CREATE TABLE "TB_06_RSR" 
   (	"SURR_SEQ" VARCHAR2(8 BYTE), 
	"SUR_SEQ" VARCHAR2(8 BYTE), 
	"SURQ_SEQ" VARCHAR2(8 BYTE), 
	"SURI_SEQ" VARCHAR2(8 BYTE), 
	"SURI_NUM" VARCHAR2(250 BYTE), 
	"DESCRIPTION" VARCHAR2(200 BYTE), 
	"WRITER" VARCHAR2(50 BYTE), 
	"REG_NAME" VARCHAR2(8 BYTE), 
	"REG_DATE" DATE, 
	"UDT_NAME" VARCHAR2(8 BYTE), 
	"UDT_DATE" DATE, 
	"SURQ_TITLE" VARCHAR2(250 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "TB_06_RSR"."SURR_SEQ" IS '설문결과번호';
   COMMENT ON COLUMN "TB_06_RSR"."SUR_SEQ" IS '설문번호';
   COMMENT ON COLUMN "TB_06_RSR"."SURQ_SEQ" IS '문제번호';
   COMMENT ON COLUMN "TB_06_RSR"."SURI_SEQ" IS '문항번호';
   COMMENT ON COLUMN "TB_06_RSR"."SURI_NUM" IS '선택문항';
   COMMENT ON COLUMN "TB_06_RSR"."DESCRIPTION" IS '선택사유';
   COMMENT ON COLUMN "TB_06_RSR"."WRITER" IS '작성자';
   COMMENT ON COLUMN "TB_06_RSR"."REG_NAME" IS '등록자';
   COMMENT ON COLUMN "TB_06_RSR"."REG_DATE" IS '등록일';
   COMMENT ON COLUMN "TB_06_RSR"."UDT_NAME" IS '수정자';
   COMMENT ON COLUMN "TB_06_RSR"."UDT_DATE" IS '수정일';
   COMMENT ON COLUMN "TB_06_RSR"."SURQ_TITLE" IS '문제';
   COMMENT ON TABLE "TB_06_RSR"  IS '설문조사 결과';
   ALTER TABLE TB_06_RSR ADD CONSTRAINT PK_TB_06_RSR PRIMARY KEY(SURR_SEQ)
 * @author USER
 *
 */
@Getter
@Setter
@ToString
@RequiredArgsConstructor // 초기화 되지않은 final 필드나, @NonNull 이 붙은 필드에 대해 생성자를 생성
@Alias("TB_06_RSI")
public class SurveyResult_nouse {
    private String surrSeq;      // 설문결과번호
    private String surSeq;       // 설문번호
    private String surqSeq;      // 문제번호
    private String suriSeq;      // 문항번호
    private String suriNum;      // 선택문항
    private String description;  // 선택사유
    private String writer;       // 작성자
    private String regName;      // 등록자
    private LocalDateTime regDate;        // 등록일
    private String udtName;      // 수정자
    private LocalDateTime udtDate;        // 수정일
    private String surqTitle;    // 문제
}

