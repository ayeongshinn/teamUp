<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<script>
	
var empNo = "${empVO.empNo}";
	
$(function() {
		console.log("개똥이");
		//input type date 기간 제한
		var now_utc = Date.now() // 지금 날짜를 밀리초로
		var timeOff = new Date().getTimezoneOffset()*60000; // 분단위를 밀리초로 변환
		var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
		
		$("#startDate").attr("max", today);
		$("#endDate").attr("max", today);
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

.bg-indigo-500 {
	background-color: #4E7DF4;
}
</style>

<!-- 업무 일지 리스트 :: 박수빈 -->
</head>
<script type="text/javascript">





</script>

<body>
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
    <div class="w-full flex justify-between items-center mb-3 mt-1 pl-3">
        <div style="margin-top: 30px; margin-bottom: 10px;">
            <h3 class="text-lg font-semibold text-slate-800">업무 일지</h3>
            <p class="text-slate-500">오늘의 업무 일지를 작성해 주세요</p>
        </div>
     </div>

		
		<!-- 검색 기능 시작 -->
		<div class="flex justify-end mb-3">
		  <form id="searchForm">
		    <div class="flex justify-end space-x-3 mt-2">
		    
		       <!-- 기간 검색 필드 추가 -->
		      <div class="flex items-center space-x-2">
				
		        <label for="startDate" class="text-gray-700" style="width: 80px;">기간</label>
		        <input type="date" id="startDate" name="startDate"
		               class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
		               value="${param.startDate != null ? param.startDate : ''}"/>
		        		
		        <span>-</span>
		        <input type="date" id="endDate" name="endDate"
		               class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
		               value="${param.endDate != null ? param.endDate : ''}"/>		        				
		      </div>
		      
		      <!-- 검색 필드 -->
		      <div class="relative">
		        <select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
		          <option value="titleContent" ${param.searchField == 'titleContent' ? 'selected' : ''}>제목+내용</option>
		          <option value="title" ${param.searchField == 'title' ? 'selected' : ''}>제목</option>
		          <option value="content" ${param.searchField == 'content' ? 'selected' : ''}>내용</option>
		          <option value="writer" ${param.searchField == 'writer' ? 'selected' : ''}>작성자</option>
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
		<!-- 검색 기능 끝 -->
		

		<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
			<div class="card-body table-responsive p-0">
				<form id="selectStatus">
					<c:set var="totalCount" value="${fn:length(taskDiaryVOList)}" />
		            <table style="text-align: center;" class="table table-hover text-nowrap">
		                <thead>
		                    <tr>
		                        <th>번호</th>
		                        <th>제목</th>
		                        <th>작성자</th>
		                        <th>작성 일지</th>
		                    </tr>
		                </thead>
		                <c:if test="${totalCount == 0}">
		                    <tbody>
		                        <tr>
		                            <td colspan="4" style="text-align: center; padding: 20px;">
		                                <strong>작성된 업무일지가 없습니다.</strong>
		                            </td>
		                        </tr>
		                    </tbody>
		                </c:if>
		                <c:if test="${totalCount > 0}">
		                    <tbody>
		                        <c:forEach var="taskDiaryVO" items="${taskDiaryVOList}" varStatus="status">
								    <tr style="cursor: pointer;">
								        <td><a href="/taskDiary/detail?diaryNo=${taskDiaryVO.diaryNo}">${articlePage.total - (articlePage.currentPage - 1) * 10 - status.index}</a></td>
								        <td style="text-align: left;"><a href="/taskDiary/detail?diaryNo=${taskDiaryVO.diaryNo}">${taskDiaryVO.diaryTtl}</a></td>
								        <td><a href="/taskDiary/detail?diaryNo=${taskDiaryVO.diaryNo}">${taskDiaryVO.empNm}</a></td>
								        <td><fmt:formatDate value="${taskDiaryVO.regDt}" pattern="yyyy.MM.dd" /></td>
								    </tr>
								</c:forEach>
		                    </tbody>
		                </c:if>

						<tfoot>
							<tr>
								<td colspan="7" style="text-align: right;"><a
									href="/taskDiary/regist">
										<button class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									        type="button"> 등록
										</button>
								</a></td>
							</tr>
						</tfoot>
					</table>
				</form>
			</div>




			<nav aria-label="Page navigation" style="margin-left: auto;margin-right: auto;margin-top: 20px;margin-bottom: 10px;" >
				<ul class="inline-flex space-x-2">
					<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
					<li>
						<c:if test="${articlePage.startPage gt 5}">
							<a href="/taskDiary/list?currentPage=${articlePage.startPage-5}"
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
								<button id="button-${pNo}" onclick="javascript:location.href='//taskDiary/list?currentPage=${pNo}';"
									class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
									style="background-color: #4E7DF4; color: white;"
									>${pNo}
								</button>
							</li>
						</c:if>
						
						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}" onclick="javascript:location.href='/taskDiary/list?currentPage=${pNo}';"
									class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color: #4E7DF4;"
									>${pNo}
								</button>
							</li>
						</c:if>
					</c:forEach>
					
					<!-- endPage < totalPages일 때만 [다음] 활성화 -->
					<li>
						<c:if test="${articlePage.endPage lt articlePage.totalPages}">
							<a href="/taskDiary/list?currentPage=${articlePage.startPage+5}"
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

	

</body>
</html>