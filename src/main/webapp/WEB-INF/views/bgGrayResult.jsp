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
  <title>설문 결과</title>
  
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
</head>

<script src="https://cdn.tailwindcss.com"></script>
<script>
	$(document).ready(function() {
		$("#confirmBtn").on("click", function() {
			window.close();
		})
	})
</script>
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
	
	header {
		font-family: 'Pretendard-Regular', sans-serif;
	}
	
	
	.my-alert-class .swal2-icon { /* 아이콘 */ 
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

<body class="hold-transition sidebar-mini layout-fixed" style="background-color:#F5F5FC;">

	<!-- Header 영역 -->
	<header class="bg-white fixed top-0 left-0 w-full z-50">
		<div class="container mx-auto flex justify-center items-center h-16">
			<div class="flex space-x-64">
				<h1 class="text-lg pr-48 font-bold text-gray-600">설문 결과</h1>
				<input type="button" id="confirmBtn" value="확인" class="text-md pl-32 font-regular text-gray-400">
			</div>
		</div>
	</header>

	<!-- Content 영역 -->
	<div style="background-color: #F5F5FC; padding-top: 80px; padd ing-bottom: 60px;">
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