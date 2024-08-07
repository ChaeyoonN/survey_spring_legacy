package com.spring.survey.utils;

import java.time.LocalDate;

public class DateUtils {

    public static boolean isAfter(LocalDate date1, LocalDate date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        return date1.isAfter(date2);
    }
    
    // 설문조사의 시작일과 종료일 사이의 기간에 해당되지 않고 현재 날짜가 종료일 이후인지 확인하는 메서드
    public static boolean isSurveyOutsidePeriod(LocalDate currentDate, LocalDate stDate, LocalDate endDate) {
        if (currentDate == null || stDate == null || endDate == null) {
            return false;
        }
        return currentDate.isAfter(endDate) && !isSurveyActive(currentDate, stDate, endDate);
    }

    public static boolean isBeforeOrEqual(LocalDate date1, LocalDate date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        return !date1.isAfter(date2);
    }

    public static boolean isAfterOrEqual(LocalDate date1, LocalDate date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        return !date1.isBefore(date2);
    }
    
    // 진행중 판단
    public static boolean isSurveyActive(LocalDate currentDate, LocalDate stDate, LocalDate endDate) {
    	if (currentDate == null || stDate == null || endDate == null) {
            return false;
        }
        return DateUtils.isAfterOrEqual(currentDate, stDate) && DateUtils.isBeforeOrEqual(currentDate, endDate);
    }
}
