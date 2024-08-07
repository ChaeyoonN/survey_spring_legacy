package com.spring.survey.batch;

import java.util.List;

import org.springframework.batch.item.ItemReader;

import com.spring.survey.entity.Member;
import com.spring.survey.mapper.ISurveyMapper;

import java.util.Iterator;
import java.util.List;

public class MemberItemReader implements ItemReader<Member> {

    private final ISurveyMapper memberMapper;
    private Iterator<Member> memberIterator;

    public MemberItemReader(ISurveyMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    @Override
    public Member read() {
        if (memberIterator == null) {
            List<Member> members = memberMapper.selectAllMembers();
            memberIterator = members.iterator();
        }

        if (memberIterator.hasNext()) {
            return memberIterator.next();
        } else {
            return null; // No more members to read
        }
    }
}

