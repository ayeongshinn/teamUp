<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!-- 로그인 후 정보 확인 시작 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!-- 로그인 후 정보 확인 끝 -->
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Sortable/1.14.0/Sortable.min.js"></script>
<script src="https://kit.fontawesome.com/16ae2edc02.js" crossorigin="anonymous"></script>
<title></title>
<script type="text/javascript">
	var originalTreeViewHtml;
	
	$(document).ready(function(){
		domReload();
	});
	
	function domReload() {
	    // 기존 이벤트 리스너 제거 후 새로 바인딩
	    $('input[name="singleSelect"]').off('change').on('change', function() {
	        // 모든 라디오 버튼의 값을 '○'로 다시 설정
	        $('input[name="singleSelect"]').val('○');
	        // 선택된 라디오 버튼의 값을 '●'로 변경
	        if ($(this).is(':checked')) {
	            $(this).val('●');
	        }
	    });

	    originalTreeViewHtml = $("#searchDiv").html();

	    $('#emrgncyYn').off('change').on('change', function() {
	        if ($(this).is(':checked')) {
	            $('#emrgncyYnValue').val('Y');  // 체크되었을 때 'Y' 설정
	        } else {
	            $('#emrgncyYnValue').val('N');  // 체크 해제되었을 때 'N' 설정
	        }
	    });

	    // 문서 오늘 날짜 표시	
	    var today = new Date();
	    var year = today.getFullYear();
	    var month = today.getMonth() + 1;  // 월은 0부터 시작하므로 +1 필요
	    var day = today.getDate();
	    if (month < 10) month = '0' + month;
	    if (day < 10) day = '0' + day;
	    var formattedDate = year + "년 " + month + "월 " + day + "일";

	    // 사원 자동완성 시 폼 자동 작성
	    $('#trgtEmpNm').autocomplete({
	        source: function(request, response) {
	            $.ajax({
	                url: "/hrMovementDoc/autocomplete",
	                type: "POST",
	                dataType: "JSON",
	                data: { empNm: request.term },
	                beforeSend: function(xhr) {
	                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	                },
	                success: function(data) {
	                    response(
	                        $.map(data.resultList, function(item) {
	                            var highlightedName = item.EMP_NM.replace(
	                                new RegExp("(" + request.term + ")", "gi"),
	                                "<span class='highlight'>$1</span>"
	                            );
	                            return {
	                                label: highlightedName + " (" + item.DEPT_NM + ", " + item.JBGD_NM + ")",
	                                value: item.EMP_NM,  
	                                idx: item.EMP_NO,
	                                dept_nm: item.DEPT_NM,
	                                jbgd_nm: item.JBGD_NM,
	                                emp_telno: item.EMP_TELNO,
	                                jncmp_ymd: item.JNCMP_YMD  
	                            };
	                        })
	                    );
	                },
	                error: function(jqXHR, textStatus, errorThrown) {
	                    console.error("AJAX 요청 중 오류 발생: " + textStatus);
	                    console.error("오류 상세: " + errorThrown);
	                    console.error("응답 텍스트: " + jqXHR.responseText);
	                    alert("오류가 발생했습니다.");
	                }
	            });
	        },
	        select: function(evt, ui) {
	            $('#trgtEmpNo').text(ui.item.idx);
	            $('#trgtEmpNm').val(ui.item.value);
	            var formattedTelno = ui.item.emp_telno.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
	            var formattedDate = ui.item.jncmp_ymd.replace(/(\d{4})(\d{2})(\d{2})/, "$1. $2. $3");
	            $('#empDept').val(ui.item.dept_nm);
	            $('#empJbgd').val(ui.item.jbgd_nm);
	            $('#empTel').val(formattedTelno);
	            $('#empPeriod').val(formattedDate + " - ");
	            $('#empName2').val(ui.item.value);
	            $('#empDept2').val(ui.item.dept_nm);
	            $('#empJbgd2').val(ui.item.jbgd_nm);
	            console.log("선택된 사원번호: " + ui.item.idx);
	            return false;
	        }
	    }).data("ui-autocomplete")._renderItem = function(ul, item) {
	        return $("<li>").append("<div>" + item.label + "</div>").appendTo(ul);
	    };

	    $('.toggle-icon').click(function(e) {
	        e.preventDefault();
	        var $icon = $(this).find('i');
	        if ($icon.hasClass('fa-square-plus')) {
	            $icon.removeClass('fa-square-plus').addClass('fa-square-minus');
	        } else {
	            $icon.removeClass('fa-square-minus').addClass('fa-square-plus');
	        }
	    });

	    // 문서 트리
	    $('.nav-click').click(function(e) {
	        e.preventDefault();
	        $(this).parent().toggleClass('active');
	    });

	    // 이벤트 리스너 최초 바인딩
	    bindToggleIcons();
	    bindNavClick();
	}
	
	var ajaxRequest; // AJAX 요청을 저장할 변수
	
	function validateField($field) {
	    if ($field.is('select')) {
	        if ($field.val() === null || $field.val() === "") {
	            $field.addClass('error');
	            let $errorMsg = $field.next('.error-message');
	            if ($errorMsg.length === 0) {
	                $errorMsg = $('<span class="error-message">선택해주세요.</span>');
	                $field.after($errorMsg);
	            }
	            $errorMsg.text('선택해주세요.');
	        } else {
	            $field.removeClass('error');
	            $field.next('.error-message').remove();
	        }
	    } else {
	        // 기존의 input 필드 검증 로직
	        if ($field.val().trim() === '') {
	            $field.addClass('error');
	            let $errorMsg = $field.next('.error-message');
	            if ($errorMsg.length === 0) {
	                $errorMsg = $('<span class="error-message">필수 입력란입니다.</span>');
	                $field.after($errorMsg);
	            }
	            $errorMsg.text('필수 입력란입니다.');
	        } else {
	            $field.removeClass('error');
	            $field.next('.error-message').remove();
	        }
	    }
	}
	
	function validateForm() {
	    let isValid = true;
	    $('[data-required="true"]').each(function() {
	        validateField($(this));
	        if ($(this).hasClass('error')) {
	            isValid = false;
	        }
	    });
	    return isValid;
	}
	
	function approve(data) {
		$.ajax({
			url:"/approval/insertApproval",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
				if(res >= 1) approvalSuccess(data.docCd);
			}
		});
	}
	
	/*
	function approve() {
		let docNo = $("#paramDocNo").text();
		let atrzTtl = $("#paramAtrzTtl").text();
		let drftEmpNo = ${empVO.empNo};
		let htmlCd = $("#paramHtmlCd").html();
		let docCdNm = $("#paramDocCdNm").html();
		
		let empNos = $(".approvalEmpNo").map(function(){
			return $(this).text();
		}).get();
		
		let atrzEmpNos = {};
		
		empNos.forEach((employees, index) => {
			atrzEmpNos["atrzEmpNo"+ (index + 1)] = employees;
		});
		
		let data = {
				"docNo" : docNo,
				"atrzTtl" : atrzTtl,
				"drftEmpNo" : drftEmpNo,
				"htmlCd" : htmlCd,
				"atrzEmpNos" : atrzEmpNos,
				"docCdNm" : docCdNm,
		}
		
		$.ajax({
			url:"/approval/insertApproval",
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify(data),
			type:"post",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(res){
				if(res == 1) {
					approvalSuccess();
				}
			}
		});
	}
	*/
	
	// 사원 검색
	function triggerSearch() {
	    const name = $('#nameInput').val().trim(); // trim()으로 공백 제거
	    if (name !== '') {
	        // 이전 AJAX 요청을 취소
	        if (ajaxRequest) {
	            ajaxRequest.abort();
	        }
	        ajaxRequest = $.ajax({
	            url: "/approval/getSearch",
	            contentType: "text/plain;charset=utf-8",
	            data: name,
	            type: "post",
	            dataType: "json",
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
	            success: function(res) {
	                updateTreeView(res);
	            },
	            error: function() {
	                // 요청 실패 시에도 트리 뷰 복원
	                restoreOriginalTreeView();
	            }
	        });
	    } else {
	        // 검색어가 비어있을 때 원래의 트리뷰 구조로 복원
	        restoreOriginalTreeView();
	    }
	}

	// 원래의 트리뷰 구조를 복원하는 함수
	function restoreOriginalTreeView() {
	    $("#searchDiv").html(originalTreeViewHtml);
	    
	 	// 드롭다운 기능에 필요한 이벤트 리스너 재바인딩
	    bindToggleIcons();
	    bindNavClick();
	    
	    reinitializeSortable();
	};
	
	function bindToggleIcons() {
	    $('.toggle-icon').off('click').on('click', function(e) {
	        e.preventDefault();
	        var $icon = $(this).find('i');
	        if ($icon.hasClass('fa-square-plus')) {
	            $icon.removeClass('fa-square-plus').addClass('fa-square-minus');
	        } else {
	            $icon.removeClass('fa-square-minus').addClass('fa-square-plus');
	        }
	    });
	};

	function bindNavClick() {
	    $('.nav-click').off('click').on('click', function(e) {
	        e.preventDefault();
	        $(this).parent().toggleClass('active');
	    });
	};
	
	function checkAlert() {
		Swal.fire({
			title: '중복된 대상입니다.',
			icon: 'warning', /* 종류 많음 맨 아래 링크 참고 */
			confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
			confirmButtonText: '확인',
		
		}).then((result) => {
		});
	};
	
	function warning() {
		Swal.fire({
			title: '결재자를 1명 이상 등록해주세요.',
			icon: 'warning', /* 종류 많음 맨 아래 링크 참고 */
			confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
			confirmButtonText: '확인',
		
		}).then((result) => {
		});
	};
	
	function maxApplovalLine() {
		Swal.fire({
			title: '결재자 최대 지정 수는 4명 이하 입니다.',
			icon: 'warning', /* 종류 많음 맨 아래 링크 참고 */
			confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
			confirmButtonText: '확인',
		
		}).then((result) => {
		});
	};
	
	function save() {
		Swal.fire({
			title: '결재선 설정이 완료되었습니다.',
			icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
			confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
			confirmButtonText: '확인',
		
		}).then((result) => {
		});
	};
	
	function approvalSuccess(docCd) {
		Swal.fire({
			title: '결재 요청이 완료되었습니다.',
			icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
			confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
			confirmButtonText: '확인',
		
		}).then((result) => {
			if(docCd == 'A29-001'){
				$.ajax({
					url:"/approval/hrMovementDocNo",
					contentType:"application/json;charset=utf-8",
					type:"get",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
					success:function(res){
						location.href="http://localhost/approval/approvalDetail?docNo=" + res;
					}
				});
			} else if(docCd == 'A29-002'){
				$.ajax({
					url:"/approval/vacationDocNo",
					contentType:"application/json;charset=utf-8",
					type:"get",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
					success:function(res){
						location.href="http://localhost/approval/approvalDetail?docNo=" + res;
					}
				});
			}
		});
	};
	
	function updateTreeView(data) {
		// 검색 결과를 표시할 새로운 HTML 생성
	    var newHtml = '<nav><ul class="navLine"><li class="nav-item"><ul><div class="column">';
	    
	    data.forEach(function(employee) {
	        newHtml += '<li class="search-group-item" draggable="true">'
	                    + '<span style="display: inline; margin-right: 3px; color: #7A7A7A;"><i class="fa-solid fa-user-large"></i></span><span style="display: inline;">' + employee.empNm
	                    + '</span><span style="display: inline;"> ' + employee.jbgdNm + ' / </span><span style="display: inline; font-size: 13px; color: #4E7DF4;">' + employee.deptNm
	                    + '</span><span style="display: none;">' + employee.empNo + '</span><span style="display: none;"><i class="fa-solid fa-trash"></i></span>'
	                    + '</li>';
	    });
	    
	    newHtml += '</div></ul></li></ul></nav>';

	    // 검색 결과를 #searchDiv에 직접 추가
	    $("#searchDiv").html(newHtml);

	    // Sortable 재초기화
	    reinitializeSortable();
	};

	function reinitializeSortable() {
	    const column = $(".column");

	    // 첫 번째 열 설정 (드래그 소스)
	    new Sortable(column[0], {
	        group: {
	            name: "shared",
	            pull: 'clone',  // 클론 가능
	            put: false
	        },
	        animation: 150,
	        sort: false,  // 첫 번째 열 내에서는 정렬 비활성화
	    });

	    // 두 번째 열 설정 (드롭 대상)
	    new Sortable(column[1], {
	        group: {
	            name: "shared",
	            pull: false, // 드래그 불가능
	            put: function(to) {
	                if (to.el.children.length > 3) {
	                    maxApplovalLine();  // 최대 아이템 경고 호출
	                    return to.el.children.length < 4;  // 4개 이하로 제한
	                }
	            }
	        },
	        animation: 150,
	        sort: true,  // 두 번째 열 내에서 정렬 가능
	        onAdd: function(evt) {
	            // 드롭된 아이템에 대한 처리가 여기에서 이루어짐
	            const item = evt.item;
	            const newEmpNo = item.querySelector('span[style*="display: none"]:nth-child(7)').innerHTML.trim();
	            const tbody = document.querySelector('.second-column');
	            const existingEmpNos = Array.from(tbody.querySelectorAll('td:nth-child(7)')).map(td => td.innerHTML.trim());

	            if (existingEmpNos.includes(newEmpNo)) {
	                checkAlert();
	                item.remove();  // 중복된 경우 아이템 삭제
	                return;
	            }

	            // 새로운 행 추가 (이 부분은 문제없이 동작하는 것 같음)
	            const newRow = document.createElement('tr');
	            newRow.style.borderBottom = "1px solid #D9D9D9";
	            newRow.style.borderTop = "1px solid #D9D9D9";

	            const userIconTd = document.createElement('td');
	            userIconTd.innerHTML = item.querySelector('span[style*="display: inline"]:nth-child(1)').innerHTML;
	            userIconTd.style.display = "none";
	            newRow.appendChild(userIconTd);

	            const iconTd = document.createElement('td');
	            iconTd.className = 'table-cell';
	            iconTd.innerHTML = item.querySelector('span[style*="display: none"]:nth-child(2)').innerHTML;
	            iconTd.style.backgroundColor = "#FAFAFA";
	            iconTd.style.borderRight = "1px solid #D9D9D9";
	            iconTd.style.width = "50px";
	            newRow.appendChild(iconTd);

	            const typeTd = document.createElement('td');
	            typeTd.className = 'table-cell';
	            typeTd.innerHTML = item.querySelector('span[style*="display: none"]:nth-child(3)').innerHTML;
	            typeTd.style.width = "80px";
	            typeTd.style.color = "#4E7DF4";
	            typeTd.style.fontWeight = "bold";
	            newRow.appendChild(typeTd);

	            const nameTd = document.createElement('td');
	            nameTd.className = 'table-cell';
	            nameTd.innerHTML = item.querySelector('span[style*="display: inline"]:nth-child(4)').innerHTML;
	            newRow.appendChild(nameTd);

	            const jbgdTd = document.createElement('td');
	            jbgdTd.className = 'table-cell';
	            jbgdTd.innerHTML = item.querySelector('span[style*="display: inline"]:nth-child(5)').innerHTML;
	            newRow.appendChild(jbgdTd);

	            const deptTd = document.createElement('td');
	            deptTd.className = 'table-cell';
	            deptTd.innerHTML = item.querySelector('span[style*="display: none"]:nth-child(6)').innerHTML;
	            newRow.appendChild(deptTd);

	            const empNoTd = document.createElement('td');
	            empNoTd.innerHTML = newEmpNo;  // 사원 번호
	            empNoTd.style.display = "none";
	            newRow.appendChild(empNoTd);

	            const deleteTd = document.createElement('td');
	            deleteTd.className = 'table-cell';
	            deleteTd.innerHTML = item.querySelector('span[style*="display: none"]:last-child').innerHTML;
	            deleteTd.style.width = "50px";
	            deleteTd.onclick = function() {
	                newRow.remove();
	            };
	            newRow.appendChild(deleteTd);

	            tbody.appendChild(newRow);

	            item.setAttribute('draggable', false);  // 드래그 비활성화
	            item.remove();  // 원래 아이템 삭제
	        }
	    });
	}

	$(function(){
		var empNm = $("#formattedName").attr('data-name');
		var fmtEmpNm = empNm.split('').join(' ');
		$("#formattedName").html("신 청 인 : &ensp;&ensp;" + fmtEmpNm + "&ensp;&ensp; (인)");
		
		// 사원 검색 시작
		let isComposing = false;  // 한글 조합 상태
		
		$('#nameInput').on('input', function() {
		    const name = $(this).val().trim(); // 입력 값에서 공백 제거
		    if (name === '') {
		        // 검색어가 비어있을 때 원래의 트리뷰 구조로 복원
		        restoreOriginalTreeView();
		    }
		});
		
		// 글자 조합이 시작될 때
		$('#nameInput').on('compositionstart', function() {
		    isComposing = true;
		});
		
		// 글자 조합이 끝났을 때 (한글이 완성되었을 때)
		$('#nameInput').on('compositionend', function() {
		    isComposing = false;
		});
		
		// Enter 키를 눌렀을 때 검색 실행
		$('#nameInput').on('keyup', function(e) {
		    if (!isComposing && e.key === 'Enter') {
		        triggerSearch();  // 검색 함수 호출
		    }
		});
		
		$('#searchBtn').on('click', function() {
		    triggerSearch();  // 검색 함수 호출
		});
        // 사원 검색 끝

		// 드래그 앤 드롭 시작
		const columns = $(".column");

		// 첫 번째 열 설정
		new Sortable(columns[0], {
		    group: {
		        name: "shared",
		        pull: 'clone',
		        put: false
		    },
		    animation: 150,
		    sort: false // 첫 번째 열 내에서 정렬 비활성화
		});
		
		new Sortable(columns[1], {
		    group: {
		        name: "shared",
		        pull: 'clone',
		        put: false
		    },
		    animation: 150,
		    sort: false // 첫 번째 열 내에서 정렬 비활성화
		});
		
		new Sortable(columns[2], {
		    group: {
		        name: "shared",
		        pull: 'clone',
		        put: false
		    },
		    animation: 150,
		    sort: false // 첫 번째 열 내에서 정렬 비활성화
		});
		
		new Sortable(columns[3], {
		    group: {
		        name: "shared",
		        pull: 'clone',
		        put: false
		    },
		    animation: 150,
		    sort: false // 첫 번째 열 내에서 정렬 비활성화
		});
		
		new Sortable(columns[4], {
		    group: {
		        name: "shared",
		        pull: 'clone',
		        put: false
		    },
		    animation: 150,
		    sort: false // 첫 번째 열 내에서 정렬 비활성화
		});

		// 두 번째 열 설정
		new Sortable(columns[5], {
		    group: {
		        name: "shared",
		        pull: false,
		        put: function(to) {
		            if(to.el.children.length > 3) {
		            	maxApplovalLine();
			            return to.el.children.length < 4;// 최대 4개 아이템으로 제한
		            }
		        }
		    },
		    animation: 150,
		    sort: true, // 두 번째 열 내에서 정렬 활성화
		    onAdd: function(evt) {
		    	const item = evt.item;
		        
		    	// 드롭된 사원 번호 확인
		        const newEmpNo = item.querySelector('span[style*="display: none"]:nth-child(7)').innerHTML.trim();

		        // 두 번째 컬럼에서 모든 사원 번호(td 태그) 가져오기
		        const tbody = document.querySelector('.second-column');
		        const existingEmpNos = Array.from(tbody.querySelectorAll('td:nth-child(7)')).map(td => td.innerHTML.trim());

		        // 이미 존재하는지 확인 (사원 번호 중복 체크)
		        if (existingEmpNos.includes(newEmpNo)) {
		            checkAlert();  // 중복된 경우 알림
		            item.remove();  // 중복 시 드롭된 요소 제거
		            return;
		        }

		        // 기존 드롭 로직
		        const newRow = document.createElement('tr');
		        newRow.style.borderBottom = "1px solid #D9D9D9";
		        newRow.style.borderTop = "1px solid #D9D9D9";
				
		        const userIconTd = document.createElement('td');
		        userIconTd.innerHTML = item.querySelector('span[style*="display: inline"]:nth-child(1)').innerHTML; 
		        userIconTd.style.display = "none";
		        newRow.appendChild(userIconTd);
		        
		        const iconTd = document.createElement('td');
		        iconTd.className = 'table-cell';
		        iconTd.innerHTML = item.querySelector('span[style*="display: none"]:nth-child(2)').innerHTML; 
		        iconTd.style.backgroundColor = "#FAFAFA";
		        iconTd.style.borderRight = "1px solid #D9D9D9";
		        iconTd.style.width = "50px";
		        newRow.appendChild(iconTd);

		        const typeTd = document.createElement('td');
		        typeTd.className = 'table-cell';
		        typeTd.innerHTML = item.querySelector('span[style*="display: none"]:nth-child(3)').innerHTML; 
		        typeTd.style.width = "80px";
		        typeTd.style.color = "#4E7DF4";
		        typeTd.style.fontWeight = "bold";
		        newRow.appendChild(typeTd);

		        const nameTd = document.createElement('td');
		        nameTd.className = 'table-cell';
		        nameTd.innerHTML = item.querySelector('span[style*="display: inline"]:nth-child(4)').innerHTML; 
		        newRow.appendChild(nameTd);

		        const jbgdTd = document.createElement('td');
		        jbgdTd.className = 'table-cell';
		        jbgdTd.innerHTML = item.querySelector('span[style*="display: inline"]:nth-child(5)').innerHTML; 
		        newRow.appendChild(jbgdTd);

		        const deptTd = document.createElement('td');
		        deptTd.className = 'table-cell';
		        deptTd.innerHTML = item.querySelector('span[style*="display: none"]:nth-child(6)').innerHTML; 
		        newRow.appendChild(deptTd);
		        
		        const empNo = document.createElement('td');
		        empNo.className = 'approvalEmpNo';
		        empNo.innerHTML = newEmpNo;  // 사원 번호는 이미 newEmpNo에 담김
		        empNo.style.display = "none";
		        newRow.appendChild(empNo);

		        const deleteTd = document.createElement('td');
		        deleteTd.className = 'table-cell';
		        deleteTd.innerHTML = item.querySelector('span[style*="display: none"]:last-child').innerHTML;
		        deleteTd.style.width = "50px";
		        deleteTd.onclick = function() {
		            newRow.remove();
		        };
		        newRow.appendChild(deleteTd);

		        tbody.appendChild(newRow);

		        // 드래그 비활성화
		        item.setAttribute('draggable', false);

		        // 원래 아이템 제거
		        item.remove();
		    }
		});
		// 드래그 앤 드롭 끝
		
		// 드래그 앤 드롭 기본 설명 시작
		// tbody 안에 자식 요소가 추가되면 dragExp 숨기고, 자식 요소가 없으면 보이게 하는 함수
		function toggleDragExp() {
		const tbody = document.querySelector('.second-column');
		const dragExp = document.getElementById('dragExp');
		
			// 자식 요소가 있으면 dragExp 숨김, 없으면 다시 보임
			if (tbody.children.length > 0) dragExp.style.display = 'none';  // 숨기기
			else dragExp.style.display = '';  // 보이기
		}
		
		// MutationObserver를 이용하여 자식 요소 추가/제거 감지
		const observer = new MutationObserver((mutations) => {
			mutations.forEach((mutation) => {
				// 자식 요소가 추가되거나 제거될 때마다 toggleDragExp 실행
				toggleDragExp();
			});
		});
		
		// 감시할 대상 요소 지정 (tbody)
		const targetNode = document.querySelector('.second-column');
		
		// 감시 옵션: 자식 노드의 추가 및 제거 감시
		const config = { childList: true };
		
		// 대상 요소에 감시 적용
		observer.observe(targetNode, config);
		
		// 초기 호출: 페이지 로딩 후에 자식이 이미 있을 수 있으므로 한번 실행
		toggleDragExp();
		// 드래그 앤 드롭 기본 설명 끝
		
		$("#backBtn").on("click", function(){
			history.back();
			
		});
		
		$('select[data-required="true"]').on('change', function() {
		    validateField($(this));
		});
		
		$('input[data-required="true"]').on('input', function() {
		    validateField($(this));
		});
		
		$('textarea[data-required="true"]').on('input', function() {
		    validateField($(this));
		});
		
		$("#approveBtn").on("click", function(e){
			e.preventDefault();
			
			let empNos = $(".approvalEmpNo").map(function(){
				return $(this).text();
			}).get();
			
			if(empNos.length == 0) {
				warning();
			} else {
				if(validateForm()) {
					Swal.fire({
						title: '작성한 문서를 상신하시겠습니까?',
						icon: 'question', /* 종류 많음 맨 아래 링크 참고 */
						confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
						confirmButtonText: '확인',
						cancelButtonText: '취소',
						showCancelButton: true, /* 필요 없으면 지워도 됨, 없는 게 기본 */
						
						reverseButtons: true,
					
					}).then((result) => {
						
						let data = {};
						let docCd = $("#docCd").val();
						
						/*결재선 정보 시작*/
						let atrzTtl = $("#docTtl").val();
						let drftEmpNo = ${empVO.empNo};
						let docCdNm = $("#paramDocCdNm").text();
						let emrgncySttus = $("#emrgncyYnValue").val();
						
						let atrzEmpNos = {};
						
						empNos.forEach((employees, index) => {
							atrzEmpNos["atrzEmpNo"+ (index + 1)] = employees;
						});
						
						let approval = {
								"atrzTtl" : atrzTtl,
								"drftEmpNo" : drftEmpNo,
								"atrzEmpNos" : atrzEmpNos,
								"docCdNm" : docCdNm,
								"emrgncySttus" : emrgncySttus
						}
						/*결재선 정보 끝*/
						
						/*인사이동 시작*/
						let docCn = $("#hrDocCn").val();
						let wrtYmd = $("#hrWrtYmd").text();
						let trgtEmpNo = $("#trgtEmpNo").text();
						let deptCd = $("#hrDeptCd").val();
						let jbgdCd = $("#hrJbgdCd").val();
						let trgtEmpDay = $("#hrTrgtEmpDay").val();
						/*인사이동 끝*/
						
						/*휴가 신청서 시작*/
						
						let vcatnCd;
						
						var selectedText = $('input[name="singleSelect"][value="●"]').closest('label').text().trim();
						
            			if(selectedText == "연차") vcatnCd = "A22-001"
            			else if(selectedText == "월차") vcatnCd = "A22-001"
            			else if(selectedText == "반차 (오전, 오후)") vcatnCd = "A22-003"
            			else if(selectedText == "공가") vcatnCd = "A22-004"
            			else if(selectedText == "병가") vcatnCd = "A22-005"
            			else if(selectedText == "기타 ( )") vcatnCd = "A22-006"
            			
            			let vcatnRsn = $("#vcatnRsn").val();
            			let useVcatnDayCnt = $("#useVcatnDayCnt").val();
            			let schdlBgngYmd = $("#startDate").val();
            			let schdlEndYmd = $("#endDate").val();
            			
            			/*휴가 신청서 끝*/
            			
						if(docCd == 'A29-001') {	// 인사 이동
							data = {
									"docTtl" : atrzTtl,
									"docCn" : docCn,
									"wrtYmd" : wrtYmd,
									"trgtEmpNo" : trgtEmpNo,
									"deptCd" : deptCd,
									"jbgdCd" : jbgdCd,
									"trgtEmpDay" : trgtEmpDay,
									"docCd" : docCd,
									"drftEmpNo" : drftEmpNo,
									"approval" : approval
							}
						} else if(docCd == 'A29-002') {	// 휴가 신청서
							
							data = {
									"vcatnCd" : vcatnCd,
									"docTtl" : atrzTtl,
									"wrtYmd" : wrtYmd,
									"vcatnRsn" : vcatnRsn,
									"useVcatnDayCnt" : useVcatnDayCnt,
									"schdlBgngYmd" : schdlBgngYmd,
									"schdlEndYmd" : schdlEndYmd,
									"docCd" : docCd,
									"drftEmpNo" : drftEmpNo,
									"approval" : approval
							}
						}
						
						console.log("data:", data);
						
						// input 필드를 텍스트로 변경
					    $('input').each(function() {
					      var value = $(this).val();
					      $(this).replaceWith('<span class="readonly" style="font-size:15px;">' + value + '</span>');
					    });
						
						// textarea 필드를 텍스트로 변경
					    $('textarea').each(function() {
					      var value = $(this).val();
					      $(this).replaceWith('<span class="readonly" style="font-size:15px;">' + value + '</span>');
					    });
	
					    // select 박스를 텍스트로 변경
					    $('select').each(function() {
					      var selectedValue = $(this).find('option:selected').text();
					      $(this).replaceWith('<span class="readonly" style="font-size:15px;">' + selectedValue + '</span>');
					    });
						
						let htmlCd = $("#htmlCdHeight").html();
					    data.htmlCd = htmlCd;
					    
						if(result.isConfirmed){
							approve(data);
						}
					});
				}
			}
			
		});
		
		$("#approvalLineSet").on("click", function(){
			$("#modal").show();
		})
		
		$("#lineSetSave").on("click", function(){
			let empNos = $(".approvalEmpNo").map(function(){
				return $(this).text();
			}).get();
			
			if(empNos.length > 0) {
				
				let data = {
						
				};
				
				empNos.forEach((employees, index) => {
				    data["empNo"+ (index + 1)] = employees;
				});
				
				console.log("data", data);
				
				
				$.ajax({
					url:"/approval/getApproveLines",
					contentType:"application/json;charset=utf-8",
					data:JSON.stringify(data),
					type:"post",
					dataType:"json",
					beforeSend:function(xhr){
						xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
					},
					success:function(res){
						
						let html = "";
						let jbgd = "";
						let tr1 = "";
						let tr2 = "";
						let tr3 = "";
						
						
						res.forEach(function(emp) {
					        if (emp.jbttlNm == '팀장') {
					            jbgd = emp.jbttlNm;
					        } else {
					            jbgd = emp.jbgdNm;
					        }

					        html += 
					        	'<div style="display: flex; position: relative;">' +
					            '<div style="display:flex; align-items: center;">' + '<span>' +
					            '<img src="data:image/png;base64,' + emp.proflPhoto + '" class="img-circle" style="width: 60px; height: 60px; display: inline-block; margin: 30px;" alt="karina.gif">' + '</span>' +
					            '</div>' + '<div style="display: flex; flex-direction: column; justify-content: center;">' +
								'<strong>' + emp.empNm + ' ' + jbgd + '</strong>' + '<p style="font-size: 13px;">' + emp.deptNm + '</p>' + '<p style="font-size: 13px;">' + '결재 예정&ensp;|&ensp;-' + '</p>' +
					            '</div>' + '</div>';
					            
					        tr1 += '<th>' + jbgd + '</th>';
					        tr2 += '<td></td>';
					        tr3 += '<th>' + emp.empNm + '</th>';
					    });
						
						

					    $("#line1").html(tr1);
					    $("#line2").html(tr2);
					    $("#line3").html(tr3);
					    $("#approvalLineDiv").html(html);
					}
				});
				
				save();
				$("#modal").hide();
			} else {
				warning();
			}
			console.log("empNos", empNos);
		})
		
		$("#lineSetClose").on("click", function(){
			
			$("#modal").hide();
		})
		
		$("#docCd").on("change", function() {
			var formNo = $("#docCd").val();
			
			$.ajax({
				url:"/approval/getDocumentForm",
				contentType: 'text/plain;charset=utf-8',
				data: formNo,
				type:"post",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success:function(res){
					console.log(res);
					$("#paramDocCdNm").text(res.docNm);
					$("#formChange").html(res.docCn);
					domReload();
				}
			});
		})
	})
</script>
<style type="text/css">

   /* 대쉬 보드 시작 */
   	.dashboard {
		display: grid;
		grid-template-columns: 2fr 0.7fr;
		grid-template-rows: 1fr;
		grid-gap: 40px;
		height: 90vh;
		padding: 60px;
		min-height: 160vh;	/* 디테일에도 추가 */
	}
	
	.approvalLine {
	    position: sticky;
	    top: 72px; /* 상단에서 20px 떨어진 위치에 고정 */
	    height: calc(100vh - 186px); /* 뷰포트 높이에서 상하 여백 40px를 뺀 높이 */
	    overflow-y: auto; /* 내용이 넘치면 수직 스크롤 표시 */
	    align-self: flex-start; /* flexbox 내에서 상단 정렬 */
	}
	
	.ui-autocomplete {
	    background-color: #ffffff; /* 원하는 배경색으로 변경 */
	    max-height: 160px; /* 최대 높이 설정 */
	    overflow-y: auto; /* 세로 스크롤 추가 */
	    overflow-x: hidden; /* 가로 스크롤 숨김 */
	    z-index: 1000; /* 다른 요소 위에 표시되도록 z-index 설정 */
	    width: 50px;
	    border: 1px solid black; /* 테두리 제거 */
	    font-size: 15px;
	    padding: 5px 5px;
	}
	
	/* 선택된 항목의 배경색 변경 */
	.ui-state-active,
	.ui-widget-content .ui-state-active {
	    background-color: #4E7DF4; /* 원하는 선택 항목 배경색으로 변경 */
	    color: white;
	}
	
	.card {
		background-color: white;
		border-radius: 20px;
		padding: 20px;
		box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		margin: 0px;
	}
	
	.cardDoc {
		background-color: white;
		border-radius: 20px;
		box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		padding: 60px;
		margin: 0px;
	}
	
	.approvalDoc {
		grid-column: 1;
		grid-row: 1/2;
	}
	
	.approvalLine {
		grid-column: 2;
	}
	
	textarea:focus {
		outline: 1.5px solid #4E7DF4;
	}
	
	.blueBtn {
	    width: 30%;
	    margin: 0px;
	    font-size: 14px;
	    border-radius: 10px;
	    background-color: #4E7DF4;
	    color: white;
	    border: none;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}
	
	.blueBtn:hover {
	    background-color: #3A63C8; /* 약 20% 더 어두운 색상 */
	}
	
	.container {
		width: 100%;
		margin: 0 auto;
		border: 1px solid black;
		padding: 60px 40px;
		box-sizing: border-box;
		box-shadow:5px 5px 0 #AAAAAA;
	}
	
	.container-table {
		display: flex;
		justify-content: space-between;
		width: 100%;
		margin: 0 auto;
		font-size: 15px;
	}
	
	.left-table {
		border: 1px solid black;
		width: 35%;
	}
	
	.right-table {
		border: 1px solid black;
	}
	
	td, th {
		border: 1px solid black;
		padding: 5px 10px;
		text-align: center;
		width: 90.5px;
	}
	
	th {
		background-color: #f0f0f0;
	}
	
	#line1, #line3 {
		background-color: #f0f0f0;
		height: 33.5px;
	}
	
	#line2 td{
		padding: 10px;
		height: 93.5px;
	}
	
	.title {
		text-align: center;
		font-size: 20px;
		font-weight: bold;
		margin: 30px 0px 50px 0px;
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
	
	.error {
    	border: 1px solid red;
	}
	
	.error-message {
	    color: red;
	    font-size: 0.8em;
	    font-weight: 100;
	}
	
	.modalContainer {
	    display: flex;
	    gap: 30px;
	    margin: 20px 0px;
	    max-height: 380px;
	}
	
	.column {
	    flex-basis: 20%;
	    padding: 0px;
	}
	
	.list-group-item {
		border: none;
	    padding: 0px;
	    cursor: pointer;
	    font-size: 14px;
	    width: fit-content;
	    margin-left: 20px;
	}
	
	.list-group-item:hover {
		border: 1px solid #4E7DF4;
		background-color: #F3F7FF;
		width: fit-content; /* 너비를 자식의 콘텐츠에 맞춤 */
		height: fit-content; /* 높이를 자식의 콘텐츠에 맞춤 */
		padding: 0px 5px;
		border-radius: 6px;
		margin-left: 15px;
	}
	
	.search-group-item {
		border: none;
	    padding: 0px;
	    cursor: pointer;
	    font-size: 14px;
	    width: fit-content;
	    margin-left: 5px;
	}
	
	.search-group-item:hover {
		border: 1px solid #4E7DF4;
		background-color: #F3F7FF;
		width: fit-content; /* 너비를 자식의 콘텐츠에 맞춤 */
		height: fit-content; /* 높이를 자식의 콘텐츠에 맞춤 */
 		padding: 0px 5px;
		border-radius: 6px;
		margin: 0px;
	}
	
	.nav-treeview1 {
		max-height: 0;
		opacity: 0.5;
		overflow: hidden;
		transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
	}
	
	.active > .nav-treeview1 {
		max-height: 1000px;
		   opacity: 1;
	}
	
	.custom-input {
	    border: none;
	    outline: none;
	}
	
	.custom-input2 {
	    border: 1px solid #adb5bd;
	    outline: none;
	    margin: 5px auto;
	    font-size: 15px;
	    color: black;
	}
	
	.custom-input:focus {
	    border: 1px solid #4E7DF4;
	    outline: none;
	    border-radius: 0px;
	}
	
	.custom-input2:focus {
	    border: 2px solid #4E7DF4;
	    outline: none;
	}
	
	.table-cell {
	  padding: 3px 0px;
	  text-align: center;
	  border: none;
	  background-color: transparent;
	  font-size: 15px;
	}
	
	.navLine {
		flex-direction: column;
		margin-left: 15px;
		margin-top: 5px;
	}
	
	.nav-click {
		display: flex;
		align-items: center; /* 수직 방향으로 중앙 정렬 */
		justify-content: flex-start; /* 수평 방향으로 왼쪽 정렬 */
	}
	
	.nav-click a {
		margin-right: 5px; /* 아이콘과 텍스트 사이의 간격 */
		margin-top: 5px;
	}
	
	.nav-click span {
		font-size: 14px; /* 이미 인라인 스타일로 지정되어 있지만, 일관성을 위해 여기에도 추가 */
	}
	
	.readonly {
	  background-color: white;
	  border: none;
	  pointer-events: none; /* 상호작용 차단 */
	}
	
	label {
         display: flex;
         align-items: center;
         font-weight: 100;
         font-size: 15px;
         margin-bottom: 0;
     }
</style>
</head>
<body>
	<div class="dashboard">
		<div class="cardDoc approvalDoc">
			<div style="display: flex; justify-content: space-around; margin-bottom: 20px; background-color: #4E7DF4; height: 70px;">
				<div style="display: flex; align-items: center;">
					<code style="margin-right: 10px; margin-top: 8px; font-size:20px;">*</code>
					<p style="font-weight: bold; margin-bottom: 0; color: white;">문서 선택&ensp;&ensp;</p>
					<select id="docCd" class="form-control form-control-sm custom-input2" style="width:170px; padding: auto 0px;">
						<option disabled style="background-color: #e9ecef;">선택</option>
							<c:forEach var="docForm" items="${documentFormVO}">
								<option value="${docForm.formNo}"
								<c:if test="${docForm.formNo eq 'A29-002'}">selected</c:if>>
								${docForm.docNm}
								</option>
						</c:forEach>
					</select>
				</div>
				<div style="display: flex; align-items: center;">
					<div style="display: flex; align-items: center;" title="결재자의 대기문서 가장 상단에 표시됩니다.">
						<i class="fa-solid fa-circle-question fa-sm" style="margin-right: 10px; color: white;"></i>
						<p style="font-weight: bold; margin-bottom: 0; color: white;">긴급 문서&ensp;&ensp;</p>
						<input id="emrgncyYn" class="form-control form-control-sm custom-input2" type="checkbox" style="width: 17px; accent-color: red;">
						<input type="hidden" id="emrgncyYnValue" value="N">
					</div>
				</div>
				<div style="display: flex; align-items: center;">
					<code style="margin-right: 10px; margin-top: 8px; font-size:20px;">*</code>
					<p style="font-weight: bold; margin-bottom: 0; color: white;">결재 제목&ensp;&ensp;</p>
					<input id="docTtl" class="form-control form-control-sm custom-input2" style="font-size: 15px; width: 400px;" name="approvalTitle" type="text" maxlength="50" placeholder="제목을 입력해주세요. (50자 미만)" data-required="true">
				</div>
			</div>
			<div class="container">
				<div style="border: 2px solid #585D6E; padding: 25px;">
					<div id="paramDocCdNm" class="title">휴가 신청서</div>
	
					<div class="container-table">
						<!-- 좌측 테이블 -->
						<table class="left-table">
							<tr>
								<th>기안 부서</th>
								<td>${employeeVO.deptNm}</td>
							</tr>
							<tr>
								<th>기안자</th>
								<td>${employeeVO.empNm} 
									<c:choose>
										<c:when test="${employeeVO.jbttlNm eq '팀장'}">
											${employeeVO.jbttlNm}
										</c:when>
										<c:otherwise>
											${employeeVO.jbgdNm}
										</c:otherwise>
									</c:choose>
									(${employeeVO.empNo})
								</td>
							</tr>
							<tr>
								<th>기안 일자</th>
								<td>
									<fmt:parseDate var="parsedDate" value="${currentDate}" pattern="yyyyMMdd" />
	                        		<fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd(E)" />
	                        		<span id="hrWrtYmd" style="display: none;"><fmt:formatDate value="${parsedDate}" pattern="yyyyMMdd" /></span>
								</td>
							</tr>
							<tr>
								<th>문서 번호</th>
							</tr>
						</table>
	
						<!-- 우측 테이블 -->
						<table class="right-table">
							<tr>
								<th rowspan="4" style="width:40px;">결재</th>
							</tr>
							
							<tr id="line1">
								<th></th>
								<th></th>
								<th></th>
							</tr>
							
							<tr id="line2">
								<td>미</td>
								<td>지</td>
								<td>정</td>
							</tr>
							
							<tr id="line3">
								<th></th>
								<th></th>
								<th></th>
							</tr>
						</table>
						
					</div>
					<div style="width: 100%; margin-top: 20px;"></div>
					<!-- 테스트용 디비 -->
					<!-- 폼 만들기 시작 -->
					<div id="htmlCdHeight" style="height: 700px;">
						<div id="formChange">
							<div style="margin: 60px auto; margin-bottom: 60px;">
								<p style="font-weight: bold; margin-bottom: 10px;">&ensp;&ensp;&ensp;· 신청인 관련 사항</p>
								<table style="width: 100%;">
									<tr>
										<th style="width: 20%;">부서 명</th>
										<td><input id="empDept" type="text"
											class="form-control form-control-sm custom-input2"
											style="text-align: center;" readonly></td>
										<th style="width: 20%;">직급</th>
										<td><input id="empJbgd" type="text"
											class="form-control form-control-sm custom-input2"
											style="text-align: center;" readonly></td>
									</tr>
									<tr>
										<th>성명</th>
										<td><input id="trgtEmpNm" type="text"
											class="form-control form-control-sm custom-input2"
											style="text-align: center;" placeholder="성명을 입력해주세요." data-required="true"></td>
										<th>연락처</th>
										<td><input id="empTel" type="text"
											class="form-control form-control-sm custom-input2"
											style="text-align: center;" readonly></td>
									</tr>
									<tr>
										<th>휴가 구분</th>
										<td colspan="3" style="padding: 13.5px 60px;">
											<form id="radioForm">
												<div style="display: flex; justify-content: space-around;">
											        <label style="margin-bottom: 0px; font-weight: 100; font-size: 15px;"><input type="radio" name="singleSelect" value="○">&ensp;연차</label>
											        <label style="margin-bottom: 0px; font-weight: 100; font-size: 15px;"><input type="radio" name="singleSelect" value="○">&ensp;월차</label>
											        <label style="margin-bottom: 0px; font-weight: 100; font-size: 15px;"><input type="radio" name="singleSelect" value="○">&ensp;반차 (오전, 오후)</label>
											        <label style="margin-bottom: 0px; font-weight: 100; font-size: 15px;"><input type="radio" name="singleSelect" value="○">&ensp;공가</label>
											        <label style="margin-bottom: 0px; font-weight: 100; font-size: 15px;"><input type="radio" name="singleSelect" value="○">&ensp;병가</label>
											        <label style="margin-bottom: 0px; font-weight: 100; font-size: 15px;"><input type="radio" name="singleSelect" value="○">&ensp;기타 (&emsp;)</label>
												</div>
	    									</form>
	    								</td>
									</tr>
									<tr>
										<th>휴가 기간</th>
										<td colspan="3" style="padding: 0px 32px;">
											<div class="flex items-center space-x-2" style="justify-content: space-around; margin: 5px 0px;">
									        	<span style="font-size: 15px;">시작일</span>
										        <input type="date" id="startDate" name="startDate" class="bg-white h-8 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" value="">
										        <span>-</span>
										        <span style="font-size: 15px;">종료일</span>
										        <input type="date" id="endDate" name="endDate" class="bg-white h-8 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" value="">		        				
										        <span style="font-size: 15px; margin-left: 20px;">사용 일 수</span>
										        <input id="useVcatnDayCnt" type="number" class="form-control form-control-sm custom-input2 ui-autocomplete-input" style="width: 100px;">
										        <span>일</span>
											</div>
										</td>
									</tr>
									<tr>
										<th>휴가 사유</th>
										<td colspan="3" style="height: 250px;">
										<textarea id="vcatnRsn" type="text" class="form-control form-control-sm custom-input2" style="height: 250px;" placeholder="휴가 사유를 입력해주세요. (1200자 미만)" maxlength="1500" data-required="true"></textarea></td>
									</tr>
								</table>
							</div>
	
							<div>
								<p style="text-align: center; margin-bottom: 20px; font-size: 15px;">위 본인은 상기의 사유로 인하여 휴가계를 신청합니다.</p>
							</div>
						</div>
						
						<div>
							<fmt:parseDate var="parsedDate" value="${currentDate}" pattern="yyyyMMdd" />
							<p style="text-align: center; font-size: 15px; margin: 40px auto; margin-bottom: 0px;"><fmt:formatDate value="${parsedDate}" pattern="yyyy년 MM월 dd일" /></p>
						</div>
					</div>
					
					<div>
						<div style="text-align: right; margin-right: 20px;">
							<p id="formattedName" style="font-size: 15px; margin-bottom: 30px;" data-name="${employeeVO.empNm}"></p>
							<p style="font-size: 15px; margin-bottom: 40px;">대 표 자 :&ensp;&ensp; 정 지 훈&ensp;&ensp; (인)</p>
						</div>
						
						<div>
							<p style="font-weight: bold; text-align: center; margin-bottom: 20px;">(주)teamUp</p>
						</div>
					</div>
					<!-- 폼 만들기 끝 -->
				</div>
			</div>
		</div>
		<div class="card approvalLine">
			<div style="display: flex; justify-content: center; border-bottom: 1px solid #D9D9D9; padding: 10px 0px 30px 0px;">
				<div>
					<strong style="font-size: 20px;">결 재 선</strong>
				</div>
			</div>
			
			<div style="display: flex; flex-direction: column; height: 100%;">
				<div style="border-bottom: 1px solid #D9D9D9; flex-grow: 1; ">
					<div style="display: flex; position: relative; background-color: #F3F7FF;">
						<div style="position: absolute; left: 0; top: 0px; bottom: 0px; width: 6px; background-color: #4E7DF4;"></div>
						<div style="display:flex; align-items: center;">
							<span>
								<img src="data:image/png;base64,${employeeVO.proflPhoto}" class="img-circle" style="width: 60px; height: 60px; display: inline-block; margin: 30px;" alt="karina.gif">
							</span>
						</div>
						<div style="display: flex; flex-direction: column; justify-content: center; ">
							<strong>
								${employeeVO.empNm}
								<c:choose>
									<c:when test="${employeeVO.jbttlNm eq '팀장'}">
										${employeeVO.jbttlNm}
									</c:when>
									<c:otherwise>
										${employeeVO.jbgdNm}
									</c:otherwise>
								</c:choose>
							</strong>
							<p style="font-size: 13px;">${employeeVO.deptNm}</p>
							<p style="font-size: 13px;">기안 상신&ensp;|&ensp;-</p>
						</div>
					</div>
					<div id="approvalLineDiv">
						
					</div>
				</div>
				
				<div style="margin-top: 15px;">
					<div style="display:flex; justify-content: space-between; margin: 15px;">
		    			<button id="approvalLineSet" class="btn btn-block btn-default" style="font-size:14px; border-radius: 10px; width: 47%; margin: 0px;">결재선 설정</button>
						<button id="approveBtn" class="blueBtn" style="font-size:14px; border-radius: 10px; width: 47%; margin: 0px;">결재 요청</button>
					</div>
					
					<div style="display:flex; justify-content: center; margin: 15px;">
						<button id="backBtn" class="btn btn-block btn-default" style="font-size:14px; border-radius: 10px;">돌아가기</button>
					</div>
				</div>
			</div>
		</div>
	</div>

<!-- 모달 -->
<div class="relative z-10 hidden" id="modal" role="dialog" aria-modal="true">
	<div class="fixed inset-0 bg-gray-500 bg-opacity-75"></div>

	<div class="fixed inset-0 z-10 w-screen overflow-y-auto">
		<div class="flex min-h-full items-center justify-center p-4">
			<div class="relative transform overflow-hidden rounded-lg bg-white shadow-xl sm:w-full" style="max-width: 80%; width: 800px;">
				<div style="height: 500px; padding: 30px; line-height: 2; padding-bottom: 0px;">
					<div style="height: 100%;">
						<div style="padding-bottom: 30px; border-bottom: 1px solid #D9D9D9; display: flex; justify-content: center;">
							<strong style="font-size: 20px;">결재 정보</strong>
						</div>
						<!-- 작성 시작 -->
						<div class="modalContainer">
							<div style="border: 1px solid #D9D9D9; height: 380px; width: 200px;">
								<p style="text-align: center; font-size: 15px; font-weight: bold; padding: 3px 0px;">조직도</p>
								<div class="input-group" style="border: 1px solid #D9D9D9; border-left: none; border-right: none; padding: 5px;">
									<input id="nameInput" type="text" class="form-control form-control-sm custom-input" style="width: 60%; font-size: 14px; margin-right: 3px;" placeholder="이름"/>
									<button id="searchBtn" type="button" class="btn btn-sm btn-default"><i class="fa fa-search fa-sm"></i></button>
								</div>
									<!-- 테스트 시작 -->
									<div id="searchDiv" style="overflow-y: auto; height: 295px;">
										<nav>
										    <ul class="navLine">
										        <li class="nav-item">
										        	<div class="nav-click">
											            <a href="#" class="toggle-icon"><i class="fa-solid fa-square-plus"></i></a>
											            <span style="font-size: 14px;">경영진</span>
										        	</div>
										            
										            <ul class="nav-treeview1">
										                <div class="column 1">
										                    <c:forEach var="employeeListVO" items="${employeeListVO}">
										                        <c:if test="${employeeListVO.deptCd == 'A17-001'}">
										                            <li class="list-group-item" draggable="true">
										                            	<span style="display: inline; margin-right: 3px; color: #7A7A7A;"><i class="fa-solid fa-user-large"></i></span>
										                                <span style="display: none;"><i class="fa-sharp fa-solid fa-angles-right"></i></span>
										                                <span style="display: none;">결재</span>
										                                <span style="display: inline;">${employeeListVO.empNm} </span>
										                                <span style="display: inline;">${employeeListVO.jbgdNm}</span>
										                                <span style="display: none;">${employeeListVO.deptNm}</span>
										                                <span style="display: none;">${employeeListVO.empNo}</span>
										                                <span style="display: none;"><i class="fa-solid fa-trash"></i></span>
										                            </li>
										                        </c:if>
										                    </c:forEach>
										                </div>
										            </ul>
										        </li>
										        
										        <li class="nav-item">
										        	<div class="nav-click">
											            <a href="#" class="toggle-icon"><i class="fa-solid fa-square-plus"></i></a>
											            <span style="font-size: 14px;">기획부서</span>
										        	</div>
										            
										            <ul class="nav-treeview1">
										                <div class="column 2">
										                    <c:forEach var="employeeListVO" items="${employeeListVO}">
										                        <c:if test="${employeeListVO.deptCd == 'A17-002'}">
										                            <li class="list-group-item" draggable="true">
										                            	<span style="display: inline; margin-right: 3px; color: #7A7A7A;"><i class="fa-solid fa-user-large"></i></span>
										                                <span style="display: none;"><i class="fa-sharp fa-solid fa-angles-right"></i></span>
										                                <span style="display: none;">결재</span>
										                                <span style="display: inline;">${employeeListVO.empNm} </span>
										                                <span style="display: inline;">${employeeListVO.jbgdNm}</span>
										                                <span style="display: none;">${employeeListVO.deptNm}</span>
										                                <span style="display: none;">${employeeListVO.empNo}</span>
										                                <span style="display: none;"><i class="fa-solid fa-trash"></i></span>
										                            </li>
										                        </c:if>
										                    </c:forEach>
										                </div>
										            </ul>
										        </li>
										
										        <li class="nav-item">
										        	<div class="nav-click">
											            <a href="#" class="toggle-icon"><i class="fa-solid fa-square-plus"></i></a>
											            <span style="font-size: 14px;">관리부서</span>
										        	</div>
										            
										            <ul class="nav-treeview1">
										                <div class="column 3">
										                    <c:forEach var="employeeListVO" items="${employeeListVO}">
										                        <c:if test="${employeeListVO.deptCd == 'A17-003'}">
										                            <li class="list-group-item" draggable="true">
										                            	<span style="display: inline; margin-right: 3px; color: #7A7A7A;"><i class="fa-solid fa-user-large"></i></span>
										                                <span style="display: none;"><i class="fa-sharp fa-solid fa-angles-right"></i></span>
										                                <span style="display: none;">결재</span>
										                                <span style="display: inline;">${employeeListVO.empNm} </span>
										                                <span style="display: inline;">${employeeListVO.jbgdNm}</span>
										                                <span style="display: none;">${employeeListVO.deptNm}</span>
										                                <span style="display: none;">${employeeListVO.empNo}</span>
										                                <span style="display: none;"><i class="fa-solid fa-trash"></i></span>
										                            </li>
										                        </c:if>
										                    </c:forEach>
										                </div>
										            </ul>
										        </li>
										
										        <li class="nav-item">
										        	<div class="nav-click">
											            <a href="#" class="toggle-icon"><i class="fa-solid fa-square-plus"></i></a>
											            <span style="font-size: 14px;">영업부서</span>
										        	</div>
										            
										            <ul class="nav-treeview1">
										                <div class="column 4">
										                    <c:forEach var="employeeListVO" items="${employeeListVO}">
										                        <c:if test="${employeeListVO.deptCd == 'A17-004'}">
										                            <li class="list-group-item" draggable="true">
										                            	<span style="display: inline; margin-right: 3px; color: #7A7A7A;"><i class="fa-solid fa-user-large"></i></span>
										                                <span style="display: none;"><i class="fa-sharp fa-solid fa-angles-right"></i></span>
										                                <span style="display: none;">결재</span>
										                                <span style="display: inline;">${employeeListVO.empNm} </span>
										                                <span style="display: inline;">${employeeListVO.jbgdNm}</span>
										                                <span style="display: none;">${employeeListVO.deptNm}</span>
										                                <span style="display: none;">${employeeListVO.empNo}</span>
										                                <span style="display: none;"><i class="fa-solid fa-trash"></i></span>
										                            </li>
										                        </c:if>
										                    </c:forEach>
										                </div>
										            </ul>
										        </li>
										
										        <li class="nav-item">
										        	<div class="nav-click">
											            <a href="#" class="toggle-icon"><i class="fa-solid fa-square-plus"></i></a>
											            <span style="font-size: 14px;">인사부서</span>
										        	</div>
										            
										            <ul class="nav-treeview1">
										                <div class="column 5">
										                    <c:forEach var="employeeListVO" items="${employeeListVO}">
										                        <c:if test="${employeeListVO.deptCd == 'A17-005'}">
										                            <li class="list-group-item" draggable="true">
										                            	<span style="display: inline; margin-right: 3px; color: #7A7A7A;"><i class="fa-solid fa-user-large"></i></span>
										                                <span style="display: none;"><i class="fa-sharp fa-solid fa-angles-right"></i></span>
										                                <span style="display: none;">결재</span>
										                                <span style="display: inline;">${employeeListVO.empNm} </span>
										                                <span style="display: inline;">${employeeListVO.jbgdNm}</span>
										                                <span style="display: none;">${employeeListVO.deptNm}</span>
										                                <span style="display: none;">${employeeListVO.empNo}</span>
										                                <span style="display: none;"><i class="fa-solid fa-trash"></i></span>
										                            </li>
										                        </c:if>
										                    </c:forEach>
										                </div>
										            </ul>
										        </li>
										    </ul>
										</nav>
									</div>
									<!-- 테스트 끝 -->
							</div>
							
							<div id="dragCheck" style="flex-grow: 1; border: 1px solid #D9D9D9;">
								<table style="width: 100%; border-collapse: collapse;">
									<thead>
										<tr style="border-bottom: 1px solid #D9D9D9;">
											<th style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px; width: 50px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px; width: 80px;">타입</th>
											<th style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px;">이름</th>
											<th style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px;">직급</th>
											<th style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px;">부서</th>
											<th style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px; width: 50px;"><i class="fa-solid fa-trash"></i></th>
										</tr>
										<tr>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px; width: 50px;">신청</th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px; width: 80px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px; width: 50px;"></th>
										</tr>
										<tr>
											<td style="padding: 3px 0px; text-align: center; border: none; background-color: #FAFAFA; border-right: 1px solid #D9D9D9; width: 50px; font-size: 15px;" ><i class="fa-sharp fa-solid fa-angles-right"></i></td>
											<td style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px; width: 80px; color: #4E7DF4; font-weight: bold;">기안</td>
											<td style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px;">${employeeVO.empNm}</td>
											<td style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px;">${employeeVO.jbgdNm}</td>
											<td style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; font-size: 15px;">${employeeVO.deptNm}</td>
											<td style="padding: 3px 0px; text-align: center; border: none; background-color: transparent; width: 50px;">-</td>
										</tr>
										<tr style="border-top: 1px solid #D9D9D9;">
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px; width: 50px;">승인</th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px; width: 80px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px;"></th>
											<th style="padding: 3px 0px; text-align: center; border: none; border-bottom:1px solid #D9D9D9; font-size: 15px; width: 50px;"></th>
										</tr>
										<tr id="dragExp" style="border-bottom: 1px solid #D9D9D9;">
											<td style="padding: 3px 0px; text-align: center; border: none; background-color: #FAFAFA; border-right: 1px solid #D9D9D9; width: 50px; font-size: 15px;" ><i class="fa-sharp fa-solid fa-angles-right"></i></td>
											<td colspan="5" style="padding: 4px 0px; text-align: center; border: none; font-size: 15px; color: #999999; font-weight: 100;">드래그하여 결재선을 추가할 수 있습니다.</td>
										</tr>
									</thead>
									<tbody id="approvalLines" class="column second-column" style="height: 39px; border: none;">
									</tbody>
								</table>
							</div>
						</div>
						<!-- 작성 끝 -->
					</div>
				</div>

				<div style="display:flex; justify-content: space-around; margin: 30px;">
					<button id="lineSetClose" class="btn btn-block btn-default" style="width: 30%; margin: 0px; font-size: 14px; border-radius: 10px;">취 소</button>
					<button id="lineSetSave" class="blueBtn">확 인</button>
				</div>
			</div>
		</div>
	</div>
</div>

</body>
</html>