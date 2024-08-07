package com.spring.survey.service;

import java.io.UnsupportedEncodingException;

import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;
    
    public void sendEmail(String to, String subject, String htmlBody) throws UnsupportedEncodingException, MessagingException {
    	
    	MimeMessage message = mailSender.createMimeMessage();
    	MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
    	
    	messageHelper.setFrom("chaey0703@gmail.com"); // 발신자 이메일 주소
        messageHelper.setTo(to); // 수신자 이메일 주소
        messageHelper.setSubject(subject); // 메일 제목
        // messageHelper.addInline("logoImage", new ClassPathResource("/resources/static/images/sub/particiation/logo.png"));
        messageHelper.setText(htmlBody, true); // 메일 내용

        mailSender.send(message);
        System.out.println("메일을 성공적으로 보냈다....!");
    }
}

