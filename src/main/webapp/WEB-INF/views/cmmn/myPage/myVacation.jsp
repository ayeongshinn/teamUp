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
<script type="text/javascript">
$(function(){
	
		console.log("qwe");
		$(function() {
			console.log("개똥이");
			//input type date 기간 제한
			var now_utc = Date.now() // 지금 날짜를 밀리초로
			var timeOff = new Date().getTimezoneOffset()*60000; // 분단위를 밀리초로 변환
			var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
			
			$("#startDate").attr("max", today);
			$("#endDate").attr("max", today);
			
			
		});
	
	$("#statusSelect").on("click",function() {

		
		
		let startDate = $("#startDate").val();
		let endDate = $("#endDate").val();
		let empNo = ${empVO.empNo}

		console.log("sdsds");
		console.log(empNo);
		
		location.href = "/cmmn/myPage/myVacation?empNo="+ empNo+ "&&startDate="+ startDate+ "&&endDate="+ endDate;
	});
});

</script>
<title></title>
<style>
	.listMoveBtn {
		background-color: white;
		color: black;
		padding: 0px 25px;
		height: 56px;
		border-bottom: 1px solid #dee2e6;
		box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
	}
	.nav-button:hover {
	    background-color: #4E7DF4; /* 호버 시 배경색 하얀색으로 변경 */
	    color: white; /* 호버 시 글자색 검정색으로 변경 */
	}
	
	td {
		font-size: 15px;
	}
     
</style>
</head>
<body>
	<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 mb-3">
	    <div class="w-full flex justify-between items-center pl-3">
	       <div style="margin-top: 30px; margin-bottom: 10px;">
	            <h3 class="text-lg font-semibold text-slate-800">
	            	<a href="/cmmn/myPage/myInfo">마이페이지</a>
	            </h3>
	            <p class="text-slate-500">나의 휴가정보를 확인하세요</p>
	        </div>
			</div>
			<!-- 대시보드 -->
		    <div class="flex flex-col justify-center items-center">
       			<div class="w-full mt-3 mb-3 grid grid-cols-1 gap-5 md:grid-cols-5 lg:grid-cols-5 2xl:grid-cols-5 3xl:grid-cols-5">
					
					<div class="relative approval-card flex flex-grow !flex-row flex-col items-center justify-center rounded-[10px] bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); height: 100px;">
					    <div class="h-50 flex w-auto flex-col justify-center items-center">
					        <h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
					            ${HrVacationVO.bscVcatnDayCnt} 개
					        </h5>
					        <p class="text-base font-medium leading-7 text-center text-dark-grey-600">기본 휴가</p>
					    </div>
					</div>
					
					<div class="relative approval-card flex flex-grow !flex-row flex-col items-center justify-center rounded-[10px] bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); height: 100px;">
					    <div class="h-50 flex w-auto flex-col justify-center items-center">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								${HrVacationVO.grntVcatnDayCnt} 개
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">부여 휴가</p>
						</div>
					</div>
					
					<div class="relative approval-card flex flex-grow !flex-row flex-col items-center justify-center rounded-[10px] bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); height: 100px;">
					    <div class="h-50 flex w-auto flex-col justify-center items-center">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								${HrVacationVO.useVcatnDayCnt} 개
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">사용 휴가</p>
						</div>
					</div>
					
					<div class="relative approval-card flex flex-grow !flex-row flex-col items-center justify-center rounded-[10px] bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); height: 100px;">
					    <div class="h-50 flex w-auto flex-col justify-center items-center">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								${HrVacationVO.holdVcatnDayCnt} 개
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">보유 휴가</p>
						</div>
					</div>
					
					<div class="relative approval-card flex flex-grow !flex-row flex-col items-center justify-center rounded-[10px] bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); height: 100px;">
					    <div class="h-50 flex w-auto flex-col justify-center items-center">
							<h5 class="text-3xl font-extrabold leading-tight text-center text-dark-grey-900">
								49일
							</h5>
							<p class="text-base font-medium leading-7 text-center text-dark-grey-600">휴가 사용 가능일</p>
						</div>
					</div>
				
				</div>
			</div>
			
			
	        <div class="flex justify-between">
		        <div class="flex justify-start items-end"> 
			        <button style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/myInfo'" class="listMoveBtn " type="button">
							<p>&ensp;나의 정보</p>
					</button>
<%-- 					<button style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/showAttend?empNo=${empVO.empNo}'" class="listMoveBtn" type="button"> --%>
<!-- 							<p>&ensp;근태조회</p> -->
<!-- 					</button>	 -->
					
					<button  style="border-radius: 5px 5px 0px 0px; border-top: 6px solid #4E7DF4; transform: scale(1.01);" onclick="location.href='/cmmn/myPage/myVacation?empNo=${empVO.empNo}'" class="listMoveBtn" type="button">
							<p>&ensp;휴가 관리</p>
					</button>
						
					<button style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/myDoc?empNo=${empVO.empNo}'" class="listMoveBtn" type="button">
							<p>&ensp;내 서류</p>
					</button>
				</div>
				<div class="flex justify-between">
				  <form id="searchForm">
				    <div class="flex justify-end space-x-3 mt-2">
				      <!-- 기간 검색 필드 추가 -->
				      <div class="flex items-center space-x-2">
				        <label for="startDate" class="text-gray-700" style="width: 162px; margin: 0px;">신청 일자</label>
				        <input type="date" id="startDate" name="startDate" class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" value="" max="">
				        		
				        <span>-</span>
				        <input type="date" id="endDate" name="endDate" class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" value="" max="">		        				
				      </div>
				      <!-- 검색 필드 및 버튼 -->
				      <div>
				        <div class="w-full max-w-sm min-w-[30px] relative">
				          <div class="relative">
				            <button type="button" id="statusSelect" class="absolute h-8 w-8 right-1 top-1 my-auto px-2 flex items-center bg-white rounded">
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
			</div>
			
	    
	       <div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border" style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);">
			<div class="card-body table-responsive p-0">
<%-- 	       <p>${formattedList}</p> --%>
	            <table style="text-align:center;"class="table table-hover text-nowrap">
	               <thead>
						<tr>
							<th><span class="text">종류</span></th>
							<th><span class="text">제목</span></th>
							<th><span class="text">신청일</span></th>
							<th><span class="text">시작 날짜</span></th>
							<th><span class="text">종료 날짜</span></th>
							<th><span class="text">승인여부</span></th>
						</tr>
				   </thead>
	               <tbody>
		               <!-- 검색 결과가 없을 때 -->
		               <c:if test="${empty formattedList}">
		               	<tr>
		               		<td colspan="7" style="text-align: center; font-weight: bold; color: #848484;">
		               			데이터가 존재하지 않습니다
		               		</td>
		               	</tr>
		               </c:if>
	                  <c:forEach var="vacationDocVO" items="${formattedList}">
						<tr> 
							<td>
								<c:if test="${vacationDocVO.vcatnCd=='A22-001'}">연차</c:if>
								<c:if test="${vacationDocVO.vcatnCd=='A22-002'}">월차</c:if>
								<c:if test="${vacationDocVO.vcatnCd=='A22-003'}">반차</c:if>
								<c:if test="${vacationDocVO.vcatnCd=='A22-004'}">공가</c:if>
								<c:if test="${vacationDocVO.vcatnCd=='A22-005'}">병가</c:if>
								<c:if test="${vacationDocVO.vcatnCd=='A22-006'}">기타</c:if>
							</td>
							<td style="text-align: left;">${vacationDocVO.docTtl}</td>
							<td>${vacationDocVO.wrtYmd}</td>
							<td>${vacationDocVO.schdlBgngYmd}</td>
							<td>${vacationDocVO.schdlEndYmd}</td>
							<td>
								<c:if test="${vacationDocVO.atrzSttusCd=='A14-001'}">
									<span class="relative inline-block px-3 py-1 font-semibold leading-tight">
						            	<span aria-hidden class="absolute inset-0 opacity-10 rounded-full" style="background-color: #4E7DF4;"></span>
										<span class="relative" style="color: #4E7DF4;">승인</span>
									</span>
								</c:if>
								<c:if test="${vacationDocVO.atrzSttusCd=='A14-002'}">
									<span class="relative inline-block px-3 py-1 font-semibold text-red-900 leading-tight">
                                    	<span aria-hidden class="absolute inset-0 bg-red-200 opacity-50 rounded-full"></span>
										<span class="relative">반려</span>
									</span>
								</c:if>
								<c:if test="${vacationDocVO.atrzSttusCd=='A14-003'}">
									<span class="relative inline-block px-3 py-1 font-semibold text-dark-900 leading-tight">
                                        <span aria-hidden class="absolute inset-0 bg-gray-200 opacity-50 rounded-full"></span>
										<span class="relative">대기</span>
									</span>
								</c:if>
								<c:if test="${vacationDocVO.atrzSttusCd=='A14-004'}">
									<span class="relative inline-block px-3 py-1 font-semibold text-dark-900 leading-tight">
                                        <span aria-hidden class="absolute inset-0 bg-green-200 opacity-50 rounded-full"></span>
										<span class="relative">처리중</span>
									</span>
								</c:if>
							</td>
						</tr>
					</c:forEach>
	               </tbody>
	            </table>
	         </div>
	       
			<nav aria-label="Page navigation" style="margin-left: auto;margin-right: auto;margin-top: 15px;margin-bottom: 20px;" >
				<ul class="inline-flex space-x-2">
					<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
						<c:if test="${articlePage.startPage gt 5}">
							<a href="/cmmn/myPage/myVacation?currentPage=${articlePage.startPage-5}&&empNo=${empVO.empNo}"
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
								<button id="button-${pNo}" onclick="javascript:location.href='/cmmn/myPage/myVacation?currentPage=${pNo}&&empNo=${empVO.empNo}';"
									class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
									style="background-color: #4E7DF4; color: white;"
									>${pNo}
								</button>
							</li>
						</c:if>
						
						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}" onclick="javascript:location.href='/cmmn/myPage/myVacation?currentPage=${pNo}&&empNo=${empVO.empNo}';"
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
							<a href="/cmmn/myPage/myVacation?currentPage=${articlePage.startPage+5}&&empNo=${empVO.empNo}"
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