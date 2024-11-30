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
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<title></title>
<style>
		.nav-button {
        background-color: white; /* 기본 배경색 */
        color: black; /* 기본 글자색 */
        border: none; /* 테두리 없애기 */
        padding: 10px 20px; /* 여백 */
        border-radius: 5px; /* 모서리 둥글게 */
        cursor: pointer; /* 마우스 커서 변경 */
        transition: background-color 0.3s, color 0.3s; /* 호버 효과를 부드럽게 */
	}
	.nav-button:hover {
	    background-color: #4E7DF4; /* 호버 시 배경색 하얀색으로 변경 */
	    color: white; /* 호버 시 글자색 검정색으로 변경 */
	}
	
	
     
</style>
</head>
<body>
	<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
	
	    <div class="w-full flex justify-between items-center mt-1 pl-3">
	        <div style="margin-top: 30px; margin-bottom: 10px;">
	            <h3 class="text-lg font-semibold text-slate-800">
	            	<a href="/noticeListN">마이페이지</a>
	            </h3>
	            <p class="text-slate-500">근태조회</p>
	        </div>
		</div>
        <div style="display: flex;">
        <button onclick="location.href='/cmmn/myPage/myInfoSecu?empNo=${empVO.empNo}'" class="nav-button " type="button">
				<p>&ensp;나의 정보</p>
		</button>
		
		<button  style="background-color:#4E7DF4;color: white; " onclick="location.href='/cmmn/myPage/showAttend?empNo=${empVO.empNo}'" class="nav-button" type="button">
				<p>&ensp;근태조회</p>
		</button>	
		
		<button onclick="location.href='/cmmn/myPage/myVacation?empNo=${empVO.empNo}'" class="nav-button" type="button">
				<p>&ensp;휴가 관리</p>
		</button>
			
		<button onclick="location.href='/cmmn/myPage/myDoc?empNo=${empVO.empNo}'" class="nav-button" type="button">
				<p>&ensp;내 서류</p>
		</button>
        </div>
		<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border mb-4">
		<!-- 대시보드 -->
	   <div class="flex flex-col justify-center items-center mr-30 ml-30">
	      <div class="flex flex-col mx-auto w-full">
			<div class="w-full draggable">
				<div class="flex flex-col items-center gap-16 mx-auto my-4">
					<div class="grid grid-cols-5 gap-4 w-full pr-3 pl-3">
						<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] b order-gray-200  bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="background-color:#4E7DF4">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								${countTeamEmp} 명
								
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">종 팀원</p>
						</div>
						
						<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200  bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="background-color:#4E7DF4">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								${countAttendEmp} 명
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">출근인원</p>
						</div>
						
						<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200  bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="background-color:#4E7DF4">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								${countNotAttendEmp} 명
								
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">미출근인원</p>
						</div>
						
						<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200  bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="background-color:#4E7DF4">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								${vacationEmp} 명
								
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">휴가인원</p>
						</div>
						
						<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200  bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="background-color:#4E7DF4">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								${busiTripEmp} 명
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">출장인원</p>
						</div>
					</div>
				</div>
			</div>
		</div>
		</div>
			
			
	    
	       <div class="card-body table-responsive p-10">
<%-- 	       <p>${formattedList}</p> --%>
<!-- 	       <div class="flex-grow mt-2 mb-2"> -->
<!-- 			  	<button class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150" -->
<!-- 				        style="box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);" -->
<%-- 				        type="button" onclick="location.href='/cmmn/myPage/teamAttend?empNo=${empVO.empNo}&&deptCd=${empVO.deptCd}'"> --%>
<!-- 				    팀원 출퇴근 조회 -->
<!-- 				</button>	 -->
<!-- 			 </div> -->
	       <form id="selectStatus">
	            <table style="text-align:center;"class="table table-hover text-nowrap">
	               <thead style="position: sticky; top: 0; background: white; z-index: 10;">
						<tr>
							<th><span class="text">사원명</span></th>
							<th><span class="text">직급</span></th>
							<th><span class="text">출근시간</span></th>
							<th><span class="text">퇴근시간</span></th>
							<th><span class="text">상태</span></th>
						</tr>
				   </thead>
	               <tbody id="tby">
	               	
		               <!-- 검색 결과가 없을 때 -->
		               <c:if test="${empty formattedList}">
		               	<tr>
		               		<td colspan="5" style="text-align: center; font-weight: bold; color: #848484;">
		               			데이터가 존재하지 않습니다
		               		</td>
		               	</tr>
		               </c:if>
	                  <c:forEach var="attendVO" items="${formattedList}">
						<tr> 
							<td>${attendVO.empNm}</td>
							<td>${attendVO.jbgdNm}</td>
							<td>
								<c:if test="${attendVO.attendTm=='0'}"> - </c:if>
								<c:if test="${attendVO.attendTm!='0'}">${attendVO.attendTm}</c:if>
							</td>
							<td>
								<c:if test="${attendVO.lvffcTm=='0'}"> - </c:if>
								<c:if test="${attendVO.lvffcTm!='0'}">${attendVO.lvffcTm}</c:if>
							</td>
							<td>${attendVO.empSttusNm}</td>
						</tr>
					</c:forEach>
	               </tbody>
	            </table>
	            </form>
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
							<a href="#=${articlePage.startPage+5}"
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