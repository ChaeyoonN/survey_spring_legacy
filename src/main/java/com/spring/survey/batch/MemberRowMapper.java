package com.spring.survey.batch;

import org.springframework.jdbc.core.RowMapper;

import com.spring.survey.entity.Member;

import java.sql.ResultSet;
import java.sql.SQLException;

public class MemberRowMapper implements RowMapper<Member> {
    @Override
    public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
        Member member = new Member();
        // ResultSet에서 Member 객체로 매핑하는 로직을 작성.
        member.setUserId(rs.getString("user_id"));
        member.setPassword(rs.getString("password"));
        member.setUserName(rs.getString("user_name"));
        member.setPhone(rs.getString("phone"));
        member.setEmail(rs.getString("email"));
        member.setAdminYn(rs.getString("admin_yn"));
        member.setRegDate(rs.getDate("reg_date"));
        // 다른 필드들도 설정.
        return member;
    }
}
