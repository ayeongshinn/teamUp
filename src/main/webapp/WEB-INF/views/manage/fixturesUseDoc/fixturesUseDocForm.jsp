<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<script type="text/javascript">
$(document).ready(function() {
    // 오늘 날짜를 YYYY-MM-DD 형식으로 가져오기
    var today = new Date();
    var year = today.getFullYear();
    var month = today.getMonth() + 1;  // 월은 0부터 시작하므로 +1 필요
    var day = today.getDate();

    if (month < 10) month = '0' + month;
    if (day < 10) day = '0' + day;

    var wrtYmd = year + month + day;  // YYYY-MM-DD 형식으로 변경

    console.log("wrtYmd : " + wrtYmd);
    
    // input 요소에 값 설정
    $('#wrtYmd').val(wrtYmd);
});

$(document).ready(function() {
			
	$('#docSave').on('click', function(event){
		event.preventDefault(); // 기본 동작 방지
		
		var startDate = $('#bgngYmd').val();
		var endDate = $('#endYmd').val();
		
		if (startDate) {
            var sDate = startDate.replace(/-/g, '');
            $('#useBgngYmd').val(sDate);
        }
		
		if (endDate) {
            var eDate = endDate.replace(/-/g, '');
            $('#useEndYmd').val(eDate);
        }
		
		
		var combinedHtml = "";
		
		// .myClass를 가진 모든 요소를 순서대로 가져와 combinedHtml에 추가
		$('.fixturesUseDoc').each(function() {
		    combinedHtml += $(this).prop('outerHTML');  // 요소의 전체 HTML을 가져옴 (태그 포함)
		});
		
		// 인코딩 후 hidden input에 저장
		$('#htmlCd').val(encodeURIComponent(combinedHtml));
		
		// 폼을 제출
		$('#fixturesUseForm').submit();
	});

});

</script>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<form id="fixturesUseForm" action="/fixturesUseDoc/fixRegist" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<button id="docSave" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2.5 mt-9 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150">저장</button>
	<input type="hidden" id="htmlCd" name="htmlCd" />
    <input type="hidden" id="drftEmpNo" name="drftEmpNo" value="${empVO.empNo}" />
    <input type="hidden" id="docCd" name="docCd" value="A29-006" />
    <input type="hidden" id="wrtYmd" name="wrtYmd" />	
	<div class="grid gap-6 mb-6">	
		<div>
			<label for="docTtl" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">문서
				제목<code> *</code></label>
			<input type="text" id="docTtl" name="docTtl"
				class="border border-gray-300  text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="문서 제목을 입력해주세요." required>
		</div>

		<div>
			<label for="usePrps" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">신청
				사유<code> *</code></label> <input type="text" id="usePrps" name="usePrps"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="신청사유를 입력해주세요." required>
		</div>
		
		<div>
			<label for="fxtrsNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">품명
				<code> *</code></label> <input type="text" id="fxtrsNm" name="fxtrsNm"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="비품명을 입력해주세요." required>
		</div>
		
		<div>
			<label for="fxtrsQy" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">수량
				<code> *</code></label> <input type="number" id="fxtrsQy" name="fxtrsQy"
				class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
				placeholder="수량을 선택해주세요." required>
		</div>
		
		<div class="grid gap-6 mb-6 lg:grid-cols-2">
			<div>
				<!-- 오늘 이전 막기 -->
				<label for="bgngYmd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300"> 사용 시작일<code> *</code></label>
				<input type="date" id="bgngYmd" name="bgngYmd" 
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
								<input type="hidden" id="useBgngYmd" name="useBgngYmd" value="" />
			</div>
			<div>
				<!-- 오늘 이전 막기 -->
				<label for="endYmd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300"> 사용 종료일<code> *</code></label>
				<input type="date" id="endYmd" name="endYmd"
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
								<input type="hidden" id="useEndYmd" name="useEndYmd" value="" />
			</div>
		</div>
	</div>
	<sec:csrfInput />
</form>


