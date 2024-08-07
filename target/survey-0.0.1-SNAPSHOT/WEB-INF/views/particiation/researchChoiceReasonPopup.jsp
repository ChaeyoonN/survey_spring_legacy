<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>서울학교급식포털</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<link href="../css/common.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
<style>
/* .research_box .research_list.last { */
/*     border-bottom: none; */
/*     margin-bottom: 10px; */
/* } */
body {
  display: flex;/* .pop을 body의 가운데 배치하기 위함*/
    justify-content: center;
    align-items: center;
  
}
.pop {
    width: 100%;
/*     max-width: 1200px; */
    margin: 0 auto;
/*     background-color: #fff; */
    border: 1px solid #ddd;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 20px;
    box-sizing: border-box;
    display: flex;
    justify-content: center;
    align-items: center;
}

.pop_box {
    display: flex;
    flex-direction: column;
    align-items: center; /* 요소의 정렬을 가운데로 맞춤 */
}

.pop_list {
    width: 100%;
}

.pop_list h1 {
    font-size: 2em; /* 폰트 크기 조정 */
    margin-bottom: 15px; /* 마진 조정 */
    text-align: center;
}

.pop_list h2 {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 1.5em; /* 폰트 크기 조정 */
    margin-bottom: 15px; /* 마진 조정 */
}

.table-container {
    display: flex;
    justify-content: space-around; /* 요소 간 간격을 더 넓게 설정 */
    width: 100%;
    max-width: 100%;
    overflow-x: auto; /* 가로 스크롤 추가 */
    align-items: stretch; /* 자식 요소들의 높이를 부모에 맞춤 */
}

.tbl_type01 {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
}

.tbl_type01 th, .tbl_type01 td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
}

.tbl_type01 th {
    background-color: #f4f4f4;
    font-weight: bold;
}

.research_box {
    width: 100%;
/*     min-width: 300px; */
    overflow-x: auto; /* 가로 스크롤 추가 */
    display: flex !important; /* Flexbox 사용 */
    flex-direction: column !important; /* 내부 요소들을 세로 방향으로 정렬 */
    justify-content: space-around !important; /* 내부 요소들이 세로 방향에서 균등하게 배치되도록 설정 */
}

.graph_box {
    width: 50%;
    min-width: 300px;
    overflow-x: auto; /* 가로 스크롤 추가 */
    display: flex; /* Flexbox 사용 */
    flex-direction: column; /* 내부 요소들을 세로 방향으로 정렬 */
}

.research_box, .graph_box {
    display: inline-block;
    vertical-align: top;
}

.research {
    margin-bottom: 10px;
}

.research.last {
    margin-bottom: 0;
}

.research p {
    font-weight: bold;
    margin-bottom: 5px;
}

.research ul {
    list-style-type: none;
    padding-left: 0;
}

.research ul li {
    margin-bottom: 5px;
}

.reasons-list {
    margin-left: 10px;
}
.reasons-list li {
    color: #007BFF; /* 선택사유의 색상 */
}

.graph_box .distribute {
    margin-bottom: 20px;
}

.survey-content {
    text-align: left;
}

.pop_btn {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

.pop_btn span {
    margin: 0 10px;
}

.pop_btn a {
    display: inline-block;
    padding: 10px 20px;
    text-decoration: none;
    color: #fff;
    border-radius: 5px;
}

.pop_btn .blue_r {
    background-color: #0056b3; /* 배경색 더 짙게 변경 */
}

.pop_btn .gray_r {
    background-color: #5a6268; /* 배경색 더 짙게 변경 */
}

.blue_l a {
    background-color: #0056b3;
}

.gray_l a {
    background-color: #5a6268;
}
</style>
</head>
<body>
<!-- w100% h450px -->
<div class="pop">
  <div class="pop_box">
    <h1>사유전체보기</h1>
    <div class="pop_list">
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl_type01" summary="설문조사">
        <caption>설문조사</caption>
        <colgroup>
          <col width="16%"/> <!-- 수정: 모든 열이 균등한 너비를 가지도록 조정 -->
	      <col width="16%"/>
	      <col width="16%"/>
	      <col width="20%"/>
	      <col width="16%"/>
	      <col width="20%"/> <!-- 상태를 나타내는 열에 조금 더 너비 할당 -->
        </colgroup>
        <tbody>
          <tr>
            <th>제목</th>
            <td colspan="6" class="tl"><strong><c:out value="${board.title}" escapeXml="true" /></strong></td>
          </tr>
          <tr>
            <th>시작일</th>
            <td class="tl">${board.startDate}</td>
            <th>종료일</th>
            <td class="tl">${board.endDate}</td>
            <th>상태</th>
            <td class="tl">
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
            </td>
          </tr>
          <!-- 상태를 한 행에 표시하는 부분을 제거 -->
          <tr>
            <th>문제수</th>
            <td class="tl">${fn:length(board.questions)}개</td>
            <th>참여자 수</th>
            <td colspan="3" class="tl">${participants}명</td>
          </tr>
        </tbody>
      </table>
      <div class="table-container">
<!--         <div class="research_box"> -->
<%--           <c:forEach var="question" items="${board.questions}" varStatus="status"> --%>
<%--             <input type="hidden" id="questionId" value="${question.questionId}"/> --%>
<%--             <div class="research ${status.last ? 'last' : ''} survey-content"> --%>
<%--               <p class="questionText" data-id="${question.questionId}"> --%>
<%--               	<c:out value="${status.index + 1}. ${question.questionText}" escapeXml="true" /> --%>
<!--               </p> -->
<!--               <ul> -->
<%--                 <c:forEach var="option" items="${question.options}" varStatus="optionStatus"> --%>
<!--                   <li> -->
<%--                   	<c:if test="${optionStatus.index + 1 eq 1}">①</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 2}">②</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 3}">③</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 4}">④</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 5}">⑤</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 6}">⑥</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 7}">⑦</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 8}">⑧</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 9}">⑨</c:if> --%>
<%--                    	<c:if test="${optionStatus.index + 1 eq 10}">⑩</c:if> --%>
<%--                   	<c:out value="${option.optionText}" escapeXml="true" /> --%>
<!--                   </li> -->
<%--                 </c:forEach> --%>
<!--               </ul> -->
<!--             </div> -->
<%--           </c:forEach> --%>
<!--         </div> -->
        
        <div id="research_box" class="research_box">
<%--         <c:choose> --%>
<%-- 		    <c:when test="${results != null}"> --%>
	          <c:forEach var="question" items="${board.questions}" varStatus="status">
	            <input type="hidden" id="questionId" value="${question.questionId}"/>
	            <div class="research ${status.last ? 'last' : ''} survey-content">
	              <p class="questionText" data-id="${question.questionId}">
	              	<c:out value="${status.index + 1}. ${question.questionText}" escapeXml="true" />
	              </p>
	              <ul id="question-${question.questionId}">
	                <c:forEach var="option" items="${question.options}" varStatus="optionStatus">
	                  <li id="option-${option.optionId}">
	                  	<c:if test="${optionStatus.index + 1 eq 1}">①</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 2}">②</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 3}">③</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 4}">④</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 5}">⑤</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 6}">⑥</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 7}">⑦</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 8}">⑧</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 9}">⑨</c:if>
	                   	<c:if test="${optionStatus.index + 1 eq 10}">⑩</c:if>
	                  	<c:out value="${option.optionText}" escapeXml="true" /> 선택사유:
		                   <ul class="reasons-list"></ul>
	                  </li>
	                </c:forEach>
	              </ul>
	            </div>
	          </c:forEach>
	          <div class="no-data">
	          </div>
<%-- 		    </c:when> --%>
<%-- 		    <c:otherwise> --%>
<!-- 		        <div class="research survey-content"> -->
<!-- 	              <p class="questionText"> -->
<%-- 	              	<c:out value="응답 데이터가 존재하지 않습니다."  /> --%>
<!-- 	              </p> -->
	              
<!-- 	            </div> -->
		        
<%-- 		    </c:otherwise> --%>
<%-- 		</c:choose> --%>
        </div>
        
      </div>
      
    </div> <!-- .pop_list의 끝 -->
    
    <p class="pt20"></p>
    <div class="pop_btn"> 
	    <span class="blue_l">
	    	<a href="#" onclick="self.close()" class="blue_r">확인</a>
	    </span> 
	    <span class="gray_l">
	    	<a href="#" onclick="self.close()" class="gray_r">취소</a>
	    </span> 
    </div>
  </div> <!-- .pop_box의 끝 -->
</div> <!-- .pop의 끝 -->
<script type="text/javascript">
	var results = ${results}
	console.log('results: ',results);
	//results는 { optionId: 202, questionId: 49, reason :  "더 맛있어서", responseDate:  "May 24, 2024, 10:09:26 AM", resultId: 22, selOptionNum: 2, surveyId: 45, userId: "jwyang" }와 같은 객체들로 이뤄진 리스트

	
	// 설문의 모든 질문에 대한 옵션 ID 목록을 얻는 함수
function getAllQuestionOptionIds() {
  var questionOptions = {}; // 질문 ID를 키로 하고 그에 대한 옵션 ID 배열을 값으로 하는 객체

  // 모든 질문 요소를 선택
  var questions = document.querySelectorAll('.survey-content');

  // 각 질문 요소에 대해 반복
  questions.forEach(function(question) {
    var questionId = question.querySelector('.questionText').getAttribute('data-id');
    if (questionId) { // 질문 ID가 존재하는 경우에만 실행
      questionOptions[questionId] = []; // 해당 질문 ID에 대한 빈 배열 초기화

      // 해당 질문의 모든 옵션 요소를 선택
      var options = question.querySelectorAll('li');
      options.forEach(function(option) {
        var optionId = option.getAttribute('id').split('-')[1]; // 옵션 ID 추출
        if (optionId) { // 옵션 ID가 존재하는 경우에만 배열에 추가
          questionOptions[questionId].push(optionId);
        }
      });
    }
  });

  return questionOptions; // 최종 객체 반환
}

// 함수 실행 예시
console.log('설문의 모든 질문에 대한 옵션 ID 목록:',getAllQuestionOptionIds());

	
	
	
function displayResults(results) {
    var questionOptions = getAllQuestionOptionIds(); // 모든 질문에 대한 옵션 ID 목록을 얻음
    var questions = {};
    
    if (!results || results.length === 0) {
        // 데이터가 없는 경우 처리
        document.querySelectorAll('.survey-content').forEach(function(question) {
            var reasonList = question.querySelector('.reasons-list');
            if (reasonList) {
                var listItem = document.createElement('li');
                listItem.textContent = '응답 데이터가 존재하지 않습니다.';
                reasonList.appendChild(listItem);
            }
        });
        return; // 데이터가 없는 경우 이 후의 처리를 건너뛰기 위해 return
    }

    results.forEach(result => {
        if (!questions[result.questionId]) {
            questions[result.questionId] = {};
        }
        if (!questions[result.questionId][result.optionId]) {
            questions[result.questionId][result.optionId] = {
                reasons: [],
                hasReason: false // 선택사유 존재 여부 확인을 위한 플래그
            };
        }
        questions[result.questionId][result.optionId].reasons.push(result.reason);
        // 선택사유가 null, undefined, 또는 빈 문자열이 아닌 경우에 플래그를 true로 설정
        if (result.reason !== null && result.reason !== undefined && result.reason !== '') {
            questions[result.questionId][result.optionId].hasReason = true;
        }
    });

    console.log('questions: ', questions);

    Object.keys(questionOptions).forEach(questionId => {
        questionOptions[questionId].forEach(optionId => {
            var reasonList = document.querySelector('#question-'+questionId+' #option-'+optionId+' .reasons-list');
            if (reasonList) {
                if (!questions[questionId] || !questions[questionId][optionId] || !questions[questionId][optionId].hasReason) {
                    // 선택사유가 전혀 없는 경우, '선택사유 없음'을 추가
                    var listItem = document.createElement('li');
                    listItem.textContent = '선택사유 없음';
                    reasonList.appendChild(listItem);
                } else {
                    // 선택사유가 하나라도 있는 경우, 해당 사유를 모두 추가
                    questions[questionId][optionId].reasons.forEach(reason => {
                        var listItem = document.createElement('li');
                        listItem.textContent = reason;
                        reasonList.appendChild(listItem);
                    });
                }
            }
        });
    });
}

window.addEventListener('DOMContentLoaded', function() {
	if (results && results.length > 0) {
	    displayResults(results);
	} else {
		document.querySelectorAll('.research.survey-content').forEach(function(element) {
		    element.remove();
		});

		var noDataGlobal = document.createElement("div");
	    noDataGlobal.textContent = "응답 데이터가 존재하지 않습니다.";
	    document.querySelector('.no-data').appendChild(noDataGlobal);
	}
	  
});
	
</script>
</body>
</html>
