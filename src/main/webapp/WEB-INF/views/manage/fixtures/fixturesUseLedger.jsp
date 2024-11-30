<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!-- jQuery 라이브러리 (최신 버전) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- jQuery UI 라이브러리 -->
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<!-- jQuery UI CSS (자동완성 UI 스타일 포함) -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>

<!-- JavaScript -->
<script type="text/javascript">

$(document).ready(function(){
	
	console.log("Autocomplete 초기화 코드 실행됨"); // 초기화 코드 확인
	
	// jQuery UI Autocomplete 로드 여부 확인
    console.log("jQuery UI Autocomplete 로드 확인: ", $().autocomplete);
	
    $(".truncate-text").each(function() {
        var text = $(this).text().trim();
        var maxLength = 25; // 원하는 글자 수 설정
        
        if(text.length > maxLength) {
            $(this).text(text.substring(0, maxLength) + '...');
        }
    });
});




$(document).ready(function(){
	
    
       $('.open-detail-modal').click(function(event){
    	    event.preventDefault(); // 링크 기본 동작 방지

    	    // 데이터 속성 가져오기
    	    let mngNo = $(this).data('mng-no');
    	    let useYmd = String($(this).data('use-ymd')); // 문자열로 변환
    	    let rtnYmd = String($(this).data('rtn-ymd')); // 문자열로 변환
    	    let usePrps = $(this).data('use-prps');
    	    let remark = $(this).data('rmrk-cn');
			let fxtrsNo = $(this).data('fxtrs-no');
			let empNo = $(this).data('emp-no');
			let useEnv = $(this).data('use-env');
			let costInc = $(this).data('cost-inc');
			let costRsn = $(this).data('cost-rsn');
			let empNm = $(this).data('emp-nm');
			let deptCd = $(this).data('dept-cd');
			let fxtrsNm = $(this).data('fxtrsNm');

    	    // 날짜 형식 변환 (4자리씩 잘라서 하이픈 추가)
    	    let formattedUseYmd = useYmd.slice(0, 4) + '-' + useYmd.slice(4, 6) + '-' + useYmd.slice(6, 8);
    	    let formattedRtnYmd = rtnYmd.slice(0, 4) + '-' + rtnYmd.slice(4, 6) + '-' + rtnYmd.slice(6, 8);
    	    
    	    console.log("formattedUseYmd",formattedUseYmd);
    	    console.log("formattedRtnYmd",formattedRtnYmd);

    	    // 데이터 확인 로그
    	    console.log("mngNo:", mngNo);
    	    console.log("useYmd:", useYmd);
    	    console.log("rtnYmd:", rtnYmd);
    	    console.log("usePrps:", usePrps);
    	    console.log("remark:", remark);
			console.log("fxtrsNo",fxtrsNo);
			console.log("empNo",empNo);
			console.log("useEnv",useEnv);
			console.log("costInc",costInc);
			console.log("costRsn",costRsn);
			console.log("empNm",empNm);
			console.log("deptCd",deptCd);
			console.log("fxtrsNm",fxtrsNm);

			
    	    // 모달의 input 필드에 데이터 삽입
    	    $('#fixMngNo').val(mngNo);
    	    $('#fUseYmd').val(formattedUseYmd);          // 사용 일자
    	    $('#fRtnYmd').val(formattedRtnYmd);          // 반납 일자
    	    $('#fixUsePrps').val(usePrps);        // 사용 목적
			$('#fixUseEnv').val(useEnv);
			$('#fixCostInc').val(costInc);
			$('#fixCostRsn').val(costRsn);
			$('#fixRmrkCn').val(remark);
			$('#fixFxtrsNo').val(fxtrsNo);
			$('#fixFxtrsNm').val(fxtrsNm);
			$('#fixEmpNo').val(empNo);
			
    	    //$('#empInfo').val(deptCd);
    	
    	    $('#InfoEmpDetail').val("["+deptCd+"]"+" "+empNm);
    	    console.log("empInfo 값:", $('#empInfo').val());  // 설정된 값 확인
    	        	    
    	    
    	    // 숨겨진 input에서 로그인된 사용자 empNo 가져오기
    	    let loggedEmpNo = $('#loggedEmpNo').val();
    	    console.log("Logged in empNo from hidden input:", loggedEmpNo);

    	    // empNo 비교 전 값 확인
    	    console.log("loggedEmpNo:", loggedEmpNo, "empNo:", empNo);

    	    // 공백 제거 후 비교
    	    if (String(loggedEmpNo).trim() === String(empNo).trim()) {
    	        $('#saveButton').show(); // 저장 버튼 보임
    	    } else {
    	        $('#saveButton').hide(); // 저장 버튼 숨김
    	    }

    	    // 모달 열기
    	    $('#detailModal').modal('show');
    	});
       
    
       // '비품 등록' 버튼 클릭 시 SweetAlert 경고창 표시
       $('#insert').click(function() {
           Swal.fire({
               title: '비품 사용에 대한 승인을 받으셨습니까?',
               icon: 'warning',
               showCancelButton: true,
               confirmButtonColor: '#4E7DF4',
               confirmButtonText: '확인',
               cancelButtonText: '취소'
           }).then((result) => {
               if (result.isConfirmed) {
                   // 사용자가 '네, 승인 받았습니다'를 눌렀을 때만 모달 열기
                   $('#regForm')[0].reset();  // 폼 리셋
                   $('#registerModal').modal('show');  // 모달 열기
               }
           });
       });
       
	
     //자동완성
       $('#fxtrsNm').autocomplete({
           source: function(request, response) {
               $.ajax({
                   url: "/fixtures/autocomplete",
                   type: "POST",
                   dataType: "JSON",
                   data: { fxtrsNm: request.term },
                   beforeSend:function(xhr){
       				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
       			},
                   success: function(data) {
                   	console.log("Data : " , data);
                       response(
                           $.map(data.resultList, function(item) {
                               // 검색어를 하이라이트 처리
                               var highlightedName = item.FXTRS_NM.replace(
                                   new RegExp("(" + request.term + ")", "gi"), 
                                   "<span class='highlight'>$1</span>"
                               );

                               return {
                               	label: highlightedName + " (" + item.FXTRS_PSTN_NM  + ")", 
                                   value: item.FXTRS_NM,      // 선택 시 입력 필드에 표시될 값
                                   idx: item.FXTRS_NO         // 비품 번호
                               };
                           })
                       );
                   },
                   error: function(jqXHR, textStatus, errorThrown) {
                       console.error("AJAX 요청 중 오류 발생: " + textStatus);
                       console.error("오류 상세: " + errorThrown);
                       console.error("응답 텍스트: " + jqXHR.responseText);
                       alert("오류가 발생했습니다.");
                   }
               });
           },
           select: function(evt, ui) {
               $('#fixNo').val(ui.item.idx);
               $('#fxtrsNm').val(ui.item.value);
               console.log("비품 번호: " + ui.item.idx);
               return false;
           }
       }).data("ui-autocomplete")._renderItem = function(ul, item) {
           return $("<li>").append("<div>" + item.label + "</div>")  // label에 하이라이트 적용된 값이 들어감
               .appendTo(ul);
       };
      

});



</script>

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

      .title-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            border-bottom: 2px solid #e5e7eb;
            padding-bottom: 0.5rem;
        }

        .title {
            font-size: 1.25rem;
            font-weight: bold;
            color: #1f2937;
            margin: 0;
        }

        .title-wrapper .date {
            font-size: 0.875rem;
            color: #6b7280;
        }

        #ntcCn {
            resize: none;
            overflow-y: auto;
            height: 400px;
            width: 100%;
        }

        .icons {
            margin-top: 10px;
            display: flex;
            align-items: center;
        }

        .icons svg {
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .icons svg:hover {
            color: #4b5563;
        }

        .text-sm {
            font-size: 0.875rem;
        }

        .flex {
            display: flex;
        }

        .justify-end {
            justify-content: flex-end;
        }

        #category {
            color: #4E7DF4;
        }

        .swal2-icon {
            font-size: 8px !important;
            width: 40px !important;
            height: 40px !important;
        }

        .swal2-styled.swal2-cancel {
            font-size: 14px;
            background-color: #f8f9fa;
            color: black;
            border: 1px solid #D9D9D9;
        }

        .swal2-styled.swal2-confirm {
            font-size: 14px;
            margin-left: 10px;
        }

        .swal2-title {
            font-size: 18px !important;
            padding: 2em;
        }

        .swal2-container.swal2-center>.swal2-popup {
            padding-top: 30px;
        }
.bg-indigo-500 {
	background-color: #4E7DF4;
}

#deleteSelected {
	background-color: #eb4634;
}

.dropdown-menu {
    position: absolute;
    z-index: 1000; /* 필요시 값 조정 */
}

select {
    max-height: none; /* 최대 높이 설정 안 함 */
    overflow: hidden !important; /* 스크롤 없앰 */
}


.ui-autocomplete {
    z-index: 1051; /* 모달보다 높은 값으로 설정 */
}

</style>

<body>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<%-- ${fixturesLedgerList} --%>
<%-- ${fixturesVOList} --%>

<div class="max-w-7xl mx-auto sm:px-6 lg:px-8"> 
	<div class="w-full flex justify-between items-center mb-3 mt-1 pl-3">
	<input type="hidden" id="loggedEmpNo" value="${empVO.empNo}" />
	    <div style="margin-top: 30px; margin-bottom: 10px;">
	        <h3 class="text-lg font-semibold text-slate-800">비품 관리 대장</h3>
	        <p class="text-slate-500">비품 사용 승인 후 반납 건에 대해서만 작성이 가능합니다.</p>
	    </div>
	</div>	


<!-- 검색 -->
<div class="flex justify-end mb-3">		
    <form id="searchForm" class="w-full flex flex-wrap items-center justify-end space-y-4 md:space-y-0 md:space-x-4">
        <!-- 기간 검색 필드 -->
        <div class="flex items-center space-x-2 w-full md:w-auto">
            <label for="startDate" class="text-gray-700" style="width: 80px;">기간</label>
            <input type="date" id="startDate" name="startDate"
                   class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
                   value="${param.startDate != null ? param.startDate : ''}"/>                                                                                                                                                                                                    
            <span>-</span>
            <input type="date" id="endDate" name="endDate"
                   class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
                   value="${param.endDate != null ? param.endDate : ''}"/>
        </div>

        <!-- 차량 번호, 사용 목적, 사용자 검색 필드 및 검색어 필드 수평 정렬 -->
        <div class="flex items-center space-x-4 w-full md:w-auto">
            <!-- 차량 번호, 사용 목적, 사용자 검색 필드 -->
            <div class="relative w-full md:w-auto">
                <select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
                    <option value="" selected disabled>선택해주세요</option>
                    <option value="fixNm" ${param.searchField == 'fixNm' ? 'selected' : ''}>품명</option>
                    <option value="purpose" ${param.searchField == 'purpose' ? 'selected' : ''}>사용 목적</option>
                    <option value="user" ${param.searchField == 'user' ? 'selected' : ''}>사용자</option>
                </select>
            </div>

            <!-- 검색어 및 검색 버튼 -->
            <div class="relative w-full md:w-auto flex-grow">
                <div class="relative">
                    <input type="text" name="keyword" value="${param.keyword}"
                           class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400 shadow-sm focus:shadow-md"
                           placeholder="검색어를 입력하세요." style="background-color:white !important;" />
                    <button type="submit" class="absolute h-8 w-8 right-1 top-1 my-auto px-2 flex items-center bg-white rounded">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-8 h-8 text-slate-600">
                            <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </form>		
</div>

    <div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
       <div class="card-body table-responsive p-0">
            <table style="text-align:center;"class="table table-hover text-nowrap">
               <thead>
                  <tr>
                     <th>번호</th>
                     <th>사용 일자</th>
                     <th>품명</th>
                     <th>사용 목적</th>
                     <th>사용 환경</th>
                     <th>비용 발생</th>
                     <th>발생 사유</th>
                     <th>사용자</th>
                  </tr>
               </thead>
               <tbody>
                   <c:forEach var="fixLedger" items="${articlePage.content}">
                     <tr> 
                     	<!-- 번호 -->
                        <td>${fixLedger.rnum}</td>
                        
                           <!-- 사용 일자  -->
                       <td>
						  <fmt:parseDate value="${fixLedger.useYmd}" pattern="yyyyMMdd" var="parsedDate" />
						  <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" /> -
						   <fmt:parseDate value="${fixLedger.rtnYmd}" pattern="yyyyMMdd" var="parsedDate" />
						    <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" />
					   </td>
                        <td style="text-align:left;">
                           <a href="#" class="open-detail-modal"
						       data-mng-no="${fixLedger.mngNo}"
						       data-use-ymd="${fixLedger.useYmd}"
						       data-rtn-ymd="${fixLedger.rtnYmd}"
						       data-use-prps="${fixLedger.usePrps}"
						       data-rmrk-cn="${fixLedger.rmrkCn}"
						       data-fxtrs-no="${fixLedger.fxtrsNo}"
						       data-emp-no="${fixLedger.empNo}"
							   data-use-env="${fixLedger.useEnv}"
							   data-cost-inc="${fixLedger.costInc}"
							   data-cost-rsn="${fixLedger.costRsn}"
							   data-dept-cd ="${fixLedger.deptCd}"
							   data-emp-nm="${fixLedger.empNm}"
							   data-fxtrs-nm="${fixLedger.fxtrsNm}"
						       >
						       
								<!-- 검색어 강조 및 텍스트 자르기 -->
						       <c:set var="highlightKeyword" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
						       <span class="truncate-text">
						           <c:out value="${fn:replace(fixLedger.fxtrsNm, param.keyword, highlightKeyword)}" escapeXml="false" />
						       </span>
							</a>
						</td>
                        <!-- 사용 목적 -->
                        <td>						       
						       <!-- 검색어 강조 및 텍스트 자르기 -->
						       <c:set var="highlightKeyword" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
						       <span class="truncate-text">
						           <c:out value="${fn:replace(fixLedger.usePrps, param.keyword, highlightKeyword)}" escapeXml="false" />
						       </span>
						</td>
						<td>${fixLedger.useEnv}</td>
						<td>
						    <c:choose>
						        <c:when test="${fixLedger.costInc != null && fixLedger.costInc != 0}">
						            <fmt:formatNumber value="${fixLedger.costInc}" type="number" groupingUsed="true"/>
						        </c:when>
						        <c:otherwise>
						            -
						        </c:otherwise>
						    </c:choose>
						</td>
						<td><c:out value="${fixLedger.costRsn}" default="-"/></td>
						<td>
						    <c:set var="highlightKeyword" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
						    <span class="truncate-text">
						        [${fixLedger.deptCd}] 
						        <c:out value="${fn:replace(fixLedger.empNm, param.keyword, highlightKeyword)}" escapeXml="false" />
						    </span>
						</td>
                     </tr>
                  </c:forEach>
               </tbody>
               <tfoot>
             	 <tr>
					<td colspan="9" style="text-align: right;">
						<button class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							    name="insert" id="insert" type="button">등록</button>
					</td>
				</tr>
               </tfoot>
            </table>
         </div>
       
<nav aria-label="Page navigation" style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
    <ul class="inline-flex space-x-2">
        <!-- startPage가 5보다 클 때만 [이전] 활성화 -->
        <li>
            <c:if test="${articlePage.startPage > 5}">
                <a href="/fixtures/ledger?currentPage=${articlePage.startPage-5}&searchField=${param.searchField}&keyword=${param.keyword}&position=${param.position}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}"
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
                    <button id="button-${pNo}" 
                        onclick="javascript:location.href='/fixtures/ledger?currentPage=${pNo}&searchField=${param.searchField}&keyword=${param.keyword}&position=${param.position}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}';"
                        class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
                        style="background-color: #4E7DF4; color: white;">
                        ${pNo}
                    </button>
                </li>
            </c:if>

            <c:if test="${articlePage.currentPage != pNo}">
                <li>
                    <button id="button-${pNo}" 
                        onclick="javascript:location.href='/fixtures/ledger?currentPage=${pNo}&searchField=${param.searchField}&keyword=${param.keyword}&position=${param.position}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}';"
                        class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
                        style="color: #4E7DF4;">
                        ${pNo}
                    </button>
                </li>
            </c:if>
        </c:forEach>

        <!-- endPage < totalPages일 때만 [다음] 활성화 -->
        <li>
            <c:if test="${articlePage.endPage < articlePage.totalPages}">
                <a href="/fixtures/ledger?currentPage=${articlePage.startPage+5}&searchField=${param.searchField}&keyword=${param.keyword}&position=${param.position}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}"
                   class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
                    <svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
                        <path d="M7.293 14.707a1 1 0 010-1.414L10.586 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
                    </svg>
                </a>
            </c:if>
        </li>
    </ul>
</nav>
</div>		
</div>


<div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="bg-white px-4 pb-4 pt-4">
                    <span class="ml-1 text-lg font-bold mb-3 block">비품 사용 이력 상세</span>
                    <hr class="px-4 py-2">
                    <form id="updateFxtrsForm" action="/fixtures/updateFxtLedger?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
                        <div>
                        	<input type="hidden" id="fixMngNo" name="mngNo" />
                        </div>
                        <!-- ** 사용 일자 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="rvsdYmdStart" class="col-form-label col-4"><strong>사용 및 반납 일자 :</strong></label>
                            <input type="date" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5"
                            	   name="useYmd" id="fUseYmd" required placeholder="사용 일자를 선택해주세요">
                            <span class="mx-2">-</span>
                            <input type="date" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5"
                                   name="rtnYmd" id="fRtnYmd" required placeholder="반납 일자를 선택해주세요">
                        </div>
                        <input type="hidden" id="fixFxtrsNo" name="fxtrsNo" />
                        <!-- ** 사용 목적 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="fixUsePrps" class="col-form-label col-4"><strong>품명: </strong></label>
                            <input type="text" class="form-control" style="width:343px !important;" id="fixFxtrsNm" name="fxtrsNm" readonly>
                        </div>
                        <!-- ** 사용 목적 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="fixUsePrps" class="col-form-label col-4"><strong>사용 목적 : </strong></label>
                            <input type="text" class="form-control" style="width:343px !important;" id="fixUsePrps" name="usePrps">
                        </div>
                        <!-- ** 사용 환경 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="fixUseEnv" class="col-form-label col-4"><strong>사용 환경 : </strong></label>
                            <input type="text" class="form-control" style="width:343px !important;" id="fixUseEnv" name="useEnv">
                        </div>
                        <!-- ** 비용 발생 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="fixCostInc" class="col-form-label col-4"><strong>비용 발생 : </strong></label>
                            <input type="text" class="form-control" style="width:343px !important;" id="fixCostInc" name="costInc">
                        </div>
                        <!-- ** 발생 사유 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="fixCostRsn" class="col-form-label col-4"><strong>발생 사유 : </strong></label>
                            <input type="text" class="form-control" style="width:343px !important;" id="fixCostRsn" name="costRsn">
                        </div>
                       <!-- ** 사원 번호 ** -->
						<div class="form-group d-flex align-items-center">
						    <label for="empNo" class="col-form-label col-4"><strong>사용자 : </strong></label>
						    <!-- JavaScript에서 empNo 값을 설정할 hidden input -->
						    <input type="hidden" id="fixEmpNo" name="empNo" >						         
						    <input type="text" class="form-control col-8" id="InfoEmpDetail"  />
						</div>
                        <!-- 비고 내용 -->
                        <div class="form-group d-flex align-items-center">
                            <label for="fixRmrkCn" class="col-form-label col-4"><strong>비고 : </strong></label>
                            <textarea class="form-control col-8" id="fixRmrkCn" name="rmrkCn"></textarea>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer bg-gray-50 px-4 py-3 flex justify-center">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <!-- submit 버튼에 type="submit" 추가 -->
                <button type="submit" class="btn btn-primary" form="updateFxtrsForm" id="saveButton">저장</button>
            </div>
        </div>
    </div>
</div>

<!-- 비품 등록 모달 -->
<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="registerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="bg-white px-4 pb-4 pt-4">
                    <span class="ml-1 text-lg font-bold mb-3 block">비품 사용 이력 등록</span>
                    <hr class="px-4 py-2">
                    <form id="regForm" action="/fixtures/registFxtLedger?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
						
                        <!-- ** 사용 일자 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="rvsdYmdStart" class="col-form-label col-4"><strong>사용 및 반납 일자 :</strong></label>
                            <input type="date" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5" name="useYmd" id="registUseYmd" required placeholder="사용 일자를 선택해주세요">
                            <span class="mx-2">-</span>
                            <input type="date" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5" name="rtnYmd" id="registRtnYmd" required placeholder="반납 일자를 선택해주세요">
                        </div>
                        <div class="form-group d-flex align-items-center">
                        	<label for="fxtrsNm" class="col-form-label col-4"><strong>품명 : </strong></label>
							<input type="text" id="fxtrsNm" name="fxtrsNm"
								class="form-control" style="width:343px !important;"
								placeholder="비품명을 입력해주세요." required>
						</div>
						<input type="hidden" id="fixNo" name="fxtrsNo" />
                        <!-- ** 사용 목적 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="registUsePrps" class="col-form-label col-4"><strong>사용 목적 : </strong></label>
                            <input type="text" class="form-control" style="width:343px !important;" id="registUsePrps" name="usePrps">
                        </div>
                        <!-- ** 사용 환경 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="registUseEnv" class="col-form-label col-4"><strong>사용 환경 : </strong></label>
                            <input type="text" class="form-control" style="width:343px !important;" id="registUseEnv" name="useEnv">
                        </div>
                        <!-- ** 비용 발생 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="registCostInc" class="col-form-label col-4"><strong>비용 발생 : </strong></label>
                            <input type="number" class="form-control" style="width:343px !important;" id="registCostInc" name="costInc">
                        </div>
                        <!-- ** 비용 발생 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="registCostRsn" class="col-form-label col-4"><strong>발생 사유 : </strong></label>
                            <input type="text" class="form-control" style="width:343px !important;" id="registCostRsn" name="costRsn">
                        </div>
                        <!-- ** 사원 번호 ** -->
                        <div class="form-group d-flex align-items-center">
                            <label for="rempNo" class="col-form-label col-4"><strong>사용자 : </strong></label>
                            <input type="hidden" id="fixEmpNo" name="empNo"/>
                            <c:forEach var="empL" items="${empList}">
                                <c:if test="${empVO.empNo == empL.empNo}">
                                    <input type="text" class="form-control col-8" value="[${empL.deptCd}] ${empVO.empNm}">
                                </c:if>
                            </c:forEach>
                        </div>
                        <!-- 비고 내용 -->
                        <div class="form-group d-flex align-items-center">
                            <label for="registRmrkCn" class="col-form-label col-4"><strong>비고 : </strong></label>
                            <textarea class="form-control col-8" id="registRmrkCn" name="rmrkCn"></textarea>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer bg-gray-50 px-4 py-3 flex justify-center">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <!-- submit 버튼에 type="submit" 추가 -->
                <button type="submit" class="btn btn-primary" form="regForm">저장</button>
            </div>
        </div>
    </div>
</div>



