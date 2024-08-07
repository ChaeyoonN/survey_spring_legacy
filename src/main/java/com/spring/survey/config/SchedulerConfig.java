package com.spring.survey.config;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

@Configuration
@EnableScheduling
public class SchedulerConfig {

    @Autowired
    private JobLauncher jobLauncher;

    @Autowired
    private Job updateInterfaceMemberJob;

//     @Scheduled(cron = "0 */1 * * * *")
    @Scheduled(cron = "0 */30 * ? * *")
    public void perform() throws Exception {
        try {
        	JobParameters jobParameters = new JobParametersBuilder()
                    .addLong("timestamp", System.currentTimeMillis())
                    .toJobParameters();
        	JobExecution execution = jobLauncher.run(updateInterfaceMemberJob, 
        			jobParameters);
            System.out.println(execution.getJobInstance());
            System.out.println(execution.getStatus());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

