package com.spring.survey.entity;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

//public class listExcelDownload extends AbstractXlsxView {
//	@Override
//	protected void buildExcelDocument(Map<String, Object> modelMap, Workbook workbook, HttpServletRequest request,
//			HttpServletResponse response) throws Exception {
//		
//		String sCurTime = null;
//		sCurTime = new SimpleDateFormat("yyyyMMdd", Locale.KOREA).format(new Date());
//	
//		String excelName = sCurTime + "_설문엑셀다운로드.xlsx";
//		Sheet worksheet = null;
//		Row row = null;
//		CellStyle style = workbook.createCellStyle(); // 셀 스타일을 위한 변수
//		style.setAlignment(CellStyle.ALIGN_CENTER); // 글 위치를 중앙으로 설정
//		
//		List listExcel = (List) modelMap.get("list");
//		
//	    // 새로운 sheet를 생성한다.
//	    worksheet = workbook.createSheet("설문 엑셀 목록");
//	    
//	    // 가장 첫번째 줄에 제목을 만든다.
//	    row = worksheet.createRow(0);
//	    
//	    // 칼럼 길이 설정
//	    int columnIndex = 0;
//	    while (columnIndex < 7) {
//	    	
//	    	if(columnIndex == 0) {
//	    		worksheet.setColumnWidth(columnIndex, 3000);
//	    	} else if (columnIndex == 1) {
//	    		worksheet.setColumnWidth(columnIndex, 5000);
//	    	} else if (columnIndex == 2) {
//	    		worksheet.setColumnWidth(columnIndex, 4000);
//	    	} else if (columnIndex == 3) {
//	    		worksheet.setColumnWidth(columnIndex, 4000);
//	    	} else if (columnIndex == 4) {
//	    		worksheet.setColumnWidth(columnIndex, 3000);
//	    	} 
//	    	columnIndex++;
//	    }
//	    
//	    // 헤더 설정
//	    row = worksheet.createRow(0);
//	    row.createCell(0).setCellValue("번호");
//	    row.createCell(1).setCellValue("제목");
//	    row.createCell(2).setCellValue("시작일");
//	    row.createCell(3).setCellValue("마감일");
//	    row.createCell(4).setCellValue("완료여부");
//	    
//	    int rowIndex = 1;
//	    
//	    // 각 해당하는 셀에 값과 스타일을 넣음
//	    for(BoardVO board : listExcel) {
//	    	row = worksheet.createRow(rowIndex);
//	    	row.createCell(0).setCellValue(board.getBno());
//	    	row.createCell(1).setCellValue(board.getTitle());
//	    	row.createCell(2).setCellValue(board.getContent());
//	    	row.createCell(3).setCellValue(board.getWriter());
//	    	row.createCell(4).setCellValue(board.getRegdate().toLocaleString());
//	    	row.createCell(5).setCellValue(board.getViewcnt());
//	    	row.createCell(6).setCellValue(board.getReplycnt());
//	    	
//	    	rowIndex++;
//	    }
//	    
//	    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
//	    worksheet.addMergedRegion(
//	    		new CellRangeAddress(listExcel.size() + 1, listExcel.size() + 1, 0, 6));
//	    
//	    // 병합 테스트를 위한 설정
//	    row = worksheet.createRow(listExcel.size() + 1);
//	    row.createCell(0).setCellValue("셀 병합 테스트");
//	    row.getCell(0).setCellStyle(style); // 지정한 스타일을 입혀준다.
//	    
//	    
//	    try {
//	        response.setHeader("Content-Disposition", "attachement; filename=\""
//	            + java.net.URLEncoder.encode(excelName, "UTF-8") + "\";charset=\"UTF-8\"");
//	      } catch (UnsupportedEncodingException e) {
//	        // TODO Auto-generated catch block
//	        e.printStackTrace();
//	      }
//	}
//	
//}


