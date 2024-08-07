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
.survey-title {
  display: block; /* 또는 inline-block; 줄 바꿈 없이 한 줄로 표시 */
  max-width: 250px; /* 최대 너비 설정, 실제 사용 환경에 맞게 조정 필요 */
  white-space: nowrap; /* 텍스트를 한 줄로 표시 */
  overflow: hidden; /* 내용이 넘칠 경우 숨김 처리 */
  text-overflow: ellipsis; /* 넘친 텍스트를 ...으로 표시 */
}
.top-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.excel-wrap {
    text-align: right;
}

.countSurveyDiv {
    text-align: right;
}

/* 추가적인 스타일링 */
.excelDown {
    background-color: #4CAF50; /* 녹색 배경 */
    border: none;
    border-radius: 3px;
    color: white;
    padding: 5px 10px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 12px;
    margin: 4px 2px;
    cursor: pointer;
}

.countDiv {
    display: inline-block;
}
</style>
<script type="text/javascript">

//브라우저 창이 로딩이 완료된 후에 실행할 것을 보장하는 이벤트.
document.addEventListener('load', function() {
	
});
window.onload = function() {
    console.log('msg: ', '${msg}');
    var totalItemCount = parseInt(document.querySelector('.countDiv>div>span').textContent, 10);
    var itemsPerPage = parseInt(document.pageForm.amount.value, 10);
    var totalPageCount = Math.ceil(totalItemCount / itemsPerPage);

    // '끝' 링크에 총 페이지 수를 설정합니다.
    var lastPageLink = document.querySelector('a[title="마지막 페이지로 가기"]');
    if (lastPageLink) {
        lastPageLink.setAttribute('data-pagenum', totalPageCount);
    }

    //사용자가 페이지 관련 버튼을 클릭했을 때 (이전, 다음, 1, 2, 3...)
    //a태그의 href에다가 각각 다른 url을 작성해서 요청을 보내기가 귀찮다.
    //클릭한 버튼이 무엇인지를 확인해서 그 버튼에 맞는 페이지 정보를 
    //자바스크립트로 끌고 와서 요청을 보내주겠다.
    document.getElementById('pagination').addEventListener('click', e => {
       if(!e.target.matches('a')){
            return;
       } 

       e.preventDefault(); // a태그의 고유 기능 중지

       //현재 이벤트가 발생한 요소(버튼)의 
       //data-pagenum의 값을 얻어서 변수에 저장.
       //date-으로 시작하는 속성값을 dataset 프로퍼티로 쉽게 끌고 올 수 있다.
       const value = e.target.dataset.pagenum;
    
       //페이지 버튼들을 감싸고 잇는 form태그를 지목하여
       //그 안에 숨겨져 있는 input태그의 value에
       //위에서 얻은 data-pagenum의 값을 삽입한 후 submit
       document.pageForm.pageNo.value = value;
       document.pageForm.submit();
    });

    const msg = '${msg}';
    const message = '${message}';
    console.log('message: ',message);
    if(msg === 'searchFail'){
        // alert('검색 결과가 없었습니다.');
    }
    if(msg === 'zeroBoard'){
        // alert('검색 결과가 없었습니다.');
    }
    if(message === 'loginRequired') {
    	alert('로그인이 필요합니다.');
    	window.location.href = "${pageContext.request.contextPath}/particiation/login";
    }
    // 참여하기 버튼 클릭 시 받은 응답 메시지
    if (message === "alreadyParticipated") {
        alert("이미 이 설문에 참여하셨습니다.");
    }
    
//     $("#excelDown").on("click", function () {
//         downloadExcel();
//     });
}

function downloadExcel() {
	//데이터 담을 배열				
    var selectedData = [];
	//class명이 checkbox인 친구들 루프 돌며 td 엘리먼트에서 텍스트를 가져온다.
    $('.checkbox:checked').each(function() {
        var rowData = $(this).closest('tr');
        var fields = rowData.find('td');
		//td에 표시된 데이터들을 JSON형식으로 세팅
        var dataObject = {
            id: fields.eq(1).text(),
            name: fields.eq(2).text(),
            job: fields.eq(3).text(),
        };
		//배열에 JSON 데이터 저장
        selectedData.push(dataObject);
    });
	//엑셀다운로드 url + 데이터 인코딩한 값을 쿼리스트링으로 붙인 값으로 주소 변경
    var downloadUrl = '/user/downloadExcel?selectedData=' + encodeURIComponent(JSON.stringify(selectedData));
    window.location.href = downloadUrl;
}
// 검색부
function search_form() {
// 	if(document.getElementById("name").value==''){
// 		alert("성명을 입력해주십시오.");
// 		return false;
// 	}
// 	if(document.getElementById("password").value==''){
// 		alert("비밀번호를 입력해주십시오.");
// 		return false;
// 	}
// 	if ( ! $('input[name=agreeBtm]:checked').val()) {
// 		alert('개인정보 활용에 동의해주십시오.');
// 		return false;
// 	}
	document.getElementById('searchForm').submit();
}
// 결과보기 팝업
function result_popup(surveyId, pageNo, amount, keyword, condition) {
	var name = "researchPopup";
    var option = "width = 900, height = 600, top = 100, left = 200, location = no";
    var url = "${pageContext.request.contextPath}/particiation/researchPopup?id="+surveyId+"&pageNo="+pageNo+"&amount="+amount+"&keyword="+keyword+"&condition="+condition;
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
        <c:choose>
           <c:when test="${myPage eq true}">
             <h3 class="surveyListTitle">내가 등록한 설문</h3>
           </c:when>
           <c:otherwise>
        	<h3 class="surveyListTitle">설문조사</h3>
           </c:otherwise>
        </c:choose>
        <p class="history"><img src="/img/sub/history_home.gif" alt="home" /> 알림마당 <img src="/img/sub/history_arrow.gif" alt="다음" /> <strong>설문조사</strong></p>
        <p class="pt30"></p>
        
        <div class="top-section">
	        <form action="${pageContext.request.contextPath}/particiation/excelDownload" method="get">
	            <div class="excel-wrap">
	                <button type="submit" class="excelDown" id="excelDown">엑셀다운로드</button>
	                <select style="display:none;" name="condition">
            			<option value="title" ${pc.page.condition == 'title' ? 'selected':''}>제목</option>
          			</select>
         		 	<input type="hidden" id="keyword" name="keyword" value="${pc.page.keyword}"/>
	            </div>
	        </form>
	        <div class="countDiv">
	            <div class="countSurveyDiv">게시글 수: <span>${totalCount}</span>건</div>
	        </div>
    	</div>
       
        <div class="tbl_box">
         <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl_type01" summary="설문조사">
            <caption>
            설문조사
            </caption>
            <colgroup>
            <col width="8%"/>
            <col width="*%"/>
            <col width="15%"/>
            <col width="15%"/>
            <col width="10%"/>
<%--             <col width="8%"/> --%>
            <col width="10%"/>
            <col width="10%"/>
            </colgroup>
            <tbody>
              <tr>
                <th>NO</th>
                <th>제목</th>
                <th>시작일</th>
                <th>마감일</th>
                <th>완료여부</th>
<!--                 <th>첨부</th> -->
                <th>설문참여</th>
                <th>결과확인</th>
              </tr>
             
              <c:if test="${msg eq 'showList'}">
              <c:set var="num" value="${totalCount - ((pc.page.pageNo-1) * 10)}"/>
              <!-- 현재 날짜를 nowDate 변수에 설정 -->
<%-- 			  <c:set var="nowDate" value="${strDate}" /> --%>
              
              <c:forEach var="vo" items="${boardList}" varStatus="status">
              
              <tr>
                <td>${num}</td>
                <td id="h_surveyId" value="${vo.surveyId}" style="display: none;">${vo.surveyId}</td>
                <td class="tl">
                	<c:choose>
			           <c:when test="${myPage eq true}">
			           		<a class="survey-title" href="${pageContext.request.contextPath}/particiation/researchView?id=${vo.surveyId}&pageNo=${pc.page.pageNo}&amount=${pc.page.amount}&keyword=${pc.page.keyword}&condition=${pc.page.condition}&myPage=true">
		                		<c:out value="${vo.title}" escapeXml="true"/>
		                	</a>
			           </c:when>
			           <c:otherwise>
				        	<a class="survey-title" href="${pageContext.request.contextPath}/particiation/researchView?id=${vo.surveyId}&pageNo=${pc.page.pageNo}&amount=${pc.page.amount}&keyword=${pc.page.keyword}&condition=${pc.page.condition}&myPage=false">
		                		<c:out value="${vo.title}" escapeXml="true"/>
		                	</a>
			           </c:otherwise>
			        </c:choose>
                </td>
                <td>${vo.startDate}</td>                
                <td>${vo.endDate}</td>
				<td><c:choose>
				    <c:when test="${vo.startDate != null and nowDate != null and DateUtils.isAfter(vo.startDate, nowDate)}">진행예정</c:when>
				    <c:when test="${vo.startDate != null and nowDate != null and vo.endDate != null and DateUtils.isBeforeOrEqual(vo.startDate, nowDate) and DateUtils.isAfterOrEqual(vo.endDate, nowDate)}">진행중</c:when>
				    <c:otherwise>완료</c:otherwise>
				</c:choose></td>
<!--                 <td><img src="/img/sub/btn/btn_pdf.gif" alt="pdf" /></td> -->
<!--                 <td><a href="#"><img src="/img/sub/btn/btn_view.gif" alt="설문참여" /></a></td> -->
                <td>
                	<c:if test="${vo.startDate != null and nowDate != null and vo.endDate != null and DateUtils.isBeforeOrEqual(vo.startDate, nowDate) and DateUtils.isAfterOrEqual(vo.endDate, nowDate)}">
                		<a href="${pageContext.request.contextPath}/particiation/researchDo?id=${vo.surveyId}&pageNo=${pc.page.pageNo}&amount=${pc.page.amount}&keyword=${pc.page.keyword}&condition=${pc.page.condition}" class="btn-gradient green mini">설문참여</a>
                	</c:if>
                </td>
                <td>
                	<c:if test="${loginUser.adminYn == '0' and vo.startDate != null and nowDate != null and vo.endDate != null and DateUtils.isBeforeOrEqual(vo.startDate, nowDate) and DateUtils.isAfterOrEqual(vo.endDate, nowDate)}">
                		<a href="javascript:void(0);" onclick="result_popup('${vo.surveyId}','${pc.page.pageNo}','${pc.page.amount}','${pc.page.keyword}','${pc.page.condition}')"><img src="/img/sub/btn/btn_view.gif" alt="결과보기" /></a>
                	</c:if>
                	<c:if test="${vo.startDate != null and nowDate != null and vo.endDate != null and DateUtils.isSurveyOutsidePeriod(nowDate, vo.startDate, vo.endDate)}">
                		<a href="javascript:void(0);" onclick="result_popup('${vo.surveyId}','${pc.page.pageNo}','${pc.page.amount}','${pc.page.keyword}','${pc.page.condition}')"><img src="/img/sub/btn/btn_view.gif" alt="결과보기" /></a>
                	</c:if>
                </td>
              </tr> 
             
<!--               <tr> -->
<!--                 <td>10</td> -->
<!--                 <td class="tl">내용입니다.</td> -->
<!--                 <td>2013-01-02</td>                 -->
<!--                 <td>2013-01-02</td> -->
<!--                 <td>완료</td> -->
<!--                 <td><img src="/img/sub/btn/btn_pdf.gif" alt="pdf" /></td> -->
<!--                 <td><a href="#"><img src="/img/sub/btn/btn_view.gif" alt="설문참여" /></a></td> -->
<!--                 <td><a href="#"><img src="/img/sub/btn/btn_view.gif" alt="결과보기" /></a></td> -->
<!--               </tr> -->
              
             <c:set var="num" value="${num-1}"></c:set>
             </c:forEach>
              </c:if>     
              
  			  <c:if test="${msg eq 'searchFail'}">
               <tr>
                <td style="text-align: center; vertical-align: middle;"><img width="45px" style="display:inline-block;margin-right:5px;"
                         src="/img/sub/particiation/alert.png"
                       /></td>
                <td style="text-align: center; vertical-align: middle;">검색 결과가 없습니다.</td>
              </tr>
             </c:if>

             <c:if test="${msg eq 'zeroBoard'}">
              <tr>
                <td style="text-align: center; vertical-align: middle;"><img width="45px" style="display:inline-block;margin-right:5px;"
                         src="/img/sub/particiation/alert.png"
                       /></td>
                <td style="text-align: center; vertical-align: middle;">현재 설문이 존재하지 않습니다.</td>
              </tr>
             </c:if>
                 
            </tbody>
          </table>
          
          <!-- paging-->
          <c:choose>
           <c:when test="${myPage eq true}">
             <form action="${pageContext.request.contextPath}/particiation/researchMyList" name="pageForm">
           </c:when>
           <c:otherwise>
	          <form action="${pageContext.request.contextPath}/particiation/researchList" name="pageForm">
           </c:otherwise>
          </c:choose>
          <ul id="pagination" class="paging">
            <c:if test="${pc.prev}">
            <li><a href="#" title="맨 처음 페이지로 가기" data-pagenum="1"><img src="/img/sub/btn/pre_01.gif"  alt="맨 처음 페이지로 가기" /></a></li>
            <li><a href="#" title="이전 페이지로 가기" data-pagenum="${pc.begin-1}"><img src="/img/sub/btn/pre.gif" alt="이전 페이지로 가기" /></a></li>
            </c:if>
            <c:forEach var="num" begin="${pc.begin}" end="${pc.end}">
	        	<li class="${pc.page.pageNo == num ? 'active':''}"><a href="#" title="${num}" data-pagenum="${num}">${num}</a></li>
	        </c:forEach>
<!--             <li><span title="현재페이지"><a href="#" class="on">1</a></span></li> -->
<!--             <li><a href="# " title="2페이지">2</a></li> -->
<!--             <li><a href="#" title="3페이지">3</a></li> -->
<!--             <li><a href="#" title="4페이지">4</a></li> -->
<!--             <li><a href="# " title="5페이지">5</a></li> -->
<!--             <li><a href="#" title="6페이지">6</a></li> -->
<!--             <li><a href="#" title="7페이지">7</a></li> -->
<!--             <li><a href="#" title="8페이지">8</a></li> -->
<!--             <li><a href="#" title="9페이지">9</a></li> -->
<!--             <li><a href="#" title="10페이지">10</a></li> -->
            <c:if test="${pc.next}">
            <li><a href="#" title="다음 페이지로 가기" data-pagenum="${pc.end+1}"><img src="/img/sub/btn/next.gif" alt="다음 페이지" /></a></li>
            <li><a href="#" title="마지막 페이지로 가기" data-pagenum=""><img src="/img/sub/btn/next_01.gif" alt="마지막 페이지" /></a></li>
          	</c:if>
          </ul>
          <!-- //paging--> 
          
          <!-- btn--> 
          <span class="bbs_btn"> 

          <span class="per_l">
          	<c:choose>
	           <c:when test="${myPage eq true}">
	             <a href="${pageContext.request.contextPath}/particiation/researchMyList?userId=${loginUser.getUserId()}" class="pre_r">목록</a>
	           </c:when>
	           <c:otherwise>
	          	<a href="${pageContext.request.contextPath}/particiation/researchList" class="pre_r">목록</a>
	           </c:otherwise>
          </c:choose>
          </span>
        <c:if test="${loginUser.adminYn == '0'}">
          <span class="per_l">
          	<a href="${pageContext.request.contextPath}/particiation/researchCreate" class="pre_r">글쓰기</a>
          </span>
		</c:if>

          </span> 
          <!-- //btn--> 
          
          <input type="hidden" name="userId" value="${loginUser.getUserId()}"/>
          <input type="hidden" name="amount" value="${pc.page.amount}"/>
		  <input type="hidden" name="keyword" value="${pc.page.keyword}"/>
		  <input type="hidden" name="condition" value="${pc.page.condition}"/>
		  <input type="hidden" name="pageNo" value="${pc.page.pageNo}"/>
		</form>
        </div>
        
        <c:choose>
           <c:when test="${myPage eq true}">
             <form id="searchForm" action="${pageContext.request.contextPath}/particiation/researchMyList">
           </c:when>
           <c:otherwise>
	        <form id="searchForm" action="${pageContext.request.contextPath}/particiation/researchList">
           </c:otherwise>
        </c:choose>
        <div class="search_box">
        	<input type="hidden" name="userId" value="${loginUser.getUserId()}"/>
          <select name="condition">
<!--             <option>제목</option> -->
            <option value="title" ${pc.page.condition == 'title' ? 'selected':''}>제목</option>
          </select>
          <input type="text" id="keyword" name="keyword" value="${pc.page.keyword}"/>
          <a href="javascript:void(0);" onclick="return search_form()"><img src="/img/sub/btn/btn_serch.gif" alt="검색" /></a> 
        </div>
        </form>
        
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
