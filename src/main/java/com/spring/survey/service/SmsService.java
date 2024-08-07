package com.spring.survey.service;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Service
public class SmsService {
    private final Environment env;
    private String apiKey;
    private String apiSecret;
    private String senderNumber;
    private DefaultMessageService messageService;

    @Autowired
    public SmsService(Environment env) {
        this.env = env;
    }

    @PostConstruct
    public void init() {
        this.apiKey = env.getProperty("coolsms.api_key");
        this.apiSecret = env.getProperty("coolsms.api_secret");
        this.senderNumber = env.getProperty("coolsms.sender_number");
        this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecret, "https://api.coolsms.co.kr");
    }

    public SingleMessageSentResponse sendSms(String phoneNumber, String messageContent) {
        Message coolsms = new Message();

        coolsms.setFrom(senderNumber); // 발신번호
        coolsms.setTo(phoneNumber); // 수신번호
        coolsms.setText(messageContent);
        
        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(coolsms));
        System.out.println(response);
        return response;
       
    }
    
    
    
}

