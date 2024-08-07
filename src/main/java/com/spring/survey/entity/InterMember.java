package com.spring.survey.entity;

import java.util.Date;

import org.apache.ibatis.type.Alias;

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
@Alias("INTERFACE_MEMBER")
public class InterMember {
    private String userId; // "USER_ID" VARCHAR2(50 BYTE)
    private String password; // "PASSWORD" VARCHAR2(60 BYTE)
    private String userName; // "USER_NAME" VARCHAR2(50 BYTE)
    private String phone; // "PHONE" VARCHAR2(50 BYTE)
    private String email; // "EMAIL" VARCHAR2(100 BYTE)
    private String adminYn; // "ADMIN_YN" VARCHAR2(1 BYTE) DEFAULT NULL
    private Date regDate; // "REG_DATE" DATE
}
