package com.spring.survey.batch;

import org.springframework.batch.item.ItemWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import com.spring.survey.entity.Member;
import com.spring.survey.entity.Survey;
import com.spring.survey.mapper.ISurveyMapper;
import com.spring.survey.service.EmailService;

import java.util.List;

public class SurveyItemWriter implements ItemWriter<Survey> {

    private ISurveyMapper surveyMapper;
    private EmailService emailService;

    public SurveyItemWriter(ISurveyMapper surveyMapper, EmailService emailService) {
        this.surveyMapper = surveyMapper;
        this.emailService = emailService;
    }

    @Override
    public void write(List<? extends Survey> surveys) throws Exception {
        for (Survey survey : surveys) {
            // 설문 생성자에게 이메일 보내기
            Member creator = surveyMapper.findByUserId(survey.getCreator());
            if (creator != null) {
                emailService.sendEmail(creator.getEmail(), "설문 종료 알림", "등록하신 설문 '" + survey.getTitle() + "'이(가) 곧 종료됩니다.");
            }

            // 설문 등록자 아닌 회원에게 이메일 보내기
            List<Member> members = surveyMapper.findAllExceptCreator(survey.getCreator());
//            for (Member member : members) {
//                emailService.sendEmail(member.getEmail(), "설문 종료 알림", "설문 '" + survey.getTitle() + "'이(가) 곧 종료됩니다. 마감 전 참여 바랍니다.");
//            }
        }
    }
}


