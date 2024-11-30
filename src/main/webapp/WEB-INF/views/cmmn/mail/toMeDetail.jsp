<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal.employeeVO" var="empVO" />
	</sec:authorize>
<!DOCTYPE html>

<html>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">

<script
	src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<head>


<script type="text/javascript">

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

.form-group {
	display: flex;
	flex-wrap: wrap;
	gap: 10px; /* 간격을 줄 수 있습니다. */
	align-items: center;
}

.form-control {
	flex: 1; /* 셀렉트 박스의 너비를 반으로 설정 */
	width: 48%; /* 두 개의 셀렉트 박스가 반씩 차지하도록 */
	min-width: 200px; /* 최소 너비 지정 */
}

.swal2-icon { /* 아이콘 */ 

font-size: 10px !important;

width: 50px !important;

height: 50px !important;

}


.swal2-confirm, .swal2-cancel {

padding: 0.4rem 2rem; /* 버튼 크기 조정 (높이, 너비) */

font-size: 1.25rem; /* 텍스트 크기 조정 */

min-width: 20px;

}


.swal2-title { /* 타이틀 텍스트 사이즈 */

font-size: 1.3rem !important;

}


.swal2-text { /* 설명란 텍스트 사이즈 */

font-size: 0.5rem !important;

}

.empContainer {
        width: 250px;
        height: 140px;
        overflow: auto;
      }
.container::-webkit-scrollbar {
    width: 10px;
  }
  .container::-webkit-scrollbar-thumb {
    background-color: #4E7DF4;
    border-radius: 10px;
  }
  .container::-webkit-scrollbar-track {
    background-color: lightGray;
    border-radius: 10px;
  }

</style>
<body>

	


	<div class="py-12">
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
						<div>
							<c:forEach var="mailRVO" items="${mailDVO.mailRVOList}">
								<c:if test="${mailRVO.rspamYn == 'Y'}">
	                        		<i class="fa-solid fa-star fa-xl" style="color: #FFD43B;"></i>
	                        	</c:if>
	                        	<c:if test="${mailRVO.rspamYn == 'N'}">
	                        		<i class="fa-regular fa-star fa-xl" style="color: #d1d1d1;"></i>
	                        	</c:if>
	                        </c:forEach>
						</div>	                        
	                    <div>    
							<p style="font-size: 30px; ">${mailDVO.mailTtl}</p>
                        	<p>
								<fmt:formatDate value="${mailDVO.dsptchDt}"
									pattern="yyyy.MM.dd(E) HH:mm" /><br>
							</p>
						</div>
						<hr style="boarder : 0px; height:1px; color: white;">
						<br>
						<div class="mb-80">
							<input type="text" class="form-control" id="dsptchEmpNo"
								name="dsptchEmpNo" value="${empVO.empNo}" hidden="hidden" />
							${mailDVO.mailCn}
						</div>

						<hr style="boarder : 0px; height:1px; color: white;">
						<br>
						<div class="mb-4 flex items-center">
							<label class="mb-4 flex items-center">첨부파일</label>
							<div class="icons flex text-gray-500 m-2">
								<label id="select-image"> <svg
										class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7"
										xmlns="http://www.w3.org/2000/svg" fill="none"
										viewBox="0 0 24 24" stroke="currentColor">
				                        <path stroke-linecap="round"
											stroke-linejoin="round" stroke-width="2"
											d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
				                    </svg> <input type="file" id="uploadFile" hidden>
								</label>
								<!-- 파일 이름 출력 영역 -->
								<div id="fileList" class="text-sm text-gray-500 mt-2"></div>
							</div>
							<!-- 이미지 첨부 시 미리보기 영역 -->
							<div id="pImg"></div>
						</div>
						<div class="flex justify-end p-1" style="gap: 10px;">
							<button type="button" id="btnRegistPost" ondblclick="location.href='/cmmn/mail/toMeList?empNo=${empVO.empNo}'"
								class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								style="background-color: #4E7DF4; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
								내게쓴 메일함</button>
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

