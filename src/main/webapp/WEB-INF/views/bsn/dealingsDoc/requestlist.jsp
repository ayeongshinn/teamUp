<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>

<head>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<link rel="stylesheet"
	  href="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/motion-tailwind.css"
	  rel="stylesheet">

<link rel="stylesheet"
	  href="https://horizon-tailwind-react-corporate-7s21b54hb-horizon-ui.vercel.app/static/css/main.d7f96858.css" />

<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>

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

#addr {
    visibility: hidden; /* 기본적으로 숨김 */
}

.card-header {
    border: none;  /* 테두리 제거 */
}

.modal {
    display: flex;
    justify-content: center; /* 수평 중앙 정렬 */
    align-items: center;     /* 수직 중앙 정렬 */
    position: fixed;
    z-index: 10;
    inset: 0;
    overflow-y: auto;
    min-height: 100vh; /* 화면 높이만큼 중앙 정렬 */
    background-color: rgba(0, 0, 0, 0.5); /* 회색 반투명 배경 유지 */
}

.modal-content {
    position: relative;
    background-color: white;
    padding: 20px;
    border-radius: 10px;
    max-width: 600px; /* 모달의 최대 너비 설정 */
    width: 100%;      /* 화면 크기에 맞게 조정 */
    margin: auto;     /* 중앙으로 정렬 */
    margin-left: 40%; /* 오른쪽으로 50px 만큼 이동 */
}

/* 필요시 모달을 화면 상단에 배치하는 방법 */
.modal-content-top {
    margin-top: 10%; /* 상단에서 10%만큼 떨어지도록 설정 */
}

/* 회색 배경을 유지하면서 모달만 이동 */
.modal-background {
    background-color: rgba(0, 0, 0, 0.5); /* 회색 배경 유지 */
}
    
</style>


<script type="text/javascript">
	
	// 토큰(?)
	const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
	const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

</script>

<script type="text/javascript">

function dealingsDocDetail(docNo) {
    // 페이지 이동 처리
    window.location.href = '/dealingsDoc/dealDetail?docNo=' + docNo;
}

// list 화면 stat 이벤트용 function
$(function(){
	
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
})

</script>

<!-- 계약서 페이지 :: 이재현 -->

</head>

<body>
	<div class="col-12" style="max-width: 1350px; margin: auto;">
		<form id="searchForm">
			<div class="card-header">
				<div style="margin-top: 30px; margin-bottom: 10px;">
					<h3 class="text-lg font-semibold text-slate-800">계약서 결재 요청</h3>
					<p class="text-slate-500">
						영업부서의 계약서 결제 요청 리스트입니다.
					</p>

					<!-- 계약서 관련 stats -->
					<div class="flex flex-col mx-auto w-full">
						<div class="w-full draggable">
							<div class="flex flex-col items-center gap-16 mx-auto my-4">
								<div class="grid grid-cols-4 gap-4 w-full">
									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] b order-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto1" countTo="${getHold}"></span>
										</h3>
										<p class="text-base font-medium leading-7 text-center text-dark-grey-600">
											결재 대기 건수
										</p>
									</div>

									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto2" countTo="${getCurrentPass}"></span>
										</h3>
										<p class="text-base font-medium leading-7 text-center text-dark-grey-600">
											당월 승인 건수 
										</p>
									</div>

									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto3" countTo="${getCurrentHold}"></span>
										</h3>
										<p
											class="text-base font-medium leading-7 text-center text-dark-grey-600">
											당월 반려 건수
										</p>
									</div>

									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto4" countTo="${getCurrent}"></span>
										</h3>
										<p class="text-base font-medium leading-7 text-center text-dark-grey-600">
											당월 요청 건수
										</p>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- 계약서 관련 stats 끝 -->
		        </div>
		    </div>
		</form>


		<div class="card" style="padding: 5px; margin-left: 17px; margin-right: 17px;">
			<div class="card-body table-responsive p-0">
				<table class="table table-hover text-nowrap">
					<thead>
						<tr>
							<th>서류 번호</th>
							<th style="text-align: center;">서류 제목</th>
							<th>담당자</th>
							<th>계약자 명</th>
							<th>작성 일자</th>
							<th>계약 금액</th>
							<th>결재 상태</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="DealingsDocVO" items="${dealingsDocVOList}">
							<tr class="detail-btn"
								onclick="dealingsDocDetail('${DealingsDocVO.docNo}')">
								<!-- 클릭 시 Ajax 요청 발생 -->
								<td style="padding-left: 45px;">${DealingsDocVO.rnum}</td>
								<td>${DealingsDocVO.docTtl}</td>
								<td>${DealingsDocVO.empNm}</td>
								<td>
                                    <!-- 계약자명 처리: 서버에서 데이터 로드 시 -->
                                    <c:choose>
                                        <c:when test="${DealingsDocVO.cnptNo != null}">
                                            ${DealingsDocVO.rprsvNm}
                                        </c:when>
                                        <c:when test="${DealingsDocVO.custNo != null}">
                                            ${DealingsDocVO.custNm}
                                        </c:when>
                                    </c:choose>
                                </td>
								<td><fmt:parseDate var="parsedDate"
										value="${DealingsDocVO.wrtYmd}" pattern="yyyyMMdd" />
									<fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" />
								</td>
								<td><fmt:formatNumber value="${DealingsDocVO.ctrtAmt}" pattern="#,###"/>원</td>
								<td>${DealingsDocVO.clsfNm}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<br>

				<nav aria-label="Page navigation" style="margin-left: 40%;">
					<ul class="inline-flex space-x-2">
						<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
						<li><c:if test="${articlePage.startPage gt 5}">
								<a
									href="/dealingsDoc/list?currentPage=${articlePage.startPage-5}"
									class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color: #4E7DF4;"> <svg class="w-4 h-4 fill-current"
										viewBox="0 0 20 20">
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
										onclick="javascript:location.href='/dealingsDoc/list?currentPage=${pNo}';"
										class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
										style="background-color: #4E7DF4; color: white;">${pNo}
									</button>
								</li>
							</c:if>

							<c:if test="${articlePage.currentPage != pNo}">
								<li>
									<button id="button-${pNo}"
										onclick="javascript:location.href='/dealingsDoc/list?currentPage=${pNo}';"
										class="w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
										style="color: #4E7DF4;">${pNo}</button>
								</li>
							</c:if>
						</c:forEach>

						<!-- endPage < totalPages일 때만 [다음] 활성화 -->
						<li><c:if
								test="${articlePage.endPage lt articlePage.totalPages}">
								<a
									href="/dealingsDoc/list?currentPage=${articlePage.startPage+5}"
									class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color: #4E7DF4;"> <svg class="w-4 h-4 fill-current"
										viewBox="0 0 20 20">
											<path
											d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
											clip-rule="evenodd" fill-rule="evenodd"></path>
										</svg>
								</a>
							</c:if></li>
					</ul>
				</nav>
			</div>
		</div>
	</div>

</body>
</html>