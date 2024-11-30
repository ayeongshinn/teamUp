<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<link rel="stylesheet" href="/resources/css/aside.css">

<!-- DayPilot 라이브러리 추가 -->
<script src="/resources/js/daypilot-all.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/riva-dashboard-tailwind/riva-dashboard.css">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<!-- jQuery 먼저 로드 -->
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery.rwdImageMaps/1.6/jquery.rwdImageMaps.min.js"></script>


<script>

$(document).ready(function() {

    let modal = $('#modal');
    let modal2 = $('#modal2');
    let modal3 = $('#modal3');
    
    // 모달을 처음에는 숨김 상태로 설정
    modal.hide();
    modal2.hide();
    modal3.hide();
    
    // 선택한 회의실을 전역 변수로 저장
    let selectedRoomId = null;

    function chk(no) {
        console.log("no : " + no);

        // 리소스 ID와 회의실 번호 매칭 (예시로 작성)
        const roomMap = {
            "03": "A05-009", // 회의실 9
            "07": "A05-010", // 회의실 10
            "10": "A05-003", // 회의실 3
            "13": "A05-002", // 회의실 2
            "14": "A05-001", // 회의실 1
            "16": "A05-005", // 회의실 5
            "20": "A05-004", // 회의실 4
            "21": "A05-006", // 회의실 6
            "26": "A05-007", // 회의실 7
            "29": "A05-008"  // 회의실 8
        };

        // 선택된 회의실 ID 저장
        selectedRoomId = roomMap[no];

        // DayPilot Scheduler 업데이트 (셀 스타일 반영을 위해)
        dp.update();
    }
    
    setTimeout(function() {
        // DayPilot.Date.today()로 현재 날짜를 사용하여 시작 시간과 종료 시간을 설정
        
        let dp = new DayPilot.Scheduler("dp", {
            startDate: DayPilot.Date.today(),
            days: 1,
            scale: "Hour",
            cellDuration: 30,
            treeEnabled: true,
            cellHeight: 40,
            eventHeight: 30,
            headerHeight: 50,
            theme: "scheduler_custom",
            // 시간 범위 설정
            timeline: [
                { start: DayPilot.Date.today().addHours(8), end: DayPilot.Date.today().addHours(22) }  // 8시부터 22시까지만 표시
            ],
            locale: "en-gb",
            
            resources: [
                {name: "회의실1", id: "A05-001"},
                {name: "회의실2", id: "A05-002"},
                {name: "회의실3", id: "A05-003"},
                {name: "회의실4", id: "A05-004"},
                {name: "회의실5", id: "A05-005"},
                {name: "회의실6", id: "A05-006"},
                {name: "회의실7", id: "A05-007"},
                {name: "회의실8", id: "A05-008"},
                {name: "회의실9", id: "A05-009"},
                {name: "회의실10", id: "A05-010"}
            ],
            
            
            separators: [
                {color: "red", location: DayPilot.Date.today()}
            ],
            
            // 이벤트 클릭 시 실행
            onEventClick: function(args) {
                const eventData = args.e.data;
        		
                let meetingDate = eventData.data.rsvtYmd.slice(0,4) + '.' + eventData.data.rsvtYmd.slice(4,6) + '.' + eventData.data.rsvtYmd.slice(6,8);

                // 시간을 숫자로 변환하여 오전/오후 구분
                let bgngHour = parseInt(eventData.data.rsvtBgngTm.slice(0, 2), 10); // 시작 시간
                let endHour = parseInt(eventData.data.rsvtEndTm.slice(0, 2), 10); // 종료 시간
				
                console.log("시간/숫자 -> " + bgngHour);
                console.log("시간/숫자 -> " + endHour);
                
                // 시작 시간에 "오전" 또는 "오후" 붙이기
                let bgngAmpm = bgngHour < 12 ? "오전" : "오후";
                console.log("뭘까나 -> " + bgngAmpm);

                // 종료 시간에 "오전" 또는 "오후" 붙이기
                let endAmpm = endHour < 12 ? "오전" : "오후";
                console.log("뭘까나 -> " + endAmpm);

                
                $('#meetingCn').text(eventData.data.rsvtCn); 
              	//회의실1 - 회의
                $('#meetingDate').text(meetingDate + " " + bgngAmpm + " " + eventData.data.rsvtBgngTm + " - " + endAmpm + " " + eventData.data.rsvtEndTm);
                //2024.09.24 13:00 - 14:00 
                $('#meetingrNo').text(eventData.text);
                //회의실1 - 회의
                
                let rsvtNo = eventData.id;
                console.log("rsvtNo" + rsvtNo);
                
                $('#rsvtNo').val(eventData.id);
                
                //debugger;
                
                 let empNo = eventData.data.emp;
                
                 $.ajax({
               	    url: '/meetingRoom/empSelect', // 서버로 보낼 API 경로
               	    type: 'POST',
               	    data: { empNo: empNo }, // 사원 번호를 데이터로 전송
               	    dataType: "json", // 서버로부터 JSON 응답을 받음
               	    beforeSend: function(xhr) {
               	        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 설정
               	    },
               	    success: function(response) {
               	        // 서버에서 받은 응답 데이터를 사용하여 화면에 출력
               	        $('#meetingEmp').text("[" + response.deptCd + "] " + response.empNm);
               	    },
               	    error: function() {
               	        console.error('사원 정보를 가져오는 데 실패했습니다.');
               	    }
               	});
                

                // 모달 열기
                modal3.show();
                
                // 삭제 버튼 핸들러 추가
                $('#resDel').click(function(event) {
                    event.preventDefault();

                    console.log("삭제 버튼 클릭");
                    
                    // Swal.fire로 삭제 확인 메시지 표시
                    Swal.fire({
                        title: '정말로 삭제하시겠습니까?',
                        icon: 'warning',
                        showCancelButton: true,
                        cancelButtonText: '취소',
                        confirmButtonText: '삭제'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Ajax를 사용하여 삭제 요청 보내기
                            $.ajax({
                                url: '/meetingRoom/deleteRes',
                                type: 'POST',
                                data: { rsvtNo: rsvtNo },
                                beforeSend: function(xhr) {
                                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                                },
                                success: function(response) {
                                    Swal.fire('삭제 완료', '예약이 성공적으로 삭제되었습니다.', 'success')
                                    .then(() => {
                                        location.reload(); // 페이지 새로고침
                                    });
                                },
                                error: function(error) {
                                    Swal.fire('삭제 실패', '삭제 중 오류가 발생했습니다.', 'error');
                                    console.error(error);
                                }
                            });
                        }
                    });
                });
            },
            
            onTimeRangeSelected: async function(args) {
                // 선택한 회의실의 id에 해당하는 회의실 이름을 찾기
                const selectedResource = dp.resources.find(resource => resource.id === args.resource);

                // 시작 시간, 종료 시간, 선택한 회의실 이름을 콘솔에 출력
                console.log("Selected start time: " + args.start);
                console.log("Selected end time: " + args.end);
                console.log("Selected room: " + selectedResource.name);
                
                // 회의실명 input 필드에 출력
                $('#meetingRoomNm').html(selectedResource.name); 
                
                // 선택한 회의실 이름을 화면                // 시작 시간, 종료 시간을 각각의 input 필드에 설정
                $('#rvsdTm1').val(args.start.toString('HH:mm')).prop('readonly', true);  // 수정 불가
                $('#rvsdTm2').val(args.end.toString('HH:mm')).prop('readonly', false);  // 수정 가능

                // 모달 열기
                modal.show();

                // 취소 버튼 클릭 시 모달 닫기
                $('#close').click(function() {
                    modal.hide();
                });
                                

                $('#confirm').on('click', function() {

                    // 입력된 시작 시간 및 종료 시간 가져오기
                    const startDate = args.start;
                    const endDate = args.end;
                    
                    let formData = new FormData();
                    
                	// 수집된 데이터를 서버로 전송 (AJAX 사용)
                    let meetingRoomNm = $('#meetingRoomNm').text(); // 회의실명 가져오기

	                 // 회의실명으로 해당 ID 찾기
	                 let selectRoom = dp.resources.find(room => room.name === meetingRoomNm);
	
                     let mtgroomCd = selectRoom.id;
	                 // 해당 회의실의 ID 출력
	                 if (selectRoom) {
	                     console.log("회의실 ID:", selectRoom.id);
	                 } else {
	                     console.log("해당 회의실을 찾을 수 없습니다.");
	                 }
	  
	                 
	                let rsvtYmd = $('#rvsdYmd').val().replace(/-/g, '');  // '-'를 제거하여 20240923으로 변환

	                // 시작 시간과 종료 시간을 String으로 변환
	                let rsvtBgngTm = String($('#rvsdTm1').val());  // 시작 시간 (이미 String이지만 명시적 변환)
	                let rsvtEndTm = String($('#rvsdTm2').val());   // 종료 시간 (이미 String
                    let rsvtCn = $('#schdlCn').val();               // 예약 내용 가져오기
                    let res = $('#res').val();                      // 예약자 정보 가져오기
                    let empNo = $('input[name="empNo"]').val();  // name 속성이 empNo인 input의 값 가져오기
                    console.log("empNo 값 확인: ", empNo);
                    
                    console.log("rsvtYmd",rsvtYmd);
                    console.log("meetingRoomNm",meetingRoomNm);
                    console.log("mtgroomCd",mtgroomCd);
                    console.log("rsvtBgngTm",rsvtBgngTm);
                    console.log("rsvtEndTm",rsvtEndTm);
                    console.log("rsvtCn",rsvtCn);
                    console.log("res",res);
                    console.log("empNo",empNo);
                    
                    formData.append("rsvtYmd",rsvtYmd);
                    formData.append("rsvtBgngTm",rsvtBgngTm);
                    formData.append("rsvtEndTm",rsvtEndTm);
                    formData.append("empNo",empNo);
                    formData.append("mtgroomCd",mtgroomCd);
                    formData.append("rsvtCn",rsvtCn);
                    
                    $.ajax({
                        url: '/meetingRoom/registRes', // 서버로 보낼 API 경로 설정
                        processData : false,
                        contentType: false,
                        data : formData,
                        type: 'POST',
                        dataType: "text",
                        beforeSend:function(xhr){
                            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
                         },
                        success: function(response) {
                            // 등록 성공 시 처리
                            Swal.fire({
                                icon: 'success',
                                title: '예약이 완료되었습니다.',
                            }).then(() => {
                                location.reload(); // 페이지 새로고침
                            });
                        },
                        error: function(error) {
                            // 등록 실패 시 처리
                            console.error("삭제 실패:", error);
                            Swal.fire({
                                icon: 'error',
                                title: '예약 중 오류가 발생했습니다.',
                            });
                        }
                    });

                    // 모달 닫기
                    modal.hide();
                });	                
	                
            }
            
        
        });
                
        $('#confirm1').on('click', function() {
        	
        	console.log("체크");
        	
        	
            // 입력된 일정명 가져오기
            const scheduleName = $('#schdlNm').val();

            // 입력된 시작 시간 및 종료 시간 가져오기 (모달 내부 값)
            const startDate = $('#rvsdTm3').val();  // 시작 시간
            const endDate = $('#rvsdTm4').val();    // 종료 시간
            
            let formData = new FormData();
            
         // 선택된 회의실의 값을 가져오기
            let meetingRoomCd = $('#meetingRoomCd').val(); // 선택된 value

            // 선택된 회의실의 이름(텍스트)을 가져오기
            let meetingRoomNm = $('#meetingRoomCd option:selected').text(); // 선택된 텍스트

            console.log("선택된 회의실 코드:", meetingRoomCd);
            console.log("선택된 회의실 이름:", meetingRoomNm);
           

            let mtgroomCd = meetingRoomCd;
            
            let rsvtYmd = $('#rvsdYmd2').val().replace(/-/g, '');  // '-'를 제거하여 20240923으로 변환

            // 시작 시간과 종료 시간을 String으로 변환
            let rsvtBgngTm = String($('#rvsdTm3').val());  // 시작 시간 (모달 내부 값)
            let rsvtEndTm = String($('#rvsdTm4').val());   // 종료 시간 (모달 내부 값)
            let rsvtCn = $('#rvsdCn1').val();               // 예약 내용 가져오기
            let res = $('#res').val();                      // 예약자 정보 가져오기
            let empNo = $('#empNo').val();                  // 직원 번호 가져오기
            
            console.log("rsvtYmd",rsvtYmd);
            console.log("meetingRoomNm",meetingRoomNm);
            console.log("mtgroomCd",mtgroomCd);
            console.log("rsvtBgngTm",rsvtBgngTm);
            console.log("rsvtEndTm",rsvtEndTm);
            console.log("rsvtCn",rsvtCn);
            console.log("res",res);
            console.log("empNo",empNo);
            
            formData.append("rsvtYmd",rsvtYmd);
            formData.append("rsvtBgngTm",rsvtBgngTm);
            formData.append("rsvtEndTm",rsvtEndTm);
            formData.append("empNo",empNo);
            formData.append("mtgroomCd",mtgroomCd);
            formData.append("rsvtCn",rsvtCn);
            
            $.ajax({
                url: '/meetingRoom/registRes', // 서버로 보낼 API 경로 설정
                processData : false,
                contentType: false,
                data : formData,
                type: 'POST',
                dataType: "text",
                beforeSend:function(xhr){
                    xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
                 },
                success: function(response) {
                    // 등록 성공 시 처리
                    Swal.fire({
                        icon: 'success',
                        title: '예약이 완료되었습니다.',
                    }).then(() => {
                        location.reload(); // 페이지 새로고침
                    });
                },
                error: function(error) {
                    // 등록 실패 시 처리
                    console.error("삭제 실패:", error);
                    Swal.fire({
                        icon: 'error',
                        title: '예약 중 오류가 발생했습니다.',
                    });
                }
            });

            // 모달 닫기
            modal.hide();
        });
        
     	// 이벤트 렌더링 전 호출될 핸들러
        dp.onBeforeEventRender = function(args) {
            console.log("onBeforeEventRender called", args.e); // 이벤트 렌더링 호출 확인
            let loggedInEmpNo = $('input[name="empNo"]').val();
            console.log("loggedInEmpNo : ", loggedInEmpNo);  // 로그인된 empNo 출력
            
            if (args.e.data && args.e.data.emp) {
                if (args.e.data.emp === loggedInEmpNo) {
                    // 기존의 cssClass에 새로운 클래스를 추가
                    args.data.cssClass = (args.data.cssClass || "") + " scheduler_custom_event_line0"; // 내 예약
                } else {
                    // 기존의 cssClass에 새로운 클래스를 추가
                    args.data.cssClass = (args.data.cssClass || "") + " scheduler_custom_event_line1"; // 다른 사람 예약
                }
            }
        };
        

        // DayPilot 초기화
        dp.init();
        
        
                
        // AJAX 호출: 예약 정보를 받아와 이벤트 처리
        $.ajax({
            url: '/meetingRoom/getReservations',
            type: 'GET',
            dataType: 'json',
            success: function(reservations) {
                console.log("Reservations:", reservations); // 응답 데이터 확인
                if (reservations.length === 0) {
                    console.log("No reservations found.");
                }
            	
                const meetingRooms = [
                    { id: 'A05-001', name: '회의실1' },
                    { id: 'A05-002', name: '회의실2' },
                    { id: 'A05-003', name: '회의실3' },
                    { id: 'A05-004', name: '회의실4' },
                    { id: 'A05-005', name: '회의실5' },
                    { id: 'A05-006', name: '회의실6' },
                    { id: 'A05-007', name: '회의실7' },
                    { id: 'A05-008', name: '회의실8' },
                    { id: 'A05-009', name: '회의실9' },
                    { id: 'A05-010', name: '회의실10'},
                ];

                dp.resources = meetingRooms;

                reservations.forEach(function(reservation) {
                	const formattedDate = reservation.rsvtYmd.slice(0, 4) + '-' + reservation.rsvtYmd.slice(4, 6) + '-' + reservation.rsvtYmd.slice(6, 8);
                	
                	 // 시작 시간과 종료 시간에 ":00"을 추가하여 초 단위 포함
                    const startTime = reservation.rsvtBgngTm.length === 5 ? reservation.rsvtBgngTm + ":00" : reservation.rsvtBgngTm;
                    const endTime = reservation.rsvtEndTm.length === 5 ? reservation.rsvtEndTm + ":00" : reservation.rsvtEndTm;
                	
                    const room = meetingRooms.find(r => r.id === reservation.mtgroomCd);
                    const roomName = room ? room.name : reservation.mtgroomCd;

                    dp.events.add({
                        id: reservation.rsvtNo,
                        text: roomName,
                        start: formattedDate + "T" + startTime,
                        end: formattedDate + "T" + endTime,
                        resource: reservation.mtgroomCd,
                        data: { emp: reservation.empNo,
                        	    rsvtCn: reservation.rsvtCn,
                        	    rsvtYmd: reservation.rsvtYmd,
                        	    rsvtBgngTm : reservation.rsvtBgngTm,
                        	    rsvtEndTm : reservation.rsvtEndTm}  // empNo를 data로 추가
                    });
                    
                    // 추가된 이벤트 콘솔 출력
                    console.log("Event added: ", reservation);
                });

                dp.onBeforeCellRender = function(args) {
                    const formattedDate = new DayPilot.Date(args.start).toString("yyyyMMdd");  // args.start를 yyyyMMdd 형식으로 변환

                    const reservation = reservations.find(r => r.mtgroomCd === args.resource &&
                                                               formattedDate === r.rsvtYmd &&
                                                               args.start.toString("HH:mm") >= r.rsvtBgngTm &&
                                                               args.end.toString("HH:mm") <= r.rsvtEndTm);

                    if (reservation) {
                        args.cell.backColor = "#4E7DF4";  // 예약된 시간대에 배경색 추가
                    }
                };
            },
            error: function(error) {
                console.error("예약 정보를 가져오는 데 실패했습니다.", error);
            }
        });

        dp.update();
        
    }, 0);
});



console.log("DayPilot", typeof DayPilot !== "undefined" ? "loaded" : "not loaded");

document.addEventListener('DOMContentLoaded', function() {
    const dpElement = document.getElementById('dp');
    dpElement.style.overflowX = 'hidden';  // 가로 스크롤바 숨기기
    
 
});

//모달을 열기 위한 JavaScript 코드
document.addEventListener('DOMContentLoaded', function() {
    let modal = document.getElementById('modal');

    // 이벤트가 발생할 때 모달을 표시
    function openModal() {
        modal.style.display = 'block';
    }

    // 취소 버튼 클릭 시 모달 닫기
    document.getElementById('close').addEventListener('click', function() {
        modal.style.display = 'none';
    });

    // 등록 버튼 클릭 시 모달 닫기 (추가적인 이벤트 처리 필요)
    document.getElementById('confirm').addEventListener('click', function() {
        modal.style.display = 'none';
    });
    

    // 스케줄러에서 일정 추가할 때 모달 열기
    const dp = new DayPilot.Scheduler("dp", {
        onTimeRangeSelected: function(args) {
            openModal();  // 일정 추가 시 모달 열기
        }
    });
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
    // modal2 초기 상태로 숨기기
    $('#modal2').hide();

    // 예약 버튼 클릭 시 modal2 열기
    $("#rsvdBtn").click(function() {
        $('#modal2').show();  // modal2를 표시
    });

    // 모달 닫기 버튼 클릭 시 모달 닫기
    $('#close1').click(function() {
        $('#modal2').hide();  // modal2를 숨기기
    });

    // 등록 버튼 클릭 시 모달 닫기
    $('#confirm1').click(function() {
        $('#modal2').hide();  // modal2를 숨기기
    });
});

$(document).ready(function() {
	
    $('#modal3').hide();
	
	$('#cancle').click(function() {
		$('#modal3').hide();
	});
	
	$('#resDel').click(function() {
		$('#modal3').hide();
	});
	
});

$(document).ready(function() {
    $('#myRes').on('click', function() {
        console.log("버튼이 클릭되었습니다."); // 클릭 로그 확인
        // 새 팝업 창 열기
        window.open('/meetingRoom/detail', 'popUpWindow', 'height=600,width=870,left=300,top=200,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes');
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



/* 큰 네모 박스 */
.outer-square {
	width: 30px;
	height: 30px;
	border: 1px solid #c0c0c0;
	border-radius: 8px;
	display: flex;
	justify-content: left;
	align-items: left;
	top: 0; /* 위에서부터의 거리 */
	left: 300px; /* 왼쪽에서 오른쪽으로 이동 */
	margin-right: 10px;
}

/* 체크박스 스타일 */
.custom-checkbox input[type="checkbox"] {
	width: 15px;
	height: 15px;
	border: 2px solid #c0c0c0;
	border-radius: 5.5px;
	appearance: none;
	-webkit-appearance: none;
	cursor: pointer;
	margin-left: 7px;
	margin-top: 7px;
}

/* 체크박스가 선택되었을 때의 스타일 */
.custom-checkbox input[type="checkbox"]:checked {
	background-color: #4E7DF4;
	position: relative;
}

#myRes {
	margin-top: 6px;
}

/* 셀 스타일 */
.scheduler_custom_cell {
	background-color: white !important; /* 셀 배경을 연한 회색으로 */
	border-left: 1px solid #E6E8EA !important; /* 셀 간의 구분선 */
	border-bottom: 1px solid #E6E8EA !important; /* 셀 하단 구분선 */
}

/* 선택된 셀 스타일 */
.scheduler_custom_selected {
	background-color: rgba(78, 125, 244, 0.3) !important; /* 선택된 셀의 배경색 */
}

/* 스케줄 코너 (DEMO 부분) */
.scheduler_custom_main {
	margin-left: 30px !important; /* 가로로 가운데 정렬 */
}

.scheduler_custom_timeheader_scroll {
	border-top: 1px solid #E6E8EA;
	border-bottom: 1px solid #E6E8EA;
	color: #6b6b6b !important; /* 글자 색상 */
	text-align: center;
	width: 960px !important; /* 너비를 960px로 설정 */
	overflow: hidden; /* 넘치는 부분 숨김 */
	position: absolute; /* 위치를 절대값으로 설정 */
	top: 0px; /* 위쪽에서 0px 위치 */
	height: 100px; /* 높이를 100px로 설정 */
}

.scheduler_custom_timeheader_scroll td:last-child {
	border-right: none; /* 마지막 열의 오른쪽 선 제거 */
	border-right: none; /* 마지막 열의 오른쪽 선 제거 */
}

.scheduler_custom_timeheader_scroll tr:last-child {
	border-bottom: none; /* 마지막 행의 하단 선 제거 */
}

.scheduler_custom_corner {
	border-top: 1px solid #E6E8EA;
	border-bottom: 1px solid #E6E8EA;
	height: 30px !important;
}

.scheduler_custom_divider.scheduler_custom_splitter {
	border-right: 1px solid #E6E8EA;
	height: 331px !important;
}

.scheduler_custom_timeheadergroup.scheduler_custom_timeheader_cell.scheduler_custom_timeheader_cell_last
	{
	display: none !important; /* 해당 요소를 숨깁니다 */
}

.scheduler_custom_timeheadercol.scheduler_custom_timeheader_cell {
	text-align: center;
}

.scheduler_custom_timeheader_scroll {
	height: 30px !important;
}

.scheduler_custom_timeheadercol.scheduler_custom_timeheader_cell {
	margin-top: -50px;
	height: 30px !important;
	border-left: 1px solid #E6E8EA;
}

.scheduler_custom_timeheadercol_inner.scheduler_custom_timeheader_cell_inner
	{
	margin-top: 5px;
}

.scheduler_custom_scrollable {
	margin-top: -70px;
}

.scheduler_custom_rowheader_scroll {
	margin-top: 8px;
}

.scheduler_custom_rowheader {
	margin-top: -8px;
	border-bottom: 1px solid #E6E8EA;
}

.scheduler_custom_rowheader_inner {
	margin-top: 7px;
}

.scheduler_custom_timeheader_cell[data-hour="23"] {
	display: none !important; /* 11 PM 셀을 숨기기 */
}

.scheduler_custom_corner div[style*="background-color: rgb(255, 102, 0)"]
	{
	display: none !important;
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

::-webkit-scrollbar {
	width: 6px;
}

/* Track */
::-webkit-scrollbar-track {
	background: #ccc;
	border-radius: 5px;
}

/* Handle */
::-webkit-scrollbar-thumb {
	background: #4E7DF4;
	border-radius: 24px;
}
/* To handle height for vertical scrollbar, you can control the thumb height */
::-webkit-scrollbar-thumb {
	max-height: 80px; /* Minimum height of the thumb handle */
}

selct {
	height: 50px;
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

.scheduler_custom_event.scheduler_custom_event_line0 {
	background-color: rgba(78, 125, 244, 0.5) !important;
	color: transparent !important;
}

.scheduler_custom_event.scheduler_custom_event_line1 {
	background-color: rgba(180, 182, 184, 0.5) !important;
	color: transparent !important;
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

#dp {
    overflow: hidden !important;
}

</style>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<br><br>

	<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
		<div class="w-full flex justify-between items-center mb-3 mt-1 pl-3" style="margin-left: -7%;">
			<div style="margin-top: 30px; margin-bottom: 10px;">
				<h3 class="text-lg font-semibold text-slate-800">회의실</h3>
				<p class="text-slate-500">회의실 예약</p>
				
				<br>
				
				<div
					class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
					<div class="card-body table-responsive p-0">
						<div style="display: flex; align-items: center;">
<!-- 							<button id="myRes" -->
<!-- 								class="bg-primary hover:bg-primaryActive text-white text-sm py-2 px-3 mr-2 mb-2 rounded-xl transition duration-300"> -->
<!-- 								내 예약</button> -->
							<button id="myRes" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                                  type="button" style="margin-left:10px;margin-top:10px;">
                           		내 예약</button>
						</div>

						<hr style="margin-top: 10px;">
						<br> <br>

						<!-- <div id="divImg1" onclick="javascript:alert('파란색 사각형 선택됨!');"></div> -->

						<div
							style="width: 1101px; height: 600px; display: flex; justify-content: center; align-items: center;">
							<!-- 	<img src="/resources/images/meetingRoom1100.png" alt="회의실 이미지" style="background-color:transparent;display: block;width:1100px;" /> -->
							<!-- Save for Web Slices (meetingRoom1100_2.png) -->
							<table id="__01" width="900" height="347" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td colspan="14">
										<img src="/resources/images/meetingName/meetingRoom_01.png" width="1000" height="127" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="127" alt=""></td>
								</tr>
								<tr>
									<td colspan="12" rowspan="2">
										<img src="/resources/images/meetingName/meetingRoom_02.png" width="929" height="38" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_03.png" width="25" height="21" alt="회의실9" title="회의실9" onclick="chk('03')" style="cursor:pointer;"></td>
									<td rowspan="12">
										<img src="/resources/images/meetingName/meetingRoom_04.png" width="46" height="219" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="21" alt=""></td>
								</tr>
								<tr>
									<td rowspan="11">
										<img src="/resources/images/meetingName/meetingRoom_05.png" width="25" height="198" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="17" alt=""></td>
								</tr>
								<tr>
									<td rowspan="10">
										<img src="/resources/images/meetingName/meetingRoom_06.png" width="214" height="181" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_07.png" width="19" height="20" alt="회의실7" title="회의실7" onclick="chk('07')" style="cursor:pointer;"></td>
									<td colspan="10">
										<img src="/resources/images/meetingName/meetingRoom_08.png" width="696" height="20" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="20" alt=""></td>
								</tr>
								<tr>
									<td colspan="2" rowspan="9">
										<img src="/resources/images/meetingName/meetingRoom_09.png" width="229" height="161" alt=""></td>
									<td rowspan="2">
										<img src="/resources/images/meetingName/meetingRoom_10.png" width="21" height="27" alt="회의실3" title="회의실3" onclick="chk('10')" style="cursor:pointer;"></td>
									<td colspan="8">
										<img src="/resources/images/meetingName/meetingRoom_11.png" width="465" height="8" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="8" alt=""></td>
								</tr>
								<tr>
									<td rowspan="8">
										<img src="/resources/images/meetingName/meetingRoom_12.png" width="9" height="153" alt=""></td>
									<td rowspan="3">
										<img src="/resources/images/meetingName/meetingRoom_13.png" width="27" height="46" alt="회의실2" title="회의실2" onclick="chk('13')" style="cursor:pointer;"></td>
									<td rowspan="3">
										<img src="/resources/images/meetingName/meetingRoom_14.png" width="69" height="46" alt="회의실1" title="회의실1" onclick="chk('14')" style="cursor:pointer;"></td>
									<td rowspan="8">
										<img src="/resources/images/meetingName/meetingRoom_15.png" width="10" height="153" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_16.png" width="21" height="19" alt="회의실5" title="회의실5" onclick="chk('16')" style="cursor:pointer;"></td>
									<td colspan="3" rowspan="4">
										<img src="/resources/images/meetingName/meetingRoom_17.png" width="329" height="64" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="19" alt=""></td>
								</tr>
								<tr>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_18.png" width="21" height="7" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_19.png" width="21" height="7" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="7" alt=""></td>
								</tr>
								<tr>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_20.png" width="21" height="20" alt="회의실4" title="회의실4" onclick="chk('20')" style="cursor:pointer;"></td>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_21.png" width="21" height="20" alt="회의실6" title="회의실6" onclick="chk('21')" style="cursor:pointer;"></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="20" alt=""></td>
								</tr>
								<tr>
									<td rowspan="5">
										<img src="/resources/images/meetingName/meetingRoom_22.png" width="21" height="107" alt=""></td>
									<td colspan="2" rowspan="5">
										<img src="/resources/images/meetingName/meetingRoom_23.png" width="96" height="107" alt=""></td>
									<td rowspan="5">
										<img src="/resources/images/meetingName/meetingRoom_24.png" width="21" height="107" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="18" alt=""></td>
								</tr>
								<tr>
									<td rowspan="4">
										<img src="/resources/images/meetingName/meetingRoom_25.png" width="16" height="89" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_26.png" width="21" height="23" alt="회의실7" title="회의실7" onclick="chk('26')" style="cursor:pointer;"></td>
									<td rowspan="4">
										<img src="/resources/images/meetingName/meetingRoom_27.png" width="292" height="89" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="23" alt=""></td>
								</tr>
								<tr>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_28.png" width="21" height="7" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="7" alt=""></td>
								</tr>
								<tr>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_29.png" width="21" height="24" alt="회의실8" title="회의실8" onclick="chk('29')" style="cursor:pointer;"></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="24" alt=""></td>
								</tr>
								<tr>
									<td>
										<img src="/resources/images/meetingName/meetingRoom_30.png" width="21" height="35" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="35" alt=""></td>
								</tr>
								<tr>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="214" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="19" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="210" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="21" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="9" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="27" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="69" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="10" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="21" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="16" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="21" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="292" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="25" height="1" alt=""></td>
									<td>
										<img src="/resources/images/meetingName/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="46" height="1" alt=""></td>
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
							<div id="currentdate"
								style="font-size: 18px; font-weight: bold; margin-left: 30px;"></div>
							<img src="/resources/images/calendar.png" style="width:20px;height:20px;margin-top:4px;"/>

<!-- 							<button id="rsvdBtn" -->
<!-- 								class="bg-primary hover:bg-primaryActive text-white text-sm py-2 px-3 mr-2 mb-2 rounded-xl transition duration-300" -->
<!-- 								style="margin-top: -6px; margin-left: 690px !important;">예약</button> -->
								
							<button id="rsvdBtn" class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                                  type="button" style="margin-left:560px !important;margin-top:-6px;">
                           		예약</button>

							<div id="ressts" style="display: flex; margin-right: 30px;">
								<div class="resp"></div>
								<span style="margin-top: -2px; margin-right: 6px;">예약 가능</span>
								<div class="resv"></div>
								<span style="margin-top: -2px; margin-right: 6px;">예약 중</span>
								<div class="myres"></div>
								<span style="margin-top: -2px; margin-right: 6px;">내 예약</span>
							</div>
						</div>

						<br>

						<div id="dp" style="height: 500px;"></div>

					</div>
				
				</div>
			</div>
		</div>
	</div>

<!-- 모달 -->
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
									<input type="date"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5"
										name="rvsdYmd" id="rvsdYmd" style="margin-left: 50px;"
										required readonly> <input type="time"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-1/4 p-2.5"
										name="rvsdTm1" id="rvsdTm1" required> <span
										class="mx-2" style="margin-left: 12px !important;">-</span> <select
										id="rvsdTm2" name="rvsdTm2"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-1/4 p-2.5">
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

				<div class="bg-gray-50 px-4 py-3 flex justify-center">
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


<!-- 회의실 예약 눌렀을 때 모달 -->
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
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-40 p-2.5"
										name="rvsdYmd2" id="rvsdYmd2" style="margin-left: 50px;"
										required readonly> <select id="rvsdTm3" name="rvsdTm3"
										class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-1/4 p-2.5"
										style="width: 120px; height: 35px !important;">
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
										style="width: 120px; height: 35px !important;">
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

				<div class="bg-gray-50 px-4 py-3 flex justify-center">
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

<!-- onClick 모달 -->
<div class="relative z-10" id="modal3" aria-labelledby="modal-title"
	role="dialog" aria-modal="true">
	<div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
		aria-hidden="true"></div>

	<div class="fixed inset-0 z-10 w-screen overflow-y-auto">
		<div
			class="flex min-h-full items-center justify-center p-4 text-center">
			<div
				class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:max-w-2xl sm:w-full">

				<div class="bg-white px-4 pb-4 pt-4 sm:p-6">
					<div style="display: flex;">
						<img src="/resources/images/resicon.png" alt="mricon"
							style="width: 20px; height: 20px; margin-right: 10px;" />
						<div id="meetingCn" class="ml-1 text-lg font-bold mb-3 block">
						</div>
					</div>
					<table style="width: 100%;">
						<input type="hidden" id="rsvtNo" value="" />
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="meetingDate"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">일시</label></td>
							<td>
								<div id="meetingDate" class="flex items-center space-x-2"></div>
							</td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="meetingrNo"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">장소</label></td>
							<td>
								<div id="meetingrNo" class="flex items-center"></div>
							</td>
						</tr>
						<tr>
							<td class="py-2" style="text-align: left; padding-right: 10px;"><label
								for="meetingEmp"
								class="text-base font-semibold leading-6 text-gray-900"
								id="modal-title">예약자</label></td>
							<td>
								<div id="meetingEmp" class="flex items-center"></div>
							</td>
						</tr>
					</table>
					<div id="mapImg" style="display: none;"></div>
				</div>

				<div class="bg-gray-50 px-4 py-3 flex justify-center">
					<button type="button" id="cancle"
						class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">취소</button>
					<button type="button" id="resDel"
						class="inline-flex justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">삭제</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 모달 끝 -->

<script>


function chk(no){
    console.log("no : " + no);
    
    console.log("scheduler_custom_cell 크기 : " + $(".scheduler_custom_cell").length); 
    
    console.log("scheduler_custom_matrix_horizontal_line 크기 : " + $('.scheduler_custom_matrix_horizontal_line').length);
    
    
    let arr = [];
        
    let namuji = 0;
    
    //1. black을 대체
    $(".scheduler_custom_cell").css({
        'border-top': '1px solid rgba(230, 232, 234, 0)',
        'border-bottom': '1px solid rgba(230, 232, 234, 0)'
    });
    
    $('.scheduler_custom_matrix_horizontal_line').eq(9).css('border', '1px solid rgba(230, 232, 234, 0)');
    
    $.each($(".scheduler_custom_cell"), function(i, cel) {
        if(no == 14) {
            namuji = 0;
        } else if(no == 13) {
            namuji = 1;
        } else if(no == 10) {
            namuji = 2;
        } else if(no == 20) {
            namuji = 3;
        } else if(no == 16) {
            namuji = 4;
        } else if(no == 21) {
            namuji = 5;
        } else if(no == 26) {
            namuji = 6;
        } else if(no == 29) {
            namuji = 7;
        } else if(no == 03) {
            namuji = 8;
        } else if(no == 07) {
            namuji = 9;
        } else if(no == 00) {
            namuji = 10;
        }

        //2. border-bottom 처리
        if (i % 10 == namuji) {
        	
        	console.log("namuji : " + namuji);
            // 현재 요소에 스타일 적용
            $(this).css({
                'border-top': '2px solid rgba(78, 125, 244, 0.5)'
            });

            if (namuji == 9) {
                // namuji가 9일 경우에만 특정 요소에 스타일 적용
            	$('.scheduler_custom_matrix_horizontal_line').eq(9).css({
            	    'border': '1.2px solid rgba(78, 125, 244, 0.5)',
            	    'margin-top': '-1px'  // 원하는 값으로 조정
            	});
            } else {
                // i+1, 즉 다음 형제 요소에 스타일 적용
                $(this).next().css({
                    'border-top': '2px solid rgba(78, 125, 244, 0.5)',
                });
            }
        }
    });

    // 리소스 ID와 회의실 번호 매칭 (예시로 작성)
    const roomMap = {
        "03": "A05-009", // 회의실 9
        "07": "A05-010", // 회의실 10
        "10": "A05-003", // 회의실 3(2,12,22,32..)
        "13": "A05-002", // 회의실 2(1,11,21,31..)
        "14": "A05-001", // 회의실 1(0,10,20,30..)
        "16": "A05-005", // 회의실 5
        "20": "A05-004", // 회의실 4
        "21": "A05-006", // 회의실 6
        "26": "A05-007", // 회의실 7
        "29": "A05-008"  // 회의실 8
    };

    // 선택된 회의실 ID 가져오기
    const selectedRoomId = roomMap[no];

    // 선택된 회의실의 모든 셀에 스타일 적용
    $('#dp .scheduler_custom_cell[data-resource="' + selectedRoomId + '"]').css({
        'border-top': '1px solid rgba(78, 125, 244, 0.5)',
        'border-bottom': '1px solid rgba(78, 125, 244, 0.5)'
    });
}

$(document).ready(function() {
    let date = DayPilot.Date.today();

    // JavaScript Date 객체로 변환
    const jsDate = date.toDate();

    // 연, 월, 일을 추출
    const year = jsDate.getFullYear();
    const month = String(jsDate.getMonth() + 1).padStart(2, '0');  // 월은 0부터 시작하므로 1을 더함
    const day = String(jsDate.getDate()).padStart(2, '0');

    // 요일 배열 설정
    const daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
    const currentDayOfWeek = daysOfWeek[jsDate.getDay()];  // 요일 추출
	
    console.log("year",year);
    console.log("month",month);
    console.log("day",day);
    console.log("currentDayOfWeek",currentDayOfWeek);
    

    // 화면에 표시
    $('#currentdate').text(year+"."+month+"."+day+"."+" "+"("+currentDayOfWeek+")");
});

</script>