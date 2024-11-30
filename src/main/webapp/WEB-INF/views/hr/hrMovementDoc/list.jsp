<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page session="false" %>
<!-- 로그인 후 정보 확인 시작 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!-- 로그인 후 정보 확인 끝 -->
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

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

</style>

<<script type="text/javascript">

$(function(){
	
	//문서 등록 페이지
	$("#docRegist").on("click", function(){
		location.href = "/hrMovementDoc/regist";
	});
	
});


</script>


<!-- 사내 전 사원 목록 :: 장영원 -->
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 ">
	<div class="w-full flex justify-between items-center mt-1 pl-3">
	    <div style="margin-top: 30px;">
	        <h3 class="text-lg font-semibold text-slate-800"><!-- ㅇㅇ부서 : 로그인 정보로 출력 -->문서 관리</h3>
	        <p class="text-slate-500">문서 리스트</p>
	    </div>
	    <div class="flex items-center space-x-3 mt-2 pt-4">
	        <!-- 버튼 -->
	        <button id="docRegist" type="button"
				class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
				>문서 등록</button>
	    </div>
	</div>
	
	<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
	    <div class="card-body table-responsive p-0">
				<table class="table table-hover text-nowrap" style="text-align: center;">
					<thead>
						<tr>
							<th>순번</th>
							<th>승인여부</th>
							<th>제목</th>
							<th>기안자</th>
							<th>기안날짜</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="hrMovementVO" items="${hrMovementDocVOList}">
							<tr>
								<td>1</td>
								<td>대기</td>
								<td>${hrMovementVO.docTtl}</td>
								<td>장영원</td>
								<td>${hrMovementVO.wrtYmd}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
	    
	    <c:if test="${articlePage.total == 0 }">
	    	<p style="margin: 40px; text-align: center;">데이터가 존재하지 않습니다.</p>
	    </c:if>
	    
	    <c:if test="${articlePage.total != 0 }">
			<nav aria-label="Page navigation" style="margin-left: auto;margin-right: auto;margin-top: 20px;margin-bottom: 10px;">
				<ul class="inline-flex space-x-2">
					<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
					<li>
						<c:if test="${articlePage.startPage gt 5}">
							<a href="/employee/list?currentPage=${articlePage.startPage-5}" style="color:#4E7DF4"
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
								<button id="button-${pNo}" onclick="javascript:location.href='/employee/list?currentPage=${pNo}';"
									class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
									style="color:#4E7DF4">${pNo}
								</button>
							</li>
						</c:if>
			
						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}" onclick="javascript:location.href='/employee/list?currentPage=${pNo}';"
									class="w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color:#4E7DF4">${pNo}
								</button>
							</li>
						</c:if>
					</c:forEach>
			
					<!-- endPage < totalPages일 때만 [다음] 활성화 -->
					<li>
						<c:if test="${articlePage.endPage lt articlePage.totalPages}">
							<a href="/employee/list?currentPage=${articlePage.startPage + 5}" style="color:#4E7DF4"
								class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
									<path d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
								</svg>
							</a>
						</c:if>
					</li>
				</ul>
			</nav>
		</c:if>
	</div>
</div>
	
	
	
