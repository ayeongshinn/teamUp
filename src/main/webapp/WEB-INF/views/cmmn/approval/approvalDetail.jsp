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
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/html2canvas.js"></script>
<script type="text/javascript" src="/resources/js/jspdf.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<title></title>
<script type="text/javascript">
	$(document).ready(function() {
		// 결재 의견 버튼 클릭 시 이벤트 처리
	    $('.atrzOpinionBtn').click(function() {
	    	$("#strTtl").text("결재 의견");
	    	
			// 현재 버튼의 가장 가까운 공통 부모
			var parentDiv = $(this).closest('div[style^="display: flex; position: relative;"]');
			
			var empName = parentDiv.find('.empName').text().trim();
			var empJbgd = parentDiv.find('.empJbgd').text().trim();
			var empDept = parentDiv.find('.empDept').text().trim();
			$("#strName").val(empName + " " + empJbgd + "(" + empDept + ")");
			
			// 날짜 변환
		    var atrzDt = parentDiv.find('.atrzYmd').val();
		    var formattedDate = formatDate(atrzDt);
		    $("#strSysDate").val(formattedDate);
			
			// 결재 의견
	    	$("#strCn").text($(this).siblings('.showAtrzOpinion').val())
			
			$("#modal3").show();
	    });
		
	    $("#strClose").on("click", function(){
			$("#modal3").hide();
		})

	    // 반려 사유 버튼 클릭 시 이벤트 처리 (같은 방식)
	    $('.rjctRsnBtn').click(function() {
			$("#strTtl").text("반려 사유");
	    	
			// 현재 버튼의 가장 가까운 공통 부모
			var parentDiv = $(this).closest('div[style^="display: flex; position: relative;"]');
			
			var empName = parentDiv.find('.empName').text().trim();
			var empJbgd = parentDiv.find('.empJbgd').text().trim();
			var empDept = parentDiv.find('.empDept').text().trim();
			$("#strName").val(empName + " " + empJbgd + "(" + empDept + ")");
			
			// 날짜 변환
		    var atrzDt = parentDiv.find('.atrzYmd').val();
		    var formattedDate = formatDate(atrzDt);
		    $("#strSysDate").val(formattedDate);
			
			// 반려 사유
	    	$("#strCn").text($(this).siblings('.showRjctRsn').val())
			
			$("#modal3").show();
	    });
		
		
		// 실시간으로 입력 감지하여 경고 메시지 제거
		$('#rjctRsn').on('keyup', function() {
			let rjctRsn = $(this).val(); // 텍스트 영역의 값 가져오기
			if (rjctRsn !== '') {
				$('.error-message').hide(); // 내용이 있으면 경고 메시지 숨기기
			}
		});
		
		$("#approvalChecked").on('click', function(){
			Swal.fire({
				title: '결재를 승인하시겠습니까?',
				icon: 'question', /* 종류 많음 맨 아래 링크 참고 */
				confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
				confirmButtonText: '확인',
				cancelButtonText: '취소',
				showCancelButton: true, /* 필요 없으면 지워도 됨, 없는 게 기본 */
				
				reverseButtons: true,
			
			}).then((result) => {
				if(result.isConfirmed){
					approveChecked();
				}
			});
		})
		
		// 버튼 클릭 시 처리
		$('#returnChecked').on('click', function(e) {
			e.preventDefault(); // 기본 동작 중단
			let rjctRsn = $('#rjctRsn').val(); // 텍스트 영역의 값 가져오기
			
			// 값이 비어있으면 경고 메시지 표시
			if (rjctRsn === '') {
				$('.error-message').show(); // 경고 메시지 표시
				$("#rjctRsn").focus();
			} else {
				$('.error-message').hide(); // 경고 메시지 숨기기
				
				Swal.fire({
					title: '결재를 반려하시겠습니까?',
					icon: 'question', /* 종류 많음 맨 아래 링크 참고 */
					confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
					confirmButtonText: '확인',
					cancelButtonText: '취소',
					showCancelButton: true, /* 필요 없으면 지워도 됨, 없는 게 기본 */
					
					reverseButtons: true,
				
				}).then((result) => {
					if(result.isConfirmed){
						returnChecked();
					}
				});
			}
		});
	});

	function formatDate(dateString) {
	    if (dateString.length !== 8) {
	        console.error("Invalid date string format. Expected YYYYMMDD, got:", dateString);
	        return "Invalid Date";
	    }
	    var year = dateString.substring(0, 4);
	    var month = dateString.substring(4, 6);
	    var day = dateString.substring(6, 8);
	    
	    // Date 객체 생성
	    var date = new Date(year, month - 1, day);
	    
	    // 요일 배열
	    var weekdays = ['일', '월', '화', '수', '목', '금', '토'];
	    var weekday = weekdays[date.getDay()];
	    
	    return year + "." + month + "." + day + "(" + weekday + ")";
	}
	
	function returnSuccess(docNo) {
		Swal.fire({
			title: '결재 요청이 반려 처리 되었습니다.',
			icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
			confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
			confirmButtonText: '확인',
		
		}).then((result) => {
			location.href="http://localhost/approval/approvalDetail?docNo=" + docNo;
		});
	}
	
	function approvalSuccess(docNo) {
		Swal.fire({
			title: '결재 요청이 승인 처리 되었습니다.',
			icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
			confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
			confirmButtonText: '확인',
		
		}).then((result) => {
			location.href="http://localhost/approval/approvalDetail?docNo=" + docNo;
		});
	}
	
	function approveChecked() {
		let isLastApprover = $("#isLastApprover").val() === "true";
		let atrzEmpNo = $('#atrzEmpNo').val();
		let atrzNo = $('#atrzNo').val();
		let docNo = $("#docNo").val();
		let atrzOpinion = $("#atrzOpinion").val()
		
		let data = {
				"isLastApprover" : isLastApprover,
				"atrzEmpNo" : atrzEmpNo,
				"atrzNo" : atrzNo,
				"atrzOpinion" : atrzOpinion
		}
		
		$.ajax({
			url:"/approval/approveAjax",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(result){
				approvalSuccess(docNo); 
			}
		});
	}
	
	function returnChecked() {
		let atrzEmpNo = $('#atrzEmpNo').val();
		let atrzNo = $('#atrzNo').val();
		let docNo = $("#docNo").val();
		let rjctRsn = $("#rjctRsn").val();
		
		let data = {
				"atrzEmpNo" : atrzEmpNo,
				"atrzNo" : atrzNo,
				"rjctRsn" : rjctRsn
		}
		
		$.ajax({
			url:"/approval/returnAjax",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(result){
				returnSuccess(docNo); 
			}
		});
	}
	
	$(function(){
		
		$("#downloadBtn").on("click", function() {
		    // 원래 스타일 저장 및 box-shadow 제거
		    const element = $('#pdfDown')[0];
		    const originalStyle = element.style.cssText;
		    $('.container').css('box-shadow', 'none');
		    
		    // A4 크기 및 여백 설정
		    const a4Width = 210; // A4 표준 너비 (mm)
		    const a4Height = 297; // A4 표준 높이 (mm)
		    const margins = 0; // 여백 (mm)
		    
		    // 임시로 스타일 조정
		    element.style.width = '230mm';  // A4 너비
		    element.style.margin = '0';
		    element.style.padding = '10mm';
		    
		    // 캡처 전에 요소의 실제 크기 계산
		    const actualWidth = element.scrollWidth + 2;
		    const actualHeight = element.scrollHeight + 2;
		    
		    // HTML을 캔버스로 변환 - 수정된 부분
		    html2canvas(element, {
		        scale: 2, // 해상도를 높여서 더 선명하게
		        useCORS: true,
		        logging: true,
		        width: actualWidth, // 실제 너비 사용
		        height: actualHeight, // 실제 높이 사용
		        scrollX: 0, // 스크롤 위치 고정
		        scrollY: 0,
		        x: 0, // 시작 x 위치
		        y: 0, // 시작 y 위치
		        foreignObjectRendering: true, // 외부 객체 렌더링 허용
		        removeContainer: false, // 임시 컨테이너 제거 방지
		        allowTaint: true, // cross-origin 이미지 허용
		        backgroundColor: '#FFFFFF', // 배경색 지정
		    }).then(function(canvas) {
		        // 나머지 코드는 동일...
		        var imgData = canvas.toDataURL('image/png');
		        var pdf = new jsPDF('p', 'mm', 'a4');
		        
		        const usableWidth = a4Width - (margins * 2);
		        const usableHeight = a4Height - (margins * 2);
		        
		        let imgWidth = usableWidth;
		        let imgHeight = (canvas.height * usableWidth) / canvas.width;
		        
		        if (imgHeight > usableHeight) {
		            const ratio = usableHeight / imgHeight;
		            imgWidth *= ratio;
		            imgHeight = usableHeight;
		        }
		        
		        const x = (a4Width - imgWidth) / 2;
		        const y = (a4Height - imgHeight) / 2;
		        
		        const pageHeight = pdf.internal.pageSize.height;
		        let remainingHeight = imgHeight;
		        let yPosition = margins;
		        let page = 1;
		        while (remainingHeight > 0) {
		            pdf.addImage(imgData, 'PNG', x, yPosition, imgWidth, imgHeight);
		            remainingHeight -= (pageHeight - margins * 2);
		            
		            if (remainingHeight > 0) {
		                pdf.addPage();
		                yPosition = margins - (page * (pageHeight - margins * 2));
		                page++;
		            }
		        }
		        
		        pdf.save('file-name.pdf');
		        element.style.cssText = originalStyle;
		        $('.container').css('box-shadow', '5px 5px 0 #AAAAAA');
		    }).catch(function(error) {
		        console.error('PDF 생성 중 오류 발생:', error);
		        element.style.cssText = originalStyle;
		        $('.container').css('box-shadow', '5px 5px 0 #AAAAAA');
		    });
		});
		
		var empNm = $("#formattedName").attr('data-name');
		var fmtEmpNm = empNm.split('').join(' ');

		// 텍스트와 이미지를 결합하여 출력
		
		var drftImageHtml = '<div class="stamp-container"><span class="seal">(인)</span><img src="' + $("#drftImage").attr('src') + '" class="inline-img"/></div>';

		$("#formattedName").html("신 청 인 :&ensp;&ensp; " + fmtEmpNm + "&ensp;&ensp; " + drftImageHtml);
		
		$("#backBtn").on("click", function(){
			history.back();
			
		});
		
		$("#approveBtn").on("click", function(){
			var today = new Date();
			var dateString = today.getFullYear() + ('0' + (today.getMonth() + 1)).slice(-2) + ('0' + today.getDate()).slice(-2);
			$("#approvalSysDate").val(formatDate(dateString));
			
			let deptCd = "${empVO.deptCd}"; // 부서 코드
			let jbgdCd = "${empVO.jbgdCd}"; // 직급 코드
			
			let data = {
					"clsfCd1" : deptCd,
					"clsfCd2" : jbgdCd,
			}
			
			$.ajax({
				url:"/tiles/getDept",
				contentType:"application/json;charset=utf-8",
				data:JSON.stringify(data),
				type:"post",
				dataType:"json",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success:function(res){
					
					let jbgdNm = "";
					
					if(res[1].clsfNm == '부장') jbgdNm = "팀장";
					else jbgdNm = res[1].clsfNm;
					
					$("#approvalName").val("${empVO.empNm} " + jbgdNm + "(" + res[0].clsfNm + ")");
				}
			});
			
			$("#modal2").show();
		});
		
		$("#approvalClose").on("click", function(){
			$("#modal2").hide();
		})
		
		$("#returnBtn").on("click", function(){
			var today = new Date();
			var dateString = today.getFullYear() + ('0' + (today.getMonth() + 1)).slice(-2) + ('0' + today.getDate()).slice(-2);
			$("#returnSysDate").val(formatDate(dateString));
			
			let deptCd = "${empVO.deptCd}"; // 부서 코드
			let jbgdCd = "${empVO.jbgdCd}"; // 직급 코드
			
			let data = {
					"clsfCd1" : deptCd,
					"clsfCd2" : jbgdCd,
			}
			
			$.ajax({
				url:"/tiles/getDept",
				contentType:"application/json;charset=utf-8",
				data:JSON.stringify(data),
				type:"post",
				dataType:"json",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success:function(res){
					
					let jbgdNm = "";
					
					if(res[1].clsfNm == '부장') jbgdNm = "팀장";
					else jbgdNm = res[1].clsfNm;
					
					$("#returnName").val("${empVO.empNm} " + jbgdNm + "(" + res[0].clsfNm + ")");
				}
			});
			
			$("#modal1").show();
		})
		
		$("#returnClose").on("click", function(){
			$("#modal1").hide();
		})
	})
</script>
<style type="text/css">

   /* 대쉬 보드 시작 */
   	.dashboard {
		display: grid;
		grid-template-columns: 2fr 0.7fr;
		grid-template-rows: 1fr;
		grid-gap: 40px;
		padding: 60px;
		min-height: 143vh;	/* 디테일에도 추가 */
	}
	
	.approvalLine {
	    position: sticky;
	    top: 72px; /* 상단에서 20px 떨어진 위치에 고정 */
	    height: calc(100vh - 186px); /* 뷰포트 높이에서 상하 여백 40px를 뺀 높이 */
	    overflow-y: auto; /* 내용이 넘치면 수직 스크롤 표시 */
	    align-self: flex-start; /* flexbox 내에서 상단 정렬 */
	}
	
	.card {
		background-color: white;
		border-radius: 20px;
		padding: 20px;
		box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		margin: 0px;
	}
	
	.cardDoc {
		background-color: white;
		border-radius: 20px;
		box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		padding: 60px;
		margin: 0px;
	}
	
	.approvalDoc {
		grid-column: 1;
		grid-row: 1/2;
	}
	
	.approvalLine {
		grid-column: 2;
	}
	
	textarea:focus {
		outline: 1.5px solid #4E7DF4;
	}
	
	.blueBtn {
	    width: 30%;
	    margin: 0px;
	    font-size: 14px;
	    border-radius: 10px;
	    background-color: #4E7DF4;
	    color: white;
	    border: none;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	    height: 35px;
	}
	
	.blueBtn:hover {
	    background-color: #3A63C8; /* 약 20% 더 어두운 색상 */
	}
	
	.container {
		width: 100%;
		margin: 0 auto;
		border: 1px solid black;
		padding: 60px 40px;
		box-sizing: border-box;
		box-shadow:5px 5px 0 #AAAAAA;
	}
	
	.container-table {
		display: flex;
		justify-content: space-between;
		width: 100%;
		margin: 0 auto;
		font-size: 15px;
	}
	
	.left-table {
		border: 1px solid black;
		width: 35%;
	}
	
	.right-table {
		border: 1px solid black;
	}
	
	td, th {
		border: 1px solid black;
		padding: 5px 10px;
		text-align: center;
		width: 90.5px;
	}
	
	th {
		background-color: #f0f0f0;
	}
	
	td img {
	    display: block;
	    margin: 0 auto;
        margin-top: 3px;
	}
	
	#line1, #line3 {
		background-color: #f0f0f0;
		height: 33.5px;
	}
	
	#line2 td{
		padding: 10px;
		height: 93.5px;
	}
	
	.title {
		text-align: center;
		font-size: 20px;
		font-weight: bold;
		margin: 30px 0px 50px 0px;
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
	
	.stamp-container {
	    position: relative;
	    display: inline-block;
	}
	
	.inline-img {
	    position: absolute;
	    top: -11px; /* (인) 위로 이미지 이동 */
	    left: 50%;
	    transform: translate(-50%, 0); /* 중앙 정렬 */
	    width: 45px; /* 비율 유지 */
	    height: 45px; /* 원하는 높이로 설정 */
	    max-width: none; /* 최대 너비 설정 제거 */
	    z-index: 10; /* 이미지가 글자 위로 오게 설정 */
	}
	
	.seal {
	    font-size: 15px;
	    display: inline-block;
	    z-index: 1;
	}
	
	.error-message {
	    color: red;
	    font-size: 0.9em;
	    font-family: 'Pretendard-Regular';
	}

</style>
</head>
<body>
<%-- <p>${approvalDocVO}<p> --%>
	<div class="dashboard">
		<div class="cardDoc approvalDoc">
			<c:choose>
				<c:when test="${approvalDocVO.atrzSttusCd == 'A14-001' && approvalDocVO.employeeVO.empNo == empVO.empNo}">
					<div style="display: flex; justify-content: flex-end; margin-bottom: 10px;">
				</c:when>
				<c:otherwise>
					<div style="display: none; justify-content: flex-end; margin-bottom: 10px;">
				</c:otherwise>
			</c:choose>
				<button id="downloadBtn" class="blueBtn" style="border-radius: 10px; width: 90px; height:35px; margin: 0px;">문서 저장</button>
			</div>
			<div id="pdfDown" class="container">
				<div style="border: 2px solid #585D6E; padding: 25px;">
					<div class="title">${approvalDocVO.docCdNm}</div>
	
					<div class="container-table">
						<!-- 좌측 테이블 -->
						<table class="left-table">
							<tr>
								<th>기안 부서</th>
								<td>${approvalDocVO.employeeVO.deptNm}</td>
							</tr>
							<tr>
								<th>기안자</th>
								<td>${approvalDocVO.employeeVO.empNm} 
								<c:choose>
									<c:when test="${approvalDocVO.employeeVO.jbttlNm eq '팀장'}">
										${approvalDocVO.employeeVO.jbttlNm}
									</c:when>
									<c:otherwise>
										${approvalDocVO.employeeVO.jbgdNm}
									</c:otherwise>
								</c:choose>
								 (${approvalDocVO.employeeVO.empNo})</td>
							</tr>
							<tr>
								<th>기안 일자</th>
								<td><fmt:formatDate value="${approvalDocVO.drftDt}" pattern="yyyy.MM.dd(E)" /></td>
							</tr>
							<tr>
								<th>문서 번호</th>
								<td>${approvalDocVO.docNo}</td>
							</tr>
						</table>
	
						<!-- 우측 테이블 -->
						<table class="right-table">
							<tr>
								<th rowspan="4" style="width:40px;">결재</th>
							</tr>
							
							<tr id="line1">
								<c:forEach var="line" items="${approvalDocVO.approvalLineVOList}">
									<th>
										<c:choose>
											<c:when test="${line.employeeVO.jbttlNm eq '팀장'}">
												${line.employeeVO.jbttlNm}
											</c:when>
											<c:otherwise>
												${line.employeeVO.jbgdNm}
											</c:otherwise>
										</c:choose>
									</th>
								</c:forEach>
							</tr>
							
							<tr id="line2">
								<c:forEach var="line" items="${approvalDocVO.approvalLineVOList}">
									<c:choose>
										<c:when test="${line.atrzSttusCd == 'A14-001'}">
											<td>
												<img src="data:image/png;base64,${line.employeeVO.offcsPhoto}" alt="직인 사진" width="45px" height="45px">
												<fmt:parseDate var="parsedDate" value="${line.atrzYmd}" pattern="yyyyMMdd" />
												<p style="font-size: 13px; margin-top: 5px;"><fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" /></p>
											</td>
										</c:when>
										<c:when test="${line.atrzSttusCd == 'A14-002'}">
											<td>
												<p style="font-size: 15px; color: red; font-weight: bold; margin: 15px auto;">결재 반려</p>
												<fmt:parseDate var="parsedDate" value="${line.atrzYmd}" pattern="yyyyMMdd" />
												<p style="font-size: 13px; margin-top: 5px; color: red;"><fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" /></p>
											</td>
										</c:when>
										<c:otherwise>
											<td></td>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</tr>
							
							<tr id="line3">
								<c:forEach var="line" items="${approvalDocVO.approvalLineVOList}">
									<th>${line.employeeVO.empNm}</th>
								</c:forEach>
							</tr>
						</table>
					</div>
					<div style="width: 100%; margin-top: 20px;"></div>
					<!-- 테스트용 디비 -->
					<div id="htmlCdHeight" style="height: 630px;">${approvalDocVO.htmlCd}</div>
					<div>
						<div class="signature-wrapper" style="text-align: right; margin-right: 20px;">
							<p id="formattedName" style="font-size: 15px; margin-bottom: 30px;" data-name="${approvalDocVO.employeeVO.empNm}"></p>
							<img id="drftImage" src="data:image/png;base64,${approvalDocVO.employeeVO.offcsPhoto}" style="display:none;" />
							<c:choose>
								<c:when test="${approvalDocVO.atrzSttusCd == 'A14-001'}">
									<p style="font-size: 15px; margin-bottom: 40px;">대 표 자 :&ensp;&ensp; 정 지 훈&ensp;&ensp; 
										<span class="stamp-container">
											<img src="data:image/png;base64,${approvalDocVO.employeeVO.offcsPhoto}" class="inline-img"/>
											<span class="seal">(인)</span>
										</span>
									</p>
								</c:when>
								<c:otherwise>
									<p style="font-size: 15px; margin-bottom: 40px;">대 표 자 :&ensp;&ensp; 정 지 훈&ensp;&ensp; (인)</p>
								</c:otherwise>
							</c:choose>
						</div>
						
						<div>
							<p style="font-weight: bold; text-align: center; margin-bottom: 20px;">(주)teamUp</p>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="card approvalLine">
			<div style="display: flex; justify-content: center; border-bottom: 1px solid #D9D9D9; padding: 10px 0px 30px 0px;">
				<div>
					<strong style="font-size: 20px;">결 재 선</strong>
				</div>
			</div>
			
			<div style="display: flex; flex-direction: column; height: 100%;">
				<div style="border-bottom: 1px solid #D9D9D9; flex-grow: 1;">
					<div style="display: flex; position: relative; opacity: 1;">
						<div style="display:flex; align-items: center;">
							<span>
								<img src="data:image/png;base64,${approvalDocVO.employeeVO.proflPhoto}" class="img-circle" style="width: 60px; height: 60px; display: inline-block; margin: 30px;" alt="karina.gif">
							</span>
						</div>
						<div style="display: flex; flex-direction: column; justify-content: center;">
							<strong>
								${approvalDocVO.employeeVO.empNm}
								<c:choose>
									<c:when test="${approvalDocVO.employeeVO.jbttlNm eq '팀장'}">
										${approvalDocVO.employeeVO.jbttlNm}
									</c:when>
									<c:otherwise>
										${approvalDocVO.employeeVO.jbgdNm}
									</c:otherwise>
								</c:choose>
							</strong>
							<p style="font-size: 13px;">${approvalDocVO.employeeVO.deptNm}</p>
							<p style="font-size: 13px;">기안 상신&ensp;|&ensp;<fmt:formatDate value="${approvalDocVO.drftDt}" pattern="yyyy.MM.dd(E) HH:mm" /></p>
						</div>
					</div>
					
					<c:set var="atrzEmpNo" value="" />
					<c:set var="returnCheck" value="" />
					<c:set var="prevAtrzSttusCd" value="" />
					<c:set var="isLastApprover" value="false" />
					<c:set var="totalApprovers" value="${fn:length(approvalDocVO.approvalLineVOList)}" />
					<c:set var="currentApproverIndex" value="0" />
					<c:forEach var="line" items="${approvalDocVO.approvalLineVOList}">
						<c:if test="${not empty line.employeeVO}">
							<c:set var="currentApproverIndex" value="${currentApproverIndex + 1}" />
							<div style="display: flex; position: relative;
								<c:choose>
									<c:when test="${line.atrzSttusCd == 'A14-002'}">
										background-color: #FFEBEE; opacity: 1;
									</c:when>
									<c:when test="${prevAtrzSttusCd != 'A14-003' and line.atrzSttusCd == 'A14-003'}">
										background-color: #F3F7FF;
									</c:when>
									<c:otherwise>
										opacity: 1;
									</c:otherwise>
								</c:choose>
								">
								
								<c:if test="${line.atrzSttusCd == 'A14-002'}">
									<div style="position: absolute; left: 0; top: 0px; bottom: 0px; width: 6px; background-color: #fb4c49; opacity: 1;"></div>
								</c:if>
								
								<c:if test="${prevAtrzSttusCd != 'A14-003' and line.atrzSttusCd == 'A14-003'}">
									<div style="position: absolute; left: 0; top: 0px; bottom: 0px; width: 6px; background-color: #4E7DF4;"></div>
									<c:set var="atrzEmpNo" value="${line.employeeVO.empNo}" />
									<c:set var="isLastApprover" value="${currentApproverIndex == totalApprovers}" />
									<c:set var="returnCheck" value="${prevAtrzSttusCd}" />
								</c:if>
								
								<div style="display:flex; align-items: center;">
									<span>
										<img src="data:image/png;base64,${line.employeeVO.proflPhoto}" class="img-circle" style="width: 60px; height: 60px; display: inline-block; margin: 30px;" alt="karina.gif">
									</span>
								</div>
								<div style="display: flex; flex-direction: column; justify-content: center;">
									<div style="display: flex; justify-content: space-start;">
										<div>
											<strong>
												<span class="empName">${line.employeeVO.empNm}</span>
												<span class="empJbgd">
													<c:choose>
														<c:when test="${line.employeeVO.jbttlNm eq '팀장'}">
															${line.employeeVO.jbttlNm}
														</c:when>
														<c:otherwise>
															${line.employeeVO.jbgdNm}
														</c:otherwise>
													</c:choose>
												</span>
											</strong>
											<p class="empDept" style="font-size: 13px;">${line.employeeVO.deptNm}</p>
										</div>
										<c:choose>
											<c:when test="${line.atrzSttusCd == 'A14-001' and line.atrzOpinion != null}">
												<div style="display: flex; margin: 0px 0px 13px 25px; color: #4E7DF4;">
													<button class="atrzOpinionBtn" style="border: 1px solid #4E7DF4; background: white; font-size: 14px; padding: 0px 10px; border-radius: 5px;">결재 의견</button>
													<input class="showAtrzOpinion" hidden type="text" value="${line.atrzOpinion}">
												</div>
											</c:when>
											<c:when test="${line.atrzSttusCd == 'A14-001' and line.atrzOpinion == null}">
												<div style="display: flex; margin: 0px 0px 13px 25px; color: #A3A3A3;">
													<button style="border: 1px solid #A3A3A3; background: white; font-size: 14px; padding: 0px 10px; border-radius: 5px; cursor: not-allowed;">의견 없음</button>
												</div>
											</c:when>
											<c:when test="${line.atrzSttusCd == 'A14-002'}">
												<div style="display: flex; margin: 0px 0px 13px 25px; color: #fb4c49;">
													<button class="rjctRsnBtn" style="border: 1px solid #ff9f9d; background: white; font-size: 14px; padding: 0px 10px; border-radius: 5px;">반려 사유</button>
													<input class="showRjctRsn" hidden type="text" value="${line.rjctRsn}">
												</div>
											</c:when>
										</c:choose>
									</div>
									<p style="font-size: 13px;">
										${line.atrzSttusNm}&ensp;| 
										<c:choose>
											<c:when test="${empty line.atrzDt}">
												&ensp;-
											</c:when>
											<c:otherwise>
												<fmt:formatDate value="${line.atrzDt}" pattern="yyyy.MM.dd(E) HH:mm" />
												<input type="hidden" class="atrzYmd" value="${line.atrzYmd}">
											</c:otherwise>
										</c:choose>
									</p>
								</div>
							</div>
							<c:set var="prevAtrzSttusCd" value="${line.atrzSttusCd}" />
				        </c:if>
					</c:forEach>
				</div>
				
				<!-- 로직 처리용 데이터 시작 -->				
				<input type="hidden" id="isLastApprover" value="${isLastApprover}">
			    <input type="hidden" id="atrzEmpNo" value="${atrzEmpNo}">
			    <input type="hidden" id="atrzNo" value="${approvalDocVO.atrzNo}" />
			    <input type="hidden" id="docNo" value="${approvalDocVO.docNo}" />
				<!-- 로직 처리용 데이터 끝 -->
				
				<div style="margin-top: 15px;">
					<c:if test="${atrzEmpNo == empVO.empNo and returnCheck != 'A14-002'}">
						<div style="display:flex; justify-content: space-between; margin: 15px;">
				    			<button id="returnBtn" class="btn btn-block btn-default" style="font-size:14px; border-radius: 10px; width: 47%; margin: 0px;">반려</button>
								<button id="approveBtn" class="blueBtn" style="font-size:14px; border-radius: 10px; width: 47%; margin: 0px;">승인</button>
						</div>
					</c:if>
					
					<div style="display:flex; justify-content: center; margin: 15px;">
						<button id="backBtn" class="btn btn-block btn-default" style="font-size:14px; border-radius: 10px;">돌아가기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
<!-- 로딩 스피너 HTML -->
<div id="loadingSpinner" style="display: none;">
    <img src="/images/loading.gif" alt="로딩중...">
</div>	
<!-- 로딩 스피너 HTML -->

<!-- 반려 사유 모달 시작 -->
<div class="relative z-10 hidden" id="modal1" role="dialog" aria-modal="true">
	<div class="fixed inset-0 bg-gray-500 bg-opacity-75"></div>

	<div class="fixed inset-0 z-10 w-screen overflow-y-auto">
		<div class="flex min-h-full items-center justify-center p-4">
			<div class="relative transform overflow-hidden rounded-lg bg-white shadow-xl" style="max-width: 600px; width: 100%;">
				<div style="height: 500px; padding: 30px; line-height: 2; padding-bottom: 0px;">
					<div style="border-bottom: 1px solid #D9D9D9; height: 100%;">
						<div style="padding-bottom: 30px; border-bottom: 1px solid #D9D9D9; display: flex; justify-content: center;">
							<strong style="font-size: 20px;">반려 사유 작성</strong>
						</div>
						
						<label for="returnName" class="text-gray-800 text-sm font-bold leading-tight tracking-normal" style="margin-top: 20px;">작성자 명<code> *</code></label>
                        <input id="returnName" class="mb-3 text-gray-600 focus:outline-none focus:border focus:border-indigo-700 font-normal w-full h-10 flex items-center pl-3 text-sm border-gray-300 rounded border" disabled/>
                        
						<label for="returnSysDate" class="text-gray-800 text-sm font-bold leading-tight tracking-normal">작성 일자<code> *</code></label>
                        <input type="text" id="returnSysDate" class="mb-3 text-gray-600 focus:outline-none focus:border focus:border-indigo-700 font-normal w-full h-10 flex items-center pl-3 text-sm border-gray-300 rounded border" disabled/>
						
						<div>
							<label for="rjctRsn" class="text-gray-800 text-sm font-bold leading-tight tracking-normal">내용<code> * <span class="error-message" style="color: red; display: none;">반려 사유를 작성해주세요.</span></code></label>
							<textarea id="rjctRsn" rows="3" cols="15" style="resize: none; height:150px; border-radius: 10px; width: 100%; border: 1px solid #D9D9D9; padding: 10px 20px; font-size: 14px;" maxlength="1000;" placeholder="반려 사유를 작성해주세요. [1000자 미만]"></textarea>
							
						</div>
					</div>
				</div>

				<div style="display:flex; justify-content: space-around; margin: 30px;">
					<button id="returnClose" class="btn btn-block btn-default" style="width: 30%; margin: 0px; font-size: 14px; border-radius: 10px;">취소</button>
					<button id="returnChecked" class="blueBtn">반려</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 반려 사유 모달 끝 -->

<!-- 결재 의견 모달 시작 -->
<div class="relative z-10 hidden" id="modal2" role="dialog" aria-modal="true">
	<div class="fixed inset-0 bg-gray-500 bg-opacity-75"></div>

	<div class="fixed inset-0 z-10 w-screen overflow-y-auto">
		<div class="flex min-h-full items-center justify-center p-4">
			<div class="relative transform overflow-hidden rounded-lg bg-white shadow-xl" style="max-width: 600px; width: 100%;">
				<div style="height: 500px; padding: 30px; line-height: 2; padding-bottom: 0px;">
					<div style="border-bottom: 1px solid #D9D9D9; height: 100%;">
						<div style="padding-bottom: 30px; border-bottom: 1px solid #D9D9D9; display: flex; justify-content: center;">
							<strong style="font-size: 20px;">결재 의견 작성</strong>
						</div>
						
						<label for="approvalName" class="text-gray-800 text-sm font-bold leading-tight tracking-normal" style="margin-top: 20px;">작성자 명<code> *</code></label>
                        <input id="approvalName" class="mb-3 text-gray-600 focus:outline-none focus:border focus:border-indigo-700 font-normal w-full h-10 flex items-center pl-3 text-sm border-gray-300 rounded border" disabled/>
                        
						<label for="approvalSysDate" class="text-gray-800 text-sm font-bold leading-tight tracking-normal">작성 일자<code> *</code></label>
                        <input type="text" id="approvalSysDate" class="mb-3 text-gray-600 focus:outline-none focus:border focus:border-indigo-700 font-normal w-full h-10 flex items-center pl-3 text-sm border-gray-300 rounded border" disabled/>
						
						<div>
							<label for="atrzOpinion" class="text-gray-800 text-sm font-bold leading-tight tracking-normal">내용</label>
							<textarea id="atrzOpinion" rows="3" cols="15" style="resize: none; height:150px; border-radius: 10px; width: 100%; border: 1px solid #D9D9D9; padding: 10px 20px; font-size: 14px;" maxlength="1000;" placeholder="결재 의견을 작성해주세요. [1000자 미만]"></textarea>
							
						</div>
					</div>
				</div>

				<div style="display:flex; justify-content: space-around; margin: 30px;">
					<button id="approvalClose" class="btn btn-block btn-default" style="width: 30%; margin: 0px; font-size: 14px; border-radius: 10px;">취소</button>
					<button id="approvalChecked" class="blueBtn">승인</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 결재 의견 모달 끝 -->

<!-- 사유 및 의견 확인 모달 -->
<div class="relative z-10 hidden" id="modal3" role="dialog" aria-modal="true">
	<div class="fixed inset-0 bg-gray-500 bg-opacity-75"></div>

	<div class="fixed inset-0 z-10 w-screen overflow-y-auto">
		<div class="flex min-h-full items-center justify-center p-4">
			<div class="relative transform overflow-hidden rounded-lg bg-white shadow-xl" style="max-width: 600px; width: 100%;">
				<div style="height: 500px; padding: 30px; line-height: 2; padding-bottom: 0px;">
					<div style="border-bottom: 1px solid #D9D9D9; height: 100%;">
						<div style="padding-bottom: 30px; border-bottom: 1px solid #D9D9D9; display: flex; justify-content: center;">
							<strong id="strTtl" style="font-size: 20px;">결재 의견 작성</strong>
						</div>
						
						<label for="strName" class="text-gray-800 text-sm font-bold leading-tight tracking-normal" style="margin-top: 20px;">작성자 명</label>
                        <input id="strName" class="mb-3 text-gray-600 focus:outline-none focus:border focus:border-indigo-700 font-normal w-full h-10 flex items-center pl-3 text-sm border-gray-300 rounded border" disabled/>
                        
						<label for="strSysDate" class="text-gray-800 text-sm font-bold leading-tight tracking-normal">작성 일자</label>
                        <input type="text" id="strSysDate" class="mb-3 text-gray-600 focus:outline-none focus:border focus:border-indigo-700 font-normal w-full h-10 flex items-center pl-3 text-sm border-gray-300 rounded border" disabled/>
						
						<div>
							<label for="strCn" class="text-gray-800 text-sm font-bold leading-tight tracking-normal">내용</label>
							<textarea id="strCn" rows="3" cols="15" style="resize: none; height:150px; border-radius: 10px; width: 100%; border: 1px solid #D9D9D9; padding: 10px 20px; font-size: 14px;" maxlength="1000;" disabled></textarea>
							
						</div>
					</div>
				</div>

				<div style="display:flex; justify-content: center;; margin: 30px;">
					<button id="strClose" class="blueBtn">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 사유 및 의견 확인 모달 -->

</body>
</html>