<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<title></title>
</head>
<body style="width:800;height:600;">

<div class="card-body table-responsive p-10 pb-1">
	       
     <form id="selectStatus">
	      <h3 class="text-lg mb-2 font-semibold text-slate-800">
	          	급여명세서
	      </h3>
	      <table class="table-auto border-collapse border w-full text-center">
		      <thead class="sticky top-0 bg-white z-10">
		          <!-- 테이블 헤더는 필요시 추가 -->
		      </thead>
		      <tbody id="tby" class="bg-gray-50">
		          <tr class="bg-white">
		              <td class="border p-2 font-bold w-1/6" style="background-color: #4E7DF4; color: white;">이름</td>
		              <td class="border p-2 w-1/6" id="trgt_emp_no">${salaryDetailsDocVO.empNm}</td>
		              <td class="border p-2 w-1/6 font-bold" style="background-color: #4E7DF4; color: white;">부서</td>
		              <td class="border p-2 w-1/6" id="trgt_emp_no">
		              	<c:if test="${salaryDetailsDocVO.deptCd=='A17-001'}">경영진</c:if>
		              	<c:if test="${salaryDetailsDocVO.deptCd=='A17-002'}">기획부서</c:if>
		              	<c:if test="${salaryDetailsDocVO.deptCd=='A17-003'}">관리부서</c:if>
		              	<c:if test="${salaryDetailsDocVO.deptCd=='A17-004'}">영업부서</c:if>
		              	<c:if test="${salaryDetailsDocVO.deptCd=='A17-005'}">인사부서</c:if>		              	
		              </td>
		              <td class="border p-2 w-1/6 font-bold" style="background-color: #4E7DF4; color: white;">직급</td>
		              <td class="border p-2 w-1/6" id="trgt_emp_no">
		              	<c:if test="${salaryDetailsDocVO.jbgdCd=='A18-001'}">사원</c:if>
		              	<c:if test="${salaryDetailsDocVO.jbgdCd=='A18-002'}">대리</c:if>
		              	<c:if test="${salaryDetailsDocVO.jbgdCd=='A18-003'}">차장</c:if>
		              	<c:if test="${salaryDetailsDocVO.jbgdCd=='A18-004'}">부장</c:if>
		              	<c:if test="${salaryDetailsDocVO.jbgdCd=='A18-005'}">이사</c:if>
		              	<c:if test="${salaryDetailsDocVO.jbgdCd=='A18-006'}">사장</c:if>
		              </td>
		          </tr>
		          <tr class="bg-white">
		              <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">은행명</td>
		              <td class="border p-2" id="trgt_emp_no">${salaryDetailsDocVO.fnstNm}</td>
		              <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">지급계좌</td>
		              <td class="border p-2" id="trgt_emp_no">${salaryDetailsDocVO.giveActno}</td>
		              <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">지급일</td>
		              <td class="border p-2" id="trgt_emp_no">
		              	<c:if test="${salaryDetailsDocVO.trgtDt=='202409'}">2024.9.10</c:if>	
		              	<c:if test="${salaryDetailsDocVO.trgtDt=='202410'}">2024.10.10</c:if>	
		              </td>
		          </tr>
		      </tbody>
		  </table>
    </form>
</div>
<div class="card-body table-responsive p-10 pt-1 pb-1 flex space-x-8"> <!-- Flexbox로 두 테이블 섹션을 가로 배치 -->
    <!-- 첫 번째 묶음 -->
    <div class="w-1/2">
        <table class="table-auto border-collapse border w-full text-center">
            <tbody id="tby">
                <tr class="bg-white">
                    <td class="border p-2 w-1/8 font-bold" style="background-color: #4E7DF4; color: white;">기본급</td>
                    <td class="border p-2 w-1/8" id="otm_pay">${salaryDetailsDocVO.empBslry}</td>
                    <td class="border p-2 w-1/8 font-bold" style="background-color: #4E7DF4; color: white;">연장 근로 수당</td>
                    <td class="border p-2 w-1/8" id="otm_pay">${salaryDetailsDocVO.otmPay}</td>
                </tr>
                <tr class="bg-white">     
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">휴일 근로 수당</td>
                    <td class="border p-2" id="hol_pay">${salaryDetailsDocVO.holPay}</td>
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">야간 근로 수당</td>
                    <td class="border p-2" id="nit_pay">${salaryDetailsDocVO.nitPay}</td>
                </tr>
                <tr class="bg-white">    
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">가족 수당</td>
                    <td class="border p-2" id="fam_alwnc">${salaryDetailsDocVO.famAlwnc}</td>
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">상여금</td>
                    <td class="border p-2" id="bonus">${salaryDetailsDocVO.bonus}</td>
                </tr>
                <tr class="bg-white">    
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">식사 비용</td>
                    <td class="border p-2" id="meal_ct">${salaryDetailsDocVO.mealCt}</td>
                    <td class="border p-2 colspan='2' bg-gray-100"></td>
                    <td class="border p-2  bg-gray-100"></td>
                </tr>
                <tr class="bg-white">
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">총 지급 금액</td>
                    <td class="border p-2" colspan='3' id="tot_give_amt" style="text-align: right;">${salaryDetailsDocVO.totGiveAmt}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 두 번째 묶음 -->
    <div class="w-1/2">
        <table class="table-auto border-collapse border w-full text-center">
            <tbody id="tby">
                <tr class="bg-white">
                    <td class="border p-2 w-1/8 font-bold" style="background-color: #4E7DF4; color: white;">국민연금</td>
                    <td class="border p-2 w-1/8" id="npn">${salaryDetailsDocVO.npn}</td>
                    <td class="border p-2 w-1/8 font-bold" style="background-color: #4E7DF4; color: white;">건강보험 보험료</td>
                    <td class="border p-2 w-1/8" id="hlthins_irncf">${salaryDetailsDocVO.hlthinsIrncf}</td>
                </tr>
                <tr class="bg-white"> 
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">고용보험 보험료</td>
                    <td class="border p-2" id="emplyminsrnc_irncf">${salaryDetailsDocVO.emplyminsrncIrncf}</td>
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">산재보험 보험료</td>
                    <td class="border p-2" id="iaci_irncf">${salaryDetailsDocVO.iaciIrncf}</td>
                </tr>
                <tr class="bg-white"> 
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">근로소득세</td>
                    <td class="border p-2" id="ecmt">${salaryDetailsDocVO.ecmt}</td>
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">지방세</td>
                    <td class="border p-2" id="llx">${salaryDetailsDocVO.llx}</td>
                </tr>
                <tr class="bg-white">
                    <td class="border p-2 font-bold" style="background-color: #4E7DF4; color: white;">총 공제 금액</td>
                    <td colspan='3' class="border p-2" id="tot_ddc_amt" style="text-align: right;">${salaryDetailsDocVO.totDdcAmt}</td>
                    
                </tr>
            </tbody>
        </table>
    </div>
</div>

<div class="card-body table-responsive p-10 pt-1">
      <table class="table-auto border-collapse border w-full text-center">
	      <tbody id="tby" class="bg-gray-50">
	          <tr class="bg-white">
                <td class="border p-2 w-1/2 font-bold" style="background-color: #4E7DF4; color: white;">실제 수령 금액</td>
                <td class="border p-2 w-1/2" id="real_recpt_amt" style="text-align: right;">${salaryDetailsDocVO.realRecptAmt}</td>
            </tr>
	      </tbody>
	  </table>
</div>
</body>
</html>