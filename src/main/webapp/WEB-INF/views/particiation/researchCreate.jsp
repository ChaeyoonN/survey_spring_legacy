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

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- Air datepicker -->
<link href="/datepicker/css/datepicker.min.css" rel="stylesheet" type="text/css" media="all"/>
<script src="/datepicker/js/jquery-3.1.1.min.js"></script>
<script src="/datepicker/js/datepicker.min.js"></script><!-- Air datepicker js -->
<script src="/datepicker/js/datepicker.ko.js"></script> <!-- 달력 한글 추가를 위해 커스텀 -->
<style>
.research .option_amount {
	margin-top:5px;
	margin-left:15px;
}
.invalid-input {
    border: 2px solid #666;;
}
.research .inp.qInput {
/* 	margin-left:5px; */
	width: 90%;
}
.research .inp.opInput {
/* 	margin-left:5px; */
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
    /* display:table-cell; */
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
	var count = 1; // 아이템의 초기 인덱스 설정
	var fileCount = 1;
    var optionCounts = [5]; // 각 문제의 옵션 수를 추적하는 배열, 초기값은 첫 번째 문제의 5개 옵션
	
 	// 숫자를 ①, ②, ③ ... 형태로 변환하는 함수
    function convertToCircleNumber(number) {
        const circleNumbers = ["①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩", "⑪"];
        return circleNumbers[number - 1] || number;
    }
    // 설문의 문제수 input 값으로 넣기
//     $('#queCnt').attr('value', count);
    
    // 아이템 추가 버튼 클릭 이벤트를 상위 요소에 위임
    $(document).on("click", ".addItemBtn", function(e) {
        e.preventDefault();
        count++;
        optionCounts.push(5); // 새로 추가되는 문제의 초기 옵션 수를 5로 설정
        
        document.getElementById("qCnt").innerHTML = count + '개<a href="javascript:void(0);" class="addItemBtn"><img src="/img/sub/particiation/plus.png" alt="설문조사" style="border:none; margin-left:5px; display:inline-block; width:14px;"/></a>' +
            '<a href="javascript:void(0);" class="removeItemBtn"><img src="/img/sub/particiation/minus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a>';
        
        var item = '<div class="research">' +
        '<p><label for="question' + count + '">문제 '+count+'.</label><input type="text" style="margin-left: 5px;width:90%;" id="question' + count + '" name="questions[' + (count - 1) + '].questionText" class="inp qInput" placeholder="100자 이내로 적어주세요."/></p>' +
        '<ul>';
        
        for (var i = 1; i <= 5; i++) {
            item += '<li><label for="option' + i + count + '">항목 ' + convertToCircleNumber(i) + '</label><input type="text" style="margin-left: 5px;width:90%;" id="option' + i + count + '" name="questions[' + (count - 1) + '].options[' + (i - 1) + '].optionText" class="inp opInput" title="항목" placeholder="50자 이내로 적어주세요."/></li>';
        }

        item += '</ul>' +
            '<li id="optionAmount'+ count +'" class="option_amount" style="margin-top:5px;margin-left:5px;"><strong>항목 갯수 조정</strong><a href="javascript:void(0);" class="addOptionBtn" data-question="' + count + '"><img src="/img/sub/particiation/plus.png" alt="항목 추가" style="border:none; display:inline-block; width:16px;"/></a>' +
            '<a href="javascript:void(0);" class="removeOptionBtn" data-question="' + count + '"><img src="/img/sub/particiation/minus.png" alt="항목 삭제" style="border:none; display:inline-block; width:16px;"/></a></li>' +
            '</div>';
//             var item = '<div class="research">' +
//             '<p>'+count+'.<input type="text" id="question' + count + '" name="questions[' + (count - 1) + '].questionText" class="inp qInput" placeholder="100자 이내로 적어주세요."/></p>' +
//             '<ul>' +
//             '<li>①<input type="text" id="option1' + count + '" name="questions[' + (count - 1) + '].options[0].optionText" class="inp opInput"  title="매우그렇다" placeholder="50자 이내로 적어주세요."/></li>' +
//             '<li>②<input type="text" id="option2' + count + '" name="questions[' + (count - 1) + '].options[1].optionText" class="inp opInput"  title="그렇다" placeholder="50자 이내로 적어주세요."/></li>' +
//             '<li>③<input type="text" id="option3' + count + '" name="questions[' + (count - 1) + '].options[2].optionText" class="inp opInput"  title="보통이다" placeholder="50자 이내로 적어주세요."/></li>' +
//             '<li>④<input type="text" id="option4' + count + '" name="questions[' + (count - 1) + '].options[3].optionText" class="inp opInput"  title="그렇지않다" placeholder="50자 이내로 적어주세요."/></li>' +
//             '<li>⑤<input type="text" id="option5' + count + '" name="questions[' + (count - 1) + '].options[4].optionText" class="inp opInput"  title="매우그렇지않다" placeholder="50자 이내로 적어주세요."/></li>' +
//             '</ul>' +
//             '<li id="optionAmount"'+ count +'class="option_amount" style="margin-top:5px;margin-left:15px;"><strong>항목 갯수 조정</strong><a href="javascript:void(0);" class="addOptionBtn" data-question="' + count + '"><img src="/img/sub/particiation/plus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a>' +
//             '<a href="javascript:void(0);" class="removeOptionBtn" data-question="' + count + '"><img src="/img/sub/particiation/minus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a></li>' +
//             '</div>';

        $(item).appendTo("#surveyContent");
        // 설문의 문제수 input 값으로 넣기
//         $('#queCnt').attr('value', count);
    });

    // 아이템 삭제 버튼 클릭 이벤트
    $(document).on("click", ".removeItemBtn", function(e) {
        e.preventDefault();
        if(count <= 1) {
            alert("설문의 문제는 1개 이상이어야 합니다.");
        } else {
            $("#surveyContent div").last().remove();
            // optionCounts.pop(); // 마지막 문제의 옵션 수 제거
            count--; // 아이템 인덱스 감소
            
            document.getElementById("qCnt").innerHTML = count + '개<a href="javascript:void(0);" class="addItemBtn"><img src="/img/sub/particiation/plus.png" alt="설문조사" style="border:none; margin-left:5px; display:inline-block; width:14px;"/></a>' +
                '<a href="javascript:void(0);" class="removeItemBtn"><img src="/img/sub/particiation/minus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a>';
        }
     // 설문의 문제수 input 값으로 넣기
//         $('#queCnt').attr('value', count);
    });
	
    // 옵션 추가 버튼 이벤트
    $(document).on("click", ".addOptionBtn", function(e) {
        e.preventDefault();
        var questionIndex = $(this).data('question'); // 해당 옵션 추가 버튼이 속한 문제의 인덱스
        if(optionCounts[questionIndex-1] < 10){ // 옵션 수가 5개 미만인 경우에만 추가 가능
            optionCounts[questionIndex-1]++;
            var optionCount = optionCounts[questionIndex-1];
            var optionHtml = '<li><label for="option'+optionCount+questionIndex+'">항목 '+convertToCircleNumber(optionCount)+'<input type="text" style="margin-left:5px;width:90%;" id="option'+optionCount+questionIndex+'" name="questions['+(questionIndex-1)+'].options['+(optionCount-1)+'].optionText" class="inp opInput" title="항목" placeholder="50자 이내로 적어주세요."/></li>';
            $(optionHtml).appendTo($(this).closest('.research').find('ul'));
        } else {
            alert("항목은 최대 10개까지만 추가할 수 있습니다.");
        }
    });

    // 옵션 삭제 버튼 이벤트
    $(document).on("click", ".removeOptionBtn", function(e) {
        e.preventDefault();
        var questionIndex = $(this).data('question'); // 해당 옵션 삭제 버튼이 속한 문제의 인덱스
        if(optionCounts[questionIndex-1] > 2){ // 옵션 수가 2개 이상인 경우에만 삭제 가능
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
      console.log(fileCount);
      newInput.id = 'surveyFile'+fileCount;
      newInput.name = 'file';
      document.querySelector('.file-container').appendChild(newInput);
      updateFileInputs(); // 간격 마진
   		// 새로운 파일 인풋에 이벤트 리스너 추가
      newInput.addEventListener('change', function() {
          checkFileSize(newInput);
      });
      window.scrollTo(0, scrollPosition);
    });

    document.querySelector('.removeFileBtn').addEventListener('click', function() {
    	// 현재 스크롤 위치 저장
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

}); // $(document).ready 끝
// 전역 변수
var maxFileSize = 1073741824; // 1GB in bytes

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
	
function formToObject(formSelector) {
    const form = document.querySelector(formSelector);
    
    var formData = new FormData(form);
    const result = {
        questions: [],
        title: '',
        startDate: '',
        endDate: ''
    };

    formData.forEach((value, key) => {
        if (key === 'title' || key === 'startDate' || key === 'endDate') {
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
        else if(optionText.length > 50) {
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
    
    if(!confirm("설문을 등록하시겠습니까?\n( 현재날짜 기준으로 진행예정인 설문만 수정할 수 있습니다. )")) {
    	return;
    }
    
    var obj = formToObject('#boardForm');
    var form = document.getElementById('boardForm');
    var formData = new FormData(form);
    var data = document.boardForm.file;
    console.log(data);
    // 파일 데이터를 FormData에 추가
	formData.append("file", data.files); 
 	// JSON 데이터를 FormData에 추가
    formData.append('surveyDTO', new Blob([JSON.stringify(obj)], { type: "application/json" }));
    
    console.log(data.files);
//     if(data.files) {
// 	 	// 최대 파일 크기 설정 (예: 1GB)
// 	    var maxFileSize = 1073741824; // 1GB in bytes
// 	    // 파일 크기 검증
// 	    var isFileTooLarge = false;
// 	    for (var i = 0; i < data.files.length; i++) {
// 	    	if (data.files[i].size > maxFileSize) {
// 	            isFileTooLarge = true;
// 	            break;
// 	        }
// 	    }
// 	    if (isFileTooLarge) {
// 	        alert("파일 크기가 1GB를 초과합니다. 다른 파일을 선택해 주세요.");
// 	        return;
// 	    } 
//     }
 	// FormData 내용 확인
    for (var pair of formData.entries()) {
        console.log(pair[0]+ ', ' + pair[1]); 
    }

    $.ajax({
        url: '${pageContext.request.contextPath}/particiation/researchCreate',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function (data) {
            location.href = "${pageContext.request.contextPath}/particiation/researchList";
        },
        //error: function (xhr, status, error) {
            error: function (xhr) {
            //console.log(xhr);
            //console.log(status);
            //console.log(error);
            if (xhr.status === 413) {
                alert("파일 크기가 너무 큽니다. 최대 1GB까지 업로드할 수 있습니다.");
            } else if (xhr.status === 500) {
                alert("파일 업로드 중 오류가 발생했습니다.");
            } else {
                alert("등록에 실패했습니다. 다시 시도해 주세요.");
            }
        }
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
        <!-- 파일 전송을 위한 multipart 선언 -->
<!--         enctype="multipart/form-data" -->
        <form method="post" id="boardForm" name="boardForm" enctype="multipart/form-data">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl_type01" summary="설문조사">
            <caption>
            설문조사
            </caption>
            <colgroup>
            <col width="20%"/>
            <col width="25%"/>
            <col width="25%"/>
            <col width="30%"/>
<%--             <col width="15%"/> --%>
<%--             <col width="%"/> --%>
            </colgroup>
            <tbody>
              <tr>
                <th>제목</th>
                <td colspan="5" class="tl"><input type="text" id="surTitle" name="title" class="inp" placeholder="제목은 50자 이내로 적어주세요."/></td>
                </tr>
              <tr>
                <th>시작일</th>
                <td class="tl"><input type="date" id="start-date" name="startDate" class="inp" style="width:100px;" required/></td>
                <th>종료일</th>
                <td class="tl"><input type="date" id="end-date" name="endDate" class="inp" style="width:100px;" required/></td>
<!--                 <th>결과확인</th> -->
<!--                 <td class="tl"> -->
<!--                 	<img src="/img/sub/btn/btn_view.gif" alt="결과보기" /> -->
<!--                 </td> -->
              </tr>
              <tr>
                <th>문제수</th>
                <td id="qCnt" colspan="5" class="tl">
<!--                 <input type="hidden" id="queCnt" name="queCnt" value=""/> -->
	                1개<a class="addItemBtn"><img src="/img/sub/particiation/plus.png" alt="설문조사" style="border:none; margin-left:5px; display:inline-block; width:14px;"/></a>
	                <a class="removeItemBtn"><img src="/img/sub/particiation/minus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a>
                </td>
                </tr>
              
              <tr>
               <td id="surveyContent" colspan="6" class="tl">
               	   <div class="research">
               	   	   <!-- id = question + 문제번호 -->
                       <p id="surveyNo"><label for="question1">문제 1.</label><input type="text" style="margin-left:5px;" id="question1" name="questions[0].questionText" class="inp qInput" placeholder="100자 이내로 적어주세요."/></p>
                       <ul>
                       <!-- id = option + 옵션번호 + 문제번호 -->
		                <li><label for="option11">항목 ①</label><input style="margin-left:5px;" type="text" id="option11" name="questions[0].options[0].optionText" class="inp opInput" title="매우그렇다" placeholder="50자 이내로 적어주세요."/></li>
		                <li><label for="option21">항목 ②</label><input style="margin-left:5px;" type="text" id="option21" name="questions[0].options[1].optionText" class="inp opInput" title="그렇다" placeholder="50자 이내로 적어주세요."/></li>
		                <li><label for="option31">항목 ③</label><input style="margin-left:5px;" type="text" id="option31" name="questions[0].options[2].optionText" class="inp opInput" title="보통이다" placeholder="50자 이내로 적어주세요."/></li>
		                <li><label for="option41">항목 ④</label><input style="margin-left:5px;" type="text" id="option41" name="questions[0].options[3].optionText" class="inp opInput" title="그렇지않다" placeholder="50자 이내로 적어주세요."/></li>
		                <li><label for="option51">항목 ⑤</label><input style="margin-left:5px;" type="text" id="option51" name="questions[0].options[4].optionText" class="inp opInput" title="매우그렇지않다" placeholder="50자 이내로 적어주세요."/></li>
		               </ul>
		               <li id="optionAmount" class="option_amount"><strong>항목 갯수 조정</strong>
			               <a href="javascript:void(0);" class="addOptionBtn" data-question="1"><img src="/img/sub/particiation/plus.png" alt="설문조사" style="border:none; margin-left:5px; display:inline-block; width:14px;"/></a>
	           			   <a href="javascript:void(0);" class="removeOptionBtn" data-question="1"><img src="/img/sub/particiation/minus.png" alt="설문조사" style="border:none; display:inline-block; width:16px;"/></a>
           			   </li>
					</div>
<!--                     <div class="research"> -->
<!--                        <p><input type="text" id="aa" name="aa" class="inp"  title="1. 위생불량 납품단절 편함" /></p> -->
<!--                         <ul> -->
<!--                         <li><input type="text" id="aa" name="aa" class="inp"  title="매우그렇다" /></li> -->
<!--                         <li><input type="text" id="aa" name="aa" class="inp"  title="매우그렇다" /></li> -->
<!--                         <li><input type="text" id="aa" name="aa" class="inp"  title="매우그렇다" /></li> -->
<!--                         <li><input type="text" id="aa" name="aa" class="inp" title="매우그렇다" /></li> -->
<!--                         <li><input type="text" id="aa" name="aa" class="inp"  title="매우그렇다" /></li> -->
<!--                         <li>선택사유 <input type="text" id="aa" name="aa" class="inp" style="width:650px;" /> </li> -->
<!--                         </ul> -->
<!-- 					</div> -->
                    
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
               <td colspan="5" class="tl file-container"><input type="file" id="surveyFile" name="file"/></td>
               
              </tr>
              
            </tbody>
          </table>
<!--           <input type="hidden" name="writer" id="writer" value="사람입니다"/> -->
<!--           <input type="hidden" name="regName" id="regName" value="사람입니다"/> -->
<!--           <input type="hidden" name="udtName" id="udtName" value="사람입니다"/> -->
          
          </form>
          <p class="pt40"></p>
          <!-- btn--> 
          <span class="bbs_btn"> 

          <span class="wte_l"><a href="${pageContext.request.contextPath}/particiation/researchList" class="wte_r">목록</a></span>
          <span id="reg" class="per_l"><a href="javascript:void(0);" class="pre_r" onclick="sendPost();">등록</a></span>
          <span class="wte_l"><a href="${pageContext.request.contextPath}/particiation/researchList" class="wte_r">취소</a></span>

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
