package com.spring.survey.batch;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.batch.item.ItemReader;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import com.spring.survey.entity.Member;

import java.io.InputStream;
import java.util.Date;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Iterator;


public class ExcelItemReader implements ItemReader<InterfaceSurvey> {

    private Iterator<Row> rowIterator;

    public ExcelItemReader(Resource resource) throws Exception {
        try (InputStream is = resource.getInputStream()) {
            Workbook workbook = WorkbookFactory.create(is);
            Sheet sheet = workbook.getSheetAt(0);
            rowIterator = sheet.iterator();
        }
    }

    @Override
    public InterfaceSurvey read() throws Exception {
        if (rowIterator.hasNext()) {
            Row row = rowIterator.next();
            InterfaceSurvey survey = new InterfaceSurvey();
            survey.setTitle(row.getCell(0).getStringCellValue());

            // Date to LocalDate for startDate
            Date startDate = row.getCell(1).getDateCellValue();
            survey.setStartDate(startDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate());

            // Date to LocalDate for endDate
            Date endDate = row.getCell(2).getDateCellValue();
            survey.setEndDate(endDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate());

            survey.setCreator(row.getCell(3).getStringCellValue());
            return survey;
        }
        return null;
    }
}

