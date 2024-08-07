<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link href="/css/base.css" rel="stylesheet" type="text/css" />
<link href="/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript">
	var flag1 = true;
	var flag2 = true;

	$(document).ready(function() {
		$(".mainMenu").each(function(index, item) {
			$(item).click(function() {
				flag1 = false;
			});
		});

		$(".subMenu").each(function(index, item) {
			$(item).click(function() {
				flag1 = true;
				flag2 = false;
			});
		});
	});

	function getElementsByClass(searchClass, node, tag) {
		var classElements = new Array();
		if (node == null)
			node = document;
		if (tag == null)
			tag = '*';
		var els = node.getElementsByTagName(tag);
		var elsLen = els.length;
		var pattern = new RegExp("(^|\\s)" + searchClass + "(\\s|$)");
		for (i = 0, j = 0; i < elsLen; i++) {
			if (pattern.test(els[i].className)) {
				classElements[j] = els[i];
				j++;
			}
		}
		return classElements;
	}

	function menuHidden(menu, sub) {
		if (menu && menu.src) {
			menu.src = menu.src.replace("On", "Off");
		}
		if (sub && sub.style) {
			sub.style.display = "none";
		}
	}

	function setEvtGnb() {
		var mainMenu = getElementsByClass("mainMenu");
		var prevMenu1, prevSub1, isHid1, prevMenu2, isHid2;

		var subMenu = getElementsByClass("subMenu");

		for (var i = 0; i < mainMenu.length; i++) {
			(function(pos) {
				mainMenu[pos].getElementsByTagName("img")[0].onmouseover = function() {
					if (prevMenu1)
						menuHidden(prevMenu1, prevSub1);
					prevMenu1 = this;
					this.src = this.src.replace("Off", "On");
					prevSub1 = document.getElementById("sub"
							+ ("0" + (pos + 1)).match(/..$/));
					if (prevSub1) {
						prevSub1.style.display = "block";
					}
				};

				mainMenu[pos].onmouseout = function(e) {
					var bool, e = e || event;
					(function(obj, tobj) {
						var childs = obj.childNodes;
						for (var x = 0; x < childs.length; x++) {
							if (childs[x] == tobj)
								bool = true;
							else
								arguments.callee(childs[x], tobj);
						}
					})(this, document.elementFromPoint(e.clientX, e.clientY));
					if (flag1) {
						if (bool)
							return false;
						menuHidden(prevMenu1, prevSub1);
					}
				};
			})(i);
		}

		for (var j = 0; j < subMenu.length; j++) {
			(function(pos) {
				subMenu[pos].getElementsByTagName("img")[0].onmouseover = function() {
					prevMenu2 = this;
					this.src = this.src.replace("Off", "On");
					prevSub2 = document.getElementById("sub"
							+ ("0" + (pos + 1)).match(/..$/));
					flag2 = true;
				};

				subMenu[pos].onmouseout = function(e) {
					var bool, e = e || event;
					(function(obj, tobj) {
						var childs = obj.childNodes;
						for (var x = 0; x < childs.length; x++) {
							if (childs[x] == tobj)
								bool = true;
							else
								arguments.callee(childs[x], tobj);
						}
					})(this, document.elementFromPoint(e.clientX, e.clientY));
					if (flag2) {
						if (bool)
							return false;
						prevSub2 = document.getElementById("sub"
								+ ("0" + (pos + 1)).match(/..$/));
						menuHidden(prevMenu2, prevSub2);
					}
				};
			})(j);
		}
	}

	window.addEventListener('load', function() {
		setEvtGnb();
	});
</script>
<script type="text/javascript">
	initPage = function() {

	};

	doGoTab = function(thisObject, tab) {
		$(".factory_tab").find(">li>a").each(function(index, el) {
			$(el).removeClass("factory_tab0" + (index + 1) + "_on");
			$(el).addClass("factory_tab0" + (index + 1));
		});
		$(thisObject).addClass("factory_tab" + tab + "_on");
		if ("01" == tab) {
			$("#tab02,#tab03").hide();
			$("#tab01").show();
		} else if ("02" == tab) {
			$("#tab01,#tab03").hide();
			$("#tab02").show();

		} else {
			$("#tab01,#tab02").hide();
			$("#tab03").show();
		}
	};
	function confirmLogout(logoutUrl) {
		if (confirm("로그아웃 하시겠습니까?")) {
			window.location.href = logoutUrl;
		}
	}
</script>
<style>
.topmenu .dropdown {
	cursor: pointer;
	float: left;
}

.topmenu .dropdown-content {
	display: none; /* 기본적으로 숨김 */
	position: absolute;
	background-color: #f9f9f9;
	min-width: 100px;
	box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
	z-index: 1;
}

.topmenu .dropdown-content a {
	color: black;
	padding: 12px 16px;
	text-decoration: none;
	display: block;
}

.topmenu .dropdown-content a:hover {
	background-color: #f1f1f1;
}

/* 마우스 오버 시 드롭다운 메뉴 표시 */
.topmenu .dropdown:hover .dropdown-content, .topmenu .dropdown-content:hover
	{
	display: block;
}
</style>
<!-- header-->
<div id="header">
	<h1>
		<img src="/img/header/common/logo.gif" alt="서울학교급식포털" />
	</h1>
	<div class="topmenu">
		<ul>
			<li class="bn"><a href="#">HOME</a></li>
			<li><a href="#">SITEMAP</a></li>
			<c:choose>
				<c:when test="${not empty sessionScope.loginUser}">
					<li class="bn">
						<div class="dropdown">
							${loginUser.getUserId()}
							<div class="dropdown-content">
								<a
									href="${pageContext.request.contextPath}/particiation/researchMyList?userId=${loginUser.getUserId()}">나의
									페이지</a>
								<c:if test="${loginUser.adminYn eq '0'}">
									<a href="#">관리자 설정</a>
								</c:if>
							</div>
							님 환영합니다.
						</div> <a href="javascript:void(0);"
						onclick="confirmLogout('${pageContext.request.contextPath}/particiation/logout')">
							<img src="/img/header/common/btn_logout.gif" alt="로그아웃" />
					</a>
					</li>
				</c:when>
				<c:otherwise>
					<li class="bn"><a
						href="${pageContext.request.contextPath}/particiation/login">
							<img src="/img/header/common/btn_login.gif" alt="로그인" />
					</a></li>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
	<div id="gnb">
		<h2>주메뉴</h2>
		<ul class="MM">
			<li class="mainMenu first"><a href="#"><img
					src="/img/header/common/mm_infoOff.gif" id="sel1" alt="서울학교급식소개" /></a>
				<div class="subMenu" id="sub01" style="display: none;">
					<div class="boxSR">
						<ul class="boxSM">
							<li class="left_bg"></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_info01Off.gif" alt="인사말" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_info02Off.gif" alt="학교급식기본방향" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_info03Off.gif" alt="학교급식현황" /></a></li>
							<li class="last subMenu"><a href="#"><img
									src="/img/header/common/sm_info04Off.gif" alt="학교급식 담당부서" /></a></li>
							<li class="right_bg"></li>
						</ul>
					</div>
				</div></li>
			<li class="mainMenu"><a href="#"><img
					src="/img/header/common/mm_safetyOff.gif" alt="학교급식위생안전" /></a>
				<div class="subMenu" id="sub02" style="display: none;">
					<div class="boxSR">
						<ul class="boxSM">
							<li class="left_bg"></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_safety01Off.gif" alt="학교급식 위생관리" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_safety02Off.gif" alt="식중독 대처요령" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_safety03Off.gif" alt="안전사고예방" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_safety04Off.gif" alt="안전사고 대처요령" /></a></li>
							<li class="last subMenu"><a href="#"><img
									src="/img/header/common/sm_safety05Off.gif" alt="위생.안전성 검사결과" /></a></li>
							<li class="right_bg"></li>
						</ul>
					</div>
				</div></li>
			<li class="mainMenu"><a href="#"><img
					src="/img/header/common/mm_factoryOff.gif" alt="학교급식시설관리" /></a>
				<div class="subMenu" id="sub03" style="display: none;">
					<div class="boxSR">
						<ul class="boxSM">
							<li class="left_bg"></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_factory01Off.gif" alt="급식환경개선사업" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_factory01Off.gif" alt="급식시설개선사례" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_factory01Off.gif" alt="급식기구관리전환" /></a></li>
							<li class="last subMenu"><a href="#"><img
									src="/img/header/common/sm_factory01Off.gif" alt="컨설팅신청안내" /></a></li>
							<li class="right_bg"></li>
						</ul>
					</div>
				</div></li>
			<li class="mainMenu"><a href="#"><img
					src="/img/header/common/mm_foodOff.gif" alt="학교급식식재료" /></a>
				<div class="subMenu" id="sub04" style="display: none;">
					<div class="boxSR">
						<ul class="boxSM">
							<li class="left_bg"></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_food01Off.gif" alt="식재료 구매·관리" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_food02Off.gif" alt="식재료 시장조사" /></a></li>
							<li class="last subMenu"><a href="#"><img
									src="/img/header/common/sm_food03Off.gif" alt="부적합 납품 업체" /></a></li>
							<li class="right_bg"></li>
						</ul>
					</div>
				</div></li>
			<li class="mainMenu"><a href="#"><img
					src="/img/header/common/mm_eduOff.gif" alt="영양,교육" /></a>
				<div class="subMenu" id="sub05" style="display: none;">
					<div class="boxSR">
						<ul class="boxSM">
							<li class="left_bg"></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_edu01Off.gif" alt="영양·식생활교육" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_edu02Off.gif" alt="추천식단" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_edu03Off.gif" alt="추천레시피" /></a></li>
							<li class="last subMenu"><a href="#"><img
									src="/img/header/common/sm_edu04Off.gif" alt="학교급식특색활동" /></a></li>
							<li class="right_bg"></li>
						</ul>
					</div>
				</div></li>
			<li class="mainMenu"><a href="#"><img
					src="/img/header/common/mm_partOff.gif" alt="알림마당" /></a>
				<div class="subMenu" id="sub06" style="display: none;">
					<div class="boxSR">
						<ul class="boxSM">
							<li class="left_bg"></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_part01Off.gif" alt="학교급식인력풀" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_part02Off.gif" alt="영양(교)사이야기" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_part03Off.gif" alt="조리(원)사이야기" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_part04Off.gif" alt="자유게시판" /></a></li>
							<li class="last subMenu"><a
								href="${pageContext.request.contextPath}/particiation/researchList"><img
									src="/img/header/common/sm_part05Off.gif" alt="설문조사" /></a></li>
							<li class="right_bg"></li>
						</ul>
					</div>
				</div></li>
			<li class="mainMenu last"><a href="#"><img
					src="/img/header/common/mm_noticeOff.gif" alt="정보마당" /></a>
				<div class="subMenu" id="sub07" style="display: none;">
					<div class="boxSR">
						<ul class="boxSM">
							<li class="left_bg"></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_notice01Off.gif" alt="급식소식" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_notice01Off.gif" alt="연수·행사" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_notice01Off.gif" alt="업무자료실" /></a></li>
							<li class="subMenu"><a href="#"><img
									src="/img/header/common/sm_notice01Off.gif" alt="관련법규" /></a></li>
							<li class="last subMenu"><a href="#"><img
									src="/img/header/common/sm_notice01Off.gif" alt="FAQ" /></a></li>
							<li class="right_bg"></li>
						</ul>
					</div>
				</div></li>
		</ul>
	</div>
</div>
<!-- //header-->
