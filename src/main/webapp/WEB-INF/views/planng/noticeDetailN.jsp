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
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.10.377/pdf.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.10.377/pdf.worker.min.js"></script>
<title>공지 상세</title>
<script type="text/javascript">
	
	function updateSelectStatus(status) {
		if (status === 'W' || status === '') {
	        $("#statusSelect").val("");
	    } else {
	        $("#statusSelect").val(status);
	    }
	}

	function del(ntcNo) {
	    Swal.fire({
	        title: '게시글을 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#4E7DF4',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	        customClass: {
	            popup: 'my-alert-class'
	        }
	    }).then((result) => {
	        if(result.isConfirmed) {
	            $.ajax({
	            	url: "/deleteNotice",
	    			data: { "ntcNo": ntcNo },
	    			type: "post",
	    			beforeSend:function(xhr){
	    				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	    			},
	                success: function(result) {
	                    Swal.fire({
	                        title: '삭제되었습니다.',
	                        icon: 'success',
	                        confirmButtonText: '확인',
	                        confirmButtonColor: '#4E7DF4',
	                        customClass: {
	                        	popup: 'my-alert-class'
	                        }
	                    }).then(() => {
	                        window.location.href = '/noticeListN'; //삭제 후 목록으로 이동
	                    });
	                },
	            });
	        }
	    });
	}
	
	$(document).ready(function() {
		
		//pdf 파일 클릭 시
		$(document).on("click", '.viewPdf', function(event) {
			event.preventDefault();
			
			//파일 경로 가져오기
			var fileUrl = $(this).attr('href');
			
			//새 창에서 pdf 파일 열기
			window.open(fileUrl, '_blank');
		});
		
		
		updateSelectStatus("${noticeVO.aprvYn}");
		
		//삭제 버튼 클릭 시
		$("#deleteBtn").on("click", function() {
			const ntcNo = "${noticeVO.ntcNo}";
			del(ntcNo);
		})
		
		//상태 셀렉트박스 변경 시
		$("#statusSelect").on("change", function() {
			let selectedValue = $(this).val();
			let ntcNo = "${noticeVO.ntcNo}";
			let currentStatus = "${noticeVO.aprvYn}";
			
			//이미 승인 또는 반려된 경우 변경 불가
		    if (currentStatus !== 'W' && currentStatus !== '') {
		        Swal.fire({
		            toast: true,
		            icon: 'error',
		            title: '이미 처리된 게시글은 상태를 변경할 수 없습니다.',
		            position: 'top-end',
		            showConfirmButton: false,
		            timer: 2000,
		            timerProgressBar: true
		        });
		        updateSelectStatus(currentStatus);
		        return;
		    }
			
			//선택해 주세요 선택 시 아무 동작 없음
		    if (selectedValue === "") {
		        return;
		    }
			
			$.ajax({
				url: "/updateAprvStatus",
				type: "post",
				data: {
					"ntcNo" : ntcNo,
					"aprvYn" : selectedValue
				},
				beforeSend: function(xhr) {
					xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
				},
				success: function(result) {
					Swal.fire({
		                title: '게시글 상태가 변경되었습니다.',
		                icon: 'success',
		                confirmButtonColor: '#4E7DF4',
		                confirmButtonText: '확인',
		                reverseButtons: true,
		            }).then((result) => {
		                if (result.isConfirmed) {
							$("#statusSelect").prop("disabled", true);
		                }
		            });
				}
			})
		})
	})
	
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
	
	#ntcCn {
		resize: none;
		overflow-y: auto;
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
	
	.my-alert-class .swal2-icon { /* 아이콘 */ 
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
	<div class="py-10 h-auto">
		<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
			<div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
				<div class="p-14 bg-white border-b border-gray-200">
					<div class="pb-2 text-sm flex justify-between items-center">
						<a id="category" href="/noticeListN" class="text-md">공지사항 관리</a>
						 <div class="inline-flex rounded-md" role="group">
					        <a href="/noticeListN" class="px-2.5 py-1 rounded-l-lg border border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700">
					            목록
					        </a>
					        <a href="/noticeDetailN?ntcNo=${nextNotice.ntcNo}" class="px-3 py-1 border-t border-b border-gray-200 bg-white font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700"
					        		style="font-size: 0.4rem;">
					            ▲
					        </a>
					        <a href="/noticeDetailN?ntcNo=${prevNotice.ntcNo}" class="px-3 py-1 rounded-r-md border border-gray-200 bg-white font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700"
					        		style="font-size: 0.4rem;">
					           	▼
					        </a>
					    </div>
					</div>
					<!-- 제목과 등록일을 한 줄에 배치 -->
					<div class="title-wrapper">
						<h3 class="title font-semibold">
							<c:choose>
								<c:when test="${noticeVO.imprtncYn == 'Y'}">
									<span style="color: #848484; font-weight: bold;">[중요]</span>
								</c:when>
								<c:when test="${noticeVO.imprtncYn == 'N'}">
									<span style="color: #848484; font-weight: bold;">[일반]</span>
								</c:when>
							</c:choose>
							${noticeVO.ntcTtl}
						</h3>
						<!-- 글 제목 -->
						<span class="date" class="text-md">
							<fmt:formatDate value="${noticeVO.regDt}" pattern="yyyy.MM.dd HH:mm"/>
						</span>
						<!-- 등록일 -->
					</div>
					
					<div class="text-sm text-gray-600 mb-4 flex justify-between items-center">
					    <span class="font-semibold text-md">작성자: ${noticeVO.empNm}</span>
					    	<!-- 기획부 팀장에게만 셀렉트 노출 -->
						   <c:if test="${empVO.empNo == 200001}">
						    <select class="inline-flex" id="statusSelect" name="statusSelect"
						    		${noticeVO.aprvYn ne 'W' ? 'disabled' : '' }>
						    	<option value="" ${empty noticeVO.aprvYn or noticeVO.aprvYn eq 'W' ? 'selected' : ''}>선택해 주세요</option>
						    	<option value="Y" ${noticeVO.aprvYn eq 'Y' ? 'selected' : ''}>승인</option>
						    	<option value="N" ${noticeVO.aprvYn eq 'N' ? 'selected' : ''}>반려</option>
						    </select>
						   </c:if>
					</div>

					<div>
						<div id="ntcCn" name="ntcCn" class="mb-5">${noticeVO.ntcCn}</div>
					</div>
					
					<hr class="mb-3">					
					<!-- 첨부파일 -->
					<c:if test="${not empty noticeVO.fileDetailVOList}">
					<div class="mb-4 flex items-center">
						<label class="text-md text-gray-600 mr-4">첨부파일</label>
						<div class="icons flex text-gray-500 m-2">
							<label id="select-image">
							<svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7"
								 xmlns="http://www.w3.org/2000/svg" fill="none"
								 viewBox="0 0 24 24" stroke="currentColor">
				                <path stroke-linecap="round"
										stroke-linejoin="round" stroke-width="2"
										d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
				                </svg>
							</label>
							<div id="fileList" class="text-sm text-gray-500 pb-2 ml-2">
								<c:forEach var="file" items="${noticeVO.fileDetailVOList}">
									<c:choose>
										 <%-- PDF 파일인 경우 이름 클릭 시 pdf 뷰어--%>
                                         <c:when test="${fn:endsWith(file.fileOriginalNm, '.pdf')}">
                                         	<div class="flex">
	                                         	<a href="/resources${file.fileSaveLocate}" class="viewPdf">${file.fileOriginalNm} [${file.fileFancysize}]</a>
	                                         	<span class="ml-1">|</span>
	                                            <a href="/download?fileName=${file.fileSaveLocate}" class="download-icon ml-1 text-[#4E7DF4]">다운로드</a>
                                         	</div>
                                         </c:when>
                                         <%-- PDF 파일이 아닌 경우 이름 클릭 시 미리보기--%>
                                         <c:otherwise>
                                         	<a href="/resources${file.fileSaveLocate}">${file.fileOriginalNm} [${file.fileFancysize}]</a>
                                         	<span>|</span>
                                            <a href="/download?fileName=${file.fileSaveLocate}" class="download-icon text-[#4E7DF4]">다운로드</a>
                                         </c:otherwise>
									</c:choose>
					            </c:forEach>
							</div>
						</div>
					</div>
					</c:if>

					<!-- 버튼들 -->
					<div class="flex justify-end p-1" style="gap: 10px;">
					<c:if test="${empVO.empNo == noticeVO.empNo}">
						<button type="button" id="updateBtn" class="shadow-xs text-gray-600 active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
						    style="background-color: #FFFFF;" onclick="location.href='/updateNotice?ntcNo=${noticeVO.ntcNo}';">
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

