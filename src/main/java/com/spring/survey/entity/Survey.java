package com.spring.survey.entity;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.type.Alias;

import lombok.Data;
/**
 *   CREATE TABLE "TB_06_RS" 
   (	"SUR_SEQ" VARCHAR2(8 BYTE), 
	"SUR_TITLE" VARCHAR2(200 BYTE), 
	"QUE_CNT" VARCHAR2(2 BYTE), 
	"SUR_SAT_DATE" VARCHAR2(10 BYTE), 
	"SUR_END_DATE" VARCHAR2(10 BYTE), 
	"HITS" VARCHAR2(8 BYTE) DEFAULT 0, 
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

   COMMENT ON COLUMN "TB_06_RS"."SUR_SEQ" IS '설문번호';
   COMMENT ON COLUMN "TB_06_RS"."SUR_TITLE" IS '제목';
   COMMENT ON COLUMN "TB_06_RS"."QUE_CNT" IS '문제수';
   COMMENT ON COLUMN "TB_06_RS"."SUR_SAT_DATE" IS '설문시작일자';
   COMMENT ON COLUMN "TB_06_RS"."SUR_END_DATE" IS '설문종료일자';
   COMMENT ON COLUMN "TB_06_RS"."HITS" IS '조회수';
   COMMENT ON COLUMN "TB_06_RS"."WRITER" IS '작성자';
   COMMENT ON COLUMN "TB_06_RS"."REG_NAME" IS '등록자';
   COMMENT ON COLUMN "TB_06_RS"."REG_DATE" IS '등록일';
   COMMENT ON COLUMN "TB_06_RS"."UDT_NAME" IS '수정자';
   COMMENT ON COLUMN "TB_06_RS"."UDT_DATE" IS '수정일';
   COMMENT ON TABLE "TB_06_RS"  IS '설문조사 정보';
 * @author USER
 *
 */
//@Getter
//@Setter
//@ToString
//@NoArgsConstructor
//@AllArgsConstructor
@Data
//@Alias("TB_06_RS")
@Alias("survey")
public class Survey {

//    // 문제수
//    private String queCnt;
//      
//    // 조회수, 기본값 0
//    @Builder.Default private String hits = "0"; // @Builder.Default: 빌더 패턴으로 생성 시에도 해당 값으로 초기화된다.

    private Long surveyId;
    private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private String creator;
    private Date createdAt;
    private Date updatedAt;
    private String finEmailSent;
    private List<Question> questions;
}


    

