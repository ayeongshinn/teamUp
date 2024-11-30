<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>

<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script
	src="https://cdn.jsdelivr.net/gh/alpinejs/alpine@2.x.x/dist/alpine.min.js"
	defer></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>


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
}
</style>

</head>
<body>

	<!-- 가로 배치 컨테이너 -->
	<div class="flex justify-center">
		<!-- 첫 번째 div, 서류 양식 제목 -->
		<div class="w-4/6 bg-white p-16">
			<%@ include file="text.jsp"%>
		</div>

		<!-- 두 번째 div, 폼 입력 영역 -->
		<div class="w-4/6 bg-white p-16">
			<h2
				class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">계약서
				작성</h2>
			<form name="registForm" id="registForm"
				action="/dealingsDoc/dealRegistPost" method="post"
				enctype="multipart/form-data">

				<div class="grid gap-3 mb-2">
					<div>
						<label for="docTtl"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							서류 제목 <code> *</code>
						</label> <input type="text" id="docTtl" name="docTtl"
							class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							placeholder="서류 제목을 입력해주세요." required>
					</div>
				</div>

				<div class="grid gap-3 mb-2 lg:grid-cols-2">

					<div style="display: none;">
						<label for="docNo"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">서류
							번호 </label> <input type="text" id="docNo" name="docNo"
							class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
					</div>

					<div>
						<label for="wrtYmd"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							작성 일자 <code> *</code>
						</label> <input type="date" id="wrtYmd" name="wrtYmd"
							class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							placeholder="작성 일자를 입력해주세요." required
							oninput="updateDateDisplay(this.value)">
					</div>

					<div>
						<label for="rbprsnEmpNo"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							담당 사원 <code> *</code>
						</label>
							<input type="text" id="rbprsnEmpNo" name="rbprsnEmpNo"
							class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							placeholder="담당 사원 번호를 입력해주세요.">
					</div>
					<div>
						<label for="ctrtAmt"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							계약 금액 <code> *</code>
						</label> <input type="text" id="ctrtAmt" name="ctrtAmt"
							class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							placeholder="담당 사원 번호를 입력해주세요.">
					</div>
					<div>
						<label for="ctrtAmt"
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							첨부 파일 <code> *</code>
						</label>
						<div class="icons flex text-gray-500 m-2">
							<label id="select-image"> <svg
									class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7"
									xmlns="http://www.w3.org/2000/svg" fill="none"
									viewBox="0 0 24 24" stroke="currentColor">
		                        <path stroke-linecap="round"
										stroke-linejoin="round" stroke-width="2"
										d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
		                    </svg> <input type="file" id="uploadFile"
								name="uploadFile" multiple hidden />
							</label>
							<!-- 파일 이름 출력 영역 -->
							<div id="fileList" class="text-sm text-gray-500 mt-2"></div>
						</div>
					</div>
				</div>

				<div class="mb-2">
					<label for="ctrtCn"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
						서류 내용 </label>
					<textarea id="ctrtCn" name="ctrtCn" rows="3"
						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="서류 내용을 입력해주세요."></textarea>
				</div>

				<div>
					<label for="rbprsnEmpNo"
						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
						계약서 구분<code> *</code>
					</label>
					<div class="btn-group btn-group-toggle" data-toggle="buttons"
						style="width: 220px;">
						<label class="btn btn-primary">
						<input type="radio" name="radioBtn" id="counterRadioBtn"
							value="counterRadioBtn" autocomplete="off" /> 거래처
						</label> 
						<label class="btn btn-primary">
						<input type="radio" name="radioBtn" id="custRadioBtn"
							value="custRadioBtn" autocomplete="off" /> 고객
						</label>
					</div>
				</div>

				<div id="dynamicForm" class="mt-3">
					<!-- Radio 버튼 클릭시 Form 들어올 자리 -->
				</div>

				<div
					style="display: flex; justify-content: flex-end; margin-top: 5px;">
					<button id="saveBtn"
						class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded hover: outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
						type="button">등록</button>
					<button id="cancelBtn"
						class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded  hover: outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
						type="button">돌아가기</button>
				</div>
				<sec:csrfInput />
			</form>
		</div>
	</div>

	<script type="text/javascript">

    const dynamicForm = document.getElementById('dynamicForm');
	
    // 라디오 버튼 변경 감지 후 폼 업데이트
    document.addEventListener('change', function(event) {
        if (event.target && event.target.matches('input[name="radioBtn"]')) {
            updateForm(event.target.id);  // 라디오 버튼 변경 시 폼 업데이트
        }
    });
    
    function updateForm(selectedId) {
    	
    	console.log("폼 업데이트 호출됨:", selectedId);
        
    	dynamicForm.innerHTML = ''; // 기존 내용 초기화

                // 선택된 라디오 버튼에 따라 다르게 입력 폼 추가
                if (selectedId === 'counterRadioBtn') {
                    dynamicForm.innerHTML = `
                    	<form name="counterRegistForm" id="counterpartyForm" action="/dealingsDoc/insertCounterParty" method="post">
	                    <div class="grid gap-3 mb-2 lg:grid-cols-2">
	                    	<div style="position: absolute; width: 0; height: 0; overflow: hidden;">
	                            <label for="cnptNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">거래처 번호 <code> *</code></label>
	                            <input type="text" id="cnptNo" name="cnptNo" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="거래처 번호를 입력해주세요.">
	                        </div>
	                        <div>
	                            <label for="cmrcNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">거래처명 <code> *</code></label>
	                            <input type="text" id="cmrcNm" name="cmrcNm" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="업체명을 입력해주세요." required>
	                        </div>
	                        <div>
	                            <label for="rprsvNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">대표자명 <code> *</code></label>
	                            <input type="text" id="rprsvNm" name="rprsvNm" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="대표자명을 입력해주세요." required oninput="nameDisplay(this.value)">
	                        </div>
	                        <div>
	                            <label for="cnptBrno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">사업자 번호 <code> *</code></label>
	                            <input type="tel" id="cnptBrno" name="cnptBrno" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="사업자 번호를 입력해주세요.">
	                        </div>
	                        <div>
	                            <label for="fndnYmd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">설립 일자</label>
	                            <input type="text" id="fndnYmd" name="fndnYmd" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="설립 일자를 입력해주세요.">
	                        </div>
	                        <div>
	                            <label for="rprsTelno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">대표 전화번호 <code> *</code></label>
	                            <input type="text" id="rprsTelno" name="rprsTelno" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="대표 전화번호를 입력해주세요." required oninput="telnoDisplay(this.value)">
	                        </div>
	                        <div>
	                            <label for="cnptFxno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">FAX 번호</label>
	                            <input type="text" id="cnptFxno" name="cnptFxno" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="FAX 번호를 입력해주세요.">
	                        </div>
	                        <div>
	                            <label for="counterCtrtCnclsYmd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">계약 체결일</label>
	                            <input type="date" id="counterCtrtCnclsYmd" name="counterCtrtCnclsYmd" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="계약 체결일을 입력해주세요." oninput="ctrtCnclsYmdDisplay(this.value)">
	                        </div>
	                        <div>
	                            <label for="indutyCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">업종 코드 <code> *</code></label>
	                            <select id="indutyCd" name="indutyCd" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" required>
	                                <option value="" disabled selected>업종코드를 선택해주세요.</option>
	                                <c:forEach var="indutyNm" items="${indutynmList}">
	                                    <option value="${indutyNm.indutyCd}">${indutyNm.indutynm}</option>
	                                </c:forEach>
	                            </select>
	                        </div>
	                    </div>
	                    <div class="grid gap-3 mb-2 lg:grid-cols-2">
		                    <div class="relative ">
			                    <label for="coRoadNmZip" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">우편 번호 <code> *</code></label>
				                    <div class="flex items-center"> <!-- flexbox 사용 -->
				                        <input type="text" id="coRoadNmZip" name="coRoadNmZip"
				                               class="bg-white border border-gray-300 text-gray-900 text-sm rounded-l-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				                               placeholder="우편 번호" required style="height: 44px;">
				                        <button id="addr"
				                                class="bg-indigo-500 text-white active:bg-indigo-600 font-bold text-sm px-4 rounded-r-lg outline-none focus:outline-none transition-all duration-150"
				                                type="button" style="height: 44px; margin-left: -1px; min-width: 100px;"> <!-- 버튼 높이와 너비 조정 -->
				                            	주소 검색
				                        </button>
				                    </div>
			                </div>

	                        <div>
	                            <label for="coRoadNmAddr" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">도로명 주소 <code> *</code></label>
	                            <input type="text" id="coRoadNmAddr" name="coRoadNmAddr" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500 mb-3" placeholder="도로명 주소" required>
	                        </div>
	        				<div>
	        					<label for="coDaddr"
	        						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">상세 주소 <code> *</code></label>
	        						<input type="text" id="coDaddr" name="coDaddr"
	        						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500 mb-3"
	        						placeholder="상세 주소를 입력해주세요.">
	        				</div>
	        			</div>
	        			
	        			<div class="mb-6">
	        				<label for="rmrkCn"
	        					class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">비고 내용</label>
	        					<textarea id="rmrkCn" name="rmrkCn" row="2"
	        					class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	        					placeholder="비고 내용을 입력해주세요."></textarea>
	        			</div>
	        		</form>
                    `;
                    
                   	console.log("counterpartyForm이 추가되었습니다.");
                    
               } else if (selectedId === 'custRadioBtn') {
                   dynamicForm.innerHTML = `
                   	<form name="customerRegistForm" id="customerForm" action="/dealingsDoc/insertCustomer" method="post">
	        			<div class="grid gap-3 mb-2 lg:grid-cols-2">
	        			<div style="position: absolute; width: 0; height: 0; overflow: hidden;">
	    					<label for="custNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 번호 <code> *</code></label>
	    					<input type="text" id="custNo" name="custNo"
	    						   class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	    						   placeholder="고객 번호를 입력해주세요.">
	    				</div>
	    				<div>
	    					<label for="custNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객명 <code> *</code></label>
	    						<input type="text" id="custNm" name="custNm"
	    						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	    						placeholder="고객명을 입력해주세요." required oninput="nameDisplay(this.value)">
	    				</div>
	    				<div>
	    					<label for="custCrNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 직업</label>
	    					<input type="text" id="custCrNm" name="custCrNm"
	    						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	    						placeholder="직업명을 입력해주세요." required>
	    				</div>
	    				<div>
	    					<label for="custRrno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 주민등록번호</label>
	    					<input type="tel" id="custRrno" name="custRrno"
	    						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	    						placeholder="주민등록번호를 입력해주세요.">
	    				</div>
	    				<div>
	    					<label for="custTelno"
	    						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 전화번호</label>
	    						<input type="text" id="custTelno" name="custTelno"
	    						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	    						placeholder="전화번호를 입력해주세요." oninput="telnoDisplay(this.value)">
	    				</div>
	    				<div>
	    					<label for="custEmlAddr"
	    						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">고객 이메일</label>
	    						<input type="text" id="custEmlAddr" name="custEmlAddr"
	    						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	    						placeholder="이메일 주소를 입력해주세요." required>
	    				</div>
	    				<div>
	    					<label for="custCtrtCnclsYmd"
	    						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">계약 체결일</label>
	    						<input type="date" id="custCtrtCnclsYmd" name="custCtrtCnclsYmd"
	    						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	    						placeholder="계약 체결일을 입력해주세요." oninput="ctrtCnclsYmdDisplay(this.value)">
	    				</div>
	    			</div>
	    			<div class="grid gap-3 mb-2 lg:grid-cols-2">	
	    			<div class="relative">
	                    <label for="custRoadNmZip" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">우편 번호 <code> *</code></label>
		                    <div class="flex items-center"> <!-- flexbox 사용 -->
		                        <input type="text" id="custRoadNmZip" name="custRoadNmZip"
		                               class="bg-white border border-gray-300 text-gray-900 text-sm rounded-l-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
		                               placeholder="우편 번호" required style="height: 44px;">
		                        <button id="addr"
		                                class="bg-indigo-500 text-white active:bg-indigo-600 font-bold text-sm px-4 rounded-r-lg outline-none focus:outline-none transition-all duration-150"
		                                type="button" style="height: 44px; margin-left: -1px; min-width: 100px;"> <!-- 버튼 높이와 너비 조정 -->
			                            	주소 검색
			                        </button>
		                    </div>
                	</div>
    					<div>
	    					<label for="custRoadNmAddr"
	    						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">도로명 주소 <code> *</code></label>
	    						<input type="text" id="custRoadNmAddr" name="custRoadNmAddr"
	    						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500 mb-3"
	    						placeholder="도로명 주소" required>
    					</div>
	    				<div>
	    					<label for="custDaddr"
	    						class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">상세 주소 <code> *</code></label>
	    						<input type="text" id="custDaddr" name="custDaddr"
	    						class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500 mb-3"
	    						placeholder="상세 주소를 입력해주세요.">
	    				</div>
	    			</div>
	    			
	    			<div class="mb-6">
	    				<label for="rmrkCn"
	    					class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">비고 내용</label>
	    					<textarea id="rmrkCn" name="rmrkCn" rows="3"
	    					class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
	    					placeholder="비고 내용을 입력해주세요."></textarea>
	    			</div>
    			</form>
                   `;
                   
                   console.log("customerForm이 추가되었습니다.");
                   
               }
                console.log("폼이 동적으로 추가되었습니다.", dynamicForm.innerHTML);
           };
           
           // 페이지 로드 시 초기 상태 설정
           const initialSelectedRadio = document.querySelector('input[name="radioBtn"]:checked');
           if (initialSelectedRadio) {
               updateForm(initialSelectedRadio.id);  // 초기 로드 시 폼 추가
           } else {
               document.querySelector('input[name="radioBtn"]').checked = true;
               updateForm(document.querySelector('input[name="radioBtn"]').id);  // 기본 선택된 버튼으로 폼 추가
           }
    
$(function() {
    console.log("주소록 API");
    
    $(document).on('click', '#addr', function() {
        var form = $(this).closest('form');
        var formType = form.attr('id'); // 폼의 ID로 타입 구분
        
        // 라디오 버튼의 값 체크
        var selectedRadio = form.find('input[name="radioBtn"]:checked').attr('id');
        console.log("폼 타입:", formType);
        console.log("선택된 라디오:", selectedRadio); // 선택된 라디오 버튼 확인

        new daum.Postcode({
            oncomplete: function(data) {
                console.log("주소 데이터:", data);

                // ID를 직접 비교
                if (selectedRadio === 'counterRadioBtn') {
                    // 거래처 주소 처리
                    form.find('[name="coRoadNmZip"]').val(data.zonecode);
                    form.find('[name="coRoadNmAddr"]').val(data.address);
                    form.find('[name="coDaddr"]').val(data.buildingName).focus();
                
                } else if (selectedRadio === 'custRadioBtn') {
                    // 고객 주소 처리
                    form.find('[name="custRoadNmZip"]').val(data.zonecode);
                    form.find('[name="custRoadNmAddr"]').val(data.address);
                    form.find('[name="custDaddr"]').val(data.buildingName).focus();
                }
            }
        }).open();
    });
});

$(document).ready(function () {
	
	//파일 선택 시 이름 출력, 선택 삭제
	$("#uploadFile").on("change", function() {
		
        const files = $(this)[0].files;
        let fileList = "";
        for(let i = 0; i < files.length; i++) {
            fileList += '<div class="file-item" id="file-' + i + '">' +
                        files[i].name +
                        ' <button type="button" class="remove-file" data-file-id="' + i + '">×</button>' +
                        '</div>';
        }
        $("#fileList").html(fileList);
        
        //삭제 버튼 클릭 이벤트
        $(".remove-file").on("click", function() {
            const fileId = $(this).data("file-id");
            removeFile(fileId);
        });
    });
	
	//취소 버튼 클릭 시 확인 후 이전 페이지로
	$("#cancelBtn").on("click", function() {
		cancelBtn();
	})
	
});

//파일 삭제 함수
function removeFile(fileId) {
 const input = $("#uploadFile")[0];
    const dt = new DataTransfer();
    
    //기존 파일 중 삭제한 파일 제외
    for(let i = 0; i < input.files.length; i++) {
        if(i != fileId) {
            dt.items.add(input.files[i]);
        }
    }
    
    //삭제 후의 파일 목록으로 input 값 설정
    input.files = dt.files;
    
    //화면에서 해당 파일 아이템 삭제
    $("#file-" + fileId).remove();
}

// 등록 버튼 처리 함수
$(document).ready(function () {
	
	// 등록 버튼 클릭 시
    $("#saveBtn").on("click", function() {
	    console.log("saveBtn 함수 호출됨");
	
	    // radio 버튼 선택
	    const selectedRadio = document.querySelector('input[name="radioBtn"]:checked');
	
	    if (!selectedRadio) {
	        Swal.fire({
	            title: '거래처 또는 고객을 선택해주세요!',
	            icon: 'warning',
	            confirmButtonColor: '#4E7DF4',
	            confirmButtonText: '확인',
	        });
	        return;
	    }
	
	    let selectedFormId = '';
	    if (selectedRadio.id === 'counterRadioBtn') {
	        selectedFormId = 'counterpartyForm'; // 거래처 폼
	    } else if (selectedRadio.id === 'custRadioBtn') {
	        selectedFormId = 'customerForm'; // 고객 폼
	    }
	
	    console.log("선택된 Radio Form", selectedFormId);
	
	    const additionalFormData = new FormData();
	    
	    additionalFormData.append("selectedFormId",selectedFormId);
	    console.log("selectedFormId 확인 : ", selectedFormId);
	    
	    // 고객/거래처 먼저 insert
	    $.ajax({
	        url: selectedForm.action,  // /insertCounterParty or /insertCustomer
	        type: 'POST',
	        data: additionalFormData,
	        processData: false,
	        contentType: false,
	        success: function(response) {
	            
	        	console.log('고객/거래처 등록 완료:', response);
	            const insertedId = response.id; // 고객 또는 거래처 insert 후 반환된 ID
	
	            // 계약서 폼 데이터 처리
	            const dealingsDocData = new FormData(document.getElementById('registForm'));
	            dealingsDocData.append('insertedId', insertedId); // 거래처/고객 ID를 계약서 데이터에 추가
	
	            // 계약서 insert
	            $.ajax({
	                url: '/dealingsDoc/dealRegistPost',
	                type: 'POST',
	                data: dealingsDocData,
	                processData: false,
	                contentType: false,
	                success: function(response) {
	                    console.log('계약서 등록 완료:', response);
	                    Swal.fire({
	                        title: '등록이 완료되었습니다!',
	                        icon: 'success',
	                        confirmButtonColor: '#4E7DF4',
	                        confirmButtonText: '확인',
	                    }).then(() => {
	                        window.location.href = '/dealingsDoc/list';
	                    });
	                },
	                error: function(error) {
	                    console.error('계약서 등록 오류:', error);
	                }
	            });
	        },
	        error: function(error) {
	            console.error('고객/거래처 등록 오류:', error);
	        }
	    });
	});
});

//선택된 폼을 찾는 함수
function selectedForm(radioId) {
    console.log("selectedForm 호출됨:", radioId);

    if (radioId === 'counterRadioBtn') {
        return document.querySelector('#counterpartyForm');
    } else if (radioId === 'custRadioBtn') {
        return document.querySelector('#customerForm');
    }
    return null;
}

</script>

</body>
</html>