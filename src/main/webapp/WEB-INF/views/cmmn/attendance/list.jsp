<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 로그인 후 정보 확인 시작 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!-- 로그인 후 정보 확인 끝 -->

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://horizon-tailwind-react-corporate-7s21b54hb-horizon-ui.vercel.app/static/css/main.d7f96858.css" />

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

<script type="text/javascript">
$(function(){
	// 로그인한 사원의 부서 코드를 JSP에서 가져옴
    var deptCd = '${empVO.deptCd}';
    var deptNm = '';

    // deptCd에 따른 부서명 설정
    if(deptCd === 'A17-002') {
        deptNm = '기획부서 사원들의 출퇴근 기록을 실시간으로 확인하고 효율적으로 관리하세요';
    } else if(deptCd === 'A17-003') {
        deptNm = '관리부서 사원들의 출퇴근 기록을 실시간으로 확인하고 효율적으로 관리하세요';
    } else if(deptCd === 'A17-004') {
        deptNm = '영업부서 사원들의 출퇴근 기록을 실시간으로 확인하고 효율적으로 관리하세요';
    } else if(deptCd === 'A17-005') {
        deptNm = '인사부서 사원들의 출퇴근 기록을 실시간으로 확인하고 효율적으로 관리하세요';
    } else {
        deptNm = '사원들의 출퇴근 기록을 실시간으로 확인하고 효율적으로 관리하세요';
    }

    // 부서명을 HTML에 출력
    $('#LoginUserdeptNm').text(deptNm);
	//날짜 변경 시 해당 일자에 해당되는 리스트 출력
	$("#selectedYmd").on("change", function(){
	    let newDate = $(this).val();
	    localStorage.setItem("selectedYmd", newDate); // 변경된 날짜를 저장

	    let formattedDate = "";
	
	    if (newDate) {
	        // YYYY-MM-DD 형식에서 YYYYMMDD 형식으로 변환
	        formattedDate = newDate.replace(/-/g, '');
		    console.log("포매티드데이트 설정 :", formattedDate);
	    }
		
	    $("#attendYmd").val(formattedDate);
	    
	    $("#attendanceList").submit();
	});

	
	//날짜 기본 설정 오늘로 지정
	let savedDate = localStorage.getItem("selectedYmd");
	
	if(!savedDate){
		let today = new Date().toISOString().substring(0, 10);
		$("#selectedYmd").val(today);
		localStorage.setItem("selectedYmd", today);
	} else {
		$("#selectedYmd").val(savedDate);
	}
	
	//금일 이후 불가
	let now_time = Date.now();
	let timeOff = new Date().getTimezoneOffset() * 60000;
	let today = new Date(now_time - timeOff).toISOString().split("T")[0];
	$("#selectedYmd").attr("max", today);
	
	
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
	
});

</script>
<!-- 각 팀장 사원 근태 조회 :: 장영원 -->
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 ">
	<div class="w-full flex justify-between items-center mb-3 pl-3">
	    <div style="margin-top: 30px;">
	        <h3 class="text-lg font-semibold text-slate-800">
	        	<a href="/attendance/list">근태 관리</a>
	        </h3>
	        <p id="LoginUserdeptNm" class="text-slate-500">사원들의 출퇴근 기록을 실시간으로 확인하고 효율적으로 관리하세요</p>
	    </div>
		
		<form id="attendanceList" action="/attendance/list">
		    <div class="flex items-center space-x-3 mt-2 pt-4">

		        <!-- 날짜 확인 가능하도록 구현. (금일뿐만 아니라 전날, 일주일전..) -->
				<input type="date" id="selectedYmd" value="${param.attendYmd}" class="p-1.5 pr-2" />
				<input type="hidden" id="attendYmd" name="attendYmd" value="${attendYmd}" />
				
		        <!-- 검색 필드 및 버튼 -->
		        <div>
		            <div class="w-full max-w-sm min-w-[200px] relative">
		                <div class="relative">
		                    <input type="text" name="keyword" value="${param.keyword}"
		                        class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
		                        placeholder="사원명을 입력하세요." />
		                    <button type="submit" class="absolute h-8 w-8 right-1 top-1 my-auto px-2 flex items-center bg-white rounded">
		                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-8 h-8 text-slate-600">
		                            <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"/>
		                        </svg>
		                    </button>
		                </div>
		            </div>
		        </div>
		    </div>
		</form>
	</div>
    
    <!-- 사원 근태 요약 추가. -->
	<div class="flex flex-col justify-center items-center pb-3">
		<div class="w-full mt-4 mb-4 grid grid-cols-1 gap-5 md:grid-cols-3 lg:grid-cols-3 2xl:grid-cols-3 3xl:grid-cols-3">
			
			<div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
				<div class="ml-[18px] flex w-auto flex-row items-center">
					<div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
						<span class="flex items-center text-brand-500 dark:text-white">
							<svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 24 24" class="h-7 w-7" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
                           <path fill="none" d="M0 0h24v24H0z"></path>
                           <path d="M4 9h4v11H4zM16 13h4v7h-4zM10 4h4v16h-4z" style="color: #4E7DF4;"></path>
                       </svg>
						</span>
					</div>
				</div>
				<div class="h-50 ml-4 flex w-auto flex-col justify-center">
					<p class="font-dm text-sm font-medium text-gray-600">전체</p>
					<h4 class="text-xl font-bold text-navy-700 dark:text-white">${deptTotal} 명</h4>
				</div>
			</div>
			
			<div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
				<div class="ml-[18px] flex h-[90px] w-auto flex-row items-center">
					<div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
						<span class="flex items-center text-brand-500 dark:text-white">
							<svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 512 512" class="h-6 w-6" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
                           <path d="M298.39 248a4 4 0 002.86-6.8l-78.4-79.72a4 4 0 00-6.85 2.81V236a12 12 0 0012 12z" style="color: #4E7DF4;"></path>
                           <path d="M197 267a43.67 43.67 0 01-13-31v-92h-72a64.19 64.19 0 00-64 64v224a64 64 0 0064 64h144a64 64 0 0064-64V280h-92a43.61 43.61 0 01-31-13zm175-147h70.39a4 4 0 002.86-6.8l-78.4-79.72a4 4 0 00-6.85 2.81V108a12 12 0 0012 12z" style="color: #4E7DF4;"></path>
                           <path d="M372 152a44.34 44.34 0 01-44-44V16H220a60.07 60.07 0 00-60 60v36h42.12A40.81 40.81 0 01231 124.14l109.16 111a41.11 41.11 0 0111.83 29V400h53.05c32.51 0 58.95-26.92 58.95-60V152z" style="color: #4E7DF4;"></path>
                       </svg>
						</span>
					</div>
				</div>
				<div class="h-50 ml-4 flex w-auto flex-col justify-center">
					<p class="font-dm text-sm font-medium text-gray-600">출근</p>
					<h4 class="text-xl font-bold text-navy-700 dark:text-white">${deptTotal - absentCnt} 명</h4>
				</div>
			</div>
			
			<div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
				<div class="ml-[18px] flex h-[90px] w-auto flex-row items-center">
					<div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
						<span class="flex items-center text-brand-500 dark:text-white">
							<svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 512 512" class="h-6 w-6" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
                            	<path d="M208 448V320h96v128h97.6V256H464L256 64 48 256h62.4v192z" style="color: #4E7DF4;"></path>
                        	</svg>
						</span>
					</div>
				</div>
				<div class="h-50 ml-4 flex w-auto flex-col justify-center">
					<p class="font-dm text-sm font-medium text-gray-600">미 출근</p>
					<h4 class="text-xl font-bold text-navy-700 dark:text-white">${absentCnt} 명</h4>
				</div>
			</div>
		</div>
	</div>

	<!-- 사원 근태 리스트 -->
    <div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
	    <div class="card-body table-responsive p-0">
				<table class="table table-hover text-nowrap" style="text-align: center;">
					<thead>
						<tr>
							<th>사원 번호</th>
							<th>사원명</th>
							<th>직급</th>
							<th>출근 시각</th>
							<th>퇴근 시각</th>
							<th>휴식 시간</th>
							<th>근무 시간</th>
							<th>식사 시간</th>
							<th>야근 시간</th>
							<th>현재 상태</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="attendanceVO" items="${attendanceVOList}">
							<!-- 출근 한 경우 -->
							<c:if test="${attendanceVO.attendTm != null }">
								<input type="hidden" id="attendTm" name="attendTm" value="${param.attendTm}" />
								<tr>
									<td>${attendanceVO.empNo}</td>
									<td class="open-detail-modal aHover" data-empno="${attendanceVO.empNo}">
										<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
										${fn:replace(attendanceVO.empNm, param.keyword, word )}
									</td>
									<td>${attendanceVO.jbgdNm}</td>
									<td>${fn:substring(attendanceVO.attendTm, 0, 2)}:${fn:substring(attendanceVO.attendTm, 2, 4)}</td>
									
									<c:if test="${attendanceVO.lvffcTm != null}">
										<td>${fn:substring(attendanceVO.lvffcTm, 0, 2)}:${fn:substring(attendanceVO.lvffcTm, 2, 4)}</td>
									</c:if>
									<c:if test="${attendanceVO.lvffcTm == null}">
										<td>-</td>
									</c:if>
									
									<td>${attendanceVO.restHr} 시간</td>
									
									<c:if test="${attendanceVO.workHr != null}">
										<td>${fn:substring(attendanceVO.workHr, 0, 2)}:${fn:substring(attendanceVO.workHr, 2, 4)}</td>
									</c:if>
									<c:if test="${attendanceVO.workHr == null}">
										<td>-</td>
									</c:if>
									<td>${attendanceVO.mealHr} 시간</td>
									
									<c:if test="${attendanceVO.ngtwrHr != null}">
										<td>${fn:substring(attendanceVO.ngtwrHr, 0, 2)}:${fn:substring(attendanceVO.ngtwrHr, 2, 4)}</td>
									</c:if>
									<c:if test="${attendanceVO.ngtwrHr == null}">
										<td>-</td>
									</c:if>
									<td>${attendanceVO.empSttusNm}</td>
								</tr>
							</c:if>
							
							<!-- 출근 안한 경우 -->
							<c:if test="${attendanceVO.attendTm == null }">
								<tr>
									<td>${attendanceVO.empNo}</td>
									<td class="open-detail-modal aHover" data-empno="${attendanceVO.empNo}">
										<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
										${fn:replace(attendanceVO.empNm, param.keyword, word )}
									</td>
									<td>${attendanceVO.jbgdNm}</td>
									<td>-</td>
									<td>-</td>
									<td>-</td>
									<td>-</td>
									<td>-</td>
									<td>-</td>
									<td>${attendanceVO.empSttusNm}</td>
							</c:if>
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
							<a href="/attendance/list?currentPage=${articlePage.startPage-5}&attendYmd=${attendYmd}" style="color:#4E7DF4"
								class="flex items-center justify-center w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100" style="color: #4E7DF4;">
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
								<button id="button-${pNo}" onclick="javascript:location.href='/attendance/list?currentPage=${pNo}&attendYmd=${attendYmd}';"
									class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
									style="background-color:#4E7DF4">${pNo}
								</button>
							</li>
						</c:if>
			
						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}" onclick="javascript:location.href='/attendance/list?currentPage=${pNo}&attendYmd=${attendYmd}';"
									class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color:#4E7DF4">${pNo}
								</button>
							</li>
						</c:if>
					</c:forEach>
			
					<!-- endPage < totalPages일 때만 [다음] 활성화 -->
					<li>
						<c:if test="${articlePage.endPage lt articlePage.totalPages}">
							<a href="/attendance/list?currentPage=${articlePage.startPage + 5}&attendYmd=${attendYmd}" style="color:#4E7DF4"
								class="flex items-center justify-center w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100" style="color: #4E7DF4;">
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
    <div class="modal-dialog" role="document">
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