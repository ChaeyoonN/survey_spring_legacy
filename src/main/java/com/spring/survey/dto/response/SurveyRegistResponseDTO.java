package com.spring.survey.dto.response;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import com.spring.survey.entity.Option;
import com.spring.survey.entity.Question;
import com.spring.survey.entity.Survey;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SurveyRegistResponseDTO {
    private Long surveyId;
    private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private String creator;
    private List<QuestionDTO> questions;
    

    public SurveyRegistResponseDTO(Survey survey) {
        this.surveyId = survey.getSurveyId();
        this.title = survey.getTitle();
        this.startDate = survey.getStartDate();
        this.endDate = survey.getEndDate();
        this.creator = survey.getCreator();
        this.questions = survey.getQuestions().stream()
            .map(QuestionDTO::new)
            .collect(Collectors.toList());
    }

    @Getter
    @Setter
    @ToString
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
        @ToString
        public static class OptionDTO {
            private Long optionId;
            private String optionText;

            public OptionDTO(Option option) {
                this.optionId = option.getOptionId();
                this.optionText = option.getOptionText();
            }
        }
    }
}
