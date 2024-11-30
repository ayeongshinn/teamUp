<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<!-- 로고 수정중입니다 ㅜㅜㅜ -->

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
   
   .aHover:hover {
	    font-weight: bold;
	    color: #4E7DF4;
	}
	
  #hometax:hover {
    color: #4E7DF4;
    text-decoration: underline;
  }
</style>

<script type="text/javascript">
$(document).ready(function(){
	// 로컬 스토리지에 저장된 값이 있는지 확인
    let savedTrgtDate = localStorage.getItem('trgtDate');
    let savedTrgtDt = localStorage.getItem('trgtDt');

    // 로컬 스토리지에 값이 없으면 오늘 날짜로 기본 값 설정
    if (!savedTrgtDate || !savedTrgtDt) {
        const today = new Date();
        const year = today.getFullYear();
        const month = ('0' + (today.getMonth() + 1)).slice(-2);
        savedTrgtDate = year + '-' + month;
        savedTrgtDt = year + month;

        // 로컬 스토리지에 저장
        localStorage.setItem('trgtDate', savedTrgtDate);
        localStorage.setItem('trgtDt', savedTrgtDt);
    }

    // 페이지에 저장된 값을 설정
    $('#trgtDate').val(savedTrgtDate);
    $('#trgtDt').val(savedTrgtDt);

    // 사용자가 값을 변경할 때 로컬 스토리지에 저장
    $('#trgtDate').on('change', function() {
        const newTrgtDate = $(this).val();
        const newTrgtDt = newTrgtDate.replace('-', '');

        // 값 업데이트 및 로컬 스토리지에 저장
        $('#trgtDt').val(newTrgtDt);
        localStorage.setItem('trgtDate', newTrgtDate);
        localStorage.setItem('trgtDt', newTrgtDt);
    });
	
	$('#salaryRegist').on('click', function(){
		location.href = 'http://localhost/salaryDetails/regist';
	})
	
	$('.salaryDetailPopUp').on('click', function(){
	    empNo = $(this).data('empno');
	    trgtDt = $('#trgtDt').val();
	    console.log(empNo);
	    console.log("trgtDt : ", trgtDt);
	    
	    var popupOptions = "width=850,height=900,scrollbars=yes,resizable=yes";
	    window.open('/salaryDetails/docPopUp?empNo=' + empNo +'&trgtDt=' + trgtDt , 'salaryDetailWindow', popupOptions);
	});

	$("#hometax").on("click", function(){
		window.location.href = '/resources/upload/excel/2024년_근로소득_간이세액표(조견표).xlsx';
	});
})
</script>

<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
	<div class="w-full flex justify-between items-center pl-3 mb-3">
	    <div style="margin-top: 30px;">
	        <h3 class="text-lg font-semibold text-slate-800">
	        	<a href="/salaryDetails/list">급여명세서 관리</a>
        	</h3>
	        <p class="text-slate-500">직원들의 급여명세서를 쉽고 안전하게 확인하고 배포하세요</p>
	    </div>
	    <div class="flex items-center space-x-3 mt-2 pt-4">
	        <!-- 버튼 -->
	        <button id="salaryRegist" type="button" style="background-color:#4E7DF4"
				class="text-white font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150">
				등록
			</button>
	    </div>
	</div>

	<!-- 사원 관련 stats -->
	<div class="p-2 bg-white rounded-2xl border border-gray-50 mb-1 relative">
	    <div class="flex justify-between">
	        <div class="flex flex-col items-center w-1/5 text-center relative">
	            <img class="h-14 w-16 object-contain mt-2" src="/resources/images/logo/국민연금로고.png">
	            <p class="text-gray-900 text-bold pb-1">국민연금</p>
	            <p class="text-gray-500 text-sm">기준 소득월액 전체 9%</p>
	            <p class="text-gray-500 text-sm">근로자 4.5%</p>
	            <p class="text-gray-500 text-sm pb-2">사업주 4.5%</p>
	            <div class="absolute right-0 border-r border-gray-300" style="top: 15%; height: 70%;"></div>
	        </div>
	        <div class="flex flex-col items-center w-1/5 text-center relative">
	            <img class="h-14 w-16 object-contain mt-2" src="/resources/images/logo/국민건강보험로고.png">
	            <p class="text-gray-900 text-bold pb-1">건강보험료</p>
	            <p class="text-gray-500 text-sm">보수월액 보험료율 7.09%</p>
	            <p class="text-gray-500 text-sm">근로자 부담률 50%</p>
	            <p class="text-gray-500 text-sm pb-2">사업주 부담률 50%</p>
	            <div class="absolute right-0 border-r border-gray-300" style="top: 15%; height: 70%;"></div>
	        </div>
	        <div class="flex flex-col items-center w-1/5 text-center relative">
	            <img class="h-14 w-16 object-contain mt-2" src="https://www.work24.go.kr/cm/static/images/bi106_32.svg" alt="고용보험" border="0">
	            <p class="text-gray-900 text-bold pb-1">고용보험</p>
	            <p class="text-gray-500 text-sm">근로자 0.9%</p>
	            <p class="text-gray-500 text-sm">150인 미만 0.25%</p>
	            <p class="text-gray-500 text-sm pb-2">150인 이상 0.65%</p>
	            <div class="absolute right-0 border-r border-gray-300" style="top: 15%; height: 70%;"></div>
	        </div>
	        <div class="flex flex-col items-center w-1/5 text-center relative">
	            <img class="h-14 w-16 object-contain mt-2" src="/resources/images/logo/근로복지공단로고.jpg">
	            <p class="text-gray-900 text-bold pb-1">산재보험</p>
	            <p class="text-gray-500 text-sm">보수총액(월평균보수)</p>
	            <p class="text-gray-500 text-sm pb-2">× 보험료율 ÷ 1,000</p>
	            <div class="absolute right-0 border-r border-gray-300" style="top: 15%; height: 70%;"></div>
	        </div>
	        <div class="flex flex-col items-center w-1/5 text-center">
	            <img class="h-14 w-16 object-contain mt-2" src="/resources/images/logo/국세청로고.png">
	            <p class="text-gray-900 text-bold pb-1">근로소득세</p>
	            <p class="text-gray-500 text-sm">근로자는 간이세액표에 따른</p>
	            <p class="text-gray-500 text-sm">세액의 비율(80%, 100%, 120%)</p>
	            <p id="hometax" class="text-gray-500 text-sm pb-2" style="cursor:pointer;">(근로소득_간이세액표)</p>
	        </div>
	    </div>
	</div>
	<!-- stats 끝 -->
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	<!-- 검색 area 수정 -->
	<div class="flex justify-end mb-2">
		<form id="searchForm">
			<div class="flex justify-end mt-2">
				<!-- 입사일자 필드 추가 -->
				<div class="flex items-center mx-1">
					<label for="jncmpStart" class="block mb-2 pt-2 text-sm font-medium text-gray-900 dark:text-gray-300">급여 날짜</label>
					<input type="month" id="trgtDate"
						class="px-2 py-2 mx-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" />
					<input type="hidden" id="trgtDt" name="trgtDt" value="${param.trgtDt.replace('-', '')}"//>
				</div>
				
				<!-- 검색 조건 필드 -->
				<div class="relative mx-1">
					<select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
						<option value="all" ${param.searchField == 'all' ? 'selected' : ''}>전체</option>
						<option value="dept" ${param.searchField == 'dept' ? 'selected' : ''}>부서</option>
						<option value="jbgd" ${param.searchField == 'jbgd' ? 'selected' : ''}>직급</option>
						<option value="empNm" ${param.searchField == 'empNm' ? 'selected' : ''}>사원</option>
					</select>
				</div>
				
				<!-- 검색 필드 및 버튼 -->
				<div>
					<div class="w-full max-w-sm min-w-[200px] relative mx-1 px-1">
						<div class="relative">
							<input type="text" name="keyword"
								class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
								placeholder="검색어를 입력하세요."
								value="${param.keyword != null ? param.keyword : ''}" />
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
	
	<!-- 급여 명세서 리스트 -->
    <div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border py-2">
    	<p class="text-right text-sm font-thin text-gray-700 mr-4 mt-2">단위 (원)</p>
	    <div class="card-body table-responsive p-0">
				<table class="table table-hover text-nowrap" style="text-align: center;">
					<thead>
						<tr>
							<th>사원 번호</th>
							<th>사원 명</th>
							<th>부서</th>
							<th>직급</th>
							<th>지급액</th>
							<th>공제액</th>
							<th>실수령액</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="salaryDetailVO" items="${salaryDetailsDocVOList}">
							<tr>
								<td>${salaryDetailVO.trgtEmpNo}</td>
								<td class="salaryDetailPopUp aHover" data-empno="${salaryDetailVO.trgtEmpNo}">
									<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
									${fn:replace(salaryDetailVO.trgtEmpNm, param.keyword, word )}
								</td>
								<td>
									<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
									${fn:replace(salaryDetailVO.deptNm, param.keyword, word )}
								</td>
								<td>
									<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
									${fn:replace(salaryDetailVO.jbgdNm, param.keyword, word )}
								</td>
								<td data-value="${salaryDetailVO.totGiveAmt}">
								   <fmt:formatNumber value="${salaryDetailVO.totGiveAmt}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetailVO.totDdcAmt}">
								   <fmt:formatNumber value="${salaryDetailVO.totDdcAmt}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetailVO.realRecptAmt}">
								   <fmt:formatNumber value="${salaryDetailVO.realRecptAmt}" type="number" groupingUsed="true"/>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
	    
	    <c:if test="${articlePage.total == 0 }">
	    	<p style="margin: 40px; text-align: center;">데이터가 존재하지 않습니다.</p>
	    </c:if>
	    
	    <c:if test="${articlePage.total != 0 }">
			<nav aria-label="Page navigation" style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
			    <ul class="inline-flex space-x-2">
			        <!-- startPage가 5보다 클 때만 [이전] 활성화 -->
			        <li>
			            <c:if test="${articlePage.startPage gt 5}">
			                <a href="/salaryDetails/list?currentPage=${articlePage.startPage-5}&keyword=${param.keyword}&trgtDt=${param.trgtDt}&searchField=${param.searchField}" style="color:#4E7DF4"
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
			                    <button id="button-${pNo}" onclick="javascript:location.href='/salaryDetails/list?currentPage=${pNo}&keyword=${param.keyword}&trgtDt=${param.trgtDt}&searchField=${param.searchField}';"
			                            class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
			                            style="background-color:#4E7DF4">${pNo}
			                    </button>
			                </li>
			            </c:if>
			
			            <c:if test="${articlePage.currentPage != pNo}">
			                <li>
			                    <button id="button-${pNo}" onclick="javascript:location.href='/salaryDetails/list?currentPage=${pNo}&keyword=${param.keyword}&trgtDt=${param.trgtDt}&searchField=${param.searchField}';"
			                            class="w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
			                            style="color:#4E7DF4">${pNo}
			                    </button>
			                </li>
			            </c:if>
			        </c:forEach>
			
			        <!-- endPage < totalPages일 때만 [다음] 활성화 -->
			        <li>
			            <c:if test="${articlePage.endPage lt articlePage.totalPages}">
			                <a href="/salaryDetails/list?currentPage=${articlePage.startPage + 5}&keyword=${param.keyword}&trgtDt=${param.trgtDt}&searchField=${param.searchField}" style="color:#4E7DF4"
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

