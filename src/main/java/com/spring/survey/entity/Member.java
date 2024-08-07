package com.spring.survey.entity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;

import java.util.Date;
import java.util.Objects;

import org.apache.ibatis.type.Alias;
/**
 * CREATE TABLE "TB_00_MEMBER" 
   (
	"USER_ID" VARCHAR2(50 BYTE),
    "PASSWORD" VARCHAR2(20 BYTE),
    "USER_NAME" VARCHAR2(20 BYTE), 
	"PHONE" VARCHAR2(50 BYTE), 
	"EMAIL" VARCHAR2(100 BYTE), 
	"ADMIN_YN" VARCHAR2(1 BYTE) DEFAULT NULL,  
	"REG_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
   COMMENT ON COLUMN "TB_00_MEMBER"."USER_ID" IS '아이디';
   COMMENT ON COLUMN "TB_00_MEMBER"."PASSWORD" IS '비밀번호';
   COMMENT ON COLUMN "TB_00_MEMBER"."USER_NAME" IS '이름';
    COMMENT ON COLUMN "TB_00_MEMBER"."PHONE" IS '전화번호';
   COMMENT ON COLUMN "TB_00_MEMBER"."EMAIL" IS '이메일';
   COMMENT ON COLUMN "TB_00_MEMBER"."ADMIN_YN" IS '관리자여부'; -- 일반유저 1, 관리자 0
   COMMENT ON COLUMN "TB_00_MEMBER"."REG_DATE" IS '등록일자';
   COMMENT ON TABLE "TB_00_MEMBER"  IS '회원관리';
   ALTER TABLE TB_00_MEMBER ADD CONSTRAINT PK_TB_00_MEMBER PRIMARY KEY(USER_ID)
 * @author USER
 *
 */
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Alias("TB_00_MEMBER")
public class Member {
    private String userId; // "USER_ID" VARCHAR2(50 BYTE)
    private String password; // "PASSWORD" VARCHAR2(60 BYTE)
    private String userName; // "USER_NAME" VARCHAR2(50 BYTE)
    private String phone; // "PHONE" VARCHAR2(50 BYTE)
    private String email; // "EMAIL" VARCHAR2(100 BYTE)
    private String adminYn; // "ADMIN_YN" VARCHAR2(1 BYTE) DEFAULT NULL
    private Date regDate; // "REG_DATE" DATE
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Member member = (Member) o;
        return Objects.equals(userId, member.userId) &&
               Objects.equals(password, member.password) &&
               Objects.equals(userName, member.userName) &&
               Objects.equals(phone, member.phone) &&
               Objects.equals(email, member.email) &&
               Objects.equals(adminYn, member.adminYn) &&
               Objects.equals(regDate, member.regDate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, password, userName, phone, email, adminYn, regDate);
    }
}




