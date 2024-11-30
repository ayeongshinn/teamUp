<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<script type="text/javascript">
$(document).ready(function() {
	$('#docSave').on('click', function(event){
		event.preventDefault(); // 기본 동작 방지
		
		var selectedDate = $('#trgtDay').val();
		var combinedHtml = "";
		
		if (selectedDate) {
            var formattedDate = selectedDate.replace(/-/g, '');
            $('#trgtEmpDay').val(formattedDate);
        }
		
		// .myClass를 가진 모든 요소를 순서대로 가져와 combinedHtml에 추가
		$('.hrMovementDoc').each(function() {
		    combinedHtml += $(this).prop('outerHTML');  // 요소의 전체 HTML을 가져옴 (태그 포함)
		});
		
		// 인코딩 후 hidden input에 저장
		$('#htmlCd').val(encodeURIComponent(combinedHtml));
		
		// 폼을 제출
		$('#hrMovementForm').submit();
	});
});
</script>

<form id="hrMovementForm" action="/hrMovementDoc/hrMovementDocRegist" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<input type="hidden" id="htmlCd" name="htmlCd" />
	<button id="docSave" class="bg-indigo-500 justify-end text-white active:bg-indigo-600 font-bold uppercase text-sm mb-2 px-4 py-2.5 mt-9 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150">저장</button>
	<div class="grid gap-6 mb-6">
		<div>
			<label for="docTtl" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">문서 제목<code> *</code></label>
			<input type="text" id="docTtl" name="docTtl"
				class="border border-gray-300  text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="문서 제목을 입력해주세요." required>
		</div>

		<div>
			<label for="trgtEmpNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">대상 사원<code> *</code></label>
			<input type="text" id="trgtEmpNm" name="trgtEmpNm"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="사원명을 입력해주세요." required>
			<input type="hidden" id="trgtEmpNo" name="trgtEmpNo" value="">
		</div>

		<div>
			<label for="docCn" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">신청 사유<code> *</code></label>
			<input type="text" id="docCn" name="docCn" maxlength="45"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="사유를 입력해주세요." required>
		</div>

		<div>
			<label for="project" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">담당 프로젝트</label>
			<input type="text" id="project" name="project"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="담당 프로젝트를 입력해주세요." required>
		</div>
	</div>

	<div class="grid gap-6 mb-6 lg:grid-cols-2">
		<div>
			<label for="deptCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">발령 부서<code> *</code></label>
			<select name="deptCd" id="deptCd" class="h-10 px-3 py-2 mt-6 mx-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
				<option value="" selected disabled>선택해주세요</option>
				<c:forEach var="commonCodeVO" items="${deptList}">
					<c:if test="${commonCodeVO.clsfCd != 'A17-001'}">
						<option value="${commonCodeVO.clsfCd}">${commonCodeVO.clsfNm}</option>
					</c:if>
				</c:forEach>
			</select>
		</div>
		
		<div>
			<label for="jbgdCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">발령 직급<code> *</code></label>
			<select name="jbgdCd" id="jbgdCd" class="h-10 px-3 py-2 mt-6 mx-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
				<option value="" selected disabled>선택해주세요</option>
				<c:forEach var="commonCodeVO" items="${jbgdList}">
					<c:if
						test="${commonCodeVO.clsfCd != 'A18-006' && commonCodeVO.clsfCd != 'A18-005'}">
						<option value="${commonCodeVO.clsfCd}">${commonCodeVO.clsfNm}</option>
					</c:if>
				</c:forEach>
			</select>
		</div>

		<div>
			<!-- 오늘 이전 막기 -->
			<label for="trgtDay" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300"> 발령 일자<code> *</code></label>
			<input type="date" id="trgtDay" name="trgtDay"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
			<input type="hidden" id="trgtEmpDay" name="trgtEmpDay" value="" />
		</div>
		
		<div>
			<label for="note" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">비고</label>
			<input type="text" id="note" name="note" maxlength="7"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="비고를 입력해주세요.">
		</div>
	</div>
</form>