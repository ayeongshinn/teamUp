<!-- findPswd.jsp 신아영 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">

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
				window.location.href = "login";
			}
		});
	}
	
	$(function() {
		
		$("#empRrno1").on("input", function() {
	        if ($("#empRrno1").val().length === 6) {
	            $("#empRrno2").focus();  // 포커스 이동
	        }
	    });
		
		//취소 버튼 클릭 시 로그인 페이지로 이동
		$("#cancel").on("click", function() {
			cancel();
		})
		
		//확인 버튼 클릭 시
		$("#confirm").on("click", function() {
			let empNo = $("#empNo").val();
			let empRrno1 = $("#empRrno1").val();
			let empRrno2 = $("#empRrno2").val();
			let empRrno = empRrno1 + empRrno2;
			
			console.log(empNo, empRrno);
			
			let data = {
				"empNo": empNo,
				"empRrno" : empRrno
			}

			console.log(data);
			
			$.ajax({
				url: "/findPswdAjax",
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
						Swal.fire({
							title: '입력하신 정보와 일치하는 사원이 없습니다.',
							icon: 'warning',
							confirmButtonColor: '#4E7DF4',
							confirmButtonText: '확인',
							reverseButtons: true,
						}).then((result) => {
							if(result.isConfirmed) {
								$("#empNo").val("");
								$("#empRrno1").val("");
								$("#empRrno2").val("");
								$("#empNo").focus();
							}
						});
					} else {
						window.location.href = "/updatePswd?empNo=" + result.empNo;
					}
					
				}
			})
		})
	})
</script>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
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
       background-color: #F3F7FF; /* 밝은 파란색 배경 */
       color: #6b7280; /* 텍스트 색상 */
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
	    border: 2px solid #4E7DF4;
	    border-radius: 30px;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}
   
   /* 취소 버튼 스타일 */
	.cancel-button {
	    width: 100%;
	    background-color: white; /* 기존 색상 유지 */
	    color: #6b7280; /* 글씨 색상 */
	    font-size: 14px;
	    font-weight: bold;
	    border: 2px solid #D1D5DB; /* 테두리 추가 */
	    border-radius: 30px; /* 둥근 모양 추가 */
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}

	.cancel-button:hover {
	    background-color: #f0f2f5; /* 호버 시 밝은 색상 */
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
</style>

</head>
<body>
<div class="flex justify-center items-center h-screen relative">
    <div class="w-[420px] h-[590px] p-12 bg-white rounded-2xl shadow-lg relative z-10 mr-[-3rem]">
  <div class="text-center">
  <a href="/login">
    <img alt="로고" src="/resources/images/findPswdLogo.png" class="mx-auto mb-6 w-32 h-auto"> <!-- 로고 크기 및 중앙 정렬 -->
  </a>
    <h2 class="text-lg font-bold tracking-tight text-gray-900 sm:text-2xl">비밀번호 찾기</h2>
    <p class="mt-2 text-sm leading-8 text-gray-600">비밀번호 찾기를 위해 정보를 입력해 주세요</p>
  </div>
  <form id="findPswdForm" method="POST" class="mt-8 space-y-6">
    <!-- 사원번호 필드 -->
    <div>
      <label for="empNo" class="block text-sm font-semibold leading-6 text-gray-900">사원번호</label>
      <div class="mt-2.5">
        <input type="text" name="empNo" id="empNo" autocomplete="organization" class="input-field">
      </div>
    </div>
    <!-- 주민등록번호 필드 -->
    <div>
      <label for="empRrno" class="block text-sm font-semibold leading-6 text-gray-900">주민등록번호</label>
      <div class="mt-2.5 grid grid-cols-2 gap-x-4">
       <input type="text" name="empRrno1" id="empRrno1" maxlength="6" placeholder="앞자리" class="input-field">
<input type="password" name="empRrno2" id="empRrno2" maxlength="7" placeholder="뒷자리" class="input-field">
      </div>
    </div>
    <div class="mt-10 flex justify-center space-x-4">
        <button type="button" id="cancel" class="cancel-button p-3">취소</button>
        <button type="button" id="confirm" class="submit-button p-3">확인</button>
    </div>
  </form>
</div>
<img alt="loginForm" src="/resources/images/loginForm.png" class="w-[450px] shadow-lg" style="border-radius: 16px;">
	</div>
</body>
</html>