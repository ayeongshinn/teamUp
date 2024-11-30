<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/hrMovementDoc_style.css">

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
	
    <script type="text/javascript">
	    $(document).ready(function() {
	        // 로그인한 사원의 이름과 번호를 JSP에서 가져옴
	        var empNm = '${empVO.empNm}';  // 사원 이름
			
	        var spacedName = empNm.split('').join(' ');
	        
	        // 'registEmp' 요소에 사원 이름을 동적으로 삽입
	        $('#registEmp').html('신 청 인 : &nbsp;&nbsp;' + spacedName + '&nbsp;&nbsp;(인)');
	    });
    </script>
</sec:authorize>

<!-- jQuery 라이브러리 (최신 버전) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- jQuery UI 라이브러리 -->
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<!-- jQuery UI CSS (자동완성 UI 스타일 포함) -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">


<script type="text/javascript">

//자동완성
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
	
	//사원 자동완성 시 폼 자동 작성
	$('#trgtEmpNm').autocomplete({
	    source: function(request, response) {
	        $.ajax({
	            url: "/hrMovementDoc/autocomplete",
	            type: "POST",
	            dataType: "JSON",
	            data: { empNm: request.term },
	            beforeSend: function(xhr) {
	                // CSRF 토큰을 헤더에 추가
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
	            success: function(data) {
	                response(
	                    $.map(data.resultList, function(item) {
	                        // 검색어 하이라이트 처리
	                        var highlightedName = item.EMP_NM.replace(
	                            new RegExp("(" + request.term + ")", "gi"),
	                            "<span class='highlight'>$1</span>"
	                        );
	                        return {
	                            label: highlightedName + " (" + item.DEPT_NM + ", " + item.JBGD_NM + ")",
	                            value: item.EMP_NM,  // 선택 시 입력 필드에 표시될 값
	                            idx: item.EMP_NO,   // 사원 번호
	                            dept_nm: item.DEPT_NM,  // 부서명
	                            jbgd_nm: item.JBGD_NM,  // 직급명
	                            emp_telno: item.EMP_TELNO,  // 전화번호
	                            jncmp_ymd: item.JNCMP_YMD  // 입사일자
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
	        $('#trgtEmpNo').val(ui.item.idx);  // 선택한 사원 번호를 input에 넣기
	        $('#trgtEmpNm').val(ui.item.value);  // 선택한 사원 이름을 input에 넣기
	
	     	// 전화번호 포매팅 (3자리 - 4자리 - 4자리)
	        var formattedTelno = ui.item.emp_telno.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");

	        // 날짜 포매팅 (YYYY.MM.DD)
	        var formattedDate = ui.item.jncmp_ymd.replace(/(\d{4})(\d{2})(\d{2})/, "$1.$2.$3");

	        // 선택한 사원의 정보들을 지정한 span 태그에 동적으로 삽입
	        $('#empName').text(ui.item.value);  // 사원 이름
	        $('#empDept').text(ui.item.dept_nm);  // 부서명
	        $('#empJbgd').text(ui.item.jbgd_nm);  // 직급명
	        $('#empTel').text(formattedTelno);  // 전화번호 포매팅 후
	        $('#empPeriod').text(formattedDate);  // 입사일자 포매팅 후
	        $('#empName2').text(ui.item.value);
	        $('#empDept2').text(ui.item.dept_nm);
	        $('#empJbgd2').text(ui.item.jbgd_nm);

	        console.log("선택된 사원번호: " + ui.item.idx);
	        
	        console.log("선택된 사원번호: " + ui.item.idx);
	        return false;
	    }
	}).data("ui-autocomplete")._renderItem = function(ul, item) {
	    return $("<li>").append("<div>" + item.label + "</div>")  // 하이라이트된 이름 및 부서/직급 표시
	        .appendTo(ul);
	};
	
	//신청사유 작성
	$('#docCn').on('input', function() {
		$('#empReason').text($(this).val());
	});
	
	//담당 프로젝트 작성
	$('#project').on('input', function() {
		$('#empProject').text($(this).val());
	});
	
	//비고 작성
	$('#note').on('input', function() {
		$('#appointNote').text($(this).val());
	});
	
	//소속 선택
	$('#deptCd').on('change', function() {
		var selectedDept = $(this).find('option:selected').text();
		$('#appointDept').text(selectedDept);
	});
	
	//직급 선택
	$('#jbgdCd').on('change', function() {
		var selectedDept = $(this).find('option:selected').text();
		$('#appointJbgd').text(selectedDept);
	});
	
	//발령일 선택
	$('#trgtDay').on('change', function() {
	    var selectedDay = $(this).val();
	    var formattedDay = selectedDay.replace(/-/g, ".");
	    $('#appointDay').text(formattedDay);
	});
});
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

	<!-- 결재라인 시작 -->
	<!-- 기안 정보 시작 -->
	<div class="htb" style="left: 24.31mm; width: 63.18mm; top: 48.95mm; height: 30.07mm;">
		<svg class="hs" viewBox="-2.50 -2.50 68.18 35.07" style="left: -2.50mm; top: -2.50mm; width: 68.18mm; height: 35.07mm;">
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
	<!-- 결재라인 끝 -->

	<!-- 본 문서 시작 -->
	<div class="hcD" style="left: 20mm; top: 25mm;">
		<div class="hcI">
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 4.10mm; white-space: nowrap; left: 0mm; top: 5.40mm; height: 4.94mm; width: 170mm;">
				<span class="hrt cs10">인사 이동 기안서</span>
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

	<div id="hrMovementDoc" class="hrMovementDoc hcD" style="left: 20mm; top: 25mm;">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/hrMovementDoc_style.css">

		<div class="hls ps21"
			style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 58.53mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps21"
			style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 64.17mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps20"
			style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 69.81mm; height: 3.53mm; width: 170mm;">
			<span class="hrt cs8">· 신청인 관련 사항</span>
		</div>
		<div class="hls ps20"
			style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 120.66mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps20"
			style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 126.30mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps21"
			style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 131.95mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps21"
			style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 137.59mm; height: 3.53mm; width: 170mm;">
			<span class="hrt cs7">하기와 같이 인사발령 되었음을 공고합니다.</span>
		</div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 143.24mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 148.88mm; height: 3.53mm; width: 170mm;">
			<span class="hrt cs7">- 아 &nbsp;&nbsp;&nbsp;래 -</span>
		</div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 154.53mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 160.17mm; height: 3.53mm; width: 0mm;"></div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 187.02mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 192.66mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 198.31mm; height: 3.53mm; width: 170mm;">
			<span class="hrt cs7" id="registDay">&nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;월
				&nbsp;&nbsp;일</span>
		</div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 203.95mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 209.60mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps24"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 215.24mm; height: 3.53mm; width: 170mm;">
			<span class="hrt cs7" id="registEmp">신 청 인 :
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</span>
		</div>
		<div class="hls ps24"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 222.30mm; height: 3.53mm; width: 170mm;">
			<span class="hrt cs7" id="ceo">대표이사 :&nbsp;&nbsp;정 지 훈&nbsp;&nbsp;(인)</span>
		</div>
		<div class="hls ps19"
			style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 229.35mm; height: 3.53mm; width: 170mm;"></div>
		<div class="hls ps19"
			style="line-height: 3.43mm; white-space: nowrap; left: 0mm; top: 234.96mm; height: 4.23mm; width: 170mm;">
			<span class="hrt cs9">㈜teamUp</span>
		</div>
	</div>

	<div class="hrMovementDoc">
		<div class="htb"
			style="left: 21mm; width: 170mm; top: 103.58mm; height: 45.25mm;">
			<svg class="hs" viewBox="-2.50 -2.50 175 50.25"
				style="left: -2.50mm; top: -2.50mm; width: 175mm; height: 50.25mm;">
					<path fill="url(#w_00)" d="M0,0L31.02,0L31.02,8.25L0,8.25L0,0Z "></path>
					<path fill="url(#w_00)"
					d="M84,0L112.03,0L112.03,8.25L84,8.25L84,0Z "></path>
					<path fill="url(#w_00)"
					d="M0,8.25L31.02,8.25L31.02,16.50L0,16.50L0,8.25Z "></path>
					<path fill="url(#w_00)"
					d="M84,8.25L112.03,8.25L112.03,16.50L84,16.50L84,8.25Z "></path>
					<path fill="url(#w_00)"
					d="M0,16.50L31.02,16.50L31.02,24.75L0,24.75L0,16.50Z "></path>
					<path fill="url(#w_00)"
					d="M0,24.75L31.02,24.75L31.02,33.01L0,33.01L0,24.75Z "></path>
					<path fill="url(#w_00)"
					d="M0,33.01L31.02,33.01L31.02,41.26L0,41.26L0,33.01Z "></path>
					<path d="M0,0 L0,41.26"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M31.02,0 L31.02,41.26"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M84,0 L84,16.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M112.03,0 L112.03,16.51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M168.01,0 L168.01,41.26"
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
					<path d="M-0.06,41.26 L168.07,41.26"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M168.01,0 L168.01,41.26"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M0,0 L0,41.26"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M-0.06,41.26 L168.07,41.26"
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
						<div class="hls ps23"
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
						<div class="hls ps23"
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
						<div class="hls ps23"
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
							<span class="hrt cs7">연락처</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 8.25mm; width: 55.98mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 52.38mm;">
							<span class="hrt cs7" id="empTel"></span>
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
							<span class="hrt cs7">신청사유</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 16.50mm; width: 136.99mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 133.38mm;">
							<span class="hrt cs7" id="empReason"></span>
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
							<span class="hrt cs7">근속기간</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 24.75mm; width: 136.99mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 133.38mm;">
							<span class="hrt cs7" id="empPeriod"></span>	
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 33.01mm; width: 31.02mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 27.42mm;">
							<span class="hrt cs7">담당 프로젝트</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 33.01mm; width: 136.99mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 133.38mm;">
							<span class="hrt cs7" id="empProject"></span>	
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="htb"
			style="left: 21mm; width: 169.99mm; top: 187.89mm; height: 25.30mm;">
			<svg class="hs" viewBox="-2.50 -2.50 174.99 30.30"
				style="left: -2.50mm; top: -2.50mm; width: 174.99mm; height: 30.30mm;">
					<path fill="url(#w_00)" d="M0,0L22,0L22,15.54L0,15.54L0,0Z "></path>
					<path fill="url(#w_00)" d="M22,0L70,0L70,7.77L22,7.77L22,0Z "></path>
					<path fill="url(#w_00)" d="M70,0L118,0L118,7.77L70,7.77L70,0Z "></path>
					<path fill="url(#w_00)" d="M118,0L143,0L143,15.54L118,15.54L118,0Z "></path>
					<path fill="url(#w_00)" d="M143,0L168,0L168,15.54L143,15.54L143,0Z "></path>
					<path fill="url(#w_00)" d="M22,7.77L46,7.77L46,15.54L22,15.54L22,7.77Z "></path>
					<path fill="url(#w_00)" d="M46,7.77L70,7.77L70,15.54L46,15.54L46,7.77Z "></path>
					<path fill="url(#w_00)" d="M70,7.77L94,7.77L94,15.54L70,15.54L70,7.77Z "></path>
					<path fill="url(#w_00)" d="M94,7.77L118,7.77L118,15.54L94,15.54L94,7.77Z "></path>
					<path d="M0,0 L0,23.31" style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M22,0 L22,23.31" style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M46,7.77 L46,23.31" style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M70,0 L70,23.31"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M94,7.77 L94,23.31"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M118,0 L118,23.31"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M143,0 L143,23.31"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M168,0 L168,23.31"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M-0.06,0 L168.06,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M21.95,7.77 L118.06,7.77"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M-0.06,15.54 L168.06,15.54"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M-0.06,23.30 L168.06,23.30"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M168,0 L168,23.31"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M0,0 L0,23.31"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M-0.06,23.30 L168.06,23.30"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
					<path d="M-0.06,0 L168.06,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path></svg>
			<div class="hce"
				style="left: 0mm; top: 0mm; width: 22mm; height: 15.54mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 5.51mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 18.40mm;">
							<span class="hrt cs7">성명</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 22mm; top: 0mm; width: 48mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 44.39mm;">
							<span class="hrt cs7">현임</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 70mm; top: 0mm; width: 48mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 44.39mm;">
							<span class="hrt cs7">발령내용</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 118mm; top: 0mm; width: 25mm; height: 15.54mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 5.51mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 21.39mm;">
							<span class="hrt cs7">발령일</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 143mm; top: 0mm; width: 25mm; height: 15.54mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 5.51mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 21.39mm;">
							<span class="hrt cs7">비고</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 22mm; top: 7.77mm; width: 24mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 20.39mm;">
							<span class="hrt cs7">소속</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 46mm; top: 7.77mm; width: 24mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 20.39mm;">
							<span class="hrt cs7">직급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 70mm; top: 7.77mm; width: 24mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 20.39mm;">
							<span class="hrt cs7">소속</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 94mm; top: 7.77mm; width: 24mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 20.39mm;">
							<span class="hrt cs7">직급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 15.54mm; width: 22mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 18.40mm;">
							<span class="hrt cs7" id="empName2"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 22mm; top: 15.54mm; width: 24mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 20.39mm;">
							<span class="hrt cs7" id="empDept2"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 46mm; top: 15.54mm; width: 24mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 20.39mm;">
							<span class="hrt cs7" id="empJbgd2"></span>	
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 70mm; top: 15.54mm; width: 24mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 20.39mm;">
							<span class="hrt cs7" id="appointDept"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 94mm; top: 15.54mm; width: 24mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 20.39mm;">
							<span class="hrt cs7" id="appointJbgd"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 118mm; top: 15.54mm; width: 25mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 21.39mm;">
							<span class="hrt cs7" id="appointDay"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 143mm; top: 15.54mm; width: 25mm; height: 7.77mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.62mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 21.39mm;">
							<span class="hrt cs7" id="appointNote"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 본문서 끝 -->
	</div>
</div>

<script>



</script>