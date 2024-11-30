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

<script type="text/javascript">

$(function() {
	console.log("개똥이");
	
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

// date => varchar 변환
// document.getElementById('birth').addEventListener('change', function() {
//     const birthValue = this.value;
    
//     if (birthValue) {
//         formattedDate = birthValue.replace(/-/g, '');
//         document.getElementById('empBrdt').value = formattedDate;
//     }
// });

</script>

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
	
	#cancelBtn {
		background-color: #FF4647;
	}
	
	.bg-gray-50 {
		background-color: #FFFFFF;
	}
	
</style>

</head>
<body>

	<!-- component -->
	<!-- This is an example component -->
	<div class="max-w-6xl mx-auto bg-white p-16">
	<h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">거래처 등록</h2>
	<br>
		<form name="registForm" id="registForm" action="/counterparty/registPost" method="post">
			<div class="grid gap-6 mb-6 lg:grid-cols-2">
				<div style="display: none;">
					<label for="cnptNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">거래처 번호 <code> *</code></label>
					<input type="text" id="cnptNo" name="cnptNo"
						   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						   placeholder="거래처 번호를 입력해주세요.">
				</div>
				<div>
					<label for="cmrcNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">거래처명 <code> *</code></label>
						<input type="text" id="cmrcNm" name="cmrcNm"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="업체명을 입력해주세요." required>
				</div>
				<div>
					<label for="rprsvNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">대표자명 <code> *</code></label>
					<input type="text" id="rprsvNm" name="rprsvNm"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="대표자명을 입력해주세요." required>
				</div>
				<div>
					<label for="cnptBrno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">사업자 번호 <code> *</code></label>
					<input type="tel" id="cnptBrno" name="cnptBrno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="사업자 번호를 입력해주세요.">
				</div>
				<div>
					<label for="fndnYmd"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">설립 일자</label>
						<input type="text" id="fndnYmd" name="fndnYmd"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="설립 일자를 입력해주세요.">
				</div>
				<div>
					<label for="rprsTelno"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">대표 전화번호 <code> *</code></label>
						<input type="text" id="rprsTelno" name="rprsTelno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="대표 전화번호를 입력해주세요." required>
				</div>
				<div>
					<label for="cnptFxno"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">FAX 번호</label>
						<input type="text" id="cnptFxno" name="cnptFxno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="FAX 번호를 입력해주세요.">
				</div>
				<div>
					<label for="ctrtCnclsYmd"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">계약 체결일</label>
						<input type="text" id="ctrtCnclsYmd" name="ctrtCnclsYmd"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="계약 체결일을 입력해주세요.">
				</div>
				<div>
					<label for="indutyCd"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">업종 코드 <code> *</code></label>
					    <select id="indutyCd" name="indutyCd" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" required>
					        <option value="" disabled selected>업종코드를 선택해주세요.</option>
					        <c:forEach var="indutyNm" items="${indutynmList}">
					            <option value="${indutyNm.indutyCd}">${indutyNm.indutynm}</option>
					        </c:forEach>
					    </select>
				</div>
			</div>
			<div class="grid gap-6 mb-6 lg:grid-cols-2">	
				<div class="flex items-center">
					<div>
						<label for="coRoadNmZip"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">우편 번호 <code> *</code></label>
							<input type="text" id="coRoadNmZip" name="coRoadNmZip"
							class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							placeholder="우편 번호" required>
					</div>
					<button id="addr" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							type="button" style="margin-top: 30px;">
						주소 검색
					</button>
				</div>
				<div>
					<label for="coRoadNmAddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">도로명 주소 <code> *</code></label>
						<input type="text" id="coRoadNmAddr" name="coRoadNmAddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="도로명 주소" required>
				</div>
				<div>
					<label for="coDaddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">상세 주소 <code> *</code></label>
						<input type="text" id="coDaddr" name="coDaddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="상세 주소를 입력해주세요.">
				</div>
			</div>
			
			<div class="mb-6">
				<label for="rmrkCn"
					class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">비고 내용</label>
					<textarea id="rmrkCn" name="rmrkCn" row="4"
					class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="비고 내용을 입력해주세요."></textarea>
			</div>
			<div style="display: flex; justify-content: flex-end; margin-top: 5px;">
				<button id="saveBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
						type="submit">
				등록
				</button>
				<a href="/counterparty/list">
					<button id="cancelBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							type="button">
					돌아가기
					</button>
				</a>
			</div>
			<sec:csrfInput />	
		</form>

	</div>

</body>
</html>