<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.spring.survey.utils.DateUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>서울학교급식포털</title>
<link href="/css/base.css" rel="stylesheet" type="text/css" />
<link href="/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/jquery-1.7.2.min.js"></script>
<style>
.surveyListTitle {
font-weight:bold;
font-size: 20px !important;
font-family: dotum, AppleGothic, sans-serif;
}
</style>
<script type="text/javascript">
//문서가 준비되면 실행
document.addEventListener('DOMContentLoaded', function() {
    // 모든 '선택사유' 입력란에 대해 이벤트 리스너 등록
    document.querySelectorAll('input[name*="questions["][name*="].reason"]').forEach(function(input) {
        input.addEventListener('input', function() {
            // 입력값의 길이가 50자를 초과하면
            if (this.value.length > 50) {
                // 사용자에게 경고
                alert('선택사유는 최대 50자까지 입력 가능합니다.');
                // 초과분 자르기
                this.value = this.value.substr(0, 50);
                // 초점 다시 맞추기
                this.focus();
            }
        });
    });
});
window.onload = function() {

}
function formToObject(formSelector) {
    const form = document.querySelector(formSelector);
    const formData = new FormData(form);
    const result = {
        questions: [],
        surveyId: '',
        userId: ''
    };

    formData.forEach((value, key) => {
        if (key === 'surveyId' || key === 'userId') {
            result[key] = value;
        } else {
            const questionMatch = key.match(/^questions\[(\d+)]/);
            if (questionMatch) {
                const questionIndex = parseInt(questionMatch[1], 10);
                if (!result.questions[questionIndex]) { // 폼 변환 결과 넣을 객체 비어있으면
                    result.questions[questionIndex] = { questionId: null, selOptionNum: null, reason: '', options: [] };
                }
				
                if(key.includes('questionId')) {
                	result.questions[questionIndex].questionId = value;
                } else if(key.includes('selOptionNum')) {
                	result.questions[questionIndex].selOptionNum = Number(value) + 1;
                } else if(key.includes('reason')) {
                	result.questions[questionIndex].reason = value;
                } else { // options 라는 [ ] 인 경우
                	const optionMatch = key.match(/options\[(\d+)]/);
                	if (optionMatch) {
                        const optionIndex = parseInt(optionMatch[1], 10);
                        result.questions[questionIndex].options[optionIndex] = { optionId: value };
                    }
                	
                }
                
            }
        }
    });

    return result;
}
function sendPost() {
    // 각 질문에 대해 선택된 옵션이 있는지 확인
    const questions = document.querySelectorAll('[id^="reason"]');
    let allSelected = true;
    
    for (let i = 0; i < questions.length; i++) {
        const questionIndex = questions[i].id.replace('reason', '');
        const selectedOption = document.querySelector("input[name='questions["+questionIndex+"].selOptionNum']:checked");

        console.log(selectedOption);
        if (!selectedOption) {
            allSelected = false;
            break;
        }
    }
	//document.getElementById('boardDetailForm').submit();
    // 모든 질문에 대한 응답이 있을 경우에만 제출
    if (allSelected) {
        const obj = formToObject('#boardDetailForm');
        console.log(obj);
        console.log(JSON.stringify(obj));
        if(!confirm('설문을 제출하시겠습니까?\n( 한번 제출한 응답은 수정할 수 없습니다. )')) {
        	return;
        }
        $.ajax({
            url: '${pageContext.request.contextPath}/particiation/researchDo',
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(obj),
            success: function (data) {
                console.log('응답 data: ', data);
                alert("응답을 제출했습니다.");
                location.href = "${pageContext.request.contextPath}/particiation/researchList";
            },
            error: function (xhr, status, error) {
                alert("응답 제출에 실패했습니다. 다시 시도해 주세요.");
            }
        });
    } else {
        // 하나 이상의 질문에 대한 응답이 없음을 사용자에게 알림
        alert("모든 질문에 대해 응답해주세요.");
    }
}
</script>
</head>
<body>
<%
    LocalDate nowDate = LocalDate.now();
    pageContext.setAttribute("nowDate", nowDate);
%>
<div id="wrap"> 
  <!--skip S-->
  <ul id="skipnavi">
    <li><a href="#gnb">주메뉴 바로가기</a></li>
    <li><a href="#contents">메인내용 바로가기</a></li>
    <li><a href="#footer">하단 바로가기</a></li>
  </ul>
  <!--skip E--> 
  
  <jsp:include page="/WEB-INF/views/particiation/header.jsp" />
  
  <!-- container-->
  <div id="container">
    <div id="contents">
      <h2>메인내용</h2>
      <p><img src="/img/sub/info/sub_vimg_01.jpg" alt="건강한 급식 행복한 학교" /></p>
      <ul class="lnb">
        <li><img src="/img/sub/particiation/sub_title_01.gif" alt="알림마당" /></li>
        <li><a href="#"><img src="/img/sub/particiation/sub_stitle_01Off.gif" alt="학교급식인력풀" /></a></li>
        <li><a href="#"><img src="/img/sub/particiation/sub_stitle_02Off.gif" alt="영양(교)사이야기" /></a></li>
        <li><a href="#"><img src="/img/sub/particiation/sub_stitle_03Off.gif" alt="조리(원)사이야기" /></a></li>
        <li><a href="#"><img src="/img/sub/particiation/sub_stitle_04Off.gif" alt="자유게시판" /></a></li>
        <li><a href="${pageContext.request.contextPath}/particiation/researchList"><img src="/img/sub/particiation/sub_stitle_05On.gif" alt="설문조사" /></a></li>
      </ul>
      <div class="right_box">
<!--         <h3><img src="/img/sub/particiation/title_04.gif" alt="급식기구관리전환" /></h3> -->
        <h3 class="surveyListTitle">설문조사</h3>
        <p class="history"><img src="/img/sub/history_home.gif" alt="home" /> 알림마당 <img src="/img/sub/history_arrow.gif" alt="다음" /> <strong>설문조사</strong></p>
        <p class="pt30"></p>
       
        <div class="tbl_box">
           <form
	          name="boardDetailForm"
	          id="boardDetailForm"
	          action="<c:url value='${pageContext.request.contextPath}/particiation/researchDo'/>"
	          method="post"
	        >
	        <input type="hidden" name="surveyId" value="${board.surveyId}" />
	        <input type="hidden" name="userId" value="${loginUser.userId}" /> <!-- 유저 ID를 hidden 필드로 추가 -->
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl_type01" summary="설문조사">
            <caption>
            설문조사
            </caption>
            <colgroup>
            <col width="20%"/>
            <col width="25%"/>
            <col width="25%"/>
<%--             <col width="20%"/> --%>
<%--             <col width="15%"/> --%>
            <col width="30%"/>
            </colgroup>
            <tbody>
              <tr>
                <th>제목</th>
                <td colspan="5" class="tl"><strong><c:out value="${board.title}" escapeXml="true" /></strong></td>
                </tr>
              <tr>
                <th>시작일</th>
                <td class="tl">${board.startDate}</td>
                <th>종료일</th>
                <td class="tl">${board.endDate}</td>
<!--                 <th>결과확인</th> -->
<!--                 <td class="tl"> -->
<%--                 	<c:if test="${board.startDate != null and board.endDate != null and nowDate != null and DateUtils.isSurveyOutsidePeriod(nowDate, board.startDate, board.endDate)}">  --%>
<%--                 	<a href="javascript:void(0);" onclick="result_popup('${board.surveyId}','${pc.page.pageNo}','${pc.page.amount}','${pc.page.keyword}','${pc.page.condition}')"><img src="/img/sub/btn/btn_view.gif" alt="결과보기" /></a> --%>
<%--                 	</c:if> --%>
<!--                 </td> -->
              </tr>
              <tr>
                <th>문제수</th>
                <td colspan="5" class="tl">${fn:length(board.questions)}개</td>
                </tr>
               <c:forEach var="question" items="${board.questions}" varStatus="status">
               	<input type="hidden" name="questions[${status.index}].questionId" value="${question.questionId}" />
              <tr>
               <td colspan="6" class="tl">
               	   <div class="research">
<%--                        <p>${status.index + 1}. ${question.questionText}</p> --%>
                       <p><c:out value="${status.index + 1}. ${question.questionText}" escapeXml="true" /></p>
                        <ul>
                        <c:forEach var="option" items="${question.options}" varStatus="optionStatus">
<%--                             <li>${optionStatus.index + 1} ${option.optionText}</li> --%>
                            	<input type="hidden" name="questions[${status.index}].options[${optionStatus.index}].optionId" value="${option.optionId}" />
                            <li>
                            	<input type="radio" id="question${status.index}_option${optionStatus.index}" name="questions[${status.index}].selOptionNum" value="${optionStatus.index}" />
<%--                             	<label for="question${status.index}_option${optionStatus.index}"> --%>
<%--                                    <c:out value="${option.optionText}" escapeXml="true" /> --%>
<!--                                </label> -->
                               <c:if test="${optionStatus.index + 1 eq 1}">
							            <label for="question${status.index}_option${optionStatus.index}">①</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 2}">
							            <label for="question${status.index}_option${optionStatus.index}">②</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 3}">
							            <label for="question${status.index}_option${optionStatus.index}">③</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 4}">
							            <label for="question${status.index}_option${optionStatus.index}">④</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 5}">
							            <label for="question${status.index}_option${optionStatus.index}">⑤</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 6}">
							            <label for="question${status.index}_option${optionStatus.index}">⑥</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 7}">
							            <label for="question${status.index}_option${optionStatus.index}">⑦</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 8}">
							            <label for="question${status.index}_option${optionStatus.index}">⑧</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 9}">
							            <label for="question${status.index}_option${optionStatus.index}">⑨</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 10}">
							            <label for="question${status.index}_option${optionStatus.index}">⑩</label>
							        </c:if><c:out value="${option.optionText}" escapeXml="true" />
                            </li>
                        </c:forEach>
                        <li>선택사유 <input type="text" id="reason${status.index}" name="questions[${status.index}].reason" class="inp" style="width:200px;" /> </li>
                        </ul>
					</div>
<!--                     <div class="research"> -->
<!--                        <p>1. 위생불량 납품단절 편함</p> -->
<!--                         <ul> -->
<!--                         <li>① 매우그렇다</li> -->
<!--                         <li>② 조금그렇다</li> -->
<!--                         <li>③ 그렇다</li> -->
<!--                         <li>④ 조금 아니다</li> -->
<!--                         <li>⑤ 매우 아니다</li> -->
<!--                         <li>선택사유 <input type="text" id="aa" name="aa" class="inp" style="width:200px;" /> </li> -->
<!--                         </ul> -->
<!-- 					</div> -->
                    
                    
               </td>
              </tr>
              </c:forEach>
              
              <c:if test="${not empty files}">
				    <tr class="fileRow">
				        <th class="fileTh">
				            <span class="fileSpan">첨부파일</span>
				        </th>
				        <td colspan="5" class="tl file-container">
				            <c:forEach items="${files}" var="file">
<%-- 				                <c:choose> --%>
<%-- 				                    <c:when test="${fn:endsWith(file.fileName, '.pdf')}"> --%>
<!-- 				                        <img src="/img/sub/btn/btn_pdf.gif" alt="pdf" /> -->
<%-- 				                    </c:when> --%>
<%-- 				                    <c:otherwise> --%>
<!-- 				                        <img src="/img/sub/btn/btn_down.gif" alt="file" /> -->
<%-- 				                    </c:otherwise> --%>
<%-- 				                </c:choose> --%>
				                <img src="/img/sub/btn/btn_down.gif" alt="file" />
				                <a href="${pageContext.request.contextPath}/particiation/download?fileId=${file.fileId}&surveyId=${board.surveyId}" title="${file.originFileName}">${file.originFileName}</a><br/>
				                <!-- 파일 다운로드 링크. 실제 다운로드 경로는 애플리케이션 설정에 따라 달라질 수 있습니다. -->
				            </c:forEach>
				        </td>
				    </tr>
				</c:if>
              
            </tbody>
          </table>
          </form>
          <p class="pt40"></p>
          <!-- btn--> 
          <span class="bbs_btn"> 
		
		<span class="wte_l"><a href="${pageContext.request.contextPath}/particiation/researchList?pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">목록</a></span>
        <span id="reg" class="per_l"><a href="javascript:void(0);" class="pre_r" onclick="sendPost();">제출</a></span>
        <span class="wte_l"><a href="${pageContext.request.contextPath}/particiation/researchList?pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">취소</a></span>
        
          </span> 
          <!-- //btn--> 
          
        </div>
      </div>
      
      <p class="bottom_bg"></p>
    </div>
  </div>
  <!-- //container-->
  
  <div id="footer">
    <h2>하단</h2>
    <address>
    110-781) 서울특별시 종로구 송월길 48(신문로 2-77)
    </address>
    <p>COPYRIGHT(C) 2013 <b>SEOUL metropolitan office of education</b> ALL RIGHT RESERVED</p>
    <ul>
      <li class="bn"><a href="#">개인정보보호정책</a></li>
      <li><a href="#">이메일 무단수집거부</a></li>
      <li><a href="#">뷰어프로그램</a></li>
      <li><a href="#">저작권보호</a></li>
      <li><a href="#">서울학교급식 배너다운로드</a></li>
    </ul>
  </div>
</div>

</body>
</html>
