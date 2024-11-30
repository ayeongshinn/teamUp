<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/vacationDoc_style.css">

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
	
    <script type="text/javascript">
        $(document).ready(function() {
            // 로그인한 사원의 이름과 번호를 JSP에서 가져옴
            var empNo = '${empVO.empNo}';  // 사원 이름
            var empNm = '${empVO.empNm}';  // 사원 이름
            var empTelno = '${empVO.empTelno}';  // 연락처
            var spacedName = empNm.split('').join(' ');
	        var formattedTelno = empTelno.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
         	
            // 'registEmp' 요소에 사원 이름을 동적으로 삽입
            $('#registEmp').html('신 청 인 : &nbsp;&nbsp;' + spacedName + '&nbsp;&nbsp;(인)');
            $('#empName').html(empNm);  // 사원명 (공백 추가)
            $('#empTel').html(formattedTelno);  // 연락처
            $('#drftEmpNo').val(empNo);
            
            $.ajax({
                url: "/employee/getDetail",
                data: { "empNo": empNo },
                type: "POST",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(response) {
                	 // 응답에서 부서명과 직급명 추출
                    var deptNm = response.deptNm;  // 부서명
                    var jbgdNm = response.jbgdNm;  // 직급명

                    // 각 HTML 요소에 정보 삽입
                    $('#empDept').html(deptNm);  // 부서명
                    $('#empJbgd').html(jbgdNm);  // 직급명
                },
                error: function(xhr, status, error) {
                    console.error("Error occurred: ", error);
                }
            });
        });
    </script>
</sec:authorize>

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
</style>

<script type="text/javascript">

//오늘 구하기
function getToday() {
    var today = new Date();
    var year = today.getFullYear();
    var month = ("0" + (today.getMonth() + 1)).slice(-2);
    var day = ("0" + today.getDate()).slice(-2);
    return year + "-" + month + "-" + day;  // "YYYY-MM-DD" 형식으로 반환
}

// 기간 계산 함수
function calculateDays(start, end) {
    var startDate = new Date(start);
    var endDate = new Date(end);

    // 차이 계산 (단위: milliseconds)
    var timeDiff = endDate - startDate;
    var dayDiff = Math.ceil(timeDiff / (1000 * 3600 * 24)) + 1;  // 날짜 차이 +1

    // 며칠인지 표시
    if (dayDiff > 0) {
        alert(dayDiff + "일이 소요됩니다.");
        $('#useVcatnDayCnt').val(dayDiff);
        console.log("useVacation" , dayDiff);
    }
}

//날짜를 YYYY-MM-DD에서 YYYYMMDD 형식으로 변환
function formatToYYYYMMDD(date) {
    return date.replace(/-/g, "");
}

$(document).ready(function() {
	//문서 오늘 날짜 표시	
	var today = new Date();
	
    var year = today.getFullYear();
    var month = today.getMonth() + 1;  // 월은 0부터 시작하므로 +1 필요
    var day = today.getDate();

    if (month < 10) month = '0' + month;
    if (day < 10) day = '0' + day;
	
    var formattedDate = year + "년 " + month + "월 " + day + "일";
	
    $('#registDay').text(formattedDate);
	
  	//휴가사유 작성
	$('#vcatnRsn').on('input', function() {
		$('#vcatnReason').text($(this).val());
	});
  	
    // 시작일과 종료일의 min 속성을 오늘로 설정
    $('#startDay, #endDay').attr('min', getToday());
    
    // 휴가 시작일 처리
    $('#startDay').on('change', function() {
        var startDay = $(this).val();
        var endDay = $('#endDay').val();
        var today = getToday();

        // 오늘 날짜 이전일 선택 시 경고
        if (startDay < today) {
            alert("시작일은 오늘 이전일 수 없습니다.");
            $(this).val("");  // 시작일 초기화
            $('#vcatnPeriod').text("");  // 표시 초기화
            return;
        }

        var formattedStartDay = startDay.replace(/-/g, ".");
        $('#vcatnPeriod').text(formattedStartDay);
		
        var schdlFormattedStartDay = formatToYYYYMMDD(startDay);
        $('#schdlBgngYmd').val(schdlFormattedStartDay);
        
        // endDay가 설정되어 있고, startDay가 endDay보다 크면 경고
        if (endDay && startDay > endDay) {
            alert("시작일은 종료일보다 클 수 없습니다.");
            $(this).val("");  // 시작일 초기화
            $('#vcatnPeriod').text("");  // 표시 초기화
        } else if (endDay) {
            calculateDays(startDay, endDay);
        }
    });
	
    // 휴가 종료일 처리
    $('#endDay').on('change', function() {
        var endDay = $(this).val();
        var startDay = $('#startDay').val();
        var today = getToday();

        // 오늘 날짜 이전일 선택 시 경고
        if (endDay < today) {
            alert("종료일은 오늘 이전일 수 없습니다.");
            $(this).val("");  // 종료일 초기화
            return;
        }

        var vcatnDay = $('#vcatnPeriod').text();
        var formattedEndDay = endDay.replace(/-/g, ".");

        // startDay가 설정되어 있고, endDay가 startDay보다 작으면 경고
        if (startDay && endDay < startDay) {
            alert("종료일은 시작일보다 작을 수 없습니다.");
            $(this).val("");  // 종료일 초기화
        } else if (startDay) {
            $('#vcatnPeriod').text(vcatnDay + " - " + formattedEndDay);
            
         	// schdlEndYmd 필드에 YYYYMMDD 형식으로 값 설정
            var schdlFormattedEndDay = formatToYYYYMMDD(endDay);
            $('#schdlEndYmd').val(schdlFormattedEndDay);
            
            calculateDays(startDay, endDay);
        }
    });
	
	//휴가 구분
    $('#vcatnCd').on('change', function() {
        // 선택된 값을 가져옴
        var selectedValue = $(this).val();
    	console.log("선택된 값: " + selectedValue);  // 선택된 값 확인
    	
        // 모든 항목을 다시 '□'로 초기화
        $('#annual').html('□ 연차&nbsp;&nbsp;&nbsp;&nbsp;');
        $('#monthly').html('□ 월차&nbsp;&nbsp;&nbsp;&nbsp;');
        $('#half').html('□ 반차(오전, 오후)&nbsp;&nbsp;&nbsp;&nbsp;');
        $('#vacant').html('□ 공가&nbsp;&nbsp;&nbsp;&nbsp;');
        $('#sick').html('□ 병가&nbsp;&nbsp;&nbsp;&nbsp;');
        $('#etc').html('□ 기타 ( &nbsp;&nbsp;&nbsp;)');
		        
		// 선택된 항목에 따라 '■'로 변경 (if-else if 문 사용)
        if (selectedValue === 'A22-001') {
        	console.log("선택");
            $('#annual').html('■ 연차&nbsp;&nbsp;&nbsp;&nbsp;');
        } else if (selectedValue === 'A22-002') {
        	console.log("선택");
            $('#monthly').html('■ 월차&nbsp;&nbsp;&nbsp;&nbsp;');
        } else if (selectedValue === 'A22-003') {
        	console.log("선택");
            $('#half').html('■ 반차(오전, 오후)&nbsp;&nbsp;&nbsp;&nbsp;');
        } else if (selectedValue === 'A22-004') {
        	console.log("선택");
            $('#vacant').html('■ 공가&nbsp;&nbsp;&nbsp;&nbsp;');
        } else if (selectedValue === 'A22-005') {
        	console.log("선택");
            $('#sick').html('■ 병가&nbsp;&nbsp;&nbsp;&nbsp;');
        } else if (selectedValue === 'A22-006') {
        	console.log("선택");
            $('#etc').html('■ 기타 ( &nbsp;&nbsp;&nbsp;)');
        }
    });
	
	
	
})

</script>

<div class="hpa" style="width: 210mm; height: 296.99mm;">
	<svg class="hs" viewBox="-0.15 -0.15 210.30 297.29"
		style="left: -0.15mm; top: -0.15mm; width: 210.30mm; height: 297.29mm;">
		<path d="M15,19.85 L15,277.13"
			style="stroke:#000000;stroke-linecap:butt;stroke-width:0.30;"></path>
		<path d="M195,19.85 L195,277.13"
			style="stroke:#000000;stroke-linecap:butt;stroke-width:0.30;"></path>
		<path d="M14.85,20 L195.15,20"
			style="stroke:#000000;stroke-linecap:butt;stroke-width:0.30;"></path>
		<path d="M14.85,276.99 L195.15,276.99"
			style="stroke:#000000;stroke-linecap:butt;stroke-width:0.30;"></path></svg>
	
	<!-- 기안 정보 시작 -->
	<div class="htb"
		style="left: 24.31mm; width: 63.18mm; top: 48.95mm; height: 30.07mm;">
		<svg class="hs" viewBox="-2.50 -2.50 68.18 35.07"
			style="left: -2.50mm; top: -2.50mm; width: 68.18mm; height: 35.07mm;">
			<defs>
			<pattern id="w_00" width="10" height="10"
				patternUnits="userSpaceOnUse">
			<rect width="10" height="10" fill="rgb(242,242,242)"></rect></pattern></defs>
			<path fill="url(#w_00)" d="M0,0L23.54,0L23.54,7.03L0,7.03L0,0Z "></path>
			<path fill="url(#w_00)"
				d="M0,7.03L23.54,7.03L23.54,14.07L0,14.07L0,7.03Z "></path>
			<path fill="url(#w_00)"
				d="M0,14.07L23.54,14.07L23.54,21.10L0,21.10L0,14.07Z "></path>
			<path fill="url(#w_00)"
				d="M0,21.10L23.54,21.10L23.54,28.07L0,28.07L0,21.10Z "></path>
			<path d="M0,0 L0,28.08"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M23.54,0 L23.54,28.08"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M61.18,0 L61.18,28.08"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,0 L61.25,0"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,7.03 L61.25,7.03"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,14.07 L61.25,14.07"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,21.10 L61.25,21.10"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,28.07 L61.25,28.07"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M61.18,0 L61.18,28.08"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M0,0 L0,28.08"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,28.07 L61.25,28.07"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,0 L61.25,0"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path></svg>
		<div class="hce"
			style="left: 0mm; top: 0mm; width: 23.54mm; height: 7.03mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.26mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 19.94mm;">
						<span class="hrt cs7">기안부서</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 23.54mm; top: 0mm; width: 37.64mm; height: 7.03mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.26mm;">
					<div class="hls ps23"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 34.04mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 0mm; top: 7.03mm; width: 23.54mm; height: 7.03mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.26mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 19.94mm;">
						<span class="hrt cs7">기안자</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 23.54mm; top: 7.03mm; width: 37.64mm; height: 7.03mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.26mm;">
					<div class="hls ps23"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 34.04mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 0mm; top: 14.07mm; width: 23.54mm; height: 7.03mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.26mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 19.94mm;">
						<span class="hrt cs7">기안날짜</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 23.54mm; top: 14.07mm; width: 37.64mm; height: 7.03mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.26mm;">
					<div class="hls ps23"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 34.04mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 0mm; top: 21.10mm; width: 23.54mm; height: 6.97mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.22mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 19.94mm;">
						<span class="hrt cs7">문서번호</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 23.54mm; top: 21.10mm; width: 37.64mm; height: 6.97mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.22mm;">
					<div class="hls ps23"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 34.04mm;"></div>
				</div>
			</div>
		</div>
	</div>
	<!-- 기안 정보 끝 -->
	
	<!-- 결재 라인 시작 -->
	<div class="htb"
		style="left: 123.70mm; width: 67.30mm; top: 45.71mm; height: 35.53mm;">
		<svg class="hs" viewBox="-2.50 -2.50 72.30 40.53"
			style="left: -2.50mm; top: -2.50mm; width: 72.30mm; height: 40.53mm;">
						<path fill="url(#w_00)" d="M0,0L12.12,0L12.12,33.54L0,33.54L0,0Z "></path>
						<path fill="url(#w_00)"
				d="M12.12,0L29.86,0L29.86,7.80L12.12,7.80L12.12,0Z "></path>
						<path fill="url(#w_00)"
				d="M29.86,0L47.59,0L47.59,7.80L29.86,7.80L29.86,0Z "></path>
						<path fill="url(#w_00)"
				d="M47.59,0L65.30,0L65.30,7.80L47.59,7.80L47.59,0Z "></path>
						<path fill="url(#w_00)"
				d="M12.12,26.61L29.86,26.61L29.86,33.54L12.12,33.54L12.12,26.61Z "></path>
						<path fill="url(#w_00)"
				d="M29.86,26.61L47.59,26.61L47.59,33.54L29.86,33.54L29.86,26.61Z "></path>
						<path fill="url(#w_00)"
				d="M47.59,26.61L65.30,26.61L65.30,33.54L47.59,33.54L47.59,26.61Z "></path>
						<path d="M0,0 L0,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M12.12,0 L12.12,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M29.86,0 L29.86,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M47.59,0 L47.59,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M65.30,0 L65.30,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M-0.06,0 L65.37,0"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M12.07,7.80 L65.37,7.80"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M12.07,26.61 L65.37,26.61"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M-0.06,33.54 L65.37,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M65.30,0 L65.30,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M0,0 L0,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M-0.06,33.54 L65.37,33.54"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
						<path d="M-0.06,0 L65.37,0"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path></svg>
		<div class="hce"
			style="left: 0mm; top: 0mm; width: 12.12mm; height: 33.54mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 14.51mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 8.52mm;">
						<span class="hrt cs7">결재</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 12.12mm; top: 0mm; width: 17.73mm; height: 7.80mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.64mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 29.86mm; top: 0mm; width: 17.73mm; height: 7.80mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.64mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 47.59mm; top: 0mm; width: 17.72mm; height: 7.80mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.64mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.11mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 12.12mm; top: 7.80mm; width: 17.73mm; height: 18.81mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 7.14mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 29.86mm; top: 7.80mm; width: 17.73mm; height: 18.81mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 7.14mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 47.59mm; top: 7.80mm; width: 17.72mm; height: 18.81mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 7.14mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.11mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 12.12mm; top: 26.61mm; width: 17.73mm; height: 6.92mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.20mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 29.86mm; top: 26.61mm; width: 17.73mm; height: 6.92mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.20mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 47.59mm; top: 26.61mm; width: 17.72mm; height: 6.92mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.20mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.11mm;"></div>
				</div>
			</div>
		</div>
	</div>
	<!-- 결재 라인 끝 -->
	
	<!-- 본 문서 시작 -->
	<div class="hcD" style="left: 20mm; top: 25mm;">
		<div class="hcI">
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 4.10mm; white-space: nowrap; left: 0mm; top: 5.40mm; height: 4.94mm; width: 170mm;">
				<span class="hrt cs10">휴가 기안서</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 13.37mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 19.01mm; height: 3.53mm; width: 102.70mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 24.66mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps22"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 30.30mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps22"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 35.95mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps22"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 41.59mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps22"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 47.24mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps22"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 52.88mm; height: 3.53mm; width: 102.70mm;"></div>
				
		</div>
	</div>
	<div class="hcD vacationDoc" style="left: 20mm; top: 25mm;">
		<div class="hcI">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/vacationDoc_style.css">
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 58.53mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 64.17mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 69.81mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs8">· 신청인 관련 사항</span>
			</div>
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 176.58mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 182.22mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 187.86mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">위 본인은 상기의 사유로 인하여 휴가계를 신청합니다.</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 193.51mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 199.15mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7" id="registDay">&nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;월
					&nbsp;&nbsp;일</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 204.80mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 210.44mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps24"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 216.09mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7" id="registEmp">신 청 인 :
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</span>
			</div>
			<div class="hls ps24"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 223.14mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7" id="ceo">대표이사 :&nbsp;&nbsp;정 지 훈&nbsp;&nbsp;(인)</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 230.20mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 3.43mm; white-space: nowrap; left: 0mm; top: 235.81mm; height: 4.23mm; width: 170mm;">
				<span class="hrt cs9">㈜teamUp</span>
			</div>
		</div>
	</div>
	
	<div class="vacationDoc">
		<div class="htb"
			style="left: 21mm; width: 170mm; top: 103.58mm; height: 101.17mm;">
			<svg class="hs" viewBox="-2.50 -2.50 175 106.17"
				style="left: -2.50mm; top: -2.50mm; width: 175mm; height: 106.17mm;">
				<path fill="url(#w_00)" d="M0,0L30.02,0L30.02,8.75L0,8.75L0,0Z "></path>
				<path fill="url(#w_00)" d="M84,0L112.03,0L112.03,8.75L84,8.75L84,0Z "></path>
				<path fill="url(#w_00)"
					d="M0,8.75L30.02,8.75L30.02,17.50L0,17.50L0,8.75Z "></path>
				<path fill="url(#w_00)"
					d="M84,8.75L112.03,8.75L112.03,17.50L84,17.50L84,8.75Z "></path>
				<path fill="url(#w_00)"
					d="M0,17.50L30.02,17.50L30.02,26.26L0,26.26L0,17.50Z "></path>
				<path fill="url(#w_00)"
					d="M0,26.26L30.02,26.26L30.02,35.01L0,35.01L0,26.26Z "></path>
				<path fill="url(#w_00)"
					d="M0,35.01L30.02,35.01L30.02,97.17L0,97.17L0,35.01Z "></path>
				<path d="M0,0 L0,97.18"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M30.02,0 L30.02,97.18"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M84,0 L84,17.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M112.03,0 L112.03,17.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M168.01,0 L168.01,97.18"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L168.07,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,8.75 L168.07,8.75"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,17.50 L168.07,17.50"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,26.26 L168.07,26.26"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,35.01 L168.07,35.01"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,97.17 L168.07,97.17"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M168.01,0 L168.01,97.18"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M0,0 L0,97.18"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,97.17 L168.07,97.17"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L168.07,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path></svg>
			<div class="hce"
				style="left: 0mm; top: 0mm; width: 30.02mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.42mm;">
							<span class="hrt cs7">부서명</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 30.02mm; top: 0mm; width: 53.98mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 50.38mm;">
							<span class="hrt cs7" id="empDept"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84mm; top: 0mm; width: 28.02mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 24.43mm;">
							<span class="hrt cs7">직급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 0mm; width: 55.98mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 52.38mm;">
							<span class="hrt cs7" id="empJbgd"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 8.75mm; width: 30.02mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.42mm;">
							<span class="hrt cs7">성명</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 30.02mm; top: 8.75mm; width: 53.98mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 50.38mm;">
							<span class="hrt cs7" id="empName"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84mm; top: 8.75mm; width: 28.02mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 24.43mm;">
							<span class="hrt cs7">연락처</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 8.75mm; width: 55.98mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 52.38mm;">
							<span class="hrt cs7" id="empTel"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 17.50mm; width: 30.02mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.42mm;">
							<span class="hrt cs7">휴가 구문</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 30.02mm; top: 17.50mm; width: 137.99mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps25" style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 134.38mm;">
							<span class="hrt cs11" id="annual">□ 연차&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span class="hrt cs11" id="monthly">□ 월차&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span class="hrt cs11" id="half">□ 반차(오전, 오후)&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span class="hrt cs11" id="vacant">□ 공가&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span class="hrt cs11" id="sick">□ 병가&nbsp;&nbsp;&nbsp;&nbsp;</span>
							<span class="hrt cs11" id="etc">□ 기타 ( &nbsp;&nbsp;&nbsp;)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 26.26mm; width: 30.02mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.42mm;">
							<span class="hrt cs7">휴가 기간</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 30.02mm; top: 26.26mm; width: 137.99mm; height: 8.75mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 2.11mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 134.38mm;">
							<span class="hrt cs7" id="vcatnPeriod"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 35.01mm; width: 30.02mm; height: 62.16mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 28.82mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.42mm;">
							<span class="hrt cs7">휴가 사유</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 30.02mm; top: 35.01mm; width: 137.99mm; height: 62.16mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 28.82mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 134.38mm;">
							<span class="hrt cs7" id="vcatnReason"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="htb"
			style="left: 123.70mm; width: 67.30mm; top: 45.71mm; height: 35.53mm;">
			<svg class="hs" viewBox="-2.50 -2.50 72.30 40.53"
				style="left: -2.50mm; top: -2.50mm; width: 72.30mm; height: 40.53mm;">
				<path fill="url(#w_00)" d="M0,0L12.12,0L12.12,33.54L0,33.54L0,0Z "></path>
				<path fill="url(#w_00)"
					d="M12.12,0L29.86,0L29.86,7.80L12.12,7.80L12.12,0Z "></path>
				<path fill="url(#w_00)"
					d="M29.86,0L47.59,0L47.59,7.80L29.86,7.80L29.86,0Z "></path>
				<path fill="url(#w_00)"
					d="M47.59,0L65.30,0L65.30,7.80L47.59,7.80L47.59,0Z "></path>
				<path fill="url(#w_00)"
					d="M12.12,26.61L29.86,26.61L29.86,33.54L12.12,33.54L12.12,26.61Z "></path>
				<path fill="url(#w_00)"
					d="M29.86,26.61L47.59,26.61L47.59,33.54L29.86,33.54L29.86,26.61Z "></path>
				<path fill="url(#w_00)"
					d="M47.59,26.61L65.30,26.61L65.30,33.54L47.59,33.54L47.59,26.61Z "></path>
				<path d="M0,0 L0,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M12.12,0 L12.12,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M29.86,0 L29.86,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M47.59,0 L47.59,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M65.30,0 L65.30,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L65.37,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M12.07,7.80 L65.37,7.80"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M12.07,26.61 L65.37,26.61"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,33.54 L65.37,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M65.30,0 L65.30,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M0,0 L0,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,33.54 L65.37,33.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L65.37,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path></svg>
			<div class="hce"
				style="left: 0mm; top: 0mm; width: 12.12mm; height: 33.54mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 14.51mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 8.52mm;">
							<span class="hrt cs7">결재</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 12.12mm; top: 0mm; width: 17.73mm; height: 7.80mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.64mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 29.86mm; top: 0mm; width: 17.73mm; height: 7.80mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.64mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 47.59mm; top: 0mm; width: 17.72mm; height: 7.80mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.64mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.11mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 12.12mm; top: 7.80mm; width: 17.73mm; height: 18.81mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 7.14mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 29.86mm; top: 7.80mm; width: 17.73mm; height: 18.81mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 7.14mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 47.59mm; top: 7.80mm; width: 17.72mm; height: 18.81mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 7.14mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.11mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 12.12mm; top: 26.61mm; width: 17.73mm; height: 6.92mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.20mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 29.86mm; top: 26.61mm; width: 17.73mm; height: 6.92mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.20mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.13mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 47.59mm; top: 26.61mm; width: 17.72mm; height: 6.92mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.20mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 14.11mm;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>