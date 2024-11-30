<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script>
	$(document).ready(function(){
	    $(".truncate-text").each(function() {
	        var text = $(this).text().trim();
	        var maxLength = 25; // 원하는 글자 수 설정
	        
	        if(text.length > maxLength) {
	            $(this).text(text.substring(0, maxLength) + '...');
	        }
	    });
	});
</script>
<title>공지사항</title>
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
	
	/* highlight-row 클래스에 파란색 왼쪽 테두리 스타일 적용 */
	.highlight-row {
	    border-left: 4px solid #4E7DF4; /* 왼쪽에 파란색 4px 테두리 추가 */
	}
	
</style>
</head>
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 mb-3">
    <div class="w-full flex justify-between items-center mt-1 pl-3">
        <div style="margin-top: 100px; margin-bottom: 10px;">
            <h3 class="text-lg font-semibold text-slate-800">
            	<a href="/noticeList">공지사항</a>
            </h3>
            <p class="text-slate-500">다양한 사내 소식을 확인하세요</p>
        </div>

	</div>
		<div class="flex justify-end mb-3">
		  <form id="searchForm">
		    <div class="flex justify-end space-x-3 mt-2">
		      <!-- 검색 필드 -->
		      <div class="relative">
		        <select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
		          <option value="titleContent" ${param.searchField == 'titleContent' ? 'selected' : ''}>제목+내용</option>
		          <option value="title" ${param.searchField == 'title' ? 'selected' : ''}>제목</option>
		          <option value="content" ${param.searchField == 'content' ? 'selected' : ''}>내용</option>
		        </select>
		      </div>
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
		<div
			class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
			<div class="card-body table-responsive p-0">
				<table style="text-align: center;"
					class="table table-hover text-nowrap">
					<thead>
						<tr>
							<th>번호</th>
							<th></th>
							<th>제목</th>
							<th>등록일</th>
							<th>조회수</th>
						</tr>
					</thead>
					<tbody>
						<!-- 검색 결과가 없을 때 -->
						<c:if test="${empty noticeVOList}">
							<tr>
								<td colspan="5" style="text-align: center; font-weight: bold; color: #848484;">
									데이터가 존재하지 않습니다
								</td>
							</tr>
						</c:if>
						<c:forEach var="noticeVO" items="${noticeVOList}">
							<!-- imprtncYn이 Y일 때만 파란색 선 클래스를 추가 -->
							<tr class="<c:if test='${noticeVO.imprtncYn == "Y"}'>highlight-row</c:if>">
								<td>${noticeVO.rnum2}</td>
								<td style="text-align: center;">
		                        	<c:if test="${noticeVO.fileGroupNo != null and noticeVO.fileGroupNo != '' and noticeVO.fileGroupNo != 0}">
										<img alt="clipIcon" src="/resources/images/clipIcon.png" class="h-[16px]"
										  style="vertical-align: middle; display: inline;">
									</c:if>
		                        </td>
								<td style="text-align: left;">
									<a href="/noticeDetail?ntcNo=${noticeVO.ntcNo}" style="text-decoration: none; color: inherit; display:inline;">
										<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
                        				<span class="truncate-text">
                        					<c:out value="${fn:replace(noticeVO.ntcTtl, param.keyword, word )}" escapeXml="false"/>
                        				</span>
									</a>
								</td>
								<td><fmt:formatDate pattern="yyyy.MM.dd" value="${noticeVO.regDt}"/></td>
								<td>${noticeVO.inqCnt}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<nav aria-label="Page navigation"
				style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
				<ul class="inline-flex space-x-2">
					<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
					<li><c:if test="${articlePage.startPage gt 5}">
							<a href="/noticeList?currentPage=${articlePage.startPage-5}"
								class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
								<path
										d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
										clip-rule="evenodd" fill-rule="evenodd"></path>
								</svg>
							</a>
						</c:if>
					</li>

					<!-- 총 페이징 -->
					<c:forEach var="pNo" begin="${articlePage.startPage}"
						end="${articlePage.endPage}">
						<c:if test="${articlePage.currentPage == pNo}">
							<li>
								<button id="button-${pNo}"
									onclick="javascript:location.href='/noticeList?currentPage=${pNo}';"
									class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
									style="background-color: #4E7DF4; color: white;">${pNo}
								</button>
							</li>
						</c:if>

						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}"
									onclick="javascript:location.href='/noticeList?currentPage=${pNo}';"
									class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color: #4E7DF4;">${pNo}</button>
							</li>
						</c:if>
					</c:forEach>

					<!-- endPage < totalPages일 때만 [다음] 활성화 -->
					<li>
						<c:if test="${articlePage.endPage lt articlePage.totalPages}">
							<a href="/noticeList?currentPage=${articlePage.startPage+5}"
								class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
									<path d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
										clip-rule="evenodd" fill-rule="evenodd">
									</path>
								</svg>
							</a>
						</c:if>
					</li>
				</ul>
			</nav>
		</div>
	</div>
</body>
</html>