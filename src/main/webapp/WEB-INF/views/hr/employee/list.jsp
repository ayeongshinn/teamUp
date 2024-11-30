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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/motion-tailwind.css" rel="stylesheet">

<link rel="stylesheet" href="https://horizon-tailwind-react-corporate-7s21b54hb-horizon-ui.vercel.app/static/css/main.d7f96858.css" />

<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>
<script>
$(function(){
	
	$("#empRegist").on("click", function() {
	    // 첫 번째 팝업 창 설정
	    var popupOptions = "width=1400,height=700,scrollbars=yes,resizable=yes";
	    // 첫 번째 팝업 창 열기 (창 이름: empRegistWindow)
	    window.open('/employee/empRegistForm', 'empRegistWindow', popupOptions);
	});

	
	//stats 이벤트
	let numbers = document.querySelectorAll("[countTo]");

    numbers.forEach((number) => {
        let ID = number.getAttribute("id");
        let value = number.getAttribute("countTo");
        let countUp = new CountUp(ID, value);

        if (number.hasAttribute("data-decimal")) {
        const options = {
              decimalPlaces: 1,
            };
        countUp = new CountUp(ID, 2.8, options);
        } else {
        countUp = new CountUp(ID, value);
        }

        if (!countUp.error) {
        countUp.start();
        } else {
        console.error(countUp.error);
        number.innerHTML = value;
        }
    });
    
 	//사원 이름 클릭 이벤트 핸들러
    $('.open-detail-modal').click(function(event) {
        event.preventDefault(); // 기본 동작 방지

        let empNo = $(this).data('empno');
        
        // AJAX를 통해 empNo로 서버에 요청을 보냄
        $.ajax({
            url: "/employee/getDetail",
            data: { "empNo": empNo },
            type: "POST",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                $('#modalEmpName').text(response.empNm); // 사원명
                $('#modalEmpNo').text("( " + response.empNo + " )"); // 사원번호
                $('#modalDeptName').text(response.deptNm + ", " + response.jbgdNm); // 부서명
                $('#modalEmpEmail').text(response.empEmlAddr); // 이메일 주소
                $('#modalEmpTelno').text(response.empTelno.substring(0, 3) + "-" + response.empTelno.substring(3, 7) + "-" + response.empTelno.substring(7, 11)); // 전화번호
                $('#modalAddr').text(response.roadNmAddr + " " + response.daddr + " (" + response.roadNmZip + ")"); // 주소
                
                // 날짜 포맷이 필요할 경우 처리
                if (response.jncmpYmd) {
                    let formattedJoinDate = formatDate(response.jncmpYmd);
                    $('#modalJoinDate').text(formattedJoinDate); // 입사일자
                }

                if (response.empBrdt) {
                    let formattedBirthDate = formatDate(response.empBrdt);
                    $('#modalBirthDate').text(formattedBirthDate); // 생년월일
                }

                if (response.rsgntnYmd && response.delYn == 'Y') {
                    let formattedResignDate = formatDate(response.rsgntnYmd);
                    $('#modalResignStatus').text("퇴직 (" + formattedResignDate + ")"); // 퇴사 여부 및 퇴사일자
                } else {
                    $('#modalResignStatus').text("재직"); // 재직 상태
                }

                // 프로필 사진 (base64로 표시)
                if (response.proflPhoto) {
                    $('#modalProfilePhoto').attr('src', 'data:image/png;base64,' + response.proflPhoto);
                } else {
                    $('#modalProfilePhoto').attr('src', ''); // 기본 이미지가 없을 경우 처리
                }

                // 모달 열기
                $('#detailModal').modal('show');
            },
            error: function(xhr, status, error) {
                console.error("Error occurred: ", error);
            }
        });
    });
    
	//날짜 문자열을 포맷하는 함수
    function formatDate(dateStr) {
        // 'yyyyMMdd' 형식의 문자열을 'yyyy.MM.dd' 형식으로 변환
        return dateStr.substring(0, 4) + '.' + dateStr.substring(4, 6) + '.' + dateStr.substring(6, 8);
    }
	
})
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
   
   	.aHover:hover {
	    font-weight: bold;
	    color: #4E7DF4;
	}
</style>

<!-- 사내 전 사원 목록 :: 장영원 -->
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 ">
	<div class="w-full flex justify-between items-center pl-3">
	    <div style="margin-top: 30px;">
	        <h3 class="text-lg font-semibold text-slate-800">
            	<a href="/employee/list">사원 관리</a>
            </h3>
	        <p class="text-slate-500">직원 정보를 한눈에 관리하고 업데이트하세요</p>
	    </div>
	    <div class="flex items-center space-x-3 mt-2 pt-4">
	        <!-- 버튼 -->
	        <button id="empRegist" type="button" style="background-color:#4E7DF4"
				class="text-white font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
				>사원 등록</button>
	    </div>
	</div>

	<!-- 사원 관련 stats -->
	<div class="flex flex-col mx-auto w-full">
		<div class="w-full draggable">
			<div class="flex flex-col items-center gap-16 mx-auto my-4">
				<div class="grid grid-cols-5 gap-4 w-full">
					<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] b order-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
						<h3 class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
							<span id="countto1" countTo="${empTotal}"></span>
						</h3>
						<p class="text-base font-medium leading-7 text-center text-dark-grey-600">전 사원 수</p>
					</div>
					
					<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
						<h3 class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
							<span id="countto2" countTo="${empJoin}"></span>
						</h3>
						<p class="text-base font-medium leading-7 text-center text-dark-grey-600">금년 입사자 수</p>
					</div>
					
					<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
						<h3 class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
							<span id="countto3" countTo="${empResign}"></span>
						</h3>
						<p class="text-base font-medium leading-7 text-center text-dark-grey-600">금년 퇴사자 수</p>
					</div>
					
					<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
						<h3 class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
							<span id="countto4" countTo="${empInOffice}"></span>
						</h3>
						<p class="text-base font-medium leading-7 text-center text-dark-grey-600">현재 재직자 수</p>
					</div>
					
					<div class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
						<h3 class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
							<span id="countto5" countTo="${empLast}" style="color:#4E7DF4"></span><span style="color:#4E7DF4">% </span>
						</h3>
						<p class="text-base font-medium leading-7 text-center text-dark-grey-600">연간 이직률</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 사원 관련 stats 끝 -->
		
	<!-- 검색 area 수정 -->
	<div class="flex justify-end mb-4">
		<form id="searchForm">
			<div class="flex justify-end mt-2">
				<!-- 입사일자 필드 추가 -->
				<div class="flex items-center mx-1">
					<label for="jncmpStart" class="block mb-2 pt-2 text-sm font-medium text-gray-900 dark:text-gray-300">입사일자</label>
					<input type="date" id="jncmpStart" name="jncmpStart" value="${param.jncmpStart != null ? param.jncmpStart : ''}"
						class="h-10 px-2 py-2 mx-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" />
					<span>-</span>
					<input type="date" id="jncmpEnd" name="jncmpEnd" value="${param.jncmpEnd != null ? param.jncmpEnd : ''}"
						class="h-10 px-2 py-2 mx-2 mr-4 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" />
				</div>
				<!-- 퇴사일자 필드 추가 -->
				<div class="flex items-center mx-1">
					<label for="rsgntnStart" class="block mb-2 pt-2 text-sm font-medium text-gray-900 dark:text-gray-300">퇴사일자</label>
					<input type="date" id="rsgntnStart" name="rsgntnStart" value="${param.rsgntnStart != null ? param.rsgntnStart : ''}"
						class="h-10 px-2 py-2 mx-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" />
					<span>-</span>
					<input type="date" id="rsgntnEnd" name="rsgntnEnd" value="${param.rsgntnEnd != null ? param.rsgntnEnd : ''}"
						class="h-10 px-2 py-2 mx-2 mr-4 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" />
				</div>
				
				<!-- 퇴사여부 필드 -->
				<div class="relative mx-1">
					<select name="delynField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
						<option value="all" ${param.delynField == 'all' ? 'selected' : ''}>재직 여부</option>
						<option value="N" ${param.delynField == 'N' ? 'selected' : ''}>재직</option>
						<option value="Y" ${param.delynField == 'Y' ? 'selected' : ''}>퇴직</option>
					</select>
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
	
	<!-- 사원 리스트 -->
    <div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
	    <div class="card-body table-responsive p-0">
				<table class="table table-hover text-nowrap" style="text-align: center;">
					<thead>
						<tr>
							<th>사원 번호</th>
							<th>사원명</th>
							<th>부서</th>
							<th>직급</th>
							<th>직책</th>
							<th>입사 일자</th>
							<th>퇴사 여부</th>
							<th>이메일 주소</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="employeeVO" items="${employeeVOList}">
							<tr>
								<td>${employeeVO.empNo}</td>
								<td class="open-detail-modal aHover" data-empno="${employeeVO.empNo}">
									<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
										${fn:replace(employeeVO.empNm, param.keyword, word )}
								</td>
								<td>
									<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
                       				${fn:replace(employeeVO.deptNm, param.keyword, word )}
								</td>
								<td>
									<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
                       				${fn:replace(employeeVO.jbgdNm, param.keyword, word )}
								</td>
								<td>${employeeVO.jbttlNm}</td>
								<td>
									<fmt:parseDate value="${employeeVO.jncmpYmd}" pattern="yyyyMMdd" var="parsedDate" />
							    	<fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" />
								<c:if test="${employeeVO.delYn == 'Y'}">
									<td>퇴사</td>
								</c:if>
								<c:if test="${employeeVO.delYn == 'N'}">
									<td>재직</td>
								</c:if>
								
								<td>${employeeVO.empEmlAddr}</td>
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
			                <a href="/employee/list?currentPage=${articlePage.startPage-5}&jncmpStart=${param.jncmpStart}&jncmpEnd=${param.jncmpEnd}&rsgntnStart=${param.rsgntnStart}&rsgntnEnd=${param.rsgntnEnd}&delynField=${param.delynField}&searchField=${param.searchField}&keyword=${param.keyword}" style="color:#4E7DF4"
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
			                    <button id="button-${pNo}" onclick="javascript:location.href='/employee/list?currentPage=${pNo}&jncmpStart=${param.jncmpStart}&jncmpEnd=${param.jncmpEnd}&rsgntnStart=${param.rsgntnStart}&rsgntnEnd=${param.rsgntnEnd}&delynField=${param.delynField}&searchField=${param.searchField}&keyword=${param.keyword}';"
			                            class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
			                            style="background-color:#4E7DF4">${pNo}
			                    </button>
			                </li>
			            </c:if>
			
			            <c:if test="${articlePage.currentPage != pNo}">
			                <li>
			                    <button id="button-${pNo}" onclick="javascript:location.href='/employee/list?currentPage=${pNo}&jncmpStart=${param.jncmpStart}&jncmpEnd=${param.jncmpEnd}&rsgntnStart=${param.rsgntnStart}&rsgntnEnd=${param.rsgntnEnd}&delynField=${param.delynField}&searchField=${param.searchField}&keyword=${param.keyword}';"
			                            class="w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
			                            style="color:#4E7DF4">${pNo}
			                    </button>
			                </li>
			            </c:if>
			        </c:forEach>
			
			        <!-- endPage < totalPages일 때만 [다음] 활성화 -->
			        <li>
			            <c:if test="${articlePage.endPage lt articlePage.totalPages}">
			                <a href="/employee/list?currentPage=${articlePage.startPage + 5}&jncmpStart=${param.jncmpStart}&jncmpEnd=${param.jncmpEnd}&rsgntnStart=${param.rsgntnStart}&rsgntnEnd=${param.rsgntnEnd}&delynField=${param.delynField}&searchField=${param.searchField}&keyword=${param.keyword}" style="color:#4E7DF4"
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

<!-- 모달 HTML -->
<div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-lg font-bold" id="detailModalLabel">사원 정보</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body bg-white px-4 pb-4 pt-4 sm:p-6">
                <form id="detailForm">
                    <div class="flex mb-2">
                        <img id="modalProfilePhoto" src="" alt="프로필 사진" width="100" height="100"
                             class="mx-3 my-3 rounded-full object-cover border" />
                        <div class="p-4">
                            <div class="flex items-center mb-2">
                                <p id="modalEmpName" class="font-bold text-lg"></p>
                                <p id="modalEmpNo" class="text-gray-700 font-thin text-sm ml-2"></p>
                            </div>
                            <p id="modalDeptName" class="text-gray-700 font-thin text-sm"></p>
                        </div>
                    </div>

                    <div class="ml-2">
                        <div class="form-group align-items-center">
                            <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>입사 일자</strong></label>
                            <p id="modalJoinDate" class="text-gray-700 font-thin text-sm ml-2"></p>
                        </div>

                        <div class="form-group align-items-center">
                            <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>퇴사 여부 (퇴사일자)</strong></label>
                            <p id="modalResignStatus" class="text-gray-700 font-thin text-sm ml-2"></p>
                        </div>

                        <div class="form-group align-items-center">
                            <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>생년월일</strong></label>
                            <p id="modalBirthDate" class="text-gray-700 font-thin text-sm ml-2"></p>
                        </div>

                        <div class="form-group align-items-center">
                            <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>전화번호</strong></label>
                            <p id="modalEmpTelno" class="text-gray-700 font-thin text-sm ml-2"></p>
                        </div>

                        <div class="form-group align-items-center">
                            <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>이메일 주소</strong></label>
                            <p id="modalEmpEmail" class="text-gray-700 font-thin text-sm ml-2"></p>
                        </div>

                        <div class="form-group align-items-center">
                            <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>주소</strong></label>
                            <p id="modalAddr" class="text-gray-700 font-thin text-sm ml-2"></p>
                        </div>
                    </div>
                </form>
            </div>
			
			<div class="bg-gray-50 px-4 py-3 flex justify-center">
				<button type="button" id="close" class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50" data-dismiss="modal">
	          		취소
                </button>
            </div>
        </div>
    </div>
</div>
