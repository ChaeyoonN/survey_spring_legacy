<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<script type="text/javascript">
	// 로그인 버튼 클릭 이벤트 처리
	function submitLoginForm() {
	    document.getElementById('loginForm').submit();
	}
	
	window.addEventListener('load', function() {
	    var loginFailed = "${loginFailed}";
	    console.log("!!!!!!!!!!!!!!!!!:", loginFailed);
	    if (loginFailed === "true") {
	        alert("로그인에 실패하였습니다. 아이디와 비밀번호를 확인해주세요.");
	    }
	    var redirectAfterLogin = "${redirectAfterLogin}";
	    console.log(redirectAfterLogin);
// 	    if (redirectAfterLogin !== "") {
// 	        location.href = "${pageContext.request.contextPath}" + redirectAfterLogin;
// 	    }
	});
	
	// 페이지가 닫힐 때 세션에서 redirectAfterLogin 제거
	window.addEventListener('unload', function() {
	    var xhr = new XMLHttpRequest();
	    xhr.open("POST", "${pageContext.request.contextPath}/particiation/removeRedirectAfterLogin", true);
	    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	    xhr.send();
	});

</script>
</head>
<body>
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
        <li><img src="/img/sub/etc/sub_title_01.gif" alt="정보마당" /></li>
        <li><a href="#"><img src="/img/sub/etc/sub_stitle_01Off.gif" alt="로그인" /></a></li>
        <li><a href="#"><img src="/img/sub/etc/sub_stitle_02Off.gif" alt="본인확인" /></a></li>
        <li><a href="#"><img src="/img/sub/etc/sub_stitle_03Off.gif" alt="관련기관링크" /></a></li>
        <li><a href="#"><img src="/img/sub/etc/sub_stitle_04On.gif" alt="개인보호정책" /></a></li>
        <li><a href="#"><img src="/img/sub/etc/sub_stitle_05Off.gif" alt="이메일무단수집거부" /></a></li>
        <li><a href="#"><img src="/img/sub/etc/sub_stitle_06Off.gif" alt="저작권보호" /></a></li>
         <li><a href="#"><img src="/img/sub/etc/sub_stitle_07Off.gif" alt="뷰어프로그램" /></a></li>
         <li><a href="#"><img src="/img/sub/etc/sub_stitle_08Off.gif" alt="팝업관리" /></a></li>
         <li><a href="#"><img src="/img/sub/etc/sub_stitle_09Off.gif" alt="사이트맵" /></a></li>
      </ul>
      <div class="right_box">
        <h3><img src="/img/sub/etc/title_01.gif" alt="로그인" /></h3>
        <p class="history"><img src="/img/sub/history_home.gif" alt="home" /> 기타 <img src="/img/sub/history_arrow.gif" alt="다음" /> <strong>로그인</strong></p>
        <p class="pt30"></p>
       
       <!-- login-->
		<form id="loginForm" action="<c:url value='${pageContext.request.contextPath}/particiation/login'/>" method="post">
		<fieldset>
		  <legend>로그인</legend>
		  <div class="login">
		    <h4>
		      <img src="/img/sub/etc/login_img_01.gif" alt="아이디를 입력하세요" />
		    </h4>
		    <div class="input-container">
		      <div class="input-item">
		        <label for="userId">아이디</label>
		        <input type="text" class="inp" name="userId" id="userId" />
		      </div>
		      <div class="input-item">
		        <label for="password">비밀번호</label>
		        <input type="password" class="inp" name="password" id="password" />
		      </div>
		    </div>
		    <div class="login-buttons">
		      <a href="javascript:void(0)" onclick="submitLoginForm()"><img src="/img/sub/etc/login_btn.gif" alt="로그인" /></a>
		      <a href="#"><img src="/img/sub/etc/login_btn_01.gif" alt="사용자등록" /></a>
		    </div>
		    <ul class="login_text">
		      <li>
		        학생, 학부모, 시민은 별도의 회원가입 없이 본인확인(아이핀인증 또는 실명인증)만으로 <br />서비스 이용이 가능합니다. (사용자 등록 불가)
		      </li>
		      <li>
		        서울특별시교육청(학교 포함) 소속 교직원은 나이스 아이디와 인증서로 로그인을 하시기 바랍니다.<br />
		        <span class="f_eb7c10">※ 로그인이 되지 않을 경우, 서울시교육청 홈페이지에서 먼저 사용자 등록을 하시기 바랍니다.</span>
		      </li>
		    </ul>
		  </div>
		</fieldset>
		</form>
       <!-- //login--> 
        
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
