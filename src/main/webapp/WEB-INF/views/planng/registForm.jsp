<!-- 공지사항 등록 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/alpinejs/alpine@2.x.x/dist/alpine.min.js" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script type="text/javascript">

	function cancel() {
		Swal.fire({
			title: '공지사항 작성을 취소하시겠습니까?',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#4E7DF4',
			confirmButtonText: '확인',
			cancelButtonText: '취소',
			reverseButtons: true,
		}).then((result) => {
			if(result.isConfirmed) {
				window.location.href = "/noticeListN";
			}
		});
	}
	
	function confirm() {
		Swal.fire({
			title: '공지사항을 등록하시겠습니까?',
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
	
	//파일 삭제 함수
	function removeFile(fileId) {
	 const input = $("#uploadFile")[0];
	    const dt = new DataTransfer();
	    
	    //기존 파일 중 삭제한 파일 제외
	    for(let i = 0; i < input.files.length; i++) {
	        if(i != fileId) {
	            dt.items.add(input.files[i]);
	        }
	    }
	    
	    //삭제 후의 파일 목록으로 input 값 설정
	    input.files = dt.files;
	    
	    //화면에서 해당 파일 아이템 삭제
	    $("#file-" + fileId).remove();
	}
	
	$(document).ready(function () {
		
		//파일 선택 시 이름 출력, 선택 삭제
		$("#uploadFile").on("change", function() {
			
	        const files = $(this)[0].files;
	        let fileList = "";
	        for(let i = 0; i < files.length; i++) {
	            fileList += '<div class="file-item" id="file-' + i + '">' +
	                        files[i].name +
	                        ' <button type="button" class="remove-file" data-file-id="' + i + '">×</button>' +
	                        '</div>';
	        }
	        $("#fileList").html(fileList);
	        
	        //삭제 버튼 클릭 이벤트
	        $(".remove-file").on("click", function() {
	            const fileId = $(this).data("file-id");
	            removeFile(fileId);
	        });
	    });
		
		//CKeditor 처리
		$(".ck-blurred").keydown(function(){
			console.log("str : " + window.editor.getData());
			
			$("#ntcCn").val(window.editor.getData());
		});
		
		$(".ck-blurred").on("focusout",function(){
			$("#ntcCn").val(window.editor.getData());
		});
		
		//취소 버튼 클릭 시 확인 후 이전 페이지로
		$("#cancel").on("click", function() {
			cancel();
		})
		
		//등록 버튼 클릭 시
		$("#confirm").on("click", function() {
			confirm();
		})
	})
	
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
<body>
	<div class="py-10">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-14 bg-white border-b border-gray-200">
                	<!-- 
                	요청URI : /registNotice
                	요청파라미터 : {ntcTtl=제목,imprtncYn=Y,ntcCn=내용,uploadFile=파일객체}
                	요청방식 : post
                	 -->
                    <form action="/registNotice?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
                    <div class="mr-4 mb-3">
                        <a href="/noticeListN" class="text-lg text-gray-600 font-semibold" style="color:#4E7DF4;">공지사항 관리</a>
                    </div>    
                        <div class="mb-4 flex items-center">
						    <label class="text-md text-gray-600 mr-4">제목<span class="text-red-500"> *</span></label>
						    <input type="text" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-4/5 p-2.5 mr-4"
						    		name="ntcTtl" id="ntcTtl" placeholder="제목을 입력해 주세요" required>
						    
						    <div class="flex items-center">
						        <input type="radio" name="imprtncYn" value="N" id="normal" checked>
						        <label for="normal" class="text-md font-medium text-gray-900 ml-2 mr-3 block mb-0">일반</label>

						        <input type="radio" name="imprtncYn" value="Y" id="important">
						        <label for="important" class="text-md font-medium text-gray-900 ml-2 block mb-0">중요</label>
						    </div>
						</div>
					
					    <div class="mb-8"> 
					        <textarea style="resize: none; overflow-y: auto; height: 400px;" id="ntcCn" name="ntcCn" class="border-2 border-gray-500 w-full"
					        		  placeholder="내용을 입력해 주세요"></textarea>

					    </div>
					
						<div class="mb-4 flex items-center">
							<label class="text-md text-gray-600 mr-4">첨부파일</label>
							<!-- 첨부파일 아이콘 -->
							 <div class="icons flex text-gray-500 m-2">
				                <label id="select-image">
				                    <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
				                    </svg>
				                   <input type="file" id="uploadFile" name="uploadFile" multiple hidden />
				                </label>
				                <!-- 파일 이름 출력 영역 -->
				                <div id="fileList" class="text-sm text-gray-500 mt-2">

				                </div>
				            </div>
				            <!-- 이미지 첨부 시 미리보기 영역 -->
				            <div id="pImg"></div>
						</div>
					    <div class="flex justify-end p-1" style="gap: 10px;">
					        <button type="button" id="cancel" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							    style="background-color: #848484;" type="button">
							    취소
							</button>
					        <button type="button" id="confirm" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							    style="background-color: #4E7DF4;">
							    등록
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
	    .create(document.querySelector('#ntcCn'), {
	        ckfinder: {
	            uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'
	        },
	        removePlugins: ['AutoGrow']  //자동 크기 조정 플러그인 비활성화
	    })
	    .then(editor => {
	        window.editor = editor;
	
	        // 에디터의 편집 영역 고정
	        const editable = editor.ui.view.editable.element;
	        editable.style.height = '40vh';  //고정된 높이 설정
	        editable.style.overflowY = 'auto';  //세로 스크롤 가능
	    })
	    .catch(err => {
	        console.error(err.stack);
	    });

    </script>

</body>
</html>
