<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<!-- select2 CSS 추가 -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />

<!-- select2 JavaScript 추가 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>


<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script>
$(document).ready(function() {
    $('#rvsdTm2').select2({
        dropdownAutoWidth: true,
        width: 'resolve',
        dropdownCssClass: 'custom-dropdown' // CSS 클래스 적용
    });
});

$(document).ready(function() {
    // 모달을 처음에 숨김 상태로 설정
    $('#modal').hide();
    
    // 회의실 1의 셀만 별도로 테스트
    $('.timeTable tbody tr:first-child td').off('click').on('click', function() {
        console.log('회의실 1 셀 클릭됨'); // 클릭 이벤트 확인용
    });

    // 500ms 대기 후 이벤트 바인딩
    setTimeout(function() {
        // 테이블 셀 클릭 시 모달을 열고 예약 정보를 설정
        $('.timeTable tbody td').off('click').on('click', function() {
            const time = $(this).data('time'); // data-time 속성 값 가져오기
            const room = $(this).closest('tr').find('td:first').text(); // 해당 회의실 이름 가져오기
            const mtgroomCd = $(this).closest('tr').find('td:first').data('mtgroom-cd'); // 회의실 코드 가져오기
            
            console.log('셀 클릭됨:', room, time,mtgroomCd); // 클릭된 셀의 정보 출력

            if (!time) {
                console.log('time 데이터 없음, 이벤트 무시');
                return;
            }

            // 선택된 시간과 회의실 이름을 모달에 표시
            $('#meetingRoomNm').text(room);
            $('#mtCd').val(mtgroomCd);

            // 시작 시간과 종료 시간 분리
            const [start, end] = time.split('-');
            $('#rvsdTm1').val(start);  // 시작 시간을 input에 설정
            $('#rvsdTm2').val(end);    // 종료 시간을 select에 설정

            // 모달 표시
            $('#modal').show();
        });


        // 닫기 버튼을 클릭하면 모달을 숨김
        $('#close').on('click', function() {
            $('#modal').hide();
        });
    }, 500); // 로드가 완료될 때까지 대기 시간 추가
});

$(document).ready(function() {
	
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 1을 더함
    const day = String(today.getDate()).padStart(2, '0');
    
    // input 태그의 값으로 오늘 날짜 설정
    $('#rvsdYmd').val(year+"-"+month+"-"+day);
    $('#rvsdYmd2').val(year+"-"+month+"-"+day);
    
    
    
    // input 필드를 readonly로 설정 (수정 불가능하게)
    $('#rvsdYmd').attr('readonly', true);
    $('#rvsdYmd2').attr('readonly', true);

});

$(document).ready(function() {
    $('#confirm').on('click', function() {
        let formData = new FormData();
        
        // 모달 필드에서 데이터 수집
        let meetingRoomNm = $('#meetingRoomNm').text(); // 회의실명
        let rsvtYmd = $('#rvsdYmd').val().replace(/-/g, '');  // 날짜 형식 변환
        let rsvtBgngTm = String($('#rvsdTm1').val());  // 시작 시간
        let rsvtEndTm = String($('#rvsdTm2').val());   // 종료 시간
        let rsvtCn = $('#schdlCn').val();  // 예약 내용
        let res = $('#res').val();  // 예약자
        let mtgroomCd = $('#mtCd').val();
        let empNo = $('input[name="empNo"]').val();  // 예약자의 사번

        // 콘솔에 데이터 확인용 출력
        console.log("회의실명:", meetingRoomNm);
        console.log("예약일자:", rsvtYmd);
        console.log("시작 시간:", rsvtBgngTm);
        console.log("종료 시간:", rsvtEndTm);
        console.log("예약 내용:", rsvtCn);
        console.log("예약자:", res);
        console.log("사번:", empNo);
        console.log("회의실 번호 : " , mtgroomCd);

        // FormData에 데이터 추가
        formData.append("rsvtYmd", rsvtYmd);
        formData.append("rsvtBgngTm", rsvtBgngTm);
        formData.append("rsvtEndTm", rsvtEndTm);
        formData.append("empNo", empNo);
        formData.append("mtgroomCd", mtgroomCd);
        formData.append("rsvtCn", rsvtCn);

        // AJAX 요청 설정
        $.ajax({
            url: '/meetingRoom/registMRN',
            processData: false,
            contentType: false,
            data: formData,
            type: 'POST',
            dataType: "text",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                // 모달 닫기 및 초기화
                $('#modal2').hide();
                $('#rvsdCn1').val('');
                $('#schdlCn').val(''); // 예약 내용 초기화

                Swal.fire({
                    icon: 'success',
                    title: '예약이 완료되었습니다.'
                }).then(() => {
                    location.reload(); // 페이지 새로고침
                });
            },
            error: function(xhr, status, error) {
                console.log("xhr.status:", xhr.status);  // 상태 코드 확인
                console.log("xhr.responseText:", xhr.responseText);  // 응답 본문 확인
                
                if (xhr.status === 409) {
                    Swal.fire({
                        icon: 'error',
                        title:  xhr.responseText || '이미 예약된 시간입니다.'
                    });
                } else {
                    console.error("예약 실패:", error);
                    Swal.fire({
                        icon: 'error',
                        title: '예약 중 오류가 발생했습니다.'
                    });
                }
            }
        });

        // 모달 닫기
        $('#modal').hide();
    });
});

$(document).ready(function() {
    const loggedInEmpNo = $('#checkEmpNo').val();

    if (!loggedInEmpNo) {
        console.error("empNo 값이 없습니다.");
        return;
    }

    $.ajax({
        url: '/meetingRoom/getReservations',
        type: 'GET',
        dataType: 'json',
        success: function(reservations) {
            console.log("불러온 예약 정보:", reservations);

            reservations.forEach(function(reservation) {
                console.log("reservation : ", reservation);
                const mtgroomCd = reservation.mtgroomCd;
                const startTime = reservation.rsvtBgngTm;
                const endTime = reservation.rsvtEndTm;
                const empNo = reservation.empNo;
                const rsvtNo = reservation.rsvtNo;
                const empNm = reservation.empNm;
                const deptName = reservation.deptName;
                const rsvtCn = reservation.rsvtCn;
                const rsvtYmd = reservation.rsvtYmd;

                $('tr[data-mtgroom-cd="' + mtgroomCd + '"] td').each(function() {
                    const timeRange = $(this).attr('data-time');
                    if (timeRange) {
                        let [start, end] = timeRange.split('-');
                        if ((startTime < end && endTime > start)) {
                            $(this).attr('data-rsvt-no', rsvtNo);
                            $(this).attr('data-emp-no', empNo);
                            $(this).attr('data-emp-nm', empNm);
                            $(this).attr('data-dept-name', deptName);
                            $(this).attr('data-rsvt-cn', rsvtCn);
                            $(this).attr('data-rsvt-ymd', rsvtYmd);
                            $(this).attr('data-mtgroom-cd', mtgroomCd);
                            $(this).attr('data-rsvt-bgng-tm', startTime);
                            $(this).attr('data-rsvt-end-tm', endTime);
                            
                            // 예약된 셀에 클래스를 추가
                            $(this).addClass(empNo === loggedInEmpNo ? 'my-booked' : 'booked');
                        }
                    }
                });
            });
        },
        error: function(error) {
            console.error("예약 정보를 가져오는데 실패했습니다.", error);
        }
    });
});

$(document).ready(function() {
    // 이벤트 위임 방식으로 클릭 이벤트 설정
    $('.timeTable tbody').on('click', 'td', function() {
        const time = $(this).data('time'); // data-time 속성 값 가져오기
        const room = $(this).closest('tr').find('td:first').text(); // 해당 회의실 이름 가져오기
        const mtgroomCd = $(this).closest('tr').find('td:first').data('mtgroom-cd'); // 회의실 코드 가져오기
        const empName = $(this).data('emp-nm');
        const deptName = $(this).data('dept-name');
        const rsvtNo = $(this).data('rsvt-no');
        const rsvtCn = $(this).data('rsvt-cn');
        
        console.log('셀 클릭됨:', room, time, mtgroomCd); // 클릭된 셀의 정보 출력

        if ($(this).hasClass('booked') || $(this).hasClass('my-booked')) {
            $('#meetingRoomNm').text(room);
            $('#mtCd').val(mtgroomCd);
            $('#rsvtNo').val(rsvtNo);
            
            const [start, end] = time.split('-');
            const today = new Date().toISOString().split('T')[0].replace(/-/g, '.');

            // 시간에 오전/오후 추가
            function formatTimeWithPeriod(time) {
                const [hour, minute] = time.split(':');
                const hourInt = parseInt(hour, 10);
                const period = hourInt < 12 ? '오전' : '오후';
                const formattedHour = hourInt % 12 === 0 ? 12 : hourInt % 12;
                return period + " " + formattedHour + ":" + minute;
            }

            const formattedStart = formatTimeWithPeriod(start);
            const formattedEnd = formatTimeWithPeriod(end);
            
            $('#meetingCn').text(rsvtCn);
            $('#meetingDate').text(today + " " + formattedStart + " - " + formattedEnd);
            $('#meetingrNo').text(room);
            $('#meetingEmp').text("["+deptName+"] "+ empName); // 예약자 이름 설정
            

            $('#modal').hide();
            $('#modal3').show();
        } else if (!time) {
            console.log('time 데이터 없음, 이벤트 무시');
        } else {
            // 예약되지 않은 셀일 경우 다른 모달 열기
            $('#meetingRoomNm').text(room);
            $('#mtCd').val(mtgroomCd);
            const [start, end] = time.split('-');
            $('#rvsdTm1').val(start);
            $('#rvsdTm2').val(end);
            $('#modal').show(); // 예약되지 않은 셀의 경우 modal 표시
        }
    });

    // 모달 닫기 버튼
    $('#infoCancle').on('click', function() {
        $('#modal3').hide();
    });

    $('#close').on('click', function() {
        $('#modal').hide();
    });
});


$(document).ready(function() {
    $('#myRes').on('click', function() {
        console.log("버튼이 클릭되었습니다."); // 클릭 로그 확인
        // 새 팝업 창 열기
        window.open('/meetingRoom/detail', 'popUpWindow', 'height=600,width=868,left=300,top=200,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes');
    });
});

$(document).ready(function() {
	// 예약 버튼 클릭 시 모달 열기
	$("#rsvdBtn").click(function() {
	    $('#modal2').show();  // modal을 표시
	});
	
	$('#close1').click(function(){
		$('#modal2').hide();
	});
});

$(document).ready(function() {
    $('#confirm1').on('click', function() {
        let formData = new FormData();
        
        // 폼 데이터 가져오기
        let meetingRoomCd = $('#meetingRoomCd').val();
        let rvsdYmd2 = $('#rvsdYmd2').val().replace(/-/g, '');
        let rvsdTm3 = $('#rvsdTm3').val();
        let rvsdTm4 = $('#rvsdTm4').val();
        let rvsdCn = $('#rvsdCn1').val();
        let empNo = $('#checkEmpNo').val();
        
        formData.append("rsvtYmd", rvsdYmd2);
        formData.append("rsvtBgngTm", rvsdTm3);
        formData.append("rsvtEndTm", rvsdTm4);
        formData.append("empNo", empNo);
        formData.append("mtgroomCd", meetingRoomCd);
        formData.append("rsvtCn", rvsdCn);

        // Ajax 요청
        $.ajax({
            url: '/meetingRoom/registMRN',
            processData: false,
            contentType: false,
            data: formData,
            type: 'POST',
            dataType: 'json',  // json으로 설정
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                // 성공 처리
            },
            error: function(xhr, status, error) {
                console.log("xhr.status:", xhr.status);  // 상태 코드 확인
                console.log("xhr.responseText:", xhr.responseText);  // 응답 본문 확인
                
                if (xhr.status === 409) {
                    Swal.fire({
                        icon: 'error',
                        title: '중복 예약',
                        text: xhr.responseText || '이미 예약된 시간입니다.'
                    });
                } else {
                    console.error("예약 실패:", error);
                    Swal.fire({
                        icon: 'error',
                        title: '예약 중 오류가 발생했습니다.'
                    });
                }
            }
        });
    });
});


//페이지가 로드된 후 hover 이벤트 추가
$(document).ready(function() {
    // 각 회의실 이미지에 hover 이벤트 추가
    $('img[title="회의실1"]').hover(
        function() { chk("14"); }, // 마우스를 올릴 때 실행
        function() {} // 마우스를 내릴 때 추가 동작을 원할 경우 여기에 추가
    );
    $('img[title="회의실2"]').hover(function() { chk("13"); });
    $('img[title="회의실3"]').hover(function() { chk("10"); });
    $('img[title="회의실4"]').hover(function() { chk("20"); });
    $('img[title="회의실5"]').hover(function() { chk("16"); });
    $('img[title="회의실6"]').hover(function() { chk("21"); });
    $('img[title="회의실7"]').hover(function() { chk("26"); });
    $('img[title="회의실8"]').hover(function() { chk("29"); });
    $('img[title="회의실9"]').hover(function() { chk("03"); });
    $('img[title="회의실10"]').hover(function() { chk("07"); });
});


//페이지가 로드된 후 hover 이벤트 추가
$(document).ready(function() {
    // 매핑된 회의실 코드와 id를 연결하는 객체
    var meetingRoomMap = {
        "03": "A05-009",
        "07": "A05-010",
        "10": "A05-003",
        "13": "A05-002",
        "14": "A05-001",
        "16": "A05-005",
        "20": "A05-004",
        "21": "A05-006",
        "26": "A05-007",
        "29": "A05-008"
    };

    // 각 회의실 이미지에 hover 이벤트 추가
    $('img[title]').hover(
        function() { // 마우스를 올릴 때 실행
            var id = $(this).attr('onclick').match(/'(\d+)'/)[1]; // onclick에서 id 추출
            chk(id);
        },
        function() { // 마우스를 뗄 때 실행
            // 모든 tr 요소의 스타일 초기화
            $('tr[data-mtgroom-cd]').css({
                'border-top': '',
                'border-bottom': '',
                'background-color': ''
            });
        }
    );
});

// chk 함수 정의
function chk(id) {
    console.log("chk 함수 호출됨. ID:", id);

    // 매핑된 회의실 코드 가져오기
    var meetingRoomCode = {
        "03": "A05-009",
        "07": "A05-010",
        "10": "A05-003",
        "13": "A05-002",
        "14": "A05-001",
        "16": "A05-005",
        "20": "A05-004",
        "21": "A05-006",
        "26": "A05-007",
        "29": "A05-008"
    }[id];

    console.log("매핑된 회의실 코드:", meetingRoomCode);

    // 선택한 회의실에 해당하는 tr 요소 찾기
    var $selectedRow = $('tr[data-mtgroom-cd="' + meetingRoomCode + '"]');

    if ($selectedRow.length > 0) {
        console.log("스타일 적용할 tr 요소:", $selectedRow);

        // 강조 스타일 적용
        $selectedRow.css({
            'border-top': '2px solid rgba(78, 125, 244, 0.5)',
            'border-bottom': '2px solid rgba(78, 125, 244, 0.5)'
        });
    } else {
        console.error("매칭되는 회의실 코드가 없습니다.");
    }
}


$(document).ready(function() {
    $('#infoResDel').on('click', function() {
        console.log("삭제 버튼 클릭");
        let rsvtNo = $('#rsvtNo').val(); // modal3에 저장된 data-rsvt-no 값 가져오기
        console.log("삭제 rsvtNo : " + rsvtNo);

        if (!rsvtNo) {
            console.error("rsvtNo 값이 없습니다.");
            Swal.fire({
                icon: 'error',
                title: '예약 정보를 찾을 수 없습니다.'
            });
            return;
        }

        
        
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
                // Ajax 코드 활성화
                $.ajax({
                    url: '/meetingRoom/deleteRes',
                    type: 'POST',
                    data: { rsvtNo: rsvtNo },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        Swal.fire({
                            icon: 'success',
                            title: '예약이 삭제되었습니다.'
                        }).then(() => {
                            $('#modal3').hide();
                            location.reload();
                        });
                    },
                    error: function(xhr, status, error) {
                        console.error("삭제 실패:", error);
                        Swal.fire({
                            icon: 'error',
                            title: '삭제 중 오류가 발생했습니다.'
                        });
                    }
                });
            }
        });
    });
});


</script>

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

#myRes {
	margin-top: 6px;
}

#divImg1 {
	position: absolute;
	width: 90px;
	height: 70px;
	background-color: blue;
	left: 763px;
	top: 377px;
	cursor: pointer;
}

.resp {
	width: 15px;
	height: 15px;
	border: 1px solid #c0c0c0;
	border-radius: 4px;
	display: flex;
	justify-content: left;
	align-items: left;
	top: 0; /* 위에서부터의 거리 */
	left: 300px; /* 왼쪽에서 오른쪽으로 이동 */
	margin-right: 10px;
}

.resv {
	background-color: #dadadb;
	width: 15px;
	height: 15px;
	border: 1px solid #c0c0c0;
	border-radius: 4px;
	display: flex;
	justify-content: left;
	align-items: left;
	top: 0; /* 위에서부터의 거리 */
	left: 300px; /* 왼쪽에서 오른쪽으로 이동 */
	margin-right: 10px;
}

.myres {
	background-color: #b3bef5;
	width: 15px;
	height: 15px;
	border: 1px solid #c0c0c0;
	border-radius: 4px;
	display: flex;
	justify-content: left;
	align-items: left;
	top: 0; /* 위에서부터의 거리 */
	left: 300px; /* 왼쪽에서 오른쪽으로 이동 */
	margin-right: 10px;
}


#confirm {
	background-color: #4E7DF4;
}

#confirm1 {
	background-color: #4E7DF4;
}

#modal2 {
	display: none; /* 페이지가 로드될 때 modal2를 숨김 */
}

#resDel {
	background-color: #4E7DF4;
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

.bg-indigo-500 {
	background-color: #4E7DF4;
}

.timeTable {
	position: relative; /* relative로 위치 지정 */
    z-index: 1; /* 이미지보다 앞에 위치하도록 설정 */
	width: 80%;
	margin: 0 auto; /* 수평 중앙 정렬 */
	border-collapse: collapse;
	margin-top: 20px;
	background-color: white;
	text-align: center;

}

.timeTable thead th, .timeTable tbody td {
	border: 1px solid #ddd;
	padding: 5px;
	text-align: center;
}

.timeTable thead th {
	background-color: white; /* 헤더 부분을 좀 더 강조 */
	color: #333; /* 헤더 텍스트 색상 */
}

.timeTable tbody td.booked {
	background-color: #c0c0c0; /* 예약된 셀의 색상을 이미지와 유사하게 */
}

.timeTable th {
	font-weight: bold;
	font-size: 14px;
}

.timeTable td {
	font-size: 13px;
	color: #333;
	border-right: 1px solid #D9D9D9 !important;
}

.timeTable thead th {
	width: 8% !important;
}

.timeTable tbody td {
	width: 4% !important; /* 반으로 줄어든 너비 */
}

.booked {
    background-color: rgba(180, 182, 184, 0.5); /* 예약된 셀 색상 */
    pointer-events: auto; /* 클릭 이벤트 비활성화 */
}
.my-booked {
    background-color: rgba(78, 125, 244, 0.5); /* 나의 예약 셀 색상 (예: 노란색) */
    pointer-events: auto; /* 클릭 이벤트 비활성화 */
}
#modal3 {
    display: none; /* 기본적으로 모달 숨김 */
}

.tooltip-btn {
    position: relative;
    display: inline-flex;
    align-items: center;
    cursor: pointer; /* 마우스 커서 변경 */
}

.tooltip-btn .tooltiptext {
    visibility: hidden;
    width: 300px; /* 툴팁의 너비를 조정하여 길게 설정 */
    background-color: black;
    color: #fff;
    text-align: center;
    border-radius: 4px;
    padding: 10px; /* 패딩을 늘려서 더 넓게 보이도록 */
    position: absolute;
    top: 125%; /* 아래쪽으로 표시되도록 설정 */
    left: 50%;
    transform: translateX(-50%);
    opacity: 0;
    transition: opacity 0.3s;
    font-size: 12px;
    z-index: 10;
}

.tooltip-btn:hover .tooltiptext {
    visibility: visible; /* 호버 시 가시성을 설정 */
    opacity: 1; /* 호버 시 불투명도를 1로 변경 */
}

.tooltip-btn .tooltiptext::after {
    content: "";
    position: absolute;
    bottom: 100%; /* 툴팁 위쪽에 위치 */
    left: 50%; /* 기본 중앙 위치 */
    margin-left: 9px; /* 화살표를 중앙으로 맞추기 위한 오프셋 */
    border-width: 5px;
    border-style: solid;
    border-color: black transparent transparent transparent; /* 화살표 색상 설정 */
}

.tooltip-btn .tooltiptext::after {
    left: calc(50% - 10px); /* 왼쪽으로 조정하여 물음표와 맞추기 */
}
.highlight-row {
    border-top: 1px solid red !important;
    border-bottom: 1px solid red !important;
}

.select2-container .select2-dropdown .select2-results__options {
    max-height: 150px !important; /* 원하는 높이로 변경 */
    overflow-y: auto !important;  /* 스크롤 활성화 */
}
</style>



<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<input type="hidden" id="checkEmpNo" value="${empVO.empNo}" />
<br>
<br>

<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
	<div class="w-full flex justify-between items-center mb-4 mt-2 pl-3" style="margin-left: 0;">
		<div style="margin-bottom: 10px;">
			<h3 class="text-lg font-semibold text-slate-800">회의실</h3>
			<p class="text-slate-500">회의실을 쉽게 예약하고 팀 회의를 준비하세요</p>

			<br>

			<div
				class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border" >
				<div class="card-body table-responsive p-0">
					<div style="display: flex; align-items: center;">
						<!-- 							<button id="myRes" -->
						<!-- 								class="bg-primary hover:bg-primaryActive text-white text-sm py-2 px-3 mr-2 mb-2 rounded-xl transition duration-300"> -->
						<!-- 								내 예약</button> -->
						<button id="myRes"
							class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
							type="button" style="margin-left: 10px; margin-top: 10px;">
							내 예약</button>
					</div>

					<hr style="margin-top: 10px;">
					<br><br>

					<!-- <div id="divImg1" onclick="javascript:alert('파란색 사각형 선택됨!');"></div> -->

					<div
						style="width: 1201px; height: 600px; display: flex; justify-content: center; align-items: center;">
						<!-- 	<img src="/resources/images/meetingRoom1100.png" alt="회의실 이미지" style="background-color:transparent;display: block;width:1100px;" /> -->
						<!-- Save for Web Slices (meetingRoom1100_2.png) -->
						<table id="__01" width="900" height="347" border="0"
							cellpadding="0" cellspacing="0">
							<tr>
								<td colspan="14"><img
									src="/resources/images/meetingName/meetingRoom_01.png"
									width="1000" height="127" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="127" alt=""></td>
							</tr>
							<tr>
								<td colspan="12" rowspan="2"><img
									src="/resources/images/meetingName/meetingRoom_02.png"
									width="929" height="38" alt=""></td>
								<td><img
									src="/resources/images/meetingName/meetingRoom_03.png"
									width="25" height="21" alt="회의실9" title="회의실9"
									onclick="chk('03')" style="cursor: pointer;"></td>
								<td rowspan="12"><img
									src="/resources/images/meetingName/meetingRoom_04.png"
									width="46" height="219" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="21" alt=""></td>
							</tr>
							<tr>
								<td rowspan="11"><img
									src="/resources/images/meetingName/meetingRoom_05.png"
									width="25" height="198" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="17" alt=""></td>
							</tr>
							<tr>
								<td rowspan="10"><img
									src="/resources/images/meetingName/meetingRoom_06.png"
									width="214" height="181" alt=""></td>
								<td><img
									src="/resources/images/meetingName/meetingRoom_07.png"
									width="19" height="20" alt="회의실10" title="회의실10"
									onclick="chk('07')" style="cursor: pointer;"></td>
								<td colspan="10"><img
									src="/resources/images/meetingName/meetingRoom_08.png"
									width="696" height="20" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="20" alt=""></td>
							</tr>
							<tr>
								<td colspan="2" rowspan="9"><img
									src="/resources/images/meetingName/meetingRoom_09.png"
									width="229" height="161" alt=""></td>
								<td rowspan="2"><img
									src="/resources/images/meetingName/meetingRoom_10.png"
									width="21" height="27" alt="회의실3" title="회의실3"
									onclick="chk('10')" style="cursor: pointer;"></td>
								<td colspan="8"><img
									src="/resources/images/meetingName/meetingRoom_11.png"
									width="465" height="8" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="8" alt=""></td>
							</tr>
							<tr>
								<td rowspan="8"><img
									src="/resources/images/meetingName/meetingRoom_12.png"
									width="9" height="153" alt=""></td>
								<td rowspan="3"><img
									src="/resources/images/meetingName/meetingRoom_13.png"
									width="27" height="46" alt="회의실2" title="회의실2"
									onclick="chk('13')" style="cursor: pointer;"></td>
								<td rowspan="3"><img
									src="/resources/images/meetingName/meetingRoom_14.png"
									width="69" height="46" alt="회의실1" title="회의실1"
									onclick="chk('14')" style="cursor: pointer;"></td>
								<td rowspan="8"><img
									src="/resources/images/meetingName/meetingRoom_15.png"
									width="10" height="153" alt=""></td>
								<td><img
									src="/resources/images/meetingName/meetingRoom_16.png"
									width="21" height="19" alt="회의실5" title="회의실5"
									onclick="chk('16')" style="cursor: pointer;"></td>
								<td colspan="3" rowspan="4"><img
									src="/resources/images/meetingName/meetingRoom_17.png"
									width="329" height="64" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="19" alt=""></td>
							</tr>
							<tr>
								<td><img
									src="/resources/images/meetingName/meetingRoom_18.png"
									width="21" height="7" alt=""></td>
								<td><img
									src="/resources/images/meetingName/meetingRoom_19.png"
									width="21" height="7" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="7" alt=""></td>
							</tr>
							<tr>
								<td><img
									src="/resources/images/meetingName/meetingRoom_20.png"
									width="21" height="20" alt="회의실4" title="회의실4"
									onclick="chk('20')" style="cursor: pointer;"></td>
								<td><img
									src="/resources/images/meetingName/meetingRoom_21.png"
									width="21" height="20" alt="회의실6" title="회의실6"
									onclick="chk('21')" style="cursor: pointer;"></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="20" alt=""></td>
							</tr>
							<tr>
								<td rowspan="5"><img
									src="/resources/images/meetingName/meetingRoom_22.png"
									width="21" height="107" alt=""></td>
								<td colspan="2" rowspan="5"><img
									src="/resources/images/meetingName/meetingRoom_23.png"
									width="96" height="107" alt=""></td>
								<td rowspan="5"><img
									src="/resources/images/meetingName/meetingRoom_24.png"
									width="21" height="107" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="18" alt=""></td>
							</tr>
							<tr>
								<td rowspan="4"><img
									src="/resources/images/meetingName/meetingRoom_25.png"
									width="16" height="89" alt=""></td>
								<td><img
									src="/resources/images/meetingName/meetingRoom_26.png"
									width="21" height="23" alt="회의실7" title="회의실7"
									onclick="chk('26')" style="cursor: pointer;"></td>
								<td rowspan="4"><img
									src="/resources/images/meetingName/meetingRoom_27.png"
									width="292" height="89" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="23" alt=""></td>
							</tr>
							<tr>
								<td><img
									src="/resources/images/meetingName/meetingRoom_28.png"
									width="21" height="7" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="7" alt=""></td>
							</tr>
							<tr>
								<td><img
									src="/resources/images/meetingName/meetingRoom_29.png"
									width="21" height="24" alt="회의실8" title="회의실8"
									onclick="chk('29')" style="cursor: pointer;"></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="24" alt=""></td>
							</tr>
							<tr>
								<td><img
									src="/resources/images/meetingName/meetingRoom_30.png"
									width="21" height="35" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="1" height="35" alt=""></td>
							</tr>
							<tr>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="214" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="19" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="210" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="21" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="9" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="27" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="69" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="10" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="21" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="16" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="21" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="292" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="25" height="1" alt=""></td>
								<td><img
									src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif"
									width="46" height="1" alt=""></td>
								<td></td>
							</tr>
						</table>

						<!-- End Save for Web Slices -->

					</div>
					<!-- usemap="#meetingRoomMap" -->
					<!-- <map name="meetingRoomMap" id="meetingRoomMap"> -->
					<!-- 사각형 영역 정의   916 - 832 = width / 469 - 404 = height -->
					<!--     <area shape="rect" coords="832,404,916,469" alt="파란색 사각형" href="#" onclick="javascript:alert('파란색 사각형 선택됨!');"> -->
					<!--     <area shape="rect" coords="0,0,1000,346" alt="파란색 사각형" href="#" onclick="javascript:alert('파란색 사각형 선택됨!');"> -->
					<!-- </map> -->



					<div
						style="display: flex; justify-content: space-between; margin-top: -200px;">
						<div style="display: flex; align-items: center;">
						    <div id="currentdate" style="font-size: 18px; font-weight: bold; margin-left: 120px; margin-right: 5px;"></div>
						    <img src="/resources/images/calendar.png" style="width: 20px; height: 20px; margin-top: -1px;" />
						        <div class="tooltip-btn">
							        <img src="/resources/images/Q.png" style="width: 19px; height: 18px; margin-top: -1px; opacity: 0.7; margin-left: 10px !important;" />
							        <span class="tooltiptext">등록 시간 이외에는 자유롭게 활용하실 수 있습니다.</span>
							    </div>
						</div>

						<!-- 							<button id="rsvdBtn" -->
						<!-- 								class="bg-primary hover:bg-primaryActive text-white text-sm py-2 px-3 mr-2 mb-2 rounded-xl transition duration-300" -->
						<!-- 								style="margin-top: -6px; margin-left: 690px !important;">예약</button> -->

						<div style="display: flex; align-items: center; margin-right:90px; margin-left:-40px;">
						    <button id="rsvdBtn"
						        class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-2 ease-linear transition-all duration-150"
						        type="button"
						        style="margin-left: 100px !important; margin-top: -6px; margin-right:50px;">
						        예약
						    </button>
						
						    <div id="ressts" style="display: flex; margin-right: 13px; margin-left:10px;">
						        <div style="display: flex; align-items: center; margin-right: 6px;"> <!-- 묶음 시작 -->
						            <div class="resp" style="margin-right: 2px;"></div>
						            <span style="margin-top: -2px;margin-left:5px !important;">예약 가능</span>
						        </div> <!-- 묶음 끝 -->
						        <div style="display: flex; align-items: center; margin-right: 6px;"> <!-- 묶음 시작 -->
						            <div class="resv" style="margin-right: 2px;"></div>
						            <span style="margin-top: -2px;margin-left:5px !important;">예약 중</span>
						        </div> <!-- 묶음 끝 -->
						        <div style="display: flex; align-items: center;"> <!-- 묶음 시작 -->
						            <div class="myres" style="margin-right: 2px;"></div>
						            <span style="margin-top: -2px;margin-left:5px !important; margin-right:20px;">내 예약</span>
						        </div> <!-- 묶음 끝 -->
						    </div>
						</div>
					</div>


					<!-- 여기야 여기 -->

					<table class="timeTable">
						<thead>
							<tr>
								<th></th>
								<th colspan="2">8</th>
								<th colspan="2">9</th>
								<th colspan="2">10</th>
								<th colspan="2">11</th>
								<th colspan="2">12</th>
								<th colspan="2">13</th>
								<th colspan="2">14</th>
								<th colspan="2">15</th>
								<th colspan="2">16</th>
								<th colspan="2">17</th>
								<th colspan="2">18</th>
							</tr>
						</thead>
						<tbody>
							<tr data-mtgroom-cd="A05-001">
								<td data-mtgroom-cd="A05-001">회의실1</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr data-mtgroom-cd="A05-002">
								<td data-mtgroom-cd="A05-002">회의실2</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr data-mtgroom-cd="A05-003">
								<td data-mtgroom-cd="A05-003">회의실3</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr data-mtgroom-cd="A05-004">
								<td data-mtgroom-cd="A05-004">회의실4</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr  data-mtgroom-cd="A05-005">
								<td  data-mtgroom-cd="A05-005">회의실5</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr  data-mtgroom-cd="A05-006">
								<td  data-mtgroom-cd="A05-006">회의실6</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr data-mtgroom-cd="A05-007">
								<td data-mtgroom-cd="A05-007">회의실7</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr data-mtgroom-cd="A05-008">
								<td data-mtgroom-cd="A05-008">회의실8</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr data-mtgroom-cd="A05-009">
								<td data-mtgroom-cd="A05-009">회의실9</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
							<tr data-mtgroom-cd="A05-010">
								<td data-mtgroom-cd="A05-010">회의실10</td>
								<td data-time="08:00-08:30"></td>
								<td data-time="08:30-09:00"></td>
								<td data-time="09:00-09:30"></td>
								<td data-time="09:30-10:00"></td>
								<td data-time="10:00-10:30"></td>
								<td data-time="10:30-11:00"></td>
								<td data-time="11:00-11:30"></td>
								<td data-time="11:30-12:00"></td>
								<td data-time="12:00-12:30"></td>
								<td data-time="12:30-13:00"></td>
								<td data-time="13:00-13:30"></td>
								<td data-time="13:30-14:00"></td>
								<td data-time="14:00-14:30"></td>
								<td data-time="14:30-15:00"></td>
								<td data-time="15:00-15:30"></td>
								<td data-time="15:30-16:00"></td>
								<td data-time="16:00-16:30"></td>
								<td data-time="16:30-17:00"></td>
								<td data-time="17:00-17:30"></td>
								<td data-time="17:30-18:00"></td>
								<td data-time="18:00-18:30"></td>
								<td data-time="18:30-19:00"></td>
							</tr>
						</tbody>
					</table>
					<br>
					<br>
				</div>

			</div>
		</div>
	</div>
</div>


<!-- 해당 회의실-시간 클릭 시 등장하는 모달 id="modal" -->
<div class="relative z-10" id="modal" aria-labelledby="modal-title"
	role="dialog" aria-modal="true">
	<div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
		aria-hidden="true"></div>

	<div class="fixed inset-0 z-10 w-screen overflow-y-auto">
		<div
			class="flex min-h-full items-center justify-center p-4 text-center">
			<div
				class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:max-w-2xl sm:w-full">

				<div class="bg-white px-4 pb-4 pt-4 sm:p-6">
					<span class="ml-1 text-lg font-bold mb-3 block">회의실 예약</span>
					<hr class="px-4 py-2">
					<table style="width: 100%;">
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="meetingRoomNm"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">회의실명</label></td>
							<td>
								<div id="meetingRoomNm"
									style="margin-left: 50px; margin-top: -5px;"></div>
							</td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="rvsdYmd"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">일시</label></td>
							<td>
								<div class="flex items-center space-x-2">
									<input type="hidden" id="mtCd" />
									<input type="date"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5"
										name="rvsdYmd" id="rvsdYmd" style="margin-left: 50px;"
										required readonly> <input type="time"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-1/4 p-2.5"
										name="rvsdTm1" id="rvsdTm1" required> <span
										class="mx-2" style="margin-left: 12px !important;">-</span> <select id="rvsdTm2" name="rvsdTm2" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-1/4 p-2.5">
									    <option value="08:30">오전 08:30</option>
									    <option value="09:00">오전 09:00</option>
									    <option value="09:30">오전 09:30</option>
									    <option value="10:00">오전 10:00</option>
									    <option value="10:30">오전 10:30</option>
									    <option value="11:00">오전 11:00</option>
									    <option value="11:30">오전 11:30</option>
									    <option value="12:00">오후 12:00</option>
									    <option value="12:30">오후 12:30</option>
									    <option value="13:00">오후 01:00</option>
									    <option value="13:30">오후 01:30</option>
									    <option value="14:00">오후 02:00</option>
									    <option value="14:30">오후 02:30</option>
									    <option value="15:00">오후 03:00</option>
									    <option value="15:30">오후 03:30</option>
									    <option value="16:00">오후 04:00</option>
									    <option value="16:30">오후 04:30</option>
									    <option value="17:00">오후 05:00</option>
									    <option value="17:30">오후 05:30</option>
									    <option value="18:00">오후 06:00</option>
									</select>
							</td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="rvsdCn"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">내용</label></td>
							<td><input type="text"
								class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-100 p-2.5"
								name="rvsdCn" id="schdlCn" placeholder="예약 내용을 입력하세요."
								style="margin-left: 50px; width: 390px !important;"></td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="res"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">예약자</label></td>
							<td><c:set var="resValue" value="${empVO.empNm}" /> <c:forEach
									var='dept' items='${deptList}'>
									<c:if test='${dept.clsfCd == empVO.deptCd}'>
										<c:set var="resValue" value="[${dept.clsfNm}] ${empVO.empNm}" />
									</c:if>
								</c:forEach>

								<div class="flex items-center">
									<input type="hidden" name="empNo" id="empNo"
										value="${empVO.empNo}" /> <input type="text"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5"
										name="res" id="res" required value="${resValue}"
										style="margin-left: 50px;" />
								</div></td>
						</tr>
					</table>
					<div id="mapImg" style="display: none;"></div>
				</div>

				<div class="bg-gray-50 px-4 py-3 flex justify-center space-x-4">
					<button type="button" id="close"
						class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">취소</button>
					<button type="button" id="confirm"
						class="inline-flex justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">예약</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 모달 끝 -->

<!-- 회의실 예약 눌렀을 때 모달 id="modal2" -->
<div class="relative z-10" id="modal2" aria-labelledby="modal-title"
	role="dialog" aria-modal="true">
	<div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
		aria-hidden="true"></div>

	<div class="fixed inset-0 z-10 w-screen overflow-y-auto">
		<div
			class="flex min-h-full items-center justify-center p-4 text-center">
			<div
				class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:max-w-2xl sm:w-full">

				<div class="bg-white px-4 pb-4 pt-4 sm:p-6">
					<span class="ml-1 text-lg font-bold mb-3 block">회의실 예약</span>
					<hr class="px-4 py-2">
					<table style="width: 100%;">
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="meetingRoomNm2"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">회의실명</label></td>
							<td>
								<div id="meetingRoomNm2"
									style="margin-left: 50px; margin-top: -5px;">
									<select class="form-control col-8" id="meetingRoomCd">
										<option value="">회의실을 선택하세요</option>
										<c:forEach var="meetingRoom" items="${mrList}">
											<option value="${meetingRoom.clsfCd}">${meetingRoom.clsfNm}</option>
										</c:forEach>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="rvsdYmd2"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">일시</label></td>
							<td>
								<div class="flex items-center space-x-2">
									<input type="date"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2"
										name="rvsdYmd2" id="rvsdYmd2" style="margin-left: 50px;"
										required readonly> <select id="rvsdTm3" name="rvsdTm3"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-1/4 p-2.5"
										style="width: 120px; height: 40px">
										<option value="08:00">오전 08:00</option>
										<option value="09:00">오전 09:00</option>
										<option value="10:00">오전 10:00</option>
										<option value="11:00">오전 11:00</option>
										<option value="12:00">오후 12:00</option>
										<option value="13:00">오후 01:00</option>
										<option value="14:00">오후 02:00</option>
										<option value="15:00">오후 03:00</option>
										<option value="16:00">오후 04:00</option>
										<option value="17:00">오후 05:00</option>
										<option value="18:00">오후 06:00</option>
									</select> <span class="mx-2" style="margin-left: 12px !important;">-</span>

									<select id="rvsdTm4" name="rvsdTm4"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-1/4 p-2.5"
										style="width: 120px; height: 40px;">
										<option value="08:00">오전 08:00</option>
										<option value="09:00">오전 09:00</option>
										<option value="10:00">오전 10:00</option>
										<option value="11:00">오전 11:00</option>
										<option value="12:00">오후 12:00</option>
										<option value="13:00">오후 01:00</option>
										<option value="14:00">오후 02:00</option>
										<option value="15:00">오후 03:00</option>
										<option value="16:00">오후 04:00</option>
										<option value="17:00">오후 05:00</option>
										<option value="18:00">오후 06:00</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="rvsdCn"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">내용</label></td>
							<td><input type="text"
								class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-100 p-2.5"
								name="rvsdCn" id="rvsdCn1" placeholder="예약 내용을 입력하세요."
								style="margin-left: 50px; width: 390px !important;"></td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="res"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">예약자</label></td>
							<td><c:set var="resValue" value="${empVO.empNm}" /> <c:forEach
									var='dept' items='${deptList}'>
									<c:if test='${dept.clsfCd == empVO.deptCd}'>
										<c:set var="resValue" value="[${dept.clsfNm}] ${empVO.empNm}" />
									</c:if>
								</c:forEach>

								<div class="flex items-center">
									<input type="hidden" name="empNo" id="empNo"
										value="${empVO.empNo}" /> <input type="text"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5"
										name="res" id="res" required value="${resValue}"
										style="margin-left: 50px;" />
								</div></td>
						</tr>
					</table>
					<div id="mapImg" style="display: none;"></div>
				</div>

				<div class="bg-gray-50 px-4 py-3 flex justify-center space-x-4">
					<button type="button" id="close1"
						class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">취소</button>
					<button type="button" id="confirm1"
						class="inline-flex justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">예약</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 모달 끝 -->

<!-- onClick 모달 id="modal3" -->
<div class="relative z-10" id="modal3" aria-labelledby="modal-title"
	role="dialog" aria-modal="true">
	<div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
		aria-hidden="true"></div>

	<div class="fixed inset-0 z-10 w-screen overflow-y-auto">
		<div
			class="flex min-h-full items-center justify-center p-4 text-center">
			<div
			    class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:w-full"
			    style="max-width: 600px;">

				<div class="bg-white px-4 pb-4 pt-4 sm:p-6">
					<div style="display: flex;">
						<img src="/resources/images/resicon.png" alt="mricon"
							style="width: 20px; height: 20px; margin-right: 10px; margin-bottom:10px;" />
						<div id="meetingCn" class="ml-1 text-lg font-bold mb-3 block" style="margin-top:-3px;">
						</div>
					</div>
					<table style="width: 100%;">
						<input type="hidden" id="rsvtNo" value="" />
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="meetingDate"
								class="text-base font-semibold leading-6 text-gray-900 mt-2"
								id="modal-title">일시</label></td>
							<td>
								<div id="meetingDate" class="flex items-center space-x-2"></div>
							</td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="meetingrNo"
								class="text-base font-semibold leading-6 text-gray-900 mt-2"
								id="modal-title">장소</label></td>
							<td>
								<div id="meetingrNo" class="flex items-center"></div>
							</td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="meetingEmp"
								class="text-base font-semibold leading-6 text-gray-900 mt-2"
								id="modal-title">예약자</label></td>
							<td>
								<div id="meetingEmp" class="flex items-center"></div>
							</td>
						</tr>
					</table>
					<div id="mapImg" style="display: none;"></div>
				</div>

				<div class="bg-gray-50 px-4 py-3 flex justify-center space-x-4">
					<button type="button" id="infoCancle"
						class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">취소</button>
					<button type="button" id="infoResDel" style="background-color:#4E7DF4"
						class="inline-flex justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">삭제</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 모달 끝 -->




<script>
	$(document).ready(
			function() {
				// JavaScript Date 객체 생성 (오늘 날짜)
				const today = new Date();

				// 연, 월, 일을 추출
				const year = today.getFullYear();
				const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 1을 더함
				const day = String(today.getDate()).padStart(2, '0');

				// 요일 배열 설정
				const daysOfWeek = [ '일', '월', '화', '수', '목', '금', '토' ];
				const currentDayOfWeek = daysOfWeek[today.getDay()]; // 요일 추출

				// 콘솔에 출력
				console.log("year", year);
				console.log("month", month);
				console.log("day", day);
				console.log("currentDayOfWeek", currentDayOfWeek);

				// 화면에 표시
				$('#currentdate').text(
						year + "." + month + "." + day + " " + "("
								+ currentDayOfWeek + ")");
			});
</script>