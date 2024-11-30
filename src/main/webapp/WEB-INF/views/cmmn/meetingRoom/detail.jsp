<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
 
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>
 
<script type="text/javascript">
$(document).ready(function() {
    // '삭제' 링크를 클릭했을 때
    $('.delBtn').click(function(event) {
    	console.log("버튼 클릭");
        event.preventDefault(); // 링크의 기본 동작 방지

        // rsvtNo 값 가져오기
        let rsvtNo = $(this).data('rsvtNo');
        console.log("삭제할 예약 번호:", rsvtNo);

        // Swal.fire로 삭제 확인 메시지 표시
        Swal.fire({
            title: '예약 정보를 삭제하시겠습니까?',
            icon: 'warning',
            confirmButtonColor: '#4E7DF4',
            showCancelButton: true,
            cancelButtonText: '취소',
            confirmButtonText: '확인',
            reverseButtons: true 
        }).then((result) => {
            if (result.isConfirmed) {
                // Ajax를 사용하여 삭제 요청 보내기
                $.ajax({
                    url: '/meetingRoom/deleteRes',  // 서버의 삭제 요청 URL
                    type: 'POST',                          // POST 방식으로 전송
                    data: { rsvtNo: rsvtNo },              // rsvtNo 파라미터 전송
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
                    },
                    success: function(response) {
                        // 성공 시 처리
                        Swal.fire(
                            '삭제 완료',
                            '예약 정보가 성공적으로 삭제되었습니다.',
                            'success'
                        ).then(() => {
                            location.reload();  // 페이지 새로고침
                        });
                    },
                    error: function(xhr, status, error) {
                        // 실패 시 처리
                        Swal.fire(
                            '삭제 실패',
                            '삭제 중 오류가 발생했습니다.',
                            'error'
                        );
                        console.error(error);
                    }
                });
            }
        });
    });
});

$(document).ready(function() {
	
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 1을 더함
    const day = String(today.getDate()).padStart(2, '0');

    // 요일 배열
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    const weekday = weekdays[today.getDay()]; // 오늘의 요일 구하기

    let todayDate = year+"."+month;
    // 원하는 형식으로 출력: 2024.09.26. (금)
    $('#today').text(todayDate);
    
});
</script>

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
   
   a {
   	   color : #B4B6B8;
   	   text-decoration : none;
   }
   
   a:focus {
   	   color : #B4B6B8;
	   text-decoration : underline;
   }
	
   a:hover {
       color : #B4B6B8;
	   text-decoration : underline;
   }
   
   .swal2-icon { /* 아이콘 */
		font-size: 8px !important;
		width: 40px !important;
		height: 40px !important;
	}
	
	.swal2-styled.swal2-cancel { /* 취소 버튼 스타일 */
		font-size: 14px;
		background-color: #f8f9fa;
		color: black;
		border: 1px solid #D9D9D9;
	}
	
	.swal2-styled.swal2-confirm { /* 확인 버튼 스타일 */
		font-size: 14px;
		margin-left: 10px;
		background-color:#4E7DF4 !important;
		box-shadow:#B1CAE3 !important;
	}
	
	.swal2-title { /* 타이틀 텍스트 사이즈 */
		font-size: 18px !important;
		padding: 2em;
	}
	
	.swal2-container.swal2-center>.swal2-popup {
		padding-top: 30px;
	}
	
	.swal2-text { /* 설명란 텍스트 사이즈 */
		font-size: 0.5rem !important;
	}
	
	div {
	    margin: 0 auto; /* 중앙 정렬 */
	    width: 100%;    /* div가 화면에 맞춰지도록 설정 */
	}
	
	.container {
	    position: absolute;
	    top: 0;
	    left: 0; /* 왼쪽 여백을 제거 */
	    padding-left: 40px;
	}
	
	.swal2-icon-content{
		margin-left : 16px;
	}
	
   
</style>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<div class="container">
  <br>
  <p style="font-weight:bold;">내 예약</p>
  <hr style="width: 785px; margin-top:10px;"> 
  <div style="display: flex; margin-top : -10px;">
  	<span id="today" style="font-weight:bold; margin-top:30px;"></span>  
  	<img src="/resources/images/calendar.png" style="width:17px;height:17px;margin-top:34px;margin-left:8px;"/> 
  </div>
  
  <hr style="width: 785px; margin-top:10px;">            
  <table class="table" style="width: 785px !important; margin-top:-15px;">
    <thead>
      <tr>
        <th style="font-weight:normal;">예약 날짜</th>
        <th style="font-weight:normal;">시간</th>
        <th style="font-weight:normal;">회의실</th>
        <th style="font-weight:normal;">예약 내용</th>
        <th style="font-weight:normal;">예약 관리</th>
      </tr>
    </thead>
		<tbody>
		   <c:forEach var="res" items="${reservations}">
		      <c:choose>
		         <c:when test="${empVO.deptCd == 'A17-003' || res.empNo == empVO.empNo}">
		            <tr>
		               <td>
		                  <fmt:parseDate value="${res.rsvtYmd}" pattern="yyyyMMdd" var="parsedDate" />
		                  <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd.' ('E')'" />
		               </td>
		               <td>${res.rsvtBgngTm} - ${res.rsvtEndTm}</td>
		               <td>
		                  <c:forEach var="room" items="${mrList}">
		                     <c:if test="${res.mtgroomCd == room.clsfCd}">
		                        ${room.clsfNm}
		                     </c:if>
		                  </c:forEach>
		               </td>
		               <td>${res.rsvtCn}</td>
		               <td><a href="#" class="delBtn" data-rsvt-No="${res.rsvtNo}">삭제</a></td>
		            </tr>
		         </c:when>
		      </c:choose>
		   </c:forEach>
		</tbody>
  </table>
</div>


