<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.spring.survey.utils.DateUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>서울학교급식포털</title>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
 	<link href="/css/common.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
<style>
.pop {
    position: fixed; /* 위치를 고정시켜 화면 전체에 표시 */
    top: 0;
    left: 0;
    width: 100%; /* 너비를 화면 전체로 설정 */
    height: 100%; /* 높이를 화면 전체로 설정 */
    /* background-color: rgba(0, 0, 0, 0.4); 배경색을 어둡게 하여 내용이 더 잘 보이게 함 */
    z-index: 1000; /* 다른 요소들 위에 표시되도록 z-index 설정 */
    display: flex; /* 내부 요소를 중앙에 위치시키기 위해 flexbox 사용 */
    justify-content: center; /* 가로 방향으로 중앙 정렬 */
    align-items: center; /* 세로 방향으로 중앙 정렬 */
/*     overflow: auto; */
	overflow-y:scroll; 
}
.pop_box {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 100%;
    height: 100%;
/*     max-width: 900px; */
/*     background-color: #fff; */
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
/*     overflow: hidden; /* 내부 요소가 바깥 요소를 넘지 않도록 설정 */ */
}
.pop_list {
    width: 100%;
/*     max-width: 900px; */
    flex-grow: 1; /* 남은 공간을 채우도록 설정 */
/*     overflow: hidden; /* 내용이 넘치지 않도록 설정 */ */
}
.table-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px 20px 20px 0px;
    width:100%;
}

.research_box {
    width: 96%;
    background-color: #fff;
    border-radius: 8px;
    padding: 15px;
    height: 100%;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.row {
    display: flex;
    justify-content: space-between;
	width: 100%;
}

.research {
    width: 50%;
    background-color: #f5f5f5;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.g-side {
    width: 50%;
    background-color: #f5f5f5;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.questionText {
    font-weight: bold;
    margin-bottom: 10px;
}

ul {
    list-style-type: none;
    padding: 0;
}

li {
    margin-bottom: 5px;
}

.pop_btn {
    margin-top: 20px;
    text-align: center;
}

.pop_btn .blue_l, .pop_btn .gray_l {
    margin: 0 10px;
}

.pop_btn a {
    text-decoration: none;
    padding: 10px 20px;
    border-radius: 4px;
    color: #fff;
}

.pop_btn .blue_r {
    background-color: #007bff;
}

.pop_btn .gray_r {
    background-color: #6c757d;
}
</style>

</head>
<body>
<%
    LocalDate nowDate = LocalDate.now();
    pageContext.setAttribute("nowDate", nowDate);
%>
<div class="pop">
  <div class="pop_box">
    <h1>결과보기</h1>
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
          <tr>
            <th>문제수</th>
            <td class="tl">${fn:length(board.questions)}개</td>
            <th>참여자 수</th>
            <td colspan="3" class="tl">${participants}명</td>
            
          </tr>
        </tbody>
      </table>
      <div class="table-container">
         <div class="research_box">
        <c:forEach var="question" items="${board.questions}" varStatus="status">
            <input type="hidden" id="questionId" value="${question.questionId}"/>
            <div class="row">
                <div class="research ${status.last ? 'last' : ''} survey-content">
                    <p class="questionText" data-id="${question.questionId}">
                        <c:out value="${status.index + 1}. ${question.questionText}" escapeXml="true" />
                    </p>
                    <ul>
                        <c:forEach var="option" items="${question.options}" varStatus="optionStatus">
                            <li>
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
                                <c:out value="${option.optionText}" escapeXml="true" />
                            </li>
                        </c:forEach>
                    </ul>
                </div>
                <div class="g-side graph_box" id="graph_box-${question.questionId}">
                    <!-- 문제에 따른 그래프들이 여기에 들어갑니다  -->
                </div>
            </div> <!-- .row 끝 -->
        </c:forEach>
    </div>
      </div> <!-- table-container 끝 -->
    </div>
    <div class="pop_btn">
      <span class="blue_l"><a href="#" onclick="self.close()" class="blue_r">확인</a></span>
      <span class="gray_l"><a href="#" onclick="self.close()" class="gray_r">취소</a></span>
    </div>
  </div>
</div>

<script>
//랜덤 색상 생성 함수
function colorize() {
	var r = Math.floor(Math.random() * 200);
	var g = Math.floor(Math.random() * 200);
	var b = Math.floor(Math.random() * 200);
	var color = 'rgba(' + r + ', ' + g + ', ' + b + ', 0.2)';
	return color;
}
var chartCount = 0; // 차트 순번을 추적하기 위한 전역 변수

    window.onload = function() {
        var responses = ${responses}; // 서버로부터 받은 응답 데이터
        console.log('responses: ',responses);
        var results = ${results}; // 서버로부터 받은 응답 데이터
        console.log('results: ',results);
        var options = JSON.parse('${options}'); // 서버로부터 받은 옵션 데이터
        console.log('options: ', options);
        /* OPTIONS의 형태는 아래와 같음.
         [
			{
			"OPTION_ID": 341,
			"OPTION_TEXT": "60대 이상",
			"QUESTION_ID": 93
			},  {
			"OPTION_ID": 342,
			"OPTION_TEXT": "70대 이상",
			"QUESTION_ID": 93
			}
		]
        */
        
        // 모든 질문 요소를 선택
        var questions = document.querySelectorAll('.questionText');
        var questionTexts = {};
        // 각 질문 요소를 순회하며 값 얻기
        questions.forEach(function(question) {
            var id = question.getAttribute('data-id'); // 데이터 속성에서 id 값 얻기
            var text = question.textContent; // 요소의 텍스트 내용 얻기
            questionTexts[id] = text; // 질문 ID와 텍스트 매핑 저장
        });
       
        // 질문별로 응답을 그룹화
        var groupedResponses = responses.reduce(function(acc, response) {
            if (!acc[response.questionId]) {
                acc[response.questionId] = [];
            }
            acc[response.questionId].push(response);
            return acc;
        }, {});

        if (responses.length > 0) {
            Object.keys(groupedResponses).forEach(function (questionId) {
            	 chartCount++; // 차트 생성 시 차트 순번 증가

           	    var chartTitle = "문제 " + chartCount; // 차트 타이틀에 순번 포함
//            	    var chartSubtitle = "서브타이틀 예시 (" + chartCount + "번째 차트)"; // 차트 서브타이틀에 순번 포함
            	
            	var questionResponses = groupedResponses[questionId];
                var totalResponses = questionResponses.reduce((total, response) => total + response.responseCount, 0);
                var optionMap = {};

                // 모든 옵션을 optionMap에 추가하고, 응답 수를 0으로 초기화
                options.forEach(function (option) {
                    if (option.QUESTION_ID == questionId) { // QUESTION_ID가 일치하는 옵션만 추가
                        optionMap[option.OPTION_ID] = { ...option, responseCount: 0, selOptionNum: option.OPTION_ID };
                    }
                });

                // 응답이 있는 옵션에 대해 응답 수 업데이트
                questionResponses.forEach(function (response) {
                    if (optionMap[response.optionId]) {
                        optionMap[response.optionId].responseCount = response.responseCount;
                        optionMap[response.optionId].selOptionNum = response.selOptionNum; // selOptionNum 업데이트
                        optionMap[response.optionId].OPTION_TEXT = response.optionText; // OPTION_TEXT 업데이트
                    }
                });

                var finalResponses = Object.values(optionMap).sort((a, b) => a.optionId - b.optionId);

//              var labels = finalResponses.map(response => response.OPTION_TEXT);
				var labels = finalResponses.map((response, index) => {
					var no = "";
				    switch (index + 1) { // 배열의 인덱스는 0부터 시작하므로 +1을 해줌
				        case 1:
				            no = "① ";
				            break;
				        case 2:
				            no = "② ";
				            break;
				        case 3:
				            no = "③ ";
				            break;
				        case 4:
				            no = "④ ";
				            break;
				        case 5:
				            no = "⑤ ";
				            break;
				        case 6:
				            no = "⑥ ";
				            break;
				        case 7:
				            no = "⑦ ";
				            break;
				        case 8:
				            no = "⑧ ";
				            break;    
				        case 9:
				            no = "⑨ ";
				            break;
				        case 10:
				            no = "⑩ ";
				            break;
				        default:
				            no = (index + 1) + " "; // 10개를 초과하는 경우 숫자로 표시
				    }
				    var optionTextWithNo = no + response.OPTION_TEXT;
				    return optionTextWithNo.length > 8 ? optionTextWithNo.substring(0, 8) + "..." : optionTextWithNo;
				});
				console.log('labels: ',labels);
                var data = finalResponses.map(response => response.responseCount);
                var colors = finalResponses.map((response, index) => `rgba(${index} * 30, ${index} * 60, ${index} * 90, 0.2)`);
                var datalabels = finalResponses.map(response => {
                var percentage = ((response.responseCount / totalResponses) * 100).toFixed(0);
                    return response.responseCount + '건 (' + percentage + '%)';
                });

                var canva = document.createElement("canvas");
                canva.id = "surveyChart" + questionId;
//                 canva.width = 200;
// 	            canva.height = 100;
	            canva.style.minHeight = '200px';
// 	            canva.style.minWidth = '300px';
// 				canva.style.display = 'block';  // 세로로 배치되도록 블록 요소로 설정
// 				canva.style.marginBottom = '10px';  // 각 canvas 요소 사이의 간격 조절
                document.getElementById('graph_box-'+questionId).appendChild(canva);

                var ctx = document.getElementById('surveyChart' + questionId).getContext('2d');
                var chart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: '응답자수',
                            data: data,
                            backgroundColor: 'rgba(75, 192, 192, 1)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true, // true가 기본값
// 						maintainAspectRatio: false, // 차트의 비율 유지를 비활성화하여 부모 컨테이너에 맞춤
// 				        layout: {
// 				            padding: {
// 				                left: 50,
// 				                right: 50,
// 				                top: 50,
// 				                bottom: 50
// 				            }
// 				        },
                        scales: {
                            x: {
                                beginAtZero: true,
                                suggestedMax: Math.max(...data) + 1,
                                ticks: {
                                    stepSize: 1,
                                    autoSkip: false,
                                    maxRotation: 45,
                                    minRotation: 0
                                }
                            },
                            y: {
                                beginAtZero: true,
                                ticks: {
                                	min: labels.length,
            						max: labels.length
//             						fontSize : 14,
            					}
                            }
                        },
                        indexAxis: 'y',
                        plugins: {
                        	 title: {
                                 display: true,
                                 text: chartTitle // 차트 타이틀 설정
                             },
//                              subtitle: {
//                                  display: true,
//                                  text: chartSubtitle // 차트 서브타이틀 설정
//                              },
                            datalabels: {
                                anchor: 'end',
                                align: 'end',
                                font: {
                                    weight: 'bold' // 글꼴 굵기를 진하게 설정
                                },
                                formatter: function (value, context) {
                                    return datalabels[context.dataIndex];
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                });
            });
        } else {
        	var noDataEle = document.createElement("div");
            noDataEle.textContent = "응답 데이터가 존재하지 않습니다.";
            noDataEle.setAttribute("id", "noDataDiv" );
//        	    noDataEle.style.display = "block"; 
//             noDataEle.style.textAlign = "left";
			document.querySelector('.research_box').replaceChildren();
            document.querySelector('.research_box').appendChild(noDataEle); 
        }
        
    };
</script>

</body>
</html>
