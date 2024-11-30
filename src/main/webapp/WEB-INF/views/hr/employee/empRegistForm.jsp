<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 로그인 후 정보 확인 시작 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!-- 로그인 후 정보 확인 끝 -->

<html>
<head>
    <meta charset="UTF-8">
    <title>사원 일괄 등록</title>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">

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
// 부모 창에 이 함수를 추가해 팝업 창에서 데이터를 넘겨받아 처리
function addEmployeeToTable(employee) {
	console.log("사원 데이터 수신:", employee);

	// '데이터가 없습니다.' 메시지 삭제
	$("#employeeTable tbody tr").each(function() {
		if($(this).find("td").length == 1 && $(this).find("td").attr("colspan") == "13") {
			$(this).remove(); // '데이터가 없습니다.' 메시지 삭제
		}
	});
	
	var newRow = "<tr>";
	newRow += "<td>" + employee.empNm + "</td>";
	newRow += "<td>" + employee.empRrno + "</td>";
	newRow += "<td>" + employee.empBrdt + "</td>";
	newRow += "<td>" + employee.empTelno + "</td>";
	newRow += "<td>" + employee.empEmlAddr + "</td>";
	newRow += "<td>" + employee.jncmpYmd + "</td>";
	newRow += "<td>" + employee.roadNmZip + "</td>";
	newRow += "<td>" + employee.roadNmAddr + "</td>";
	newRow += "<td>" + employee.daddr + "</td>";
	newRow += "<td>" + employee.jbgdCd + "</td>";
	newRow += "<td>" + employee.jbttlCd + "</td>";
	newRow += "<td>" + employee.deptCd + "</td>";
	newRow += "<td>" + employee.sexdstnCd + "</td>";
	newRow += "</tr>";

	// 테이블에 새 행 추가
	$("#employeeTable tbody").append(newRow);

	// 로컬 스토리지에 저장
	var employeeList = JSON.parse(localStorage.getItem("employeeList")) || [];
	employeeList.push(employee);
	localStorage.setItem("employeeList", JSON.stringify(employeeList));
}

$(function() {
	// 로컬 스토리지 클리어: 새로고침 시 모든 데이터 삭제
	localStorage.clear();

	// 로컬 스토리지에서 데이터 가져와서 테이블에 추가
	var employeeList = JSON.parse(localStorage.getItem("employeeList"))
			|| [];
	employeeList.forEach(function(employee) {
		addEmployeeToTable(employee);
	});

	//파일 선택 시 파일 이름 출력
	$("#uploadFile").on("change", function() {
		const files = $(this)[0].files;
		let fileList = "";
		for (let i = 0; i < files.length; i++) {
			fileList += files[i].name + "<br>";
		}
		$("#fileList").html(fileList); // 파일 이름을 표시할 영역에 출력
	});
	
	//양식 다운로드
	$("#download").on("click", function(){
		event.preventDefault();
		window.location.href = '/resources/upload/excel/사원등록양식.xlsx';  // 파일 경로
	});
	
	$("#empRegistPost").on("click", function(event) {
	    // 파일 입력 필드에서 선택된 파일이 있는지 확인
	    const fileInput = $("#uploadFile").get(0);
	    
	    if (fileInput.files.length === 0) {
	        Swal.fire({
	            title: '파일을 선택해주세요.',
	            icon: 'warning',
	            confirmButtonColor: '#4E7DF4',
	            confirmButtonText: '확인'
	        });
	        event.preventDefault(); // 폼 제출을 막음
	        return false;
	    }
	
	    // 파일의 확장자를 확인
	    const fileName = fileInput.files[0].name;
	    const fileExtension = fileName.split('.').pop().toLowerCase(); // 확장자 추출
	
	    if (fileExtension !== 'xls' && fileExtension !== 'xlsx') {
	        Swal.fire({
	            title: '지원하지 않는 파일 형식입니다. 엑셀 파일만 업로드해주세요.',
	            icon: 'error',
	            confirmButtonColor: '#4E7DF4',
	            confirmButtonText: '확인'
	        });
	        event.preventDefault(); // 폼 제출을 막음
	        return false;
	    }
	
	    // 파일이 엑셀 형식일 경우 폼 제출
	    console.log("업로드 버튼 눌렀지롱~");
	    $("#uploadForm").submit();
	});
	
	//사원 일괄 등록
	$("#empRegist").on("click", function(){
		var employees = [];
        // 테이블의 각 행을 순회하며 데이터를 수집
        document.querySelectorAll("#employeeTable tbody tr").forEach(function(row) {
            var employee = {
                empNm: row.cells[0].textContent,
                empRrno: row.cells[1].textContent,
                empBrdt: row.cells[2].textContent,
                empTelno: row.cells[3].textContent,
                empEmlAddr: row.cells[4].textContent,
                jncmpYmd: row.cells[5].textContent,
                roadNmZip: row.cells[6].textContent,
                roadNmAddr: row.cells[7].textContent,
                daddr: row.cells[8].textContent,
                jbgdCd: row.cells[9].textContent,
                jbttlCd: row.cells[10].textContent,
                deptCd: row.cells[11].textContent,
                sexdstnCd: row.cells[12].textContent
            };
            employees.push(employee);
        });
	
        // 수집한 데이터를 AJAX를 통해 서버로 전송
        $.ajax({
            url: '/employee/batchRegist',  // 서버에 일괄 등록 요청
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(employees),  // 수집한 데이터 JSON 형식으로 전송
            beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
            success: function(response) {
            	Swal.fire({
                    title: '사원 등록이 실행되었습니다.',
                    icon: 'success',
                    confirmButtonColor: '#4E7DF4',
                    confirmButtonText: '확인'
                }).then((result) => {
                	if (result.isConfirmed) {
                        if (window.opener) {
                            window.opener.location.reload();  // 부모 창 새로고침
                        }
                        window.close();  // 팝업 창 닫기
                    }
                })
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
	})
	
	//각 tr에 클릭 이벤트 추가
	$('#employeeTable tbody').on('click', 'tr', function() {
        const row = $(this); // 클릭된 행 저장
        
        // '데이터가 존재하지 않습니다' 메시지가 있는지 확인
        const noDataMessageExists = $('#noDataMessage').length > 0;

        if (noDataMessageExists) {
            // 데이터가 없을 때 경고창 띄우기
            Swal.fire({
                title: '데이터가 존재하지 않습니다.',
                icon: 'error',
                confirmButtonColor: '#4E7DF4',
                confirmButtonText: '확인'
            });
        } else {
            // 삭제 확인 창 띄우기
            Swal.fire({
                title: '리스트를 삭제하시겠습니까?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#4E7DF4',
                confirmButtonText: '확인',
                cancelButtonText: '취소',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    // "예" 버튼을 눌렀을 때만 행을 삭제
                    row.remove();
                    
                    // 남은 행이 있는지 확인
                    const remainingRows = $('#employeeTable tbody tr').length;
                    // 남은 행이 없으면 "데이터가 존재하지 않습니다." 메시지를 추가
                    if (remainingRows === 0) {
                        $('#employeeTableBody').append('<tr id="noDataMessage"><td colspan="13">데이터가 존재하지 않습니다.</td></tr>');
                    }
                }
            });
        }
    });
	
	//버튼 누르면  사원 수기 추가
	$("#addEmp").on("click",function() {
		// 두 번째 팝업 창 설정
		var popupOptions = "width=700,height=800,scrollbars=yes,resizable=yes";
		// 두 번째 팝업 창 열기 (창 이름: addEmpWindow)
		window.open('/employee/regist', 'addEmpWindow', popupOptions);
	});
});
</script>

</head>

<body>
<!-- 엑셀 파일 업로드 -->
<div class="sm:px-6 lg:px-8 my-8">
	<!-- 파일 입력 폼과 버튼을 한 줄로 정렬 -->
	<div class="flex flex-col mx-auto bg-white pt-4 mb-6">
		<form id="uploadForm" action="/employee/uploadExcel" method="post" enctype="multipart/form-data" class="flex items-center space-x-4">
			<div>
				<label class="text-md text-gray-600">첨부파일</label>
			</div>
			<!-- 첨부파일 아이콘 -->
			<div class="icons flex text-gray-500 m-2">
                <label id="select-image">
                    <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
                    </svg>
                   <input type="file" id="uploadFile" name="uploadFile" multiple hidden />
                </label>
                <!-- 파일 이름 출력 영역 -->
                <div id="fileList" class="text-sm text-gray-500 mt-1"></div>
            </div>

			<div class="ml-auto flex space-x-3">
				<button id="empRegistPost" type="button"
					class="text-white font-bold uppercase text-sm px-3 py-2 rounded outline-none focus:outline-none mb-1 ease-linear transition-all duration-150"
					style="background-color: #4E7DF4;">업로드</button>
				<button id="download" type="button"
					class="text-white font-bold uppercase text-sm px-3 py-2 rounded outline-none focus:outline-none mb-1 ease-linear transition-all duration-150"
					style="background-color: #4E7DF4;">다운로드</button>
				<button id="addEmp" type="button"
					class="text-white font-bold uppercase text-sm px-3 py-2 rounded outline-none focus:outline-none mb-1 ease-linear transition-all duration-150"
					style="background-color: #4E7DF4;">개별 입력</button>
				<button id="empRegist" type="button"
					class="text-white font-bold uppercase text-sm px-3 py-2 rounded outline-none focus:outline-none mb-1 ease-linear transition-all duration-150"
					style="background-color: #4E7DF4;">일괄 등록</button>
			</div>
			<sec:csrfInput />
		</form>
	</div>
	
	<!-- 사원 리스트 테이블 -->
	<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
		<p class="text-right text-sm font-thin text-gray-700 mb-4">리스트를 클릭하시면 삭제됩니다</p>
		<div id="empRegistTableDiv" class="card-body table-responsive p-2" style="height: 480px; overflow-y: scroll;">
			<table id="employeeTable" class="table table-hover text-nowrap" style="text-align: center;">
				<thead>
					<tr>
						<th>사원명</th>
						<th>주민등록번호</th>
						<th>생년월일</th>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
						<th>전화번호</th>
						<th>이메일 주소</th>
						<th>입사일</th>
						<th>우편번호</th>
						<th>도로명 주소</th>
						<th>상세 주소</th>
						<th>직급 코드</th>
						<th>직책 코드</th>
						<th>부서 코드</th>
						<th>성별 코드</th>
					</tr>
				</thead>
				<tbody id="employeeTableBody">
					<c:if test="${not empty employeeList}">
						<c:forEach var="employee" items="${employeeList}">
							<tr>
								<td>${employee.empNm}</td>
								<td>${employee.empRrno}</td>
								<td>${employee.empBrdt}</td>
								<td>${employee.empTelno}</td>
								<td>${employee.empEmlAddr}</td>
								<td>${employee.jncmpYmd}</td>
								<td>${employee.roadNmZip}</td>
								<td>${employee.roadNmAddr}</td>
								<td>${employee.daddr}</td>
								<td>${employee.jbgdCd}</td>
								<td>${employee.jbttlCd}</td>
								<td>${employee.deptCd}</td>
								<td>${employee.sexdstnCd}</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty employeeList || employeeList == null}">
						<tr id="noDataMessage">
							<td colspan="13">데이터가 존재하지 않습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>
</div>

</body>
</html>
