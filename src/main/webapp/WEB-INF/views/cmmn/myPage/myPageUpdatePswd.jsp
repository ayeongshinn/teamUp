<!-- updatePswd.jsp 신아영 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<script>

    // 비밀번호 정규 표현식
    function validatePswd(password) {
        let pswdRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,16}$/;
        return pswdRegex.test(password);
    }
    
    //취소 alert
    function cancel() {
		Swal.fire({
			title: '로그인 페이지로 이동하시겠습니까?',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#4E7DF4',
			confirmButtonText: '확인',
			cancelButtonText: '취소',
			reverseButtons: true,
		}).then((result) => {
			if(result.isConfirmed) {
				window.location.href = "/login";
			}
		});
	}
    
    //완료 alert
    function success() {
		Swal.fire({
			title: '비밀번호가 성공적으로 변경되었습니다',
			icon: 'success',
			confirmButtonColor: '#4E7DF4',
			confirmButtonText: '확인',
		}).then((result) => {
			if(result.isConfirmed) {
				window.location.href = "/login";
			}
		});
	}
    
    $(document).ready(function() {
    	
    	//클릭 시 비밀번호 표시/숨기기
        $("#togglePassword").on("click", function() {
            const passwordField = $("#empPswdNew");
            const passwordFieldType = passwordField.attr("type");
            
            if (passwordFieldType === "password") {
                passwordField.attr("type", "text");  //비밀번호 보여주기
                $(this).removeClass("fas fa-eye-slash").addClass("fas fa-eye");
            } else {
                passwordField.attr("type", "password");  //비밀번호 숨기기
                $(this).removeClass("fas fa-eye").addClass("fas fa-eye-slash");
            }
        });
    	
        $("#togglePassword2").on("click", function() {
            const passwordField = $("#empPswdNewConfirm");
            const passwordFieldType = passwordField.attr("type");
            
            if (passwordFieldType === "password") {
                passwordField.attr("type", "text");  //비밀번호 보여주기
                $(this).removeClass("fas fa-eye-slash").addClass("fas fa-eye");
            } else {
                passwordField.attr("type", "password");  //비밀번호 숨기기
                $(this).removeClass("fas fa-eye").addClass("fas fa-eye-slash");
            }
        });
    	
	    // 새 비밀번호 입력 시 유효성 검사
	    $("#empPswdNew").on("input", function() {
	        let empPswdNew = $("#empPswdNew").val();
	        let empPswdNewConfirm = $("#empPswdNewConfirm").val();
	
	        if (!validatePswd(empPswdNew)) {
	            $("#pswdValidateMsg").text("8~16자의 영문 대/소문자, 숫자, 특수문자를 포함해야 합니다.").css("color", "red");
	            $("#confirm").attr("disabled", true); //유효하지 않으면 확인 버튼 비활성화
	        } else {
	            $("#pswdValidateMsg").text(""); //조건이 맞으면 경고 메시지 제거
	            if (empPswdNew === empPswdNewConfirm) {
	                $("#confirm").removeAttr("disabled"); //비밀번호가 일치하고 유효성 검사 통과 시 활성화
	                $("#pswdMismatchMsg").text(""); //비밀번호 일치 메시지 제거
	            } else {
	                $("#confirm").attr("disabled", true); //비밀번호가 일치하지 않으면 비활성화
	                $("#pswdMismatchMsg").text("비밀번호가 일치하지 않습니다.").css("color", "red");
	            }
	        }
	    });
	
	  // 실시간으로 비밀번호 일치 여부 검사
		$("#empPswdNewConfirm").on("input", function() {
		    let empPswdNew = $("#empPswdNew").val();
		    let empPswdNewConfirm = $("#empPswdNewConfirm").val();
			
		    if (empPswdNew !== empPswdNewConfirm) {
		        $("#pswdMismatchMsg").text("비밀번호가 일치하지 않습니다").css("color", "red");
		        $("#confirm").attr("disabled", true); //비밀번호가 일치하지 않으면 비활성화
		    } else {
		        $("#pswdMismatchMsg").text(""); //비밀번호가 일치하면 메시지 제거
		        if (validatePswd(empPswdNew)) {
		            $("#confirm").removeAttr("disabled"); //비밀번호가 유효하고 일치하면 활성화
		        }
		    }
		});
	
	    
	    //취소 버튼 클릭 시 로그인 페이지로 이동
	    $("#cancel").on("click", function() {
	    	location.href = "/cmmn/myPage/myInfo";
	    });
	    
	    //확인 버튼 클릭 시 비밀번호 재설정 완료
	    $("#confirm").on("click", function() {
	    	let empPswdNew = $("#empPswdNew").val();
	    	let empPswdNewConfirm = $("#empPswdNewConfirm").val();
	    	
	    	let empNo = $("input[name='empNo']").val();
			
			console.log(empPswdNew, empPswdNewConfirm);
			
			let data = {
				"empPswdNew" : empPswdNewConfirm,
				"empNo":empNo
			}
	
			console.log(data);
			
			$.ajax({
				url: "/updatePswdAjax",
				contentType: "application/json;charset=utf-8",
				data: JSON.stringify(data),
				type: "post",
				dataType:"json",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success: function(result){
					console.log("result: ", result);
					if(result.empPswd === "ERROR") {
						alert("비밀번호 변경에 실패하였습니다");
					} else {
						success();
					}
				}
			})
	    })
    });
    
</script>

<head>
<meta charset="UTF-8">
<title>비밀번호 재설정</title>
<style>
   @font-face {
    font-family: 'Pretendard-Regular';
    src: url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
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
	    margin: 8px 0;
	    display: inline-block;
	    border-radius: 30px;
	    border: none;
	    background-color: #F3F7FF;
	    color: #6b7280;
	    font-size: 14px;
	    box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.1);
	}
	
	.input-field::placeholder {
	    color: #6b7280; /* 플레이스홀더 색상 */
	}
	
	input:focus {
	outline: 1.5px solid #4E7DF4;
	}
	
	/* 확인 버튼 스타일 */
	.submit-button {
	    width: 100%;
	    background-color: #4E7DF4;
	    color: white;
	    font-size: 14px;
	    font-weight: bold;
	    border: none;
	    border-radius: 30px;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}
	
	.submit-button:hover {
	    background-color: #3A66C9;
	}
	
	/* 취소 버튼 스타일 */
	.cancel-button {
	    width: 100%;
	    background-color: white;
	    color: #6b7280;
	    font-size: 14px;
	    font-weight: bold;
	    border: 2px solid #D1D5DB;
	    border-radius: 30px;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}
	
	.cancel-button:hover {
	    background-color: #f0f2f5;
	}
	
	/* 비활성화된 상태에서의 스타일 */
	#confirm:disabled {
	    background-color: #e0e0e0;
	    color: #9e9e9e;
	    cursor: not-allowed;
	}
	
	#confirm:disabled:hover {
	    background-color: #e0e0e0;
	}
	
	/* 활성화된 상태 */
	#confirm:not(:disabled) {
	    background-color: #4E7DF4;
	    color: white;
	    cursor: pointer;
	}
	
	#confirm:not(:disabled):hover {
	    background-color: #3A66C9;
	}
	
	.text-gray-600 {
       color: #6b7280;
   }
	
	.swal2-icon { /* 아이콘 */ 
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
	
	#togglePassword, #togglePassword2 {
	    font-size: 18px;
	    color: #D3D3D3; /* 회색 */
	}
	
	#togglePassword:hover, #togglePassword2:hover {
	    color: #4E7DF4; /* 호버 시 파란색 */
	}
</style>
</head>
<body>
<div class="flex justify-center items-center h-screen relative">
    <div class="w-[420px] h-[590px] p-12 bg-white rounded-2xl shadow-lg relative z-10 mr-[-3rem]">
        <div class="text-center">
        	<a href="/login">
            <img alt="로고" src="/resources/images/findPswdLogo.png" class="mx-auto mb-6 w-32 h-auto"> <!-- 로고 크기 및 중앙 정렬 -->
            </a>
            <h2 class="text-lg font-bold tracking-tight text-gray-900 sm:text-2xl">비밀번호 재설정</h2>
            <p class="mt-2 text-sm leading-8 text-gray-600">비밀번호 재설정을 위해 새 비밀번호를 입력해 주세요</p>
        </div>
        <form action="${pageContext.request.contextPath}/updatePswd" method="POST" class="mt-8 space-y-6">
            <input type="hidden" name="empNo" value="${param.empNo}"/>
            <div>
                <label for="empPswdNew" class="block text-sm font-semibold leading-6 text-gray-900">새 비밀번호</label>
                <div class="mt-2.5" style="position: relative;">
                   <input type="password" name="empPswdNew" id="empPswdNew" autocomplete="organization" class="input-field">
                   <i class="fas fa-eye-slash" id="togglePassword"
						style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
                </div>
                	<p id="pswdValidateMsg" class="mt-1 text-xs"></p>
            </div>
            <div>
                <label for="empPswdNewConfirm" class="block text-sm font-semibold leading-6 text-gray-900">새 비밀번호 확인</label>
                <div class="mt-2.5" style="position: relative;">
                    <input type="password" name="empPswdNewConfirm" id="empPswdNewConfirm" autocomplete="organization" class="input-field">
                     <i class="fas fa-eye-slash" id="togglePassword2"
						style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
                    <!-- 실시간으로 비밀번호 일치 여부 메시지 -->
                </div>
                    <p id="pswdMismatchMsg" class="mt-1 text-xs"></p>
            </div>
            <div class="mt-10 flex justify-center space-x-4">
                <button type="button" id="cancel" class="cancel-button p-3">취소</button>
                <button type="button" id="confirm" class="submit-button p-3">확인</button>
            </div>
            <sec:csrfInput />
        </form>
    </div>
    <img alt="loginForm" src="/resources/images/loginForm.png" class="w-[450px] shadow-lg" style="border-radius: 16px;">
	</div>
</body>

</html>