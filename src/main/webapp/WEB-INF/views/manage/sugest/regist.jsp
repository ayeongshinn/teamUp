<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>

<html>
<head>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<script type="text/javascript">
	$(function() {
			$(".ck-blurred").keydown(function(){
				//window.editor : CKEditor 객체
				console.log("str : " + window.editor.getData());

				$("#bbsCn").val(window.editor.getData());
			});
			//CKEditor로부터 커서이동 또는 마우스 이동 시 실행
			$(".ck-blurred").on("focusout",function(){
				$("#bbsCn").val(window.editor.getData());
			});

			
			$("#uploadFile").on("change", function() {
				const files = $(this)[0].files;
				let fileList = "";
				for (let i = 0; i < files.length; i++) {
					fileList += files[i].name + "<br>";
				}
				$("#fileList").html(fileList); // 파일 이름을 표시할 영역에 출력
			});
			
			$("#cancel").on("click", function() {
			let result = confirm("건의사항작성을 취소하시겠습니까?");
			if(result) location.href = "/manage/sugest/list";
			});
	});
</script>

</head>

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

.ck-editor__editable {
	height: 400px !important; /* 높이를 400px로 고정 */
	overflow-y: auto !important; /* 세로 스크롤바를 자동으로 생성 */
	resize: none; /* 사용자가 크기를 조절할 수 없도록 설정 */
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
</style>
<body>

	<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal.employeeVO" var="empVO" />
	</sec:authorize>


	<div class="py-14">
		<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
			<div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
				<div class="p-6 bg-white border-b border-gray-200">

					<!-- 
	요청URI : /sugest/registPost
	요청파라미터 : {sugestClsfCd=,bbsTtl=,empNo=,bbsCn=,uploadFile=파일객체}
	요청방식 : post
	 -->
					<form:form id="frm" modelAttribute="boardVO"
						action="/manage/sugest/registPost?${_csrf.parameterName}=${_csrf.token}"
						method="post" enctype="multipart/form-data">
						<div class="mb-4 flex items-center">

							<label class="text-md text-gray-600 mr-4">제목<span
								class="text-red-500"> *</span></label> <input type="text"
								class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-4/5 p-2.5 mr-4"
								id="bbsTtl" name="bbsTtl" placeholder="제목을 입력해주세요" required>

							<div class="form-group">
								<label>건의사항 분류</label> <select id="sugestClsfCd"
									name="sugestClsfCd" class="form-control" required>
									<option value="" selected disabled>선택해주세요</option>
									<option value="A25-001">비품</option>
									<option value="A25-002">사내 서비스</option>
									<option value="A25-003">기타</option>
								</select>
							</div>


						</div>
						<div class="mb-8">
							<input type="text"
								class="form-control" id="empNo" name="empNo"
								value="${empVO.empNo}" hidden /> 
							<label for="bbsCn">내용</label>
							<textarea style="resize: none; overflow-y: auto; height: 400px;"
								class="border-2 border-gray-500 w-full" id="bbsCn" name="bbsCn"
								placeholder="내용을 입력해주세요"> </textarea>
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
				                <div id="fileList" class="text-sm text-gray-500 mt-2"></div>
				            </div>
				            <!-- 이미지 첨부 시 미리보기 영역 -->
				            <div id="pImg"></div>
						</div>
						<div class="flex justify-end p-1" style="gap: 10px;">
							<button type="button" id="cancel"
								class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								style="background-color: #848484; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);"
								type="button">취소</button>
							<button type="submit" id="btnRegistPost"
								class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								style="background-color: #4E7DF4; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
								등록</button>
						</div>
						<sec:csrfInput />
					</form:form>
				</div>
			</div>
		</div>
	</div>

   <script>
	    ClassicEditor
	    .create(document.querySelector('#bbsCn'), {
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





