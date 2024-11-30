<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script type="text/javascript">

$(document).ready(function(){
    $(".truncate-text").each(function() {
        var text = $(this).text().trim();
        var maxLength = 60; // 원하는 글자 수 설정
        
        if(text.length > maxLength) {
            $(this).text(text.substring(0, maxLength) + '...');
        }
    });
});

$(document).ready(function(){
	
	$('#selectAll').change(function(){
		let isChecked = (this).prop('checked');
		$('tbody input[type="checkbox"]').porp('checked',isChecked);
		
	});
	
    // 개별 체크박스 상태 변경 시 "전체 선택" 체크박스 상태 변경
    $('tbody input[type="checkbox"]').change(function() {
        if (!$(this).prop('checked')) {
            $('#selectAll').prop('checked', false);
        }

        if ($('tbody input[type="checkbox"]:checked').length === $('tbody input[type="checkbox"]').length) {
            $('#selectAll').prop('checked', true);
        }
    });
    
    // 선택된 자료 삭제
    $('#deleteSelected').click(function() {
       
        // 선택된 비품 삭제 확인 (SweetAlert 적용)
        Swal.fire({
            title: '정말 삭제하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#4E7DF4',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
            reverseButtons: true,
        }).then((result) => {
            if (result.isConfirmed) {
                // 확인을 누른 경우만 삭제 진행
                
                // 선택된 체크박스의 비품 번호를 배열에 저장
                let selectedItems = [];
                
                let formData = new FormData();
                
                $('tbody input[type="checkbox"]:checked').each(function() {
//                     let fxtrsNo = $(this).closest('tr').find('td').eq(1).text(); // 비품 코드 가져오기
						//data-fxtrs-no="B0101"
                    let bbsNo = $(this).data("bbsNo"); // 비품 코드 가져오기
                    console.log("삭제 비품 : " , bbsNo);
                    selectedItems.push(bbsNo);
                    
                    formData.append("bbsNoList",bbsNo);
                });
                
                console.log("삭제 폼 데이터 : " , formData);

                // 아무것도 선택되지 않은 경우 경고
                if (selectedItems.length === 0) {
                    alert("삭제할 자료를 선택하세요.");
                    return;
                }

                // AJAX 요청으로 선택된 비품 삭제
                $.ajax({
                    url: '/docUpload/deleteDoc', // 서버에서 처리할 URL
                    processData:false,
                    contentType:false,
                    type: 'POST',
                    data: formData, // 선택된 비품 번호를 JSON으로 전송
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 포함
                    },
                    dataType:"text",
                    success: function(result) {
                        // 삭제 성공 시 처리
                        Swal.fire({
                            icon: 'success',
                            title: '선택한 자료가 삭제되었습니다.',
                        }).then(() => {
                            location.reload(); // 페이지 새로고침
                        });
                    },
                    error: function(xhr, status, error) {
                        // 삭제 실패 시 처리
                        console.error("삭제 실패:", error);
                        Swal.fire({
                            icon: 'error',
                            title: '자료 삭제 중 오류가 발생했습니다.',
                        });
                    }
                });
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
   
   .swal2-icon { /* 아이콘 */
		font-size: 8px !important;
		width: 40px !important;
		height: 40px !important;
	}
	
	.swal2-styled.swal2-cancel { /* 취소 버튼 스타일 */
		font-size: 14px;
		background-color: #f8f9fa;
		color: black;
		border: 1px solid #D9D9D9;
	}
	
	.swal2-styled.swal2-confirm { /* 확인 버튼 스타일 */
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
	
	.swal2-text { /* 설명란 텍스트 사이즈 */
		font-size: 0.5rem !important;
	}
	
	#deleteSelected {
    background-color: white;
    color: #848484;
}

#deleteSelected:hover {
    background-color: #848484;
    color: white;
}
	
</style>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

 <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
    <div class="w-full flex justify-between items-center mt-1 pl-3">
        <div style="margin-top: 30px; margin-bottom: 10px;">
            <h3 class="text-lg font-semibold text-slate-800">
            	<a href="/noticeList">자료실</a>
            </h3>
            <p class="text-slate-500">필요한 사내 문서를 다운로드하고 확인하세요</p>
        </div>

	</div>

<div class="flex justify-between items-center mb-3 w-full">
  <c:if test="${empVO.deptCd == 'A17-003'}">
    <!-- 왼쪽에 삭제 버튼 -->
    <div class="flex-shrink-0">
      <input type="button" value="삭제" 
             class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 mt-2"
             onclick="deleteSurveys()" id="deleteSelected" />
    </div>
  </c:if>
  
  <form id="searchForm" class="flex items-center space-x-3 mt-2 w-full justify-end">
    <c:if test="${empVO.deptCd == 'A17-003'}">
      <!-- 날짜 검색 -->
      <div class="flex items-center space-x-2">
        <label for="startDate" class="text-gray-700" style="width: 80px; text-align:right;margin-top:7px;">기간</label>
        <input type="date" id="startDate" name="startDate"
               class="bg-white h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
               value="${param.startDate != null ? param.startDate : ''}"/>
        
        <span>-</span>
        <input type="date" id="endDate" name="endDate"
               class="bg-white h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
               value="${param.endDate != null ? param.endDate : ''}"/>
      </div>
    </c:if>

    <!-- 검색 필드 및 버튼 전체 영역을 오른쪽 정렬 -->
    <div class="flex items-center space-x-2">
      <select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
        <option value="titleContent" ${param.searchField == 'titleContent' ? 'selected' : ''}>제목+내용</option>
        <option value="title" ${param.searchField == 'title' ? 'selected' : ''}>제목</option>
        <option value="content" ${param.searchField == 'content' ? 'selected' : ''}>내용</option>
      </select>

      <input type="text" name="keyword"
             class="bg-white h-10 px-3 pr-10 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
             placeholder="검색어를 입력하세요."
             value="${param.keyword != null ? param.keyword : ''}"/>
      <button type="submit" class="h-10 w-10 flex items-center justify-center bg-white rounded border border-slate-200 transition duration-200 ease focus:outline-none hover:border-slate-400">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5 text-slate-600">
          <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
        </svg>
      </button>
    </div>
  </form>
</div>

		<div
			class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
			<div class="card-body table-responsive p-0">
				<table style="text-align: center;"
					class="table table-hover text-nowrap">
					<thead>
						<tr>
						   <c:if test="${empVO.deptCd == 'A17-003'}">
							<th><input type="checkbox" id="selectAll" /></th>
						   </c:if>
							<th>번호</th>
							<th> </th>
							<th>제목</th>
							<th>등록일</th>
							<th>조회수</th>
						</tr>
					</thead>
					<tbody>
						<!-- 검색 결과가 없을 때 -->
						<c:if test="${empty articlePage.content}">
							<tr>
								<td colspan="6"
									style="text-align: center; font-weight: bold; color: #848484;">
									데이터가 존재하지 않습니다</td>
							</tr>
						</c:if>
						<c:forEach var="docUploadVO" items="${articlePage.content}">
							
							  <c:if test="${empVO.deptCd == 'A17-003'}">
								<td><input type="checkbox" data-bbs-no="${docUploadVO.bbsNo}" /></td>
							  </c:if>
								<td>${docUploadVO.rnum}</td>
								<td style="text-align: center;">
		                        	<c:if test="${docUploadVO.fileGroupNo != null and docUploadVO.fileGroupNo != '' and docUploadVO.fileGroupNo != 0}">
										<img alt="clipIcon" src="/resources/images/clipIcon.png" class="h-[16px]"
										  style="vertical-align: middle; display: inline;">
									</c:if>
                        		</td>
								<td style="text-align:left;">
									<a href="/docUpload/detail?bbsNo=${docUploadVO.bbsNo}" style="text-decoration: none; color: inherit;">
										<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
										<span class="truncate-text">
                        				${fn:replace(docUploadVO.bbsTtl, param.keyword, word )}
                        				</span>
									</a>
								</td>
								<td><fmt:formatDate pattern="yyyy.MM.dd"
										value="${docUploadVO.regDt}" /></td>
								<td>${docUploadVO.inqCnt}</td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
					  <c:if test="${empVO.deptCd == 'A17-003'}">
		             	 <tr>
							<td colspan="7" style="text-align: right;">
								<button class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									    name="insert" id="insert" type="button" onclick="location.href='/docUpload/regist'" style="background-color:#4E7DF4">등록</button>
							</td>
						</tr>
					   </c:if>
	               </tfoot>
				</table>
			</div>

			<nav aria-label="Page navigation"
			    style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
			    <ul class="inline-flex space-x-2">
			        <!-- startPage가 5보다 클 때만 [이전] 활성화 -->
			        <li>
			            <c:if test="${articlePage.startPage gt 5}">
			                <a href="/docUpload/list?currentPage=${articlePage.startPage-5}&startDate=${param.startDate}&endDate=${param.endDate}&searchField=${param.searchField}&keyword=${param.keyword}"
			                    class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
			                    <svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
			                        <path d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
			                    </svg>
			                </a>
			            </c:if>
			        </li>
			
			        <!-- 총 페이징 -->
			        <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
			            <c:if test="${articlePage.currentPage == pNo}">
			                <li>
			                    <button id="button-${pNo}"
			                        onclick="javascript:location.href='/docUpload/list?currentPage=${pNo}&startDate=${param.startDate}&endDate=${param.endDate}&searchField=${param.searchField}&keyword=${param.keyword}';"
			                        class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
			                        style="background-color: #4E7DF4; color: white;">${pNo}
			                    </button>
			                </li>
			            </c:if>
			
			            <c:if test="${articlePage.currentPage != pNo}">
			                <li>
			                    <button id="button-${pNo}"
			                        onclick="javascript:location.href='/docUpload/list?currentPage=${pNo}&startDate=${param.startDate}&endDate=${param.endDate}&searchField=${param.searchField}&keyword=${param.keyword}';"
			                        class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
			                        style="color: #4E7DF4;">${pNo}
			                    </button>
			                </li>
			            </c:if>
			        </c:forEach>
			
			        <!-- endPage < totalPages일 때만 [다음] 활성화 -->
			        <li>
			            <c:if test="${articlePage.endPage lt articlePage.totalPages}">
			                <a href="/docUpload/list?currentPage=${articlePage.startPage+5}&startDate=${param.startDate}&endDate=${param.endDate}&searchField=${param.searchField}&keyword=${param.keyword}"
			                    class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
			                    <svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
			                        <path d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
			                    </svg>
			                </a>
			            </c:if>
			        </li>
			    </ul>
			</nav>
		</div>
	</div>


