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
   
</style>

<script type="text/javascript">

let cnptNo;
let cmrcNm;
let rprsvNm;
let cnptBrno;
let rprsTelno;
let cnptFxno;
let coRoadNmZip;
let fndnYmd;
let rmrkCn;
let ctrtCnclsYmd;
let coRoadNmAddr;
let coDaddr;
let indutyCd;

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
    		$("[name='cmrcNm'], [name='rprsvNm'], [name='rprsTelno'], [name='cnptFxno'], [name='coRoadNmZip'], [name='rmrkCn'], [name='coRoadNmAddr'], [name='coDaddr']").attr("readonly", false).css("background-color", "#FFFFFF");
			
			// 데이터 백업
			cnptNo = $("input[name='cnptNo']").val();
			cmrcNm = $("input[name='cmrcNm']").val();
			rprsvNm = $("input[name='rprsvNm']").val();
			cnptBrno = $("input[name='cnptBrno']").val();
			rprsTelno = $("input[name='rprsTelno']").val();
			cnptFxno = $("input[name='cnptFxno']").val();
			coRoadNmZip = $("input[name='coRoadNmZip']").val();
			fndnYmd = $("input[name='fndnYmd']").val();
			rmrkCn = $("input[name='rmrkCn']").val();
			ctrtCnclsYmd = $("input[name='ctrtCnclsYmd']").val();
			coRoadNmAddr = $("input[name='coRoadNmAddr']").val();
			coDaddr = $("input[name='coDaddr']").val();
			indutyCd = $("input[name='indutyCd']").val();			
		});
		
		// 취소 버튼 클릭하여 일반 모드로 전환
		$("#cancelBtn").on("click", function() {
			
			// spn1 : 일반 영역, spn2 : 수정 영역
			$("#spn1").css("display", "block");
			$("#spn2").css("display", "none");
			$("#addr").css("display", "none");
			
			// 원본 input 요소에 readonly 속성을 제거
    		$("[name='cmrcNm'], [name='rprsvNm'], [name='rprsTelno'], [name='cnptFxno'], [name='coRoadNmZip'], [name='rmrkCn'], [name='coRoadNmAddr'], [name='coDaddr']").attr("readonly", true).css("background-color", "#f9fafb");
			
			// 백업된 데이터 가져오기
			cnptNo = $("input[name='cnptNo']").val(cnptNo);
			cmrcNm = $("input[name='cmrcNm']").val(cmrcNm);
			rprsvNm = $("input[name='rprsvNm']").val(rprsvNm);
			cnptBrno = $("input[name='cnptBrno']").val(cnptBrno);
			rprsTelno = $("input[name='rprsTelno']").val(rprsTelno);
			cnptFxno = $("input[name='cnptFxno']").val(cnptFxno);
			coRoadNmZip = $("input[name='coRoadNmZip']").val(coRoadNmZip);
			fndnYmd = $("input[name='fndnYmd']").val(fndnYmd);
			rmrkCn = $("input[name='rmrkCn']").val(rmrkCn);
			ctrtCnclsYmd = $("input[name='ctrtCnclsYmd']").val(ctrtCnclsYmd);
			coRoadNmAddr = $("input[name='coRoadNmAddr']").val(coRoadNmAddr);
			coDaddr = $("input[name='coDaddr']").val(coDaddr);
			indutyCd = $("input[name='indutyCd']").val(indutyCd);
			
			// 비고 내용 textarea를 다시 input으로 변환
	        $("#remarkField").html(originalRemarkHtml);			
			
			console.log("일반 모드 실행 확인");
			
		});
		
		// 삭제 버튼 클릭하여 실행하기
		$("#deleteBtn").on("click", function() {
		    if (confirm("정말로 삭제하시겠습니까?")) {
		        // 확인 버튼을 누른 경우 삭제 요청 보내기
		        $("#updatePost").attr("action", "/counterparty/deletePost");
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
		        	$("#coRoadNmZip").val(data.zonecode);
		        	$("#coRoadNmAddr").val(data.address);
		        	$("#coDaddr").val(data.buildingName);
		        	$("#coDaddr").focus();
		        }
		    }).open();
		});
	});
	
	
</script>

</head>
<body>
	
	<div class="max-w-6xl mx-auto bg-white p-16">
	<h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">거래처 상세조회</h2>
	<br>
	
		<form name="updatePost" id="updatePost" action="/counterparty/updatePost" method="post">
		<!-- Modal용 div -->
		<div id="detailContent">	
			<div class="grid gap-6 mb-6 lg:grid-cols-2">
				<div>
					<label for="cnptNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">거래처 번호</label>
					<input type="text" id="cnptNo" name="cnptNo"
						   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						   value="${counterPartyVO.cnptNo}" readonly>
				</div>
				<div>
					<label for="cmrcNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">업체명</label>
						<input type="text" id="cmrcNm" name="cmrcNm"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.cmrcNm}" readonly>
				</div>
				<div>
					<label for="rprsvNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">대표자명</label>
					<input type="text" id="rprsvNm" name="rprsvNm"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.rprsvNm}" readonly>
				</div>
				<div>
					<label for="cnptBrno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">사업자 번호</label>
					<input type="tel" id="cnptBrno" name="cnptBrno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.cnptBrno}" readonly>
				</div>
				<div>
					<label for="rprsTelno"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">대표 전화번호</label>
						<input type="text" id="rprsTelno" name="rprsTelno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.rprsTelno}" readonly>
				</div>
				<div>
					<label for="cnptFxno"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">FAX 번호</label>
						<input type="text" id="cnptFxno" name="cnptFxno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.cnptFxno}" readonly>
				</div>
				<div>
					<label for="fndnYmd"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">설립 일자</label>
						<input type="text" id="fndnYmd" name="fndnYmd"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.fndnYmd}" readonly>
				</div>
				<div>
					<label for="ctrtCnclsYmd"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">계약 체결일</label>
						<input type="text" id="ctrtCnclsYmd" name="ctrtCnclsYmd"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.ctrtCnclsYmd}" readonly>
				</div>
				<div>
					<label for="indutyCd"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">업종 코드</label>
						<input type="text" id="indutyCd" name="indutyCd"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.indutynm}" readonly>
				</div>
			</div>
			<div class="grid gap-6 mb-6 lg:grid-cols-2">	
				<div class="flex items-center">
					<div>
						<label for="coRoadNmZip"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">우편 번호</label>
							<input type="text" id="coRoadNmZip" name="coRoadNmZip"
							class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							value="${counterPartyVO.coRoadNmZip}" readonly>
					</div>
					<button id="addr" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded hover: outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							type="button" style="margin-top: 30px; display: none;">
						주소 검색
					</button>
				</div>
				<div>
					<label for="coRoadNmAddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">도로명 주소</label>
						<input type="text" id="coRoadNmAddr" name="coRoadNmAddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.coRoadNmAddr}" readonly>
				</div>
				<div>
					<label for="coDaddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">상세 주소</label>
						<input type="text" id="coDaddr" name="coDaddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						value="${counterPartyVO.coDaddr}" readonly>
				</div>
			</div>
			
			<div class="mb-6" id="remarkField">
				<label for="rmrkCn"
					class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">비고 내용</label>
					<input type="text" id="rmrkCn" name="rmrkCn"
					class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					value="${counterPartyVO.rmrkCn}" readonly>
			</div>
			
			</div>
			
			<!-- 일반 모드 시작 -->
			<span id="spn1">
				<div style="display: flex; margin-top: 5px;">
					<a href="/counterparty/list">
						<button id="backBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded hover: outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								type="button">
						돌아가기
						</button>
					</a>
					<div style="margin-left: 74%;">
							<button id="updateBtn" class="bg-white text-[#848484] active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded hover: outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									type="button">
							수정
							</button>
							<button id="deleteBtn" class="bg-[#848484] text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded hover: outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
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
						<button id="submitBtn" class="bg-white text-[#848484] active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded hover: outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								type="submit">
						저장
						</button>
						<button id="cancelBtn" class="bg-[#848484] text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded hover: outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
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