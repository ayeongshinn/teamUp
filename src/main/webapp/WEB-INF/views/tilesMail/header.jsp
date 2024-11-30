<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authorize access="isAuthenticated()">
   <sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
$(function(){
	$("#profileImg").on("click", function(){
		let deptCd = "${empVO.deptCd}"; // 부서 코드
		let jbgdCd = "${empVO.jbgdCd}"; // 직급 코드
		
		let data = {
				"clsfCd1" : deptCd,
				"clsfCd2" : jbgdCd,
		}
		
		$.ajax({
			url:"/tiles/getDept",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
				$("#empInfo").text(res[0].clsfNm + " 부서 / " + res[1].clsfNm);
				$("#profileJbgdCd").text("${empVO.empNm} " + res[1].clsfNm + "님");
				
			}
		});
		
		$.ajax({
			url:"/tiles/getEmpSttus",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(${empVO.empNo}),
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
				$("#empSttus").html("&ensp;" + res.commonCodeVOList[0].clsfNm);
			},
			error: function(xhr) {
				$("#empSttus").html("&ensp;미 출근");
			}
		});
		
	})
})
</script>
<style>
    .nav-item.dropdown {
        display: flex;
        align-items: center;
    }
    .nav-item.dropdown .nav-link {
        display: flex;
        align-items: center;
    }
    
    div {
    	font-family: "Pretendard-Regular";
    }
</style>
<nav class="main-header navbar navbar-expand navbar-white navbar-light">
	<!-- Left navbar links -->
	<ul class="navbar-nav">
		<li class="nav-item"><a class="nav-link" data-widget="pushmenu"
			href="#" role="button"><i class="fas fa-bars"></i></a></li>
	</ul>

	<!-- Right navbar links -->
	<ul class="navbar-nav ml-auto">
		<!-- Messages Dropdown Menu -->
		<li class="nav-item dropdown"><a class="nav-link"
			data-toggle="dropdown" href="#"> <i class="far fa-comments"></i>
				<span class="badge badge-danger navbar-badge">3</span>
		</a>
			<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
				<a href="#" class="dropdown-item"> <!-- Message Start -->
					<div class="media">
						<img src="/resources/adminlte3/dist/img/user1-128x128.jpg" alt="User Avatar"
							class="img-size-50 mr-3 img-circle">
						<div class="media-body">
							<h3 class="dropdown-item-title">
								Brad Diesel <span class="float-right text-sm text-danger"><i
									class="fas fa-star"></i></span>
							</h3>
							<p class="text-sm">Call me whenever you can...</p>
							<p class="text-sm text-muted">
								<i class="far fa-clock mr-1"></i> 4 Hours Ago
							</p>
						</div>
					</div> <!-- Message End -->
				</a>
				<a href="#" class="dropdown-item"> <!-- Message Start -->
					<div class="media">
						<img src="/resources/adminlte3/dist/img/user8-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
						<div class="media-body">
							<h3 class="dropdown-item-title">
								John Pierce <span class="float-right text-sm text-muted"><i
									class="fas fa-star"></i></span>
							</h3>
							<p class="text-sm">I got your message bro</p>
							<p class="text-sm text-muted">
								<i class="far fa-clock mr-1"></i> 4 Hours Ago
							</p>
						</div>
					</div> <!-- Message End -->
				</a>
				<a href="#" class="dropdown-item"> <!-- Message Start -->
					<div class="media">
						<img src="/resources/adminlte3/dist/img/user3-128x128.jpg" alt="User Avatar" class="img-size-50 img-circle mr-3">
						<div class="media-body">
							<h3 class="dropdown-item-title">
								Nora Silvester <span class="float-right text-sm text-warning"><i
									class="fas fa-star"></i></span>
							</h3>
							<p class="text-sm">The subject goes here</p>
							<p class="text-sm text-muted">
								<i class="far fa-clock mr-1"></i> 4 Hours Ago
							</p>
						</div>
					</div> <!-- Message End -->
				</a>
				<div class="dropdown-divider"></div>
				<a href="#" class="dropdown-item dropdown-footer">See All
					Messages</a>
			</div></li>
		<!-- Notifications Dropdown Menu -->
		<li class="nav-item dropdown">
			<a class="nav-link" data-toggle="dropdown" href="#">
				<i class="far fa-bell"></i>
				<span class="badge badge-warning navbar-badge">15</span>
			</a>
			
			<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
				<span class="dropdown-item dropdown-header">15 Notifications</span>
				<div class="dropdown-divider"></div>
					<a href="#" class="dropdown-item">
						<i class="fas fa-envelope mr-2"></i> 4 new messages
						<span class="float-right text-muted text-sm">3 mins</span>
					</a>
				
				<div class="dropdown-divider"></div>
					<a href="#" class="dropdown-item">
						<i class="fas fa-users mr-2"></i> 8 friend requests
						<span class="float-right text-muted text-sm">12 hours </span>
					</a>
				<div class="dropdown-divider"></div>
					<a href="#" class="dropdown-item">
						<i class="fas fa-file mr-2"></i> 3 new reports
						<span class="float-right text-muted text-sm">2 days</span>
					</a>
					
				<div class="dropdown-divider"></div>
				<a href="#" class="dropdown-item dropdown-footer">See All Notifications</a>
			</div>
		</li>
		
		<li class="nav-item">
			<a class="nav-link" data-widget="fullscreen" href="#" role="button">
				<i class="fas fa-expand-arrows-alt"></i>
			</a>
		</li>
		
<!-- Login Info Dropdown Menu -->
<li class="nav-item dropdown">
    <!-- 시큐리티 계정 관리 시작 -->
    <div style="border-left: 1px solid #D9D9D9 !important;">
        <!-- 스프링 시큐리티 표현식 : 인증 및 권한 정보에 따라 화면을 동적으로 구성할 수 있고, 로그인 한 사용자 정보를 보여줄 수도 있음 -->
        <!-- /// 로그인 전 /// -->
        <sec:authorize access="isAnonymous()">
            <a href="/login" class="nav-link" style="padding: 0px 16px 0px 24px;">
                <img src="/resources/images/tiles/user.png" class="img-circle" style="width: 30px; height: 30px;" alt="user.png">
            </a>
        </sec:authorize>
        <!-- /// 로그인 전 /// -->
    
        <!-- /// 로그인 후 /// -->
        <sec:authorize access="isAuthenticated()">
            <sec:authentication property="principal.employeeVO" var="employeeVO" />
            
            <a class="nav-link" data-toggle="dropdown" href="#" style="padding: 0px 16px 0px 24px;">
                <img src="/resources/images/tiles/karina.gif" class="img-circle" style="width: 30px; height: 30px;" alt="karina.gif" id="profileImg">
            </a>
            
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right" style="border-radius: 10px; background-color: #F5F5FC;">
                <span class="dropdown-item dropdown-header" style="background-color: #4E7DF4; color: white; border-radius: 10px 10px 0 0; font-size: 12px;">STATUS</span>
                <div style="display: flex;">
                	<div style="display:flex; align-items: center;">
		                <span>
			                <img src="/resources/images/tiles/karina.gif" class="img-circle" style="width: 60px; height: 60px; display: inline-block; margin: 20px;" alt="karina.gif">
		                </span>
                	</div>
                	<div style="display: flex; flex-direction: column; justify-content: center;">
		                <strong id="profileJbgdCd"></strong>
		                <p id="empInfo" style="font-size: 12px; margin-top: 3px;"></p>
                	</div>
                </div>
                <div style="padding: 0px 20px 15px 20px;">
                	<div style="border: 0.1px solid rgba(68, 68, 68, 0.2); border-radius: 20px; background-color: white;">
                		<div style="padding: 5px 15px;">
	                		<i class="fa-solid fa-clock" style="vertical-align: middle; color:#424242;"></i><span id="empSttus"style="font-size: 14px;"></span>
                		</div>
                	</div>
                </div>
                <div class="dropdown-divider"></div>
                <form action="/logout" method="post">
                    <button type="submit" style="font-size: 14px; color: red; margin: 10px 35px;"><i class="fa-solid fa-arrow-right-from-bracket" style="color:red;"></i>&ensp;로그아웃</button>
                    <sec:csrfInput />
                </form>
            </div>
        </sec:authorize>
        <!-- /// 로그인 후 /// -->
    </div>
    <!-- 시큐리티 계정 관리 끝 -->
</li>
	</ul>

</nav>



