<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
</style>

<script type="text/javascript">
$(document).ready(function() {
    // .enter 요소에 클릭 이벤트 추가
    $('.enter').on('click', function(e) {
        e.preventDefault();  // 기본 링크 동작을 막음

        // 클릭한 방의 roomId 가져오기
        var roomId = $(this).closest('.relative').find('#roomId').val();
        console.log('roomId: ', roomId);  // roomId 값 확인

        // roomId가 존재하는지 확인
        if (!roomId) {
            console.log('roomId가 없습니다.');
            return;
        }

        // AJAX 요청 보내기
        $.ajax({
            url: '/getRoomUrl',
            type: 'POST',  // 반드시 POST 메서드를 사용
            data: { roomId: roomId },  // roomId를 데이터로 전송
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 추가
            },
            success: function(res) {
                console.log('방 URL 요청 성공, 결과값: ', res);
                var roomUrl = res.data.url;  // 서버에서 받은 방 URL
                window.open(roomUrl, '_blank');
            },
            error: function(xhr) {
                console.log('오류 발생: ' + xhr.status);
            }
        });
    });
});

</script>

<!-- 회의 시작 -->
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
	<div class="w-full flex justify-between items-center mt-1 pl-3">
		<div style="margin-top: 30px; margin-bottom: 10px;">
			<h3 class="text-lg font-semibold text-slate-800">
				<a href="/videoList">화상 회의</a>
			</h3>
			<p class="text-slate-500">언제 어디서나 온라인으로 회의에 참여하세요</p>
		</div>
		
		<button class="text-white font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
				style="background-color:#4E7DF4" type="button" onclick="window.open('/videoRegist', '_blank')"> 회의 생성
		</button>
	</div>
</div>

<div class="relative flex flex-col justify-center overflow-hidden my-10">
	<div class="mx-auto max-w-screen-xl px-3 w-full">
		<div class="grid w-full sm:grid-cols-2 xl:grid-cols-4 gap-6 mb-5">
			<c:set var="roomListLength" value="${fn:length(roomList.data.list)} " />
			<c:set var="num" value="${roomListLength }" />
			<c:set var="count" value="0" />

			<c:forEach var="roomList" items="${roomList.data.list}">
				<c:if test="${count < 12}">
					<div class="relative flex flex-col shadow-md rounded-xl overflow-hidden hover:shadow-lg hover:-translate-y-1 transition-all duration-300 max-w-sm">
						<a href="" class="hover:text-orange-600 absolute z-30 top-2 right-0 mt-2 mr-3" style="height: 250px;">
							<i class="fa-solid fa-circle-info" style="color: #4E7DF4;"></i>
						</a>
						<a href="#" class="enter z-20 absolute h-full w-full top-0 left-0 ">&nbsp;</a>
						<div class="h-auto overflow-hidden bg-white">
							<div class="h-44 overflow-hidden relative flex justify-center items-center">
								<img src="${pageContext.request.contextPath}/resources/images/document/화상회의로고3.png" style="color:#9F9F9F;" class="object-contain max-h-full">
							</div>
						</div>

						<div class="bg-white py-4 px-3">
							<h3 class="text-xs mb-2 font-medium">${roomList.roomTitle}</h3>
							<div class="flex justify-start items-center">
								<p class="text-xs text-gray-400">${roomList.userNickname}</p>
								<p class="text-xs text-gray-400">${roomList.startDate}</p>
								<input type="hidden" id="roomId" value="${roomList.roomId}" />
								<!-- isDefinePasswd 비밀번호 여부 -->
								<div class="relative z-40 flex items-center gap-2">
									<c:if test="${roomList.isDefinePasswd  == true}">
										<i class="fa-solid fa-lock justify-end" style="color: #4E7DF4;margin-left: 60px;"></i>
									</c:if>
									<c:if test="${roomList.isDefinePasswd  == false}">
										<i class="fa-solid fa-lock justify-end" style="color: #9F9F9F;margin-left: 60px;"></i>
									</c:if>
								</div>
							</div>
						</div>
					</div>
					<c:set var="count" value="${count + 1}" />
				</c:if>
			</c:forEach>
		</div>
	</div>
</div>
