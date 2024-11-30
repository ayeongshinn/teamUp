<!-- 공지사항 등록 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<!-- registForm.jsp 공지 등록 폼 :: 신아영 -->
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/alpinejs/alpine@2.x.x/dist/alpine.min.js" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<script src="/resources/adminlte3/dist/js/adminlte.js" aria-hidden="true"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script type="text/javascript">
    // DOM이 로드된 후 실행
    $(document).ready(function () {
        // 버튼에 이벤트 리스너 연결 (JavaScript)
        document.getElementById('confirm').addEventListener('click', confirm);
        document.getElementById('cancel').addEventListener('click', cancel);

        // 파일 선택 시 파일 이름 출력
        $("#uploadFile").on("change", function() {
            const files = $(this)[0].files;
            let fileList = "";
            for (let i = 0; i < files.length; i++) {
                fileList += files[i].name + "<br>";
            }
            $("#fileList").html(fileList); // 파일 이름 출력
        });
    });

    // 등록 확인 모달
    function confirm(e) {
        e.preventDefault();  // 기본 동작 방지
        Swal.fire({
	        title: '업부일지를 등록하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#4E7DF4',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	    }).then((result) => {
			if(result.isConfirmed) {
				$("form").submit(); //폼 제출
			}
		});
    }

    // 취소 확인 모달
    function cancel(e) {
        e.preventDefault();  // 기본 동작 방지
        Swal.fire({
            title: '업무일지를 취소하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#4E7DF4',
            confirmButtonText: '확인',
            cancelButtonText: '취소',
            reverseButtons: true,
        }).then((result) => {
			if(result.isConfirmed) {
				window.location.href = "/taskDiary/list";
			}
		});
    }
</script>

<title></title>
</head>
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
	
	/*기본스타일을 없애고, 버튼모양을 구현*/
	input[type='radio'] {
	  -webkit-appearance: none; /*웹킷 브라우저에서 기본 스타일 제거*/
	  -moz-appearance: none; /*모질라 브라우저에서 기본 스타일 제거*/
	  appearance: none; /*기본 브라우저에서 기본 스타일 제거*/
	  width: 18px;
	  height: 18px;
	  border: 2px solid #4E7DF4; /*체크되지 않았을 때의 테두리 색상*/
	  border-radius: 50%;
	  outline: none; /*focus 시에 나타나는 기본 스타일 제거*/
	  cursor: pointer;
	}
	
	/*체크될 시에, 변화되는 스타일 설정*/
	input[type='radio']:checked {
	  background-color: #4E7DF4; /*체크 시 내부 원으로 표시될 색상*/
	  border: 3px solid white; /*테두리가 아닌, 테두리와 원 사이의 색상*/
	  box-shadow: 0 0 0 1.6px #4E7DF4; /*얘가 테두리가 됨*/
	  /*그림자로 테두리를 직접 만들어야 함 (퍼지는 정도를 0으로 주면 테두리처럼 보입니다.)*/
	  /*그림자가 없으면 그냥 설정한 색상이 꽉 찬 원으로만 나옵니다*/
	}
	
	#category {
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

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<body>
	<div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-14 bg-white border-b border-gray-200">
                   <form name="registForm" id="registForm" action="/taskDiary/registPost" method="POST">
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                    	
                    	<div style="margin-bottom: 10px;">
						    <a id="category" href="/taskDiary/list" class="text-lg font-semibold" style="color:#4E7DF4;">업무 일지</a>
						</div>
                        <div class="mb-4 flex items-center">
						    <label class="text-md text-gray-600 mr-4">제목<span class="text-red-500"> *</span></label>
						    <input type="text" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-4/5 p-2.5 mr-4"
						    		name="diaryTtl" id="diaryTtl" placeholder="제목을 입력해 주세요" required>
						</div>
				
						
						
						
					
					    <div class="mb-8"> 
					        <textarea style="resize: none; overflow-y: auto; height: 400px;" 
					        id="diaryCn" name="diaryCn" class="border-2 border-gray-500 w-full"
					        		  placeholder="내용을 입력해 주세요"></textarea>

					    </div>
					
						
						<!-- 첨부파일 -->
<!-- 						<table class="border-collapse table-auto"> -->
<!-- 						  <tr> -->
<!-- 						    <td class="align-middle whitespace-nowrap" style="padding-right: 15px;"> -->
<!-- 						      첨부파일 -->
<!-- 						    </td> -->
<!-- 						    <td style="padding-right: 5px;"> -->
<!-- 						      <div class="icons flex text-gray-500"> -->
<!-- 						        <label id="select-image"> -->
<!-- 						          <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7" -->
<!-- 						               xmlns="http://www.w3.org/2000/svg" fill="none" -->
<!-- 						               viewBox="0 0 24 24" stroke="currentColor"> -->
<!-- 						            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" -->
<!-- 						                  d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" /> -->
<!-- 						          </svg> -->
<!-- 						        </label> -->
<!-- 						      </div> -->
<!-- 						    </td> -->
<!-- 						    <td style="padding-right: 5px;"> -->
<!-- 						      <div id="fileList" class="text-sm text-gray-500">[파일 이름]</div> -->
<!-- 						    </td> -->
<!-- 						  </tr> -->
<!-- 						</table> -->
						
					    <div class="flex justify-end p-1" style="gap: 10px;">
						    <button type="button" id="cancel" 
						        class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
						        style="background-color: #848484;" 
						        onclick="cancel()">취소</button>
						
						    <button type="submit" id="confirm" 
						        class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
						        style="background-color: #4E7DF4;" 
						        onclick="confirm()">등록</button>
						</div>
    					<sec:csrfInput/>
                    </form>
                </div>
            </div>
        </div>

    <script src="/resources/ckeditor5/ckeditor.js"></script>

    <!-- CKEditor5 적용 코드 -->
    <script>
	    ClassicEditor
	    .create(document.querySelector('#diaryCn'), {
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
