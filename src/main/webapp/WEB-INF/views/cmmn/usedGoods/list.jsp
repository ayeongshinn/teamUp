<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<script>
$(document).ready(function(){
    $(".truncate-text").each(function() {
        var text = $(this).text().trim();
        var maxLength = 18; // 원하는 글자 수 설정
        
        if(text.length > maxLength) {
            $(this).text(text.substring(0, maxLength) + '...');
        }
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
</style>

<%-- <p>${ugBoardList}</p> --%>

<div class="max-w-7xl mx-auto sm:px-6 lg:px-8"> 
	<div class="w-full flex justify-between items-center mb-3 mt-1 pl-3">
	    <div style="margin-top: 30px; margin-bottom: 10px;">
	        <h3 class="text-lg font-semibold text-slate-800">중고 거래 커뮤니티</h3>
	        <p class="text-slate-500">사내에서 필요한 물품을 찾아보세요</p>
	    </div>
	</div>	
	
	
			<div class="flex justify-end mb-3">
			<div  style="margin-top:10px !important; margin-right:10px;">
				<tr>
					<td colspan="7" style="text-align: right;">
						<button
							class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							name="insert" id="insert" type="button" onclick="window.location.href='/usedGoods/registGoods';" style="background-color:#4E7DF4">등록</button>
					</td>
				</tr>
			</div>

		<form id="searchForm">
		    <div class="flex justify-end space-x-3 mt-2">

		     <!-- 검색 필드 및 버튼 -->
		      <div>
		        <div class="w-full max-w-sm min-w-[200px] relative">
		          <div class="relative">
		            <input type="text" name="keyword"
		                   class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
		                   placeholder="검색어를 입력하세요."
		                   value="${param.keyword != null ? param.keyword : ''}"/>
		            <button type="submit" class="absolute h-8 w-8 right-1 top-1 my-auto px-2 flex items-center bg-white rounded">
		              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-8 h-8 text-slate-600">
		                <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
		              </svg>
		            </button>
		          </div>
		        </div>
		      </div>
		    </div>
		  </form>
		</div>
<!-- component -->

<div class="relative flex flex-col w-full h-full text-gray-700 bg-white rounded-lg bg-clip-border p-4">
  <div class="-m-4 flex flex-wrap">
    <c:forEach var="ugBoard" items="${articlePage.content}">
      <div class="w-full p-4 md:w-1/2 lg:w-1/4">
        <a href="/usedGoods/detail?bbsNo=${ugBoard.board.bbsNo}" class="relative block h-64 overflow-hidden rounded">
<!--           <img alt="ecommerce" class="block h-full w-full object-cover object-center cursor-pointer" src="https://dummyimage.com/421x261" /> -->
			           <c:forEach var="fileDetailVO" items="${ugBoard.board.fileDetailVOList}" varStatus="fileStatus">
				            <c:if test="${fileStatus.index == 0}">
				                <img src="${pageContext.request.contextPath}${fileDetailVO.fileSaveLocate}" alt="${fileDetailVO.fileOriginalNm}" class="block h-full w-full object-cover object-center cursor-pointer">
				            </c:if>
				        </c:forEach>
        </a>
        <div class="mt-3">
       
          <h3 class="title-font mb-2 text-base font-bold tracking-wide text-balck-500"><span class="truncate-text font-sm">${ugBoard.board.bbsTtl}</span></h3>
          <c:choose>
		    <c:when test="${ugBoard.board.price == 0}">
		        <h2 class="title-font mb-2 text-sm font-bold text-gray-900">무료</h2>
		    </c:when>
		    <c:otherwise>
		        <h2 class="title-font mb-2 text-sm font-bold text-gray-900">
		            <fmt:formatNumber value="${ugBoard.board.price}" type="number" groupingUsed="true" />원
		        </h2>
		    </c:otherwise>
		 </c:choose>
          
			
			<p class="mb-2 text-sm">${ugBoard.formattedRegDt}</p>
			
			<div class="flex justify-between items-center">
				  <c:choose>
				    <c:when test="${ugBoard.board.delngSttusCd == 'A01-001'}">
<!-- 				      판매 중 배지 -->
				      <span class="relative inline-flex items-center px-2 py-0.5 font-semibold text-sm text-dark-900 leading-tight">
				        <span aria-hidden class="absolute inset-0 opacity-15 rounded-lg" style="background-color: #4E7DF4;"></span>
				        <span class="relative" style="color: #4E7DF4; font-size: 12px;">판매중</span>
				      </span>
				    </c:when>
				    <c:when test="${ugBoard.board.delngSttusCd == 'A01-002'}">
<!-- 				      판매 완료 배지 -->
				      <span class="relative inline-flex items-center px-2 py-0.5 font-semibold text-sm text-dark-900 leading-tight">
				        <span aria-hidden class="absolute inset-0 opacity-15 rounded-lg" style="background-color: #28a745;"></span>
				        <span class="relative" style="color: #28a745; font-size: 12px;">판매완료</span>
				      </span>
				    </c:when>
				  </c:choose>
				  
				    <div class="flex items-center">
				    <div class="text-sm text-gray-600 flex items-center" style="margin-right: 8px;">
				      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#4E5461" class="w-4 h-4 inline-fl">
				        <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z"></path>
				        <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
				      </svg>
				      <span style="margin-left: 4px;">${ugBoard.board.inqCnt}</span>
				    </div>
				
				    <div class="text-sm text-gray-600 flex items-center">
				      <img src="/resources/images/rrreply.png" alt="Reply Icon" class="w-4 h-4 inline-fl" style="width:12px;height:12px; margin-left: 4px;" />
				      <span style="margin-left: 4px;">${ugBoard.board.replyCnt}</span>
				    </div>
				  </div>
			  </div>  
			
        </div>
      </div>
    </c:forEach>
  </div>
  <nav aria-label="Page navigation" style="margin-left: auto;margin-right: auto;margin-top: 20px;margin-bottom: 10px;" >
    <ul class="inline-flex space-x-2">
        <!-- startPage가 5보다 클 때만 [이전] 활성화 -->
        <li>
            <c:if test="${articlePage.startPage gt 5}">
                <a href="/usedGoods/list?currentPage=${articlePage.startPage-5}&keyword=${param.keyword}"
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
                    <button id="button-${pNo}" onclick="javascript:location.href='/usedGoods/list?currentPage=${pNo}';"
                        class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
                        style="background-color: #4E7DF4; color: white;">
                        ${pNo}
                    </button>
                </li>
            </c:if>
            
            <c:if test="${articlePage.currentPage != pNo}">
                <li>
                    <button id="button-${pNo}" onclick="javascript:location.href='/usedGoods/list?currentPage=${pNo}';"
                        class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
                        style="color: #4E7DF4;">
                        ${pNo}
                    </button>
                </li>
            </c:if>
        </c:forEach>
        
        <!-- endPage < totalPages일 때만 [다음] 활성화 -->
        <li>
            <c:if test="${articlePage.endPage lt articlePage.totalPages}">
                <a href="/usedGoods/list?currentPage=${articlePage.startPage-5}&keyword=${param.keyword}"
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
<br><br>
</div>

