<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page session="false" %>
<!-- 로그인 후 정보 확인 시작 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!-- 로그인 후 정보 확인 끝 -->
<!DOCTYPE html>
<html>
<link rel="stylesheet" href="/resources/adminlte3/dist/css/adminlte.min.css">
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="dns-prefetch" href="//unpkg.com" />
<link rel="dns-prefetch" href="//cdn.jsdelivr.net" />
<link rel="stylesheet" href="https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css">
<script src="https://cdn.jsdelivr.net/gh/alpinejs/alpine@v2.x.x/dist/alpine.js" defer></script>
<link href="/resources/css/mainPage.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
	
	// 체크함수
	function fayoungChk(){
		//출근 시각 기록되어 있으면
		let attTime = $("#attendTime").find("#inTime").html();
		console.log("체킁2: ",attTime);
		if(attTime != "-") {
			//출근 버튼 삭제
			$("#attendBtn").remove();
			//퇴근 버튼 보이기
			$("#lvWrkBtn").css("display", "block");
		}

		let lvfTime = $("#lvffcTime").find("#outTime").html();		
		
		console.log("체킁3: ",lvfTime);		
		//퇴근 시각 기록되어 있으면
		if(lvfTime != "-") {
			//퇴근 버튼 disabled
			$("#lvWrkBtn").attr("disabled", true);
		}	
	}
	
	$(document).ready(function() {
			
		//달력 전체 보기 버튼 클릭 시
		$("#calendarBtn").on("click", function() {
			window.location.href = "/calendarList";
		})
		
		///---------------------달력 코드--------------------------
		var today = new Date();
        var currentMonth = today.getMonth();
        var currentYear = today.getFullYear();

        // 달력 렌더링 함수
        function renderCalendar(month, year) {
            var firstDay = new Date(year, month).getDay();
            var daysInMonth = new Date(year, month + 1, 0).getDate();
            var monthNames = ["January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
            
            $('#calendarDates').empty(); // 달력 초기화
            $('#monthName').text(monthNames[month] + ' ' + year); // 월 이름 설정
            
            // 빈 칸 추가 (첫째 날 요일 전까지)
            for (var i = 0; i < firstDay; i++) {
                $('#calendarDates').append('<div></div>');
            }
            
            // 날짜 채우기
            for (var day = 1; day <= daysInMonth; day++) {
                var dateElement = $('<div></div>').text(day).addClass('p-2 hover:bg-gray-200');
                
                // 오늘 날짜 강조
                if (day === today.getDate() && month === today.getMonth() && year === today.getFullYear()) {
                    dateElement.addClass('bg-[#4E7DF4] text-white rounded-full');
                }
                
                $('#calendarDates').append(dateElement);
            }
        }

        // 이전 달 버튼 클릭 이벤트
        $('#prevMonth').click(function() {
            if (currentMonth === 0) {
                currentMonth = 11;
                currentYear--;
            } else {
                currentMonth--;
            }
            renderCalendar(currentMonth, currentYear);
        });

        // 다음 달 버튼 클릭 이벤트
        $('#nextMonth').click(function() {
            if (currentMonth === 11) {
                currentMonth = 0;
                currentYear++;
            } else {
                currentMonth++;
            }
            renderCalendar(currentMonth, currentYear);
        });

        // 초기 렌더링
        renderCalendar(currentMonth, currentYear);
        
        
        
     
       
		//-----------------------------------------------
        
        
        
		
		//버튼으로 출근
		if (sessionStorage.getItem("showToastIn") === "true") {
	        Swal.fire({
	            toast: true,
	            icon: 'success',
	            title: '출근 체크가 완료되었습니다.',
	            position: 'top-end',
	            showConfirmButton: false,
	            timer: 2000,
	            timerProgressBar: true,
	            didOpen: (toast) => {
	                toast.addEventListener('mouseenter', Swal.stopTimer);
	                toast.addEventListener('mouseleave', Swal.resumeTimer);
	            }
	        });
	        sessionStorage.removeItem("showToastIn");
	    }
		
		//퇴근 체크
		if (sessionStorage.getItem("showToastOut") === "true") {
	        Swal.fire({
	            toast: true,
	            icon: 'success',
	            title: '퇴근 체크가 완료되었습니다.',
	            position: 'top-end',
	            showConfirmButton: false,
	            timer: 2000,
	            timerProgressBar: true,
	            didOpen: (toast) => {
	                toast.addEventListener('mouseenter', Swal.stopTimer);
	                toast.addEventListener('mouseleave', Swal.resumeTimer);
	            }
	        });
	        sessionStorage.removeItem("showToastOut");
	    }
		
		//큐알로 출근
		if (sessionStorage.getItem("showToastQr") === "true") {
	        Swal.fire({
	            toast: true,
	            icon: 'success',
	            title: '출근 체크가 완료되었습니다.',
	            position: 'top-end',
	            showConfirmButton: false,
	            timer: 2000,
	            timerProgressBar: true,
	            didOpen: (toast) => {
	                toast.addEventListener('mouseenter', Swal.stopTimer);
	                toast.addEventListener('mouseleave', Swal.resumeTimer);
	            }
	        });
	        sessionStorage.removeItem("showToastQr");
	    }
		
		//출근 상태 초기값
		let attendSuccess = false;
		
		//출근 버튼 클릭 시
		$("#attendBtn").on("click", function() {
			
			$("#qrModal").show();
			
			//qr 이미지 삽입(링크는 컨트롤러에서 만들어 줌)
			$("#qrImg").attr("src", "${pageContext.request.contextPath}/createQr");
			
			//버튼으로 출근 클릭 시 출근 시각 update
			$("#attBtn").on("click", function() {
				$.ajax({
					url: "/updateAttendBtnAjax",
					contentType: "text/plain;charset=utf-8",
					data: ${empVO.empNo},
					type: "get",
					dataType:"json",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
					success: function(result){
						console.log("result: ", result);
						
						if(result === 1) {
							$("#qrModal").hide();
							
							sessionStorage.setItem("showToastIn", "true");
							
							window.location.reload();
							
						} 
					}
				})
			})		 
		})

		//퇴근 버튼 클릭 시 퇴근 시각 update
		$("#lvWrkBtn").on("click", function() {
			$.ajax({
				url: "/updateLvffcAjax",
				contentType: "application/json;charset=utf-8",
				data: JSON.stringify({empVO: "${empVO.empNo}"}),
				type: "post",
				dataType:"json",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success: function(result){
					console.log("result: ", result);
					
					if(result === 1) {
						$("#qrModal").hide();
						
						sessionStorage.setItem("showToastOut", "true");
						
						window.location.reload();
						
					}
				},
			})
		})
		
		//확인 버튼 클릭 시 큐알 모달 닫힘
		$("#okey").on("click", function() {
			$("#qrModal").hide();
			
			sessionStorage.setItem("showToastQr", "true");
			
			window.location.reload();
		})
		
		//닫기 버튼 클릭 시 큐알 모달 닫힘
		$("#close").on("click", function() {
			$("#qrModal").hide();
		})
		
		//ESC 누를 때 출근 큐알 모달 닫힘
		$(document).on("keydown", function(event) {
			if (event.key === "Escape") {
				$("#qrModal").hide();
			}
		})
		
		///////////////////////////////////////////////////////////////////////// 대쉬 보드 주요 기능 시작
		var today = new Date();
		
		var dateString = today.getFullYear() + "년 " + ('0' + (today.getMonth() + 1)).slice(-2)  + "월 " + ('0' + today.getDate()).slice(-2) + "일";
		
		$("#sysDate").text(dateString);
		
		let deptCd = "${empVO.deptCd}"; // 부서 코드
		let jbgdCd = "${empVO.jbgdCd}"; // 직급 코드
		
		let data = {
				"clsfCd1" : deptCd,
				"clsfCd2" : jbgdCd,     
		}
		
		$.ajax({
			url:"/tiles/getDept",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
				if(res[1].clsfNm == '부장') {
					$("#empDeptCd").text(res[0].clsfNm  + " / 팀장");
					$("#empJbgdCd").text("${empVO.empNm} " + "팀장님");
				} else {
					$("#empDeptCd").text(res[0].clsfNm  + " / " + res[1].clsfNm);
					$("#empJbgdCd").text("${empVO.empNm} " + res[1].clsfNm + "님");
				}
			}
		})
		
		$.ajax({
			url:"/getEmpAttendTime",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(${empVO.empNo}),
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
				console.log("체킁:",res);
				
				if(res.attendTm) $("#inTime").text(res.attendTm);
				if(res.lvffcTm) $("#outTime").text(res.lvffcTm);
			
				fayoungChk();
				
			}
		})
		
		$.ajax({
			url:"/getNoticeImprtnc",
			type:"get",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
			    let html = '';
			    
			    $.each(res, function(idx, noticeVO) {
			        html += '<blockquote class="blockQuoteRebon" style="display:flex; justify-content: space-between; margin: 10px 0px; heigth:10px; padding:0px;">';
			        html += '<a href="/noticeDetail?ntcNo=' + noticeVO.ntcNo + '" style="color: #434343; margin-left:10px;">' + noticeVO.ntcTtl + '</a>';
			        html += '<span style="color: #9F9F9F; font-size:14px; margin-right:10px;">' + noticeVO.strRegDt + '</span>';
			        html += '</blockquote>';
			    });
			    $("#ntcIn").append(html);
			    
				$(".blockQuoteRebon").css({
				    "border-left-width": "3px",
				    "border-left-color": "#4E7DF4",
				    "border-left-style": "solid",
				    "padding-left": "10px"
				});
				
				$.ajax({
					url:"/getNotice",
					type:"get",
					dataType:"json",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
					success:function(res){
					    let html = '';
					    
					    $.each(res, function(idx, noticeVO) {
					        html += '<blockquote class="blockQuoteNoRebon" style="display:flex; justify-content: space-between; margin: 10px 0px; heigth:10px; padding:0px;">';
					        html += '<a href="/noticeDetail?ntcNo=' + noticeVO.ntcNo + '" style="color: #434343; margin-left:10px;">' + noticeVO.ntcTtl + '</a>';
					        html += '<span style="color: #9F9F9F; font-size:14px; margin-right:10px;">' + noticeVO.strRegDt + '</span>';
					        html += '</blockquote>';
					    });
					    $("#ntcIn").append(html);
					    
					    $(".blockQuoteNoRebon").css({
					    	"border-left": "none",
					    	"padding-left": "13px"
					    });
					    
					}
				})
			}
		})
		
// 			contentType:"text/plain;charset=utf-8",  // 문자열 데이터를 보내므로 contentType을 text/plain으로 변경
		$.ajax({
			url: "/getAdreesTim",
		    contentType: "application/json;charset=utf-8",
		    data: JSON.stringify({
		        deptCd: "${empVO.deptCd}",
		        jbttlCd: "${empVO.jbttlCd}",
		        empNo: "${empVO.empNo}"
		    }),
		    type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
				console.log("res", res);
				
				let html = '';
				
				$.each(res, function(idx, employeeVO) {
				    html += '<div style="display: flex; justify-content: space-between; align-items: center; margin-top:5px;">'
				    html += '<div style="display: flex; align-items: center;">'
				    html += '<img src="data:image/png;base64,' + employeeVO.proflPhoto + '" class="img-circle" style="width: 60px; height: 60px; margin: 10px;">'
				    html += '<div style="margin-left: 10px;">';
				    
				    if(employeeVO.jbttlNm == '팀장'){
					    html += '<strong style="font-size: 16px; display: block; color:#434343;">' + employeeVO.deptNm + " " + employeeVO.empNm + " " + employeeVO.jbttlNm + '</strong>';
				    } else {
					    html += '<strong style="font-size: 16px; display: block; color:#434343;">' + employeeVO.deptNm + " " + employeeVO.empNm + " " + employeeVO.jbgdNm + '</strong>';
				    }
				    
				    html += '<span style="font-size: 13px; color:#434343;">소개 : ' + employeeVO.empIntrcn + '</span>';
				    html += '</div>'
				    html += '</div>'
				    html += '<div>'
				    html += '<button class="img-circle" style="width: 30px; height: 30px; background-color:#DCE8FE; margin:0 5px;"><i class="fa-solid fa-comment-dots"></i></button>';
				    html += '<button class="img-circle" style="width: 30px; height: 30px; background-color:#DCE8FE; margin:0 5px; margin-right:20px;" onclick="window.open(\'http://localhost/cmmn/mail/send\', \'메일 전송\', \'width=900,height=900\');"><i class="fa-solid fa-envelope"></i></button>'
				    html += '</div></div>';
				})

				$("#adreesTim").html(html);
			}
		})
		
		///////////////////////////////////////////////////////////////////////// TODO
		
		loadTodoList();
		
		// Add Todo
		$("#todoInput").on('keypress', function(e) {
	    if (e.which === 13) { // 엔터키가 눌렸을 때
	        e.preventDefault(); // 기본 엔터 동작 방지
	        
	        let todoText = $(this).val().trim();
	        if (todoText !== "") {
	            // 기존의 할 일 추가 로직과 동일한 처리
	            let todoData = {
	                goalNm: todoText,
	                delYn: 'N'
	            };
	            
	            $.ajax({
	                url: '/todoList/insertTodo',
	                type: 'POST',
	                contentType: 'application/json',
	                data: JSON.stringify(todoData),
	                beforeSend: function(xhr) {
	                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	                },
	                success: function(response) {
	                    if (response.status === "SUCCESS") {
	                        let newTodoItem = 
	                            '<li class="todo-item" data-listno="' + response.listNo + '">' +
	                                '<div class="todo-content">' +
	                                    '<input type="checkbox" id="todo-' + response.listNo + '" class="todo-checkbox" />' +
	                                    '<label for="todo-' + response.listNo + '" class="thin-label">' + todoData.goalNm + '</label>' +
	                                '</div>' +
	                                '<div class="todo-buttons">' +
	                                    '<button class="upBtn"><i class="fa-solid fa-pen-to-square cls1" style="color: #a3a3a3;"></i></button>' +
	                                    '<button class="delBtn"><i class="fa-solid fa-trash-can cls2" style="color: #a3a3a3;"></i></button>' +
	                                '</div>' +
	                            '</li>';
	                            
	                        $("#todoList").append(newTodoItem);
	                        $("#todoInput").val(''); // 입력창 비우기
	                        
	                        // 새 항목이 추가된 후 스크롤을 맨 아래로 이동
	                        let todoListContainer = document.getElementById('todoList');
	                        todoListContainer.scrollTop = todoListContainer.scrollHeight;
	                    } else {
	                        alert("할 일 추가에 실패했습니다.");
	                    }
	                }
	            });
	        }
	    }
	});

	
	    // Delete Todo
	    $(document).on("click", ".delBtn", function() {
	        let listItem = $(this).closest('li');
	        let listNo = listItem.data('listno');
	        
	        $.ajax({
	            url: '/todoList/deletePost',
	            type: 'POST',
	            data: { listNo: listNo },
	            beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
	            success: function(response) {
	                listItem.remove();
	            }
	        });
	    });
	
	 // Update Todo
		$(document).on("click", ".upBtn", function () {
		    let listItem = $(this).closest('li'); // 해당 li 항목 선택
		    let label = listItem.find('label');   // 기존 텍스트(label) 선택
		    let currentText = label.text();       // 현재 텍스트 가져오기
		    
		    // 수정용 입력 필드 생성
		    let inputField = $('<input type="text" class="edit-input" value="' + currentText + '">');
		    label.hide().after(inputField); // 기존 텍스트 숨기고 입력 필드 추가
		    inputField.focus();             // 입력 필드에 포커스
		
		    // **blur** 시 (포커스가 벗어날 때) 수정 처리
		    inputField.on('blur', function () {
		        let newText = $(this).val().trim(); // 입력된 텍스트 가져오기
		        if (newText !== "" && newText !== currentText) {
		            let listNo = listItem.data('listno'); // 해당 항목의 ID 가져오기
		            
		            // 서버에 수정 요청 보내기
		            $.ajax({
		                url: '/todoList/updatePost',
		                type: 'POST',
		                data: {
		                    listNo: listNo,
		                    goalNm: newText
		                },
		                beforeSend: function (xhr) {
		                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		                },
		                success: function (response) {
		                    label.text(newText).show(); // 수정된 텍스트 표시
		                    inputField.remove();        // 입력 필드 제거
		                }
		            });
		        } else {
		            label.show(); // 수정 내용이 없을 경우 원래 텍스트 표시
		            inputField.remove(); // 입력 필드 제거
		        }
		    });
		
		    // **Enter** 키 누를 때 blur 이벤트 트리거
		    inputField.on('keypress', function (e) {
		        if (e.which === 13) { // Enter 키
		            $(this).blur(); 
		        }
		    });
		});
	    
	 // checkSta
	    // 체크 상태 변경 처리
		$(document).on('change', '.todo-checkbox', function() {
		    let checkbox = $(this);
		    let listItem = checkbox.closest('.todo-item');
		    let listNo = listItem.data('listno');
		    
		    // UI 업데이트
		    if (checkbox.is(':checked')) {
		        listItem.addClass('completed');
		    } else {
		        listItem.removeClass('completed');
		    }
		    
		    $.ajax({
		        url: '/todoList/checkSta',
		        type: 'POST',
		        data: { listNo: listNo },
		        beforeSend: function(xhr) {
		            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		        },
		        success: function(response) {
		            if (response !== "SUCCESS") {
		                // 상태 업데이트 실패 시 UI 되돌림
		                checkbox.prop('checked', !checkbox.is(':checked'));
		                listItem.toggleClass('completed');
		            }
		        }
		    });
		});
		
		// 할 일 목록 로드 함수
		function loadTodoList() {
		    $.ajax({
		        url: '/todoList/list',
		        type: 'GET',
		        dataType: 'json',
		        success: function(response) {
		            $("#todoList").empty();
		            
		            $.each(response, function(index, todo) {
		                let isCompleted = todo.checkSta === 'Y';
		                
		                let todoItem = 
		                    '<li class="todo-item' + (isCompleted ? ' completed' : '') + 
		                    '" data-listno="' + todo.listNo + '" data-checksta="' + todo.checkSta + '">' +
		                        '<div class="todo-content">' +
		                            '<input type="checkbox" id="todo-' + todo.listNo + 
		                            '" class="todo-checkbox"' + (isCompleted ? ' checked' : '') + ' />' +
		                            '<label for="todo-' + todo.listNo + '" class="thin-label">' + 
		                            todo.goalNm + '</label>' +
		                        '</div>' +
		                        '<div class="todo-buttons">' +
		                            '<button class="upBtn"><i class="fa-solid fa-pen-to-square cls1" style="color: #a3a3a3;"></i></button>' +
		                            '<button class="delBtn"><i class="fa-solid fa-trash-can cls2" style="color: #a3a3a3;"></i></button>' +
		                        '</div>' +
		                    '</li>';
		
		                $("#todoList").append(todoItem);
		            });
		        }
		    });
		}
		
		$(document).on('change', '.todo-checkbox', function() {
		    let checkbox = $(this);
		    let listItem = checkbox.closest('.todo-item');
		    let listNo = listItem.data('listno');

		    // 체크박스 상태 변경 전에 UI 즉시 업데이트
		    if (checkbox.is(':checked')) {
		        // 체크박스가 체크된 경우 (checkSta를 'Y'로 변경)
		        listItem.addClass('completed');
		        $.ajax({
		            url: '/todoList/checkSta', // 기존 체크 완료 API
		            type: 'POST',
		            data: { listNo: listNo },
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
		            success: function(response) {
		                if (response !== "SUCCESS") {
		                    // 실패 시에만 UI 상태를 되돌림
		                    checkbox.prop('checked', false);
		                    listItem.removeClass('completed');
		                    alert("상태 업데이트에 실패했습니다.");
		                }
		            }
		        });
		    } else {
		        // 체크박스가 해제된 경우 (checkSta를 'N'으로 변경)
		        listItem.removeClass('completed');
		        $.ajax({
		            url: '/todoList/checkStaOff', // 체크 해제 API
		            type: 'POST',
		            data: { listNo: listNo },
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		            },
		            success: function(response) {
		                if (response !== "SUCCESS") {
		                    // 실패 시에만 UI 상태를 되돌림
		                    checkbox.prop('checked', true);
		                    listItem.addClass('completed');
		                }
		            }
		        });
		    }
		///////////////////////////////////////////////////////////////////////// 대쉬 보드 기능 끝
	
		
		
		})
	
	$(function(){
		///////////////////////////////////////////////////////////////////////// 메인 페이지 로딩 후 시작
		$("#seatBtn").on("click", function(){
			
			let text = $("#seatBtn").text();
			
			if(text == "자리 비움") {
				$.ajax({
					url:"/empSttusRunUpdate",
					contentType:"application/json;charset=utf-8",
					data:JSON.stringify(${empVO.empNo}),
					type:"post",
					dataType:"json",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
					success:function(res){
						$("#seatBtn").text("복귀하기");
					}
				})
			} else if(text == "복귀하기") {
				$.ajax({
					url:"/empSttusReturnUpdate",
					contentType:"application/json;charset=utf-8",
					data:JSON.stringify(${empVO.empNo}),
					type:"post",
					dataType:"json",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
					success:function(res){
						$("#seatBtn").text("자리 비움");
					}
				})
			}
		})
		
		////////////////////////////////////////////////////////////////////////////한줄소개
		$("#upDateIntrcn").on("click", function(){
			console.log("한줄소개업데이트");

	        $("#empIntrcnText").css("display", "none");
	        $("#empIntrcn").css("display", "block");

			$("#updatePostBtn").css("display", "flex");
		});
		
		$("#updateDel").on("click", function(){
			console.log("한줄소개업데이트 취소");

	        $("#empIntrcnText").css("display", "block");
	        $("#empIntrcn").css("display", "none");

			$("#updatePostBtn").css("display", "none");
		});
		
		$("#updatePost").on("click", function(){
			console.log("한줄소개업데이트실행");
			let empIntrcn = $('#empIntrcn').val();
			let empNo = ${employeeVO.empNo};

			console.log(empIntrcn);
			console.log(empNo);
			
			window.location.href = "/infoUpdatePost?empNo="+empNo+"&empIntrcn="+encodeURIComponent(empIntrcn);
		});
		////////////////////////////////////////////////////////////////////////////한줄소개
		
		
		
		
		$("#noticeBtn").on("click", function(){
			location.href= "/noticeList";
		})
		///////////////////////////////////////////////////////////////////////// 메인 페이지 로딩 후 끝
	});
});


</script>
<head>
<title>Home</title>
</head>
<body>
	<!-- 대쉬 보드 시작 -->
	<div class="dashboard">
		<div class="card user-info">
		<!-- 사용자 정보 및 출퇴근 관련 내용 -->
			<div style="border-right: 1px solid white; width: 50%;">
				<div style="display: flex;">
					<div style="display:flex; align-items: center;">
						<span>
							<img src="data:image/png;base64,${employeeVO.proflPhoto}" class="img-circle" style="width: 80px; height: 80px; display: inline-block; margin: 20px;">
						</span>
					</div>
					<div style="display: flex; flex-direction: column; justify-content: center; margin-left: 10px; line-height: 1.5; position: relative;">
						<strong id="empJbgdCd" style="font-size: 20px;"></strong>
						<p id="empDeptCd" style="font-size: 15px; margin-top: 3px; margin-bottom: 0px;"></p>
						 <div style="display: flex; align-items: center;">
						    <!-- 인풋 필드 -->
						    <input type="text" value="${employeeVO.empIntrcn}" id="empIntrcn" name="empIntrcn" 
						        class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 p-1.5 w-full" 
						        style="display: none;"/>
						    
						    <!-- 인풋 옆에 버튼 아이콘들 -->
						    <div id="updatePostBtn" class="flex items-center ml-2" style="display: none;">
						        <p id="updateDel" style="color: #ffffff; cursor: pointer;">x</p>
						        <i id="updatePost" class="fa-solid fa-check fa-sm ml-2" style="color: #ffffff; margin-right: 5px; cursor: pointer;"></i>
						    </div>
						</div>
						<p id="empIntrcnText" style="font-size: 13px; margin-top: 3px;">소개 : ${employeeVO.empIntrcn} <i id="upDateIntrcn" class="ml-1 fa-solid fa-pen fa-sm cursor-pointer"></i></p> 
					</div>
				</div>
				<div style="margin-left: 20px;">
					<p style="margin-top: 10px;">안녕하세요 :D</p>
					<p style="margin-bottom: 20px;">오늘도 즐거운 하루 보내세요!</p>
				</div>
			</div>
			
			<div style="width: 50%; padding: 0px 20px 0px 40px;">
				<div style="display:flex; justify-content: space-between; align-items: center; margin-bottom: 5px; margin-top: 10px;">
					<span>
						<i class="fa-regular fa-calendar fa-sm"></i>
						<span id="sysDate" style="font-size: 13px;"></span>
					</span>
					<span style="font-size: 12px;">휴게 시간 | 12:00 - 13:00 (점심 시간)</span>
				</div>
				
				<div style="background-color: #ECF3FF; border-radius: 10px; color: black; display: flex; flex-direction: row; justify-content: space-between; padding: 15px 0px; text-align: center;">
					<div style="width: 50%;">
						<p style="font-size: 15px;">출근 시간</p>
					 	<span id="attendTime"><strong id="inTime" style="font-size: 20px;">-</strong></span>
					</div>
					<div style="width: 50%;">
						<p style="font-size: 15px;">퇴근 시간</p>
					 	<span id="lvffcTime"><strong id="outTime" style="font-size: 20px;">-</strong></span>
					</div>
				</div>
				
				<div style="display: flex; justify-content: space-between; margin-top: 20px; margin-bottom: 5px;">
					<div style="width: 45%;">
						<button id="attendBtn" class="btn btn-block btn-light" style="border-radius: 10px;">출근</button>
						<button id="lvWrkBtn" class="btn btn-block btn-light" style="border-radius: 10px;">퇴근</button>
					</div>
					<div style="width: 45%;">
						<button id="seatBtn" class="btn btn-block btn-light" style="border-radius: 10px;">자리 비움</button>
					</div>
				</div>
			</div>
		</div>
		
		<div class="card calendar pt-4">
		<div style="display: flex; justify-content: space-between; border-bottom: 1px solid #D9D9D9; padding-bottom: 10px;">
				<div>
					<strong style="font-size: 20px;">Calendar</strong>
				</div>
				
				<div>
					<button id="calendarBtn" class="btn btn-block btn-default" style="font-size:14px; border-radius: 100px;">전체 보기 +</button>
				</div>
			</div>
			<div class="calendar-container p-6 rounded-lg">
			    <div class="relative flex justify-center items-center mb-4 mt-3">
				    <button id="prevMonth" class="absolute left-0 p-3 text-gray-500 hover:text-gray-700">&lt;</button>
				    <span id="monthName" class="text-lg font-semibold text-gray-800"></span>
				    <button id="nextMonth" class="absolute right-0 p-3 text-gray-500 hover:text-gray-700">&gt;</button>
				</div>
			    <div class="grid grid-cols-7 gap-3 text-center">
			        <!-- 요일 표시 -->
			        <span class="text-sm font-semibold" style="color: #4E7DF4;">Sun</span>
			        <span class="text-sm font-semibold" style="color: #4E7DF4;">Mon</span>
			        <span class="text-sm font-semibold" style="color: #4E7DF4;">Tue</span>
			        <span class="text-sm font-semibold" style="color: #4E7DF4;">Wed</span>
			        <span class="text-sm font-semibold" style="color: #4E7DF4;">Thu</span>
			        <span class="text-sm font-semibold" style="color: #4E7DF4;">Fri</span>
			        <span class="text-sm font-semibold" style="color: #4E7DF4;">Sat</span>
			    </div>
			    <div id="calendarDates" class="grid grid-cols-7 gap-3 text-center mt-2" style="cursor:pointer;">
			        <!-- 날짜가 여기에 동적으로 삽입됩니다. -->
			    </div>
			</div>
		</div>
		
		<div class="card quick-menu flex items-center">
		<div class="mb-7 w-full" style="display: flex; justify-content: space-between; border-bottom: 1px solid #D9D9D9; padding-bottom: 10px;">
			<div>
				<strong style="font-size: 20px;">Quick Menu</strong>
			</div>
		</div>
		   <div class="flex gap-8">
		       <div class="flex flex-col items-center">
		           <div class="bg-[#dce8fe] flex rounded-xl p-3 items-center">
			           <a href="/taskDiary/regist">
			               <img alt="taskDiary" src="/resources/images/main/taskDiary.png" class="w-[32px] h-[32px]">
			           </a>
		           </div>
		           <span class="mt-2">업무 일지</span>
		       </div>
		       
		       <div class="flex flex-col items-center">
		           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
			           <a href="/cmmn/mail/send" target="_blank">
			               <img alt="mail" src="/resources/images/main/mail.png" class="w-[32px] h-[32px]">
			           </a>
		           </div>
		           <span class="mt-2">메일 작성</span>
		       </div>
		
		       <div class="flex flex-col items-center">
		           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
		           		<a href="/approval/approvalRegist">
			               <img alt="vacation" src="/resources/images/main/vacation.png" class="w-[32px] h-[32px]">
		           		</a>
		           </div>
		           <span class="mt-2">휴가 신청</span>
		       </div>
		       <!-- 경영진 -->
		       <c:if test="${empVO.deptCd == 'A17-001'}">
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           <a href="/approval/approvalList">
				               <img alt="sign" src="/resources/images/main/sign.png" class="w-[32px] h-[32px]">
				           </a>
			           </div>
			           <span class="mt-2">결재 관리</span>
			       </div>
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           	<a href="/approval/approvalRequestList">
				               <img alt="box" src="/resources/images/main/box.png" class="w-[32px] h-[32px]">
				           	</a>
			           </div>
			           <span class="mt-2">결재문서함</span>
			       </div>
		       </c:if>
		       <!-- 기획부 -->
		       <c:if test="${empVO.deptCd == 'A17-002'}">
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           	<a href="/registForm">
				               <img alt="notice" src="/resources/images/main/notice.png" class="w-[32px] h-[32px]">
				           	</a>
			           </div>
			           <span class="mt-2">공지 작성</span>
			       </div>
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           	<a href="/surveyList">
				               <img alt="survey" src="/resources/images/main/survey.png" class="w-[32px] h-[32px]">
				           	</a>
			           </div>
			           <span class="mt-2">설문 관리</span>
			       </div>
		       </c:if>
		       <!-- 관리부 -->
		       <c:if test="${empVO.deptCd == 'A17-003'}">
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           	<a href="/fixtures/list">
				               <img alt="fixture" src="/resources/images/main/fixture.png" class="w-[32px] h-[32px]">
				           	</a>
			           </div>
			           <span class="mt-2">비품 관리</span>
			       </div>
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           	<a href="/car/list">
				               <img alt="car" src="/resources/images/main/car.png" class="w-[32px] h-[32px]">
				           	</a>
			           </div>
			           <span class="mt-2">차량 관리</span>
			       </div>
		       </c:if>
		       <!-- 영업부 -->
		       <c:if test="${empVO.deptCd == 'A17-004'}">
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           	<a href="/customer/list">
				               <img alt="customer" src="/resources/images/main/customer.png" class="w-[32px] h-[32px]">
				           	</a>
			           </div>
			           <span class="mt-2">CRM</span>
			       </div>
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
			           	<a href="/counterparty/list">
			               <img alt="counterparty" src="/resources/images/main/counterparty.png" class="w-[32px] h-[32px]">
			           	</a>
			           </div>
			           <span class="mt-2">SRM</span>
			       </div>
		       </c:if>
		       <!-- 인사부 -->
		       <c:if test="${empVO.deptCd == 'A17-005'}">
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           	<a href="/employee/list">
				               <img alt="employee" src="/resources/images/main/employee.png" class="w-[32px] h-[32px]">
				           	</a>
			           </div>
			           <span class="mt-2">사원 관리</span>
			       </div>
			        <div class="flex flex-col items-center">
			           <div class="bg-[#DCE8FE] flex rounded-xl p-3 items-center">
				           	<a href="/salaryDetails/list">
				               <img alt="receipt" src="/resources/images/main/receipt.png" class="w-[32px] h-[32px]">
				           	</a>
			           </div>
			           <span class="mt-2">명세서 관리</span>
			       </div>
		       </c:if>
		   </div>
		</div>
		
		<div class="card notice">
		<!-- 공지사항 목록 -->
			<div style="display: flex; justify-content: space-between; border-bottom: 1px solid #D9D9D9; padding-bottom: 10px;">
				<div>
					<strong style="font-size: 20px;">Notice</strong>
				</div>
				
				<div>
					<button id="noticeBtn" class="btn btn-block btn-default" style="font-size:14px; border-radius: 100px;">전체 보기 +</button>
				</div>
			</div>
			
			<div id="ntcIn" style="margin-top: 10px;">
			</div>
		</div>
		
		<div class="card todo_list">
		    <!-- TO-DO List 목록 -->
		    <div style="display: flex; justify-content: space-between; border-bottom: 1px solid #D9D9D9; padding-bottom: 10px;">
		        <div>
		            <strong style="font-size: 20px;">To Do List</strong>
		        </div>
		        <div>
					 </div>
		    </div>
		    <div id="inputField">
		        <input type="text" id="todoInput" placeholder="할 일 추가하기">
		        <button type="button" id="addBtn" style="margin-left: 5px;">
		            <i class="fa-solid fa-plus fa-xl" style="color: #ffffff;"></i>
		        </button>
		    </div>
		    <div class="todo-list-container">
		        <ul id="todoList">
		            <!-- todoList 항목들이 여기에 추가됨 -->
		        </ul>
		    </div>
		</div>        

		<div class="card address-book">
			<!-- 주소록 목록 -->
			<div style="display: flex; justify-content: space-between; border-bottom: 1px solid #D9D9D9; padding-bottom: 10px;">
				<div>
					<strong style="font-size: 20px;">Address Book</strong>
				</div>
				
				<div>
					<button id="noticeBtn" class="btn btn-block btn-default" style="font-size:14px; border-radius: 100px;"
						onclick="window.location.href='http://localhost/addressList'">전체 보기 +</button>
				</div>
			</div>
			
			<div id="adreesTim" style="margin-top: 10px;">
			</div>
		</div>
	</div>
	<!-- 대쉬 보드 끝 -->

	<!-- 출근 큐알 모달 -->
	<div class="relative z-10" id="qrModal" aria-labelledby="modal-title" role="dialog" aria-modal="true">
	  <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
	
	  <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
	    <div class="flex min-h-full items-center justify-center p-4 text-center">
	      <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:max-w-lg sm:w-full">
	        <div class="bg-white px-4 pb-4 pt-5 sm:p-6">
	          <div class="text-center">
	          	<span id="close" class='absolute top-3 right-2 text-lg text-gray cursor-pointer delete-div mr-3'>×</span>
	            <h3 class="text-base font-semibold leading-6 text-gray-900" id="modal-title">출근 QR 코드</h3>
	            <h4 class="text-sm font-light leading-2 text-gray-600" id="modal-sub">휴대 전화로 QR 코드를 촬영 후 <b>확인</b> 버튼을 클릭해 주세요</h4>
	            <div class="mt-2 flex justify-center">
	            	<img id="qrImg" src="${pageContext.request.contextPath}/createQr" alt="qr코드"/>
	            </div>
	          </div>
	        </div>
	        <div class="bg-gray-50 px-4 py-3 flex justify-center">
	          <button type="button" id="okey" class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">확인</button>
	          <button type="button" id="attBtn" class="inline-flex justify-center rounded-md bg-gray-500 ml-2 px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-600">클릭하여 출근</button>
	        </div>
	      </div>
	    </div>
	  </div>
	</div>
</body>
</html>
