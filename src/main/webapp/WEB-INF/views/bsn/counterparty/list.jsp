<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>

<head>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<link rel="stylesheet"
	  href="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/motion-tailwind.css"
	  rel="stylesheet">

<link rel="stylesheet"
	  href="https://horizon-tailwind-react-corporate-7s21b54hb-horizon-ui.vercel.app/static/css/main.d7f96858.css" />

<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>

<!-- SweetAlert2 라이브러리 로드 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<style>

@font-face {
	font-family: 'Pretendard-Regular';
	src:
		url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff')
		format('woff');
	font-weight: 100;
	font-style: normal;
}

body {
	font-family: 'Pretendard-Regular', sans-serif;
}

#addr {
    visibility: hidden; /* 기본적으로 숨김 */
}

.card-header {
    border: none;  /* 테두리 제거 */
}

.modal {
    display: flex;
    justify-content: center; /* 수평 중앙 정렬 */
    align-items: center;     /* 수직 중앙 정렬 */
    position: fixed;
    z-index: 5000;
    inset: 0;
    overflow-y: auto;
    min-height: 100vh; /* 화면 높이만큼 중앙 정렬 */
    background-color: rgba(0, 0, 0, 0.5); /* 회색 반투명 배경 유지 */
}

.modal-content {
    position: relative;
    background-color: white;
    padding: 50px;
    border-radius: 10px;
    max-width: 950px; /* 모달의 최대 너비 설정 */
    width: 100%;      /* 화면 크기에 맞게 조정 */
    margin: auto;     /* 중앙으로 정렬 */
    margin-left: 25%; 
}

/* 필요시 모달을 화면 상단에 배치하는 방법 */
.modal-content-top {
    margin-top: 2.5%; /* 상단에서 10%만큼 떨어지도록 설정 */
}

/* 회색 배경을 유지하면서 모달만 이동 */
.modal-background {
    background-color: rgba(0, 0, 0, 0.5); /* 회색 배경 유지 */
}


.swal2-icon { /* 아이콘 */ 
		font-size: 8px !important;
		width: 40px !important;
		height: 40px !important;
	}

	.swal2-confirm, .swal2-cancel {
		font-size: 14px; /* 텍스트 크기 조정 */
		width: 75px;
		height: 35px;
		padding: 0px;
	}
	
	.swal2-styled.swal2-cancel {
	    font-size: 14px;
	    background-color: #f8f9fa;
	    color: black;
	    border: 1px solid #D9D9D9;
	}
	
	.swal2-styled.swal2-confirm {
	    font-size: 14px;
	}
	
	.swal2-title { /* 타이틀 텍스트 사이즈 */
		font-size: 18px !important;
		padding-top: 1.5em;
    	padding-bottom: 0.5em;
	}
	
	.swal2-container.swal2-center>.swal2-popup {
		padding-top: 30px;
		width: 450px;
	}
	
	.swal2-input {
	    font-size: 15px;
	    height: 2em;
	    padding-top: 18px;
	    padding-bottom: 18px;
	    width: 270px; /* 원하는 너비로 설정 */
	    margin: 0 auto; /* 가운데 정렬 */
	    display: block; /* 인풋 필드를 블록 요소로 만들어서 margin이 적용되도록 */
	    text-align: center;
	    margin-top: 20px;
    	margin-bottom: 5px;
	}
	
	.swal2-input:focus {
		border : 1px solid #4E7DF4;
	}
	
	.swal2-input::placeholder {
	    color: #7a7a7a; /* 어둡게 설정 */
	    font-weight: 100; /* 얇게 설정 */
	}

.swal2-icon { /* 아이콘 */ 
	font-size: 8px !important;
	width: 40px !important;
	height: 40px !important;
}

.swal2-styled.swal2-cancel {
   font-size: 14px;
   background-color: #f8f9fa;
   color: black;
   border: 1px solid #D9D9D9;
}

.swal2-styled.swal2-confirm {
   font-size: 14px;
   margin-left: 10px;
}

.swal2-title { /* 타이틀 텍스트 사이즈 */
	font-size: 18px !important;
	padding: 2em;
}

.swal2-container.swal2-center>.swal2-popup {
	padding-top: 30px;
	z-index: 99999 !important; /* SweetAlert을 최상위로 설정 */
    display: block; /* 창이 보이지 않도록 숨겨진 경우 강제로 표시 */
}

</style>


<script type="text/javascript">
	// 토큰
	const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
	const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

</script>

<script type="text/javascript">

// daum 주소 API용
$(function() {
	
	console.log("주소 검색 확인");

	$("#addr").on("click", function() {
	    new daum.Postcode({
	    	// 다음 창에서 검색이 완료되어 클릭하면 콜백함수에의해
	    	// 결과 데이터(JSON String)가 data객체로 들어온다.
	        oncomplete: function(data) {
	        	// data{"zonecode" : "12345", "address" : "대전 중구", "buildingName" : "123-67"}
	        	$("#coRoadNmZip").val(data.zonecode);
	        	$("#coRoadNmAddr").val(data.address);
	        	$("#coDaddr").val(data.buildingName);
	        	$("#coDaddr").focus();
	        }
	    }).open();
	});
});

//전화번호 포매팅 함수 (글로벌 스코프)
function formatPhoneNumber(number) {
    // 숫자가 아닌 문자는 모두 제거
    number = number.replace(/[^\d]/g, '');

    if (number.length === 11) {
        // 11자리 전화번호 포맷팅 (휴대폰 번호)
        return number.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
    } else if (number.length === 10) {
        // 10자리 전화번호 포맷팅 (일반 전화번호)
        return number.replace(/(\d{2,3})(\d{3,4})(\d{4})/, '$1-$2-$3');
    } else {
        return number; // 포매팅이 불가능할 경우 원래 값을 반환
    }
}

// 연락처 포매팅 함수 (글로벌 스코프)
function formatContactDetails(response) {
    var formattedRprsTelno = formatPhoneNumber(response.counterPartyVO.rprsTelno);
    var formattedFax = formatPhoneNumber(response.counterPartyVO.cnptFxno);
    $('#rprsTelno').val(formattedRprsTelno);
    $('#cnptFxno').val(formattedFax);
}

// 날짜 포매팅 함수 (글로벌 스코프)
function formatDateString(dateString) {
    if (dateString && dateString.length === 8) {
        return dateString.replace(/(\d{4})(\d{2})(\d{2})/, '$1.$2.$3');
    }
    return dateString;
}

// 날짜 필드에 포맷된 값 적용 (글로벌 스코프)
function formatDateDetails(response) {
    var formattedFndnYmd = formatDateString(response.counterPartyVO.fndnYmd);
    var formattedCtrtCnclsYmd = formatDateString(response.counterPartyVO.ctrtCnclsYmd);
    $('#fndnYmd').val(formattedFndnYmd);
    $('#ctrtCnclsYmd').val(formattedCtrtCnclsYmd);
}

//업종명 포매팅 함수 (글로벌 스코프)
function setIndustryName(response) {
    // 원본 업종코드 저장
    $('#indutyCd').data('original', response.counterPartyVO.indutyCd);

    // 업종명을 indutyNm으로 포맷해서 설정
    var formattedIndutyNm = response.counterPartyVO.indutynm;  // 업종명 포맷 (이미 포맷된 데이터 사용)
    $('#indutyCd').val(formattedIndutyNm);  // 포맷된 업종명을 표시
}


function searchDetail(cnptNo) {
    
	console.log("Ajax 요청 시작");

    $.ajax({
        url: '/counterparty/detail',  // 절대 경로로 설정
        type: 'GET',
        data: { cnptNo: cnptNo },  // 요청 파라미터
        dataType: 'json',  // 서버로부터 JSON 형식의 응답을 기대
        success: function(response) {
            console.log("응답 데이터:", response);
            
            if (response && response.counterPartyVO) {
		        
            	// 각 ID에 Ajax로 받은 데이터를 채워 넣음
		        document.getElementById("cnptNo").value = response.counterPartyVO.cnptNo;
		        document.getElementById("cmrcNm").value = response.counterPartyVO.cmrcNm;
		        document.getElementById("rprsvNm").value = response.counterPartyVO.rprsvNm;
		        document.getElementById("cnptBrno").value = response.counterPartyVO.cnptBrno;
		        document.getElementById("rprsTelno").value = response.counterPartyVO.rprsTelno;
		        document.getElementById("cnptFxno").value = response.counterPartyVO.cnptFxno;
		        document.getElementById("fndnYmd").value = response.counterPartyVO.fndnYmd;
		        document.getElementById("ctrtCnclsYmd").value = response.counterPartyVO.ctrtCnclsYmd;
		        document.getElementById("indutyCd").value = response.counterPartyVO.indutyCd;
		        document.getElementById("coRoadNmAddr").value = response.counterPartyVO.coRoadNmAddr;
		        document.getElementById("coDaddr").value = response.counterPartyVO.coDaddr;
		        document.getElementById("coRoadNmZip").value = response.counterPartyVO.coRoadNmZip;
		        document.getElementById("rmrkCn").value = response.counterPartyVO.rmrkCn;
		        
		        // 원본 데이터를 저장하기 위해 data-* 속성에 저장 [포매팅으로 인해 저장 필요]
                $("#rprsTelno").data('original', response.counterPartyVO.rprsTelno);
                $("#cnptFxno").data('original', response.counterPartyVO.cnptFxno);
                $("#fndnYmd").data('original', response.counterPartyVO.fndnYmd);
                $("#ctrtCnclsYmd").data('original', response.counterPartyVO.ctrtCnclsYmd);

		        
		     	// 모든 input 태그에 대해 background-color 적용
                $('#modalBody input').css("background-color", "#f9fafb");
		     	
                // 전화번호 포매팅
                formatContactDetails(response);
                // 업종명 표시
                setIndustryName(response);
                // 날짜 포매팅
                formatDateDetails(response);
            
            } else {
                console.error("counterPartyVO 데이터가 없습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX 에러:", error);
            console.error("상태 코드:", xhr.status);
            console.error("응답 텍스트:", xhr.responseText);
            alert('데이터를 불러오는 데 실패했습니다. 오류: ' + error);
        }
    });
    
}
	
// Modal 띄우기 이벤트
$(document).on('click', '.modal-btn', function(){
	
	$('body').css('overflow', 'hidden'); // 페이지 스크롤 비활성화
	$('#detailModal').css('display', 'block');

});
	

// list 화면 stat 이벤트용 function
$(function(){
	
	//stats 이벤트
	let numbers = document.querySelectorAll("[countTo]");

    numbers.forEach((number) => {
        let ID = number.getAttribute("id");
        let value = number.getAttribute("countTo");
        let countUp = new CountUp(ID, value);

        if (number.hasAttribute("data-decimal")) {
        const options = {
           		decimalPlaces: 1,
            };
        countUp = new CountUp(ID, 2.8, options);
        } else {
        countUp = new CountUp(ID, value);
        }

        if (!countUp.error) {
        countUp.start();
        } else {
        console.error(countUp.error);
        number.innerHTML = value;
        }
    });
})

// 수정 및 일반모드 처리 로직
$(document).ready(function() {
		
    // 원래 label 텍스트를 저장할 전역 변수
    var originalLabels = {};
	
	// 수정 버튼을 클릭하면 수정 가능 모드로 변경
	$("#editBtn").click(function() {
		
        // 수정 모드가 처음일 때 한 번만 원래 label 텍스트를 저장
        if (!originalLabels['rprsTelno']) {
            originalLabels['rprsTelno'] = $("label[for='rprsTelno']").html();  // 원래 텍스트 저장
        }
        if (!originalLabels['cnptFxno']) {
            originalLabels['cnptFxno'] = $("label[for='cnptFxno']").html();  // 원래 텍스트 저장
        }
		
		// 수정이 가능한 필드의 readonly 속성 해제
		$("[name='cmrcNm'], [name='rprsvNm'], [name='rprsTelno'],[name='cnptFxno'], [name='coRoadNmZip'], [name='coRoadNmAddr'], [name='coDaddr']").attr("readonly", false).css("background-color", "#FFFFFF");
		
		// 변경되지 않아야 하는 필드는 여전히 readonly 유지
		$("[name='cnptNo'], [name='cnptBrno'], [name='fndnYmd'], [name='ctrtCnclsYmd']").attr("readonly", true).css("background-color", "#f9fafb");
		
		// 비고 내용을 textarea로 변환
		const rmrkCnValue = $("input[name='rmrkCn']").val();  // 현재 input 값 가져오기
		originalRemarkHtml = $("#remarkField").html();  // 원본 HTML 저장
		
		// input을 textarea로 변경
		$("#remarkField").html(`
		<label for="rmrkCn" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
			비고 내용
		</label>
		<textarea id="rmrkCn" name="rmrkCn" rows="4"
		    	  class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
		>
			${rmrkCnValue}
		</textarea>
		`);
		
	    // 포맷된 데이터를 원본 값으로 복구
	    $("#rprsTelno").val($("#rprsTelno").data('original'));
	    $("#cnptFxno").val($("#cnptFxno").data('original'));
	    $("#fndnYmd").val($("#fndnYmd").data('original'));
	    $("#ctrtCnclsYmd").val($("#ctrtCnclsYmd").data('original'));
	    $("#indutyCd").val($("#indutyCd").data('original'));
		
	 	// 수정 시 label 텍스트 변경 (스타일 추가)
        originalLabels['rprsTelno'] = $("label[for='rprsTelno']").html();  // 원래 텍스트 저장
        $("label[for='rprsTelno']").html("대표 전화번호 <span class='font-thin text-xs' style='color: #848484;'>  하이픈(-)을 제외한 숫자만 입력하세요.</span>");

        originalLabels['cnptFxno'] = $("label[for='cnptFxno']").html();  // 원래 텍스트 저장
        $("label[for='cnptFxno']").html("FAX 번호 <span class='font-thin text-xs' style='color: #848484;'>  하이픈(-)을 제외한 숫자만 입력하세요.</span>");
	    
		// 주소 검색 버튼을 보이게 설정
		$("#addr").css("visibility", "visible");
		     
		// 수정 버튼 숨기고 등록/취소 버튼 보이기
		$(this).hide();
		$("#deleteBtn").hide();
		  
		// 등록/취소 버튼 동적으로 추가
		$("#modalBody").after(`
		 <div class="flex justify-end">
		 	<button id="saveBtn" class="bg-white text-[#848484] px-4 py-2 border border-[#848484] rounded mr-2">등록</button>
		 	<button id="cancelBtn" class="bg-[#848484] text-white px-4 py-2 rounded">취소</button>
		 </div>
		  `);
	});

	// 취소 버튼 클릭 시 수정 모드 취소
	$(document).on('click', '#cancelBtn', function() {
	   
		// 다시 readonly 속성 추가
		$('#modalBody input').attr('readonly', true).css("background-color", "#f9fafb");
		
		// 비고 내용을 다시 input으로 변환
		$("#remarkField").html(originalRemarkHtml);  // 저장된 원본 HTML 복원
		
		// 주소 검색 버튼을 숨김
		$("#addr").css("visibility", "hidden");
		   
		// 등록/취소 버튼 숨기고 수정/삭제 버튼 보이기
		$(this).parent().remove();
		$("#editBtn").show();
		$("#deleteBtn").show();
		
	    // 취소 시 포맷된 데이터를 다시 적용
	    // 전화번호 포매팅
	    var formattedRprsTelno = formatPhoneNumber($("#rprsTelno").data('original'));
	    var formattedFax = formatPhoneNumber($("#cnptFxno").data('original'));
	    $('#rprsTelno').val(formattedRprsTelno);
	    $('#cnptFxno').val(formattedFax);

	    // 날짜 포맷팅
	    var formattedFndnYmd = formatDateString($("#fndnYmd").data('original'));
	    var formattedCtrtCnclsYmd = formatDateString($("#ctrtCnclsYmd").data('original'));
	    $('#fndnYmd').val(formattedFndnYmd);
	    $('#ctrtCnclsYmd').val(formattedCtrtCnclsYmd);
	    
        // label 텍스트를 원래대로 복구
        $("label[for='rprsTelno']").html(originalLabels['rprsTelno']);
        $("label[for='cnptFxno']").html(originalLabels['cnptFxno']);
	   
	});

	// 등록 버튼 클릭 시 업데이트 처리
	$(document).on('click', '#saveBtn', function() {
    
		// Ajax 호출로 데이터를 서버에 업데이트
		var updatedData = {
			cnptNo: $('#cnptNo').val(),
			cmrcNm: $('#cmrcNm').val(),
			rprsvNm: $('#rprsvNm').val(),
			cnptBrno: $('#cnptBrno').val(),
			rprsTelno: $('#rprsTelno').val(),
			cnptFxno: $('#cnptFxno').val(),
			fndnYmd: $('#fndnYmd').val(),
			ctrtCnclsYmd: $('#ctrtCnclsYmd').val(),
			indutyCd: $('#indutyCd').val(),
			coRoadNmAddr: $('#coRoadNmAddr').val(),
			coDaddr: $('#coDaddr').val(),
			coRoadNmZip: $('#coRoadNmZip').val(),
			rmrkCn: $('#rmrkCn').val()
		};

		$.ajax({
			url: '/counterparty/update',  // 적절한 업데이트 URL
			type: 'POST',
			data: updatedData,
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeader, csrfToken);  // CSRF 토큰을 요청 헤더에 포함
			},
			success: function(response) {
				if (response === "success") {
					success();
				$('#detailModal').hide();
				} else {
					alert('수정 중 오류가 발생했습니다.');
				}
			},
			error: function(error) {
				alert('수정 중 오류가 발생했습니다.');
			}
		});
	});
});


function success() {
	Swal.fire({
		title: '수정이 완료되었습니다.',
		icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
		confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
		confirmButtonText: '확인',
	
	}).then((result) => {
		if (result.isConfirmed) {
			location.reload(); // 페이지 리로드로 반영된 값 확인
		}
	});
};

	
$(document).on('click', '#deleteBtn', function() {
		
	console.log("삭제 버튼 클릭");
	
	if (confirm("정말로 삭제하시겠습니까?")) {
		var cnptNo = $('#cnptNo').val();  // 삭제할 거래처 번호 가져오기
			        
		$.ajax({
			url: '/counterparty/deletePost',  // 수정된 삭제 처리 URL
			type: 'POST',
			data: { cnptNo: cnptNo },  // 삭제할 거래처 번호
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeader, csrfToken);  // CSRF 토큰을 요청 헤더에 포함
			},
			success: function(response) {
				if (response === "success") {
					alert('삭제가 완료되었습니다.');
					$('#detailModal').hide();  // 모달 닫기
					location.reload();  // 페이지 새로고침으로 삭제 반영
				} else {
					alert('삭제 중 오류가 발생했습니다.');
				}
			},
			error: function(error) {
				alert('삭제 중 오류가 발생했습니다.');
			}
		});
	}
});

//Modal 닫기 버튼
$(document).on('click', '#closeModal', function() {
	$('body').css('overflow', 'auto'); // 페이지 스크롤 활성화
    $('#detailModal').css('display', 'none');  // Modal을 닫음
});

</script>

<!-- 거래처 주소록 페이지 :: 이재현 -->

</head>

<body>
	<div class="col-12" style="max-width: 1350px; margin: auto;">
		<form id="searchForm">
			<div class="card-header">
				<div style="margin-top: 30px; margin-bottom: 10px;">
					<h3 class="text-lg font-semibold text-slate-800">거래처 주소록</h3>
					<p class="text-slate-500">거래처와의 연락처를 쉽게 찾고 관리하세요</p>

					<!-- 거래처 관련 stats -->
					<div class="flex flex-col mx-auto w-full">
						<div class="w-full draggable">
							<div class="flex flex-col items-center gap-16 mx-auto my-4">
								<div class="grid grid-cols-4 gap-4 w-full">
									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] b order-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto1" countTo="${ctrtTotal}"></span>
										</h3>
										<p
											class="text-base font-medium leading-7 text-center text-dark-grey-600">전체
											계약 수</p>
									</div>

									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto2" countTo="${ctrtBeforeMonth}"></span>
										</h3>
										<p
											class="text-base font-medium leading-7 text-center text-dark-grey-600">전월
											계약 수</p>
									</div>

									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto3" countTo="${ctrtMonth}"></span>
										</h3>
										<p
											class="text-base font-medium leading-7 text-center text-dark-grey-600">당월
											계약 수</p>
									</div>

									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto4" countTo="${ctrtChange}"></span>%
										</h3>
										<p
											class="text-base font-medium leading-7 text-center text-dark-grey-600">전월
											대비 계약률</p>
									</div>

								</div>
							</div>
						</div>
					</div>
					<!-- 거래처 관련 stats 끝 -->

					<div class="input-group input-group-sm"
						style="width: 300px; margin-left: 77.3%;">
						<select class="form-control" style="width: 80px" id="selCategory"
							name="category">
							<option value="rprsvNm"
								<c:if test="${param.category=='rprsvNm'}">selected</c:if>>대표명</option>
							<option value="cmrcNm"
								<c:if test="${param.category=='cmrcNm'}">selected</c:if>>거래처명</option>
						</select> <input type="text" name="keyword" style="width: 180px"
							class="form-control float-right" value="${param.keyword}"
							placeholder="검색어를 입력하세요." />
						<div class="input-group-append">
							<button type="submit" class="btn btn-default">
								<i class="fas fa-search"></i>
							</button>
						</div>
					</div>
				</div>
			</div>
		</form>


		<div class="card" style="padding: 5px;margin-left: 17px;margin-right: 17px;">
			<div class="card-body table-responsive p-0">
				<table class="table table-hover text-nowrap">
					<thead>
						<tr>
							<th>번호</th>
							<th>거래처명</th>
							<th>업종</th>
							<th>대표명</th>
							<th>대표 번호</th>
							<th>계약 성사일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="CounterPartyVO" items="${counterPartyVOList}">
							<tr class="modal-btn"
								onclick="searchDetail('${CounterPartyVO.cnptNo}')">
								<!-- 클릭 시 Ajax 요청 발생 -->
								<td style="padding-left: 55px;">${CounterPartyVO.rnum}</td>
								<td>${CounterPartyVO.cmrcNm}</td>
								<td>${CounterPartyVO.indutynm}</td>
								<td>${CounterPartyVO.rprsvNm}</td>
								<td><c:if
										test="${fn:length(CounterPartyVO.rprsTelno) == 10}">
							      ${fn:substring(CounterPartyVO.rprsTelno, 0, 3)}-${fn:substring(CounterPartyVO.rprsTelno, 3, 6)}-${fn:substring(CounterPartyVO.rprsTelno, 6, 10)}
							    </c:if> <c:if test="${fn:length(CounterPartyVO.rprsTelno) == 9}">
							        ${fn:substring(CounterPartyVO.rprsTelno, 0, 2)}-${fn:substring(CounterPartyVO.rprsTelno, 2, 5)}-${fn:substring(CounterPartyVO.rprsTelno, 5, 9)}
							    </c:if></td>
								<td><fmt:parseDate var="parsedDate"
										value="${CounterPartyVO.ctrtCnclsYmd}" pattern="yyyyMMdd" />
									<fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" /></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<br>

			</div>
				<nav aria-label="Page navigation"
					 style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
					<ul class="inline-flex space-x-2">
						<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
						<li><c:if test="${articlePage.startPage gt 5}">
								<a
									href="/counterparty/list?currentPage=${articlePage.startPage-5}"
									class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color: #4E7DF4;"> <svg class="w-4 h-4 fill-current"
										viewBox="0 0 20 20">
											<path
											d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
											clip-rule="evenodd" fill-rule="evenodd"></path>
										</svg>
								</a>
							</c:if></li>

						<!-- 총 페이징 -->
						<c:forEach var="pNo" begin="${articlePage.startPage}"
							end="${articlePage.endPage}">
							<c:if test="${articlePage.currentPage == pNo}">
								<li>
									<button id="button-${pNo}"
										onclick="javascript:location.href='/counterparty/list?currentPage=${pNo}';"
										class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
										style="background-color: #4E7DF4; color: white;">${pNo}
									</button>
								</li>
							</c:if>

							<c:if test="${articlePage.currentPage != pNo}">
								<li>
									<button id="button-${pNo}"
										onclick="javascript:location.href='/counterparty/list?currentPage=${pNo}';"
										class="w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
										style="color: #4E7DF4;">${pNo}</button>
								</li>
							</c:if>
						</c:forEach>

						<!-- endPage < totalPages일 때만 [다음] 활성화 -->
						<li>
							<c:if test="${articlePage.endPage lt articlePage.totalPages}">
								<a href="/counterparty/list?currentPage=${articlePage.startPage+5}"
								   class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
								   style="color: #4E7DF4;">
									<svg class="w-4 h-4 fill-current"
									   viewBox="0 0 20 20">
										<path d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
											  clip-rule="evenodd" fill-rule="evenodd">
										</path>
									</svg>
								</a>
							</c:if>
						</li>
					</ul>
				</nav>
		</div>
	</div>

	<!-- 거래처 상세정보 Modal -->
	<div id="detailModal" class="modal" style="display: none;">
	    <div class="modal-content modal-content-top">
			<div id="modalHeader">
				<span id="closeModal"
					  class="close text-right cursor-pointer text-m font-bold"
					  onclick="closeModal()">
					 ✕
			    </span>
				<h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">거래처 정보</h2>
			</div>
			
			<br>
			
			<div id="modalBody">
				<!-- 여기 아래에 input 태그 추가 -->
				<div class="grid gap-5 mb-4 lg:grid-cols-2">
					<div>
						<label for="cnptNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							거래처 번호
						</label>
						<input type="text" id="cnptNo" name="cnptNo"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="cmrcNm"	class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							업체명
						</label>
						<input type="text" id="cmrcNm" name="cmrcNm"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="rprsvNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							대표자명
						</label>
						<input type="text" id="rprsvNm" name="rprsvNm"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="cnptBrno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							사업자  번호
						</label>
						<input type="text" id="cnptBrno" name="cnptBrno"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="rprsTelno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
						대표 전화번호
						</label>
						<input type="text" id="rprsTelno" name="rprsTelno"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="cnptFxno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							FAX 번호
						</label>
						<input type="text" id="cnptFxno" name="cnptFxno"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="fndnYmd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							설립 일자
						</label>
						<input type="text" id="fndnYmd" name="fndnYmd"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="ctrtCnclsYmd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							계약 성사일
						</label>
						<input type="text" id="ctrtCnclsYmd" name="ctrtCnclsYmd"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="indutyCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							업종 코드
						</label>
						<input type="text" id="indutyCd" name="indutyCd"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
				</div>	
				<div class="grid gap-5 mb-4 lg:grid-cols-2">
					<div class="relative w-full">
					    <label for="coRoadNmZip" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
					       	 우편번호
					    </label>
					    <div class="relative">
					        <input type="text" id="coRoadNmZip" name="coRoadNmZip"
					               class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 pr-20 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					               readonly>
					        <button id="addr" class="absolute inset-y-0 right-0 bg-[#848484] text-white active:bg-[#848484] font-bold uppercase text-sm px-4 py-2 rounded-r-lg outline-none focus:outline-none transition-all duration-150"
					                type="button" style="background-color: #848484; color: white;">
					            	주소 검색
					        </button>
					    </div>
					</div>
				</div>
				<div class="grid gap-5 mb-4 lg:grid-cols-2">
					<div>
						<label for="coRoadNmAddr" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							도로명 주소
						</label>
						<input type="text" id="coRoadNmAddr" name="coRoadNmAddr"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="coDaddr" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
						상세 주소
						</label>
						<input type="text" id="coDaddr" name="coDaddr"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
				</div>	
				<div class="grid gap-5 mb-4">
					<div id="remarkField">
						<label for="rmrkCn" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							비고 내용
						</label>
						<input type="text" id="rmrkCn" name="rmrkCn"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
				</div>
				<div class="flex justify-end">
					<button id="editBtn"
						class="bg-white text-[#848484] px-4 py-2 rounded mr-2 border border-[#848484]">수정</button>
					<button id="deleteBtn"
						class="bg-[#848484] text-white px-4 py-2 rounded">삭제</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>