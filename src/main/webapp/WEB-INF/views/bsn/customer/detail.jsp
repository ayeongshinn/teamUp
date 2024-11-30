<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<style>
   @font-face {
       font-family: 'Pretendard-Regular';
       src: url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
       font-weight: 100;
       font-style: normal;
   }
   
   body {
       font-family: 'Pretendard-Regular', sans-serif;
   }
   
   .bg-indigo-500 {
		background-color: #4E7DF4;
	}
	
	#deleteBtn, #cancelBtn {
		background-color: #FF4647;
	}
   
</style>

<script type="text/javascript">

let custNo;
let custNm;
let custRrno;
let custCrNm;
let custTelno;
let custEmlAddr;
let ctrtCnclsYmd;
let custRoadNmZip;
let rmrkCn;
let custRoadNmAddr;
let custDaddr;

	$(function() {
		
		// 수정 버튼 클릭하여 수정 모드로 전환
		$("#updateBtn").on("click", function() {
			
			console.log("수정 모드 실행 확인");
			
			// 비고 내용 input을 textarea로 변환
	        const rmrkCnValue = $("input[name='rmrkCn']").val();
	        originalRemarkHtml = $("#remarkField").html(); // 원본 HTML 저장
			
	        // textarea로 변환
	        $("#remarkField").html(`
	            <label for="rmrkCn" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">비고 내용</label>
	            <textarea id="rmrkCn" name="rmrkCn" rows="4"
	                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	            >${rmrkCnValue}</textarea>
	        `);
			
			// spn1 : 일반 영역, spn2 : 수정 영역
			$("#spn1").css("display", "none");
			$("#spn2").css("display", "block");
			$("#addr").css("display", "block");
			
			// 원본 input 요소에 readonly 속성을 제거
    		$("[name='custCrNm'], [name='custTelno'], [name='custEmlAddr'], [name='custRoadNmZip'], [name='rmrkCn'], [name='custRoadNmAddr'], [name='custDaddr']").attr("readonly", false).css("background-color", "#FFFFFF");
			
			// 데이터 백업
			custNo = $("input[name='custNo']").val();
			custNm = $("input[name='custNm']").val();
			custRrno = $("input[name='custRrno']").val();
			custCrNm = $("input[name='custCrNm']").val();
			custTelno = $("input[name='custTelno']").val();
			custEmlAddr = $("input[name='custEmlAddr']").val();
			ctrtCnclsYmd = $("input[name='ctrtCnclsYmd']").val();
			custRoadNmZip = $("input[name='custRoadNmZip']").val();
			rmrkCn = $("input[name='rmrkCn']").val();
			custRoadNmAddr = $("input[name='custRoadNmAddr']").val();
			coRoadNmAddr = $("input[name='coRoadNmAddr']").val();
			custDaddr = $("input[name='custDaddr']").val();
		});
		
		// 취소 버튼 클릭하여 일반 모드로 전환
		$("#cancelBtn").on("click", function() {
			
			// spn1 : 일반 영역, spn2 : 수정 영역
			$("#spn1").css("display", "block");
			$("#spn2").css("display", "none");
			$("#addr").css("display", "none");
			
			// 원본 input 요소에 readonly 속성을 제거
    		$("[name='custCrNm'], [name='custTelno'], [name='custEmlAddr'], [name='custRoadNmZip'], [name='rmrkCn'], [name='custRoadNmAddr'], [name='custDaddr']").attr("readonly", true).css("background-color", "#f9fafb");
			
			// 백업된 데이터 가져오기
			custNo = $("input[name='custNo']").val(custNo);
			custNm = $("input[name='custNm']").val(custNm);
			custRrno = $("input[name='custRrno']").val(custRrno);
			custCrNm = $("input[name='custCrNm']").val(custCrNm);
			custTelno = $("input[name='custTelno']").val(custTelno);
			custEmlAddr = $("input[name='custEmlAddr']").val(custEmlAddr);
			ctrtCnclsYmd = $("input[name='ctrtCnclsYmd']").val(ctrtCnclsYmd);
			custRoadNmZip = $("input[name='custRoadNmZip']").val(custRoadNmZip);
			rmrkCn = $("input[name='rmrkCn']").val(rmrkCn);
			custRoadNmAddr = $("input[name='custRoadNmAddr']").val(custRoadNmAddr);
			coRoadNmAddr = $("input[name='coRoadNmAddr']").val(coRoadNmAddr);
			custDaddr = $("input[name='custDaddr']").val(custDaddr);
			
			// 비고 내용 textarea를 다시 input으로 변환
	        $("#remarkField").html(originalRemarkHtml);	
			
			console.log("일반 모드 실행 확인");
			
		});
		
		// 삭제 버튼 클릭하여 실행하기
		$("#deleteBtn").on("click", function() {
		    if (confirm("정말로 삭제하시겠습니까?")) {
		        // 확인 버튼을 누른 경우 삭제 요청 보내기
		        $("#updatePost").attr("action", "/customer/deletePost");
		        $("#updatePost").submit();
		    } else {
		        // 취소 버튼을 누른 경우 아무 작업도 수행하지 않음
		        return;
		    }
		});
		
	});
	
	$(function() {
		
		console.log("주소 검색 확인");
	
		$("#addr").on("click", function() {
		    new daum.Postcode({
		    	// 다음 창에서 검색이 완료되어 클릭하면 콜백함수에의해
		    	// 결과 데이터(JSON String)가 data객체로 들어온다.
		        oncomplete: function(data) {
		        	// data{"zonecode" : "12345", "address" : "대전 중구", "buildingName" : "123-67"}
		        	$("#custRoadNmZip").val(data.zonecode);
		        	$("#custRoadNmAddr").val(data.address);
		        	$("#custDaddr").val(data.buildingName);
		        	$("#custDaddr").focus();
		        }
		    }).open();
		});
	});
	
	
</script>

</head>
<body>
	
	<div class="max-w-6xl mx-auto bg-white p-16">
	<h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">고객 상세조회</h2>
	<br>
	
		<form name="updatePost" id="updatePost" action="/customer/updatePost" method="post">
			<div class="grid gap-6 mb-6 lg:grid-cols-2">
				<div>
					<label for="custNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 번호</label>
					<input type="text" id="custNo" name="custNo"
						   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						   value="${customerVO.custNo}" readonly>
				</div>
				<div>
					<label for="custCrNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 직업</label>
					<input type="text" id="custCrNm" name="custCrNm"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${customerVO.custCrNm}" readonly>
				</div>
				<div>
					<label for="custNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객명</label>
						<input type="text" id="custNm" name="custNm"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${customerVO.custNm}" readonly>
				</div>
				<div>
					<label for="custTelno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 전화번호</label>
					<input type="tel" id="custTelno" name="custTelno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${customerVO.custTelno}" readonly>
				</div>
				<div>
					<label for="custRrno"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 주민등록번호</label>
						<input type="text" id="custRrno" name="custRrno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${customerVO.custRrno}" readonly>
				</div>
				<div>
					<label for="custEmlAddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 이메일</label>
						<input type="text" id="custEmlAddr" name="custEmlAddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${customerVO.custEmlAddr}" readonly>
				</div>
				<div>
					<label for="ctrtCnclsYmd"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">계약 성사일</label>
						<input type="text" id="ctrtCnclsYmd" name="ctrtCnclsYmd"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${customerVO.ctrtCnclsYmd}" readonly>
				</div>
			</div>
			<div class="grid gap-6 mb-6 lg:grid-cols-2">	
				<div class="flex items-center">
					<div>
						<label for="custRoadNmZip"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">우편 번호</label>
							<input type="text" id="custRoadNmZip" name="custRoadNmZip"
							class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							value="${customerVO.custRoadNmZip}" readonly>
					</div>
					<button id="addr" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							type="button" style="margin-top: 30px; display: none;">
						주소 검색
					</button>
				</div>
				<div>
					<label for="custRoadNmAddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">도로명 주소</label>
						<input type="text" id="custRoadNmAddr" name="custRoadNmAddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${customerVO.custRoadNmAddr}" readonly>
				</div>
				<div>
					<label for="custDaddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">상세 주소</label>
						<input type="text" id="custDaddr" name="custDaddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${customerVO.custDaddr}" readonly>
				</div>
			</div>
			
			<div class="mb-6" id="remarkField">
				<label for="rmrkCn"
					class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">비고 내용</label>
					<input type="text" id="rmrkCn" name="rmrkCn"
					class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					value="${customerVO.rmrkCn}" readonly>
			</div>
			
			<!-- 일반 모드 시작 -->
			<span id="spn1">
				<div style="display: flex; margin-top: 5px;">
					<a href="/customer/list">
						<button id="backBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								type="button">
						돌아가기
						</button>
					</a>
					<div style="margin-left: 74%;">
							<button id="updateBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									type="button">
							수정
							</button>
							<button id="deleteBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									type="button">
							삭제
							</button>
					</div>
				</div>
			</span>
			<!-- 일반 모드 끝 -->
			
			<!-- 수정 모드 시작 -->
			<span id="spn2" style="display: none;">
				<div style="margin-left: 84%;">
						<button id="submitBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								type="submit">
						저장
						</button>
						<button id="cancelBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								type="button">
						취소
						</button>
				</div>
			</span>
			<!-- 수정 모드 끝 -->
			<sec:csrfInput />	
		</form>

	</div>

</body>
</html>