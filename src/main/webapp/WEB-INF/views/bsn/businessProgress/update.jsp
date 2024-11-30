<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<sec:authorize access="isAuthenticated()">
   <sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<!DOCTYPE html>
<html>
<head>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/alpinejs/alpine@2.x.x/dist/alpine.min.js" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

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
   
   	.ck-editor__editable {
    height: 400px !important;  /* 높이를 400px로 고정 */
    overflow-y: auto !important;  /* 세로 스크롤바를 자동으로 생성 */
    resize: none;  /* 사용자가 크기를 조절할 수 없도록 설정 */
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
	
	#category {
		color: #4E7DF4;
	}
	
</style>

<script type="text/javascript">

//진행률 select 요소에 0%부터 100%까지 5% 단위로 옵션을 추가하는 함수
function populateProgressOptions() {
    const select = document.getElementById('bsnProgrs');
    for (let i = 0; i <= 100; i += 5) {
        const option = document.createElement('option');
        option.value = i;
        option.text = i + '%';
        select.appendChild(option);
    }
}
//DOM이 로드되면 옵션을 추가
document.addEventListener('DOMContentLoaded', populateProgressOptions);

$(document).ready(function() {
	
	// CKeditor 처리
	$(".ck-blurred").keydown(function(){
		console.log("str : " + window.editor.getData());
		
		$("#bsnCn").val(window.editor.getData());
	});
	
	$(".ck-blurred").on("focusout",function(){
		$("#bsnCn").val(window.editor.getData());
	});
	
	// 취소 버튼 처리
	$('#cancelBtn').on('click', function() {
		cancelUpdate();
	});
	
	//등록 버튼 클릭 시
	$("#saveBtn").on("click", function() {
		confirm();
	})
	
});

// 취소 버튼 얼럿
function cancelUpdate() {
	
	console.log("Cancel 함수 호출");
	
	Swal.fire({
		title: '영업 진척도 수정을 취소하시겠습니까?',
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#4E7DF4',
		confirmButtonText: '확인',
		cancelButtonText: '취소',
		reverseButtons: true,
	}).then((result) => {
		if(result.isConfirmed) {
			window.location.href = '/businessProgress/list';
		}
	});
}

// 등록 버튼 처리
function confirm() {
	Swal.fire({
		title: '수정을 완료하시겠습니까?',
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#4E7DF4',
		confirmButtonText: '확인',
		cancelButtonText: '취소',
		reverseButtons: true,
	}).then((result) => {
		if(result.isConfirmed) {
			console.log("폼 제출 직전");
			$("form").submit();
		}
	});
}

</script>

</head>
<body>
	<div class="py-24">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-14 bg-white border-b border-gray-200">
                
                <div class="pb-2 mb-3 text-lg flex justify-between items-center">
						<a id="category" href="/businessProgress/list" class="text-lg">영업 진척도 수정</a>
				</div>
                	<!-- 
                	요청URI : /updateNotice
                	요청파라미터 : {ntcTtl=제목,imprtncYn=Y,ntcCn=내용,uploadFile=파일객체}
                	요청방식 : post
                	
                	1. <input type="file"... + spring security
                	  - enctype="multipart/form-data"
                	  - action="요청URI?토큰처"
                	  - method="post"
                	  - <sec:csrfInput />
                	  
                	  param : ntcNo=NOTICE0024
                	 -->
                    <form action="/businessProgress/updatePost" method="POST">
                    	<input type="hidden" name="manageNo" value="${businessProgressVO.manageNo}">
                    	<input type="hidden" name="bsnNm" value="${businessProgressVO.bsnNm}">
                    
                        <div class="lg:grid-cols-4 mb-4 flex items-center">
						    <label class="text-md text-gray-600 mr-3">제목 <code> *</code></label>
		                        <div class="lg:col-span-3">
								    <input type="text" style="width: 825px;"
								    	   class="col-span-3 bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-4/5 p-2.5 mr-4"
								    	   name="bsnTtl" id="bsnTtl" placeholder="제목을 입력해 주세요" required value="${businessProgressVO.bsnTtl}">
								</div>
								<label class="text-md text-gray-600 mr-3">진행률<code> *</code></label>
								<div class="lg:col-span-2" style="width: 11%;">	
									<select id="bsnProgrs" name="bsnProgrs"
											class="col-span-1 bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
											required>
											
									</select>
								</div>
						</div>
					
					    <div class="mb-8"> 
					        <textarea style="resize: none; overflow-y: auto; height: 400px;" id="bsnCn" name="bsnCn" class="border-2 border-gray-500 w-full"
					        		  placeholder="내용을 입력해 주세요">${businessProgressVO.bsnCn}</textarea>

					    </div>
					
					    <div class="flex justify-end p-1" style="gap: 10px;">
					        <button type="button" id="cancelBtn" onclick="cancelUpdate()"
					        		class="bg-[#848484] text-white active:bg-[#848484] font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150">
							    취소
							</button>
					        <button type="button" id="saveBtn"
					        		class="bg-white text-[#848484] active:bg-white font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150">
							    확인
							</button>
    					</div>
    					<sec:csrfInput/>
                    </form>
                </div>
            </div>
        </div>
    </div>

<script src="/resources/ckeditor5/ckeditor.js"></script>

	<!-- CKEditor5 적용 코드 -->
	<script>
	ClassicEditor
	.create(document.querySelector('#bsnCn'), {
	    ckfinder: {
	        uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'
	    },
	    removePlugins: ['AutoGrow']  // 자동 크기 조정 플러그인 비활성화
	})
	.then(editor => {
	    window.editor = editor;
	
	    // 에디터의 편집 영역 고정
	    const editable = editor.ui.view.editable.element;
	    editable.style.height = '40vh';  // 고정된 높이 설정
	    editable.style.overflowY = 'auto';  // 세로 스크롤 가능
	})
	.catch(err => {
	    console.error(err.stack);
	});

</script>

</body>
</html>