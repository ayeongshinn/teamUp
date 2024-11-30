<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<!-- jQuery 라이브러리 (최신 버전) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- jQuery UI 라이브러리 -->
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<!-- jQuery UI CSS (자동완성 UI 스타일 포함) -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

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

.highlight {
	background-color: yellow;
}
</style>

<script type="text/javascript">

$(document).ready(function() { 
    $('#docType').on('change', function() {
        var selectedValue = $(this).val();

        // 모든 div를 숨기기
        $('#hrMovementDocDiv, #hrMovementFormDiv').hide();
        $('#vacationDocDiv, #vacationFormDiv').hide();
        $('#resignationDocDiv, #resignationFormDiv').hide();
        $('#salaryDocDiv, #salaryFormDiv').hide();
        
        
        // 선택된 div만 보이기
        if (selectedValue === 'hrMovementDoc') {
            $('#hrMovementDocDiv, #hrMovementFormDiv').show();
            
        } else if (selectedValue === 'vacationDoc') {
            $('#vacationDocDiv, #vacationFormDiv').show();
            
        } else if (selectedValue === 'resignationDoc') {
            $('#resignationDocDiv, #resignationFormDiv').show();
            
        } else if (selectedValue === 'salaryDoc') {
            $('#salaryDocDiv, #salaryFormDiv').show();
        } 
    });

    // 페이지 로드 시 선택된 옵션에 따라 초기화
    $('#docType').trigger('change');
});


</script>

<div class="flex justify-center">
	<div class="w-4/6 bg-white p-16" id="jspContainer">
		<!-- 문서 양식 시작 -->
<!-- 		<div id="hrMovementDocDiv" style="display: none;"> -->
<%-- 			<%@ include file="hrMovementDoc.jsp" %> --%>
<!-- 		</div> -->
		
		<div id="vacationDocDiv" style="display: none;">
			<%@ include file="vacationDoc.jsp" %>
		</div>
		
<!-- 		<div id="resignationDocDiv" style="display: none;"> -->
<%-- 			<%@ include file="resignationDoc.jsp" %> --%>
<!-- 		</div> -->
		
<!-- 		<div id="salaryDocDiv" style="display: none;"> -->
<%-- 			<%@ include file="salaryDoc.jsp" %> --%>
<!-- 		</div> -->
	</div>
	
	
	<div class="w-4/6 bg-white p-16">
		<h2	class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">문서 작성</h2>
		<div>
			<!-- 추후에 바꿔서 넣기 -->
			<select id="docType" class="form-control">
			    <option value="hrMovementDoc">인사 이동 기안서</option>
			    <option value="vacationDoc" selected>휴가 기안서</option>
			    <option value="resignationDoc">사직서</option>
			    <option value="salaryDoc">연봉 계약서</option>
			</select>
		</div>
		
		<!-- 문서 작성 폼 시작 -->
		<div id="hrMovementFormDiv" style="display: none;">
		    <%@ include file="hrMovementForm.jsp" %>
		</div>
		
<!-- 		<div id="vacationFormDiv" style="display: none;"> -->
<%-- 		    <%@ include file="vacationForm.jsp" %> --%>
<!-- 		</div> -->
		
<!-- 		<div id="resignationFormDiv" style="display: none;"> -->
<%-- 			<%@ include file="resignationForm.jsp" %> --%>
<!-- 		</div> -->
		
<!-- 		<div id="salaryFormDiv" style="display: none;"> -->
<%-- 			<%@ include file="salaryForm.jsp" %> --%>
<!-- 		</div> -->
		
	</div>
</div>
