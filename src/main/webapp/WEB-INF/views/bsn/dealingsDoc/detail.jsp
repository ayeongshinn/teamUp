<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script src="https://cdn.jsdelivr.net/gh/alpinejs/alpine@2.x.x/dist/alpine.min.js" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>


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

</head>

	<body>
		 
		 <div class="flex justify-center">
    <!-- 좌측에 계약서 검토 화면 (text.jsp) 포함 -->
    <div class="w-4/6 bg-white p-16">
        <%@ include file="text.jsp" %>
    </div>

    <!-- 우측 계약서 상세 내용 및 결재 상태 변경 -->
    <div class="w-4/6 bg-white p-16">
        <h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300">계약서 상세</h2>
        
        <c:if test="${dealingsDocVO != null}">
            <p>서류 제목: ${dealingsDocVO.docTtl}</p>
            <p>작성 일자: ${dealingsDocVO.wrtYmd}</p>
            <p>계약 금액: ${dealingsDocVO.ctrtAmt}</p>
            <p>계약 내용: ${dealingsDocVO.ctrtCn}</p>
            <!-- 기타 계약서 정보 표시 -->
        </c:if>
        
        <!-- 거래처 또는 고객 정보 선택 -->
        <c:choose>
            <c:when test="${radioSelection == 'counterparty'}">
                <h3>거래처 정보</h3>
                <p>거래처명: ${counterPartyVO.cmrcNm}</p>
                <p>대표자명: ${counterPartyVO.rprsvNm}</p>
                <p>전화번호: ${counterPartyVO.rprsTelno}</p>
                <!-- 기타 거래처 정보 -->
            </c:when>
            <c:when test="${radioSelection == 'customer'}">
                <h3>고객 정보</h3>
                <p>고객명: ${customerVO.custNm}</p>
                <p>고객 직업: ${customerVO.custCrNm}</p>
                <p>전화번호: ${customerVO.custTelno}</p>
                <!-- 기타 고객 정보 -->
            </c:when>
        </c:choose>

        <!-- 결재 상태 변경 폼 -->
        <form action="/dealingsDoc/updateApprovalStatus" method="post" id="approvalForm">
            <input type="hidden" name="docNo" value="${dealingsDocVO.docNo}">
            
            <label>결재 상태:</label>
            <select name="approvalStatus" id="approvalStatus">
                <option value="A14-003" <c:if test="${dealingsDocVO.atrzSttusCd == 'A14-003'}">selected</c:if>>결재 대기</option>
                <option value="A14-001" <c:if test="${dealingsDocVO.atrzSttusCd == 'A14-001'}">selected</c:if>>결재 승인</option>
            </select>

            <button type="button" id="updateBtn">결재 상태 변경</button>
        </form>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        // 결재 상태 변경 버튼 클릭 시
        $('#updateBtn').on('click', function() {
            var selectedStatus = $('#approvalStatus').val();
            
            // 결재 승인이 선택되었을 때만 거래처/고객 정보 insert 처리
            if (selectedStatus === 'A14-001') {
                Swal.fire({
                    title: '결재 승인하시겠습니까?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#4E7DF4',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        $('#approvalForm').submit(); // 폼 제출
                    }
                });
            } else {
                $('#approvalForm').submit(); // 폼 제출
            }
        });
    });
</script>
		 
		 
	</body>
	
</html>