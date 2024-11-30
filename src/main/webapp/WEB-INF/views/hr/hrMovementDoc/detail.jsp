<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

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

</style>

<div class="bg-white w-full y-auto">
    <h2>문서 번호: ${hrMovementDocVO.docNo}</h2>
    <h3>문서 제목: ${hrMovementDocVO.docTtl}</h3>
    <p>작성 날짜: ${hrMovementDocVO.wrtYmd}</p>
    <p>대상 사원: ${hrMovementDocVO.trgtEmpNo}</p>
    <p>부서 코드: ${hrMovementDocVO.deptCd}</p>
    <p>직급 코드: ${hrMovementDocVO.jbgdCd}</p>
    <p>발령 일자: ${hrMovementDocVO.trgtEmpDay}</p>

    <!-- HTML 내용을 출력 -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/hrMovementDoc_style.css">
    <div>
        ${hrMovementDocVO.htmlCd}
    </div>
</div>
