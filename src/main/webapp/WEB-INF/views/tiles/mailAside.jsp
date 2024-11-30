<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
	.sidebar .nav-link {
	  color: #9F9F9F !important;
	}
	
	.sidebar .nav-link:hover {
	  background-color: #f4f4f4 !important;
	  transform: scale(1.01) !important;
	  color: #4E7DF4 !important;
	}
	
	.sidebar .nav-link:hover i {
	  color: #4E7DF4 !important;
	}
	
	.logo-link {
		display: inline-flex;
		align-items: center;
		text-decoration: none;
		background-color: white;
		padding: 20px 20px 20px 10px;
	}

	.logo-image {
		margin-right: 10px; /* 이미지와 텍스트 사이의 간격 */
		
	}

	.logo-text {
		font-size: 18px; /* 텍스트 크기 조정 */
		color: #9F9F9F; /* 텍스트 색상 */
		width: 100%;
	}
	
	.logoCls {
		background-color: white;
	}
</style>
<aside class="main-sidebar sidebar-primary elevation-4" style="font-family:Pretendard-Regular; font-weight: lighter;">
	<!-- Brand Logo -->
	<div class="logoCls">
		<a href="/" class="logo-link">
			<img src="/resources/images/tiles/logo.png" alt="logo" class="logo-image">
			<span class="logo-text">teamUP</span>
		</a>
	</div>
	
	<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal.employeeVO" var="empVO" />
	</sec:authorize>
	
	<!-- /.Brand Logo -->

	<!-- Sidebar -->
	<div class="sidebar" style="background-color: white;">
		<p>메일전용사이드</p>
		<!-- Sidebar Menu -->
		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class with font-awesome or any other icon font library -->
               
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-comment-dots fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;메신저</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/cmmn/mail/list?empNo=${empVO.empNo}" class="nav-link">
						<i class="fa-solid fa-envelope fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;메일</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-address-book fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;주소록</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-regular fa-calendar fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;캘린더</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-list fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;To-do List</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-cloud-arrow-up fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;드라이브</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-video fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;화상 회의</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-people-line fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;회의실 예약</p>
					</a>
				</li>
				
				<li class="nav-header"><hr style="boarder : 0px; height:1px; color: white;"></li>
				
				
				
				<li class="nav-header"><hr style="boarder : 0px; height:1px;"></li>
				
				
				
				<li class="nav-header"><hr style="boarder : 0px; height:1px;"></li>
				
				
				
				
				
			</ul>
		</nav>
		<!-- /.sidebar-menu -->
	</div>
	<!-- /.sidebar -->
</aside>