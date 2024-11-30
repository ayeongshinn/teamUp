<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://unpkg.com/flowbite@1.4.0/dist/flowbite.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script>
$(document).ready(function() {
    // 메뉴 버튼 클릭 이벤트 - 댓글 또는 대댓글의 메뉴 버튼 클릭 시 작동
    $(document).on('click', '.menu-button', function(event) {
        event.stopPropagation(); // 이벤트 전파 방지

        // 댓글 ID 및 대댓글 ID 가져오기
        var commentId = $(this).attr('data-cmnt-no');
        var replyId = $(this).attr('data-reply-no');

        console.log("commentId =", commentId, "replyId =", replyId); // 댓글 및 대댓글 ID 확인

        // 메뉴 ID 설정 - 댓글과 대댓글의 ID에 따라 다르게 설정
        var menuId = replyId ? "#dropdown-menu-" + commentId + "-" + replyId : "#dropdown-menu-" + commentId;

        // 모든 드롭다운 메뉴를 닫고 선택한 메뉴만 엽니다.
        $('.dropdown-menu').hide();
        $(menuId).toggle();
        console.log("토글된 메뉴:", menuId); // 토글된 메뉴 ID 확인
        
        // 화면 다른 곳 클릭 시 드롭다운 메뉴 닫기
        $(document).on('click', function(event) {
            // 클릭한 요소가 메뉴나 메뉴 버튼이 아니면 메뉴 닫기
            if (!$(event.target).closest('.menu-button, .dropdown-menu').length) {
                $('.dropdown-menu').hide(); // 모든 드롭다운 메뉴 숨기기
            }
        });


        $(document).on("click", "#updateUgReply", function() {
            console.log("수정 버튼 클릭!");
            
            $('.dropdown-menu').hide();

            // 클릭한 버튼으로부터 가장 가까운 댓글 또는 대댓글 요소를 찾습니다.
            var post = $(this).closest(".post");
            var replyId = $(this).attr("data-reply-no"); // 대댓글 ID 가져오기
            var commentId = $(this).attr("data-cmnt-no"); // 댓글 ID 가져오기

            var commentContent;

            if (replyId) {
                // 대댓글인 경우
                console.log("대댓글 선택, replyId:", replyId);
                commentContent = $("span[data-reply-cmnt-no='" + replyId + "']");
            } else {
                // 댓글인 경우
                console.log("댓글 선택, commentId:", commentId);
                commentContent = post.find("span[data-cmnt-no='" + commentId + "']");
            }

            // 댓글 내용을 찾았는지 확인합니다.
            if (commentContent.length > 0) {
                var currentContent = commentContent.text().trim();
                console.log("현재 댓글 내용은:", currentContent);
            } else {
                console.error("댓글 내용을 찾지 못했습니다. commentContent 길이:", commentContent.length);
                return;
            }

            // 기존에 이미 열려 있는 수정 input 창이 있는지 확인하고 제거합니다.
            $(".reply-input-wrapper").remove();

            // 기존 span 요소를 숨깁니다.
            commentContent.hide();

            // 입력 필드를 생성하여 댓글 내용을 수정할 수 있게 합니다.
            var replyInput = $("<div class='reply-input-wrapper'>").append($("#replyInput").clone().removeAttr("id").show());
            replyInput.find("input[name='cmntCn']").val(currentContent);

            // 취소 버튼 동작 추가
            var cancelButton = $('<button type="button">취소</button>')
                .addClass("text-pink-500 font-bold uppercase text-sm px-4 py-2 rounded-full border border-pink-500 hover:bg-pink-500 hover:text-white transition-all duration-150")
                .css({
                    "height": "40px",
                    "white-space": "nowrap",
                    "margin-right": "8px"
                })
                .on("click", function() {
                    replyInput.remove();   // 입력 필드를 삭제하고
                    commentContent.show(); // 기존 댓글 내용을 다시 표시합니다.
                });

            // 등록 버튼 앞에 취소 버튼 추가
            var submitButton = replyInput.find("button").css({
                "padding": "4px 16px",
                "height": "40px",
                "white-space": "nowrap"
            });
            submitButton.before(cancelButton);

            // span 요소 뒤에 입력 필드를 추가합니다.
            commentContent.after(replyInput);

            // 등록 버튼 클릭 시 수정된 댓글 서버로 전송
            submitButton.off("click").on("click", function(event) {
                event.preventDefault(); // 폼 기본 제출 방지
                var updatedComment = replyInput.find("input[name='cmntCn']").val();

                $.ajax({
                    url: '/usedGoods/updateComment', // 서버의 댓글 업데이트 URL
                    type: 'POST',
                    data: {
                        cmntNo: replyId || commentId, // 대댓글 ID가 있으면 사용하고, 없으면 댓글 ID 사용
                        cmntCn: updatedComment
                    },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 설정
                    },
                    success: function(response) {
                        // 성공적으로 업데이트되면 댓글 텍스트를 새 댓글로 바꿔주고, 입력 필드를 숨깁니다.
                        commentContent.text(updatedComment).show();
                        replyInput.remove();
                        console.log("댓글이 성공적으로 업데이트되었습니다.");
                        $('.dropdown-menu').hide();
                    },
                    error: function(xhr, status, error) {
                        console.error("댓글 업데이트 실패:", error);
                    }
                });
            });
        });

		
        

        $(document).on("click", "#deleteUgReply", function() {
            console.log("수정 버튼 클릭!");

            $('.dropdown-menu').hide();

            // 클릭한 버튼으로부터 가장 가까운 댓글 또는 대댓글 요소를 찾습니다.
            var post = $(this).closest(".post");
            var replyId = $(this).attr("data-reply-no"); // 대댓글 ID 가져오기
            var commentId = $(this).attr("data-cmnt-no"); // 댓글 ID 가져오기
            var bbsNo = $("#content").data("bbs-no"); // #content 요소의 data-bbs-no 속성 값 가져오기

            console.log("삭제 -> 대댓글 ID : ", replyId);
            console.log("삭제 -> 댓글 ID : ", commentId);
            console.log("삭제 -> 게시물 번호 : ", bbsNo);

            var cmntNo = replyId ? replyId : commentId;
            var deleteType = replyId ? "대댓글" : "댓글";
            console.log(deleteType + " 삭제 입니다 ! cmnt 확인 : " + cmntNo);

            // SweetAlert confirmation dialog
            Swal.fire({
                title: "댓글을 삭제하시겠습니까?",
                icon: "warning",
                showCancelButton: true,
                confirmButtonText: "삭제",
                cancelButtonText: "취소",
                reverseButtons: true,
                customClass: {
                    confirmButton: 'swal2-confirm',
                    cancelButton: 'swal2-cancel'
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '/usedGoods/deleteComment',
                        type: 'POST',
                        data: {
                            cmntNo: cmntNo,
                            bbsNo: bbsNo
                        },
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function(response) {
                            Swal.fire(
                                "삭제가 완료되었습니다!"
                            );
                            
                            location.reload();
                        },
                        error: function(xhr, status, error) {
                            Swal.fire(
                                "오류",
                                "댓글 삭제 중 오류가 발생했습니다.",
                                "error"
                            );
                            console.error("댓글 삭제 오류:", error);
                        }
                    });
                }
            });
        });

    });
    
    $(document).on('click', '.menu-button', function(event) {
        event.stopPropagation(); // 이벤트 전파 방지

        // 댓글과 대댓글의 데이터를 가져옵니다.
        var commentId = $(this).attr('data-cmnt-no');
        var replyId = $(this).attr('data-reply-no');

        console.log("commentId = $(this).attr('data-cmnt-no') : ", commentId, "replyId = $(this).attr('data-reply-no') : ", replyId); // 아이디 확인

        var menuId = replyId ? "#dropdown-menu-" + commentId + "-" + replyId : "#dropdown-menu-" + commentId;

        // 모든 드롭다운 메뉴를 닫고 선택한 메뉴만 엽니다.
        $('.dropdown-menu').hide();
        $(menuId).toggle();
        console.log("토글된 메뉴:", menuId); // 메뉴 ID 확인
    });

});


function editPost(button) {
    const bbsNo = button.getAttribute("data-bbs-no");
    console.log("bbsNo 값:", bbsNo);  // 확인용
    
    // 백틱을 사용하지 않고 URL을 연결
    window.location.href = "/usedGoods/editGoods?bbsNo=" + bbsNo;
}

function deletePost(button) {
    // data-bbs-no 속성 값을 가져옵니다.
    const bbsNo = button.getAttribute("data-bbs-no");
    console.log("bbsNo : " , bbsNo);
    
    // 삭제 확인 후, AJAX 요청을 통해 삭제 수행
    Swal.fire({
        title: '게시물을 삭제하시겠습니까?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#4E7DF4',
        confirmButtonText: '확인',
        cancelButtonText: '취소',
        reverseButtons: true,
    	}).then((result) => {
    	  if (result.isConfirmed) {
    	    $.ajax({
    	      url: '/usedGoods/deleteUgGoods',
    	      type: 'POST',
    	      data: {
    	        bbsNo: bbsNo
    	      },
    	      beforeSend: function(xhr) {
    	        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 설정
    	      },
    	      success: function(response) {
    	        Swal.fire({
    	          icon: 'success',
    	          title: '게시물이 삭제되었습니다.',
    	        });
    	        // 삭제 후 원하는 동작 (예: 페이지 새로고침)
    	        location.href = "/usedGoods/list";
    	      },
    	      error: function(xhr, status, error) {
    	        Swal.fire({
    	          icon: 'error',
    	          title: '삭제 중 오류가 발생했습니다.',
    	        });
    	        console.error("삭제 오류:", error);
    	      }
    	    });
    	  }
    	});
}

function changeStatus(button) {
    const bbsNo = button.getAttribute("data-bbs-no"); // 게시글 번호 가져오기
    
    console.log("bbsNo : " + bbsNo);

    $.ajax({
        url: "/usedGoods/updateStatus", // 상태 업데이트를 처리하는 서버의 URL
        type: "POST",
        data: { bbsNo: bbsNo },
        beforeSend: function(xhr) {
   	        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 설정
   	    },
        success: function(response) {
            Swal.fire({
                icon: 'success',
                title: '상태가 성공적으로 업데이트되었습니다.',
            });
        },
        error: function(xhr, status, error) {
            Swal.fire({
                icon: 'error',
                title: '상태 업데이트 중 오류가 발생했습니다.',
            });
        }
    });
    
}

$(document).ready(function() {
    // 답글 버튼 클릭 이벤트
    $('body').on('click', '.reply-button', function() {
        console.log("답글 버튼 클릭됨");  // 로그 추가로 클릭 확인
        const $replyForm = $(this).closest('.post').find('.reply-form');
        
        // 답글 버튼 숨기기
        $(this).hide();
        
        // 답글 입력 폼 보이기
        $replyForm.show();
    });
    
    // 취소 버튼 클릭 이벤트
    $('body').on('click', '.cancel-button', function() {
        console.log("취소 버튼 클릭됨");  // 로그 추가로 클릭 확인
        const $replyForm = $(this).closest('.reply-form');
        const $replyButton = $replyForm.closest('.post').find('.reply-button');
        
        // 답글 입력 폼 숨기기
        $replyForm.hide();
        
        // 답글 버튼 다시 보이기
        $replyButton.show();
    });
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
    margin: 0;
    padding: 0;
    background-color: #f9f9f9;
}

#content {
    max-width: 900px;
    margin: auto;
    background: #fff;
    padding: 16px;
    border-radius: 8px;
}

#article-profile {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 16px;
}

#article-profile-image img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    object-fit: cover;
}

#article-profile-left {
    margin-left: 12px;
}

#nickname {
    font-weight: bold;
    font-size: 1rem;
}

#region-name {
    font-size: 0.875rem;
    color: #888;
}

#article-profile-right {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 0.4rem;
}

#temperature-wrap {
    display: flex;
    align-items: center;
    font-weight: bold;
    color: #4E7DF4;
}

.meters {
    width: 100%;
    height: 6px;
    background: #eee;
    border-radius: 3px;
    margin-top: 4px;
    overflow: hidden;
}

.bar {
    height: 100%;
    border-radius: 3px;
    background-color: #4E7DF4;
}

#article-description {
    margin-top: 16px;
}

#article-title {
    font-size: 1.25rem;
    font-weight: bold;
}

#article-category, #article-price, #article-counts {
    font-size: 0.875rem;
    color: #888;
}

#article-price {
    font-size: 1.5rem;
    font-weight: bold;
    color: #333;
}

#article-detail {
    margin-top: 12px;
    line-height: 1.5;
    color: #333;
}

#article-counts {
    margin-top: 8px;
}

.hide {
    position: absolute;
    left: -9999px;
    top: -9999px;
}

.status-icon {
    transition: filter 0.3s ease;
}

.status-icon:hover {
    filter: invert(39%) sepia(58%) saturate(6055%) hue-rotate(178deg) brightness(95%) contrast(96%);
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


.tooltip-btn {
    position: relative;
    display: inline-flex;
    align-items: center;
}

.tooltip-btn .tooltip-text {
    visibility: hidden;
    width: 180px;
    background-color: black;
    color: #fff;
    text-align: center;
    border-radius: 4px;
    padding: 5px;
    position: absolute;
    top: 125%; /* 위에 있던 bottom을 top으로 변경 */
    left: 50%;
    transform: translateX(-50%);
    opacity: 0;
    transition: opacity 0.3s;
    font-size: 12px;
    z-index: 10;
}

.tooltip-btn .tooltip-text::after {
    content: "";
    position: absolute;
    bottom: 100%; /* 아래에 있던 top을 bottom으로 변경 */
    left: 50%;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: black transparent transparent transparent;
}

.tooltip-btn:hover .tooltip-text {
    visibility: visible;
    opacity: 1;
}

.menu-container {
    position: absolute;
    top: 0; /* 댓글 줄과 메뉴의 상단을 맞춥니다 */
    right: 20px; /* 댓글과의 거리를 설정합니다 */
    z-index: 10;
}

.post.parent-comment {
    border-bottom: 1px solid #e0e0e0;
}

.post.reply-comment {
    border-bottom: none;
}

.menu-container {
    position: relative;
    z-index: 10; /* z-index 값을 높여주세요 */
}

.menu-action:hover {
    background-color: #e6f0ff; /* 수정 버튼 hover 효과 */
    cursor: pointer;
}

.menu-action.text-pink-500:hover {
    background-color: #ffe6e6; /* 삭제 버튼 hover 효과 */
}

.menu-container {
    position: absolute; /* 부모 요소 기준으로 위치 설정 */
    top: 10px; /* 부모 요소의 위쪽에서 일정한 거리 */
    right: 10px; /* 오른쪽에 고정 */
    z-index: 1;
}

.post {
    position: relative; /* 자식 요소의 위치를 기준으로 사용 */
    padding: 10px;
    margin-bottom: 10px;
    border-bottom: 1px solid #e0e0e0;
}

.menu-button img {
    width: 16px;
    height: 16px;
    object-fit: contain; /* 이미지 비율을 유지하면서 잘리지 않도록 설정 */
}

.post img {
    width: 30px;
    height: 30px;
    border-radius: 50%; /* 프로필 사진의 경우 둥글게 처리 */
    object-fit: cover;
}

.dropdown-menu {
    position: absolute;
    top: 0; /* 부모 요소의 위쪽에서 일정한 거리 */
    left: 100%; /* 메뉴 버튼의 오른쪽으로 일정한 거리 */
    margin-left: -20px; /* 드롭다운 메뉴 위치 조정 */
    background-color: white;
    border-radius: 8px;
    padding: 5px;
    z-index: 9999;
    box-shadow: none;
    min-width: 80px;
}

.reply-input-wrapper{
	width: 750px;
	margin-top : 20px;
}

input {
	text-indent : 15px;
}


</style>

<%-- <p>${boardVOList}</p> --%>
<%-- <p>${formattedRegDt}</p> --%>
<%-- <p>${empVOList}</p> --%>
<%-- ${commentVOList} --%>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<article id="content" data-bbs-no="${boardVOList.bbsNo}">
<section id="article-images">
    <c:choose>
        <c:when test="${not empty boardVOList.fileDetailVOList && boardVOList.fileDetailVOList.size() == 1}">
            <!-- 이미지가 하나일 경우: 슬라이드 없이 정적 이미지로 표시 -->
            <div class="relative mt-4 overflow-hidden h-56 rounded-lg" style="height:600px;">
                <img src="${boardVOList.fileDetailVOList[0].fileSaveLocate}" class="block w-full h-full object-cover" alt="${boardVOList.fileDetailVOList[0].fileOriginalNm}">
            </div>
        </c:when>
        <c:otherwise>
            <!-- 이미지가 여러 개일 경우: 캐러셀로 표시 -->
            <div id="default-carousel" class="relative mt-4" data-carousel="static">
                <!-- Carousel wrapper -->
                <div class="overflow-hidden relative h-56 rounded-lg"  style="height: 600px;">
                    <!-- Slide N 반복 시작 -->
                    <c:forEach var="fileDetailVO" items="${boardVOList.fileDetailVOList}">
                        <div class="hidden duration-700 ease-in-out" data-carousel-item>
                            <img src="${fileDetailVO.fileSaveLocate}" class="block absolute top-1/2 left-1/2 w-full -translate-x-1/2 -translate-y-1/2" alt="${fileDetailVO.fileOriginalNm}">
                        </div>
                    </c:forEach>
                    <!-- Slide N 반복 끝 -->
                </div>
                
                <!-- Slider indicators -->
                <div class="flex absolute bottom-5 left-1/2 z-30 space-x-3 -translate-x-1/2">
                    <c:forEach var="fileDetailVO" items="${boardVOList.fileDetailVOList}" varStatus="stat">
                        <button type="button" class="w-2 h-2 rounded-full" aria-current="false" aria-label="Slide ${stat.count}" data-carousel-slide-to="${stat.index}"></button>
                    </c:forEach>
                </div>
                
                <!-- Slider controls -->
                <button type="button" class="flex absolute top-0 z-30 justify-center items-center px-4 h-full cursor-pointer group focus:outline-none" data-carousel-prev style="left: -4rem;">
                    <span class="inline-flex justify-center items-center w-8 h-8 rounded-full sm:w-10 sm:h-10">
                        <svg class="w-5 h-5 text-white sm:w-6 sm:h-6 dark:text-gray-800" fill="none" stroke="black" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                        </svg>
                        <span class="hidden">Previous</span>
                    </span>
                </button>
                <button type="button" class="flex absolute top-0 z-30 justify-center items-center px-4 h-full cursor-pointer group focus:outline-none" data-carousel-next style="right: -4rem;">
                    <span class="inline-flex justify-center items-center w-8 h-8 rounded-full sm:w-10 sm:h-10">
                        <svg class="w-5 h-5 text-white sm:w-6 sm:h-6 dark:text-gray-800" fill="none" stroke="black" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                        <span class="hidden">Next</span>
                    </span>
                </button>
            </div>
        </c:otherwise>
    </c:choose>
</section>

    <section id="article-profile">
            <div id="article-profile" style="display: flex; align-items: center; justify-content: space-between; margin-top: 16px;">
                <div style="display: flex; align-items: center;">
                    <div id="article-profile-image">
                        <img src="data:image/png;base64,${empVOList.proflPhoto}" style="width:40px; height:40px;">
                    </div>
                    <div id="article-profile-left" style="margin-left: 12px;">
                        <div id="detailEmpNm" name="empNm" class="font-bold text-sm" >${empVOList.empNm}</div>
                        <div id="detailEmp" class="text-sm" >[${empVOList.deptCd}] ${empVOList.jbttlCd}</div>
                    </div>
                </div>
            </div>
            
			<div class="inline-flex items-center rounded-md">
			  <c:if test="${empVO.empNo == boardVOList.empNo}">
			    <!-- 수정 버튼 -->
			    <button class="tooltip-btn text-slate-800 hover:text-blue-600 p-0 m-0 bg-transparent border-none inline-flex items-center"
			        data-bbs-no="${boardVOList.bbsNo}" onclick="editPost(this)"> 
			        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4" style="margin-right:10px;">
			            <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10" />
			        </svg>
			        <span class="tooltip-text">클릭하여 게시물 내용을 편집하세요</span>
			    </button>
			
			    <!-- 상품 상태 변경 -->
			    <button class="tooltip-btn text-slate-800 hover:text-blue-600 p-0 m-0 bg-transparent border-none inline-flex items-center" 
			        onclick="changeStatus(this)" data-bbs-no="${boardVOList.bbsNo}"
			        onmouseover="this.children[0].src='/resources/images/statusCkBlueB.png'"
			        onmouseout="this.children[0].src='/resources/images/statusCkB.png'">
			        <img src="/resources/images/statusCkB.png" alt="status icon" class="w-3.5 h-3.5" style="margin-right: 10px;">
			        <span class="tooltip-text">클릭하여 상품 상태를 판매 완료로 업데이트하세요</span>
			    </button>
			
			    <!-- 삭제 버튼 -->
			    <button class="tooltip-btn text-slate-800 hover:text-blue-600 p-0 m-0 bg-transparent border-none inline-flex items-center"
			        data-bbs-no="${boardVOList.bbsNo}" onclick="deletePost(this)">
			        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
			            <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
			        </svg>
			        <span class="tooltip-text">클릭하여 게시물을 삭제하세요</span>
			    </button>
			  </c:if>
			</div>

    </section>

        <hr class="mt-3 mb-3">

    <section id="article-description">
        <span property="schema:name" id="article-title" class="mt-1 mb-3 text-lg">${boardVOList.bbsTtl}</span>
        <p id="article-category" class="mt-2">
            ${formattedRegDt}
        </p>
        <p id="article-price" property="schema:price" content="10000.0" class="mt-2" style="font-size : 17px !important;">
        	<fmt:formatNumber value="${boardVOList.price}" pattern="#,###" />원
        </p>
        <div property="schema:description" id="article-detail">
            <p>${boardVOList.bbsCn}</p>
        </div>
      	  <div class="flex items-center mt-2">
		    <div class="text-sm text-gray-600 flex items-center" style="margin-right: 8px;">
		      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#4E5461" class="w-4 h-4 inline-fl">
		        <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z"></path>
		        <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
		      </svg>
		      <span style="margin-left: 4px;">${boardVOList.inqCnt}</span>
		    </div>
		
		    <div class="text-sm text-gray-600 flex items-center">
		      <img src="/resources/images/rrreply.png" alt="Reply Icon" class="w-4 h-4 inline-fl" style="width:12px;height:12px; margin-left: 4px;" />
		      <span style="margin-left: 4px;">${boardVOList.replyCnt}</span>
		    </div>
		    
		    <a href="/usedGoods/list" style="color:#4E7DF4;margin-left:auto;" >더 구경하기</a>
		  </div>
    </section>
    <hr class="mt-4 mb-4">

		<div class="pb-2 text-sm flex justify-between items-center">
			
			<form id="formComment" action="/usedGoods/replyUgBoard?${_csrf.parameterName}=${_csrf.token}"
				method="post" class="form-horizontal d-flex align-items-center">
					<!-- 어떤글에 -->
					<input type="text" name="bbsNo" id="ugBbsNo" value="${boardVOList.bbsNo}"
						hidden />
					<!-- 누가 -->
					<input type="text" name="empNo" id="ugEmpNo" value="${empVO.empNo}"
						hidden />
					<!-- 어떤 내용을 -->
					
					<div id="replyInput" class="pb-2 text-sm flex justify-between items-center">
						<input type="text" name="cmntCn" id="ugCmntCn" style="width:780px; margin-right: 10px; height: 40px;"
							class="form-control form-control-sm border border-indigo-500 rounded-full placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="댓글 입력">
						<button type="submit"
								class="text-indigo-500 font-bold uppercase text-sm px-4 py-2 rounded-full border border-indigo-500 hover:bg-indigo-500 hover:text-white transition-all duration-150" style="height: 40px; white-space: nowrap;">등록</button>
					</div>
				<sec:csrfInput />
			</form>
		</div>
		
<div class="col-12" id="divReplyList">
    <c:forEach var="commentVO" items="${commentVOList}" varStatus="stat">
        <!-- 부모 댓글만 출력 -->
        <c:if test="${commentVO.replyNo == null}">
            <div class="post" id="menudot" style="position: relative; padding: 10px; border-bottom : none;">
                <!-- 댓글 작성자 이미지와 이름 -->
                <div style="display: flex; align-items: center; justify-content: space-between;">
                    <div style="display: flex; align-items: center;">
                        <span>
                            <img src="data:image/png;base64,${commentVO.proflPhoto}" class="img-circle" style="width: 30px; height: 30px; margin: 5px;">
                        </span>
                        <h2 style="margin: 0; margin-left: 5px;">[${commentVO.deptNm}] ${commentVO.nm}</h2>
                    </div>
					
				   <c:if test="${commentVO.empNo == empVO.empNo}">
                    <!-- 메뉴 버튼 (점 세 개) -->
						<div class="menu-container" style="position: relative; display: inline-block; margin-top:10px;">
							<button class="menu-button" data-cmnt-no="${commentVO.cmntNo}" onclick="toggleMenu('${commentVO.cmntNo}')">
							    <img src="/resources/images/menuDot.png" style="width: 16px; height: 16px;">
							</button>
						    
						    <!-- 부모 댓글의 드롭다운 메뉴 -->
						    <div id="dropdown-menu-${commentVO.cmntNo}" class="dropdown-menu" 
						         style="display: none; position: absolute; top: 20px; right: 0; background-color: white; border-radius: 8px; padding: 5px; z-index: 1; box-shadow: none; min-width: 80px;">
								<!-- 수정 버튼 -->
								<button type="button" data-cmnt-no="${commentVO.cmntNo}" id="updateUgReply" class="clsUpdate text-blue-500 font-bold text-sm border-none"
								        style="background-color: white; padding: 3px 5px; display: flex; align-items: center; justify-content: center; width: 100%; transition: background-color 0.3s; border-radius: 4px;"
								        onmouseover="this.style.backgroundColor='#e6f0ff';" onmouseout="this.style.backgroundColor='white';">
								    <i class="fas fa-pencil-alt" style="margin-right: 8px; width:12px;height:12px;"></i> 
								    <span style="font-size: 12px;">수정</span>
								</button>
								
								<!-- 삭제 버튼 -->
								<button type="button" data-cmnt-no="${commentVO.cmntNo}" id="deleteUgReply" class="clsDelete text-pink-500 font-bold text-sm border-none"
								        style="background-color: white; padding: 3px 5px; display: flex; align-items: center; justify-content: center; width: 100%; transition: background-color 0.3s; border-radius: 4px;"
								        onmouseover="this.style.backgroundColor='#ffe6e6';" onmouseout="this.style.backgroundColor='white';">
								    <i class="fas fa-trash" style="margin-right: 8px; width:12px;height:12px;"></i> 
								    <span style="font-size: 12px;">삭제</span>
								</button>
						    </div>
						</div>
                   </c:if>
                </div>

                <!-- 댓글 내용 -->
                <div style="margin-left: 45px; margin-top: 5px;">
                    <div id="replyCn">
                        <span data-cmnt-no="${commentVO.cmntNo}">${commentVO.cmntCn}</span>
                    </div>
                    <!-- 답글 버튼 -->
                    <button type="button" class="reply-button text-blue-500 font-bold text-xs" onclick="$(this).next('.reply-form').toggle();">
                        답글
                    </button>
                </div>

                <!-- 답글 입력 폼 -->
                <div class="reply-form" style="display: none; margin-left: 45px; margin-top: 10px;">
                    <form id="replyForm" action="/usedGoods/replyToComment" method="post" style="display: flex; align-items: center;">
                        <input type="hidden" name="replyNo" value="${commentVO.cmntNo}" />
                        <input type="hidden" name="bbsNo" value="${boardVOList.bbsNo}" />
                        <input type="hidden" name="empNo" value="${empVO.empNo}" />
                        <div style="display: flex; align-items: center;">
                            <span>
                                <img src="data:image/png;base64,${empVO.proflPhoto}" class="img-circle" style="width: 30px; height: 30px; margin: 5px; margin-right:15px;">
                            </span>
                            <input type="text" name="cmntCn" id="replyCmntCn" style="width: 617px; margin-right: 10px; height: 40px;"
                                class="form-control form-control-sm border border-indigo-500 rounded-full placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="댓글 입력">
                            <button type="button" 
                                    class="cancel-button text-pink-500 font-bold uppercase text-sm px-4 py-2 rounded-full border border-pink-500 hover:bg-pink-500 hover:text-white transition-all duration-150" style="height: 40px; white-space: nowrap; margin-right: 8px;">
                                취소
                            </button>      
                            <button type="submit" 
                                    class="text-indigo-500 font-bold uppercase text-sm px-4 py-2 rounded-full border border-indigo-500 hover:bg-indigo-500 hover:text-white transition-all duration-150" style="height: 40px; white-space: nowrap;">
                                등록
                            </button>
                        </div>
                        <sec:csrfInput />
                    </form>
                </div>

                <!-- 해당 댓글의 대댓글 출력 (부모 댓글 스타일과 동일) -->
                <div class="replies" style="margin-left: 45px; margin-top: 10px;">
                    <c:forEach var="replyVO" items="${commentVOList}">
                        <c:if test="${replyVO.replyNo == commentVO.cmntNo}">
                            <div class="post" style="padding: 10px;border-bottom: none;">
                                <div style="display: flex; align-items: center; justify-content: space-between;">
                                    <div style="display: flex; align-items: center;">
                                        <span>
                                            <img src="data:image/png;base64,${replyVO.proflPhoto}" class="img-circle" style="width: 23px; height: 23px; margin: 5px;">
                                        </span>
                                        <h2 style="margin: 0; margin-left: 5px; width:140px;">[${replyVO.deptNm}] ${replyVO.nm}</h2> 
                                         <c:if test="${replyVO.empNo == empVO.empNo}">
						                    <!-- 메뉴 버튼 (점 세 개) -->
										<div class="menu-container ml-8" style="position: relative; display: inline-block; margin-top:10px;margin-left:430px;">
											<button class="menu-button" data-cmnt-no="${commentVO.cmntNo}" data-reply-no="${replyVO.cmntNo}" onclick="toggleMenu('${commentVO.cmntNo}', '${replyVO.cmntNo}')" style="margin-left:160px;margin-top:-3px;">
											    <img src="/resources/images/menuDot.png" style="width: 16px; height: 16px;">
											</button>
										
										    <!-- 드롭다운 메뉴 -->
										    <div id="dropdown-menu-${commentVO.cmntNo}-${replyVO.cmntNo}" class="dropdown-menu" 
										         style="display: none; position: absolute; top: 20px; right: 0; background-color: white; border-radius: 8px; padding: 5px; z-index: 1; box-shadow: none; min-width: 80px;">
												<button type="button" data-reply-no="${replyVO.cmntNo}" data-parent-cmnt-no="${commentVO.cmntNo}" id="updateUgReply" class="clsUpdate text-blue-500 font-bold text-sm border-none"
												        style="background-color: white; padding: 3px 5px; display: flex; align-items: center; justify-content: center; width: 100%; transition: background-color 0.3s; border-radius: 4px;"
												        onmouseover="this.style.backgroundColor='#e6f0ff';" onmouseout="this.style.backgroundColor='white';">
												    <i class="fas fa-pencil-alt" style="margin-right: 8px; width:12px; height:12px;"></i> 
												    <span style="font-size: 12px;">수정</span>
												</button>
										        <button type="button" data-cmnt-no="${commentVO.cmntNo}" id="deleteUgReply" data-reply-no="${replyVO.cmntNo}"
										                class="clsDelete text-pink-500 font-bold text-sm border-none"
										                style="background-color: white; padding: 3px 5px; display: flex; align-items: center; justify-content: center; width: 100%; transition: background-color 0.3s; border-radius: 4px;"
										                onmouseover="this.style.backgroundColor='#ffe6e6';" onmouseout="this.style.backgroundColor='white';">
										            <i class="fas fa-trash" style="margin-right: 8px; width:12px;height:12px;"></i> <span style="font-size : 12px;">삭제</span>
										        </button>
										    </div>
										</div>
									  </c:if>
									  </div> 
                                    </div>
                                </div>
                                <div style="margin-left: 45px; margin-bottom: 5px;">
                                    <div id="rereplyCn" style="margin-top:-15px;margin-left:3px;">
                                        <span data-reply-cmnt-no="${replyVO.cmntNo}">${replyVO.cmntCn}</span>
                                    </div>
                                </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </c:forEach>
</div>
	
</article>


