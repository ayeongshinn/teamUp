
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
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>
<script>
	
	var empNo = "${empVO.empNo}";
	
	$(function() {
		
		//대시보드 - 내가 작성한 게시글 불러오기
		$("#myNoticesElement").on("click", function() {
			window.location.href = "/noticeListN?myNoticeList=true";
		});

		//테이블 헤더의 [상태]가 변경되면 실행
		$("#statusSelect").on("change",function(){
			$("#statusForm").submit();
		});
		
		console.log("개똥이");
		
		//input type date 기간 제한
		var now_utc = Date.now() //지금 날짜를 밀리초로
		var timeOff = new Date().getTimezoneOffset()*60000; // 분단위를 밀리초로 변환
		var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
		
		$("#startDate").attr("max", today);
		$("#endDate").attr("max", today);
		
		//숫자 카운팅 애니메이션
		$("[countTo]").each(function() {
		    var $this = $(this);
		    var ID = $this.attr("id");
		    var value = $this.attr("countTo");
		    var decimalPlaces = $this.data("decimal");

		    var options = {};
		    if (decimalPlaces) {
		        options.decimalPlaces = 1;
		    }

		    var countUp = new CountUp(ID, value, options);

		    if (!countUp.error) {
		        countUp.start();
		    } else {
		        console.error(countUp.error);
		        $this.html(value);
		    }
		});
	});
	
	$(document).ready(function() {
		$(".truncate-text").each(function() {
	        var text = $(this).text().trim();
	        var maxLength = 50; //원하는 글자 수 설정
	        
	        if(text.length > maxLength) {
	            $(this).text(text.substring(0, maxLength) + '...');
	        }
	    });
	})

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
	
	.bg-indigo-500 {
	  background-color: #4E7DF4;
	}
	
	mark {
		background: #ff0; !important;
		color: #000; !important;
	}
	
	svg {
		color: #4E7DF4;
	}
	
	#wCntElement {
		cursor: pointer;
	}
	
	#wCntElement:hover {
		color: #4E7DF4;
	}
	
	#myNoticesElement {
		cursor: pointer;
	}
	
	#myNoticesElement:hover {
		color: #4E7DF4;
	}
	
</style>
</head>
<body>
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
    <div class="w-full flex justify-between items-center mt-1 pl-3">
        <div style="margin-top: 30px; margin-bottom: 10px;">
            <h3 class="text-lg font-semibold text-slate-800">
            	<a href="/noticeListN">공지사항 관리</a>
            </h3>
            <p class="text-slate-500">다양한 사내 소식을 관리하세요</p>
        </div>
	</div>
	<!-- 대시보드 -->
   <div class="flex flex-col justify-center items-center">
      <div class="w-full mt-4 mb-2 grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-2 2xl:grid-cols-2 3xl:grid-cols-2">
         
         <div class="p-3 relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
            <div class="ml-[18px] flex w-auto flex-row items-center">
               <div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
                  <span class="flex items-center text-brand-500 dark:text-white">
                    <svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 512 512" class="h-10 w-10" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
                           <path d="M298.39 248a4 4 0 002.86-6.8l-78.4-79.72a4 4 0 00-6.85 2.81V236a12 12 0 0012 12z"></path>
                           <path d="M197 267a43.67 43.67 0 01-13-31v-92h-72a64.19 64.19 0 00-64 64v224a64 64 0 0064 64h144a64 64 0 0064-64V280h-92a43.61 43.61 0 01-31-13zm175-147h70.39a4 4 0 002.86-6.8l-78.4-79.72a4 4 0 00-6.85 2.81V108a12 12 0 0012 12z"></path>
                           <path d="M372 152a44.34 44.34 0 01-44-44V16H220a60.07 60.07 0 00-60 60v36h42.12A40.81 40.81 0 01231 124.14l109.16 111a41.11 41.11 0 0111.83 29V400h53.05c32.51 0 58.95-26.92 58.95-60V152z"></path>
                    </svg>
                  </span>
               </div>
            </div>
            <div class="h-50 ml-4 flex w-auto flex-col justify-center">
               <p class="font-dm text-sm font-medium text-gray-600 mb-2">대기 중인 게시글</p>
               <a href="/noticeListN?status=W">
               	<h4 class="text-xl font-bold text-navy-700" id="wCntElement" countTo="${wCnt}"></h4>
               </a>
            </div>
         </div>
         
         <div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
            <div class="ml-[18px] flex h-[90px] w-auto flex-row items-center">
               <div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
                  <span class="flex items-center text-brand-500 dark:text-white">
                     <i class="fa-solid fa-pencil fa-2xl" style="color: #4E7DF4;"></i>
                  </span>
               </div>
            </div>
            <div class="h-50 ml-4 flex w-auto flex-col justify-center">
               <p class="mb-2 font-dm text-sm font-medium text-gray-600">내가 작성한 게시글</p>
               <h4 class="text-xl font-bold text-navy-700" id="myNoticesElement" countTo="${myNotices}"></h4>
            </div>
         </div>
      </div>
		</div>
		
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
		
    <div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border mb-4">
       <div class="card-body table-responsive p-0">
            <table style="text-align:center;"class="table table-hover text-nowrap">
               <thead>
                  <tr>
                     <th>번호</th>
                     <th> </th>
                     <th>제목</th>
                     <th>작성자</th>
                     <th>등록일</th>
                     <th>
                     	<form id="statusForm" action="/noticeListN" method="get">
						    <select name="status" id="statusSelect">
						        <option value="all" ${param.status == 'all' ? 'selected' : ''}>상태</option>
						        <option value="W" ${param.status == 'W' ? 'selected' : ''}>대기</option>
						        <option value="Y" ${param.status == 'Y' ? 'selected' : ''}>승인</option>
						        <option value="N" ${param.status == 'N' ? 'selected' : ''}>반려</option>
						    </select>
						</form>
                     </th>
                  </tr>
               </thead>
               <tbody id="tby">
               <!-- 검색 결과가 없을 때 -->
               <c:if test="${empty noticeVOList}">
               	<tr>
               		<td colspan="6" style="text-align: center; font-weight: bold; color: #848484;">
               			데이터가 존재하지 않습니다
               		</td>
               	</tr>
               </c:if>
                  <c:forEach var="noticeVO" items="${noticeVOList}">
                     <tr>
                        <td>${noticeVO.rnum2}</td>
                        <td style="text-align: center;">
                        	<c:if test="${noticeVO.fileGroupNo != null and noticeVO.fileGroupNo != '' and noticeVO.fileGroupNo != 0}">
								<img alt="clipIcon" src="/resources/images/clipIcon.png" class="h-[16px]"
								  style="vertical-align: middle; display: inline;">
							</c:if>
                        </td>
                        <td style="text-align: left;">
                        	<a href="/noticeDetailN?ntcNo=${noticeVO.ntcNo}" style="text-decoration:none; color: inherit; display:inline;">
                        		<c:choose>
                        			<c:when test="${noticeVO.imprtncYn == 'Y'}">
                        				<span style="color: #848484; font-weight: bold;">[중요]</span>
                        			</c:when>
                        			<c:when test="${noticeVO.imprtncYn == 'N'}">
                        				<span style="color: #848484; font-weight: bold;">[일반]</span>
                        			</c:when>
                        		</c:choose>
                        		<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
                        		<span class="truncate-text">
	                        		<c:out value="${fn:replace(noticeVO.ntcTtl, param.keyword, word )}" escapeXml="false"/>
                        		</span>
                        	</a>
                        </td>
                        <td>${noticeVO.empNm}</td>
                        <td><fmt:formatDate pattern="yyyy.MM.dd" value="${noticeVO.regDt}"/></td>
                        <td>
                        	<c:if test="${noticeVO.aprvYn == 'Y'}">
                        		<span class="relative inline-block px-3 py-1 font-semibold leading-tight">
						            <span aria-hidden class="absolute inset-0 opacity-10 rounded-full" style="background-color: #4E7DF4;"></span>
						            <span class="relative" style="color: #4E7DF4;">승인</span>
						        </span>
                        	</c:if>
                        	<c:if test="${noticeVO.aprvYn == 'N'}">
                        		<span class="relative inline-block px-3 py-1 font-semibold text-red-900 leading-tight">
                                        <span aria-hidden class="absolute inset-0 bg-red-200 opacity-50 rounded-full"></span>
										<span class="relative">반려</span>
								</span>
                        	</c:if>
                        	<c:if test="${noticeVO.aprvYn == 'W'}">
                        		<span class="relative inline-block px-3 py-1 font-semibold text-dark-900 leading-tight">
                                        <span aria-hidden class="absolute inset-0 bg-gray-200 opacity-50 rounded-full"></span>
										<span class="relative">대기</span>
								</span>
                        	</c:if>
                        </td>
                     </tr>
                  </c:forEach>
               </tbody>
               <tfoot>
						<tr>
							<td colspan="7" style="text-align: right;">
								<a href="/registForm">
									<button class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									        type="button">
									    등록
									</button>	    
								</a>
							</td>
						</tr>
					</tfoot>
            </table>
         </div>
       
		<nav aria-label="Page navigation" style="margin-left: auto;margin-right: auto;margin-top: 20px;margin-bottom: 10px;" >
			<ul class="inline-flex space-x-2">
				<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
				<li>
					<c:if test="${articlePage.startPage gt 5}">
						<a href="/noticeListN?currentPage=${articlePage.startPage-5}"
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
							<button id="button-${pNo}" onclick="javascript:location.href='/noticeListN?currentPage=${pNo}';"
								class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
								style="background-color: #4E7DF4; color: white;"
								>${pNo}
							</button>
						</li>
					</c:if>
					
					<c:if test="${articlePage.currentPage != pNo}">
						<li>
							<button id="button-${pNo}" onclick="javascript:location.href='/noticeListN?currentPage=${pNo}';"
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
						<a href="/noticeListN?currentPage=${articlePage.startPage+5}"
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