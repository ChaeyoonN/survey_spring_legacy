package com.spring.survey.config;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.core.step.tasklet.TaskletStep;
import org.springframework.batch.item.database.BeanPropertyItemSqlParameterSourceProvider;
import org.springframework.batch.item.database.JdbcBatchItemWriter;
import org.springframework.batch.item.database.JdbcCursorItemReader;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import com.spring.survey.batch.MemberItemProcessor;
import com.spring.survey.batch.MemberItemReader;
import com.spring.survey.batch.MemberItemWriter;
import com.spring.survey.batch.MemberRowMapper;
import com.spring.survey.entity.Member;
import com.spring.survey.mapper.ISurveyMapper;

import javax.sql.DataSource;

@Configuration
@EnableBatchProcessing
public class BatchConfig {

    @Autowired
    private JobBuilderFactory jobBuilderFactory;
    
    @Autowired
    private StepBuilderFactory stepBuilderFactory;

    @Autowired
    @Qualifier("ds")
    private DataSource dataSource;
    
//    @Autowired
//    @Qualifier("ds2")
//    private DataSource kjhDataSource;

    @Autowired
    private ISurveyMapper memberMapper;
    
    @Bean
    public Job updateInterfaceMemberJob() {
        return jobBuilderFactory.get("updateInterfaceMemberJob")
                .incrementer(new RunIdIncrementer())
                .flow(updateInterfaceMemberStep())
                .end()
                .build();
    }

    @Bean
    public Step updateInterfaceMemberStep() {
        return stepBuilderFactory.get("updateInterfaceMemberStep")
                .<Member, Member>chunk(100) // <reader의 입력 타입, processor의 출력 타입>
                .reader(memberItemReader())
                .processor(memberItemProcessor())
                .writer(memberItemWriter())
                .build();
    }

    @Bean
    public JdbcCursorItemReader<Member> memberItemReader() {
        JdbcCursorItemReader<Member> reader = new JdbcCursorItemReader<>();
        reader.setDataSource(dataSource);
        reader.setSql("SELECT * FROM tb_00_member");
        reader.setFetchSize(100);
        reader.setRowMapper(new MemberRowMapper());
        return reader;
    }

    @Bean
    public MemberItemProcessor memberItemProcessor() {
        return new MemberItemProcessor();
    }

    @Bean
    public MemberItemWriter memberItemWriter() {
        //return new MemberItemWriter(memberMapper, kjhDataSource);
        return new MemberItemWriter(memberMapper);
    }

    @Bean
    public PlatformTransactionManager transactionManager() {
        return new DataSourceTransactionManager(dataSource);
    }
    
}


