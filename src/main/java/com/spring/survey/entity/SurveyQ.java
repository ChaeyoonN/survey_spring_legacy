package com.spring.survey.entity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Date;

import org.apache.ibatis.type.Alias;
/**
 *   CREATE TABLE "TB_06_RSQ" 
   (	"SURQ_SEQ" VARCHAR2(8 BYTE), 
	"SUR_SEQ" VARCHAR2(8 BYTE), 
	"SURQ_TITLE" VARCHAR2(200 BYTE), 
	"WRITER" VARCHAR2(50 BYTE), 
	"REG_NAME" VARCHAR2(8 BYTE), 
	"REG_DATE" DATE, 
	"UDT_NAME" VARCHAR2(8 BYTE), 
	"UDT_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "TB_06_RSQ"."SURQ_SEQ" IS '문제번호';
   COMMENT ON COLUMN "TB_06_RSQ"."SUR_SEQ" IS '설문번호';
   COMMENT ON COLUMN "TB_06_RSQ"."SURQ_TITLE" IS '문제';
   COMMENT ON COLUMN "TB_06_RSQ"."WRITER" IS '작성자';
   COMMENT ON COLUMN "TB_06_RSQ"."REG_NAME" IS '등록자';
   COMMENT ON COLUMN "TB_06_RSQ"."REG_DATE" IS '등록일';
   COMMENT ON COLUMN "TB_06_RSQ"."UDT_NAME" IS '수정자';
   COMMENT ON COLUMN "TB_06_RSQ"."UDT_DATE" IS '수정일';
   COMMENT ON TABLE "TB_06_RSQ"  IS '설문조사 문제';
ALTER TABLE TB_06_RSQ ADD CONSTRAINT PK_TB_06_RSQ PRIMARY KEY(SURQ_SEQ)

 * @author USER
 *
 */
@Getter
@Setter
@ToString
@NoArgsConstructor
@Alias("TB_06_RSQ")
public class SurveyQ {
	// 오라클 테이블의 컬럼에 해당하는 필드들을 정의
    private String surqSeq; // 문제번호
    private String surSeq; // 설문번호
    private String surqTitle; // 문제
    private String writer; // 작성자
    private String regName; // 등록자
    private LocalDateTime regDate; // 등록일
    private String udtName; // 수정자
    private LocalDateTime udtDate; // 수정일
}


    

