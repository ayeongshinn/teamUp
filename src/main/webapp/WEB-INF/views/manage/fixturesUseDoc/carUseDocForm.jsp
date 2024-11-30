<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<script type="text/javascript">
$(document).ready(function() {
    // 오늘 날짜를 YYYYMMDD 형식으로 가져오기
    var today = new Date();
    var year = today.getFullYear();
    var month = today.getMonth() + 1;  // 월은 0부터 시작하므로 +1 필요
    var day = today.getDate();

    if (month < 10) month = '0' + month;
    if (day < 10) day = '0' + day;

    var wrtYmd = year + "" + month + "" + day;  // YYYYMMDD 형식으로 변경

    console.log("wrtYmd : " + wrtYmd);
    
    // input 요소에 값 설정
    $('#ymdWrt').val(wrtYmd);
    
    // 폼 제출 전 데이터 처리
    $('#saveDoc').click(function(event) {
        event.preventDefault(); // 기본 동작 방지
        
        debugger;
        
        var frm = $('#carUseForm');
        
        // 시작일과 종료일 값 가져오기
        var start = $('#ymdBgng').val();
        var end = $('#ymdEnd').val();
        
        if (start) {
            var sttDate = start.replace(/-/g, '');  // 하이픈 제거
            $("input[name=useBgngYmd", frm).val(sttDate);  // Hidden input에 값 설정
            console.log("useBgngYmd Date (val): " + $("input[name=useBgngYmd", frm).val());  // 설정된 값 확인
        }

        if (end) {
            var endDate = end.replace(/-/g, '');  // 하이픈 제거
            $("input[name=useEndYmd", frm).val(endDate);  // Hidden input에 값 설정
            console.log("useEndYmd Date (val): " + $("input[name=useEndYmd", frm).val());  // 설정된 값 확인
        }

        var combinedHtml = "";
        
        // .carUseDoc를 가진 모든 요소의 HTML을 결합하여 hidden input에 저장
        $('.carUseDoc').each(function() {
            combinedHtml += $(this).prop('outerHTML');  // 요소의 전체 HTML을 가져옴 (태그 포함)
        });
        
        $('#cdHtml').val(encodeURIComponent(combinedHtml));
        
        
        console.log($('#carUseForm').serialize());
        
        // 폼을 제출
        $('#carUseForm').submit();
    });
});
</script>

<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<form id="carUseForm" action="/fixturesUseDoc/carRegist" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <button id="saveDoc" type="button" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2.5 mt-9 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150">저장</button>
    <input type="hidden" id="cdHtml" name="htmlCd" />
    <input type="hidden" id="drftEmpNo" name="drftEmpNo" value="${empVO.empNo}" />
    <input type="hidden" id="docCd" name="docCd" value="A29-007" />
    <input type="hidden" id="ymdWrt" name="wrtYmd" />
    <input type="hidden" id="useEndYmd" name="useEndYmd"/>
    <input type="hidden" id="useBgngYmd" name="useBgngYmd"/>
    
    <div class="grid gap-6 mb-6">    
        <div>
            <label for="ttlDoc" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">문서
                제목<code> *</code></label>
            <input type="text" id="ttlDoc" name="docTtl"
                class="border border-gray-300  text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                placeholder="문서 제목을 입력해주세요." required>
        </div>

        <div>
            <label for="prpsUse" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">신청
                사유<code> *</code></label> 
            <input type="text" id="prpsUse" name="usePrps"
                class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                placeholder="신청사유를 입력해주세요." required>
        </div>
        
        <div class="grid gap-6 mb-6 lg:grid-cols-2">
            <div>
                <label for="ymdBgng" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300"> 사용 시작일<code> *</code></label>
                <input type="date" id="ymdBgng" name="bgngYmd" 
                    class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
            </div>
            <div>
                <label for="ymdEnd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300"> 사용 종료일<code> *</code></label>
                <input type="date" id="ymdEnd" name="endYmd"
                    class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
            </div>
        </div>
    </div>
    <sec:csrfInput />
</form>
