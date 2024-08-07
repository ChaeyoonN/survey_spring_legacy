package com.spring.survey.batch;

import java.util.List;

import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;

import com.spring.survey.entity.Member;
import com.spring.survey.mapper.ISurveyMapper;

public class MemberItemProcessor implements ItemProcessor<Member, Member> {

    @Override
    public Member process(Member member) {
        System.out.println("Processing member: "+ member);
        String regEx = "(\\d{3})(\\d{3,4})(\\d{4})";
        member.setPhone(member.getPhone().replaceAll(regEx, "$1-$2-$3")); 
        return member;
    }
}
