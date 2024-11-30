<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal.employeeVO" var="empVO" />
	</sec:authorize>
<!DOCTYPE html>
<html>
<head>
<link rel="preconnect" href="https://rsms.me/">
<link rel="stylesheet" href="https://rsms.me/inter/inter.css">
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>

<script type="text/javascript">

$(function() {
    $("#confirm").on("click", function(e) {
        e.preventDefault();
        
        let inputPassword = $("#inputPassword").val();
        let empNo = ${empVO.empNo};
        
        console.log(inputPassword);
        
        $.ajax({
            url: "/cmmn/myPage/checkPassword",  // 비밀번호 체크 컨트롤러 경로
            type: "POST",
            data: {
                empNo: empNo,
                password: inputPassword
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                if(result === "success") {
                    location.href = "/cmmn/myPage/myInfo";
                } else {
                    $("#pwsdCheck").text("비밀번호가 일치하지 않습니다");
                    $("#inputPassword").val("").focus();
                }
            },
            error: function() {
                alert("서버 오류가 발생했습니다.");
            }
        });
    });
});

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
	
	.bg-indigo-500 {
	  background-color: #4E7DF4;
	}
	
	mark {
		background: #ff0; !important;
		color: #000; !important;
	}
	
	svg {
		color: #4E7DF4;
	}
	
	#wCntElement {
		text-decoration: underline;
		cursor: pointer;
	}
	
	#wCntElement:hover {
		color: #ffffff
	}
	
	#myNoticesElement {z
		text-decoration: underline;
		cursor: pointer;
	}
	
	#myNoticesElement:hover {
		color: #ffffff
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
	.input-field {
	width: 100%;
	padding: 12px 20px;
	margin: 8px 0;
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
	
	.nav-button {
       background-color: white; /* 기본 배경색 */
       color: black; /* 기본 글자색 */
       border: none; /* 테두리 없애기 */
       padding: 10px 20px; /* 여백 */
       border-radius: 5px; /* 모서리 둥글게 */
       cursor: pointer; /* 마우스 커서 변경 */
       transition: background-color 0.3s, color 0.3s; /* 호버 효과를 부드럽게 */
}
.nav-button:hover {
    background-color: #4E7DF4; /* 호버 시 배경색 하얀색으로 변경 */
    color: white; /* 호버 시 글자색 검정색으로 변경 */
}
     
</style>

</head>
<body>
	
	<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 mt-15" >
	    <div class="w-full flex justify-between items-center mt-1  pl-3 mb-4">
	       <div style="margin-top: 30px; margin-bottom: 10px;">
	            <h3 class="text-lg font-semibold text-slate-800">
	            	　
	            </h3>
	            <p class="text-slate-500">　</p>
	        </div>
	    </div>
	    
			<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg  bg-clip-border " style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);">
				<div class="card-body table-responsive p-0">
					<div class="flex flex-col justify-center items-center mt-20 mb-20">
						 <div class="mx-auto max-w-sm p-12 bg-white rounded-2xl mt-20 mb-20" style="max-width: 27rem;">
						 	<img src="/resources/images/infoLock.jpg" style="width: 20%; margin: 0px auto;">
							<div class="text-center">
								<!-- 로고 크기 및 중앙 정렬 -->
								<h4
									class="font-bold tracking-tight text-gray-900 sm:text-2xl" style="margin: 30px auto; margin-bottom: 10px; font-size: 18px;">개인정보 보호를 위해 비밀번호를 입력해 주세요</h4>
								<div id="pwsdCheck" class="text-sm font-bold" role="alert" style="color: red; text-align: center;"></div>
							</div>
							<c:if test="${not empty error}" >
								<div class="text-sm font-bold mt-2.5" role="alert" style="color: red; text-align: center;">
									${error}
								</div>
							</c:if>
							<form action="/cmmn/myPage/myInfoSecuPost" method="POST">
								<!-- 비밀번호 필드 -->
								<div>
									<div class="mt-2.5" style="width: 80%; margin: 0px auto; margin-bottom: 20px; margin-top: 40px;">
										<input type="text" id="empNo"
										name="empNo" value="${empVO.empNo}" hidden="hidden" />
										<input type="password" name="inputPassword" id="inputPassword"
											autocomplete="organization" placeholder="PASSWORD"
											class="input-field" style="margin-top: -40px" required="required">
									</div>
								</div>
								<div class="flex justify-center space-x-4" style="width: 80%; margin: 0px auto;">
									<button type="submit" id="confirm" class="submit-button">확인</button>
								</div>
								<sec:csrfInput />
							</form>
						</div>	
					</div>
				</div>
			</div>
		</div>
	</body>
</html>