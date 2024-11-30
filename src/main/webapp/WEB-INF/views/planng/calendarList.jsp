<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authorize access="isAuthenticated()">
   <sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.css" rel="stylesheet">
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link href="/resources/css/calendarList.css" rel="stylesheet" type="text/css">
<script>

	const loggedInEmpNo = "${empNo}";
	console.log("Logged in Employee Number: " + loggedInEmpNo);
	   
	var sock = new SockJS("/alram");
	socket = sock; // socket 초기화

	//페이지 로드 시 전체 일정 가져오는 함수
	function loadAllEvents() {
		$.ajax({
			url: '/getAllEvents',
			type: 'get',
			dataType: 'json',
			success: function(result) {
				console.log("result:" , result);
				var events = result.map(function(event) {
					return {
						id: event.schdlNo,
				        title: event.schdlNm,
				        start: event.schdlBgngYmd + 'T' + event.schdlBgngTm,
				        end: event.schdlEndYmd + 'T' + event.schdlEndTm,
				        description: event.schdlCn,
				        location: event.schdlPlc,
				        backgroundColor: event.backColor,
				        textColor: event.fontColor,
				        allDay: !event.schdlBgngTm && !event.schdlEndTm,
				        extendedProps: {
				          schdlTtl: event.schdlTtl,
				          userCd: event.userCd,
				          schdlCn: event.schdlCn,
				          schdlBgngTm: event.schdlBgngTm,
				          schdlEndTm: event.schdlEndTm
				        }
					};
				});
				calendar.removeAllEvents();
				calendar.addEventSource(events);
			}
		})
	}
	
	//일정 등록 컨펌 버튼
	function confirm() {
	    Swal.fire({
	        title: '일정을 등록하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#4E7DF4',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	    }).then((result) => {
	        if (result.isConfirmed) {
	            Swal.fire({
	                title: '일정 등록이 완료되었습니다.',
	                icon: 'success',
	                confirmButtonColor: '#4E7DF4',
	                confirmButtonText: '확인',
	                reverseButtons: true,
	            }).then((result) => {
	                if (result.isConfirmed) {
	                    $("form").submit();
	                }
	            });
	        }
	    });
	}
	
	//일정 등록 취소 버튼
	function cancel() {
		Swal.fire({
			title: '일정 등록을 취소하시겠습니까?',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#4E7DF4',
			confirmButtonText: '확인',
			cancelButtonText: '취소',
			reverseButtons: true,
		}).then((result) => {
			if(result.isConfirmed) {
				window.location.href = "/calendarList";
			}
		});
	}
	
	//캘린더 헤더 설정
	var headerToolbar = {
			left: 'prev,next,today',
			center: 'title',
			right: 'dayGridMonth,dayGridWeek,timeGridDay'
	}
	
	//캘린더 불러오기
	document.addEventListener('DOMContentLoaded', function() {
		var calendarEl = document.getElementById('calendar');

		calendar = new FullCalendar.Calendar(calendarEl, {
			initialView : 'dayGridMonth',
			selectable: true,
			editable:true,
			headerToolbar: headerToolbar,
			eventTimeFormat: {
		        hour: '2-digit',
		        minute: '2-digit',
		        hour12: false
		    },
		    dayMaxEvents: true,
		    moreLinkText: "더보기", 
		    events: loadAllEvents(),
	        eventDidMount: function(info) {
	            //borderColor를 backgroundColor와 동일하게 설정
	            info.el.style.borderColor = info.event.backgroundColor;
	        },
			select: function(info) {
				//선택한 시간 날짜와 종료 날짜 가져옴
				$("#schdlBgngYmd").val(info.startStr); //시작일
				
				//종료일 하루 빼기
			    var endDate = new Date(info.end);
			    $("#schdlEndYmd").val(endDate.toISOString().split('T')[0]); // 종료일 설정
				
				//시간 input은 선택한 범위가 '종일'인지 여부에 따라 활성화 또는 비활성화
	            if (info.allDay) {
	                $("#schdlBgngTm").attr("disabled", false);
	                $("#schdlEndTm").attr("disabled", false);
	                $("#allDayCheck").prop('checked', false);
	            } else {
	            	$("#schdlBgngTm").val("").attr("disabled", true);
	                $("#schdlEndTm").val("").attr("disabled", true);
	                $("#allDayCheck").prop('checked', true);
	            }
				$('#modal').show();
			},
			
			//이벤트 영역에 마우스 호버 시 툴팁 열기
	        eventMouseEnter: function(info) {
	        	var tooltip = $("#eventTooltip");
	            
	            //이벤트 시작 및 종료 날짜와 시간을 받아서 변환
	            var startDate = info.event.start ? info.event.start.toLocaleDateString() : " ";
	            var startTime = info.event.extendedProps.schdlBgngTm || " ";
	            
	            var endDate = info.event.end ? info.event.end.toLocaleDateString() : "종료 날짜 없음";
	            var endTime = info.event.extendedProps.schdlEndTm || " ";
	            
	            var userCd = "";
	            
	            if(info.event.extendedProps.userCd == "A03-001") {
	            	userCd = "개인";
	            } else if(info.event.extendedProps.userCd == "A03-006") {
	            	userCd = "공통";
	            } else {
	            	userCd = "부서";
	            }
	            
	            var title = info.event.extendedProps.schdlTtl;
	            var content = info.event.extendedProps.schdlCn;
	            var sTime = info.event.extendedProps.schdlBgngTm;
	            var location = info.event.extendedProps.location;
	            
	            if(location == null) {
	            	location = " -";
	            }
	            
	            if(content == null) {
	            	content = " ";
	            }
	            
	            console.log(content);
	            
	            //팝업 내용 설정: 날짜와 시간을 함께 표시
	            $("#tooltipTitle").text("(" + sTime + ") " + info.event.title);
	            $("#tooltipTime").html(
	            		"<b>시간:</b> " + startDate + " " + startTime + " ~ " + endDate + " " + endTime + "<br>" +
	            		"<b>구분:</b> " + userCd + "<br>" +
	            		"<b>장소:</b> " + location + "<br>" +
	            		"<hr class='mt-2 mb-2'>" +
	            		"<b>내용: </b>" + content
	            		);
	            
	            //팝업 위치를 마우스 근처로 설정
	            tooltip.css({
	                top: info.jsEvent.pageY + 'px',
	                left: info.jsEvent.pageX + 'px',
	                display: 'block'
	            });
	        },

	        //마우스가 이벤트 영역 밖일 때 툴팁 닫기
	        eventMouseLeave: function(info) {
	            $("#eventTooltip").hide();
	        },
	        
	        //일정 영역 클릭 시 수정 모달 생성
	        eventClick: function(info) {
	        	
	        	console.log("이벤트 클릭 실행", info.event.backgroundColor);
	        	
	        	//정보 채우기
	        	$("#updateSchdlNo").val(info.event.id);
	        	$("#updateSchdlNm").val(info.event.title);
	            $("#updateSchdlBgngYmd").val(info.event.start.toISOString().split('T')[0]);
	            $("#updateSchdlEndYmd").val(info.event.end ? info.event.end.toISOString().split('T')[0] : info.event.start.toISOString().split('T')[0]);
	            $("#updateSchdlBgngTm").val(info.event.start.toTimeString().split(' ')[0].substr(0,5));
	            $("#updateSchdlEndTm").val(info.event.end ? info.event.end.toTimeString().split(' ')[0].substr(0,5) : '');
	            $("#updateSchdlCn").val(info.event.extendedProps.schdlCn);
	            $("#updateSchdlPlc").val(info.event.extendedProps.location);
	            $("select[name='userCd']").val(info.event.extendedProps.userCd);
	            $("#updateBackColor").val(info.event.backgroundColor);
	            $("#updateFontColor").val(info.event.textColor);

	            //기존에 선택된 클래스 제거 (초기화)
	            $(".update-color-box").removeClass('selected');

	            //클릭한 일정의 색상에 맞는 팔레트 박스에 selected 클래스 추가
				const selectedColorBox = $(`.update-color-box[data-color="${info.event.backgroundColor.toLowerCase().trim()}"]`);
				console.log("선택된 색상 박스:", selectedColorBox);
				
				if (selectedColorBox.length) {
				    selectedColorBox.addClass('selected');
				    console.log("선택된 색상에 selected 클래스 추가됨.");
				} else {
				    console.log("선택된 색상에 해당하는 팔레트 박스를 찾을 수 없습니다.");
				}	            
				
	            //종일 이벤트 체크
	            if(info.event.allDay) {
	                $("#updateAllDayCheck").prop('checked', true);
	                $("#updateSchdlBgngTm, #updateSchdlEndTm").attr("disabled", true);
	            } else {
	                $("#updateAllDayCheck").prop('checked', false);
	                $("#updateSchdlBgngTm, #updateSchdlEndTm").attr("disabled", false);
	            }
	            
	            let ayoung = document.querySelector("#updateColorPalette")
	            let divChilds = ayoung.children;
	            
	            for(let k=0; k<divChilds.length;k++){
	            	let div1 = divChilds[k];
	            	console.log("체킁:",div1.dataset.color);
	            	if(div1.dataset.color == info.event.backgroundColor){
	            		$(div1).addClass("selected");
	            		//alert("찾았당 ");	
	            		break;
	            	}
	            }
	            
				$("#updateModal").show();
				
	        },
	        
	        events: loadAllEvents(),
	        
		});
		
		//캘린더 그려~
		calendar.render();
	});

	$(document).ready(function() {
		
		//전체 일정 가져오기
		$("#all").on("click", function() {
			$.ajax({
				url: '/getAllEvents',
				type: 'get',
				beforeSend: function(xhr){
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 추가
		        },
		        success: function(result) {
		            console.log("전체 일정 데이터:", result);
		            var events = result.map(function(event) {
		            	return {
							id: event.schdlNo,
					        title: event.schdlNm,
					        start: event.schdlBgngYmd + 'T' + event.schdlBgngTm,
					        end: event.schdlEndYmd + 'T' + event.schdlEndTm,
					        description: event.schdlCn,
					        location: event.schdlPlc,
					        backgroundColor: event.backColor,
					        textColor: event.fontColor,
					        allDay: !event.schdlBgngTm && !event.schdlEndTm,
					        extendedProps: {
					          schdlTtl: event.schdlTtl,
					          userCd: event.userCd,
					          schdlCn: event.schdlCn,
					          schdlBgngTm: event.schdlBgngTm,
					          schdlEndTm: event.schdlEndTm
					        }
						};
		            });
		            calendar.removeAllEvents();
		            calendar.addEventSource(events);
		        }
			})
		})
		
		//공통 일정 가져오기
		$("#common").on("click", function() {
			$.ajax({
				url: '/getCommonEvents',
				type: 'post',
				beforeSend: function(xhr){
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 추가
		        },
		        success: function(result) {
		            console.log("공통 일정 데이터:", result);
		            var events = result.map(function(event) {
		            	return {
							id: event.schdlNo,
					        title: event.schdlNm,
					        start: event.schdlBgngYmd + 'T' + event.schdlBgngTm,
					        end: event.schdlEndYmd + 'T' + event.schdlEndTm,
					        description: event.schdlCn,
					        location: event.schdlPlc,
					        backgroundColor: event.backColor,
					        textColor: event.fontColor,
					        allDay: !event.schdlBgngTm && !event.schdlEndTm,
					        extendedProps: {
					          schdlTtl: event.schdlTtl,
					          userCd: event.userCd,
					          schdlCn: event.schdlCn,
					          schdlBgngTm: event.schdlBgngTm,
					          schdlEndTm: event.schdlEndTm
					        }
						};
		            });
		            calendar.removeAllEvents();
		            calendar.addEventSource(events);
		        }
			})
		})
		
		//부서 일정 가져오기
		$("#dept").on("click", function() {
			
			$.ajax({
				url: "/getDeptEvents",
				type: "post",
				data: JSON.stringify({
					"empNo": '${empVO.empNo}'
				}),
				dataType: 'json',
				contentType: "application/json",
				beforeSend: function(xhr){
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 추가
		        },
		        success: function(result) {
		        	console.log("부서 일정 데이터:", result);
		            var events = result.map(function(event) {
		            	return {
							id: event.schdlNo,
					        title: event.schdlNm,
					        start: event.schdlBgngYmd + 'T' + event.schdlBgngTm,
					        end: event.schdlEndYmd + 'T' + event.schdlEndTm,
					        description: event.schdlCn,
					        location: event.schdlPlc,
					        backgroundColor: event.backColor,
					        textColor: event.fontColor,
					        allDay: !event.schdlBgngTm && !event.schdlEndTm,
					        extendedProps: {
					          schdlTtl: event.schdlTtl,
					          userCd: event.userCd,
					          schdlCn: event.schdlCn,
					          schdlBgngTm: event.schdlBgngTm,
					          schdlEndTm: event.schdlEndTm
					        }
						};
		            });
		            calendar.removeAllEvents();
		            calendar.addEventSource(events);
		        }
			})
		})
		
		//개인 일정 가져오기
		$("#per").on("click", function() {
			$.ajax({
				url: "/getPerEvents",
				type: "post",
				data: JSON.stringify({
					"empNo": '${empVO.empNo}'
				}),
				dataType: 'json',
				contentType: "application/json",
				beforeSend: function(xhr){
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 추가
		        },
		        success: function(result) {
		        	console.log("개인 일정 데이터:", result);
		            var events = result.map(function(event) {
		            	return {
							id: event.schdlNo,
					        title: event.schdlNm,
					        start: event.schdlBgngYmd + 'T' + event.schdlBgngTm,
					        end: event.schdlEndYmd + 'T' + event.schdlEndTm,
					        description: event.schdlCn,
					        location: event.schdlPlc,
					        backgroundColor: event.backColor,
					        textColor: event.fontColor,
					        allDay: !event.schdlBgngTm && !event.schdlEndTm,
					        extendedProps: {
					          schdlTtl: event.schdlTtl,
					          userCd: event.userCd,
					          schdlCn: event.schdlCn,
					          schdlBgngTm: event.schdlBgngTm,
					          schdlEndTm: event.schdlEndTm
					        }
						};
		            });
		            calendar.removeAllEvents();
		            calendar.addEventSource(events);
		        }
			})
		})
		
		//기본 상태
		$("#modal").hide(); //일정 추가 모달
		$("#updateModal").hide(); //일정 수정 모달
		
		//등록 버튼 클릭 시 일정 추가
		$("#confirm").on("click", function(event) {
			let isValid = true;

			// 종일 체크 여부 확인
		    const isAllDayChecked = $("#allDayCheck").is(":checked");

		    // 필수 입력 필드 중 값이 없는 경우 처리
		    $("#insertForm input[required]").each(function() {
		        // 종일 체크 시 시간 필드는 무시
		        if (!$(this).is(":disabled") && !$(this).is("[readonly]") && !isAllDayChecked && $(this).val() === "") {
		            $(this).addClass("border-red-500");  // 보더를 빨간색으로 변경
		            isValid = false;
		        } else {
		            $(this).removeClass("border-red-500");  // 보더 색상 초기화
		        }
		    });

		    // 종일 체크 시 시간을 검사하지 않도록 조건 추가
		    if (!isValid && !isAllDayChecked) {
		        Swal.fire({
		            title: '시간을 입력해 주세요.',
		            icon: 'warning',
		            confirmButtonColor: '#4E7DF4',
		            confirmButtonText: '확인',
		        });
		    } else {
		        confirm();
		    }
		});
		
		//닫기 버튼 클릭 시 모달 닫힘
		$("#close").on("click", function() {
			$("#modal").hide();
		});
		
		//수정 모달 닫기 버튼 클릭 시 모달 닫힘
		$("#updateClose").on("click", function() {
			$("#updateModal").hide();
		});

		//일정 추가 모달 내의 종일 체크박스 체크 시
		$("#allDayCheck").on("change", function() {
			//시간 필드 disabled
			if ($(this).is(":checked")) {
				var startDate = $("#schdlBgngYmd").val();
		        var endDate = $("#schdlEndYmd").val();

		        if (startDate === endDate) {
		            // 당일 일정인 경우: 종료 시간 비우기
		            $("#schdlBgngTm").val("09:00").attr("readonly", true).removeAttr("required");
		            $("#schdlEndTm").val("").attr("readonly", true).removeAttr("required");
		        } else {
		            // 당일 일정이 아닌 경우: 09:00 기본값 설정
		            $("#schdlBgngTm").val("09:00").attr("readonly", true).removeAttr("required");
		            $("#schdlEndTm").val("09:00").attr("readonly", true).removeAttr("required");
		        }
		    } else {
		        // 종일 체크 해제 시
		        $("#schdlBgngTm").val("").attr("readonly", false).attr("required", "required");
		        $("#schdlEndTm").val("").attr("readonly", false).attr("required", "required");
		    }
		});
		
		//수정 버튼 클릭 시
		$("#updateConfirm").on("click", function() {
			let isValid = true;
/* 
		    // 필수 입력 필드 중 값이 없는 경우 처리
		    $("#updateForm input[required]").each(function() {
		    	// input이 disabled 상태가 아니고 readonly 상태가 아닌 경우에만 검사
		        if (!$(this).is(":disabled") && !$(this).is("[readonly]") && $(this).val() === "") {
		            $(this).addClass("border-red-500");  // 보더를 빨간색으로 변경
		            isValid = false;
		        } else {
		            $(this).removeClass("border-red-500");  // 보더 색상 초기화
		        }
		    }); */

		    //시간 입력 안 하면
		    if (!isValid) {
		        Swal.fire({
		            title: '시간을 입력해 주세요',
		            icon: 'warning',
		            confirmButtonColor: '#4E7DF4',
		            confirmButtonText: '확인',
		        });
		    } else {
		        //입력하면 확인 후 폼 제출
				Swal.fire({
					title: '일정을 수정하시겠습니까?',
			        icon: 'warning',
			        showCancelButton: true,
			        confirmButtonColor: '#4E7DF4',
			        confirmButtonText: '확인',
			        cancelButtonText: '취소',
			        reverseButtons: true,
			    }).then((result) => {
			        if(result.isConfirmed) {
			        	Swal.fire({
			                title: '일정 수정이 완료되었습니다.',
			                icon: 'success',
			                confirmButtonColor: '#4E7DF4',
			                confirmButtonText: '확인',
			                reverseButtons: true,
			            }).then((result) => {
			                if (result.isConfirmed) {
					            $("#updateForm").submit();
			                }
			            });
			        }
			    });
		    }
		})
		
		//삭제 버튼 클릭 시
		$("#deleteBtn").on("click", function(schdlNo) {
			var schdlNo = $("#updateSchdlNo").val();
			
			Swal.fire({
				title: '일정을 삭제하시겠습니까?',
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#4E7DF4',
				confirmButtonText: '삭제',
				cancelButtonText: '취소',
				reverseButtons: true,
			}).then((result) => {
				if(result.isConfirmed) {Swal.fire({
	                title: '일정 삭제가 완료되었습니다.',
	                icon: 'success',
	                confirmButtonColor: '#4E7DF4',
	                confirmButtonText: '확인',
	                reverseButtons: true,
	            }).then((result) => {
	                if (result.isConfirmed) {
						$.ajax({
							url: '/deleteEvents',
							type: 'post',
							data: {schdlNo: schdlNo},
							beforeSend: function(xhr) {
			                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰을 헤더에 추가
			                },
							success: function() {
								window.location.href = '/calendarList';
							}
						})
	                }
	            });
				}
			})
		})
		
		//일정 수정 모달에서 종일 체크박스 클릭 시
		var originalStartTime = ''; 
		var originalEndTime = '';
		
		$("#updateAllDayCheck").on("change", function() {
			var startDate = $("#updateSchdlBgngYmd").val();
		    var endDate = $("#updateSchdlEndYmd").val();
		    
		    if ($(this).is(":checked")) {
		        //시간 입력 필드 비활성화
		        originalStartTime = $("#updateSchdlBgngTm").val();
        		originalEndTime = $("#updateSchdlEndTm").val();
        		if (startDate === endDate) {
       	            // 당일 일정인 경우: 종료 시간 비우기
       	            $("#updateSchdlBgngTm").val("09:00").attr("readonly", true);
       	            $("#updateSchdlEndTm").val("").attr("readonly", true);
        		 } else {
        			// 당일 일정이 아닌 경우: 09:00 기본값 설정
       	            $("#updateSchdlBgngTm").val("09:00").attr("readonly", true);
       	            $("#updateSchdlEndTm").val("09:00").attr("readonly", true);
        		 }
		    } else {
		        //시간 입력 필드 활성화
		        $("#updateSchdlBgngTm").val(originalStartTime).attr("readonly", false);
        		$("#updateSchdlEndTm").val(originalEndTime).attr("readonly", false);
		    }
		});
		
		//추가 모달 팔레트에 체크 추가
        $('.color-box').on('click', function() {
            // 기존 선택된 체크 제거
            $('.color-box').removeClass('selected');
            // 클릭된 요소에 체크 추가
            $(this).addClass('selected');

            // 선택된 색상을 hidden input에 저장
            var color = $(this).data('color');
            $('#backColor').val(color);
        });
		
		//수정 모달 팔레트에 체크 추가
        $('.update-color-box').on('click', function() {
            // 기존 선택된 체크 제거
            $('.update-color-box').removeClass('selected');
            // 클릭된 요소에 체크 추가
            $(this).addClass('selected');

            // 선택된 색상을 hidden input에 저장
            var color = $(this).data('color');
            $('#updateBackColor').val(color);
        });
		
        //페이지가 처음 로드되면 전체 버튼에 selected 클래스 추가
        $("#all").addClass("filterSelected");

        //모든 버튼 클릭 이벤트 설정
        $(".filter-link").on("click", function(e) {
            e.preventDefault();
            
            //모든 버튼에서 selected 클래스 제거
            $(".filter-link").removeClass("filterSelected");

            //클릭한 버튼에 selected 클래스 추가
            $(this).addClass("filterSelected");
        });
        
	});
	
	//날짜 일요일부터 시작, 주말 색 바꿈
	function calendar_rendering() {
		calendar = new FullCalendar.Calendar(calendarEl, {
			initialView : "dayGridMonth",
			firstDay : 0,
			
		});
		calendar.render();
	}
	
	//툴팁 외부 영역 클릭 시 닫음
	$(document).on("mousedown", function(e) {
		var tooltip = $("#eventTooltip");
		if(!$(e.target).closest("#eventTooltip").length && !$(e.target).closest(".fc-event").length) {
			tooltip.hide();
		}
	})
	
</script>

<title></title>
</head>
<body>

	<!-- 메인 영역 -->
	<div id="entire">
		<div id="category" class="ml-4 mt-4 font-semibold text-gray-900">
		<div class="inline-flex rounded-md" role="group">
			<a href="#" id="all" class="filter-link px-2.5 py-1 rounded-l-lg border border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2">
				전체
			</a>
			<a href="#" id="common" class="filter-link px-2.5 py-1 border-t border-b border-r border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2">
				공통
			</a>
			<a href="#" id="dept" class="filter-link px-2.5 py-1 border-t border-b border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2">
				부서
			</a>
			<a href="#" id="per" class="filter-link px-2.5 py-1 rounded-r-md border border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2">
				개인
			</a>
		</div>
		    <div class="tooltip-right mt-1" data-tooltip="날짜 영역 클릭 시 일정 추가, 일정 영역 클릭 시 수정이 가능해요">
		          <i class="fas fa-question-circle" focusable="false" aria-hidden="true"></i>
		     </div>
		</div>
		<div id="calendar" class="mb-4" ></div>
	</div>

	<!-- 일정 수정 모달 -->
	<form id="updateForm" name="updateForm" action="/updateEvents?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
	<input type="hidden" value="${empVO.empNo}">
	<input type="hidden" id="updateSchdlNo" name="schdlNo" value="${calendarVO.schdlNo}">
	<div class="relative z-10" id="updateModal" aria-labelledby="modal-title" role="dialog" aria-modal="true">
	  <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
	
	  <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
	    <div class="flex min-h-full items-center justify-center p-4 text-center">
	      <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:max-w-3xl sm:w-full">
	        
	        <div class="bg-white px-4 pb-4 pt-4 sm:p-6">
	        	<div class="flex justify-between items-center">
		        	<span class="ml-1 text-lg font-bold mb-3 block">일정 수정</span>
		        	<button type="button" id="deleteBtn" class="mr-1 mb-3 inline-flex justify-center text-sm font-semibold">
		        		<i class="fa-solid fa-trash w-[20px] h-[20px]"></i>
		        	</button>
	        	</div>
				  <hr class="px-4 py-2">
			  <table style="width: 100%;">
			    <tr>
			    <td class="py-2" style="text-align: left; padding-right: 10px;">
			    	<!-- 배경색 선택 -->
		            <label for="backColor" class="w-[80px] text-gray-900">색상<span class="text-red"> *</span></label>
		        </td>
		        <td>
					<div class="flex items-center space-x-3" id="updateColorPalette">
					    <div class="update-color-box" data-color="#fa573b" style="background-color: #fa573b;"></div>
					    <div class="update-color-box" data-color="#ffad46" style="background-color: #ffad46;"></div>
					    <div class="update-color-box" data-color="#fbe983" style="background-color: #fbe983;"></div>
					    <div class="update-color-box" data-color="#b3dc6c" style="background-color: #b3dc6c;"></div>
					    <div class="update-color-box" data-color="#16a765" style="background-color: #16a765;"></div>
					    <div class="update-color-box" data-color="#9fc6e7" style="background-color: #9fc6e7;"></div>
					    <div class="update-color-box" data-color="#4e7df4" style="background-color: #4e7df4;"></div>
					    <div class="update-color-box" data-color="#b99aff" style="background-color: #b99aff;"></div>
					    <div class="update-color-box" data-color="#9a9cff" style="background-color: #9a9cff;"></div>
					    <div class="update-color-box" data-color="#cd74e6" style="background-color: #cd74e6;"></div>
					    <div class="update-color-box" data-color="#f691b2" style="background-color: #f691b2;"></div>
					    <div class="update-color-box" data-color="#000000" style="background-color: #000000;"></div>
					</div>
					<input type="hidden" id="updateBackColor" name="backColor"/>
				</td>
				</tr>
			    <tr>
			      <td class="py-2 w-[80px]" style="text-align: left;">
			        <label for="schdlNm" class="text-base font-semibold leading-6 text-gray-900" id="modal-title">일정명<span class="text-red"> *</span></label>
			      </td>
			      <td>
			        <input type="text" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5"
			               name="schdlNm" id="updateSchdlNm" placeholder="일정을 입력해 주세요" required>
			      </td>
			    </tr>
			   <tr>
				  <td class="py-2 w-[80px]" style="text-align: left;">
				    <label for="schdlBgngYmd" class="text-base font-semibold leading-6 text-gray-900" id="modal-title">일시<span class="text-red"> *</span></label>
				  </td>
				  <td>
				    <div class="flex items-center">
				      <input type="date" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5 mr-1.5"
				             name="schdlBgngYmd" id="updateSchdlBgngYmd" required> 
				      <input type="time" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5"
				             name="schdlBgngTm" id="updateSchdlBgngTm" required>
				             
				      <span class="ml-1 mr-1">-</span>
				      
				      <input type="date" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5 mr-1.5"
				             name="schdlEndYmd" id="updateSchdlEndYmd">
				      <input type="time" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5"
				             name="schdlEndTm" id="updateSchdlEndTm">
				      <label class="ml-2 mt-2 flex items-center">
				        <input type="checkbox" id="updateAllDayCheck" class="form-checkbox">
				        <span class="ml-1 text-sm font-semibold">종일</span>
				      </label>
				    </div>
				  </td>
				</tr>
				<tr>
				    <td class="py-2" style="text-align: left;">
				    	<input type="hidden" name="schdlCd" value="${schdlCd}"/>
				        <label for="userCd" class="text-base font-semibold leading-6 text-gray-900 w-[80px]" id="update-modal-title">분류<span class="text-red"> *</span></label>
				    </td>
				    <td>
				        <div class="flex-container">
				            <select name="userCd">
				            	<option value="A03-001">개인</option>
				            	<c:if test="${empVO.deptCd == 'A17-001'}">
					            	<option value="A17-001">경영진</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-003'}">
					            	<option value="A17-003">관리부</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-002'}">
					            	<option value="A17-002">기획부</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-004'}">
					            	<option value="A17-004">영업부</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-005'}">
					            	<option value="A17-005">인사부</option>
					            </c:if>
					            <option value="A03-006" <c:if test="${empVO.deptCd != 'A17-002'}">disabled</c:if>>공통</option>
				            </select>
				        </div>
				    </td>
				</tr>
			    <tr>
			      <td class="py-2" style="text-align: left;">
			        <label for="schdlCn" class="text-base font-semibold leading-6 text-gray-900 w-[80px]" id="modal-title">내용</label>
			      </td>
			      <td>
			        <input type="text" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5"
			               name="schdlCn" id="updateSchdlCn" placeholder="내용을 입력해 주세요">
			      </td>
			    </tr>
			    <tr>
				  <td class="py-2" style="text-align: left;">
				    <label for="schdlPlc" class="text-base font-semibold leading-6 text-gray-900 w-[80px]" id="modal-title">장소</label>
				  </td>
				  <td>
				    <div class="flex items-center">
				      <input type="text" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5"
				             name="schdlPlc" id="updateSchdlPlc" placeholder="장소를 입력해 주세요" required>
				    </div>
				  </td>
				</tr>
			  </table>
				    <div id="mapImg" style="display:none;">
				    </div>
			</div>

	        <div class="bg-gray-50 px-4 py-3 flex justify-center">
	          <button type="button" id="updateClose" class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">취소</button>
	          <button type="button" id="updateConfirm" class="inline-flex justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">확인</button>
	        </div>
	      </div>
	    </div>
	  </div>
	</div>
	<sec:csrfInput/>
	</form>
	<!-- 일정 수정 모달 끝 -->
	
	<!-- 일정 추가 모달 -->
	<form id="insertForm" name="insertForm" action="/insertEvents?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
	<input type="hidden" value="${empVO.empNo}">
	<div class="relative z-10" id="modal" aria-labelledby="modal-title" role="dialog" aria-modal="true">
	  <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
	
	  <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
	    <div class="flex min-h-full items-center justify-center p-4 text-center">
	      <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:max-w-3xl sm:w-full">
	        
	        <div class="bg-white px-4 pb-4 pt-4 sm:p-6">
	        <span class="ml-1 text-lg font-bold mb-3 block">일정 추가</span>
			  <hr class="px-4 py-2">
			  <!-- 여기서부터 수정하기 -->
			  <table style="width: 100%;">
			    <tr>
			    <td class="py-2" style="text-align: left; padding-right: 10px;">
			    	<!-- 배경색 선택 -->
		            <label for="backColor" class="text-gray-900 w-[80px]">색상<span class="text-red"> *</span></label>
		        </td>
		        <td>
					<div class="flex items-center space-x-3" id="colorPalette">
					    <div class="color-box" data-color="#fa573b" style="background-color: #fa573b;"></div>
					    <div class="color-box" data-color="#ffad46" style="background-color: #ffad46;"></div>
					    <div class="color-box" data-color="#fbe983" style="background-color: #fbe983;"></div>
					    <div class="color-box" data-color="#b3dc6c" style="background-color: #b3dc6c;"></div>
					    <div class="color-box" data-color="#16a765" style="background-color: #16a765;"></div>
					    <div class="color-box" data-color="#9fc6e7" style="background-color: #9fc6e7;"></div>
					    <div class="color-box" data-color="#4e7df4" style="background-color: #4e7df4;"></div>
					    <div class="color-box" data-color="#b99aff" style="background-color: #b99aff;"></div>
					    <div class="color-box" data-color="#9a9cff" style="background-color: #9a9cff;"></div>
					    <div class="color-box" data-color="#cd74e6" style="background-color: #cd74e6;"></div>
					    <div class="color-box" data-color="#f691b2" style="background-color: #f691b2;"></div>
					    <div class="color-box" data-color="#000000" style="background-color: #000000;"></div>
					</div>
					<input type="hidden" id="backColor" name="backColor"/>
				</td>
				</tr>
			    <tr>
			      <td class="py-2 w-[80px]" style="text-align: left;">
			        <label for="schdlNm" class="text-base font-semibold leading-6 text-gray-900" id="modal-title">일정명<span class="text-red"> *</span></label>
			      </td>
			      <td>
			        <input type="text" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg block p-2.5 w-full"
			               name="schdlNm" id="schdlNm" placeholder="일정을 입력해 주세요" required>
			      </td>
			    </tr>
			   <tr>
				  <td class="py-2 w-[80px]" style="text-align: left;">
				    <label for="schdlBgngYmd" class="text-base font-semibold leading-6 text-gray-900" id="modal-title">일시<span class="text-red"> *</span></label>
				  </td>
				  <td>
				    <div class="flex items-center">
				      <input type="date" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5 mr-1.5"
				             name="schdlBgngYmd" id="schdlBgngYmd" required> 
				      <input type="time" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5"
				             name="schdlBgngTm" id="schdlBgngTm" required>
				             
				      <span class="ml-1 mr-1">-</span>
				      
				      <input type="date" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5 mr-1.5"
				             name="schdlEndYmd" id="schdlEndYmd">
				      <input type="time" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg p-2.5"
				             name="schdlEndTm" id="schdlEndTm">
				      <label class="ml-2 mt-2 flex items-center">
				        <input type="checkbox" id="allDayCheck" class="form-checkbox">
				        <span class="ml-1 text-sm font-semibold">종일</span>
				      </label>
				    </div>
				  </td>
				</tr>
				<tr>
				    <td class="py-2" style="text-align: left;">
				    	<input type="hidden" name="schdlCd" value="${schdlCd}"/>
				        <label for="userCd" class="text-base font-semibold leading-6 text-gray-900 w-[80px]" id="modal-title">분류<span class="text-red"> *</span></label>
				    </td>
				    <td>
				        <div class="flex-container">
				            <select name="userCd">
				            	<option value="A03-001">개인</option>
				            	<c:if test="${empVO.deptCd == 'A17-001'}">
					            	<option value="A17-001">경영진</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-003'}">
					            	<option value="A17-003">관리부</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-002'}">
					            	<option value="A17-002">기획부</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-004'}">
					            	<option value="A17-004">영업부</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-005'}">
					            	<option value="A17-005">인사부</option>
					            </c:if>
					            <c:if test="${empVO.deptCd == 'A17-002'}">
				            		<option value="A03-006">공통</option>
				            	</c:if>
				            </select>
				        </div>
				    </td>
				</tr>
			    <tr>
			      <td class="py-2" style="text-align: left;">
			        <label for="schdlCn" class="text-base font-semibold leading-6 text-gray-900 w-[80px]" id="modal-title">내용</label>
			      </td>
			      <td>
			        <input type="text" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg block p-2.5 w-full"
			               name="schdlCn" id="schdlCn" placeholder="내용을 입력해 주세요">
			      </td>
			    </tr>
			    <tr>
				  <td class="py-2" style="text-align: left;">
				    <label for="schdlPlc" class="text-base font-semibold leading-6 text-gray-900 w-[80px]" id="modal-title">장소</label>
				  </td>
				  <td>
				    <div class="flex items-center">
				      <input type="text" class="bg-white-50 border border-gray-300 text-gray-900 text-sm rounded-lg block p-2.5 w-full"
				             name="schdlPlc" id="schdlPlc" placeholder="장소를 입력해 주세요" required>
				    </div>
				  </td>
				</tr>
			  </table>
				    <div id="mapImg" style="display:none;">
				    </div>
			</div>

	        <div class="bg-gray-50 px-4 py-3 flex justify-center">
	          <button type="button" id="close" class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">취소</button>
	          <button type="button" id="confirm" class="inline-flex justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">등록</button>
	        </div>
	      </div>
	    </div>
	  </div>
	</div>
	<sec:csrfInput/>
	</form>
	<!-- 일정 추가 모달 끝 -->
	
	<!-- 툴팁 시작 -->
	<div id="eventTooltip" style="display:none; position:absolute; z-index:1000; background-color:white; border:1px solid #ccc; padding:15px; border-radius:5px;">
		<span id="tooltipTitle" style="font-weight:bold;"></span>
		<br>
		<span id="tooltipTime"></span>
		<br><br>
	</div>
</body>
</html>