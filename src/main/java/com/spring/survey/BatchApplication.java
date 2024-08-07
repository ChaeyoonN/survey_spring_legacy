package com.spring.survey;


import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.spring.survey.config.BatchConfig;

public class BatchApplication {
    public static void main(String[] args) {
    	 AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(BatchConfig.class);
         JobLauncher jobLauncher = context.getBean(JobLauncher.class);
         Job importUserJob = context.getBean("importUserJob", Job.class);

         try {
             JobExecution execution = jobLauncher.run(importUserJob, new JobParametersBuilder().toJobParameters());
             System.out.println("Job Exit Status : " + execution.getStatus());
         } catch (Exception e) {
             e.printStackTrace();
         } finally {
             context.close();
         }
    }
}
