<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/resignationDoc_style.css">

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
	
    <script type="text/javascript">
        $(document).ready(function() {
            // 로그인한 사원의 이름과 번호를 JSP에서 가져옴
            var empNo = '${empVO.empNo}';  // 사원 이름
            var empNm = '${empVO.empNm}';  // 사원 이름
            var empBrdt = '${empVO.empBrdt}';
            var jncmpYmd = '${empVO.jncmpYmd}';
            var roadNmZip = '${empVO.roadNmZip}';
            var roadNmAddr = '${empVO.roadNmAddr}';
            var daddr = '${empVO.daddr}';
            var empTelno = '${empVO.empTelno}';
            var empEmlAddr = '${empVO.empEmlAddr}';
            
            var spacedName = empNm.split('').join(' ');
	        var formattedTelno = empTelno.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
	        var formattedBrdt = empBrdt.replace(/(\d{4})(\d{2})(\d{2})/, "$1.$2.$3");
	        var formattedJncmp = jncmpYmd.replace(/(\d{4})(\d{2})(\d{2})/, "$1.$2.$3");
         	
	        
            // 'registEmp' 요소에 사원 이름을 동적으로 삽입
            $('#registEmp').html('신 청 인 : &nbsp;&nbsp;' + spacedName + '&nbsp;&nbsp;(인)');
            $('#empName').html(empNm);
            $('#empbirth').html(formattedBrdt);
            $('#empJoin').html(formattedJncmp);
            $('#empaddr').html(roadNmAddr + daddr + " ( " + roadNmZip + " )");
            $('#empTel').html(formattedTelno);
            $('#empEmail').html(empEmlAddr);
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
//오늘 날짜를 가져오는 함수
function getToday() {
    var today = new Date();
    var year = today.getFullYear();
    var month = ("0" + (today.getMonth() + 1)).slice(-2);
    var day = ("0" + today.getDate()).slice(-2);
    return year + "-" + month + "-" + day;  // YYYY-MM-DD 형식으로 반환
}

// 날짜를 YYYY-MM-DD에서 YYYYMMDD 형식으로 변환하는 함수
function formatToYYYYMMDD(date) {
    return date.replace(/-/g, "");
}

// 날짜를 YYYY-MM-DD에서 YYYY.MM.DD 형식으로 변환하는 함수
function formatToDotDate(date) {
    return date.replace(/-/g, ".");
}

// 날짜를 'YYYY년 MM월 DD일' 형식으로 변환하는 함수
function formatToKoreanDate(date) {
    var parts = date.split("-");
    return parts[0] + "년 " + parts[1] + "월 " + parts[2] + "일";
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
	
  	//사직 사유 작성
	$('#rsgntnRsn').on('input', function() {
		$('#empReason').text($(this).val());
	});
  	
	// 오늘 날짜를 가져와서 rsgntnDay의 min 속성 설정 (오늘 날짜 이전 선택 불가)
    $('#rsgntnDay').attr('min', getToday());

    // 퇴직 예정일 처리
    $('#rsgntnDay').on('change', function() {
        var rsgntnDay = $(this).val();  // 선택된 날짜 가져오기
        var today = getToday();

        // 오늘 날짜 이전일 선택 시 경고
        if (rsgntnDay < today) {
            alert("퇴직 예정일은 오늘 이전일 수 없습니다.");
            $(this).val("");  // 퇴직일 초기화
            $('#empResign').text("");  // 표시 초기화
            $('#rsgntnYmd').val("");  // 숨겨진 필드 초기화
            return;
        }

     	// 날짜 포맷 변환
        var formattedRsgntnDay = formatToDotDate(rsgntnDay);  // YYYY.MM.DD 형식
        var formattedRsgntnYmd = formatToYYYYMMDD(rsgntnDay);  // YYYYMMDD 형식
        var koreanRsgntnDay = formatToKoreanDate(rsgntnDay);  // YYYY년 MM월 DD일 형식

        // 변환된 날짜를 각 필드에 넣기
        $('#empResign').text(formattedRsgntnDay);  // 화면에 표시할 요소
        $('#rsgntnYmd').val(formattedRsgntnYmd);  // 숨겨진 필드에 값 저장
        $('#rsgntnDoc').text(koreanRsgntnDay);  // 'YYYY년 MM월 DD일' 형식으로 rsgntnDoc에 표시

        // 콘솔에 확인을 위한 로그 출력
        console.log("퇴직 예정일 (화면 표시용):", formattedRsgntnDay);
        console.log("퇴직 예정일 (저장용):", formattedRsgntnYmd);
        console.log("퇴직 예정일 (한글 형식):", koreanRsgntnDay);
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
	<!-- 기안라인 시작 -->
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
					<div class="hls ps22"
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
					<div class="hls ps22"
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
					<div class="hls ps22"
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
					<div class="hls ps22"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 34.04mm;"></div>
				</div>
			</div>
		</div>
	</div>
	<!-- 기안라인 끝 -->
	
	<!-- 결재라인 시작 -->
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
	<!-- 결재 끝 -->
	
	<!-- 본문서 시작 -->
	<div class="hcD" style="left: 20mm; top: 25mm;">
		<div class="hcI">
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 4.10mm; white-space: nowrap; left: 0mm; top: 5.40mm; height: 4.94mm; width: 170mm;">
				<span class="hrt cs10">사직서</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 13.37mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 19.01mm; height: 3.53mm; width: 102.70mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 24.66mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps21"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 30.30mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps21"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 35.95mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps21"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 41.59mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps21"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 66.49mm; top: 47.24mm; height: 3.53mm; width: 36.21mm;"></div>
			<div class="hls ps21"
				style="padding-left: 14.11mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 52.88mm; height: 3.53mm; width: 102.70mm;"></div>
		</div>
	</div>
	
	<div class="hcD resignationDoc" style="left: 20mm; top: 25mm;">
		<div class="hcI">	
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 58.53mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 64.17mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs8">· 신청인 관련 사항</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 122.83mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 128.47mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs8">본인은</span>
				<span class="hrt cs8" id="rsgntnDoc">&nbsp;&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;월 &nbsp;&nbsp;일</span>
				<span class="hrt cs8">일자로 퇴직함 있어 아래 조항을 성실히 준수할 것을 서약합니다.</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 134.12mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 139.76mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps24"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 145.40mm; height: 3.53mm; width: 170mm;">
				<div class="hhe"
					style="display: inline-block; margin-left: 0mm; width: 4.21mm; height: 3.53mm;">
					<span class="hrt cs7" style="font-size: 10pt;">1.</span>
				</div>
				<span class="hrt cs7">본인은 퇴직에 따른 사무 인수. 인계의 철저로 최종 퇴사 시까지 책임과
					의무를 완수하고, 재직 시 업무상 제반&nbsp;</span><span class="htC"
					style="left: 5.09mm; width: 0.52mm; height: 100%;"></span>
			</div>
			<div class="hls ps24"
				style="padding-left: 4.21mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 151.05mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">비밀사항을 타인에게 누설함이 귀사의 경영에 막대한 손해와 피해를 준다는
					사실을 지각하고 일절 이를 누설하지&nbsp;</span>
			</div>
			<div class="hls ps24"
				style="padding-left: 4.21mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 156.69mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">않겠습니다.</span>
			</div>
			<div class="hls ps24"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 162.34mm; height: 3.53mm; width: 170mm;">
				<div class="hhe"
					style="display: inline-block; margin-left: 0mm; width: 4.73mm; height: 3.53mm;">
					<span class="hrt cs7" style="font-size: 10pt;">2.</span>
				</div>
				<span class="hrt cs7">재직 중 지급 공구 및 비품, 명함, 카드키 등 반환 물품(금품)은
					퇴직일 전일까지 반환하겠습니다.</span>
			</div>
			<div class="hls ps24"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 167.98mm; height: 3.53mm; width: 170mm;">
				<div class="hhe"
					style="display: inline-block; margin-left: 0mm; width: 4.83mm; height: 3.53mm;">
					<span class="hrt cs7" style="font-size: 10pt;">3.</span>
				</div>
				<span class="hrt cs7">기타 회사와 관련된 제반 사항은 회사규정에 의거 퇴직일 전일까지
					처리하겠습니다.</span>
			</div>
			<div class="hls ps24"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 173.63mm; height: 3.53mm; width: 170mm;">
				<div class="hhe"
					style="display: inline-block; margin-left: 0mm; width: 4.85mm; height: 3.53mm;">
					<span class="hrt cs7" style="font-size: 10pt;">4.</span>
				</div>
				<span class="hrt cs7">만일 본인이 상기 사항을 위반하였을 때는 이유 여하 막론하고 서약에
					의거 민, 형사상의 책임을 지며, 회사에서&nbsp;</span>
			</div>
			<div class="hls ps24"
				style="padding-left: 4.85mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 179.27mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">요구하는 손해배상의 의무를 지겠습니다.</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 184.92mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 190.56mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 196.20mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 201.85mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7" id="registDay">&nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;월&nbsp;&nbsp;일</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 207.49mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 213.14mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps23"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 218.78mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7" id="registEmp">신 청 인 :
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</span>
			</div>
			<div class="hls ps23"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 225.84mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7" id="ceo">대표이사 :&nbsp;&nbsp;정 지 훈&nbsp;&nbsp;(인)</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 232.89mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 3.43mm; white-space: nowrap; left: 0mm; top: 238.50mm; height: 4.23mm; width: 170mm;">
				<span class="hrt cs9">㈜teamUp</span>
			</div>
		</div>
	</div>
	
	<div class="resignationDoc">
		<div class="htb"
			style="left: 21mm; width: 170.01mm; top: 97.50mm; height: 53.50mm;">
			<svg class="hs" viewBox="-2.50 -2.50 175.01 58.50"
				style="left: -2.50mm; top: -2.50mm; width: 175.01mm; height: 58.50mm;">
				<path fill="url(#w_00)" d="M0,0L31.02,0L31.02,8.25L0,8.25L0,0Z "></path>
				<path fill="url(#w_00)" d="M84,0L112.03,0L112.03,8.25L84,8.25L84,0Z "></path>
				<path fill="url(#w_00)"
					d="M0,8.25L31.02,8.25L31.02,16.50L0,16.50L0,8.25Z "></path>
				<path fill="url(#w_00)"
					d="M84,8.25L112.03,8.25L112.03,16.50L84,16.50L84,8.25Z "></path>
				<path fill="url(#w_00)"
					d="M0,16.50L31.02,16.50L31.02,24.75L0,24.75L0,16.50Z "></path>
				<path fill="url(#w_00)"
					d="M84,16.50L112.03,16.50L112.03,24.75L84,24.75L84,16.50Z "></path>
				<path fill="url(#w_00)"
					d="M0,24.75L31.02,24.75L31.02,33.01L0,33.01L0,24.75Z "></path>
				<path fill="url(#w_00)"
					d="M0,33.01L31.02,33.01L31.02,49.50L0,49.50L0,33.01Z "></path>
				<path fill="url(#w_00)"
					d="M31.02,33.01L52.59,33.01L52.59,41.25L31.02,41.25L31.02,33.01Z "></path>
				<path fill="url(#w_00)"
					d="M31.02,41.25L52.59,41.25L52.59,49.50L31.02,49.50L31.02,41.25Z "></path>
				<path fill="url(#w_00)"
					d="M99.51,41.25L122.78,41.25L122.78,49.50L99.51,49.50L99.51,41.25Z "></path>
				<path d="M0,0 L0,49.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M31.02,0 L31.02,49.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M52.59,33.01 L52.59,49.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M84,0 L84,24.76"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M99.51,41.25 L99.51,49.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M112.03,0 L112.03,24.76"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M122.78,41.25 L122.78,49.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M168.01,0 L168.01,49.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L168.07,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,8.25 L168.07,8.25"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,16.50 L168.07,16.50"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,24.75 L168.07,24.75"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,33.01 L168.07,33.01"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M30.96,41.25 L168.07,41.25"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,49.50 L168.07,49.50"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M168.01,0 L168.01,49.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M0,0 L0,49.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,49.50 L168.07,49.50"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L168.07,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path></svg>
			<div class="hce"
				style="left: 0mm; top: 0mm; width: 31.02mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 27.42mm;">
							<span class="hrt cs7">부서명</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 0mm; width: 52.98mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 49.37mm;">
							<span class="hrt cs7" id="empDept"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84mm; top: 0mm; width: 28.02mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 24.43mm;">
							<span class="hrt cs7">직급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 0mm; width: 55.98mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 52.38mm;">
							<span class="hrt cs7" id="empJbgd"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 8.25mm; width: 31.02mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 27.42mm;">
							<span class="hrt cs7">성명</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 8.25mm; width: 52.98mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 49.37mm;">
							<span class="hrt cs7" id="empName"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84mm; top: 8.25mm; width: 28.02mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 24.43mm;">
							<span class="hrt cs7">생년월일</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 8.25mm; width: 55.98mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 52.38mm;">
							<span class="hrt cs7" id="empbirth"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 16.50mm; width: 31.02mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 27.42mm;">
							<span class="hrt cs7">입사 일자</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 16.50mm; width: 52.98mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 49.37mm;">
							<span class="hrt cs7" id="empJoin"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84mm; top: 16.50mm; width: 28.02mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 24.43mm;">
							<span class="hrt cs7">퇴직 예정일</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 16.50mm; width: 55.98mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 52.38mm;">
							<span class="hrt cs7" id="empResign"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 24.75mm; width: 31.02mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 27.42mm;">
							<span class="hrt cs7">사직 사유</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 24.75mm; width: 136.99mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 133.39mm;">
							<span class="hrt cs7" id="empReason"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 33.01mm; width: 31.02mm; height: 16.50mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 5.99mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 27.42mm;">
							<span class="hrt cs7">사직 후 연락처</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 33.01mm; width: 21.57mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 17.96mm;">
							<span class="hrt cs7">주소</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 52.59mm; top: 33.01mm; width: 115.42mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 111.82mm;">
							<span class="hrt cs7" id="empaddr"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 41.25mm; width: 21.57mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 17.96mm;">
							<span class="hrt cs7">휴대폰</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 52.59mm; top: 41.25mm; width: 46.93mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 43.32mm;">
							<span class="hrt cs7" id="empTel"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.51mm; top: 41.25mm; width: 23.27mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 19.66mm;">
							<span class="hrt cs7">이메일</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 122.78mm; top: 41.25mm; width: 45.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 41.63mm;">
							<span class="hrt cs7" id="empEmail"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
