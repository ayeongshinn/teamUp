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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link rel="preconnect" href="https://rsms.me/">
<link rel="stylesheet" href="https://rsms.me/inter/inter.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>

<script type="text/javascript">

//전화번호 날짜 포멧팅
document.addEventListener('DOMContentLoaded', function () {
    const inputField = document.getElementById('jncmpYmd');
    let originalValue = inputField.value;
    
    const empBrdtField = document.getElementById('empBrdt');
    let empBrdtValue = empBrdtField.value;

    // 날짜를 YYYY.MM.DD 형식으로 변환하는 함수
    function formatDateString(dateString) {
        if (dateString && dateString.length === 8) {
            return dateString.replace(/(\d{4})(\d{2})(\d{2})/, '$1.$2.$3');
        }
        return dateString;
    }

    // 변환된 값이 없으면 그대로 둡니다
    if (originalValue && originalValue.length === 8) {
        inputField.value = formatDateString(originalValue);
    }
    
    if (empBrdtValue && empBrdtValue.length === 8) {
        empBrdtField.value = formatDateString(empBrdtValue);
    }
    

    const empTelnoField = document.getElementById('empTelno');
    let empTelnoValue = empTelnoField.value;

    // 전화번호 포매팅 함수
    function formatPhoneNumber(number) {
        // 숫자가 아닌 문자는 모두 제거
        number = number.replace(/[^\d]/g, '');

        if (number.length === 11) {
            // 11자리 전화번호 포맷팅 (휴대폰 번호)
            return number.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        } else if (number.length === 10) {
            // 10자리 전화번호 포맷팅 (일반 전화번호)
            return number.replace(/(\d{2,3})(\d{3,4})(\d{4})/, '$1-$2-$3');
        } else {
            return number; // 포매팅이 불가능할 경우 원래 값을 반환
        }
    }

    // 변환된 값이 없으면 그대로 둡니다
    if (empTelnoValue) {
        empTelnoField.value = formatPhoneNumber(empTelnoValue);
    }
});


document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('selectFrofil').addEventListener('click', openTextFile);
});

function openTextFile() {
	console.log("프사변경파일열기");
    var input = document.createElement("input");
    
    input.type = "file";
    input.accept = "image/*";
    input.id = "uploadInput";

    input.click();
    
    input.onchange = function (event) {
        processFile(event.target.files[0]);
    };
}

function processFile(file){
	 var reader = new FileReader();

	    // 파일을 다 읽었을 때 실행될 함수 설정
	    reader.onload = function () {
	        var base64String  = reader.result;  // 파일의 Base64 인코딩된 데이터
	        
	        //이미지 미리보기 처리
	        $(".img-circle").attr("src",base64String);
	        
	        var proflPhoto = base64String.replace(/^data:image\/jpeg;base64,/, "");
	        
	        console.log("proflPhoto: " + proflPhoto);  // 파일 데이터 출력
	        let empNo='${empVO.empNo}'
	        let data = {
	                "proflPhoto": proflPhoto,
	                "empNo": empNo
	            };
	            
	            //data:image/jpeg;base64,/9j/4AAQSkZJR
	            console.log("base64String : ", base64String);
	            //{empNo:240003,proflPhoto:/9j/4AAQSkZJRgABAQAAAQA}						 
	            console.log("data : ", data);

	            $.ajax({
	                url: "/cmmn/myPage/upDateFrofl",
	                contentType: "application/json;charset=utf-8",
	                data: JSON.stringify(data),
	                type: "post",
	                dataType: "json",
	                beforeSend: function(xhr) {
	                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	                },
	                success: function(result) {
	             	  
	                    console.log("result : ", result);
	                    
                        Swal.fire({
                           title: '프로필 사진 변경을 완료하였습니다.',
                           icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
                           showCancelButton: false, /* 필요 없으면 지워도 됨, 없는 게 기본 */
                           confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
                           confirmButtonText: '확인',
                        }).then((result) => {
                      	  window.close();
                        });
	                     
						
	                   
	                },
	                error: function(xhr, status, error) {
	                    console.error("AJAX Error:", status, error); // 에러 처리
	                }
	            });

	    };

	    // 파일 읽기 시작 (이 부분은 비동기적으로 실행됨)
	    reader.readAsDataURL(file);
}


$(document).on('click', '#newPass', function(){
	
	$('body').css('overflow', 'hidden'); // 페이지 스크롤 비활성화
	$('#detailModal').css('display', 'block');

});


//Modal 닫기 버튼
$(document).on('click', '#closeModal', function() {
    $('#detailModal').css('display', 'none');  // Modal을 닫음
});

$(function() {
	$("#update").click(function(event) {
		$("#updateBtn").css("display", "none");
		$("#updatePostBtn").css("display", "block");
		
		 let currentValue = $("#empTelno").val();
		 let newValue = currentValue.replace(/-/g, '');
		 $("#empTelno").val(newValue);
		 
		$("#empTelno").removeAttr('readonly');
        
        $("#empEmlAddr").removeAttr('readonly');
        
        $("#daddr").removeAttr('readonly');
        $("#addrSearch").css("display", "block");
        $("#empIntrcnText").css("display", "none");
        $("#empIntrcn").css("display", "block");
        $("#exmTelno").css("display", "block");
        $("#exmEmail").css("display", "block");
        
        $("#empEmlAddr").css("background-color", "white");
        $("#empTelno").css("background-color", "white");
        $("#daddr").css("background-color", "white");
        $("#roadNmZip").css("background-color", "white");
        $("#roadNmAddr").css("background-color", "white");
		
	});
	
	$("#updatePost").on("click", function(e){
		// 기본 submit 동작 막기
	    e.preventDefault(); 
		
		successInfoUpdate();
	});
	
	
function successInfoUpdate() {
	Swal.fire({
		title: '정보 수정이 완료되었습니다.',
		icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
		confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
		confirmButtonText: '확인',
	
	}).then((result) => {
		if (result.isConfirmed) {  // 확인 버튼 클릭 시
            // 폼 전송 실행
            $("#updatePost").closest("form").submit();
        }
	});
};
	
	$(document).on('click', '.addrSearch', function() {
		 var form = $('#updateForm');
		 
        new daum.Postcode({
            oncomplete: function(data) {
                console.log("주소 데이터:", data);
                // 고객 주소 처리
                document.getElementById('daddr').value = '';
                form.find('[name="roadNmZip"]').val(data.zonecode);
                form.find('[name="roadNmAddr"]').val(data.address);
                form.find('[name="daddr"]').val(data.buildingName).focus();
             
            }
        }).open();
    });


});


function validatePswd(password) {
    let pswdRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,16}$/;
    return pswdRegex.test(password);
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
					 $('#detailModal').css('display', 'none'); 
					alert("비밀번호 변경에 실패하였습니다");
				} else {
					 $('#detailModal').css('display', 'none'); 
					success();
				}
			}
		})
    })
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
	.listMoveBtn {
		background-color: white;
		color: black;
		padding: 0px 25px;
		height: 56px;
		border-bottom: 1px solid #dee2e6;
		box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
	}
     
	.swal2-icon { /* 아이콘 */ 
		font-size: 8px !important;
		width: 40px !important;
		height: 40px !important;
	}

	.swal2-confirm, .swal2-cancel {
		font-size: 14px; /* 텍스트 크기 조정 */
		width: 75px;
		height: 35px;
		padding: 0px;
	}
	
	.swal2-styled.swal2-cancel {
	    font-size: 14px;
	    background-color: #f8f9fa;
	    color: black;
	    border: 1px solid #D9D9D9;
	}
	
	.swal2-styled.swal2-confirm {
	    font-size: 14px;
	}
	
	.swal2-title { /* 타이틀 텍스트 사이즈 */
		font-size: 18px !important;
		padding-top: 1.5em;
    	padding-bottom: 0.5em;
	}
	
	.swal2-container.swal2-center>.swal2-popup {
		padding-top: 30px;
		width: 450px;
	}
	
	.swal2-input {
	    font-size: 15px;
	    height: 2em;
	    padding-top: 18px;
	    padding-bottom: 18px;
	    width: 270px; /* 원하는 너비로 설정 */
	    margin: 0 auto; /* 가운데 정렬 */
	    display: block; /* 인풋 필드를 블록 요소로 만들어서 margin이 적용되도록 */
	    text-align: center;
	    margin-top: 20px;
    	margin-bottom: 5px;
	}
	
	.swal2-input:focus {
		border : 1px solid #4E7DF4;
	}
	
	.swal2-input::placeholder {
	    color: #7a7a7a; /* 어둡게 설정 */
	    font-weight: 100; /* 얇게 설정 */
	}

	.modal {
	    display: 30%;
	    justify-content: center; /* 수평 중앙 정렬 */
	    align-items: center;     /* 수직 중앙 정렬 */
	    position: fixed;
	    z-index: 9999;
	    inset: 0;
	    overflow-y: auto;
	    min-height: 80vh; /* 화면 높이만큼 중앙 정렬 */
	    background-color: rgba(0, 0, 0, 0.5); /* 회색 반투명 배경 유지 */
	}
	
	.modal-content {
	    position: relative;
	    background-color: white;
	    padding: 30px;
	    padding-top: 40px;
	    border-radius: 10px;
	    max-width: 950px; /* 모달의 최대 너비 설정 */
	    width: 25%;      /* 화면 크기에 맞게 조정 */
	    margin: auto;     /* 중앙으로 정렬 */
	    margin-top: 20%; /* 오른쪽으로 50px 만큼 이동 */
	    border: none;
	}
	
	.input-field {
	    width: 100%;
	    padding: 12px 20px;
	    margin: 8px 0;
	    border-radius: 10px;
	    display: inline-block;
	    border: none;
	    font-size: 14px;
	    
	}
	
	.input-field::placeholder {
	    color: #6b7280; /* 플레이스홀더 색상 */
	}
	
	input:focus {
	outline: 1.5px solid #4E7DF4;
	}


	.submit-button {
	    
	    background-color: #4E7DF4;
	    color: white;
	    font-size: 14px;
	    font-weight: bold;
	    border: none;
	    width:100px;
	    border-radius: 10px;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}
	
	.submit-button:hover {
	    background-color: #3A66C9;
	}
	
	
	#togglePassword, #togglePassword2 {
	    font-size: 18px;
	    color: #D3D3D3; /* 회색 */
	}
	
	#togglePassword:hover, #togglePassword2:hover {
	    color: #4E7DF4; /* 호버 시 파란색 */
	}
	
	.form-group {
		margin-bottom: 1.5rem;
	}
</style>

</head>
<body>
<div class="py-3">
	<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
	    <div class="w-full flex justify-between items-center mt-1 pl-3 mb-4">
	        <div style="margin-top: 30px; margin-bottom: 10px;">
	            <h3 class="text-lg font-semibold text-slate-800">
	            	<a href="/cmmn/myPage/myInfo">마이페이지</a>
	            </h3>
	            <p class="text-slate-500">나의 정보를 확인하고 수정하세요</p>
	        </div>
		</div>
         <div class="flex justify-between">
		        <div class="flex justify-start items-end"> 
			        <button style="border-radius: 5px 5px 0px 0px; border-top: 6px solid #4E7DF4; transform: scale(1.01);" onclick="location.href='/cmmn/myPage/myInfo'" class="listMoveBtn " type="button">
							<p>&ensp;나의 정보</p>
					</button>
<%-- 					<button style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/showAttend?empNo=${employeeVO.empNo}'" class="listMoveBtn" type="button"> --%>
<!-- 							<p>&ensp;근태조회</p> -->
<!-- 					</button>	 -->
					
					<button  style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/myVacation?empNo=${employeeVO.empNo}'" class="listMoveBtn" type="button">
							<p>&ensp;휴가 관리</p>
					</button>
						
					<button style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/myDoc?empNo=${employeeVO.empNo}'" class="listMoveBtn" type="button">
							<p>&ensp;내 서류</p>
					</button>
				</div>
		</div>		
		<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border" style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);">
			<div class="card-body table-responsive p-0 align-items-center mt-10 mb-20" style="margin-bottom: 2.5rem;">
				<form id="updateForm" action="/cmmn/myPage/infoUpdatePost?${_csrf.parameterName}=${_csrf.token}"
						method="post">
                <div class="flex mb-10 ml-8 mr-11" style="position: relative;">
                        <div style="position: relative; display: inline-block; margin-right: 10px;">
							<img src="data:image/png;base64,${employeeVO.proflPhoto}" class="img-circle" style="width: 80px; height: 80px; display: inline-block; margin: 20px;">
                        	<input value="${employeeVO.proflPhoto}" name="proflPhoto" id="proflPhoto" hidden/>
                        	<div id="selectFrofil" style="position: absolute; bottom: 10px; right: 10px; margin-bottom: 6px;">
                        		<i class="fa-solid fa-camera" style="color: #4E7DF4; cursor: pointer;"></i>
                        	</div>
						</div>
                        <div>
                            <div class="flex items-center mb-2 mt-3">
                                <p id="modalEmpName" class="font-bold text-lg">${employeeVO.empNm}</p>
                                <p id="modalEmpNo" class="text-gray-700 font-thin text-sm ml-2">(${employeeVO.empNo})</p>
                                <input value="${employeeVO.empNo}" name="empNo" hidden/>
                            </div>
							<input type="text"  value="${employeeVO.empIntrcn}" id="empIntrcn" name="empIntrcn" 
                            	class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 mb-2" style="display: none;"/>
                        
                            	<p id="empIntrcnText" style="font-size: 16px; margin-bottom: 5px; font-weight: bold;">${employeeVO.empIntrcn}</p>
                            
                            <p id="modalDeptName" class="text-gray-700 font-thin text-sm" style="font-weight: bold;">
                          	
                            <c:if test="${employeeVO.deptCd=='A17-001'}">경영진 / </c:if>
			              	<c:if test="${employeeVO.deptCd=='A17-002'}">기획부서 / </c:if>
			              	<c:if test="${employeeVO.deptCd=='A17-003'}">관리부서 / </c:if>
			              	<c:if test="${employeeVO.deptCd=='A17-004'}">영업부서 / </c:if>
			              	<c:if test="${employeeVO.deptCd=='A17-005'}">인사부서 / </c:if>
			              	
			              	<c:if test="${employeeVO.jbgdCd=='A18-001'}">사원</c:if>
			              	<c:if test="${employeeVO.jbgdCd=='A18-002'}">대리</c:if>
			              	<c:if test="${employeeVO.jbgdCd=='A18-003'}">차장</c:if>
			              	<c:if test="${employeeVO.jbgdCd=='A18-004'}">부장</c:if>
			              	<c:if test="${employeeVO.jbgdCd=='A18-005'}">이사</c:if>
			              	<c:if test="${employeeVO.jbgdCd=='A18-006'}">사장</c:if>
                            </p>
                        </div>
                        
                        <div class="flex" style=" position: absolute; bottom: 0; right: 0; ">
                        	
	                        <div id="updateBtn"  class="flex items-center ml-5 mb-2 mt-5" >
								<button type="button" class="mr-2 text-gray-900 border border-gray-300" id="newPass" style="background-color: white ; padding: 6px 15px; border-radius: 5px; cursor: pointer; ">비밀번호 변경</button>	                        
	                        	<button type="button" id="update" style="background-color: #4E7DF4 ;color:white; border: none; padding: 6px 15px; border-radius: 5px; cursor: pointer;">내 정보 수정</button>
	                        </div>
	                        
	                        <div id="updatePostBtn"  class="flex items-center ml-5 mb-2 mt-5"  style="display: none; ">
		                        
	                        	<button type="button" class=" text-gray-900 border border-gray-300" id="updateDel" onclick="location.href='/cmmn/myPage/myInfo'" style="background-color: white ; padding: 6px 15px; border-radius: 5px; cursor: pointer; margin-right: 5px;">취소</button>
	                        
	                        	<button type="submit" id="updatePost" style="background-color: #848484 ;color:white; border: none; padding: 6px 15px; border-radius: 5px; cursor: pointer;">확인</button>
		                        
	                        </div>
	                        
                        </div>
                  </div>
                    
                   
                   <div class="flex mb-3 ml-8 mr-8">
                    <div class="mr-3 ml-3" style="width: 50%;">
                        <div class="form-group align-items-center">
                            <label class="col-form-label col-4"><strong>입사 일자</strong></label>
                            <input type="text"  value="${employeeVO.jncmpYmd}" id="jncmpYmd" name="jncmpYmd" readonly
                            	class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"/>
                        </div>

                        <div class="form-group align-items-center">
                            <label class="col-form-label col-6"><strong>퇴사 여부 (퇴사 일자)</strong></label>
                           	<c:if test="${employeeVO.rsgntnYmd==null}">
                           		<input type="text"  value="재직" id="rsgntnYmdNull" name="rsgntnYmd" readonly
                           			class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"/>	
                           	</c:if>	
                           	<c:if test="${employeeVO.rsgntnYmd!=null}">
                           		<input type="text"  value="${employeeVO.rsgntnYmd}" id="rsgntnYmd" name="rsgntnYmd" readonly
                           			class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"/>
                           	</c:if>	
                        </div>

                        <div class="form-group align-items-center">
                            <label class="col-form-label col-4"><strong>생년월일</strong></label>
                            <input type="text"  value="${employeeVO.empBrdt}" id="empBrdt" name="empBrdt" readonly
                           			class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"/>
                           	
                        </div>

                        <div class="form-group align-items-center">
                            <label class="flex col-form-label col-5"><strong>전화번호 </strong><p id="exmTelno" style="font-size:14px;color: red; display: none;">&nbsp;&nbsp;[번호만 입력해주세요]</p> </label>
                            <input type="text"  value="${employeeVO.empTelno}" id="empTelno" name="empTelno" readonly
                           			class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"/>
							 
                        </div>

                    </div>
					<div style="width: 50%;" class="mr-3 ml-3" >		
                        <div class="form-group align-items-center">
                            <label class="flex col-form-label col-5"><strong>이메일 주소</strong><p id="exmEmail" style="font-size:14px;color: red; display: none;">&nbsp;&nbsp;[xxxx@xxxxx.xxx]</p> </label>
                            <input type="text"  value="${employeeVO.empEmlAddr}" id="empEmlAddr" name="empEmlAddr" readonly
                           			class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"/>
							 
                        </div>
						<div class="form-group align-items-center">
						    <label class="col-form-label col-4"><strong>우편번호</strong></label>
						    <div class="relative">
						        <input type="text" id="roadNmZip" name="roadNmZip" value="${employeeVO.roadNmZip}" readonly 
						               class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 pr-24">
						        <button type="button" id="addrSearch" 
						                class="addrSearch absolute right-[1px] top-[1px] bottom-[1px] bg-[#848484] text-white active:bg-[#848484] font-bold uppercase text-sm px-4 rounded-r-md outline-none focus:outline-none transition-all duration-150"
						                style="background-color: rgb(132, 132, 132); color: white; visibility: visible; display: none;">
						            주소 검색
						        </button>
						    </div>
						</div>
						
                        <div class="form-group align-items-center">    
                            <label class="col-form-label col-4"><strong>도로명주소</strong></label>
                            <input type="text" id="roadNmAddr" name="roadNmAddr"  value="${employeeVO.roadNmAddr}" readonly
									class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"/>
                        </div>
                        <div class="form-group align-items-center">    	
                            
                            <label class="col-form-label col-4"><strong>상세주소</strong></label>
                            <input type="text" id="daddr" name="daddr"  value="${employeeVO.daddr}" readonly
									class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"/>
                            	
                        </div>
                    </div>
                </div>
                </form>
			</div>
		</div>
	</div>
</div>	
	
</body>
<div id="detailModal" class="modal" style="display: none;">
    	<div class="modal-content modal-content-top">
    		<div id="modalHeader">
				<span id="closeModal"
					  class="close text-right cursor-pointer text-m font-bold">
					 ✕
			    </span>
				<h2 class="block text-rg font-semibold leading-6 text-gray-900" style="color: #4E7DF4; font-size: 20px;">비밀번호 변경</h2>
			</div>
			<div id="modalBody">
				<!-- 여기 아래에 input 태그 추가 -->
				<form action="${pageContext.request.contextPath}/updatePswd" method="POST" class="mt-8 space-y-6">
		            <input type="hidden" name="empNo" value="${param.empNo}"/>
		            <div>
		                <label for="empPswdNew" class="block text-sm font-semibold leading-6 text-gray-900" style="margin: 0px;">새 비밀번호 입력</label>
		                <div style="position: relative; margin-bottom: 10px;">
		                   <input type="password" name="empPswdNew" id="empPswdNew" autocomplete="organization" class="bg-gray-50 input-field" style="border: 1px solid #dee2e6">
		                   <i class="fas fa-eye-slash" id="togglePassword"
								style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
		                </div>
		                	<p id="pswdValidateMsg" class="mt-1 text-xs"></p>
		            </div>
		            <div style="margin: 0px;">
		                <label for="empPswdNewConfirm" class="block text-sm font-semibold leading-6 text-gray-900" style="margin: 0px;">새 비밀번호 확인</label>
		                <div style="position: relative;">
		                    <input type="password" name="empPswdNewConfirm" id="empPswdNewConfirm" autocomplete="organization" class="bg-gray-50 input-field" style="border: 1px solid #dee2e6">
		                     <i class="fas fa-eye-slash" id="togglePassword2"
								style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
		                    <!-- 실시간으로 비밀번호 일치 여부 메시지 -->
		                </div>
		                    <p id="pswdMismatchMsg" class="mt-1 text-xs"></p>
		            </div>
		            <div class="mt-15 flex justify-center space-x-4">
		                <button type="button" id="confirm" class="submit-button p-2">확인</button>
		            </div>
		            <sec:csrfInput />
		        </form>
			</div>
		</div>
	</div>
</html>

