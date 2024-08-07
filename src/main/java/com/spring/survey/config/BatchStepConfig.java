package com.spring.survey.config;

import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.database.JdbcBatchItemWriter;
import org.springframework.batch.item.database.JdbcCursorItemReader;
import org.springframework.batch.item.database.builder.JdbcCursorItemReaderBuilder;
import org.springframework.batch.item.database.builder.JdbcBatchItemWriterBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.spring.survey.entity.InterMember;
import com.spring.survey.entity.Member;

import javax.sql.DataSource;

@Configuration
public class BatchStepConfig {

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("oracle.jdbc.driver.OracleDriver");
        dataSource.setUrl("jdbc:oracle:thin:@localhost:1521:orcl");
        dataSource.setUsername("survey");
        dataSource.setPassword("1234");
        return dataSource;
    }

    @Bean
    public JdbcCursorItemReader<Member> reader(DataSource dataSource) {
        return new JdbcCursorItemReaderBuilder<Member>()
                .dataSource(dataSource)
                .name("memberReader")
                .sql("SELECT USER_ID, PASSWORD, USER_NAME, PHONE, EMAIL, ADMIN_YN, REG_DATE FROM TB_00_MEMBER")
                .rowMapper(new BeanPropertyRowMapper<>(Member.class))
                .build();
    }

    @Bean
    public ItemProcessor<Member, InterMember> processor() {
        return member -> {
            InterMember interMember = new InterMember();
            interMember.setUserId(member.getUserId());
            interMember.setPassword(member.getPassword());
            interMember.setUserName(member.getUserName());
            interMember.setPhone(member.getPhone());
            interMember.setEmail(member.getEmail());
            interMember.setAdminYn(member.getAdminYn());
            System.out.println(interMember);
            return interMember;
        };
    }

    @Bean
    public JdbcBatchItemWriter<InterMember> writer(DataSource dataSource) {
        JdbcBatchItemWriter<InterMember> writer = new JdbcBatchItemWriterBuilder<InterMember>()
                .dataSource(dataSource)
                .sql("INSERT INTO INTERFACE_MEMBER (USER_ID, PASSWORD, USER_NAME, PHONE, EMAIL, ADMIN_YN) VALUES (:userId, :password, :userName, :phone, :email, :adminYn)")
                .beanMapped()
                .build();
        writer.afterPropertiesSet();
        return writer;
    }

}
