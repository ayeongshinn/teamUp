<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
       src: url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
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
	$("#docType").on('change',function(){
		var selectDoc = $(this).val();
		
		$("#fixturesUseDocDiv, #fixturesUseDocFormDiv, #carUseDocDiv, #carUseDocFormDiv").hide();
		
        // 선택된 div만 보이기
        if (selectDoc === 'fixturesUseDoc') {
            $('#fixturesUseDocDiv, #fixturesUseDocFormDiv').show();
        } else if (selectDoc === 'carUseDoc') {
            $('#carUseDocDiv, #carUseDocFormDiv').show();
        }
	});
	
    // 페이지 로드 시 선택된 옵션에 따라 초기화
    $('#docType').trigger('change');
});
</script>

<div class="flex justify-center">
	<div class="w-4/6 bg-white p-16" id="jspContainer">
		<!-- 문서 양식 -->
		<div id="fixturesUseDocDiv" style="display: none;">
			<%@ include file="fixturesUseDoc.jsp" %>
		</div>
		<div id="carUseDocDiv" style="display: none;">
			<%@ include file="carUseDoc.jsp" %>
		</div>			
	</div>
	
	<div class="w-4/6 bg-white p-16">
		<h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">문서 작성</h2>
		<div>
			<select id="docType" class="form-control">
				<option value="fixturesUseDoc" selected>비품 사용 신청서</option>
				<option value="carUseDoc">법인 차량 사용 신청서</option>
			</select>
		</div>

	
		<div id="fixturesUseDocFormDiv" style="display: none;">
			<%@ include file="fixturesUseDocForm.jsp" %>
		</div>

	    <div id="carUseDocFormDiv" style="display: none;">
			<%@ include file="carUseDocForm.jsp" %>
		</div>
		
	</div>
</div>
