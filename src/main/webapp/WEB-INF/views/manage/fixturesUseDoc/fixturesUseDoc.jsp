<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/fixturesUseDoc_style.css">
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<!-- jQuery 라이브러리 (최신 버전) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- jQuery UI 라이브러리 -->
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<!-- jQuery UI CSS (자동완성 UI 스타일 포함) -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script type="text/javascript">

$(document).ready(function() {
	
	let empNo = $('#drftEmpNo').data('empno');
	console.log("empNo: " + empNo);
	
    // Ajax를 통해 사원 정보 가져오기
    $.ajax({
        url: '/fixturesUseDoc/getEmpInfo',
        type: 'post',
        dataType:"json",
        data : {empNo:empNo},
        beforeSend: function(xhr) {
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 포함
        },
        success: function(empVO) {
            // 사원 정보가 성공적으로 조회되면 직급명과 부서명 출력
             $('#deptNm').text(empVO.deptNm);
             $('#jbgdNm').text(empVO.jbgdNm);
             
             let phone = empVO.empTelno;
             phone = phone.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
             
             $('#empTelno').text(phone);
        },
        error: function() {
            alert("사원 정보를 불러오는데 실패했습니다.");
        }
    });
    
	
	var today = new Date();
	var year = today.getFullYear();
	var month = today.getMonth() + 1;  // 월은 0부터 시작하므로 +1 필요
	var day = today.getDate();

    if (month < 10) month = '0' + month;
    if (day < 10) day = '0' + day;

    var formattedDate = year + "년 " + month + "월 " + day + "일";
    
    console.log("formatteDate : " + formattedDate);
    
    $('#docWYmd').text(formattedDate);
    
	//자동완성
	$('#fxtrsNm').autocomplete({
	    source: function(request, response) {
	        $.ajax({
	            url: "/fixturesUseDoc/autocomplete",
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
	                        	label: highlightedName + " (" + item.FXTRS_PSTN_NM + ", " + item.FXTRS_STTUS_NM + ")", 
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
	        $('#fixNm').text(ui.item.value);
	        $('#fxtrsNm').val(ui.item.value);
	        console.log("선택된 사원번호: " + ui.item.idx);
	        return false;
	    }
	}).data("ui-autocomplete")._renderItem = function(ul, item) {
	    return $("<li>").append("<div>" + item.label + "</div>")  // label에 하이라이트 적용된 값이 들어감
	        .appendTo(ul);
	};
	
	//신청사유
	$('#usePrps').on('input', function() {
		$('#docCn').text($(this).val());
	});
	
	//수량
	$('#fxtrsQy').on('input', function(){
		$('#fixQy').text($(this).val());
	});
	
    //사용기간
    $('#bgngYmd, #endYmd').on('input', function(){
        const useBgngYmd = $('#bgngYmd').val();
        const useEndYmd = $('#endYmd').val();

        if (useBgngYmd && useEndYmd) {
            // 날짜 형식을 YYYY.MM.DD로 변환
            const formattedBgngYmd = useBgngYmd.replace(/-/g, '.');
            const formattedEndYmd = useEndYmd.replace(/-/g, '.');
            $('#useYmd').text(formattedBgngYmd + "부터 " + formattedEndYmd + "까지");
        } else {
            $('#useYmd').text('');
        }
    });
    
});

</script>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

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
	
	<div class="hcD" style="left: 20mm; top: 25mm;">
		<div class="hcI">
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 4.10mm; white-space: nowrap; left: 0mm; top: 5.40mm; height: 4.94mm; width: 170mm;">
				<span class="hrt cs10">비품 사용 신청서</span>
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
			
		<div id="fixturesUseDoc" class="fixturesUseDoc hcD" style="left: 20mm; top: 25mm;" >	
		  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/fixturesUseDoc_style.css">
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 58.53mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 64.17mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 69.81mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs8">· 신청인 관련 사항</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 128.91mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 134.56mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 140.20mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps21"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 145.85mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">상기와 같이 비품 사용을 신청합니다.</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 151.49mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 157.13mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 162.78mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 168.42mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 174.07mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 179.71mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7" id="docWYmd" >&nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;월
					&nbsp;&nbsp;일</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 185.36mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 191mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 196.65mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 202.29mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 207.93mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 213.58mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps24"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 219.22mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">신 청 인 :
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</span>
			</div>
			<div class="hls ps24"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 226.28mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">대표이사 :
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 233.33mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 3.43mm; white-space: nowrap; left: 0mm; top: 238.94mm; height: 4.23mm; width: 170mm;">
				<span class="hrt cs9">㈜teamUp</span>
			</div>
		</div>
	
	<div class="htb"
		style="left: 24.31mm; top: 48.95mm; width: 63.18mm; height: 30.07mm;">
		<svg class="hs" viewBox="-2.50 -2.50 68.18 35.07"
			style="left: -2.50mm; top: -2.50mm; width: 68.18mm; height: 35.07mm;">
			<defs>
			<pattern id="w_00" width="10" height="10"
				patternUnits="userSpaceOnUse">
			<rect width="10" height="10" fill="rgb(242,242,242)" /></pattern></defs>
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
	
	<div class="fixturesUseDoc">
	<div class="htb"
		style="left: 21mm; top: 103.58mm; width: 170mm; height: 53.51mm;">
		<svg class="hs" viewBox="-2.50 -2.50 175 58.50"
			style="left: -2.50mm; top: -2.50mm; width: 175mm; height: 58.50mm;">
			<path fill="url(#w_00)" d="M0,0L31.02,0L31.02,8.25L0,8.25L0,0Z "></path>
			<path fill="url(#w_00)" d="M84,0L112.03,0L112.03,8.25L84,8.25L84,0Z "></path>
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
			<path fill="url(#w_00)"
				d="M0,41.26L31.02,41.26L31.02,49.51L0,49.51L0,41.26Z "></path>
			<path d="M0,0 L0,49.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M31.02,0 L31.02,49.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M84,0 L84,16.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M112.03,0 L112.03,16.51"
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
			<path d="M-0.06,41.26 L168.07,41.26"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,49.51 L168.07,49.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M168.01,0 L168.01,49.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M0,0 L0,49.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,49.51 L168.07,49.51"
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
						<span class="hrt cs7" id="deptNm"></span>
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
						<span class="hrt cs7" id="jbgdNm"></span>
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
						<span class="hrt cs7" id="drftEmpNo" data-empno="${empVO.empNo}">${empVO.empNm}</span>
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
						<span class="hrt cs7" id="empTelno">${empVO.empTelno}</span>
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
						<span class="hrt cs7" id="docCn" ></span>
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
						<span class="hrt cs7">품명</span>
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
						<span class="hrt cs7" id="fixNm"></span>
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
						<span class="hrt cs7">수량</span>
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
						<span class="hrt cs7" id="fixQy"></span>
						</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 0mm; top: 41.26mm; width: 31.02mm; height: 8.25mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.86mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 27.42mm;">
						<span class="hrt cs7">사용기간</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 31.02mm; top: 41.26mm; width: 136.99mm; height: 8.25mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.86mm;">
					<div class="hls ps23"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 133.38mm;">
					    <span class="hrt cs7" id="useYmd"></span>
						</div>
				</div>
			</div>
		</div>
	</div>
	<div class="htb"
		style="left: 123.70mm; top: 45.71mm; width: 67.30mm; height: 35.53mm;">
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