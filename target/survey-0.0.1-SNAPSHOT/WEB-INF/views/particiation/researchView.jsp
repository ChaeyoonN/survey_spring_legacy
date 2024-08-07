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
document.addEventListener('DOMContentLoaded', function name() {
});
window.onload = function() {
	const msgForDelete = new URLSearchParams(window.location.search).get('msgForDelete');
	if (msgForDelete) {
		handleDeleteResponse(msgForDelete);
	}
	
	const msgForEditPage = '${msgForEditPage}';
	const doMessage = '${message}';
	console.log(doMessage);
	if(msgForEditPage === 'loginRequired') {
		alert('로그인이 필요한 기능입니다.');
    	window.location.href = "${pageContext.request.contextPath}/particiation/login";
    }
	if(msgForEditPage === 'noAuthority') {
    	alert('권한이 없습니다.');
    }
	if(msgForEditPage === 'surveyOngoing') {
		alert('진행중인 설문은 수정할 수 없습니다.');
    }
	if(msgForEditPage === 'surveyComplete') {
		alert('완료된 설문은 수정할 수 없습니다.');
    }
	if(doMessage === 'loginRequired') {
    	alert('로그인이 필요합니다.');
    	window.location.href = "${pageContext.request.contextPath}/particiation/login";
    }
	if(doMessage === 'alreadyParticipated') {
		alert("이미 이 설문에 참여하셨습니다.");
    }
}

function handleDeleteResponse(msgForDelete) {
	if(msgForDelete === 'loginRequired'){
    	alert('로그인이 필요한 기능입니다.');   
    	location.href = "${pageContext.request.contextPath}/particiation/login";
    }
	if(msgForDelete === 'noAuthority'){
    	alert('권한이 없습니다.');
    }
	if(msgForDelete === 'surveyOngoing'){
    	alert('진행중인 설문은 삭제할 수 없습니다.');
    }
	if(msgForDelete === 'deleteSuccess'){
    	alert('삭제되었습니다.');
    	location.href = "${pageContext.request.contextPath}/particiation/researchList";
    }
	if(msgForDelete === 'deleteFailed'){
    	alert('삭제에 실패했습니다. 관리자에게 문의하세요.');
    }
}
function survey_delete() {
	//document.getElementById('boardDetailForm').submit();
	const surveyId = '${board.surveyId}'; // 설문 ID를 가져옵니다.
	fetch('${pageContext.request.contextPath}/particiation/researchDelete?surveyId='+surveyId, {
		method: 'POST',
	})
	.then(response => response.json())
	.then(data => {
		const msgForDelete = data.msgForDelete;
		handleDeleteResponse(msgForDelete);
	})
	.catch(error => {
		console.error('Error:', error);
		alert('서버와 통신 중 오류가 발생했습니다.');
	});
}
//결과보기 팝업
function result_popup(surveyId, pageNo, amount, keyword, condition) {
	var name = "researchResultPopup";
    var option = "width = 900, height = 600, top = 100, left = 200, location = no";
    //var surveyId = $('#h_surveyId').val();
//     console.log(surveyId);
//     pageNo=${pc.page.pageNo}
//     amount=${pc.page.amount}
//     keyword=${pc.page.keyword}
//     condition=${pc.page.condition}

//     var url = "${pageContext.request.contextPath}/particiation/researchPopup?id=${vo.surveyId}&pageNo=${pc.page.pageNo}&amount=${pc.page.amount}&keyword=${pc.page.keyword}&condition=${pc.page.condition}";
    var url = "${pageContext.request.contextPath}/particiation/researchPopup?id="+surveyId+"&pageNo="+pageNo+"&amount="+amount+"&keyword="+keyword+"&condition="+condition;
    window.open(url, "researchPopup", "width=900, height=600, scrollbars=yes");
}
function result_reason(surveyId, pageNo, amount, keyword, condition) {
	var name = "researchReasonPopup";
    var option = "width = 900, height = 600, top = 100, left = 200, location = no";
    var url = "${pageContext.request.contextPath}/particiation/researchChoiceReasonPopup?id="+surveyId+"&pageNo="+pageNo+"&amount="+amount+"&keyword="+keyword+"&condition="+condition;
    window.open(url, "researchPopup", "width=900, height=600, scrollbars=yes");
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
	          action="<c:url value='${pageContext.request.contextPath}/particiation/researchEdit'/>"
	          method="post"
	        >
	        <input type="hidden" name="surveyId" value="${board.surveyId}" />
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
              <tr>
               <td colspan="6" class="tl">
               <c:forEach var="question" items="${board.questions}" varStatus="status">
               	   <div class="research ${status.last ? 'last' : ''}">
<%--                        <p>${status.index + 1}. ${question.questionText}</p> --%>
                       <p><c:out value="${status.index + 1}. ${question.questionText}" escapeXml="true" /></p>
                        <ul>
                        <c:forEach var="option" items="${question.options}" varStatus="optionStatus">
<%--                             <li>${optionStatus.index + 1} ${option.optionText}</li> --%>
                            <li class="option-item">
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
<%--                             		${option.optionText} --%>
                            </li>
                        </c:forEach>
<%--                         <li>선택사유 <input type="text" id="reason${status.index}" name="reason${status.index}" class="inp" style="width:200px;" /> </li> --%>
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
                    
                    
              </c:forEach>
               </td>
              </tr>
              
<!--               <tr class="fileRow"> -->
<!--                <th class="fileTh"> -->
<!--                <span class="fileSpan">첨부파일</span> -->
<!--                </th> -->
<!--                <td colspan="5" class="tl file-container"><img src="/img/sub/btn/btn_pdf.gif" alt="pdf" /></td> -->
<!--               </tr> -->
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
		
          <c:choose>
		    
		    <c:when test="${board.startDate != null and nowDate != null and DateUtils.isAfter(board.startDate, nowDate)}">
		        <span class="wte_l">
		        	<c:choose>
			           <c:when test="${myPage eq true}">
			             <a href="${pageContext.request.contextPath}/particiation/researchMyList?userId=${loginUser.userId}&pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">목록</a>
			           </c:when>
			           <c:otherwise>
			        	<a href="${pageContext.request.contextPath}/particiation/researchList?pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">목록</a>
			           </c:otherwise>
			        </c:choose>
		        </span>
		        <c:if test="${loginUser.adminYn == '0' || loginUser.userId == board.creator}">
		            <span class="wte_l"><a href="${pageContext.request.contextPath}/particiation/researchEdit?id=${board.surveyId}" class="wte_r">수정</a></span>
		            <span class="wte_l"><a id="delA" href="javascript:survey_delete();" onclick="return confirm('삭제하시겠습니까?')" class="wte_r">삭제</a></span>
		        </c:if>
		    </c:when>
		    
		    <c:when test="${board.startDate != null and nowDate != null and board.endDate != null and DateUtils.isBeforeOrEqual(board.startDate, nowDate) and DateUtils.isAfterOrEqual(board.endDate, nowDate)}">
		        <!-- 진행중 상태이므로 수정,삭제 버튼은 숨김 처리 -->
		        <span class="wte_l">
		        	<c:choose>
			           <c:when test="${myPage eq true}">
			             <a href="${pageContext.request.contextPath}/particiation/researchMyList?userId=${loginUser.userId}&pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">목록</a>
			           </c:when>
			           <c:otherwise>
			        	<a href="${pageContext.request.contextPath}/particiation/researchList?pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">목록</a>
			           </c:otherwise>
			        </c:choose>
		        </span>
		        <span class="wte_l">
		        	<a href="${pageContext.request.contextPath}/particiation/researchDoInView?id=${board.surveyId}&pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">설문참여</a>
		        </span>
		    	<c:if test="${loginUser.adminYn == '0'}">
		            <span class="per_l">
		            	<a class="pre_r" href="javascript:void(0);" onclick="result_popup('${board.surveyId}','${pc.page.pageNo}','${pc.page.amount}','${pc.page.keyword}','${pc.page.condition}')">결과보기</a>
		            </span>
		            <span class="wte_l">
		            	<a href="javascript:void(0);" onclick="result_reason('${board.surveyId}','${pc.page.pageNo}','${pc.page.amount}','${pc.page.keyword}','${pc.page.condition}')" class="wte_r">사유전체보기</a>
		            </span>
		        </c:if>
		    </c:when>
		    
		    <c:otherwise>
		        <span class="wte_l">
		        	<c:choose>
			           <c:when test="${myPage eq true}">
			             <a href="${pageContext.request.contextPath}/particiation/researchMyList?userId=${loginUser.userId}&pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">목록</a>
			           </c:when>
			           <c:otherwise>
			        	<a href="${pageContext.request.contextPath}/particiation/researchList?pageNo=${page.pageNo}&amount=${page.amount}&keyword=${page.keyword}&condition=${page.condition}" class="wte_r">목록</a>
			           </c:otherwise>
			        </c:choose>
		        </span>
		        <c:if test="${loginUser.adminYn == '0' || loginUser.userId == board.creator}">
		            <span class="wte_l"><a id="delA" href="javascript:survey_delete();" onclick="return confirm('삭제하시겠습니까?')" class="wte_r">삭제</a></span>
		        </c:if>
		            <span class="per_l">
		            	<a class="pre_r" href="javascript:void(0);" onclick="result_popup('${board.surveyId}','${pc.page.pageNo}','${pc.page.amount}','${pc.page.keyword}','${pc.page.condition}')">결과보기</a>
		            </span>
		            <span class="wte_l">
		            	<a href="javascript:void(0);" onclick="result_reason('${board.surveyId}','${pc.page.pageNo}','${pc.page.amount}','${pc.page.keyword}','${pc.page.condition}')" class="wte_r">사유전체보기</a>
		            </span>
		    </c:otherwise>
		</c:choose>
          
          
          

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
