<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 로그인 후 정보 확인 시작 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!-- 로그인 후 정보 확인 끝 -->

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">

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

.swal2-icon { /* 아이콘 */
	font-size: 8px !important;
	width: 40px !important;
	height: 40px !important;
}

.swal2-confirm, .swal2-cancel {
	font-size: 14px; /* 텍스트 크기 조정 */
	width: 75px;
	height: 35px;
	padding: 0px;
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

.swal2-title { /* 타이틀 텍스트 사이즈 */
	font-size: 18px !important;
	padding: 2em;
}

.swal2-container.swal2-center>.swal2-popup {
	padding-top: 30px;
}
</style>

<script type="text/javascript">
function addSalaryDetailsToTable(salaryDetail) {
	console.log("데이터 수신:", salaryDetail);

	// '데이터가 없습니다.' 메시지 삭제
	$("#salaryDetailTable tbody tr").each(function() {
		if($(this).find("td").length == 1 && $(this).find("td").attr("colspan") == "12") {
			$(this).remove(); // '데이터가 없습니다.' 메시지 삭제
		}
	});
	
	var newRow = "<tr>";
	newRow += "<td>" + salaryDetail.trgtEmpNo + "</td>";
	newRow += "<td>" + salaryDetail.trgtEmpNm + "</td>";
	newRow += "<td>" + salaryDetail.otmPay + "</td>";
	newRow += "<td>" + salaryDetail.holPay + "</td>";
	newRow += "<td>" + salaryDetail.nitPay + "</td>";
	newRow += "<td>" + salaryDetail.famAlwnc + "</td>";
	newRow += "<td>" + salaryDetail.mealCt + "</td>";
	newRow += "<td>" + salaryDetail.npn + "</td>";
	newRow += "<td>" + salaryDetail.hlthinsIrncf + "</td>";
	newRow += "<td>" + salaryDetail.emplyminsrncIrncf + "</td>";
	newRow += "<td>" + salaryDetail.ecmt + "</td>";
	newRow += "<td>" + salaryDetail.llx + "</td>";
	newRow += "</tr>";

	// 테이블에 새 행 추가
	$("#salaryDetailTable tbody").append(newRow);

	// 로컬 스토리지에 저장
	var salaryDetailsList = JSON.parse(localStorage.getItem("salaryDetailsList")) || [];
	salaryDetailsList.push(salaryDetail);
	localStorage.setItem("salaryDetailsList", JSON.stringify(salaryDetailsList));
}

//양식 다운로드
$(document).ready(function(){
	// 로컬 스토리지 클리어: 새로고침 시 모든 데이터 삭제
	localStorage.clear();

	// 로컬 스토리지에서 데이터 가져와서 테이블에 추가
	var salaryDetailsList = JSON.parse(localStorage.getItem("salaryDetailsList")) || [];
	salaryDetailsList.forEach(function(salaryDetail) {
		addSalaryDetailsToTable(salaryDetail);
	});
	
	// 파일 선택 시 파일 이름 출력
	$("#uploadFile").on("change", function() {
		const files = $(this)[0].files;
		let fileList = "";
		for (let i = 0; i < files.length; i++) {
			fileList += files[i].name + "<br>";
		}
		$("#fileList").html(fileList); // 파일 이름을 표시할 영역에 출력
	});
	
	$("#download").on("click", function(){
		window.location.href = '/resources/upload/excel/급여명세서_양식.xlsx';
	});
	
	$("#salaryRegistPost").on("click", function(event) {
	    const fileInput = $("#uploadFile").get(0);
	    
	    if (fileInput.files.length === 0) {
	        Swal.fire({
	            title: '파일을 선택해주세요.',
	            icon: 'warning',
	            confirmButtonColor: '#4E7DF4',
	            confirmButtonText: '확인'
	        });
	        event.preventDefault(); 
	        return false;
	    }
	
	    const fileName = fileInput.files[0].name;
	    const fileExtension = fileName.split('.').pop().toLowerCase(); 
	
	    if (fileExtension !== 'xls' && fileExtension !== 'xlsx') {
	        Swal.fire({
	            title: '지원하지 않는 파일 형식입니다. 엑셀 파일만 업로드해주세요.',
	            icon: 'error',
	            confirmButtonColor: '#4E7DF4',
	            confirmButtonText: '확인'
	        });
	        event.preventDefault(); 
	        return false;
	    }
	
	    $("#uploadForm").submit();
	});
	
	// 각 tr에 클릭 이벤트 추가
	$('#salaryDetailTable tbody').on('click', 'tr', function() {
        const row = $(this);
        
        const noDataMessageExists = $('#noDataMessage').length > 0;

        if (noDataMessageExists) {
            Swal.fire({
                title: '데이터가 존재하지 않습니다.',
                icon: 'error',
                confirmButtonColor: '#4E7DF4',
                confirmButtonText: '확인'
            });
        } else {
            Swal.fire({
                title: '리스트를 삭제하시겠습니까?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#4E7DF4',
                confirmButtonText: '예',
                cancelButtonText: '아니오',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    row.remove();

                    const remainingRows = $('#salaryDetailTable tbody tr').length;

                    if (remainingRows === 0) {
                        $('#salaryDetailTableBody').append('<tr id="noDataMessage"><td colspan="12">데이터가 존재하지 않습니다.</td></tr>');
                    }
                }
            });
        }
    });
	
	
	$("#salaryRegist").on("click", function() {
		var salaryDetails = [];
		
		document.querySelectorAll("#salaryDetailTable tbody tr").forEach(function(row) {
			var salaryDetail = {
			    trgtEmpNo: row.cells[0].textContent,
			    trgtEmpNm: row.cells[1].textContent,
			    otmPay: parseInt(row.cells[2].getAttribute('data-value'), 10),
			    holPay: parseInt(row.cells[3].getAttribute('data-value'), 10),
			    nitPay: parseInt(row.cells[4].getAttribute('data-value'), 10),
			    famAlwnc: parseInt(row.cells[5].getAttribute('data-value'), 10),
			    mealCt: parseInt(row.cells[6].getAttribute('data-value'), 10),
			    npn: parseInt(row.cells[7].getAttribute('data-value'), 10),
			    hlthinsIrncf: parseInt(row.cells[8].getAttribute('data-value'), 10),
			    emplyminsrncIrncf: parseInt(row.cells[9].getAttribute('data-value'), 10),
			    ecmt: parseInt(row.cells[10].getAttribute('data-value'), 10),
			    llx: parseInt(row.cells[11].getAttribute('data-value'), 10)
			};
		    salaryDetails.push(salaryDetail);
		});
		
		console.log(JSON.stringify(salaryDetails));

		// AJAX 요청
        $.ajax({
            url: "/salaryDetails/batchRegistPost",
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(salaryDetails),
            beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
            success: function(response) {
                // 성공 시 처리할 코드
                Swal.fire({
                    title: '등록 성공!',
                    text: '급여명세서가 성공적으로 등록되었습니다.',
                    icon: 'success',
                    confirmButtonColor: '#4E7DF4',
                    confirmButtonText: '확인'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = "/salaryDetails/list";
                    }
                });
            },
            error: function(error) {
                console.log('일괄 등록 중 오류 발생:', error);
                Swal.fire({
                    title: '등록 중 오류가 발생했습니다.',
                    icon: 'warning',
                    confirmButtonColor: '#4E7DF4',
                    confirmButtonText: '확인'
                });
            }
        });
    });
});
</script>


<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 ">
	<div class="w-full flex justify-between items-center pl-3">
		<div class="mt-5">
			<h3 class="text-lg font-semibold text-slate-800">급여명세서 작성</h3>
			<p class="text-slate-500">10월 급여명세서 작성</p>
		</div>
	</div>
	
	<div class="flex flex-col mx-auto mb-6">
		<form id="uploadForm" action="/salaryDetails/uploadExcel" method="post" enctype="multipart/form-data" class="flex items-center space-x-4">
			<div>
				<label class="text-md text-gray-600">첨부파일</label>
			</div>
			<!-- 첨부파일 아이콘 -->
			<div class="icons flex text-gray-500 m-2">
				<label id="select-image">
					<svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" troke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
                    </svg>
                    <input type="file" id="uploadFile" name="uploadFile" multiple hidden />
				</label>
				<!-- 파일 이름 출력 영역 -->
				<div id="fileList" class="text-sm text-gray-500 mt-2"></div>
			</div>
			
			
			<div class="ml-auto flex space-x-3">
				<button id="salaryRegistPost" type="button" style="cursor:pointer; background:none; border:none;">
				    <img src="${pageContext.request.contextPath}/resources/images/document/문서업로드3.png" alt="문서 업로드" />
				</button>
				<button id="download" type="button" style="cursor:pointer; background:none; border:none;">
				    <img src="${pageContext.request.contextPath}/resources/images/document/문서다운로드3.png" alt="문서 다운로드" />
				</button>
				<button id="salaryRegist" type="button"
					class="text-white font-bold uppercase text-sm px-3 py-2 rounded outline-none focus:outline-none mb-1 ease-linear transition-all duration-150"
					style="background-color: #4E7DF4;">등록</button>
				<button id="return" type="button" onclick="window.location.href='http://localhost/salaryDetails/list'"
					class="text-white font-bold uppercase text-sm px-3 py-2 rounded outline-none focus:outline-none mb-1 ease-linear transition-all duration-150"
					style="background-color: #4E7DF4;">돌아가기</button>
			</div>
			<sec:csrfInput />
		</form>
	</div>

	<div class="relative flex flex-col w-full h-full text-gray-700 bg-white py-4 my-6 shadow-md rounded-lg bg-clip-border">
		<p class="text-right mr-4 text-sm font-thin text-gray-700">리스트를 클릭하시면 삭제됩니다.</p>
		<p class="text-right mr-4 text-sm font-thin text-gray-700">단위 (원)</p>
		<div class="card-body table-responsive p-2" style="height: 650px; overflow-y: scroll;">
			<table id="salaryDetailTable" class="table table-hover text-nowrap" style="text-align: center;">
				<thead>
					<tr>
						<th>사원 번호</th>
						<th>사원명</th>
						<th>연장근로수당</th>
						<th>휴일근로수당</th>
						<th>야간근로수당</th>
						<th>가족 수당</th>
						<th>식대</th>
						<th>국민연금</th>
						<th>건강보험</th>
						<th>고용보험</th>
						<th>소득세</th>
						<th>지방세</th>
					</tr>
				</thead>
				<tbody id="salaryDetailTableBody">
					<c:if test="${not empty salaryDetailsDocList}">
						<c:forEach var="salaryDetail" items="${salaryDetailsDocList}">
							<tr>
								<td>${salaryDetail.trgtEmpNo}</td>
								<td>${salaryDetail.trgtEmpNm}</td>
								<td data-value="${salaryDetail.otmPay}">
								   <fmt:formatNumber value="${salaryDetail.otmPay}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.holPay}">
								   <fmt:formatNumber value="${salaryDetail.holPay}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.nitPay}">
								   <fmt:formatNumber value="${salaryDetail.nitPay}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.famAlwnc}">
								   <fmt:formatNumber value="${salaryDetail.famAlwnc}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.mealCt}">
								   <fmt:formatNumber value="${salaryDetail.mealCt}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.npn}">
								   <fmt:formatNumber value="${salaryDetail.npn}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.hlthinsIrncf}">
								   <fmt:formatNumber value="${salaryDetail.hlthinsIrncf}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.emplyminsrncIrncf}">
								   <fmt:formatNumber value="${salaryDetail.emplyminsrncIrncf}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.ecmt}">
								   <fmt:formatNumber value="${salaryDetail.ecmt}" type="number" groupingUsed="true"/>
								</td>
								<td data-value="${salaryDetail.llx}">
								   <fmt:formatNumber value="${salaryDetail.llx}" type="number" groupingUsed="true"/>
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if
						test="${empty salaryDetailsDocList || salaryDetailsDocList == null}">
						<tr id="noDataMessage">
							<td colspan="12">데이터가 존재하지 않습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>
</div>
