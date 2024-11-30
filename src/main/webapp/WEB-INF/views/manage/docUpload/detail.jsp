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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.9.359/pdf.min.js"></script>
<title>공지 상세</title>
<script type="text/javascript">

	$(document).ready(function() {
		//pdf 파일 클릭 시
		$(document).on("click", '.viewPdf', function(event) {
			event.preventDefault();
			
			//파일 경로 가져오기
			var fileUrl = $(this).attr('href');
			
			//새 창에서 pdf 파일 열기
			window.open(fileUrl, '_blank');
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
	
	/* 제목과 등록일을 가로로 배치 */
	.title-wrapper {
		display: flex;
		justify-content: space-between; /* 양쪽에 배치 */
		align-items: center;
		margin-bottom: 1rem;
		border-bottom: 2px solid #e5e7eb; /* 밑줄 추가 */
		padding-bottom: 0.5rem;
	}
	
	.title {
		font-size: 1.25rem; /* 제목을 크게 */
		font-weight: bold;
		color: #1f2937; /* 다크 그레이 */
		margin: 0;
	}
	
	.title-wrapper .date {
		font-size: 0.875rem; /* 날짜는 작게 */
		color: #6b7280; /* 중간 회색 */
	}
	
	#bbsCn {
		resize: none;
		overflow-y: auto;
		height: 400px;
		width: 100%;
	}
	
	.icons {
		margin-top: 10px;
		display: flex;
		align-items: center;
	}
	
	.icons svg {
		cursor: pointer;
		transition: color 0.2s ease;
	}
	
	.icons svg:hover {
		color: #4b5563; /* 아이콘 호버 시 색상 변경 */
	}
	
	.text-sm {
		font-size: 0.875rem; /* 작은 텍스트 크기 */
	}
	
	.flex {
		display: flex;
	}
	
	.justify-end {
		justify-content: flex-end;
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
</head>
<body>
	<div class="py-14">
		<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
			<div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
				<div class="p-10 bg-white border-b border-gray-200">
					<div class="pb-2 text-sm flex justify-between items-center">
						<a id="category" href="/docUpload/list" class="text-md">자료실</a>
						 <div class="inline-flex rounded-md" role="group">
					        <a href="/docUpload/list" class="px-2.5 py-1 rounded-l-lg border border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700">
					            목록
					        </a>
					        <a href="/docUpload/detail?bbsNo=${nextNo.bbsNo}" class="px-3 py-1 border-t border-b border-gray-200 bg-white font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700"
					        		style="font-size: 0.4rem;">
					            ▲
					        </a>
					        <a href="/docUpload/detail?bbsNo=${prevNo.bbsNo}" class="px-3 py-1 rounded-r-md border border-gray-200 bg-white font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700"
					        		style="font-size: 0.4rem;">
					           	▼
					        </a>
					    </div>
					</div>
					<!-- 제목과 등록일을 한 줄에 배치 -->
					<div class="title-wrapper ">
						<h3 class="title font-semibold flex items-center">
							${boardVO.bbsTtl}
						</h3>
						<!-- 글 제목 -->
						<span class="date" class="text-md">
							<fmt:formatDate value="${boardVO.regDt}" pattern="yyyy.MM.dd HH:mm"/>
						</span>
						<!-- 등록일 -->
					</div>
					<!-- 조회수 -->
					<div class="text-sm text-gray-600 mb-1 flex justify-end items-center">
					    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4 inline-fl">
					        <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z"></path>
					        <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
					    </svg>
					    <!-- 아이콘과 숫자 사이의 간격을 위한 margin-left 추가 -->
					    <span style="margin-left: 4px;">${boardVO.inqCnt}</span>
					</div>
					<div class="mb-8">
						<div id="bbsCn" name="bbsCn">${boardVO.bbsCn}</div>
					</div>
					<hr style="boarder: 0px; height: 1px; color: white;">
					<br>
					<!-- 첨부파일 -->
					<c:if test="${not empty fileDetailList}">
					    <div class="mb-4 flex items-center">
					        <label class="text-md text-gray-600 mr-4">첨부파일</label>
					        <div class="icons flex text-gray-500 m-2">
					            <label id="select-image">
					                <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7"
					                     xmlns="http://www.w3.org/2000/svg" fill="none"
					                     viewBox="0 0 24 24" stroke="currentColor">
					                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
					                          d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
					                </svg>
					            </label>
					            <div id="fileList" class="text-sm text-gray-500 pb-2 ml-2">
					                <c:forEach var="file" items="${fileDetailList}">
<%-- 					                    <a href="/download?fileName=${file.fileSaveLocate}"> --%>
<%-- 					                        ${file.fileOriginalNm} [${file.fileFancysize}] --%>
<!-- 					                    </a> -->
                                    <c:choose>
                                    <c:when test="${fn:endsWith(file.fileOriginalNm, '.pdf')}">
                                         	<div class="flex">
	                                         	<a href="${file.fileSaveLocate}" class="viewPdf">${file.fileOriginalNm} [${file.fileFancysize}]</a>
	                                         	<span class="ml-1">|</span>
	                                            <a href="/download?fileName=${fn:replace(file.fileSaveLocate, ' ', '%20')}" class="download-icon text-[#4E7DF4]">다운로드</a>
                                         	</div>
                                    </c:when>
                                         <%-- PDF 파일이 아닌 경우 이름 클릭 시 미리보기--%>
                                    <c:otherwise>
                                         	<a href="${file.fileSaveLocate}">${file.fileOriginalNm} [${file.fileFancysize}]</a>
                                         	<span>|</span>
                                            <a href="/download?fileName=${file.fileSaveLocate}" class="download-icon text-[#4E7DF4]">다운로드</a>
                                         </c:otherwise>
                                    </c:choose>
					                    <br/>
					                </c:forEach>
					            </div>
					        </div>
					    </div>
					</c:if>	
					<!-- 버튼들 -->
					<div class="flex justify-end p-1" style="gap: 10px;">
					<c:if test="${empVO.empNo == boardVO.empNo}">
						<button type="button" id="updateBtn" class="shadow-xs text-gray-600 active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
						    style="background-color: #FFFFF;" onclick="location.href='/docUpload/edit?bbsNo=${boardVO.bbsNo}'">
						    수정
						</button>
				        <button type="button" id="deleteBtn" class="shadow-xs text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
						    style="background-color: #848484;">
						    삭제
						</button>
					</c:if>
					</div>
					
				</div>
			</div>
		</div>
	</div>
</body>
</html>




