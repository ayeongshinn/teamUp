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

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/salaryDetailsDoc_style.css">

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


<div class="hpa mx-auto" style="width: 210mm; height: 296.99mm;">
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
				<span class="hrt cs9">급여 명세서</span>
			</div>
			<div class="hls ps20"
				style="padding-left: 7.06mm; line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 240.96mm; height: 3.53mm; width: 170mm;"></div>
		</div>
	</div>
	<div class="htG"
		style="left: 20mm; width: 171.20mm; top: 41.51mm; height: 224.63mm;">
		<div class="htb"
			style="left: 1mm; width: 169.20mm; top: 9.17mm; height: 214.46mm;">
			<svg class="hs" viewBox="-2.50 -2.50 174.20 219.46"
				style="left: -2.50mm; top: -2.50mm; width: 174.20mm; height: 219.46mm;">
				<defs>
				<pattern id="w_00" width="10" height="10"
					patternUnits="userSpaceOnUse">
				<rect width="10" height="10" fill="rgb(242,242,242)"></rect></pattern></defs>
				<path fill="url(#w_00)" d="M0,0L31.02,0L31.02,8.25L0,8.25L0,0Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,0L112.03,0L112.03,8.25L84.60,8.25L84.60,0Z "></path>
				<path fill="url(#w_00)"
					d="M0,8.25L31.02,8.25L31.02,16.50L0,16.50L0,8.25Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,8.25L112.03,8.25L112.03,16.50L84.60,16.50L84.60,8.25Z "></path>
				<path fill="url(#w_00)"
					d="M0,16.50L31.02,16.50L31.02,24.75L0,24.75L0,16.50Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,16.50L112.03,16.50L112.03,24.75L84.60,24.75L84.60,16.50Z "></path>
				<path fill="url(#w_00)"
					d="M0,24.75L31.02,24.75L31.02,33L0,33L0,24.75Z "></path>
				<path fill="url(#w_00)"
					d="M0,33L169.20,33L169.20,41.25L0,41.25L0,33Z "></path>
				<path d="M0.06,41.06 L84.60,41.06"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M0.06,41.43 L84.60,41.43"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M84.60,41.06 L169.14,41.06"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M84.60,41.43 L169.14,41.43"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<defs>
				<pattern id="w_01" width="10" height="10"
					patternUnits="userSpaceOnUse">
				<rect width="10" height="10" fill="rgb(255,255,255)"></rect></pattern></defs>
				<path fill="url(#w_01)"
					d="M0,41.25L84.60,41.25L84.60,49.50L0,49.50L0,41.25Z "></path>
				<path d="M0.06,41.06 L84.60,41.06"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M0.06,41.43 L84.60,41.43"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path fill="url(#w_01)"
					d="M84.60,41.25L169.20,41.25L169.20,49.50L84.60,49.50L84.60,41.25Z "></path>
				<path d="M84.60,41.06 L169.14,41.06"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M84.60,41.43 L169.14,41.43"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path fill="url(#w_00)"
					d="M0,49.50L48.83,49.50L48.83,57.75L0,57.75L0,49.50Z "></path>
				<path fill="url(#w_00)"
					d="M48.83,49.50L84.60,49.50L84.60,57.75L48.83,57.75L48.83,49.50Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,49.50L125.97,49.50L125.97,57.75L84.60,57.75L84.60,49.50Z "></path>
				<path fill="url(#w_00)"
					d="M125.97,49.50L169.20,49.50L169.20,57.75L125.97,57.75L125.97,49.50Z "></path>
				<path fill="url(#w_00)"
					d="M0,57.75L14.88,57.75L14.88,115.48L0,115.48L0,57.75Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,57.75L48.83,57.75L48.83,65.99L14.88,65.99L14.88,57.75Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,57.75L125.97,57.75L125.97,65.99L84.60,65.99L84.60,57.75Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,65.99L48.83,65.99L48.83,74.24L14.88,74.24L14.88,65.99Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,65.99L125.97,65.99L125.97,74.24L84.60,74.24L84.60,65.99Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,74.24L48.83,74.24L48.83,82.49L14.88,82.49L14.88,74.24Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,74.24L125.97,74.24L125.97,82.49L84.60,82.49L84.60,74.24Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,82.49L48.83,82.49L48.83,90.74L14.88,90.74L14.88,82.49Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,82.49L125.97,82.49L125.97,90.74L84.60,90.74L84.60,82.49Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,90.74L48.83,90.74L48.83,98.99L14.88,98.99L14.88,90.74Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,90.74L125.97,90.74L125.97,98.99L84.60,98.99L84.60,90.74Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,98.99L48.83,98.99L48.83,107.23L14.88,107.23L14.88,98.99Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,98.99L125.97,98.99L125.97,107.23L84.60,107.23L84.60,98.99Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,107.23L48.83,107.23L48.83,115.48L14.88,115.48L14.88,107.23Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,107.23L125.97,107.23L125.97,115.48L84.60,115.48L84.60,107.23Z "></path>
				<path fill="url(#w_00)"
					d="M0,115.48L14.88,115.48L14.88,131.98L0,131.98L0,115.48Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,115.48L48.83,115.48L48.83,123.73L14.88,123.73L14.88,115.48Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,115.48L125.97,115.48L125.97,123.73L84.60,123.73L84.60,115.48Z "></path>
				<path fill="url(#w_00)"
					d="M14.88,123.73L48.83,123.73L48.83,131.98L14.88,131.98L14.88,123.73Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,123.73L125.97,123.73L125.97,131.98L84.60,131.98L84.60,123.73Z "></path>
				<path fill="url(#w_00)"
					d="M0,131.98L48.83,131.98L48.83,140.23L0,140.23L0,131.98Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,131.98L125.97,131.98L125.97,140.23L84.60,140.23L84.60,131.98Z "></path>
				<path fill="url(#w_00)"
					d="M84.60,140.23L125.97,140.23L125.97,148.47L84.60,148.47L84.60,140.23Z "></path>
				<path fill="url(#w_00)"
					d="M0,148.47L33.60,148.47L33.60,156.72L0,156.72L0,148.47Z "></path>
				<path fill="url(#w_00)"
					d="M33.60,148.47L67.20,148.47L67.20,156.72L33.60,156.72L33.60,148.47Z "></path>
				<path fill="url(#w_00)"
					d="M67.20,148.47L100.80,148.47L100.80,156.72L67.20,156.72L67.20,148.47Z "></path>
				<path fill="url(#w_00)"
					d="M100.80,148.47L134.39,148.47L134.39,156.72L100.80,156.72L100.80,148.47Z "></path>
				<path fill="url(#w_00)"
					d="M134.39,148.47L169.20,148.47L169.20,156.72L134.39,156.72L134.39,148.47Z "></path>
				<path fill="url(#w_00)"
					d="M0,164.97L169.20,164.97L169.20,173.22L0,173.22L0,164.97Z "></path>
				<path d="M0,0 L0,214.46"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M14.88,57.75 L14.88,131.98"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M31.02,0 L31.02,33.01"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M32.04,173.22 L32.04,214.46"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M33.60,148.47 L33.60,164.97"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M48.83,49.50 L48.83,140.23"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M67.20,148.47 L67.20,164.97"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M84.60,0 L84.60,24.76"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M84.60,41.50 L84.60,148.48"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M100.80,148.47 L100.80,164.97"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M112.03,0 L112.03,24.76"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M125.97,49.50 L125.97,148.48"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M134.39,148.47 L134.39,164.97"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M138.96,173.22 L138.96,214.46"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M169.20,0 L169.20,214.46"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L169.26,0"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,8.25 L169.26,8.25"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,16.50 L169.26,16.50"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,24.75 L169.26,24.75"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,33 L169.26,33"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,49.50 L169.26,49.50"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,57.75 L169.26,57.75"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M14.82,65.99 L169.26,65.99"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M14.82,74.24 L169.26,74.24"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M14.82,82.49 L169.26,82.49"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M14.82,90.74 L169.26,90.74"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M14.82,98.99 L169.26,98.99"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M14.82,107.23 L169.26,107.23"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,115.48 L169.26,115.48"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M14.82,123.73 L169.26,123.73"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,131.98 L169.26,131.98"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,140.23 L169.26,140.23"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,148.47 L169.26,148.47"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,156.72 L169.26,156.72"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,164.97 L169.26,164.97"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,173.22 L169.26,173.22"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,181.47 L169.26,181.47"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,189.71 L169.26,189.71"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,197.96 L169.26,197.96"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,206.21 L169.26,206.21"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,214.46 L169.26,214.46"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M169.20,0 L169.20,214.46"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M0,0 L0,214.46"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,214.46 L169.26,214.46"
					style="stroke:#000000;stroke-linecap:butt;stroke-width:0.12;"></path>
				<path d="M-0.06,0 L169.26,0"
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
				style="left: 31.02mm; top: 0mm; width: 53.58mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps21"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 49.97mm;">
							<span class="hrt cs7">${empSalaryVO.deptNm}</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 0mm; width: 27.43mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 23.83mm;">
							<span class="hrt cs7">직급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 0mm; width: 57.17mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps21"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 53.57mm;">
							<span class="hrt cs7">${empSalaryVO.jbgdNm}</span>
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
				style="left: 31.02mm; top: 8.25mm; width: 53.58mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps21"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 49.97mm;">
							<span class="hrt cs7">${empSalaryVO.empNm}</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 8.25mm; width: 27.43mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 23.83mm;">
							<span class="hrt cs7">연락처</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 8.25mm; width: 57.17mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps21"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 53.57mm;">
							<!-- 포매팅 -->
							<span class="hrt cs7">
								${fn:substring(empSalaryVO.empTelno, 0, 3)}-${fn:substring(empSalaryVO.empTelno, 3, 7)}-${fn:substring(empSalaryVO.empTelno, 7, 11)}
							</span>
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
							<span class="hrt cs7">금융기관명</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 16.50mm; width: 53.58mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps21"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 49.97mm;">
							<span class="hrt cs7">${empSalaryVO.fnstNm}</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 16.50mm; width: 27.43mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 23.83mm;">
							<span class="hrt cs7">지급일</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 112.03mm; top: 16.50mm; width: 57.17mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps21"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 53.57mm;">
							<span class="hrt cs7">매월 ${empSalaryVO.dsgnYmd}일</span>
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
							<span class="hrt cs7">지급 계좌번호</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 31.02mm; top: 24.75mm; width: 138.18mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps21"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 134.58mm;">
							<span class="hrt cs7">${empSalaryVO.giveActno}</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 33mm; width: 169.20mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 165.59mm;">
							<span class="hrt cs8">세부 내역</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 41.25mm; width: 84.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 81mm;">
							<span class="hrt cs7">지급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 41.25mm; width: 84.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 81mm;">
							<span class="hrt cs7">공제</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 49.50mm; width: 48.83mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 45.23mm;">
							<span class="hrt cs7">임금 항목</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 49.50mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs7">지급 금액(원)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 49.50mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;">
							<span class="hrt cs7">공제 항목</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 49.50mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;">
							<span class="hrt cs7">공제 금액(원)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 57.75mm; width: 14.88mm; height: 57.74mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 23.78mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 11.27mm;">
							<span class="hrt cs7">매월&nbsp;</span>
						</div>
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 5.47mm; height: 3.53mm; width: 11.27mm;">
							<span class="hrt cs7">지급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 57.75mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;">
							<span class="hrt cs7">기본급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 57.75mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.empBslry}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 57.75mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;">
							<span class="hrt cs7">국민연금</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 57.75mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.npn}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 65.99mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;">
							<span class="hrt cs7">연장근로수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 65.99mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.otmPay}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 65.99mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;">
							<span class="hrt cs7">건강보험</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 65.99mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.hlthinsIrncf}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 74.24mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;">
							<span class="hrt cs7">휴일근로수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 74.24mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.holPay}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 74.24mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;">
							<span class="hrt cs7">고용보험</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 74.24mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.emplyminsrncIrncf}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 82.49mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;">
							<span class="hrt cs7">야간근로수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 82.49mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.nitPay}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 82.49mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;">
							<span class="hrt cs7">소득세</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 82.49mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.ecmt}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 90.74mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;">
							<span class="hrt cs7">가족 수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 90.74mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.famAlwnc}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 90.74mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;">
							<span class="hrt cs7">지방세</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 90.74mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.llx}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 98.99mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;">
							<span class="hrt cs7">식대</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 98.99mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.mealCt}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 98.99mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 98.99mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 107.23mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 107.23mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 107.23mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 107.23mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 115.48mm; width: 14.88mm; height: 16.50mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 3.16mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 11.27mm;">
							<span class="hrt cs7">부정기&nbsp;</span>
						</div>
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: 5.47mm; height: 3.53mm; width: 11.27mm;">
							<span class="hrt cs7">지급</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 115.48mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;">
							<span class="hrt cs7">상여금</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 115.48mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs7">
								<c:choose>
								    <c:when test="${not empty empSalaryVO.bonus}">
								        <fmt:formatNumber value="${empSalaryVO.bonus}" type="number" groupingUsed="true"/>
								    </c:when>
								    <c:otherwise>
								        0
								    </c:otherwise>
								</c:choose>
							</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 115.48mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 115.48mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 14.88mm; top: 123.73mm; width: 33.95mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30.34mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 123.73mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 123.73mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 123.73mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 131.98mm; width: 48.83mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 45.23mm;">
							<span class="hrt cs8">총 지급 금액</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 48.83mm; top: 131.98mm; width: 35.77mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps25"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 32.16mm;">
							<span class="hrt cs12"><fmt:formatNumber value="${empSalaryVO.totGiveAmt}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 131.98mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;">
							<span class="hrt cs8">총 공제 금액</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 131.98mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps25"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;">
							<span class="hrt cs12"><fmt:formatNumber value="${empSalaryVO.totDdcAmt}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 140.23mm; width: 84.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 81mm;"></div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 84.60mm; top: 140.23mm; width: 41.37mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 37.76mm;">
							<span class="hrt cs8">실 수령 금액(원)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 125.97mm; top: 140.23mm; width: 43.23mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps23"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 39.62mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.realRecptAmt}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 148.47mm; width: 33.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30mm;">
							<span class="hrt cs7">총 근로시간</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 33.60mm; top: 148.47mm; width: 33.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30mm;">
							<span class="hrt cs7">연장근로시간</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 67.20mm; top: 148.47mm; width: 33.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30mm;">
							<span class="hrt cs7">야간근로시간</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 100.80mm; top: 148.47mm; width: 33.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30mm;">
							<span class="hrt cs7">휴일근로시간</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 134.39mm; top: 148.47mm; width: 34.81mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 31.20mm;">
							<span class="hrt cs7">기타</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 156.72mm; width: 33.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30mm;">
							<span class="hrt cs7">209</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 33.60mm; top: 156.72mm; width: 33.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30mm;">
							<span class="hrt cs7">0</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 67.20mm; top: 156.72mm; width: 33.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30mm;">
							<span class="hrt cs7">0</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 100.80mm; top: 156.72mm; width: 33.60mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 30mm;">
							<span class="hrt cs7">0</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 134.39mm; top: 156.72mm; width: 34.81mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 31.20mm;">
							<span class="hrt cs7">0</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 164.97mm; width: 169.20mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 165.59mm;">
							<span class="hrt cs8">계산방법</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 173.22mm; width: 32.04mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 28.43mm;">
							<span class="hrt cs7">구분</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 32.04mm; top: 173.22mm; width: 106.92mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 103.31mm;">
							<span class="hrt cs7">산출식</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 138.96mm; top: 173.22mm; width: 30.24mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.64mm;">
							<span class="hrt cs7">지급액(원)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 181.47mm; width: 32.04mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 28.43mm;">
							<span class="hrt cs7">연장근로수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 32.04mm; top: 181.47mm; width: 106.92mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 103.31mm;">
							<span class="hrt cs7">연장근로시간 수 (<fmt:formatNumber value="${empSalaryVO.otmPay / (empSalaryVO.empBslry / 209) / 1.5}" type="number" groupingUsed="true" maxFractionDigits="0"/>시간)
							 × <fmt:formatNumber value="${empSalaryVO.empBslry / 209}" type="number" groupingUsed="true" maxFractionDigits="0"/>원 × 1.5
							</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 138.96mm; top: 181.47mm; width: 30.24mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.64mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.otmPay}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 189.71mm; width: 32.04mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 28.43mm;">
							<span class="hrt cs7">휴일근로수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 32.04mm; top: 189.71mm; width: 106.92mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 103.31mm;">
							<span class="hrt cs7">휴일근로시간 수 (<fmt:formatNumber value="${empSalaryVO.holPay / (empSalaryVO.empBslry / 209) / 1.5}" type="number" groupingUsed="true" maxFractionDigits="0"/>시간)
							 × <fmt:formatNumber value="${empSalaryVO.empBslry / 209}" type="number" groupingUsed="true" maxFractionDigits="0"/>원 × 1.5</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 138.96mm; top: 189.71mm; width: 30.24mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.64mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.holPay	}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 197.96mm; width: 32.04mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 28.43mm;">
							<span class="hrt cs7">야간근로수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 32.04mm; top: 197.96mm; width: 106.92mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 103.31mm;">
							<span class="hrt cs7">야간근로시간 수 (<fmt:formatNumber value="${empSalaryVO.nitPay / (empSalaryVO.empBslry / 209) / 1.5}" type="number" groupingUsed="true" maxFractionDigits="0"/>시간)
							 × <fmt:formatNumber value="${empSalaryVO.empBslry / 209}" type="number" groupingUsed="true" maxFractionDigits="0"/>원 × 1.5</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 138.96mm; top: 197.96mm; width: 30.24mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.64mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.nitPay	}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 0mm; top: 206.21mm; width: 32.04mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 28.43mm;">
							<span class="hrt cs7">가족수당</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 32.04mm; top: 206.21mm; width: 106.92mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 103.31mm;">
							<span class="hrt cs7">100,000원 × 0명 (배우자) + 50,000원 × 0명
								(자녀)</span>
						</div>
					</div>
				</div>
			</div>
			<div class="hce"
				style="left: 138.96mm; top: 206.21mm; width: 30.24mm; height: 8.25mm;">
				<div class="hcD" style="left: 1.80mm; top: 0.50mm;">
					<div class="hcI" style="top: 1.86mm;">
						<div class="hls ps19"
							style="line-height: 2.79mm; white-space: nowrap; left: 0mm; top: -0.18mm; height: 3.53mm; width: 26.64mm;">
							<span class="hrt cs7"><fmt:formatNumber value="${empSalaryVO.famAlwnc}" type="number" groupingUsed="true"/></span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="hcD"
			style="left: 1mm; top: 3mm; width: 169.20mm; height: 3.17mm; overflow: hidden;">
			<div class="hcI">
				<div class="hls ps23"
					style="line-height: 2.48mm; white-space: nowrap; left: 0mm; top: -0.16mm; height: 3.17mm; width: 169.19mm;">
					<span class="hrt cs13">
						( ${fn:substring(empSalaryVO.trgtDt, 0, 4)}년 ${fn:substring(empSalaryVO.trgtDt, 4, 6)}월 급여 명세서 ) &nbsp;
					</span>
				</div>
			</div>
		</div>
	</div>
</div>

