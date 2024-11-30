<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html>
<html>

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

<head>
  <script type="text/javascript" src="/resources/js/jquery.min.js"></script>
  <title>설문 등록 폼</title>
  
  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="/resources/adminlte3/plugins/fontawesome-free/css/all.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="/resources/adminlte3/dist/css/adminlte.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
</head>


<script>

	var sock = new SockJS("/alram");
	socket = sock; // socket 초기화
	
	function submitSurveyForm() {
	    const startDate = $('input[name="srvyBgngDate"]');
	    const startTm = $('input[name="srvyBgngTm"]');
	    const endDate = $('input[name="srvyEndDate"]');
	    const endTm = $('input[name="srvyEndTm"]');
	    
	    let error = false;
	    
	    $(".errorMsg").remove();
	    
	    if(!startDate.val() || !startTm.val()) {
	        error = true;
	        $(startDate).before('<span class="error-message text-red-500 mr-1 text-sm flex items-center">시작 일시를 입력해 주세요</span>');
	    }
	    if(!endDate.val() || !endTm.val()) {
	        error = true;
	        $(endDate).before('<span class="error-message text-red-500 mr-1 text-sm flex items-center">종료 일시를 입력해 주세요</span>');
	    }
	    
	    if (error) {
	        $('#surveySettings').slideDown();
	        return;
	    }
	    
	    Swal.fire({
	        title: '설문을 등록하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#4E7DF4',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	    }).then(function(result) {
	        if(result.isConfirmed) {
	        	Swal.fire({
	        		title: '설문 등록이 완료되었습니다.',
	        		icon: 'success',
	        		confirmButtonColor:'#4E7DF4',
	        		confirmButtonText: '확인',
	        	}).then(function(result) {
	        		if(result.isConfirmed) {
			            var surveyForm = document.getElementById("frm");
			            if (surveyForm) {
			                surveyForm.submit(); // 폼 제출
		
			                // WebSocket 메시지 전송
			                if (socket && socket.readyState === WebSocket.OPEN) {
			                    let url = '/surveyList'; // 설문조사 목록 페이지 URL
			                    let icon = '<i class="fa-solid fa-chart-simple"></i>'; // 설문조사 아이콘
			                    let message = "새로운 설문조사가 등록되었습니다.";
			                    
			                    // 모든 사원에게 알림 전송 (서버에서 처리)
			                    socket.send("3," + "기획부서" + ",ALL," + icon + "," + message + "," + url);
			                } else {
			                    console.error("WebSocket is not connected. Trying to reconnect...");
			                    connectWs();
			                }
			            } else {
			                console.log('폼을 찾을 수 없습니다.');
			            }
	        		}
	        	})
	        }
	    });
	}

	//메시지 제거
	$('input[name="srvyBgngDate"], input[name="srvyBgngTm"], input[name="srvyEndDate"], input[name="srvyEndTm"]').on('input', function() {
	    $(this).prev('.error-message').remove();
	});
</script>

<body class="hold-transition sidebar-mini layout-fixed" style="background-color:#F5F5FC;">

	<!-- Header 영역 -->
	<header class="bg-white fixed top-0 left-0 w-full z-50">
		<div class="container mx-auto flex justify-center items-center h-16">
			<div class="flex space-x-64">
				<h1 class="text-lg pr-48 font-bold text-gray-600">설문 작성</h1>
				<input type="button" id="submit222" value="완료" class="text-md pl-32 font-regular text-gray-400"
						onclick="submitSurveyForm()">
			</div>
		</div>
	</header>

	<!-- Content 영역 -->
	<div style="background-color: #F5F5FC; padding-top: 80px; padding-bottom: 60px;">
		<tiles:insertAttribute name="body" />
	</div>

	<!-- JS Scripts -->
	<script src="/resources/adminlte3/plugins/jquery/jquery.min.js"></script>
	<script src="/resources/adminlte3/plugins/jquery-ui/jquery-ui.min.js"></script>
	<script>
		$.widget.bridge('uibutton', $.ui.button);
	</script>
	<script src="/resources/adminlte3/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="/resources/adminlte3/plugins/moment/moment.min.js"></script>
	<script src="/resources/adminlte3/plugins/daterangepicker/daterangepicker.js"></script>
	<script src="/resources/adminlte3/plugins/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>
	<script src="/resources/adminlte3/plugins/summernote/summernote-bs4.min.js"></script>
	<script src="/resources/adminlte3/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
	<script src="/resources/adminlte3/dist/js/adminlte.js"></script>
</body>
</html>