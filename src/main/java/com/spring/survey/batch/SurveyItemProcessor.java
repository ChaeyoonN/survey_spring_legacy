package com.spring.survey.batch;

import org.springframework.batch.item.ItemProcessor;

import com.spring.survey.entity.Survey;

public class SurveyItemProcessor implements ItemProcessor<Survey, Survey>  {

	@Override
    public Survey process(final Survey survey) throws Exception {
        return survey;
    }
}

