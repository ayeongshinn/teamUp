<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authorize access="isAuthenticated()">
   <sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>

<script type="text/javascript">

//전역 변수 선언
var socket = null;
let cnt = 1;

// 웹소켓 연결 함수
function connectWs() {
    var ws = new SockJS("/alram");
    socket = ws;
    ws.onopen = function() {
        console.log('WebSocket 연결이 열렸습니다.');
        fetchAndDisplayNotifications();
    };
    ws.onmessage = function(event) {
        if(cnt > 0) {
            console.log("onmessage : " + event.data);
            let [icon, message, url, ntcnNo] = event.data.split(',');
            showPopupNotification(icon, message, url);
            addNotificationToList(icon, message, url, ntcnNo);
            cnt = 0;
        }
        setTimeout(() => { cnt = 1; }, 2000);
    };
    ws.onclose = function() {
        console.log('WebSocket 연결이 닫혔습니다.');
    };
}

// 팝업 알림 표시 함수
function showPopupNotification(icon, message, url) {
    let $socketAlert = $('div#socketAlert');
    if ($socketAlert.length === 0) {
        $socketAlert = $('<div id="socketAlert"></div>');
        $('body').append($socketAlert);
    }
    $socketAlert.html(icon + '&nbsp;' + message).css('display', 'block');
    $socketAlert.off('click').on('click', function() {
        window.location.href = getAbsoluteUrl(url);
    });
    setTimeout(() => { $socketAlert.css('display', 'none'); }, 6000);
}

// 알림을 목록에 추가하는 함수
function addNotificationToList(icon, message, url, ntcnNo, toid) {
    var alramList = $('#alramList');
    alramList.find('a:contains("새로운 알림이 없습니다.")').remove();
    
    $.ajax({
        url: "/approval/getAlramEmpNm",
        contentType: "text/plain; charset=UTF-8",
        data: toid,
        type: "post",
        dataType: "text",
        beforeSend: function(xhr){
            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        },
        success: function(res){
        	var notificationHtml = 
        	    '<a href="' + getAbsoluteUrl(url) + '" class="dropdown-item" data-ntcn-no="' + ntcnNo + '">' +
        	        icon + '&nbsp;' + 
        	        (res ? "<span style='color:#4E7DF4; font-weight:bold;'> " + res + "</span>님으로부터" : "") + 
        	        message + 
        	    '</a>' +
        	    '<div class="dropdown-divider"></div>';
                
            alramList.prepend(notificationHtml);
            updateNotificationCount();
        },
        error: function(xhr, status, error) {
            console.log("Error:", error);
        }
    });
}

// 알림 개수 업데이트 함수
function updateNotificationCount() {
    var count = $('#alramList').children('a').filter(function() {
        return $(this).text() !== '새로운 알림이 없습니다.';
    }).length;
    var badge = $('.badge-warning.navbar-badge');
    count > 0 ? badge.text(count).show() : badge.hide();
}

// 알림 목록을 가져오고 표시하는 함수
function fetchAndDisplayNotifications() {
    $.ajax({
        url: '/cmmn/list', 
        type: 'GET',
        dataType: 'json',
        success: function(notifications) {
            console.log("알림 데이터 응답:", notifications);
            var alramList = $('#alramList');
            alramList.empty();
            if (!notifications || notifications.length === 0) {
                alramList.append('<a href="#" class="dropdown-item text-center">새로운 알림이 없습니다.</a>');
            } else {
                notifications.forEach(function(notification) {
                    addNotificationToList(notification.icon, notification.text, notification.url, notification.ntcnNo, notification.toid);
                });
            }
            updateNotificationCount();
        }
//         error: function(xhr, status, error) {
//             console.error('알림을 가져오는 중 오류 발생:', error);
//             $('#alramList').html('<a href="#" class="dropdown-item text-center text-danger">알림을 가져오는 중 오류가 발생했습니다.</a>');
//             updateNotificationCount();
//         }
    });
}

// 절대 URL을 생성하는 함수
function getAbsoluteUrl(url) {
    // URL이 이미 절대 경로라면 그대로 반환
    if (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('/')) {
        return url;
    }
    // 상대 경로인 경우, 현재 페이지의 경로를 기준으로 절대 경로 생성
    var base = window.location.protocol + "//" + window.location.host + "/";
    return base + url;
}

///////////////////////////////////

// 문서 준비 완료 시 실행되는 함수
$(document).ready(function() {
    console.log('Document ready');
    connectWs();

    // 알림 드롭다운 클릭 이벤트
    $('.nav-item.dropdown').on('show.bs.dropdown', function () {
        console.log('알림 드롭다운이 클릭되었습니다.');
        if (!$(this).data('loaded')) {
            console.log('알림 목록을 처음 불러옵니다.');
            fetchAndDisplayNotifications();
            $(this).data('loaded', true);
            console.log('loaded 상태를 true로 설정했습니다.');
        } else {
            console.log('알림 목록이 이미 로드되어 있습니다.');
        }
    });

    // 알림 목록 클릭 이벤트 핸들러
    $(document).on('click', '#alramList a.dropdown-item', function(e) {
        console.log('알림 항목이 클릭되었습니다.');
        e.preventDefault();
        var $this = $(this);
        var ntcnNo = $this.data('ntcn-no');
        var url = $this.attr('href');
        
        console.log('알림 클릭 이벤트 발생: ntcnNo =', ntcnNo, 'url =', url);

        // 서버에 읽음 상태 업데이트 요청
        $.ajax({
            url: '/cmmn/updateCheck',
            type: 'POST',
            data: { ntcnNo: ntcnNo },
            beforeSend:function(xhr){
                xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            },
            success: function(response) {
                console.log('서버 응답:', response);
                if (response === 'success') {
                    console.log('알림 읽음 상태 업데이트 성공');
                    $this.removeClass('unread').addClass('read');
                    updateNotificationCount();
                    window.location.href = url;
                } else {
                    console.error('알림 읽음 상태 업데이트 실패');
                }
            },
            error: function(xhr, status, error) {
                console.error('알림 상태 업데이트 요청 중 오류 발생:', error);
                console.error('상태 코드:', xhr.status);
                console.error('에러 메시지:', xhr.responseText);
            }
        });
    });

 	// 프로필 이미지 클릭 이벤트 핸들러
    $("#profileImg").on("click", function() {
        // Principal 객체에서 부서 코드와 직책 코드 추출
        let deptCd = "${empVO.deptCd}";  // 부서 코드
        let jbgdCd = "${empVO.jbgdCd}";  // 직책 코드
        
        // AJAX 요청에 사용할 데이터 객체
        let data = {
            "deptCd": deptCd,  // 부서 코드
            "jbgdCd": jbgdCd   // 직책 코드
        };
        
        // 사용자의 부서명 및 직책명을 요청하는 Ajax 호출
        $.ajax({
            url: "/tiles/getDept",  						// 요청할 URL
            contentType: "application/json;charset=utf-8",  // 전송할 데이터 형식
            data: JSON.stringify(data),  					// 데이터를 JSON 문자열로 변환
            type: "post",  									// HTTP 메소드
            dataType: "json",  								// 응답 데이터 형식
            beforeSend: function(xhr) {
                // CSRF 보호를 위한 헤더 설정
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(res) {
                // 직급명이 '부장'일 경우, 직책명을 '팀장'으로 치환 후, text 요소에 출력
                if (res[1].clsfNm == "부장") {
                    $("#profileJbgdCd").text("${empVO.empNm} " + "팀장님");
                    $("#empInfo").text(res[0].clsfNm + " / 팀장");
                } else {
                    $("#profileJbgdCd").text("${empVO.empNm} " + res[1].clsfNm + "님");
                    $("#empInfo").text(res[0].clsfNm + " / " + res[1].clsfNm);
                }
            }
        });
        
        // 사용자의 근태 상태를 요청하는 Ajax 호출
        $.ajax({
            url: "/tiles/getEmpSttus",  					// 요청할 URL
            contentType: "application/json;charset=utf-8",  // 전송할 데이터 형식
            data: JSON.stringify(${empVO.empNo}),  			// 사용자 사원 번호를 JSON 문자열로 변환
            type: "post",  									// HTTP 메소드
            dataType: "json",  								// 응답 데이터 형식
            beforeSend: function(xhr) {
                // CSRF 보호를 위한 헤더 설정
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(res) {
                // 근태 상태를 html 요소에 출력
                $("#empSttus").html("&ensp;" + res.commonCodeVOList[0].clsfNm);
            },
            error: function(xhr) {
                // 사용자의 근태 상태가 insert되지 않았을 경우 '미 출근' 메시지를 출력
                $("#empSttus").html("&ensp;미 출근");
            }
        });
    });
});

</script>

<style>
    .nav-item.dropdown {
        display: flex;
        align-items: center;
    }
    .nav-item.dropdown .nav-link {
        display: flex;
        align-items: center;
    }
    
    div {
    	font-family: "Pretendard-Regular";
    }
    
    #dropdown-container {
	    background-color: #ffffff; /* 밝은 배경색 */
	    border: 1px solid #ddd; /* 부드러운 테두리 */
	    border-radius: 12px; /* 모서리 둥글게 */
	    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15); /* 그림자 추가 */
	    padding: 15px; /* 내부 패딩 */
	    min-width: 220px; /* 최소 너비 지정 */
	    max-width: 300px; /* 최대 너비 지정 */
	    margin-top: 10px; /* 상단 여백 */
	    margin-right: 5px; /* 우측 여백 */
	    z-index: 1050; /* 드롭다운의 우선 순위를 높이기 위해 z-index 설정 */
	}
	
	#dropdown-container .dropdown-header {
	    font-size: 1.2em; /* 제목 폰트 크기 확대 */
	    font-weight: bold; /* 제목 글씨 굵게 */
	    color: #333; /* 제목 글씨 색상 */
	    padding-bottom: 10px; /* 아래쪽 여백 추가 */
	    border-bottom: 1px solid #ddd; /* 제목 아래 구분선 추가 */
	    margin-bottom: 15px; /* 제목과 항목 간의 간격 추가 */
	}
	
	#dropdown-container .dropdown-item {
	    padding: 10px 15px; /* 드롭다운 항목의 패딩 */
	    color: #555; /* 항목 글씨 색상 */
	    cursor: pointer; /* 커서 포인터로 변경 */
	    transition: background-color 0.3s, color 0.3s; /* 배경색과 글씨 색 전환 */
	    border-radius: 8px; /* 항목의 모서리 둥글게 */
	}
	
	#dropdown-container .dropdown-item:hover {
	    background-color: #007bff; /* 호버 시 배경 색상 */
	    color: #ffffff; /* 호버 시 글씨 색상 */
	}
	
	#dropdown-container .dropdown-item + .dropdown-item {
	    margin-top: 8px; /* 각 항목 사이 간격 추가 */
	}
	
  #socketAlert {
    position: fixed; /* 고정된 위치에 표시 */
    bottom: 20px; /* 화면 아래에서 20px 위에 위치 */
    right: 20px; /* 화면 오른쪽에서 20px 왼쪽에 위치 */
    width: 270px;
    height: 75px;
    background-color: rgba(0, 0, 0, 0.35); /* 검정 배경, 투명도 35% */
    color: white;
    border-radius: 12px; /* 둥근 모서리 */
    padding: 20px;
    font-size: 16px;
    text-align: center;
    line-height: 40px; /* 세로 정렬 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 살짝 그림자 */
    display: none; /* 초기에는 숨겨진 상태 */
  }
  
  #aicon {
  color: #828282;
  width: 20px; 
  height: 20px;
  margin-right: 10px; 
}



	/* Dropdown container styles */
#alramListContainer {
    background-color: #F5F5FC;
    border: none;
    border-radius: 12px;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
    padding: 0;
    margin-top: 10px;
    min-width: 250px;          /* 드롭다운 넓이 통일 */
    max-width: 250px;          /* 드롭다운 넓이 통일 */
    overflow: hidden;
    right: 0;                  /* 오른쪽 정렬 */
}

/* Dropdown header styles */
#alramListContainer .dropdown-header {
    background-color: #4E7DF4;
    color: white;
    font-size: 12px;
    font-weight: 400;
    padding: 8px 20px;        /* 패딩 통일 */
    border-radius: 10px 10px 0 0;
    margin-bottom: 0;
    text-align: center;          /* 텍스트 왼쪽 정렬 */
}

/* Dropdown item styles */
#alramList .dropdown-item {
    padding: 12px 15px;        /* 패딩 통일 */
    color: #333;
    font-size: 13px;
    transition: background-color 0.2s ease;
/*     border-bottom: 1px solid #E0E0E0; */
}

#alramList .dropdown-item:last-child {
    border-bottom: none;
}

#alramList .dropdown-item:hover {
    background-color: #EAEAF6;
}

/* Notification icon styles */
.nav-item.dropdown .nav-link {
    display: flex;
    align-items: center;
    padding: 0.5rem 1rem;
}


.badge.badge-warning.navbar-badge {
    position: absolute;
    top: 5px;
    right: 5px;
    font-size: 0.6rem;
    padding: 2px 4px;
    background-color: #FFA500;
    color: white;
    border-radius: 50%;
}

/* Custom scrollbar for dropdown */
#alramList {
    max-height: 300px;
    overflow-y: auto;
}

#alramList::-webkit-scrollbar {
    width: 6px;
}

#alramList::-webkit-scrollbar-track {
    background: #F5F5FC;
}

#alramList::-webkit-scrollbar-thumb {
    background: #4E7DF4;
    border-radius: 3px;
}

#alramList::-webkit-scrollbar-thumb:hover {
    background: #3A63C2;
}
</style>


	
<nav class="main-header navbar navbar-expand navbar-white navbar-light">
	<!-- Left navbar links -->
	<ul class="navbar-nav">
		<li class="nav-item"><a class="nav-link" data-widget="pushmenu"
			href="#" role="button"><i class="fas fa-bars"></i></a></li>
	</ul>
	
	<!-- Right navbar links -->
	<ul class="navbar-nav ml-auto">
	
		<!-- Notifications Dropdown Menu -->
		<li class="nav-item dropdown">
		    <a class="nav-link" data-toggle="dropdown" href="#">
		        <i class="far fa-bell"></i>
		        <span class="badge badge-warning navbar-badge"></span>
		    </a>
		    
		    <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right" id="alramListContainer" style="border-radius: 10px; background-color: #F5F5FC;">
		        <span class="dropdown-item dropdown-header" style="background-color: #4E7DF4; color: white; border-radius: 10px 10px 0 0; font-size: 12px;">NOTIFICATIONS</span>
		        <div class="dropdown-divider"></div>
		        <div id="alramList">
		        
		        </div>
		    </div>
		</li>
		
		<li class="nav-item">
			<a class="nav-link" data-widget="fullscreen" href="#" role="button">
				<i class="fas fa-expand-arrows-alt"></i>
			</a>
		</li>
		
		<li class="nav-item">
			<a class="nav-link" href="/cmmn/myPage/myInfoSecu" role="button">
				<i class="fa-solid fa-user"></i>
			</a>
		</li>
		
<!-- Login Info Dropdown Menu -->
<li class="nav-item dropdown">
    <!-- 시큐리티 계정 관리 시작 -->
    <div style="border-left: 1px solid #D9D9D9 !important;">
        <!-- 스프링 시큐리티 표현식 : 인증 및 권한 정보에 따라 화면을 동적으로 구성할 수 있고, 로그인 한 사용자 정보를 보여줄 수도 있음 -->
        <!-- /// 로그인 전 /// -->
        <sec:authorize access="isAnonymous()">
            <a href="/login" class="nav-link" style="padding: 0px 16px 0px 24px;">
                <img src="/resources/images/tiles/user.png" class="img-circle" style="width: 30px; height: 30px;" alt="user.png">
            </a>
        </sec:authorize>
        <!-- /// 로그인 전 /// -->
    
        <!-- /// 로그인 후 /// -->
        <sec:authorize access="isAuthenticated()">
            <sec:authentication property="principal.employeeVO" var="employeeVO" />
            
            <a class="nav-link" data-toggle="dropdown" href="#" style="padding: 0px 16px 0px 24px;">
                <img src="data:image/png;base64,${empVO.proflPhoto}" class="img-circle" style="width: 30px; height: 30px;" alt="default.gif" id="profileImg">
            </a>
            
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right" style="border-radius: 10px; background-color: #F5F5FC;">
                <span class="dropdown-item dropdown-header" style="background-color: #4E7DF4; color: white; border-radius: 10px 10px 0 0; font-size: 12px;">STATUS</span>
                <div style="display: flex;">
                	<div style="display:flex; align-items: center;">
		                <span>
			                <img src="data:image/png;base64,${empVO.proflPhoto}" class="img-circle" style="width: 60px; height: 60px; display: inline-block; margin: 20px;" alt="default.gif">
		                </span>
                	</div>
                	<div style="display: flex; flex-direction: column; justify-content: center;">
		                <strong id="profileJbgdCd"></strong>
		                <p id="empInfo" style="font-size: 12px; margin-top: 3px;"></p>
                	</div>
                </div>
                <div style="padding: 0px 20px 15px 20px;">
                	<div style="border: 0.1px solid rgba(68, 68, 68, 0.2); border-radius: 20px; background-color: white;">
                		<div style="padding: 5px 15px;">
	                		<i class="fa-solid fa-clock" style="vertical-align: middle; color:#424242;"></i><span id="empSttus"style="font-size: 14px;"></span>
                		</div>
                	</div>
                </div>
                <div class="dropdown-divider"></div>
                <form action="/logout" method="post">
                    <button type="submit" style="font-size: 14px; color: red; margin: 10px 35px;"><i class="fa-solid fa-arrow-right-from-bracket" style="color:red;"></i>&ensp;로그아웃</button>
                    <sec:csrfInput />
                </form>
            </div>
        </sec:authorize>
        <!-- /// 로그인 후 /// -->
    </div>
    <!-- 시큐리티 계정 관리 끝 -->
</li>
	</ul>

</nav>



