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
	console.log("주소 등록 확인");
	
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
	<h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">고객 등록</h2>
	<br>
		<form name="registForm" id="registForm" action="/customer/registPost" method="post">
			<div class="grid gap-6 mb-6 lg:grid-cols-2">
				<div style="display: none;">
					<label for="custNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 번호 <code> *</code></label>
					<input type="text" id="custNo" name="custNo"
						   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						   placeholder="고객 번호를 입력해주세요.">
				</div>
				<div>
					<label for="custNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객명 <code> *</code></label>
						<input type="text" id="custNm" name="custNm"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="고객명을 입력해주세요." required>
				</div>
				<div>
					<label for="custCrNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 직업</label>
					<input type="text" id="custCrNm" name="custCrNm"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="직업명을 입력해주세요." required>
				</div>
				<div>
					<label for="custRrno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 주민등록번호</label>
					<input type="tel" id="custRrno" name="custRrno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="주민등록번호를 입력해주세요.">
				</div>
				<div>
					<label for="custTelno"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 전화번호</label>
						<input type="text" id="custTelno" name="custTelno"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="전화번호를 입력해주세요.">
				</div>
				<div>
					<label for="custEmlAddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 이메일</label>
						<input type="text" id="custEmlAddr" name="custEmlAddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="이메일 주소를 입력해주세요." required>
				</div>
				<div>
					<label for="ctrtCnclsYmd"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">계약 체결일</label>
						<input type="text" id="ctrtCnclsYmd" name="ctrtCnclsYmd"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="계약 체결일을 입력해주세요.">
				</div>
			</div>
			<div class="grid gap-6 mb-6 lg:grid-cols-2">	
				<div class="flex items-center">
					<div>
						<label for="custRoadNmZip"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">우편 번호<code> *</code></label>
							<input type="text" id="custRoadNmZip" name="custRoadNmZip"
							class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							placeholder="우편 번호" required>
					</div>
					<button id="addr" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							type="button" style="margin-top: 30px;">
						주소 검색
					</button>
				</div>
				<div>
					<label for="custRoadNmAddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">도로명 주소 <code> *</code></label>
						<input type="text" id="custRoadNmAddr" name="custRoadNmAddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="도로명 주소" required>
				</div>
				<div>
					<label for="custDaddr"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">상세 주소 <code> *</code></label>
						<input type="text" id="custDaddr" name="custDaddr"
						class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="상세 주소를 입력해주세요.">
				</div>
			</div>
			
			<div class="mb-6">
				<label for="rmrkCn"
					class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">비고 내용</label>
					<textarea id="rmrkCn" name="rmrkCn" rows="4"
					class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="비고 내용을 입력해주세요."></textarea>
			</div>
			<div style="display: flex; justify-content: flex-end; margin-top: 5px;">
				<button id="saveBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
						type="submit">
				등록
				</button>
				<a href="/customer/list">
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