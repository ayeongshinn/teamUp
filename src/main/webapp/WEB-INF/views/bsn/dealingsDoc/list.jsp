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


// 날짜 포매팅 함수 (글로벌 스코프)
function formatDateString(dateString) {
    if (dateString && dateString.length === 8) {
        return dateString.replace(/(\d{4})(\d{2})(\d{2})/, '$1.$2.$3');
    }
    return dateString;
}

// 날짜 필드에 포맷된 값 적용 (글로벌 스코프)
function formatDateDetails(response) {
    var formattedWrtYmd = formatDateString(response.dealingsDocVO.wrtYmd);
    $('#wrtYmd').val(formattedWrtYmd);
}

//숫자를 세 자리마다 쉼표로 포매팅하는 함수
function formatCurrency(amount) {
    return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + ' 원';
}

function searchDetail(docNo) {
    
    console.log("Ajax 요청 시작");
    console.log("docNo 확인 : ", docNo);

    $.ajax({
        url: window.location.origin + '/dealingsDoc/detail',  // 절대 경로로 설정
        type: 'GET',
        data: { docNo: docNo },  // 요청 파라미터
        dataType: 'json',  // 서버로부터 JSON 형식의 응답을 기대
        success: function(response) {
            console.log("응답 데이터:", response);
            
            if (response && response.dealingsDocVO) {

                // 계약자명 처리: rprsvNm이 있으면 사용하고, 없으면 custNm을 사용
                var contractorName = response.dealingsDocVO.rprsvNm || response.dealingsDocVO.custNm;
                console.log("Contractor Name 확인 : ", contractorName);  // 값이 정상적으로 있는지 확인

                // 각 ID에 Ajax로 받은 데이터를 채워 넣음
                document.getElementById("docNo").value = response.dealingsDocVO.docNo;
                document.getElementById("wrtYmd").value = response.dealingsDocVO.wrtYmd;
                document.getElementById("empNm").value = response.dealingsDocVO.empNm;
                document.getElementById("cntrNm").value = contractorName;
             	
                // 계약 금액 포매팅 적용
                var formattedAmt = formatCurrency(response.dealingsDocVO.ctrtAmt);
                document.getElementById("ctrtAmt").value = formattedAmt;
                
                document.getElementById("clsfNm").value = response.dealingsDocVO.clsfNm;
                document.getElementById("docTtl").value = response.dealingsDocVO.docTtl;
                document.getElementById("ctrtCn").value = response.dealingsDocVO.ctrtCn;
                
                // 원본 데이터를 저장하기 위해 data-* 속성에 저장 [포매팅으로 인해 저장 필요]
                $("#wrtYmd").data('original', response.dealingsDocVO.wrtYmd);
                $("#ctrtAmt").data('original', response.dealingsDocVO.ctrtAmt);

                // 모든 input 태그에 대해 background-color 적용
                $('#modalBody input').css("background-color", "#f9fafb");
                
                console.log("찍히는지 확인 : ", document.getElementById("cntrNm"));

                // 날짜 포매팅
                formatDateDetails(response);
            
            } else {
                console.error("dealingsDocVO 데이터가 없습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX 에러:", error);
            console.error("상태 코드:", xhr.status);
            console.error("응답 텍스트:", xhr.responseText);
            alert('데이터를 불러오는 데 실패했습니다. 오류: ' + error);
        }
    });
}

// Modal 띄우기 이벤트 (hover 시)
$(document).on('mouseenter', '.modal-btn', function(){
    $('#detailModal').css('display', 'block');
    const docNo = $(this).attr('data-docno'); // 문서 번호 가져오기
    searchDetail(docNo); // Ajax로 문서 상세 정보 불러오기
});

//모달 외부 클릭 시 닫기
$(document).on('click', function(event) {
    if ($(event.target).closest('.modal-content').length === 0) {
        $('#detailModal').css('display', 'none');
    }
});

//ESC 키로 모달 닫기
$(document).on('keydown', function(event) {
    if (event.key === "Escape") {
        $('#detailModal').css('display', 'none');
    }
});



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

//등록으로 이동
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('regBtn').addEventListener('click', function() {
        window.location.href = '/dealingsDoc/regist'; // 버튼 클릭 시 이동할 경로
    });
});

</script>

<!-- 계약서 페이지 :: 이재현 -->

</head>

<body>
	<div class="col-12" style="max-width: 1350px; margin: auto;">
		<form id="searchForm">
			<div class="card-header">
				<div style="margin-top: 30px; margin-bottom: 10px;">
					<h3 class="text-lg font-semibold text-slate-800">계약서 리스트</h3>
					<p class="text-slate-500">
						영업부서의 계약서 리스트입니다.
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
											<span id="countto1" countTo="${getPass}"></span>
										</h3>
										<p class="text-base font-medium leading-7 text-center text-dark-grey-600">
											승인 건수
										</p>
									</div>

									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto2" countTo="${getReturn}"></span>
										</h3>
										<p class="text-base font-medium leading-7 text-center text-dark-grey-600">
											반려 건수
										</p>
									</div>

									<div
										class="flex flex-col py-4 items-center rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
										<h3
											class="text-5xl font-extrabold leading-tight text-center text-dark-grey-900">
											<span id="countto3" countTo="${getHold}"></span>
										</h3>
										<p
											class="text-base font-medium leading-7 text-center text-dark-grey-600">
											대기 건수</p>
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
		
		            <!-- 검색 조건 (대표명/고객명) 및 키워드 입력 -->
		            <div class="input-group input-group-sm" style="width: 500px; margin-left: 62%;">
						<!-- 결재 상태(카테고리) 필터 -->
						<select id="selCategory" name="category" class="form-control" style="width: 130px;">
						    <option value="" selected>결재 상태 선택</option>
						    <c:forEach var="category" items="${categories}">
						        <option value="${category.CATEGORY}" 
						            <c:if test="${param.category == category.CATEGORY}">selected</c:if>>
						            ${category.CATEGORYNAME} <!-- category.categoryName에서 대문자로 수정 -->
						        </option>
						    </c:forEach>
						</select>
					
		                <select class="form-control" style="width: 130px" id="selGubun" name="gubun">
		            		<option value="" selected>조건 선택</option>
		                    <option value="rprsvNm" <c:if test="${param.gubun == 'rprsvNm'}">selected</c:if>>대표명</option>
		                    <option value="custNm" <c:if test="${param.gubun == 'custNm'}">selected</c:if>>고객명</option>
		                </select>
		
		                <input type="text" name="keyword" style="width: 160px"
		                       class="form-control float-right" value="${param.keyword}"
		                       placeholder="검색어를 입력하세요." />
		
		                <div class="input-group-append">
		                    <button type="submit" class="btn btn-default">
		                        <i class="fas fa-search"></i>
		                    </button>
		                </div>
		            </div>
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
							<tr>
								<!-- 클릭 시 Ajax 요청 발생 -->
								<td style="padding-left: 45px;">${DealingsDocVO.rnum}</td>
								<td class="modal-btn" data-docno="${DealingsDocVO.docNo}" style="cursor: pointer;">
									${DealingsDocVO.docTtl}
								</td>
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
					<tfoot>
					    <tr>
					        <td colspan="7" style="text-align: right;">
					           <button id="regBtn"
									   class="bg-blue-500 text-white px-4 py-2 rounded mr-2">등록</button>
					        </td>
					    </tr>
					</tfoot>
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

	<!-- 거래처 상세정보 Modal -->
	<div id="detailModal" class="modal" style="display: none;">
	    <div class="modal-content modal-content-top">
			<div id="modalHeader">
				<h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">검토 요청 정보</h2>
			</div>
			
			<br>
			
			<div id="modalBody">
				<!-- 여기 아래에 input 태그 추가 -->
				<div class="grid gap-3 mb-3 lg:grid-cols-2">
					<div>
						<label for="docNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							서류 번호
						</label>
						<input type="text" id="docNo" name="docNo"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="wrtYmd"	class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							작성 일자
						</label>
						<input type="text" id="wrtYmd" name="wrtYmd"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="empNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							담당자명
						</label>
						<input type="text" id="empNm" name="empNm"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="cntrNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							계약자명
						</label>
						<input type="text" id="cntrNm" name="cntrNm"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<c:choose>
					    <c:when test="${rprsvNm != null}">
					        ${rprsvNm}
					    </c:when>
					    <c:otherwise>
					        ${custNm}
					    </c:otherwise>
					</c:choose>
										
					<div>
						<label for="ctrtAmt" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							계약 금액
						</label>
						<input type="text" id="ctrtAmt" name="ctrtAmt"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="clsfNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							결재 상태
						</label>
						<input type="text" id="clsfNm" name="clsfNm"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
				</div>	
				<div class="grid gap-3 mb-3">
					<div>
						<label for="docTtl" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							서류 제목
						</label>
						<input type="text" id="docTtl" name="docTtl"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
					<div>
						<label for="ctrtCn" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							서류 내용
						</label>
						<input type="text" id="ctrtCn" name="ctrtCn"
							   class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>