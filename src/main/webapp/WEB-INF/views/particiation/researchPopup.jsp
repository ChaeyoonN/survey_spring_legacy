<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.spring.survey.utils.DateUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>서울학교급식포털</title>
<link href="/css/base.css" rel="stylesheet" type="text/css" />
<link href="/css/common.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.1/Chart.min.js"></script>
<style>
    .graph_box {
        margin-top: 50px;
        margin-bottom: 30px;
    }
    .graph_box .distribute {
        margin-bottom: 20px;
    }
    .research_box h3 {
        margin-bottom: 10px;
    }
    .research.last {
    border-bottom: none;
	}
</style>
</head>
<body>
<%
    LocalDate nowDate = LocalDate.now();
    pageContext.setAttribute("nowDate", nowDate);
%>
<!-- w100% h545px -->
<div class="pop">
  <div class="pop_box">
  	<h1>결과보기</h1>
    <div class="pop_list">
    	<h2><strong><c:out value="${board.title}" escapeXml="true" /></strong>
	    	<span class="rearch_end">
				<c:choose>
	                <c:when test="${board.startDate != null and nowDate != null and DateUtils.isAfter(board.startDate, nowDate)}">
	                    진행 예정
	                </c:when>
	                <c:when test="${board.startDate != null and nowDate != null and board.endDate != null and DateUtils.isBeforeOrEqual(board.startDate, nowDate) and DateUtils.isAfterOrEqual(board.endDate, nowDate)}">
	                    진행 중
	                </c:when>
	                <c:otherwise>
	                    완료
	                </c:otherwise>
	            </c:choose>
            </span>
    	</h2>
        <div class="graph_box" id="graph_box">
        	<div class="distribute"><strong>문제별 응답 분포</strong></div>
<%--         	<canvas id="surveyChart"></canvas> --%>
        </div>
        <div class="research_box">
        	<h3><strong>설문 내용</strong></h3>
        	<c:forEach var="question" items="${board.questions}" varStatus="status">
        		<input type="hidden" id="questionId" value="${question.questionId}"/>
	             <tr>
	              <td colspan="6" class="tl">
              	   <div class="research ${status.last ? 'last' : ''}"> <!-- 마지막 요소에 'last' 클래스 추가 -->
                      <p><c:out value="${status.index + 1}. ${question.questionText}" escapeXml="true" /></p>
                       <ul>
                       <c:forEach var="option" items="${question.options}" varStatus="optionStatus">
                           <li><c:out value="${optionStatus.index + 1} ${option.optionText}" escapeXml="true" /></li>
                       </c:forEach>
<%--                         <li>선택사유 <input type="text" id="reason${status.index}" name="reason${status.index}" class="inp" style="width:200px;" /> </li> --%>
                       </ul>
					</div>
	              </td>
	             </tr>
              </c:forEach>
        </div>
        
    </div>
	<p class="pt20"></p>
    <div class="pop_btn">
    	<span class="blue_l"><a href="#" onclick="self.close()" class="blue_r">확인</a></span>
        <span class="gray_l"><a href="#" onclick="self.close()" class="gray_r">취소</a></span>
    </div>
  </div>
  
  </div>
<script type="text/javascript">
var board = JSON.parse(${board.questions.size()});
console.log('!!!!!!!',board);
// array
var countPerOption = ${countPerOption}
var countPerOption_jsonObject = JSON.stringify(countPerOption);
var countPerOption_jData = JSON.parse(countPerOption_jsonObject);
console.log(countPerOption); // optionId, questionId, responsecount, selOptionNum, surveyId 객체 가진 리스트

var results = ${results}
var results_jsonObject = JSON.stringify(results);
var results_jData = JSON.parse(results_jsonObject);
console.log(results); // optionId, questionId, responseDate, resultId, selOptionNum, surveyId, userId 객체 가진 리스트

var questionId = document.getElementById('questionId').value;
console.log(questionId);
// 결과 리스트 갯수 만큼 차트 그리기
// 선택 옵션 갯수만큼 차트 내용 그리기

// 랜덤 색상 생성 함수
function colorize() {
	var r = Math.floor(Math.random() * 200);
	var g = Math.floor(Math.random() * 200);
	var b = Math.floor(Math.random() * 200);
	var color = 'rgba(' + r + ', ' + g + ', ' + b + ', 0.7)';
	return color;
}

// 설문의 문제 리스트 갯수 만큼 차트 그리기
// board.length : 설문 문제의 갯수
// countPerOption.length : 응답자가 선택한 항목의 갯수
// results.length : 응답(자) 수
if(results.length > 0) { // 응답이 존재한다면
	for (var i = 0; i < board; i++) { // 문제 수만큼 차트 보여주기
		renderChart(i, results, countPerOption);
	}
} else {
	var noDataEle = document.createElement("div");
    noDataEle.textContent = "응답 데이터가 존재하지 않습니다.";
    noDataEle.setAttribute("id", "noDataDiv" + (i+1));
//	    noDataEle.style.display = "block"; 
//     noDataEle.style.textAlign = "left";
    document.getElementById('graph_box').appendChild(noDataEle); 
}

function renderChart(num, resultData, countData) {
	var labelList = [];
    var valueList = [];
    var colorList = [];
 	// 문제별로 응답 옵션의 분포 계산
    for (var j = 0; j < countData.length; j++) {
//     	if(results[j].questionId ===)
    	if(countData[j].questionId === resultData[j].questionid){ // 문제 ID가 일치하는 데이터만 처리
            
    		var countObj = countData[j];

			var opNumTxt = countObj.selOptionNum + "번 " + countObj.optionText;
            var opResCount = countObj.responseCount;
            labelList.push(opNumTxt);
            valueList.push(opResCount); // 수정된 부분: 올바른 응답 수를 배열에 추가
            colorList.push(colorize());
        }
    }

    var data = {
        labels: labelList,
        datasets: [{
            backgroundColor: colorList,
            data: valueList
        }]
    };
	
 	// 문제 번호 출력을 위한 span 태그 생성 및 설정
    var span = document.createElement("span");
    span.textContent = "문제 " + (num + 1); // "문제 번호" 텍스트 설정
    span.style.display = "block"; // span을 블록 레벨 요소로 만들어 줄바꿈 효과
//     span.style.textAlign = "left";
    document.getElementById('graph_box').appendChild(span); // span 태그를 문서에 추가
    // 차트 그리기
    var canva = document.createElement("canvas");
    canva.id = "surveyChart" + num;
    canva.width = 200;
    canva.height = 100;
    canva.style.marginBottom = "20px";
    document.getElementById('graph_box').appendChild(canva);
    
    var ctx = canva.getContext('2d');
    new Chart(ctx, {
        type: 'pie',
        data: data,
        options: {
            title: {
                display: true,
                text: '설문 응답 ' + (num + 1)
            }
        }
    });
}
</script>
</body>
</html>
