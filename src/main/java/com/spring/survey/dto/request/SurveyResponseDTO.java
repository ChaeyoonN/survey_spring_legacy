package com.spring.survey.dto.request;

import java.util.List;
import java.util.stream.Collectors;

import com.spring.survey.dto.response.SurveyResultResponseDTO.QuestionDTO.OptionDTO;
import com.spring.survey.entity.Option;
import com.spring.survey.entity.Question;
import com.spring.survey.entity.SurveyResult;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
/*
 * 설문 응답을 등록하기 위한 DTO
 */
@Getter
@Setter
@ToString
public class SurveyResponseDTO {
    private Long surveyId;
    private String userId;
    private List<QuestionResponseDTO> questions;

    @Getter
    @Setter
    @ToString
    @NoArgsConstructor // jackson library가 빈 생성자가 없는 모델을 생성하는 방법을 모르므로 추가
    public static class QuestionResponseDTO {
        private Long questionId;
        private Long selOptionNum; // 선택옵션순번
        private String reason;
		private List<OptionResponseDTO> options;
        
        public QuestionResponseDTO(Question question, SurveyResult surveyResult) {
            this.questionId = question.getQuestionId();
            this.selOptionNum = surveyResult.getSelOptionNum(); // 디비에 없음. 클라이언트에서 받음.
            this.options = question.getOptions().stream()
                .map(OptionResponseDTO::new)
                .collect(Collectors.toList());
        }
        
        
        
        @Getter
        @Setter
        @ToString
        @NoArgsConstructor // // jackson library가 빈 생성자가 없는 모델을 생성하는 방법을 모르므로 추가
        public static class OptionResponseDTO {
            private Long optionId;

            public OptionResponseDTO(Option option) {
                this.optionId = option.getOptionId();
            }
        }
    } // QuestionResponseDTO 끝
}

//{
//	"questions":[
//					{
//						"questionText":"",
//						"options":[]
//					}
//				],
//	"surveyId":"24"
//	
//}