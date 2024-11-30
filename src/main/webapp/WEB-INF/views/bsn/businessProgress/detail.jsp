<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<!DOCTYPE html>
<html>
<head>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

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
   
   /* 제목과 등록일을 가로로 배치 */
	.title-wrapper {
		display: flex;
		justify-content: space-between; /* 양쪽에 배치 */
		align-items: center;
		margin-bottom: 1rem;
		border-bottom: 2px solid #e5e7eb; /* 밑줄 추가 */
		padding-bottom: 1rem;
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
	// 토큰
	const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
	const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

</script>

<script type="text/javascript">

$(document).ready(function() {
	
	//삭제 버튼 클릭 시
	$("#deleteBtn").on("click", function() {
		var bsnNm = '${businessProgressVO.bsnNm}';
		del(bsnNm);
	})
});

function del(bsnNm) {
	
	console.log("삭제할 bsnNm : ", bsnNm);
	
    Swal.fire({
        title: '영업 진척도를 삭제하시겠습니까?',
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
            	url: "/businessProgress/deletePost",
    			data: { "bsnNm": bsnNm },
    			type: "POST",
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
                        window.location.href = '/businessProgress/list'; //삭제 후 목록으로 이동
                    });
                },
            });
        }
    });
}

</script>

</head>
<body>
	<div class="py-36">
		<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
			<div class="bg-white overflow-hidden shadow-sm sm:rounded-lg" style="height: 650px;">
				<div class="p-14 bg-white border-b border-gray-200" style="height: 100%;">
					<div class="pb-2 text-lg flex justify-between items-center">
						<a id="category" href="/businessProgress/list" class="text-lg">영업 진척도</a>
					</div>
					<!-- 제목과 등록일을 한 줄에 배치 -->
					<div class="title-wrapper ">
					
                    	<input type="hidden" name="manageNo" value="${businessProgressVO.manageNo}">
                    	<input type="hidden" name="bsnNm" value="${businessProgressVO.bsnNm}">
						
						<!-- 글 제목 -->
						<h3 class="title font-semibold flex items-center">
							${businessProgressVO.bsnTtl}
						</h3>
						<!-- 등록일 -->
						<span class="date" class="text-md">
							<fmt:parseDate value="${businessProgressVO.regDt}" pattern="yyyy-MM-dd" var="formattedDate"/>
							<fmt:formatDate value="${formattedDate}" pattern="yyyy.MM.dd"/>
						</span>
					</div>
					<div class="mb-4 font-semibold" style="display: flex; justify-content: space-between; align-items: center;">
					    <div style="flex-grow: 1; text-align: left;">
					        <span style="margin-right: 20px;">
					            영업 시작일 : 
					            <fmt:parseDate value="${businessProgressVO.bsnBgngYmd}" pattern="yyyyMMdd" var="startDate"/>
					            <fmt:formatDate value="${startDate}" pattern="yyyy.MM.dd"/>
					        </span>
			                <span>
					            영업 종료일 : 
					            <c:choose>
					                <c:when test="${not empty businessProgressVO.bsnEndYmd}">
					                    <fmt:parseDate value="${businessProgressVO.bsnEndYmd}" pattern="yyyyMMdd" var="endDate"/>
					                    <fmt:formatDate value="${endDate}" pattern="yyyy.MM.dd"/>
					                </c:when>
					                <c:otherwise>
					                   	진행중
					                </c:otherwise>
					            </c:choose>
					        </span>
					    </div>
					    <div style="flex-grow: 1; text-align: right;">
					        <span style="margin-right: 20px;">
					            	담당자 : ${businessProgressVO.tkcgEmpNm} ${businessProgressVO.tkcgEmpJbttlNm}
					        </span>
					        <span>
					            	책임자 : ${businessProgressVO.rbprsnEmpNm} ${businessProgressVO.rbprsnEmpJbttlNm}
					        </span>
					    </div>
					</div>
					<div style="height: 300px;">
						<div id="bsnCn" name="bsnCn" class="mb-5">${businessProgressVO.bsnCn}</div>
					</div>
					<!-- 영업 진척도용 프로세스 바 -->
					<div class="relative max-w-80 ml-auto">
						<div class="flex mb-2 items-center justify-between">
							<div>
								<span class="text-xs font-semibold inline-block py-1 px-2 uppercase rounded-full text-white bg-[#848484]">
								영업 진행률
								</span>
							</div>
							<div class="text-right">
								<span class="text-xs font-semibold inline-block text-[#848484]">
									${businessProgressVO.bsnProgrs} % </span>
							</div>
						</div>
						<div class="flex rounded-full h-2 bg-gray-200 mb-3">
							<div style="width:${businessProgressVO.bsnProgrs}%"
								class="rounded-full bg-[#848484]"></div>
						</div>
					</div>
					<hr class="mb-3">
					
					<div class="flex justify-end p-1" style="gap: 10px;">
						<c:if test="${empVO.empNo == businessProgressVO.tkcgEmpNo}">
							<button type="button" id="updateBtn" class="bg-white text-#[#848484] active:bg-white font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
							    	onclick="location.href='update?manageNo=${businessProgressVO.manageNo}';">
							   수정
							</button>
							<button type="button" id="deleteBtn"
									class="bg-[#848484] text-white active:bg-[#848484] font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150">
							    삭제
							</button>
						</c:if>
					</div>
					<sec:csrfInput/>
				</div>
			</div>
		</div>
	</div>
</body>
</html>