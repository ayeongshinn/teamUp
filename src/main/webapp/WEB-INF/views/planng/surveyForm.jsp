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
<script src="https://cdnjs.cloudflare.com/ajax/libs/Sortable/1.14.0/Sortable.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script type="text/javascript">

$(document).ready(function() {
	
	// 시작일시가 변경될 때 실행
    $("input[name='srvyBgngDate'], input[name='srvyBgngTm']").on('change', function() {
    	  const startDate = $("input[name='srvyBgngDate']").val();
          const startTime = $("input[name='srvyBgngTm']").val();

          if (startDate && startTime) {
              // 종료일시에 최소값 설정
              $("input[name='srvyEndDate']").attr('min', startDate);

              // 종료일시가 시작일시와 동일할 경우 종료 시간 제한
              $("input[name='srvyEndDate'], input[name='srvyEndTm']").on('change', function() {
                  const endDate = $("input[name='srvyEndDate']").val();
                  const endTime = $("input[name='srvyEndTm']").val();

                  if (endDate === startDate) {
                      // 시작 시간보다 빠른 종료 시간을 설정할 수 없도록 제한
                      $("input[name='srvyEndTm']").attr('min', startTime);

                      // 종료 시간이 시작 시간보다 빠를 경우 경고
                      if (endTime && endTime < startTime) {
                    	  $("input[name='srvyEndDate']").before('<span class="error-message text-red-500 mr-1 text-sm flex items-center">종료 일시는 시작 일시 이후여야 합니다</span>');
                      } else {
                    	  $(".error-message").remove();
                      }
                  } else {
                      // 종료일시가 시작일시와 다르면 시간 제한 해제
                      $("input[name='srvyEndTm']").removeAttr('min');
                      $("#dateError").hide();
                  }
              });
          }
    });
	
	//오늘 날짜를 구함
    const today = new Date().toISOString().split('T')[0];

    //시작일과 종료일에 오늘 날짜를 최소값으로 설정
    $("input[name='srvyBgngDate'], input[name='srvyEndDate']").attr('min', today);

    function updateIndexes(container) {
		//인덱스의 모든 항목 가져오고
		const items = container.children;
		//각 항목에 대해 새로운 인덱스 설정
 		for(let i = 0; i < items.length; i++) {
 			const item= items[i];
 			//새로운 인덱스 설정
 			const newIndex = i;
 			//각 항목의 input name 속서 업데이트 
 			const optionInput = $(item).find('input[type="text"]');
 			if(optionInput.length > 0) {
 				//srvyQstVOList[0].optionList[0].optionCn
 				optionInput.attr('name', `srvyQstVOList[\${questionIndex}].optionList[\${newIndex}].optionCn`);
 			}
 		}
	}
	
	//스크롤 시 발생하는 이벤트
    $(window).scroll(function() {
        if ($(this).scrollTop() > 50) { //스크롤이 200px 이상일 때
            $('#scrollTopBtn').fadeIn(); //버튼 나타남
        } else { 
            $('#scrollTopBtn').fadeOut(); //버튼 사라짐
        }
    });

    //버튼 클릭 시 페이지 맨 위로 이동
    $('#scrollTopBtn').click(function() {
        $('html, body').animate({scrollTop: 0}, '300'); //300ms 동안 부드럽게 이동
        return false;
    });
	
	//CKeditor 처리
	$(".ck-blurred").keydown(function(){
		console.log("str : " + window.editor.getData());
		
		$("#srvyCn").val(window.editor.getData());
	});
	
	$(".ck-blurred").on("focusout",function(){
		$("#srvyCn").val(window.editor.getData());
	});

	 //익명 Y/N
    $('#annmsCheck').on('change', function() {
        if ($(this).is(':checked')) {
            $('#annmsYn').val('Y');
        } else {
            $('#annmsYn').val('N');
        }
        console.log('annmsYn:', $('#annmsYn').val());
    });

    //결과 Y/N
    $('#resOpenCheck').on('change', function() {
        if ($(this).is(':checked')) {
            $('#resOpenYn').val('Y');
        } else {
            $('#resOpenYn').val('N');
        }
        console.log('resOpenYn:', $('#resOpenYn').val());
    });
	
	//익명 체크 시
	$("#annmsCheck").on("change", function() {
		if($(this).is(':checked')) {
			$("#annmsN").hide();
			$("#annmsY").show();
		} else {
			$("#annmsY").hide();
			$("#annmsN").show();
		}
	})
	
	//설정 접고 펼치기
    $('#toggleBtn').on('click', function() {
        $('#surveySettings').slideToggle();
    });
	
	//전체 or 부서 선택 radio
	$('input[type="radio"]').change(function() {
		var groupName = $(this).attr('name');
	    
	    $('label[for="' + $(this).attr('id') + '"]').addClass('active');
	    $(this).prop('checked', true);
	    
	    $('input[type="radio"][name="' + groupName + '"]').not(this).each(function() {
	        $('label[for="' + $(this).attr('id') + '"]').removeClass('active');
	        $(this).prop('checked', false);
	    });
	});
	
    var questionIndex = 0;
    
    //모달 열기
    $("#addOption").on("click", function() {
        $("#addOptionModal").show();
    });

    //모달에서 객관식 또는 서술형 선택 후 div 추가
    $("#confirm").on("click", function() {
       	questionIndex = $(".clsQst").length;
        if ($("#multiple").prop("checked")) {
        	
            console.log("questionIndex : " + questionIndex);
        	
            var newDiv = `
            	<div class='flex justify-center mt-3' id='multipleDiv_\${questionIndex}'>
                <div class='w-[700px] relative'>
                    <div class='h-auto bg-white rounded-xl pb-5'>
                        <div class='flex px-10 mb-1 items-center pt-5 w-full'>
                            <span class='absolute top-2 right-2 text-lg text-gray cursor-pointer delete-div mr-3'>×</span>
                            <input type='hidden' name='quesCdList[\${questionIndex}]' value='A27-001'>
                            <input type='text' name='srvyQstVOList[\${questionIndex}].quesCn' placeholder='질문을 입력하세요.' class='font-bold w-full clsQst'>
                        </div>
                        <div class='px-10 pb-3 w-full'>
                            <input type='text' name='srvyQstVOList[\${questionIndex}].quesExp' placeholder='설명을 입력하세요.' class='w-full'>
                        </div>
                        <div class='px-10'>
                            <ul id='multipleChoiceList_\${questionIndex}' class='space-y-2'>
                                <li class='flex items-center space-x-3 bg-white rounded'>
                                    <span class='cursor-move text-gray'>☰</span>
                                    <input type='text' name='srvyQstVOList[\${questionIndex}].optionList[0].optionCn'
                                            placeholder='객관식 항목 입력' class='flex-1 bg-white border rounded p-2 clsOpt\${questionIndex}'>
                                    <button class='remove-item text-gray'>×</button>
                                </li>
                            </ul>
                            <div class='mt-2'>
                                <button type='button' data-qst-idx='\${questionIndex}' class='text-sm text-blue-600 addItemBtn'>+ 항목 추가</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            `;
            //새로운 div를 화면에 추가
            $('#multipleDivContainer').append(newDiv);

            //모달 닫기
            $("#addOptionModal").hide();
            
         	//추가된 multipleChoiceList에 대해 Sortable 적용
            new Sortable(document.getElementById(`multipleChoiceList_\${questionIndex}`), {
                animation: 150,
                ghostClass: 'sortable-ghost',
                handle: '.cursor-move',
                onEnd: function(evt) {
                	//항목 순서가 바뀔 때 인덱스 업데이트
                	updateIndexes(evt.from);
                }
            });

          //객관식 선택 시
          //questionIndex++;
         	
        } else if ($("#descript").prop("checked")) {
            
            //서술형 선택 시 새로운 div 추가
            var newDiv = `
            	<div class='flex justify-center mt-3' id='descriptDiv_\${questionIndex}'>
                <div class='w-[700px] relative'>
                    <div class='h-auto bg-white rounded-xl pb-5'>
                        <div class='flex px-10 mb-1 items-center pt-5 w-full'>
                            <span class='absolute top-2 right-2 text-lg text-gray cursor-pointer delete-div mr-3'>×</span>
                            <input type='hidden' name='quesCdList[\${questionIndex}]' value='A27-002'>
                            <input type='text' name='srvyQstVOList[\${questionIndex}].quesCn' placeholder='질문을 입력하세요.' class='font-bold w-full clsQst'>
                        </div>
                        <div class='px-10 pb-2 w-full'>
                            <input type='text' name='srvyQstVOList[\${questionIndex}].quesExp' placeholder='설명을 입력하세요.' class='w-full'>
                        </div>
                        <div class='px-10 w-full'>
                            <div class='w-full bg-gray-100 rounded-xl'>
                                <span class='text-gray px-3 py-3 text-sm pt-1 pb-1'> 자유 입력 </span>
                            </div>
                            <span class='text-gray text-xs'>응답자가 자유롭게 답변을 입력할 수 있습니다</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
            //새로운 div를 화면에 추가
            $('#multipleDivContainer').append(newDiv);

            //모달 닫기
            $("#addOptionModal").hide();
        }
    });

    //취소 버튼 클릭 시 모달 닫기
    $("#cancelBtn").on("click", function() {
        $("#addOptionModal").hide();
    });
    
    //나. 항목 추가 버튼 (객관식 항목 추가)
    $(document).on('click', '.addItemBtn', function() {
    	//객관식 항목 추가가 될 대상 질문의 인덱스 번호  
    	let qstIdx = $(this).data("qstIdx");
    	console.log("qstIndex : " + qstIdx);
    	//대상 질문의 인덱스번호를 통해 객관식 항목의 name값을 구성함
    	let optIdx = $(".clsOpt"+qstIdx).length;
    	console.log("optIdx : " + optIdx);
    	
        var newItem = `
            <li class="flex items-center space-x-3 bg-white rounded">
                <span class="cursor-move text-gray">☰</span>
                <input type="text" name="srvyQstVOList[\${qstIdx}].optionList[\${optIdx}].optionCn" placeholder="객관식 항목 입력" class="flex-1 bg-white border rounded p-2 clsOpt\${qstIdx}">
                <button class="remove-item text-gray">×</button>
            </li>
        `;
        $(this).closest('.flex').find('ul').append(newItem);
    });

    //항목 삭제 버튼
    $(document).on('click', '.remove-item', function() {
        $(this).parent().remove();
    });
    
    //div 삭제 버튼
    $(document).on("click", '.delete-div', function() {
    	Swal.fire({
			title: '질문을 삭제하시겠습니까?',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#4E7DF4',
			confirmButtonText: '확인',
			cancelButtonText: '취소',
			reverseButtons: true,
		}).then((result) => {
			if(result.isConfirmed) {
				$(this).closest('[id^="multipleDiv_"], [id^="descriptDiv_"]').remove();
			}
		});
    })
});

</script>
<title></title>
</head>
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
	
	/* 기본 상태 */
	.filter-link {
	    background-color: white;
	    color: gray;
	}
	
	/* 체크된 상태 */
	.custom-radio-group input[type="radio"]:checked + label {
	    background-color: #4E7DF4;
	    color: white;
	}
	
	.ck-editor__editable {
	    border-radius: 10px !important; /* 기본적으로 테두리 둥글게 */
	    border: 1px solid #ccc; /* 기본 테두리 색상 */
	    outline: none !important;
	}
	
	.ck-editor__editable:focus {
	    border-radius: 10px !important; /* 포커스 상태에서 테두리 둥글게 유지 */
	    border-color: #4E7DF4 !important; /* 포커스 시 테두리 색상 변경 */
	    outline: none !important;
	}
	
	.ck-reset_all {
		display: none;
	}
	
	#scrollTopBtn {
	    display: none;
	    position: fixed;
	    bottom: 50px;
	    right: 50px;
	    z-index: 99; 
	    background-color: #333;
	    color: white;
	    border: none;
	    padding: 20px;
	   	width: 50px;
	   	height: 50px;
	    border-radius: 50%;
	    cursor: pointer;
	}

</style>
<body>
<form id="frm" name="frm" action="/registSurvey" method="post">
	<input type="hidden" name="srvyEmpNo" value="${empVO.empNo}" />
	
		<!-- 설문 설정 -->
		<div class="flex justify-center">
		    <div class="w-[700px]">
		        <div class="h-auto bg-white rounded-xl mb-3">
		            <div class="flex px-4 py-3 items-center cursor-pointer" id="toggleBtn">
		               <img alt="settingIcon" src="/resources/images/settingIcon.png">
		               <span class="text-md ml-2 text-gray-500">설정</span>️
		            </div>
		            <div id="surveySettings" class="hidden">
		             <!-- 시작일시 -->
				    <div class="flex justify-between items-center w-full mt-2 mb-2">
				        <label class="text-sm ml-4 text-gray-500">시작일시</label>
				        <div class="flex space-x-2">
				            <input type="date" name="srvyBgngDate" class="dateTime border rounded-md px-2 py-1 text-sm" required>
				            <input type="time" name="srvyBgngTm" class="dateTime border rounded-md px-2 py-1 mr-4 text-sm" required>
				        </div>
				    </div>
				    <hr class="mt-2 mb-2">
				    <!-- 종료일시 -->
				    <div class="flex justify-between items-center w-full mt-2 mb-2">
				        <label class="text-sm ml-4 mt-2 text-gray-500">종료일시</label>
				        <div class="flex space-x-2">
				            <input type="date" name="srvyEndDate" class="dateTime border rounded-md px-2 py-1 text-sm" required>
				            <input type="time" name="srvyEndTm" class="dateTime border rounded-md px-2 py-1 mr-4 text-sm " required>
				        </div>
				    </div>
				    <hr class="mb-2">
				    <!-- 익명 응답 받기 -->
				    <div class="flex justify-between items-center w-full">
				        <label class="text-sm ml-4 mt-2 text-gray-500">익명으로 응답 받기</label>
				        <input type="checkbox" id="annmsCheck" class="mr-4">
				        <input type="hidden" name="annmsYn" id="annmsYn" value="N">
				    </div>
				    <hr class="mt-1 mb-2">
				    <!-- 응답자에게 결과 공개 -->
				    <div class="flex justify-between items-center w-full pb-2">
				        <label class="text-sm ml-4 mt-2 text-gray-500">응답자에게 결과 공개</label>
				        <input type="checkbox" id="resOpenCheck" class="mr-4">
				        <input type="hidden" name="resOpenYn" id="resOpenYn" value="N">
				    </div>
		        </div>
	        </div>
	    </div>
	</div>
		
	<!-- 설문 제목 입력 -->
	<div class="flex justify-center">
		<div class="w-[700px]">
			<div class="h-auto bg-white rounded-xl">
				<div class="flex px-10 pt-10 items-center">
		            <div class="inline-flex rounded-md mr-2 custom-radio-group" role="group">
					    <input type="radio" id="all" value="A03-006" name="srvyTarget" class="hidden" checked>
					    <label for="all" class="filter-link px-2.5 py-1 rounded-l-lg border border-gray-200 text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 cursor-pointer">
					        전체
					    </label>
					    <input type="radio" id="dept" value="${empVO.deptCd}" name="srvyTarget" class="hidden">
					    <label for="dept" class="filter-link px-2.5 py-1 rounded-r-md border border-gray-200 text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 cursor-pointer">
					        부서
					    </label>
					</div>
	                <span class="bg-yellow-200 text-yellow-700 text-sm font-semibold px-2 py-1 rounded-lg mb-2" id="annmsN">실명</span>
	                <span class="bg-blue-100 text-blue-700 text-sm font-semibold px-2 py-1 rounded-lg mb-2" style="display:none;" id="annmsY">익명</span>
	            </div>
				 <div class="flex px-10 mb-1 items-center">
	                <label class="text-red-500 mr-1">*</label>
	                <input type="text" name ="srvyTtl" placeholder="설문 제목을 입력하세요" class="text-lg font-bold w-full" maxlength="40" required>
	            </div>
				<div class="px-10 pb-10 mt-2">
					<textarea style="resize: none; overflow-y: auto;" name="srvyCn" id="srvyCn" placeholder="설문 설명을 입력하세요" class="w-full"></textarea>
				</div>
				<div class="justify-center flex" id="plusDiv">
					<input type="button" id="addOption" value="구성 추가" class="text-blue-600 mb-4" style="cursor: pointer;">
				</div>
			</div>
		</div>
	</div>
	<!-- 설문 제목 입력 끝 -->
	
	<!-- 설문 질문이 추가될 컨테이너 -->
	<div id="multipleDivContainer" class="justify-center mt-3"></div>
	
	<!-- 구성 추가 모달 -->
	<div class="relative z-10" id="addOptionModal" aria-labelledby="modal-title" role="dialog" aria-modal="true" style="display:none;">
	  <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
	
	  <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
	    <div class="flex min-h-full items-center justify-center p-4 text-center">
	      <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:max-w-2xl sm:w-[300px]">
	        
	        <div class="bg-white px-4 pb-4 pt-4 sm:p-6">
	        <span class="ml-1 text-lg font-bold mb-3 block">구성 추가</span>
			  <hr class="px-4 py-2">
			  <table style="width: 100%;" class="text-center">
			    <tr>
				    <td>
						<input type="radio" name="quesCd" id="multiple"/>
			            <label class="text-base font-semibold leading-6 text-gray-900">객관식</label>
			        </td>
			        <td>
			        	<input type="radio" name="quesCd" id="descript"/>
						<label class="text-base font-semibold leading-6 text-gray-900">서술형</label>			        	
					</td>
				</tr>
			   </table>
			</div>

	        <div class="bg-gray-50 px-4 py-3 flex justify-center">
	          <button type="button" id="cancelBtn" class="inline-flex justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">취소</button>
	          <button type="button" id="confirm" class="inline-flex justify-center rounded-md ml-2 px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset ring-gray-300"
					   style="background-color: #4E7DF4">추가</button>
	        </div>
	      </div>
	    </div>
	  </div>
	</div>
	<!-- 구성 추가 모달 끝 -->
	<sec:csrfInput/>
</form>

<!-- 스크롤 상단으로 이동 버튼 -->
<button id="scrollTopBtn" style="display:none; position: fixed; bottom: 40px; right: 40px; z-index: 99; background-color: #333; color: white; border: none; padding: 10px; border-radius: 50%;">
    ↑
</button>

<script src="/resources/ckeditor5/ckeditor.js"></script>
<script>
	
	ClassicEditor
	.create(document.querySelector('#srvyCn'), {
	    ckfinder: {
	        uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'
	    },
	   	toolbar: [],
	    removePlugins: ['AutoGrow']
	})
	.then(editor => {
	    window.editor = editor;
	    const editable = editor.ui.view.editable.element;
	    editable.style.height = '55px';
	    editable.style.overflowY = 'auto';
	    editable.style.borderRadius = '10px';
	})
	.catch(err => {
	    console.error(err.stack);
	});

</script>
</body>
</html>