<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>


<script type="text/javascript">
function handleProflImg(e) {
    let files = e.target.files; // 선택한 파일들
    let fileArr = Array.prototype.slice.call(files); // 배열로 변환
    let accumStr = "";
    fileArr.forEach(function (f) {
        // 이미지 파일이 아니면 경고
        if (!f.type.match("image.*")) {
            alert("이미지 확장자만 가능합니다.");
            return;
        }
        let reader = new FileReader();
        reader.onload = function (e) {
            // 미리보기 이미지 추가
            accumStr += "<img src='" + e.target.result + "' style='width:20%;border:1px solid #D7DCE1;' />";
            $("#proflImg").html(accumStr); // 미리보기 갱신
        };
        reader.readAsDataURL(f);
    });
}
	   
function handleOffcsImg(e) {
    let files = e.target.files; // 선택한 파일들
    let fileArr = Array.prototype.slice.call(files); // 배열로 변환
    let accumStr = "";
    fileArr.forEach(function (f) {
        // 이미지 파일이 아니면 경고
        if (!f.type.match("image.*")) {
            alert("이미지 확장자만 가능합니다.");
            return;
        }
        let reader = new FileReader();
        reader.onload = function (e) {
            // 미리보기 이미지 추가
            accumStr += "<img src='" + e.target.result + "' style='width:20%;border:1px solid #D7DCE1;' />";
            $("#offcsImg").html(accumStr); // 미리보기 갱신
        };
        reader.readAsDataURL(f);
    });
}
	   
$(function() {
	
	//이미지 미리보기 시작 /////
	$('#proflFile').on('change', function (e) {
        // e.target.files[0]는 선택한 첫 번째 파일 객체
        let fileName = $(this).val().split('\\').pop();
        // 선택한 파일 이름을 label에 설정
        $(this).next('.custom-file-label').html(fileName);
        
        // 직인 파일 미리보기
        handleProflImg(e);  // 미리보기 함수 호출
    });
	
	$('#offcsFile').on('change', function (e) {
        // e.target.files[0]는 선택한 첫 번째 파일 객체
        let fileName = $(this).val().split('\\').pop();
        // 선택한 파일 이름을 label에 설정
        $(this).next('.custom-file-label').html(fileName);
        
        // 직인 파일 미리보기
        handleOffcsImg(e);  // 미리보기 함수 호출
    });
	  
	// 이미지 파일 변경 시 기존 이미지 대체
	$("#modalUploadFile").on("change", function(e) {
	    let files = e.target.files;
	    let fileArr = Array.prototype.slice.call(files);
	    let imgPreview = "";
	
	    fileArr.forEach(function(f) {
	        // 이미지 파일만 허용
	        if (!f.type.match("image.*")) {
	            alert("이미지 파일만 가능합니다.");
	            return;
	        }
	        
	        let reader = new FileReader();
	        reader.onload = function(e) {
	            // 기존 이미지를 새 이미지로 대체
	            imgPreview += "<img src='" + e.target.result + "' style='width:20%;border:1px solid #D7DCE1;' />";
	            $("#divFileSaveLocate").html(""); // 기존 이미지를 제거
	            $("#modalImgPreview").html(imgPreview); // 새로운 이미지로 대체
	        };
	        reader.readAsDataURL(f);
	    });
	});
	
	$("#addr").on("click", function() {
	    new daum.Postcode({
	    	// 다음 창에서 검색이 완료되어 클릭하면 콜백함수에의해
	    	// 결과 데이터(JSON String)가 data객체로 들어온다.
	        oncomplete: function(data) {
	        	// data{"zonecode" : "12345", "address" : "대전 중구", "buildingName" : "123-67"}
	        	$("#roadNmZip").val(data.zonecode);
	        	$("#roadNmAddr").val(data.address);
	        	$("#daddr").val(data.buildingName);
	        	$("#daddr").focus();
	        }
	    }).open();
	});
	
	
	document.getElementById('birth').addEventListener('change', function() {
        const birthValue = this.value;
        
        if (birthValue) {
            formattedDate = birthValue.replace(/-/g, '');
            document.getElementById('empBrdt').value = formattedDate;
        }
    });
	
	document.getElementById('jncmp').addEventListener('change', function() {
        const birthValue = this.value;
        
        if (birthValue) {
            formattedDate = birthValue.replace(/-/g, '');
            document.getElementById('jncmpYmd').value = formattedDate;
        }
    });
	
	if (window.opener && !window.opener.closed) {
	    console.log("부모 창에 접근 가능합니다.");
	} else {
	    console.log("부모 창에 접근할 수 없습니다.");
	}
	
	if (window.opener) {
	    console.log("부모 창 도메인:", window.opener.location.hostname);
	    console.log("부모 창 프로토콜:", window.opener.location.protocol);
	    console.log("부모 창 포트:", window.opener.location.port);
	} else {
	    console.log("부모 창에 접근할 수 없습니다.");
	}

	$("#save").click(function() {
	    var formData = new FormData($("#registForm")[0]);

	    // 프로필 사진 파일이 있을 경우만 추가
	    var proflFile = $("#proflFile")[0].files[0];
	    if (proflFile) {
	        formData.append("proflFile", proflFile);
	    }

	    // 직인 파일이 있을 경우만 추가
	    var offcsFile = $("#offcsFile")[0].files[0];
	    if (offcsFile) {
	        formData.append("offcsFile", offcsFile);
	    }

	    $.ajax({
	        url: "/employee/empRegistPost",  // 서버에 데이터 전송
	        type: "POST",
	        data: formData,
	        processData: false,  // FormData의 경우에는 false로 설정
	        contentType: false,  // FormData의 경우에는 false로 설정
	        success: function(response) {
	            if (window.opener && !window.opener.closed) {
	                window.opener.addEmployeeToTable(response);  // 부모 창의 함수 호출
	                window.close();  // 팝업 창 닫기
	            }
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            console.log("AJAX 에러 발생");
	            console.log("상태:", textStatus);
	            console.log("에러 메시지:", errorThrown);
	            console.log("응답 본문:", jqXHR.responseText);
	            alert("사원 정보 등록 중 오류가 발생했습니다.");
	        }
	    });
	});

});
</script>

<style>
   @font-face {
       font-family: 'Pretendard-Regular';
       src: url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
       font-weight: 100;
       font-style: normal;
   }
   
   body {
       font-family: 'Pretendard-Regular', sans-serif;
   }
   
	.bg-indigo-500 {
		background-color: #4E7DF4;
	}
</style>

<!-- component -->
<!-- This is an example component -->
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 my-8">
	<h2 class="blocks text-lg font-bold" style="color:#4E7DF4">사원 등록</h2>
	<br>
	
	<form name="registForm" id="registForm" action="/employee/registPost" method="post" enctype="multipart/form-data">
		<div class="grid grid-cols-2 gap-6 mb-6 lg:grid-cols-2">
			<div>
				<label for="empNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">사원명<code> *</code></label>
				<input type="text" id="empNm" name="empNm"
					class="border border-gray-300  text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="사원명을 입력해주세요." required>
			</div>
			
			<div>
				<label for="empRrno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">사원 주민등록번호</label>
				<input type="text" id="empRrno" name="empRrno"
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="주민등록번호를 입력해주세요." required>
			</div>
			
			<div>
				<!-- 금일 일자 보다 크면 안됨. 그리고 5살이 입사할 순 없으니까 어느정도 막아둬야 하나..? -->
				<label for="empBrdt" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">사원 생년월일</label>
				<input type="date" id="birth"
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="생년월일 입력해주세요." required>
				<input type="hidden" id="empBrdt" name="empBrdt" value="" />
			</div>
			
			<div>
				<label for="sexdstnCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">성별 <code> *</code></label>
				<div class="grid grid-cols-2">
					<c:forEach var="commonCodeVO" items="${A21List}">
						<div class="flex px-2 py-2">
							<input id="${commonCodeVO.clsfCd}" type="radio" name="sexdstnCd" value="${commonCodeVO.clsfCd}"
								class="h-4 w-4 mx-2 border-gray-300 focus:ring-2 focus:ring-blue-300" aria-labelledby="country-option-1" aria-describedby="country-option-1" checked="">
				            <label for="${commonCodeVO.clsfCd}" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">${commonCodeVO.clsfNm}자</label>
						</div>
					</c:forEach>
				</div>
			</div>
			
			<div>
				<label for="empTelno" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">사원 전화번호</label>
					<input type="tel" id="empTelno" name="empTelno"
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="전화번호를 입력해주세요." required>
			</div>
			
			<div>
				<label for="empEmlAddr" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">사원 이메일 주소</label>
					<input type="text" id="empEmlAddr" name="empEmlAddr"
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="이메일 주소를 입력해주세요." required>
			</div>
		</div>
		
		<div class="grid gap-6 mb-6 lg:grid-cols-2">
			<div class="flex items-center">
				<div>
					<label for="roadNmZip" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">우편 번호 <code> *</code></label>
					<input type="text" id="roadNmZip" name="roadNmZip" readonly
						class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="우편 번호" required>
				</div>

				<button id="addr"
					class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2.5 mt-9 rounded-r-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
					type="button" style="height:42px; margin-left:-3px; min-width:100px;">주소 검색</button>
			</div>
			
			<div>
				<label for="roadNmAddr" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">도로명 주소 <code> *</code></label>
				<input type="text" id="roadNmAddr" name="roadNmAddr" readonly
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="도로명 주소" required>
			</div>
			
			<div>
				<label for="daddr" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">상세 주소 <code> *</code></label>
				<input type="text" id="daddr" name="daddr"
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="상세 주소를 입력해주세요." required>
			</div>
		</div>
		
		<div class="grid grid-cols-2 gap-6 mb-6 lg:grid-cols-2">
			<div>
				<label for="jncmpYmd"
					class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">입사 일자</label>
					<input type="date" id="jncmp"
					class="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
					placeholder="입사 일자를 입력해주세요." required>
					<input type="hidden" id="jncmpYmd" name="jncmpYmd" value="" />
			</div>
			
			<div>
				<label for="jbgdCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">직급 <code> *</code></label>
				<select class="h-11 w-full px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" id="jbgdCd" name="jbgdCd">
					<c:forEach var="commonCodeVO" items="${A18List}">
						<option value="${commonCodeVO.clsfCd}">${commonCodeVO.clsfNm}</option>
					</c:forEach>
				</select>
			</div>
			
			<div>
				<label for="jbttlCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">직책 <code> *</code></label>
				<select class="h-11 w-full px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" id="jbttlCd" name="jbttlCd">
					<c:forEach var="commonCodeVO" items="${A19List}">
						<option value="${commonCodeVO.clsfCd}">${commonCodeVO.clsfNm}</option>
					</c:forEach>
				</select>
			</div>
			
			<div>
				<label for="deptCd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">부서 <code> *</code></label>
				<select class="h-11 w-full px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" id="deptCd" name="deptCd">
					<c:forEach var="commonCodeVO" items="${A17List}">
						<option value="${commonCodeVO.clsfCd}">${commonCodeVO.clsfNm}</option>
					</c:forEach>
				</select>
			</div>
		</div>

		<div class="grid grid-cols-2 gap-6 mb-6 lg:grid-cols-2">
			<div>
				<label for="perDet" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">직인 이미지</label>
				<div class="icons flex text-gray-500 m-2">
	                <label id="select-image">
	                    <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
	                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
	                    </svg>
	                   <input type="file" id="offcsFile" name="offcsFile" multiple hidden />
	                </label>
	                <!-- 파일 이름 출력 영역 -->
	                <div id="fileList" class="text-sm text-gray-500 mt-1"></div>
	            </div>
				<div id="offcsImg"></div>
			</div>

			<div>
				<label for="perDet" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">프로필 사진</label>
				<div class="icons flex text-gray-500 m-2">
	                <label id="select-image">
	                    <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
	                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
	                    </svg>
	                   <input type="file" id="proflFile" name="proflFile" multiple hidden />
	                </label>
	                <!-- 파일 이름 출력 영역 -->
	                <div id="fileList" class="text-sm text-gray-500 mt-1"></div>
	            </div>
				<div id="proflImg"></div>
			</div>
		</div>

		<div style="display: flex; justify-content: flex-end; margin-top: 5px;">
			<button id="base64" type="submit"
			class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-3 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
				>개별 등록</button>
			<button id="save" type="button"
				class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-3 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
				>입력</button>
			<button id="cancel" type="button"
				class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-3 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
				onclick="javascript:window.close();" >닫기</button>
		</div>
		<sec:csrfInput />
	</form>
</div>
