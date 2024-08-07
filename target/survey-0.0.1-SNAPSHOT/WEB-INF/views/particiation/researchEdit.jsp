<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
.research .option_amount {
	margin-top:5px;
	margin-left:15px;
}
.invalid-input {
    border: 2px solid #666;;
}
.research .inp.qInput {
 	width: 90%;
}
.research .inp.opInput {
 	width: 90%;
}
.surveyListTitle {
	font-weight:bold;
	font-size: 20px !important;
	font-family: dotum, AppleGothic, sans-serif;
}
.addItemBtn, .removeItemBtn,
.addFileBtn, .removeFileBtn {
	cursor: pointer;
}
/* 첨부파일 tr 배치 */
.fileRow {
/* 	display:flex; */
/* 	flex-direction: row; */
	display: table-row;
}
.fileTh {
    display: flex; /* Flexbox 레이아웃을 사용하여 내부 요소들을 가로로 배치 */
    align-items: center; /* 내부 요소들을 세로 방향 가운데로 정렬 */
    justify-content: center; /* tr 내부 요소들을 가운데 정렬 */
    display: table-cell;
    
    position: relative;
}
.fileHeader {
  position: absolute;
  top: 0;
  left: 0;
  display: flex;
  align-items: center;
}
.fileSpan, .addFileBtn, .removeFileBtn {
    /* margin-right: 5px; 버튼과 텍스트 사이의 간격 */ 
    border: none;
    margin-left: 15px;
    margin-top: 10px;
}

.addFileBtn img, .removeFileBtn img {
    display: inline-block;
    height: 14px;
    vertical-align: middle; /* 이미지를 텍스트 중앙에 정렬 */
}
/* 파일 인풋을 감싸는 td */
.file-container {
    display: flex;
    flex-direction: column;
    width:600px;
/*     display:table-cell; */
}
/* 기존 첨부파일들 간 간격 */
.file-item {
	margin-bottom:3px;
}
</style>
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {
    // 달력 설정
	const startDateInput = document.getElementById('start-date');
    const endDateInput = document.getElementById('end-date');
    const today = new Date().toISOString().split('T')[0]; // 현재 날짜를 YYYY-MM-DD 형식으로 가져옵니다.

    startDateInput.setAttribute('min', today); // 시작일의 최소 선택 가능 날짜를 오늘로 설정합니다.
    endDateInput.setAttribute('min', today); // 종료일의 최소 선택 가능 날짜를 오늘로 설정합니다.

    // 시작일이 변경될 때, 종료일의 최소 날짜를 시작일로 설정합니다.
    startDateInput.addEventListener('change', function() {
        endDateInput.setAttribute('min', startDateInput.value);
        validateDates();
    });
    
 	// 종료일이 변경될 때, 시작일과 종료일의 유효성 검사를 수행합니다.
    endDateInput.addEventListener('change', validateDates);

    // 시작일과 종료일의 유효성 검사 함수
    function validateDates() {
        const startDate = startDateInput.value;
        const endDate = endDateInput.value;

        if (startDate && endDate && startDate > endDate) {
            alert("종료일이 시작일보다 이전일 수 없습니다.");
            startDateInput.classList.add('invalid-input');
            endDateInput.classList.add('invalid-input');
//             startDateInput.value = '';
        } else {
            startDateInput.classList.remove('invalid-input');
            endDateInput.classList.remove('invalid-input');
        }
    }

    //모든 파일 인풋에 이벤트 리스너 추가
    function addFileInputListeners() {
        var fileInputs = document.querySelectorAll('input[type="file"]');
        fileInputs.forEach(function(fileInput) {
            fileInput.addEventListener('change', function() {
                checkFileSize(fileInput);
            });
        });
    }
    
 	// 초기 로드 시 모든 인풋에 chang리스너 추가
	 addFileInputListeners();
 	
}); // DOMContentLoaded 끝

document.addEventListener('load', function() {
	const msgForEdit = new URLSearchParams(window.location.search).get('msgForEdit');
	if (msgForEdit) {
		console.log(msgForEdit);
		handleEditResponse(msgForEdit);
	}
});
$(document).ready(function() {
	/******* 글자수 *********/
    // 제목 입력란에 대한 이벤트 리스너
	$('#surTitle').on('input', function() {
	    var maxLength = 50; // 최대 글자수
	    var currentLength = $(this).val().length;
	    if (currentLength > maxLength) {
	        alert('제목은 50자 이내로 입력해주세요.');
	        $(this).val($(this).val().substring(0, maxLength)); // 초과 글자수 자르기
	    }
	});
	
	// 질문 입력란에 대한 이벤트 리스너
	$(document).on('input', 'input[id^="question"]', function() {
	    var maxLength = 100; // 최대 글자수
	    var currentLength = $(this).val().length;
	    if (currentLength > maxLength) {
	        alert('각 문제는 100자 이내로 입력해주세요.');
	        $(this).val($(this).val().substring(0, maxLength)); // 초과 글자수 자르기
	    }
	});
	
	// 옵션 입력란에 대한 이벤트 리스너
	$(document).on('input', 'input[id^="option"]', function() {
	    var maxLength = 50; // 최대 글자수
	    var currentLength = $(this).val().length;
	    if (currentLength > maxLength) {
	        alert('각 항목은 50자 이내로 입력해주세요.');
	        $(this).val($(this).val().substring(0, maxLength)); // 초과 글자수 자르기
	    }
	});
	$('input[id^="option"]').on('keyup', function() {
        var maxLength = 50; // 최대 글자수
        var currentLength = $(this).val().length;
        if (currentLength > maxLength) {
            alert('항목은 50자 이내로 입력해주세요.');
            $(this).val($(this).val().substring(0, maxLength)); // 초과 글자수 자르기
        }
    });
    $(document).on('keyup', 'input[id^="option"]', function() {
        var currentOption = $(this);
        var optionText = currentOption.val().trim();
        var currentIndex = $('input[id^="option"]').index(currentOption);
        var emptyFieldFound = false;
        var firstEmptyElement = null;
        $('input[id^="option"]').each(function(index, element) {
            if (index > currentIndex) {
                return false; // 현재 입력 필드 이후는 검사하지 않음
            }
            if ($(element).val().trim().length === 0) {
                if (!emptyFieldFound) {
                    firstEmptyElement = element; // 첫 번째 빈 입력란 저장
                } 
                emptyFieldFound = true;
            } else if (emptyFieldFound) {
                alert("빈칸인 항목 입력란이 있습니다. 빈칸을 먼저 채워주세요.");
                $(firstEmptyElement).addClass('invalid-input').focus();
                currentOption.val(''); 
                return false;
            }
        });

        if (emptyFieldFound) {
            return false;
        }
    });
	/******* 입력란 추가 *********/
// 	var count = ${fn:length(board.questions)} // 아이템의 초기 인덱스 설정
	var count = document.getElementById('queCnt').value // 현재 문제 수
	var fileCount = 1;
// 	console.log(count);
// 	const questionCount = document.querySelectorAll(".question-item").length;
	var questionCount = document.getElementById('queCnt').value; // 현재 문제 수
	var newQuestionIndex = questionCount; // 새 문제의 인덱스
	console.log(questionCount);
    var optionCounts = [5]; // 각 문제의 옵션 수를 추적하는 배열, 초기값은 첫 번째 문제의 5개 옵션
    
	 
    // 숫자를 ①, ②, ③ ... 형태로 변환하는 함수
    function convertToCircleNumber(number) {
        const circleNumbers = ["①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩", "⑪"];
        return circleNumbers[number - 1] || number;
    }
    
    // 아이템 추가 버튼 클릭 이벤트를 상위 요소에 위임
    $(document).on("click", ".addItemBtn", function(e) {
        e.preventDefault();
        count++;
        console.log(count);
        optionCounts.push(5); // 새로 추가되는 문제의 초기 옵션 수를 5로 설정
        
        document.getElementById("qCnt").innerHTML = count + '개<a href="javascript:void(0);" class="addItemBtn"><img src="/img/sub/particiation/plus.png" alt="설문조사" style="border:none; margin-left:5px; display:inline-block; width:14px;"/></a>' +
            '<a href="javascript:void(0);" class="removeItemBtn"><img src="/img/sub/particiation/minus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a>';

       var item = '<div class="research">' +
       '<p><label for="question' + count + '">문제 '+count+'.</label><input type="text" id="question' + count + '" name="questions[' + (count - 1) + '].questionText" class="inp qInput" style="margin-left: 5px;width:90%;" placeholder="100자 이내로 적어주세요."/></p>' +
       '<ul>';
       
       for (var i = 1; i <= 5; i++) {
           item += '<li class="option-item"><label for="option' + i + count + '">항목 ' + convertToCircleNumber(i) + '</label><input type="text" id="option' + i + count + '" name="questions[' + (count - 1) + '].options[' + (i - 1) + '].optionText" class="inp opInput" style="margin-left: 5px;width:90%;" title="항목" placeholder="50자 이내로 적어주세요."/></li>';
       }

       item += '</ul>' +
           '<li id="optionAmount'+ count +'" class="option_amount" style="margin-top:5px;margin-left:5px;"><strong>항목 갯수 조정</strong><a href="javascript:void(0);" class="addOptionBtn" data-question="' + count + '"><img src="/img/sub/particiation/plus.png" alt="항목 추가" style="border:none; display:inline-block; width:16px;"/></a>' +
           '<a href="javascript:void(0);" class="removeOptionBtn" data-question="' + count + '"><img src="/img/sub/particiation/minus.png" alt="항목 삭제" style="border:none; display:inline-block; width:16px;"/></a></li>' +
           '</div>';
		
    // 마지막 research div 뒤에 새 문제를 추가
       $("#surveyContent .research").last().after(item);
        
    });

    // 아이템 삭제 버튼 클릭 이벤트
    $(document).on("click", ".removeItemBtn", function(e) {
        e.preventDefault();
        if(count <= 1) {
            alert("설문의 문제는 1개 이상이어야 합니다.");
        } else {
            $("#surveyContent div").last().remove();
            count--; // 아이템 인덱스 감소
            document.getElementById("qCnt").innerHTML = count + '개<a href="javascript:void(0);" class="addItemBtn"><img src="/img/sub/particiation/plus.png" alt="설문조사" style="border:none; margin-left:5px; display:inline-block; width:14px;"/></a>' +
                '<a href="javascript:void(0);" class="removeItemBtn"><img src="/img/sub/particiation/minus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a>';
        }
    });
    
 	// 옵션 추가 버튼 이벤트
    $(document).on("click", ".addOptionBtn", function(e) {
        e.preventDefault();
        var questionIndex = $(this).data('question'); // 해당 옵션 추가 버튼이 속한 문제의 인덱스
        // 해당 문제의 옵션 리스트를 찾음
        var optionList = $(this).closest('.research').find('ul');

        // 기존 옵션 수를 계산
        var existingOptions = optionList.find('li.option-item').length;

        // 다음 옵션 번호 계산 (기존 옵션 수 + 1)
        var nextOptionNumber = existingOptions + 1;
        
        if (nextOptionNumber <= 10) {
            var optionHtml = '<li class="option-item"><label for="option'+nextOptionNumber+questionIndex+'">항목 ' +
                convertToCircleNumber(nextOptionNumber) + 
                '<input type="text" id="option' + nextOptionNumber + questionIndex + 
                '" name="questions[' + (questionIndex - 1) + '].options[' + (nextOptionNumber - 1) + '].optionText" class="inp opInput" style="margin-left:5px;width:90%;" title="항목" placeholder="50자 이내로 적어주세요." /></li>';
            
            // 새로운 옵션을 추가
            $(optionHtml).appendTo(optionList);
        } else {
            alert("항목은 최대 10개까지만 추가할 수 있습니다.");
        }
    });

    // 옵션 삭제 버튼 이벤트
    $(document).on("click", ".removeOptionBtn", function(e) {
        e.preventDefault();
        var questionIndex = $(this).data('question'); // 해당 옵션 삭제 버튼이 속한 문제의 인덱스
     	// 해당 문제의 옵션 리스트를 찾음
        var optionList = $(this).closest('.research').find('ul');

        // 기존 옵션 수를 계산
        var existingOptions = optionList.find('li.option-item').length;

        // 다음 옵션 번호 계산 (기존 옵션 수 + 1)
        var nextOptionNumber = existingOptions + 1;
        if(existingOptions > 2){ // 옵션 수가 2개 이상인 경우에만 삭제 가능
            $(this).closest('.research').find('ul li').last().remove();
            optionCounts[questionIndex-1]--;
        } else {
            alert("항목은 최소 2개가 있어야 합니다.");
        }
    });
    
 	// 파일 인풋 추가/삭제 이벤트
    document.querySelector('.addFileBtn').addEventListener('click', function() {
    	var scrollPosition = window.scrollY;
    	var newInput = document.createElement('input');
      newInput.type = 'file';
      fileCount++;
      console.log('파일 카운트: ',fileCount);
      console.log('카운트: ',count);
      newInput.id = 'surveyFile'+fileCount;
      newInput.name = 'file';
      document.querySelector('.file-container').appendChild(newInput);
      updateFileInputs();
   	
      // 새로운 파일 인풋에 이벤트 리스너 추가
      newInput.addEventListener('change', function() {
          checkFileSize(newInput);
      });
      // 스크롤 위치 복원
      window.scrollTo(0, scrollPosition);
    });

    document.querySelector('.removeFileBtn').addEventListener('click', function() {
    	var scrollPosition = window.scrollY;
    	fileCount--;
      var inputs = document.querySelectorAll('.file-container input[type="file"]');
      if (inputs.length > 1) { // 최소한 하나의 입력 필드는 남겨둠
        inputs[inputs.length - 1].remove();
        updateFileInputs();
      } else {
    	  alert('파일첨부란은 1개 이상 존재해야 합니다.');
      }
   	  // 스크롤 위치 복원
      window.scrollTo(0, scrollPosition);
      
    });
	
    // 기존에 등록한 첨부파일 화면상에서 삭제하는 이벤트
    $("a[name='file-delete']").on("click", function(e) {
			e.preventDefault();
            deleteFile($(this));
    });
    
    // 수정 등록 위한 삭제될 파일id 얻기
	 // 파일 삭제 링크에 대한 클릭 이벤트 핸들러 추가
	 document.querySelectorAll('[name="file-delete"]').forEach(item => {
	     item.addEventListener('click', function(e) {
	         e.preventDefault(); // 기본 동작 방지
	         var fileId = this.getAttribute('data-file-id'); // 데이터 속성에서 파일 ID 추출
	         if(fileId && !deleteFileIds.includes(fileId)) {
	             deleteFileIds.push(fileId); // 배열에 파일 ID 추가
	         }
	     });
	 });
    
}); // $(document).ready 끝
// 전역 변수
var deleteFileIds = []; // 삭제할 파일 ID를 저장할 배열
var maxFileSize = 1073741824; // 1GB in bytes

//스크롤 이벤트 리스너 추가
window.addEventListener('scroll', saveScrollPosition);

// 페이지 로드 시 저장된 스크롤 위치로 이동
window.addEventListener('load', restoreScrollPosition);

//스크롤 위치를 로컬 스토리지에 저장
function saveScrollPosition() {
    localStorage.setItem("scrollPosition", window.scrollY || document.documentElement.scrollTop);
}

// 저장된 스크롤 위치로 스크롤
function restoreScrollPosition() {
    if (localStorage.getItem("scrollPosition")) {
        const savedScrollPosition = localStorage.getItem("scrollPosition");
        window.scrollTo(0, parseInt(savedScrollPosition, 10));
    }
}

//첨부파일 용량 제한
function checkFileSize(fileInput) {
    var isFileTooLarge = false;
    for (var i = 0; i < fileInput.files.length; i++) {
        if (fileInput.files[i].size > maxFileSize) {
            isFileTooLarge = true;
            break;
        }
    }
    if (isFileTooLarge) {
        alert("파일 크기가 1GB를 초과합니다. 다른 파일을 선택해 주세요.");
        fileInput.value = ""; // 파일 input 초기화
    }
}

function updateFileInputs() {
  var fileInputs = document.querySelectorAll('.file-container input[type="file"]');
  // 먼저 모든 파일 입력 필드에서 margin-bottom을 제거.
  fileInputs.forEach(function(input) {
    input.style.marginBottom = '';
  });
  
  // 파일 입력 필드가 하나 이상 있을 경우, 마지막 파일 입력 필드를 제외한 모든 입력 필드에 margin-bottom을 적용합니다.
  if (fileInputs.length > 1) {
    for (var i = 0; i < fileInputs.length - 1; i++) {
      fileInputs[i].style.marginBottom = '3px';
    }
  }
}
	
function deleteFile(obj) {
	var fileId = obj.data("file-id");
    var surveyId = obj.data("survey-id");
    obj.closest("div").remove();
}

function handleEditResponse(msgForEdit) {
	if(msgForEdit === 'loginRequired'){
    	alert('로그인이 필요한 기능입니다.');
    	location.href = "${pageContext.request.contextPath}/particiation/login";
    }
    else if(msgForEdit === 'noAuthority'){
    	alert('권한이 없습니다.');
    }
    else if(msgForEdit === 'surveyOngoing'){
    	alert('진행중인 설문은 수정할 수 없습니다.');
    }
    else if(msgForEdit === 'surveyComplete'){
    	alert('완료된 설문은 수정할 수 없습니다.');
    }
    else if(msgForEdit === 'editSuccess'){
    	// alert('수정되었습니다.');
    	location.href = "${pageContext.request.contextPath}/particiation/researchList";
    }
    else if(msgForEdit === 'editFailed'){
    	alert('수정에 실패했습니다. 관리자에게 문의하세요.');
    }
    else if(msgForEdit === 'validationError'){
    	alert('입력 값에 문제가 있습니다. 다시 확인해주세요.');
    }
}

function formToObject(formSelector) {
    const form = document.querySelector(formSelector);
    const formData = new FormData(form);
    const result = {
        questions: [],
        surveyId: null,
        title: '',
        startDate: '',
        endDate: ''
    };

    formData.forEach((value, key) => {
        if (key === 'title' || key === 'startDate' || key === 'endDate' || key === 'surveyId') {
            result[key] = value;
        } else {
            const questionMatch = key.match(/^questions\[(\d+)]/);
            if (questionMatch) {
                const questionIndex = parseInt(questionMatch[1], 10);
                if (!result.questions[questionIndex]) {
                    result.questions[questionIndex] = { questionText: '', options: [] };
                }

                if (key.includes('questionText')) {
                    result.questions[questionIndex].questionText = value;
                } else if (key.includes('options')) {
                    const optionMatch = key.match(/options\[(\d+)]/);
                    if (optionMatch) {
                        const optionIndex = parseInt(optionMatch[1], 10);
                        result.questions[questionIndex].options[optionIndex] = { optionText: value };
                    }
                }
            }
        }
    });

    // 옵션 배열 내에서 빈 항목 제거
    result.questions.forEach(question => {
        question.options = question.options.filter(option => option !== undefined);
    });

    return result;
}

function sendPost(){
	// 유효성 검사 시작
    var title = $('#surTitle').val().trim();
    if(title.length === 0) {
    	alert("공백만 등록할 수 없습니다.");
    	$('#surTitle').val('');
        $('#surTitle').addClass('invalid-input').focus();
        return;
    }
	if(title.length > 50) {
        alert("제목은 1자 이상 50자 이내로 입력해주세요.");
        $('#surTitle').addClass('invalid-input').focus();
        return;
    } else {
        $('#surTitle').removeClass('invalid-input');
    }
    
    var startDate = $('#start-date').val();
    var endDate = $('#end-date').val();
    if(startDate.length === 0 || endDate.length === 0) {
        alert("시작일과 종료일을 모두 입력해주세요.");
        if(startDate.length === 0) {
            $('#start-date').addClass('invalid-input').focus();
        } else {
            $('#end-date').addClass('invalid-input').focus();
        }
        return;
    } else {
        $('#start-date').removeClass('invalid-input');
        $('#end-date').removeClass('invalid-input');
    }
    
    if(startDate > endDate) {
        alert("종료일이 시작일보다 이전일 수 없습니다.");
        $('#end-date').addClass('invalid-input').focus();
        return;
    } else {
        $('#end-date').removeClass('invalid-input');
    }

    // 문제 텍스트 유효성 검사
    var questionsValid = true;
    $('input[id^="question"]').each(function() {
        var questionText = $(this).val().trim();
        if(questionText.length === 0) {
        	alert("공백만 등록할 수 없습니다.");
            $(this).val('');
            $(this).addClass('invalid-input').focus();
            questionsValid = false;
            return false; // each 루프 중지
        }
        if(questionText.length > 100) {
            alert("각 문제는 1자 이상 100자 이내로 입력해주세요.");
            $(this).addClass('invalid-input').focus();
            questionsValid = false;
            return false; // each 루프 중지
        } else {
            $(this).removeClass('invalid-input');
        }
        // 비속어 검사 예시
        if(isContainBadWords(questionText)) {
            alert("문제에 부적절한 내용이 포함되어 있습니다.");
            $(this).addClass('invalid-input').focus();
            questionsValid = false;
            return false; // each 루프 중지
        } else {
            $(this).removeClass('invalid-input');
        }
    });
    if(!questionsValid) return; // sendPost() 탈출
    
    // 옵션 유효성 검사
    var optionsValid = true;
    $('input[id^="option"]').each(function() {
        var optionText = $(this).val().trim();
        if(optionText.length === 0) {
        	alert("공백만 등록할 수 없습니다.");
        	$(this).val('');
            $(this).addClass('invalid-input').focus();
            optionsValid = false;
            return false; // each 루프 중지
        }
        if(optionText.length > 50) {
            alert("각 항목은 1자 이상 50자 이내로 입력해주세요.");
            $(this).addClass('invalid-input').focus();
            optionsValid = false;
            return false; // each 루프 중지
        } else {
            $(this).removeClass('invalid-input');
        }
        // 비속어 검사 예시
        if(isContainBadWords(optionText)) {
            alert("항목에 부적절한 내용이 포함되어 있습니다.");
            $(this).addClass('invalid-input').focus();
            optionsValid = false;
            return false; // each 루프 중지
        } else {
            $(this).removeClass('invalid-input');
        }
    });
    if(!optionsValid) return; // sendPost() 탈출
    
    var obj = formToObject('#boardEditForm');
    var form = document.getElementById('boardEditForm');
    var formData = new FormData(form);
    var data = document.querySelectorAll('#boardEditForm input[type="file"]');
//     var maxFileSize = 1073741824; // 1GB in bytes
//  	// 파일 크기 검증 및 FormData에 파일 추가
//     var isFileTooLarge = false;
//     data.forEach(fileInput => {
//         for (var i = 0; i < fileInput.files.length; i++) {
//             if (fileInput.files[i].size > 0) {
//                 if (fileInput.files[i].size > maxFileSize) {
//                     isFileTooLarge = true;
//                     break;
//                 }
//             }
//         }
//     });
//     if (isFileTooLarge) {
//         alert("파일 크기가 1GB를 초과합니다. 다른 파일을 선택해 주세요.");
//         return;
//     }
  	// 파일 데이터를 FormData에 추가
    formData.append("file", data.files);
// 	for (var i = 0; i < data.length; i++) {
// 	    formData.append("file", data[i].files[0]);
// 	}
	
	// 기존 파일 정보를 FormData에 추가
// 	var existingFiles = document.querySelectorAll('#boardEditForm input[name="existingFileIds"]');
// 	var existingFileIds = [];
// 	// 값들을 배열에 추가
// 	existingFiles.forEach((input) => {
// 	    existingFileIds.push(input.value);
// 	});
// 	// FormData에 배열을 추가
// 	formData.append("existingFileIds", JSON.stringify(existingFileIds));
	// 기존 파일 정보를 FormData에 추가
	var existingFilesElements = document.querySelectorAll('#boardEditForm input[name="existingFileIds"]');
	const existingFiles = Array.from(existingFilesElements).map(element => ({ value: element.value }));
	console.log(existingFiles);
	
// 	formData.append("existingFileIds", existingFiles.value);
	// 각 파일 ID를 별도의 FormData 항목으로 추가
	existingFiles.forEach((input) => {
	    formData.append("existingFileIds[]", input.value);
	});
	
	
    // 삭제할 파일 ID 목록을 JSON 문자열로 변환하여 FormData에 추가
    // formData.append('deleteFileIds', JSON.stringify(deleteFileIds));
 	
    // JSON 데이터를 FormData에 추가
    formData.append('surveyDTO', new Blob([JSON.stringify(obj)], { type: "application/json" }));
    
 	// FormData 내용 확인
    for (var pair of formData.entries()) {
        console.log(pair[0]+ ', ' + pair[1]); 
    }
    
    // processData와 contentType 옵션은 fetch에서 자동 처리된다.
    // Fetch API는 기본적으로 processData: false, contentType: false와 같은 역할을 한다.
    // 따라서 명시적으로 이를 설정할 필요가 없다.
	fetch('${pageContext.request.contextPath}/particiation/researchEdit', {
		method: 'POST',
		body: formData
	})
	.then(response => response.json())
	.then(data => {
		const msgForEdit = data.msgForEdit;
		handleEditResponse(msgForEdit);
	})
	.catch(error => {
		console.error('Error:', error);
		alert('수정에 실패했습니다. 관리자에게 문의하세요.');
	});
}
//비속어가 포함되어 있는지 확인하는 함수
function isContainBadWords(text) {
    var badWords = ["시발", "개새끼", "병신"]; // 실제 비속어 리스트로 대체 필요
    for(var i = 0; i < badWords.length; i++) {
        if(text.includes(badWords[i])) {
            return true;
        }
    }
    return false;
}
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
        <form name="boardEditForm" id="boardEditForm" method="post" enctype="multipart/form-data">
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
                <td colspan="5" class="tl"><input type="text" value="${fn:escapeXml(board.title)}" id="surTitle" name="title" class="inp" placeholder="제목은 50자 이내로 적어주세요."/></td>
                </tr>
              <tr>
                <th>시작일</th>
                <td class="tl"><input type="date" value="${board.startDate}" id="start-date" name="startDate" class="inp" style="width:100px;" /><a href="#"></a></td>
                <th>종료일</th>
                <td class="tl"><input type="date" value="${board.endDate}" id="end-date" name="endDate" class="inp" style="width:100px;" /><a href="#"></a></td>
<!--                 <th>결과확인</th> -->
<!--                 <td class="tl"><img src="/img/sub/btn/btn_view.gif" alt="결과보기" /></td> -->
              </tr>
              <tr>
                <th>문제수</th>
                <td id="qCnt" colspan="5" class="tl">
                	<input type="hidden" id="queCnt" name="queCnt" value="${fn:length(board.questions)}"/>
                 	<c:out value="${fn:length(board.questions)}개"/>
                <a class="addItemBtn"><img src="/img/sub/particiation/plus.png" alt="문제추가" style="border:none; margin-left:5px; display:inline-block; width:14px;"/></a>
                <a class="removeItemBtn"><img src="/img/sub/particiation/minus.png" alt="문제삭제" style="border:none; display:inline-block; width:16px;"/></a>
                </td>
              </tr>
              
              
			  
              <tr id="surveyContent_big">
               <td id="surveyContent" colspan="6" class="tl">
              <c:forEach var="question" items="${board.questions}" varStatus="status">
               	   <div class="research">
               	   	   <!-- id = question + 문제번호 -->
                       <p id="surveyNo"><label for="question${status.index}">문제 ${status.index + 1}.</label><input type="text" value="${fn:escapeXml(question.questionText)}" id="question${status.index}" name="questions[${status.index}].questionText" class="inp qInput" style="margin-left:5px;width:90%;" title="${fn:escapeXml(question.questionText)}" /></p>
                        <ul>
	                        <!-- id = option + 옵션번호 + 문제번호 -->
	                         <c:forEach var="option" items="${question.options}" varStatus="optionStatus">
                                <li class="option-item">
                                	<c:if test="${optionStatus.index + 1 eq 1}">
							            <label for="option${optionStatus.index}${status.index}">항목 ①</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 2}">
							            <label for="option${optionStatus.index}${status.index}">항목 ②</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 3}">
							            <label for="option${optionStatus.index}${status.index}">항목 ③</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 4}">
							            <label for="option${optionStatus.index}${status.index}">항목 ④</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 5}">
							            <label for="option${optionStatus.index}${status.index}">항목 ⑤</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 6}">
							            <label for="option${optionStatus.index}${status.index}">항목 ⑥</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 7}">
							            <label for="option${optionStatus.index}${status.index}">항목 ⑦</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 8}">
							            <label for="option${optionStatus.index}${status.index}">항목 ⑧</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 9}">
							            <label for="option${optionStatus.index}${status.index}">항목 ⑨</label>
							        </c:if>
							        <c:if test="${optionStatus.index + 1 eq 10}">
							            <label for="option${optionStatus.index}${status.index}">항목 ⑩</label>
							        </c:if><input type="text" value="${fn:escapeXml(option.optionText)}" id="option${optionStatus.index}${status.index}" name="questions[${status.index}].options[${optionStatus.index}].optionText" class="inp opInput" style="margin-left:5px;width:90%;"  title="${fn:escapeXml(option.optionText)}" />
                                </li>
                            </c:forEach>
<%--                             <li>선택사유 <input type="text" id="reason${status.index}" name="reason${status.index}" class="inp" style="width:650px;"/></li> --%>
                        </ul>
                        <li id="optionAmount" class="option_amount"><strong>항목 갯수 조정</strong>
			               <a href="javascript:void(0);" class="addOptionBtn" data-question="1"><img src="/img/sub/particiation/plus.png" alt="설문조사" style="border:none; margin-left:5px; display:inline-block; width:14px;"/></a>
	           			   <a href="javascript:void(0);" class="removeOptionBtn" data-question="1"><img src="/img/sub/particiation/minus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a>
           			   </li>
					</div>
              </c:forEach>
               </td>
              </tr>
              
              <tr class="fileRow">
               <th class="fileTh">
               <div class="fileHeader">
	               <span class="fileSpan">첨부파일</span>
	               	<button type="button" class="addFileBtn">
	                        <img
	                          style="display: inline-block; height:14px;"
	                          src="/img/sub/particiation/plus.png"
	                        />
	                </button>
	                <button type="button" class="removeFileBtn">
	                        <img
	                          style="display: inline-block; height:14px;"
	                          src="/img/sub/particiation/minus.png"
	                        />
	                </button>
                </div>
               </th>
               <td colspan="5" class="tl file-container">
               	<c:if test="${not empty files}">
               	<div class="existing-files">
               		<c:forEach items="${files}" var="file">
		                <div class="file-item">
<%-- 	                        <c:choose> --%>
<%-- 	                            <c:when test="${fn:endsWith(file.fileName, '.pdf')}"> --%>
<!-- 	                                <img src="/img/sub/btn/btn_pdf.gif" alt="pdf" /> -->
<%-- 	                            </c:when> --%>
<%-- 	                            <c:otherwise> --%>
<!-- 	                                <img src="/img/sub/btn/btn_down.gif" alt="file" /> -->
<%-- 	                            </c:otherwise> --%>
<%-- 	                        </c:choose> --%>
							<img src="/img/sub/btn/btn_down.gif" alt="file" />
	                        <a href="${pageContext.request.contextPath}/particiation/download?fileId=${file.fileId}&surveyId=${board.surveyId}" title="${file.originFileName}">${file.originFileName}</a>
	                        <a href="#" name="file-delete" data-file-id="${file.fileId}" data-survey-id="${board.surveyId}">&nbsp;삭제</a>
	                        <input type="hidden" name="existingFileIds" value="${file.fileId}" />
                    	</div>
		            </c:forEach>
		        </div>
               	</c:if><input type="file" id="surveyFile" name="file" /></td>
               
              </tr>
              
            </tbody>
          </table>
          </form>
          
          <p class="pt40"></p>
          <!-- btn--> 
          <span class="bbs_btn"> 

          <span class="wte_l"><a href="${pageContext.request.contextPath}/particiation/researchList" class="wte_r">목록</a></span>
          <span id="reg" class="per_l"><a href="javascript:void(0);" class="pre_r" onclick="sendPost();">확인</a></span>
          <span class="wte_l"><a href="${pageContext.request.contextPath}/particiation/researchView?id=${board.surveyId}" class="wte_r">취소</a></span>
          
          
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
