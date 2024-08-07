package com.spring.survey.dto.response;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import com.spring.survey.dto.response.SurveyResultResponseDTO.QuestionDTO;
import com.spring.survey.dto.response.SurveyResultResponseDTO.QuestionDTO.OptionDTO;
import com.spring.survey.entity.Option;
import com.spring.survey.entity.Question;
import com.spring.survey.entity.Survey;
import com.spring.survey.entity.SurveyResult;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SurveyResultResponseDTO {
    private Long surveyId;
    private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private String creator;
    private List<QuestionDTO> questions;
    private List<SurveyResultDTO> results;

    public SurveyResultResponseDTO(Survey survey, List<SurveyResult> surveyResults) {
        this.surveyId = survey.getSurveyId();
        this.title = survey.getTitle();
        this.startDate = survey.getStartDate();
        this.endDate = survey.getEndDate();
        this.creator = survey.getCreator();
        this.questions = survey.getQuestions().stream()
            .map(QuestionDTO::new)
            .collect(Collectors.toList());
        
        this.results = surveyResults.stream()
            .map(SurveyResultDTO::new)
            .collect(Collectors.toList());
    }

    public SurveyResultResponseDTO() {
		super();
	}
    
	public SurveyResultResponseDTO(Long surveyId, String title, LocalDate startDate, LocalDate endDate, String creator,
			List<QuestionDTO> questions, List<SurveyResultDTO> results) {
		super();
		this.surveyId = surveyId;
		this.title = title;
		this.startDate = startDate;
		this.endDate = endDate;
		this.creator = creator;
		this.questions = questions;
		this.results = results;
	}

	@Getter
    @Setter
    public static class QuestionDTO {
        private Long questionId;
        private String questionText;
        private List<OptionDTO> options;

        public QuestionDTO(Question question) {
            this.questionId = question.getQuestionId();
            this.questionText = question.getQuestionText();
            this.options = question.getOptions().stream()
                .map(OptionDTO::new)
                .collect(Collectors.toList());
        }

        @Getter
        @Setter
        public static class OptionDTO {
            private Long optionId;
            private String optionText;

            public OptionDTO(Option option) {
                this.optionId = option.getOptionId();
                this.optionText = option.getOptionText();
            }
        }
    }
    
    @Getter
    @Setter
    public static class SurveyResultDTO {
        private Long resultId;
        private Long surveyId;
        private Long questionId;
        private Long optionId;
        private Long selOptionNum;
        private String reason;
        private String userId;
        private Date responseDate;

        public SurveyResultDTO(SurveyResult result) {
            this.resultId = result.getResultId();
            this.surveyId = result.getSurveyId();
            this.questionId = result.getQuestionId();
            this.optionId = result.getOptionId();
            this.selOptionNum = result.getSelOptionNum();
            this.reason = result.getReason();
            this.userId = result.getUserId();
            this.responseDate = result.getResponseDate();
        }
    }
}


