<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/salaryDoc_style.css">

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
			
			
			
			
			
			
			
	<!-- 본문 시작 -->
	<div class="hcD" style="left: 20mm; top: 25mm;">
		<div class="hcI">
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 4.10mm; white-space: nowrap; left: 0mm; top: 5.40mm; height: 4.94mm; width: 170mm;">
				<span class="hrt cs10">연봉 계약서</span>
			</div>
			<div class="hls ps23"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 13.37mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 20.43mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs8">1. 계약자 관련 사항</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 26.07mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 31.71mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 37.36mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 43mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 48.65mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs8">2. 계약 내용</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 54.29mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(1) 계약 기간 : &nbsp;&nbsp;&nbsp;&nbsp;년
					&nbsp;&nbsp;월 &nbsp;&nbsp;일 ~ &nbsp;&nbsp;&nbsp;&nbsp;년
					&nbsp;&nbsp;월 &nbsp;&nbsp;일</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 59.94mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(2) 총 연봉 금액 :
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;원</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 65.58mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 71.23mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 76.87mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 82.51mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 88.16mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 93.80mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 99.45mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 105.09mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 110.74mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 116.38mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 122.03mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps24"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 127.67mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 134.02mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(3) 연봉 지급 방식 : 상기의 연봉 중 Core Pay에 해당하는
					고정연봉은 균등 18분할하여 정기급여일에 12를</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 139.66mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">&nbsp;&nbsp;&nbsp;지급하고, 정기상여 지급일에 6을
					지급한다.</span>
			</div>
			<div class="hls ps24"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 145.31mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(4) 중도 입사자의 월 급여는 입사일자를 기준으로 계산하여 지급한다.</span>
			</div>
			<div class="hls ps24"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 151.66mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(5) 상기 계약 연봉에 포함되지 않은 제수당은 별도 기준에 의거
					지급한다.</span>
			</div>
			<div class="hls ps24"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 158.01mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(6) 연차수당 및 기타 복리후생은 취업규칙의 복리후생 기준에 따른다</span>
			</div>
			<div class="hls ps24"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 164.36mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(7) 개인 또는 조직의 업적, 회사의 경영성과에 따라 별도의
					인센티브를 지급할 수 있다.</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 170.71mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(8) 연봉 계약 기간 중 회사규정에 의거 징계를 받거나 직무 대기
					발령을 받을 경우 본 계약의 효력은 상실되며</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 176.35mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">&nbsp;&nbsp;&nbsp;&nbsp;회사는 해당하는 사유별
					기준에 의거 합리적인 절차를 거쳐 계약금액을 조정할 수 있다.</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 182mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(9) 연봉 계약 기간 중 퇴직하는 경우에는 본 계약의 효력은 상실되며
					1년 이상 계속 근로자의 퇴직 시&nbsp;</span><span class="htC"
					style="left: 0.88mm; width: 8.59mm; height: 100%;"></span>
			</div>
			<div class="hls ps20"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 187.64mm; height: 3.53mm; width: 170mm;">
				<span class="htC"
					style="left: 0.88mm; width: 12.35mm; height: 100%;"></span><span
					class="hrt cs7">취업규칙에 명시된 산정방식에 따라 퇴직금을 지급한다.</span>
			</div>
			<div class="hls ps24"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 193.29mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">(10) 상기 외의 기타사항은 회사 제반 규정에 따른다.</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 199.64mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 205.28mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 210.93mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">&nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;월
					&nbsp;&nbsp;일</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 216.57mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps21"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 222.21mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">계 약 자 :
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</span>
			</div>
			<div class="hls ps21"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 229.27mm; height: 3.53mm; width: 170mm;">
				<span class="hrt cs7">대표이사 :
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</span>
			</div>
			<div class="hls ps19"
				style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 236.33mm; height: 3.53mm; width: 170mm;"></div>
			<div class="hls ps19"
				style="line-height: 3.43mm; white-space: nowrap; left: 0mm; top: 241.93mm; height: 4.23mm; width: 170mm;">
				<span class="hrt cs9">㈜teamUp</span>
			</div>
		</div>
	</div>
	<div class="htb"
		style="left: 21mm; width: 170mm; top: 51.82mm; height: 18.50mm;">
		<svg class="hs" viewBox="-2.50 -2.50 175 23.50"
			style="left: -2.50mm; top: -2.50mm; width: 175mm; height: 23.50mm;">
			<defs>
			<pattern id="w_00" width="10" height="10"
				patternUnits="userSpaceOnUse">
			<rect width="10" height="10" fill="rgb(242,242,242)"></rect></pattern></defs>
			<path fill="url(#w_00)" d="M0,0L42,0L42,7.26L0,7.26L0,0Z "></path>
			<path fill="url(#w_00)" d="M42,0L84,0L84,7.26L42,7.26L42,0Z "></path>
			<path fill="url(#w_00)" d="M84,0L126,0L126,7.26L84,7.26L84,0Z "></path>
			<path fill="url(#w_00)"
				d="M126,0L168.01,0L168.01,7.26L126,7.26L126,0Z "></path>
			<defs>
			<pattern id="w_01" width="10" height="10"
				patternUnits="userSpaceOnUse">
			<rect width="10" height="10" fill="rgb(255,255,255)"></rect></pattern></defs>
			<path fill="url(#w_01)" d="M0,7.26L42,7.26L42,14.51L0,14.51L0,7.26Z "></path>
			<path fill="url(#w_01)"
				d="M42,7.26L84,7.26L84,14.51L42,14.51L42,7.26Z "></path>
			<path fill="url(#w_01)"
				d="M84,7.26L126,7.26L126,14.51L84,14.51L84,7.26Z "></path>
			<path fill="url(#w_01)"
				d="M126,7.26L168.01,7.26L168.01,14.51L126,14.51L126,7.26Z "></path>
			<path d="M0,0 L0,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M42,0 L42,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M84,0 L84,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M126,0 L126,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M168.01,0 L168.01,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,0 L168.07,0"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,7.26 L168.07,7.26"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,14.51 L168.07,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M168.01,0 L168.01,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M0,0 L0,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,14.51 L168.07,14.51"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
			<path d="M-0.06,0 L168.07,0"
				style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path></svg>
		<div class="hce"
			style="left: 0mm; top: 0mm; width: 42mm; height: 7.26mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.37mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 38.40mm;">
						<span class="hrt cs7">성명</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 42mm; top: 0mm; width: 42mm; height: 7.26mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.37mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 38.40mm;">
						<span class="hrt cs7">급/년차</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 84mm; top: 0mm; width: 42mm; height: 7.26mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.37mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 38.40mm;">
						<span class="hrt cs7">소속</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 126mm; top: 0mm; width: 42mm; height: 7.26mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.37mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 38.40mm;">
						<span class="hrt cs7">직급</span>
					</div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 0mm; top: 7.26mm; width: 42mm; height: 7.25mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.36mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 38.40mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 42mm; top: 7.26mm; width: 42mm; height: 7.25mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.36mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 38.40mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 84mm; top: 7.26mm; width: 42mm; height: 7.25mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.36mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 38.40mm;"></div>
				</div>
			</div>
		</div>
		<div class="hce"
			style="left: 126mm; top: 7.26mm; width: 42mm; height: 7.25mm;">
			<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
				<div class="hcI" style="top: 1.36mm;">
					<div class="hls ps19"
						style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 38.40mm;"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="htG"
		style="left: 20mm; width: 170mm; top: 85.25mm; height: 68.45mm;">
		<div class="htb"
			style="left: 1mm; width: 168.01mm; top: 9.17mm; height: 58.28mm;">
			<svg class="hs" viewBox="-2.50 -2.50 173.01 63.28"
				style="left: -2.50mm; top: -2.50mm; width: 173.01mm; height: 63.28mm;">
				<path fill="url(#w_00)" d="M0,0L99.05,0L99.05,7.28L0,7.28L0,0Z "></path>
				<path fill="url(#w_00)"
					d="M99.05,0L168.01,0L168.01,7.28L99.05,7.28L99.05,0Z "></path>
				<path fill="url(#w_00)"
					d="M0,7.28L21.04,7.28L21.04,29.14L0,29.14L0,7.28Z "></path>
				<path fill="url(#w_00)"
					d="M21.04,7.28L64.04,7.28L64.04,14.57L21.04,14.57L21.04,7.28Z "></path>
				<path fill="url(#w_00)"
					d="M21.04,14.57L64.04,14.57L64.04,21.85L21.04,21.85L21.04,14.57Z "></path>
				<path fill="url(#w_00)"
					d="M21.04,21.85L64.04,21.85L64.04,29.14L21.04,29.14L21.04,21.85Z "></path>
				<path fill="url(#w_00)"
					d="M0,29.14L21.04,29.14L21.04,50.99L0,50.99L0,29.14Z "></path>
				<path fill="url(#w_00)"
					d="M21.04,29.14L64.04,29.14L64.04,36.42L21.04,36.42L21.04,29.14Z "></path>
				<path fill="url(#w_00)"
					d="M21.04,36.42L64.04,36.42L64.04,43.71L21.04,43.71L21.04,36.42Z "></path>
				<path fill="url(#w_00)"
					d="M21.04,43.71L64.04,43.71L64.04,50.99L21.04,50.99L21.04,43.71Z "></path>
				<path fill="url(#w_00)"
					d="M0,50.99L99.05,50.99L99.05,58.28L0,58.28L0,50.99Z "></path>
				<path d="M0,0 L0,58.28"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M21.04,7.28 L21.04,51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M64.04,7.28 L64.04,51"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M99.05,0 L99.05,58.28"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M168.01,0 L168.01,58.28"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L168.07,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,7.28 L168.07,7.28"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M20.98,14.57 L168.07,14.57"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M20.98,21.85 L168.07,21.85"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,29.14 L168.07,29.14"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M20.98,36.42 L168.07,36.42"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M20.98,43.71 L168.07,43.71"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,50.99 L168.07,50.99"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,58.28 L168.07,58.28"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M168.01,0 L168.01,58.28"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M0,0 L0,58.28"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,58.28 L168.07,58.28"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L168.07,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path></svg>
			<div class="hce"
				style="left: 0mm; top: 0mm; width: 99.05mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 95.45mm;">
							<span class="hrt cs7">구분</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.05mm; top: 0mm; width: 68.96mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 65.35mm;">
							<span class="hrt cs7">산출근거</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 7.28mm; width: 21.04mm; height: 21.85mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 8.66mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 17.43mm;">
							<span class="hrt cs7">월 급여</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 21.04mm; top: 7.28mm; width: 43mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.40mm;">
							<span class="hrt cs7">기본급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 64.04mm; top: 7.28mm; width: 35.01mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 31.41mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.05mm; top: 7.28mm; width: 68.96mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 65.35mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 21.04mm; top: 14.57mm; width: 43mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.40mm;">
							<span class="hrt cs7">연차 수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 64.04mm; top: 14.57mm; width: 35.01mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 31.41mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.05mm; top: 14.57mm; width: 68.96mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 65.35mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 21.04mm; top: 21.85mm; width: 43mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.40mm;">
							<span class="hrt cs7">월 급여 총 금액(A)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 64.04mm; top: 21.85mm; width: 35.01mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 31.41mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.05mm; top: 21.85mm; width: 68.96mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 65.35mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 29.14mm; width: 21.04mm; height: 21.85mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 8.66mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 17.43mm;">
							<span class="hrt cs7">부가급여</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 21.04mm; top: 29.14mm; width: 43mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.40mm;">
							<span class="hrt cs7">상여</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 64.04mm; top: 29.14mm; width: 35.01mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 31.41mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.05mm; top: 29.14mm; width: 68.96mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 65.35mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 21.04mm; top: 36.42mm; width: 43mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.40mm;">
							<span class="hrt cs7">시간 외 근로 수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 64.04mm; top: 36.42mm; width: 35.01mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 31.41mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.05mm; top: 36.42mm; width: 68.96mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 65.35mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 21.04mm; top: 43.71mm; width: 43mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.40mm;">
							<span class="hrt cs7">부가급여 총 금액(B)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 64.04mm; top: 43.71mm; width: 35.01mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 31.41mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.05mm; top: 43.71mm; width: 68.96mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 65.35mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 50.99mm; width: 99.05mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 95.45mm;">
							<span class="hrt cs8">계약 연봉(A × 12 + B)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 99.05mm; top: 50.99mm; width: 68.96mm; height: 7.28mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.38mm;">
						<div class="hls ps22"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 65.35mm;"></div>
					</div>
				</div>
			</div>
		</div>
		<div class="hcD"
			style="left: 1mm; top: 3mm; width: 168.01mm; height: 3.17mm; overflow: hidden;">
			<div class="hcI">
				<div class="hls ps22"
					style="line-height: 2.48mm; white-space: nowrap; left: 0mm; top: -0.16mm; height: 3.17mm; width: 168.01mm;">
					<span class="hrt cs11">(단위 : 원)</span>
				</div>
			</div>
		</div>
	</div>
</div>
