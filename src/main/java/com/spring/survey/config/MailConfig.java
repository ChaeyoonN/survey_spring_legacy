package com.spring.survey.config;

import java.util.Properties;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

@Configuration
@PropertySource("classpath:/properties/Email.properties")
public class MailConfig {
    @Value("${spring.mail.host}")
    private String host;

//    @Value("${mail.smtp.port}")
//    private int port;
    
    @Value("${spring.mail.port}")
    private int port;

    @Value("${spring.mail.username}")
    private String username;

    @Value("${spring.mail.password}")
    private String password;
    
    @Value("${spring.mail.properties.mail.smtp.auth}")
    private String auth;
    @Value("${spring.mail.properties.mail.smtp.starttls.enable}")
    private String enable;
    
    @Value("${spring.mail.properties.mail.smtp.starttls.required}")
    private String required;
    
    @Value("${spring.mail.properties.mail.smtp.connectiontimeout}")
    private String contimeout;
    
    @Value("${spring.mail.properties.mail.smtp.timeout}")
    private String timeout;
    @Value("${spring.mail.properties.mail.smtp.writetimeout}")
    private String writetimeout;
    
//    @Value("${mail.transport.protocol}")
//    private String protocol;
//
//    @Value("${mail.smtp.auth}")
//    private boolean smtpAuth;
//
//    @Value("${mail.smtp.ssl.enable}")
//    private boolean sslEnable;
//
//    @Value("${spring.mail.properties.mail.smtp.starttls.enable}")
//    private boolean tlsEnable;
//    
//    @Value("${mail.smtp.ssl.trust}")
//    private String sslTrust;
//    
//    @Value("${mail.smtp.ssl.protocols}")
//    private String TLS;
//    
//    @Value("mail.debug")
//    private String debug;
    
    @Bean
    public JavaMailSender javaMailSender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost(host);
        mailSender.setPort(port);

        mailSender.setUsername(username);
        mailSender.setPassword(password);

        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.debug", "true");
        props.put("mail.smtp.connectiontimeout", 5000);
        props.put("mail.smtp.timeout", 5000);
        props.put("mail.smtp.writetimeout", 5000);
//        props.put("mail.transport.protocol", protocol);
//        props.put("mail.smtp.auth", smtpAuth);
//        props.put("mail.smtp.ssl.enable", sslEnable);
//        props.put("mail.smtp.ssl.trust", sslTrust);
//        props.put("mail.debug", debug);
//        props.put("mail.smtp.ssl.protocols", TLS);

        return mailSender;
    }
}

