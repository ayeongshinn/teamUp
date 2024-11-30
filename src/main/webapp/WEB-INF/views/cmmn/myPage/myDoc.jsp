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

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>

<script type="text/javascript">

$(document).ready(function() {
    $("#YSalBtn").click(function() {
		
		console.log("rPdirtj");
		
	    // 파일 경로 (파일을 열거나 다운로드할 파일의 경로)
		const fileUrl = "/resources/upload/2024/10/16/계약서.pdf"; // 웹 서버의 URL	
		console.log(fileUrl);
	    
	    // 파일을 새 창(탭)에서 열기
	    window.open(fileUrl, "_blank");
    });
});
$(function() {
	console.log("개똥이");
	//input type date 기간 제한
	var now_utc = Date.now() // 지금 날짜를 밀리초로
	var timeOff = new Date().getTimezoneOffset()*60000; // 분단위를 밀리초로 변환
	var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
	
	$("#startDate").attr("max", today);
	$("#endDate").attr("max", today);
	
//버튼 클릭 시 파일 열기
	
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
	
	
     
</style>
</head>
<body>
<div class="py-14">
	<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
	    <div class="w-full flex justify-between items-center mt-1 pl-3 mb-4">
	        <div style="margin-top: 30px; margin-bottom: 10px;">
	            <h3 class="text-lg font-semibold text-slate-800">
	            	<a href="/cmmn/myPage/myInfo">마이페이지</a>
	            </h3>
	            <p class="text-slate-500">나의 서류를 확인하세요</p>
	        </div>
		</div>
         <div class="flex justify-between mt-2">
		        <div class="flex justify-start items-end"> 
			        <button style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/myInfo'" class="listMoveBtn " type="button">
							<p>&ensp;나의 정보</p>
					</button>
<%-- 					<button style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/showAttend?empNo=${empVO.empNo}'" class="listMoveBtn" type="button"> --%>
<!-- 							<p>&ensp;근태조회</p> -->
<!-- 					</button>	 -->
					
					<button  style="border-radius: 5px 5px 0px 0px; height: 50px;" onclick="location.href='/cmmn/myPage/myVacation?empNo=${empVO.empNo}'" class="listMoveBtn" type="button">
							<p>&ensp;휴가 관리</p>
					</button>
						
					<button style="border-radius: 5px 5px 0px 0px; border-top: 6px solid #4E7DF4; transform: scale(1.01);" onclick="location.href='/cmmn/myPage/myDoc?empNo=${empVO.empNo}'" class="listMoveBtn" type="button">
							<p>&ensp;내 서류</p>
					</button>
				</div>
				<div class="flex justify-between">
				  <form id="searchForm">
				    <div class="flex justify-end space-x-3 mt-2">
				      <!-- 기간 검색 필드 추가 -->
				      <div class="flex items-center space-x-2">
				        <label for="startDate" class="text-gray-700" style="width: 230px; margin: 0px;">명세서 일자</label>
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
				<div class="card-body table-responsive mb-2 p-0">		
				   <div class="flex flex-col justify-end items-center mr-30 ml-30">
				      <div class="flex flex-col mx-auto w-full">
					</div>
				</div>
	            <table style="text-align:center;"class="table table-hover  text-nowrap">
	               <thead style="position: sticky; top: 0; background: white; z-index: 10;">
						<tr>
							<th><span class="text">번호</span></th>
							<th><span class="text">제목</span></th>
							<th><span class="text">총지급&nbsp;(원)</span></th>
							<th><span class="text">총공제&nbsp;(원)</span></th>
							<th><span class="text">실수령&nbsp;(원)</span></th>
							<th><span class="text">일자</span></th>
						</tr>
				   </thead>
	               <tbody id="tby">
		               <!-- 검색 결과가 없을 때 -->
		               <c:if test="${empty salaryDetailsDocVOList}">
		               	<tr>
		               		<td colspan="5" style="text-align: center; font-weight: bold; color: #848484;">
		               			데이터가 존재하지 않습니다
		               		</td>
		               	</tr>
		               </c:if>
	                  <c:forEach var="salaryDetailsDocVO" items="${salaryDetailsDocVOList}"  varStatus="status">
						
						<tr> 
							<td>
								<c:if test="${salaryDetailsDocVO.trgtDt=='202409'}">9</c:if>	
		              			<c:if test="${salaryDetailsDocVO.trgtDt=='202410'}">10</c:if>	
							</td>
							<td><a href="/salaryDetails/docPopUp?empNo=${empVO.empNo}&trgtDt=${salaryDetailsDocVO.trgtDt}" onclick="window.open(this.href,'salaryDetailsDoc','width=950, height=500');return false;">${salaryDetailsDocVO.trgtYear}년 ${salaryDetailsDocVO.trgtMonth}월 급여명세서</a></td>
							<td><fmt:formatNumber value="${salaryDetailsDocVO.totGiveAmt}" type="number"/></td>
							<td><fmt:formatNumber value="${salaryDetailsDocVO.totDdcAmt}" type="number"/></td>
							<td><fmt:formatNumber value="${salaryDetailsDocVO.realRecptAmt}" type="number"/></td>
							<td>
								<c:if test="${salaryDetailsDocVO.trgtDt=='202409'}">2024.09.05</c:if>	
		              			<c:if test="${salaryDetailsDocVO.trgtDt=='202410'}">2024.10.05</c:if>	
		              		</td>
						</tr>
					</c:forEach>
						
						<tr> 
							<td>8</td>
							<td>2024년 8월 급여명세서</td>
							<td>6,100,000</td>
							<td>1,093,190</td>
							<td>5,006,810</td>
							<td>2024.08.05</td>
						</tr>
						<tr> 
							<td>7</td>
							<td>2024년 7월 급여명세서</td>
							<td>6,100,000</td>
							<td>1,093,190</td>
							<td>5,006,810</td>
							<td>2024.07.05</td>
						</tr>
						<tr> 
							<td>6</td>
							<td>2024년 6월 급여명세서</td>
							<td>6,100,000</td>
							<td>1,093,190</td>
							<td>5,006,810</td>
							<td>2024.06.05</td>
						</tr>
						<tr> 
							<td>5</td>
							<td>2024년 5월 급여명세서</td>
							<td>6,100,000</td>
							<td>1,093,190</td>
							<td>5,006,810</td>
							<td>2024.05.05</td>
						</tr>
						<tr> 
							<td>4</td>
							<td>2024년 4월 급여명세서</td>
							<td>6,100,000</td>
							<td>1,093,190</td>
							<td>5,006,810</td>
							<td>2024.04.05</td>
						</tr>
						<tr> 
							<td>3</td>
							<td>2024년 3월 급여명세서</td>
							<td>6,100,000</td>
							<td>1,093,190</td>
							<td>5,006,810</td>
							<td>2024.03.05</td>
						</tr>
						<tr> 
							<td>2</td>
							<td>2024년 2월 급여명세서</td>
							<td>6,100,000</td>
							<td>1,093,190</td>
							<td>5,006,810</td>
							<td>2024.02.05</td>
						</tr>
						<tr> 
							<td>1</td>
							<td>2024년 1월 급여명세서</td>
							<td>6,100,000</td>
							<td>1,093,190</td>
							<td>5,006,810</td>
							<td>2024.01.05</td>
						</tr>
	               </tbody>
	            </table>
	         </div>
	         <nav aria-label="Page navigation" style="margin-left: auto;margin-right: auto;margin-top: 30px;margin-bottom: 30px;" >
				<ul class="inline-flex space-x-2">
					<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
						<c:if test="${articlePage.startPage gt 5}">
							<a href="/cmmn/myPage/myVacation?currentPage=${articlePage.startPage-5}&&empNo=${empVO.empNo}"
								class="flex items-center justify-center w-10 h-10  transition-colors duration-150 rounded-full focus:shadow-outline ">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
									<path d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
								</svg>
							</a>
						</c:if>
					</li>
					
					
					<li>
						<button id="button-${pNo}" onclick="javascript:location.href='/cmmn/myPage/myVacation?currentPage=${pNo}&&empNo=${empVO.empNo}';"
							class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
							style="background-color: #4E7DF4; color: white;"
							>1
						</button>
					</li>
					
					
					<!-- endPage < totalPages일 때만 [다음] 활성화 -->
					<li>
						<c:if test="${articlePage.endPage lt articlePage.totalPages}">
							<a href="/cmmn/myPage/myVacation?currentPage=${articlePage.startPage+5}&&empNo=${empVO.empNo}"
								class="flex items-center justify-center w-10 h-10  transition-colors duration-150 rounded-full focus:shadow-outline ">
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
</div>	
</body>
</html>