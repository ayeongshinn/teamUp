<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<script type="text/javascript">
$(document).ready(function() {
	$('#docSave').on('click', function(event){
		event.preventDefault(); // 기본 동작 방지
		
		var combinedHtml = "";
		
		// .myClass를 가진 모든 요소를 순서대로 가져와 combinedHtml에 추가
		$('.vacationDoc').each(function() {
		    combinedHtml += $(this).prop('outerHTML');  // 요소의 전체 HTML을 가져옴 (태그 포함)
		});
		
		// 인코딩 후 hidden input에 저장
		$('#htmlCd').val(encodeURIComponent(combinedHtml));
		
		// 폼을 제출
		$('#vacationForm').submit();
	});
});
</script>

<form id="vacationForm" action="/hrMovementDoc/vacationDocRegist" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<button id="docSave" class="bg-indigo-500 justify-end text-white active:bg-indigo-600 font-bold uppercase text-sm mb-2 px-4 py-2.5 mt-9 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150">저장</button>
	<input type="hidden" id="htmlCd" name="htmlCd" />
	<input type="hidden" id="drftEmpNo" name="drftEmpNo" />
	<input type="hidden" id="useVcatnDayCnt" name="useVcatnDayCnt" />

	<div class="grid gap-6 mb-6">
		<div>
			<label for="docTtl" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">문서 제목<code> *</code></label>
			<input type="text" id="docTtl" name="docTtl"
				class="border border-gray-300  text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="문서 제목을 입력해주세요." required>
		</div>
		
		<div>
			<!-- vcatnCd -->
			<label for="vcatnCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">휴가 구분<code> *</code></label>
			<select name="vcatnCd" id="vcatnCd" class="h-10 px-3 py-2 w-full text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
				<option value="" selected disabled>선택해주세요</option>
				<c:forEach var="commonCodeVO" items="${vacationReasonList}">
					<option value="${commonCodeVO.clsfCd}">${commonCodeVO.clsfNm}</option>
				</c:forEach>
			</select>
			
		</div>
	</div>

	<div class="grid gap-6 mb-6 lg:grid-cols-2">
		<div>
			<!-- 오늘 이전 막기 -->
			<label for="startDay" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">휴가 시작 일자<code> *</code></label>
			<input type="date" id="startDay" name="startDay"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
			<input type="hidden" id="schdlBgngYmd" name="schdlBgngYmd" value="" />
		</div>
		
		<div>
			<!-- 오늘 이전 막기 -->
			<label for="endDay" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">휴가 종료 일자<code> *</code></label>
			<input type="date" id="endDay" name="endDay"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
			<input type="hidden" id="schdlEndYmd" name="schdlEndYmd" value="" />
		</div>
	</div>
	
	<div class="grid gap-6 mb-6">
		<div>
			<label for="vcatnRsn" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">휴가 사유<code> *</code></label>
			<input type="text" id="vcatnRsn" name="vcatnRsn" maxlength="45"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="사유를 입력해주세요." required>
		</div>
	</div>
</form>