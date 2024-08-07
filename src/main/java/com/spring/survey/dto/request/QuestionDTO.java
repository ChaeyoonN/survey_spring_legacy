package com.spring.survey.dto.request;

import lombok.Data;
import java.util.List;

@Data
public class QuestionDTO {
    //private Long id;
    private String questionText;
    private List<OptionDTO> options;
}
