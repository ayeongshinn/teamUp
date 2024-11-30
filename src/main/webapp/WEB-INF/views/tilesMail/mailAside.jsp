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
		
		<!-- Sidebar Menu -->
		<nav class="mt-2">
			<div style="text-align: center;">
				<i class="fa-regular fa-pen-to-square" style="color:#424242; vertical-align: middle;"></i>
				<input type="button" value="메일 쓰기" onclick = "location.href = '/cmmn/mail/send'"/>
			</div>
			
			<ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class with font-awesome or any other icon font library -->
               
				
			
				<li class="nav-header"><hr style="boarder : 0px; height:1px; color: white;"></li>
				
				<li class="nav-item">
					<a href="/cmmn/mail/list?empNo=${empVO.empNo}" class="nav-link">
						<i class="fa-solid fa-envelope fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;받은 메일함</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/cmmn/mail/sendList?empNo=${empVO.empNo}" class="nav-link">
						<i class="fa-solid fa-paper-plane" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;보낸 메일함</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/cmmn/mail/delList?empNo=${empVO.empNo}" class="nav-link">
						<i class="fa-regular fa-trash-can" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;휴지통</p>
					</a>
				</li>
				
				
				
				
				
				
				
			</ul>
		</nav>
		<!-- /.sidebar-menu -->
	</div>
	<!-- /.sidebar -->
</aside>