package com.spring.survey.entity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.Date;

import org.apache.ibatis.type.Alias;
/**
 *  CREATE TABLE "TB_06_RSI" 
   (	"SURI_SEQ" VARCHAR2(8 BYTE), 
	"SUR_SEQ" VARCHAR2(8 BYTE), 
	"SURQ_SEQ" VARCHAR2(8 BYTE), 
	"SURI_TITLE1" VARCHAR2(200 BYTE), 
	"SURI_TITLE2" VARCHAR2(200 BYTE), 
	"SURI_TITLE3" VARCHAR2(200 BYTE), 
	"SURI_TITLE4" VARCHAR2(200 BYTE), 
	"SURI_TITLE5" VARCHAR2(200 BYTE), 
	"WRITER" VARCHAR2(50 BYTE), 
	"REG_NAME" VARCHAR2(8 BYTE), 
	"REG_DATE" DATE, 
	"UDT_NAME" VARCHAR2(8 BYTE), 
	"UDT_DATE" DATE, 
	"SURI_NUM1" VARCHAR2(1 BYTE) DEFAULT 1, 
	"SURI_NUM2" VARCHAR2(1 BYTE) DEFAULT 2, 
	"SURI_NUM3" VARCHAR2(1 BYTE) DEFAULT 3, 
	"SURI_NUM4" VARCHAR2(1 BYTE) DEFAULT 4, 
	"SURI_NUM5" VARCHAR2(1 BYTE) DEFAULT 5
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "TB_06_RSI"."SURI_SEQ" IS '문항번호';
   COMMENT ON COLUMN "TB_06_RSI"."SUR_SEQ" IS '설문번호';
   COMMENT ON COLUMN "TB_06_RSI"."SURQ_SEQ" IS '문제번호';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_TITLE1" IS '문항제목1';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_TITLE2" IS '문항제목2';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_TITLE3" IS '문항제목3';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_TITLE4" IS '문항제목4';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_TITLE5" IS '문항제목5';
   COMMENT ON COLUMN "TB_06_RSI"."WRITER" IS '작성자';
   COMMENT ON COLUMN "TB_06_RSI"."REG_NAME" IS '등록자';
   COMMENT ON COLUMN "TB_06_RSI"."REG_DATE" IS '등록일';
   COMMENT ON COLUMN "TB_06_RSI"."UDT_NAME" IS '수정자';
   COMMENT ON COLUMN "TB_06_RSI"."UDT_DATE" IS '수정일';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_NUM1" IS '문항1';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_NUM2" IS '문항2';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_NUM3" IS '문항3';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_NUM4" IS '문항4';
   COMMENT ON COLUMN "TB_06_RSI"."SURI_NUM5" IS '문항5';
   COMMENT ON TABLE "TB_06_RSI"  IS '설문조사 문항';
   ALTER TABLE TB_06_RSI ADD CONSTRAINT PK_TB_06_RSI PRIMARY KEY(SURI_SEQ)
 * @author USER
 *
 */
@Getter
@Setter
@ToString
@Alias("TB_06_RSI")
public class SurveySub {
	private String suriSeq; // 문항번호
    private String surSeq; // 설문번호
    private String surqSeq; // 문제번호
    private String suriTitle1; // 문항제목1
    private String suriTitle2; // 문항제목2
    private String suriTitle3; // 문항제목3
    private String suriTitle4; // 문항제목4
    private String suriTitle5; // 문항제목5
    private String writer; // 작성자
    private String regName; // 등록자
    private LocalDateTime regDate; // 등록일
    private String udtName; // 수정자
    private LocalDateTime udtDate; // 수정일
    
    private String suriNum1; // 문항1
    private String suriNum2; // 문항2
    private String suriNum3; // 문항3
    private String suriNum4; // 문항4
    private String suriNum5; // 문항5
}





