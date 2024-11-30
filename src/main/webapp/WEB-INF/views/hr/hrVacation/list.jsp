<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link href="https://unpkg.com/tailwindcss@^2/dist/tailwind.min.css" rel="stylesheet">
<script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>

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

.aHover:hover {
    font-weight: bold;
    color: #4E7DF4;
}
</style>

<!-- 인사부서 휴가 조회 :: 장영원 -->

<script>
const holidays = [
	'2024.10.01', // 임시공휴일
	'2024.10.03', // 개천절
	'2024.10.09', // 한글날
	'2024.12.25'  // 성탄절
];

function setDeptValue(value) {
    // 부서 코드를 hidden input에 설정
    document.getElementById('deptCd').value = value;
    // 선택된 부서명을 버튼에 표시
    document.getElementById('selected-option').textContent = value;
    
    // 폼 제출 (부서 선택 후 자동 검색)
    document.getElementById("searchForm").submit();
}

//날짜를 'YYYY-MM-DD' 형식으로 변환하는 함수
function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}.${month}.${day}`;
}

// 주말인지 확인하는 함수 (토요일: 6, 일요일: 0)
function isWeekend(date) {
	const day = date.getDay();
	return day === 0 || day === 6;
}

// 공휴일인지 확인하는 함수
function isHoliday(dateStr) {
  return holidays.includes(dateStr);
}

$(function(){
	
    const dropdownButton = document.getElementById('dropdown-button');
    const dropdownList = document.getElementById('dropdown-list');
    const selectedOptionText = document.getElementById('selected-option');
    const deptCdInput = document.getElementById('deptCd');
    
    // 드롭다운 버튼 클릭 시 목록 표시/숨김
    dropdownButton.addEventListener('click', function() {
        dropdownList.classList.toggle('hidden');
    });

    // 드롭다운 항목 클릭 시 선택 처리
    document.querySelectorAll('#dropdown-list li').forEach(item => {
        item.addEventListener('click', (e) => {
            const value = e.currentTarget.getAttribute('data-value');

            // 선택된 텍스트를 버튼에 표시
            selectedOptionText.textContent = value;

            // 선택한 부서 코드 hidden 필드에 설정
            deptCdInput.value = value;

            // 체크 마크 업데이트
            document.querySelectorAll('.checkmark').forEach(checkmark => {
                checkmark.classList.add('hidden');
            });
            e.currentTarget.querySelector('.checkmark').classList.remove('hidden');

            // 드롭다운 닫기
            dropdownList.classList.add('hidden');
        });
    });

    // 드롭다운 외부 클릭 시 닫기
    window.addEventListener('click', (e) => {
        if (!dropdownButton.contains(e.target) && !dropdownList.contains(e.target)) {
            dropdownList.classList.add('hidden');
        }
    });
    
 // sortVacation 클릭 이벤트
    $('#sortVacation').click(function(event) {
        event.preventDefault();

        // 현재 정렬 순서 가져오기 (초기값은 DESC)
        let currentOrder = $(this).data('order') || 'DESC';
        let newOrder = currentOrder === 'DESC' ? 'ASC' : 'DESC';  // 클릭할 때마다 토글

        // AJAX 요청으로 리스트 갱신
        $.ajax({
            url: "/hrVacation/list",
            type: "GET",
            data: {
                orderBy: "HOLD_VCATN_DAY_CNT",  // 고정된 정렬 기준
                sortOrder: newOrder              // 새로 설정된 정렬 순서
            },
            success: function(response) {
				console.log("보유 휴가일 클릭은 됐슈 ;;")
            },
            error: function(xhr, status, error) {
                console.error("Error occurred: ", error);
            }
        });
    });
    
 // 사원 이름 클릭 이벤트 핸들러
    $('.open-detail-modal').click(function(event) {
        event.preventDefault(); // 기본 동작 방지

        let empNo = $(this).data('empno');
        console.log("empNo : ", empNo);
        
        // AJAX를 통해 empNo로 서버에 요청을 보냄
        $.ajax({
            url: "/hrVacation/lastVcatnDetail",
            data: { "empNo": empNo },
            type: "POST",
            dataType: "json",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
            },
            success: function(response) {
                // AJAX 성공 시 프로필 사진, 사원 정보, 휴가 정보 등을 모달에 삽입
                console.log("AJAX 성공, 응답 데이터: ", response);

                // 각 데이터를 response에서 가져와서 해당 모달 요소에 넣음
                if (response.proflPhoto) {
                    $('#modalProfilePhoto').attr('src', 'data:image/png;base64,' + response.proflPhoto);
                } else {
                    $('#modalProfilePhoto').attr('src', ''); // 기본 이미지가 없을 경우 처리
                }
                $('#modalEmpName').text(response.empNm);  // 사원명
                $('#modalEmpNo').text("( " + response.empNo + " )");  // 사원번호
                $('#hiddenEmpNo').val(response.empNo);
                
                // 부서명 + 직급명 결합 후 출력
                let deptAndJob = response.deptNm + ", " + response.jbgdNm;
                $('#modalDeptName').text(deptAndJob);  // 부서명 + 직급명

                // 잔여 휴가
                $('#modalHoldVcatn').text(response.holdVcatnDayCnt + "일");  // 잔여 휴가
                
                // 모달을 열기 (여기에 모달을 열기 위한 코드 추가)
                $('#detailModal').modal('show');  // Bootstrap 모달일 경우
            },
            error: function(xhr, status, error) {
                console.error("Error occurred: ", error);
                alert("데이터를 불러오는 데 문제가 발생했습니다.");
            }
        });
    });
 
    $('#close').on('click', function(){
        $('#detailModal').modal('hide'); // 모달을 닫음
    });
	
    const today = new Date();
    const endOfYear = new Date(today.getFullYear(), 11, 31);

    // 오늘 날짜를 포함하기 위해 시작 날짜를 그대로 사용
    let totalDays = Math.ceil((endOfYear - today) / (1000 * 60 * 60 * 24)) + 1; // 오늘 포함

    let weekendCount = 0;
    let holidayCount = 0;
    let currentDate = new Date(today);

    for (let i = 0; i < totalDays; i++) {
      if (isWeekend(currentDate)) {
        weekendCount++;
      } else if (isHoliday(formatDate(currentDate))) {
        holidayCount++;
      }
      // 하루를 더함
      currentDate.setDate(currentDate.getDate() + 1);
    }

    // 전체 일수에서 주말과 공휴일을 제외한 평일 계산
    const workingDays = totalDays - weekendCount - holidayCount;

    console.log(`오늘부터 12월 31일까지 주말 및 공휴일을 제외한 평일은 ${workingDays}일 남았습니다.`);
    $('#workDay').text(workingDays - 1);
});
</script>

<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
	<div class="w-full flex justify-between items-center mb-3 pl-3">
		<div style="margin-top: 30px; margin-bottom: 10px;">
			<h3 class="text-lg font-semibold text-slate-800">
				<a href="/hrVacation/list">휴가 관리</a>
			</h3>
			<p class="text-slate-500">효율적인 휴가 신청 및 관리 시스템으로 직원들의 휴가 현황을 파악하세요</p>
		</div>

		<form id="searchForm">
			<div class="flex items-center space-x-3 mt-2">
				<div class="relative w-32">
					<button type="button" id="dropdown-button"
						class="relative w-full cursor-default rounded-md bg-white py-1.5 pl-3 pr-10 text-left text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 sm:text-sm sm:leading-6"
						aria-haspopup="listbox" aria-expanded="true" aria-labelledby="listbox-label">

						<span class="flex items-center"> <!-- deptCd가 있는 경우 해당 부서 이름을 표시, 없는 경우 '부서 선택' -->
							<span id="selected-option" class="ml-3 block truncate"> <c:choose>
									<c:when test="${not empty param.deptCd}">
		                                ${deptNmMap[param.deptCd]} <!-- deptCd에 맞는 deptNm을 표시 -->
									</c:when>
									<c:otherwise>
		                               	 부서 선택
		                            </c:otherwise>
								</c:choose>
							</span>
						</span>
						
						<span class="pointer-events-none absolute inset-y-0 right-0 ml-3 flex items-center pr-2">
							<svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
		                        <path fill-rule="evenodd" clip-rule="evenodd" d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z"/>
		                    </svg>
						</span>
					</button>

					<!-- Hidden input에 부서 코드를 설정 (검색할 때 전송) -->
					<input type="hidden" id="deptCd" name="deptCd" value="${param.deptCd}">

					<!-- 드롭다운 리스트 -->
					<ul id="dropdown-list"
						class="absolute z-10 mt-1 max-h-56 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm hidden"
						tabindex="-1" role="listbox" aria-labelledby="listbox-label"
						aria-activedescendant="listbox-option-3">

						<li class="relative cursor-pointer select-none py-2 pl-3 pr-9 text-gray-900" role="option" data-value="전체" onclick="setDeptValue('전체')">
							<div class="flex items-center">
								<span class="ml-3 block truncate font-normal">전체</span>
							</div>
							<span class="absolute inset-y-0 right-0 flex items-center pr-4 hidden checkmark">
								<svg class="h-5 w-5 text-indigo-600" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
		                            <path fill-rule="evenodd" clip-rule="evenodd"
										d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z"/>
		                        </svg>
							</span>
						</li>

						<!-- 부서 리스트 출력 -->
						<c:forEach var="commonCodeVO" items="${deptList}">
							<li class="relative cursor-pointer select-none py-2 pl-3 pr-9 text-gray-900" role="option" data-value="${commonCodeVO.clsfNm}" onclick="setDeptValue('${commonCodeVO.clsfCd}')">
								<div class="flex items-center">
									<span class="ml-3 block truncate font-normal">${commonCodeVO.clsfNm}</span>
								</div>
								
								<span class="absolute inset-y-0 right-0 flex items-center pr-4 hidden checkmark">
									<svg class="h-5 w-5 text-indigo-600" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
		                                <path fill-rule="evenodd" clip-rule="evenodd"
											d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z"/>
		                            </svg>
								</span>
							</li>
						</c:forEach>
					</ul>
				</div>

				<!-- 검색 필드 및 버튼 -->
				<div>
					<div class="w-full max-w-sm min-w-[200px] relative">
						<div class="relative">
							<input type="text" name="keyword" value="${param.keyword}" placeholder="사원명을 입력하세요."
								class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"/>
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
	<!-- 검색 필드 끝 -->

	<!-- 대시보드 시작 -->
	<div class="grid grid-cols-1 md:grid-cols-4 xl:grid-cols-5 xl:p-0 gap-y-4 md:gap-6 my-4">
		<div class="md:col-span-2 xl:col-span-3 bg-white p-6 rounded-2xl border border-gray-50">
			<div class="flex flex-col space-y-6 md:h-full md:justify-between">
				<div class="flex justify-between">
					<span class="text-gray-500 uppercase">
					    2024년도
					</span>
					<span class="text-gray-500 uppercase">
					    1월 1일 ~ 12월 31일
					</span>
				</div>

				<div class="flex gap-2 md:gap-4 justify-between items-center">
					<div class="flex flex-col space-y-4">
						<h2 class="text-gray-800 font-bold leading-tight">
							올해 휴가 사용 가능일</h2>
					</div>

					<h2 class="text-lg md:text-xl xl:text-3xl text-gray-700 font-black">
						<span class="md:text-xl" id="workDay"></span>일
					</h2>
				</div>
			</div>
		</div>

		<!-- 오른쪽 -->
		<div class="col-span-2 p-6 rounded-2xl bg-gradient-to-r flex flex-col justify-between" style="background-color: #4E7DF4;">
			<div class="flex flex-col">
				<p class="text-white font-bold">잔여 휴가가 많이 남은 사원</p>
				<c:forEach var="hrVacationVO" items="${holdVcatnTop3}">
					<p class="mt-1 text-sm md:text-sm text-gray-50 font-light leading-tight max-w-sm">
						${hrVacationVO.empNm} (${hrVacationVO.deptNm},
						${hrVacationVO.jbgdNm})
						&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;${hrVacationVO.holdVcatnDayCnt}일
					</p>
				</c:forEach>
			</div>
		</div>
	</div>
	<!-- 대시보드 끝 -->

	<!-- 리스트 출력 시작 -->
	<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
		<div class="card-body table-responsive p-0">
			<table class="table table-hover text-nowrap"
				style="text-align: center;">
				<thead>
					<tr>
						<th>사원 번호</th>
						<th>부서명</th>
						<th>사원명</th>
						<th>기본 휴가(일)</th>
						<th>부여 휴가(일)</th>
						<th>사용 휴가(일)</th>
						<th id="sortVacation">잔여 휴가(일)</th>
					</tr>
				</thead>
				<tbody id="tableBody">
					<c:forEach var="hrVacationVO" items="${hrVacationVOList}">
						<tr>
							<td>${hrVacationVO.empNo}</td>
							<td class="open-detail-modal aHover" data-empno="${hrVacationVO.empNo}">
								<c:set var="word"
									value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
								${fn:replace(hrVacationVO.empNm, param.keyword, word )}
							</td>
							<td>${hrVacationVO.deptNm}</td>
							<td>${hrVacationVO.bscVcatnDayCnt}</td>
							<td>${hrVacationVO.grntVcatnDayCnt}</td>
							<td>${hrVacationVO.useVcatnDayCnt}</td>
							<td>${hrVacationVO.holdVcatnDayCnt}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<c:if test="${articlePage.total == 0 }">
			<p style="margin: 40px; text-align: center;">데이터가 존재하지 않습니다.</p>
		</c:if>

		<c:if test="${articlePage.total != 0 }">
			<nav aria-label="Page navigation"
				style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
				<ul class="inline-flex space-x-2">
					<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
					<li><c:if test="${articlePage.startPage gt 5}">
							<a
								href="/hrVacation/list?currentPage=${articlePage.startPage-5}&deptCd=${param.deptCd}"
								style="color: #4E7DF4"
								class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
									<path
										d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
										clip-rule="evenodd" fill-rule="evenodd"></path>
								</svg>
							</a>
						</c:if></li>

					<!-- 총 페이징 -->
					<c:forEach var="pNo" begin="${articlePage.startPage}"
						end="${articlePage.endPage}">
						<c:if test="${articlePage.currentPage == pNo}">
							<li>
								<button id="button-${pNo}"
									onclick="javascript:location.href='/hrVacation/list?currentPage=${pNo}&deptCd=${param.deptCd}';"
									class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
									style="background-color:#4E7DF4">${pNo}</button>
							</li>
						</c:if>

						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}"
									onclick="javascript:location.href='/hrVacation/list?currentPage=${pNo}&deptCd=${param.deptCd}';"
									class="w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color: #4E7DF4">${pNo}</button>
							</li>
						</c:if>
					</c:forEach>

					<!-- endPage < totalPages(일) 때만 [다음] 활성화 -->
					<li><c:if
							test="${articlePage.endPage lt articlePage.totalPages}">
							<a
								href="/hrVacation/list?currentPage=${articlePage.startPage+5}&deptCd=${param.deptCd}"
								style="color: #4E7DF4"
								class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
									<path
										d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
										clip-rule="evenodd" fill-rule="evenodd"></path>
								</svg>
							</a>
						</c:if></li>
				</ul>
			</nav>
		</c:if>
	</div>
</div>


<!-- 모달 HTML -->
<div class="modal fade" id="detailModal" tabindex="-1" role="dialog"
    aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document"> <!-- modal-dialog-centered 추가 -->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-lg font-bold" id="detailModalLabel">사원 정보</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body bg-white px-4 pb-4 pt-4 sm:p-6">
                <form id="detailForm" action="/hrVacation/grantVacation" method="post">
                    <input type="hidden" name="empNo" id="hiddenEmpNo" value="">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <div class="modal-body">
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
                                <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>잔여 휴가(일)</strong></label>
                                <p id="modalHoldVcatn" class="text-gray-700 font-thin text-sm ml-2"></p>
                            </div>

                            <div class="form-group align-items-center flex-column">
                                <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>휴가 부여 일수</strong></label>
                                <select name="grntVcatnDayCnt" id="grntVcatnDayCnt" class="h-10 px-3 py-2 mx-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
                                    <option value="" selected disabled>선택해주세요</option>
                                    <option value="1">1일</option>
                                    <option value="2">2일</option>
                                    <option value="3">3일</option>
                                    <option value="4">4일</option>
                                    <option value="5">5일</option>
                                    <option value="6">6일</option>
                                    <option value="7">7일</option>
                                </select>
                            </div>

                            <div class="form-group align-items-center">
                                <label class="col-form-label col-4 text-base font-semibold leading-6 text-gray-900"><strong>휴가 부여 사유</strong></label>
                                <input type="text" id="reason" name="reason" class="border border-gray-300 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5" placeholder="문서 제목을 입력해주세요." required>
                            </div>
                        </div>
                    </div>

                    <div class="bg-gray-50 px-4 py-3 flex justify-center">
                        <button id="close" type="button" class="inline-flex justify-center rounded-md bg-white px-3 py-2 mx-4 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50" data-dismiss="modal">취소</button>
                        <button type="submit" id="save" class="inline-flex justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50" style="background-color: #4E7DF4;">등록</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


