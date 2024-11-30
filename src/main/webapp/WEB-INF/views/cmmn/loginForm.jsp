<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<script type="text/javascript">

$(document).ready(function() {
	
	//클릭 시 비밀번호 표시/숨기기
    $("#togglePassword").on("click", function() {
        const passwordField = $("#password");
        const passwordFieldType = passwordField.attr("type");
        
        if (passwordFieldType === "password") {
            passwordField.attr("type", "text");  //비밀번호 보여주기
            $(this).removeClass("fas fa-eye-slash").addClass("fas fa-eye");
        } else {
            passwordField.attr("type", "password");  //비밀번호 숨기기
            $(this).removeClass("fas fa-eye").addClass("fas fa-eye-slash");
        }
    });
	
    //쿠키에서 사번 불러오기
    if (getCookie("rememberEmpNo")) {
        $("#username").val(getCookie("rememberEmpNo"));
        $("#rememberEmpNo").prop('checked', true);
    }

	//엔터 입력 시 sign in 버튼 클릭
	$("#confirm").on("keyup", function(key) {
		if (key.keyCode == 13) {
			$("#confirm").click();
		}
	});
	
	//로그인 버튼 클릭 시 아이디 기억하기 설정
    $("#confirm").on("click", function() {
        if ($("#rememberEmpNo").is(":checked")) {
            setCookie("rememberEmpNo", $("#username").val(), 30); //30일 동안 쿠키 저장
        } else {
            setCookie("rememberEmpNo", "", 0); //체크 해제 시 쿠키 삭제
        }
    });
});

	//쿠키 설정 함수
	function setCookie(cname, cvalue, exdays) {
	    var d = new Date();
	    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000)); // 쿠키 만료일 설정
	    var expires = "expires=" + d.toUTCString();
	    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
	}
	
	// 쿠키 가져오는 함수
	function getCookie(cname) {
	    var name = cname + "=";
	    var decodedCookie = decodeURIComponent(document.cookie);
	    var ca = decodedCookie.split(';');
	    for (var i = 0; i < ca.length; i++) {
	        var c = ca[i].trim();
	        if (c.indexOf(name) === 0) {
	            return c.substring(name.length, c.length);
	        }
	    }
	    return "";
	}

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
	background-color: #f0f2f5; /* 전체 배경 색 */
}

/* 입력 필드 스타일 */
.input-field {
	width: 100%;
	padding: 12px 20px;
	display: inline-block;
	border-radius: 30px;
	border: none;
	background-color: #F3F7FF; /* 밝은 파란색 배경 */
	color: #6b7280; /* 텍스트 색상 */
	font-size: 14px;
	box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.1);
	font-family:Pretendard-Regular;
}

.input-field::placeholder {
	color: #6b7280; /* 플레이스홀더 색상 */
}

input:focus {
	outline: 1.5px solid #4E7DF4;
}

/* SIGN IN 버튼 스타일 */
.submit-button {
	width: 100%;
	padding: 12px;
	background-color: #4E7DF4; /* 기본 파란색 */
	color: white;
	font-size: 14px;
	font-weight: bold;
	border: none;
	border-radius: 30px;
	cursor: pointer;
	margin-top: 20px;
	transition: background-color 0.3s ease;
}

.submit-button:hover {
	background-color: #3A66C9; /* 호버 시 더 진한 파란색 */
}

.flex {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.text-gray-600 {
	color: #6b7280;
}

.text-blue-500 {
	color: #4E7DF4;
}

#togglePassword {
    font-size: 18px;
    color: #D3D3D3; /* 회색 */
}

#togglePassword:hover {
    color: #4E7DF4; /* 호버 시 파란색 */
}

</style>

<body>
	<div class="flex justify-center items-center h-screen relative">
	<!-- 로그인 폼 -->
		<div class="w-[400px] p-12 bg-white rounded-2xl shadow-lg relative z-10 mr-[-10rem]">
			<div class="text-center">
				<img alt="로고" src="/resources/images/findPswdLogo.png" class="mx-auto mb-6 w-32 h-auto">
				<!-- 로고 크기 및 중앙 정렬 -->
				<h2 class="text-lg font-bold tracking-tight text-gray-900 sm:text-2xl" style="margin-top: 30px;">로그인</h2>
			</div>
			<c:if test="${not empty error}">
				<div class="text-sm font-bold mt-2.5" role="alert" style="color: red; text-align: center;">${error}</div>
			</c:if>
			<form action="/login" method="POST" class="mt-8 space-y-6">
				<!-- 사번 필드 -->
				<div>
					<div class="mt-2.5">
						<input type="text" name="username" id="username" autocomplete="organization" placeholder="ID" class="input-field">
					</div>
				</div>
				<!-- 비밀번호 필드 -->
				<div style="position: relative;">
					<input type="password" name="password" id="password" autocomplete="organization" placeholder="PASSWORD"
							class="input-field" style="padding-right: 40px;">
					<i class="fas fa-eye-slash" id="togglePassword"
						style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
				</div>
				<div class="flex justify-between mt-3" style="margin: 10px 10px;">
					<div class="flex items-center">
						<input type="checkbox" id="rememberEmpNo" name="rememberEmpNo"
							class="mr-2"> <label for="rememberEmpNo"
							class="text-sm text-gray-600">ID 기억하기</label>
					</div>
					<div>
						<a href="${pageContext.request.contextPath}/findPswd"
							class="text-sm text-blue-500 hover:underline">비밀번호 찾기</a>
					</div>
				</div>
				<div class="mt-10 flex justify-center space-x-4">
					<button type="submit" id="confirm" class="submit-button">SIGN IN</button>
				</div>
				<sec:csrfInput />
			</form>
		</div>
		<img alt="loginForm" src="/resources/images/loginForm.png" class="w-[450px] shadow-lg" style="border-radius: 16px;">
	</div>
</body>
