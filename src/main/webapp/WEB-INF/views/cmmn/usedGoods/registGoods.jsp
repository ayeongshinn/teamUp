<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.6.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>
<script src="/resources/ckeditor5/ckeditor.js"></script>

<script>
$(document).ready(function() {
    // 파일 선택 창 열기 (업로드 버튼 클릭 시)
    $('#uploadBtn').on('click', function() {
        $('#uploadFile').click();
    });

    // 숫자에 쉼표 추가 함수
    function formatNumberWithCommas(number) {
        return number.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    // 판매 가격 필드에 자동 쉼표 추가
    $('#price').on('keyup', function() {
        let value = $(this).val().replace(/,/g, '');
        if (!isNaN(value) && value !== '') {
            $(this).val(formatNumberWithCommas(value));
        } else {
            $(this).val('');
        }
    });

    // 파일 선택 시 미리보기 처리
    $('#uploadFile').on('change', function(e) {
        let files = e.target.files;
        let fileArr = Array.prototype.slice.call(files);

        // 기존의 파일 미리보기 제거
        $("#filePreview").empty();

        fileArr.forEach(function(f) {
            // 이미지 파일인지 확인
            if (!f.type.startsWith("image/")) {
                Swal.fire("이미지 파일만 업로드할 수 있습니다.");
                return;
            }

            let reader = new FileReader();
            reader.onload = function(event) {
                // 이미지 미리보기와 삭제 버튼을 포함한 HTML 구조 생성
                let imgElement = `
                    <li class="relative inline-block mx-1.5">
                        <img src="\${event.target.result}" style="width: 120px !important; height: 110px; border: 1px solid #D7DCE1;" class="object-cover rounded-md border-gray-300">
                        <button type="button" class="absolute top-[-5px] right-0 -mt-1 -mr-1 w-5 h-5 bg-white rounded-full border border-gray-300 text-gray-600 hover:bg-gray-100 deletePreview" style="line-height: 0; padding: 0;">
                            <span style="position: relative; top: -1px; font-size: 1rem;">×</span>
                        </button>
                    </li>`;
                $("#filePreview").append(imgElement);
                updateFileCount(); // 파일 추가 후 업데이트
            };
            reader.readAsDataURL(f);
        });
    });

    // 삭제 버튼 클릭 이벤트
    $(document).on('click', '.deletePreview', function(e) {
        e.stopPropagation(); // 삭제 버튼 클릭 시 부모 요소 클릭 이벤트 방지
        $(this).closest('li').remove(); // 클릭한 li 요소만 삭제
        updateFileCount(); // 파일 삭제 후 업데이트
    });

    // 파일 개수 업데이트 함수
    function updateFileCount() {
        let count = $("#filePreview li").length;
        $('#countImg').text(count + "/10");
    }

    $("#registUsedGoods").on("click", function() {
    	console.log("버튼 클릭 ");
        let formData = new FormData();
        let bbsTtl = $("#goodsBbsTtl").val();
        let empNo = $("#goodsEmpNo").val();
        let bbsCn = window.editor.getData(); // CKEditor의 내용을 가져옴
        let price = $("#price").val().replace(/,/g, '');

        formData.append("bbsTtl", bbsTtl);
        formData.append("empNo", empNo);
        formData.append("bbsCn", bbsCn); // 에디터에서 가져온 내용 추가
        formData.append("price", price);

        let filesTemp = $("#uploadFile")[0];
        let files = filesTemp.files;
//         let filesTemp = $("#uploadFile")[0].files;
//         let files = Array.prototype.slice.call(filesTemp);

//         console.log("files : " , files);
        
        for (let i = 0; i < files.length; i++) {
            formData.append("uploadFile", files[i]);
        }

        $.ajax({
            url: "/usedGoods/registUsedGoods",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "text",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
            	console.log("result : ", result);
                Swal.fire({
                    icon: 'success',
                    title: '상품이 성공적으로 등록되었습니다.',
                }).then(() => {
                    location.href = "/usedGoods/list";
                });
            },
            error: function(xhr, status, error) {
                console.error("등록 실패:", error);
                Swal.fire({
                    icon: 'error',
                    title: '상품 등록 중 오류가 발생했습니다.',
                });
            }
        });
    });

    // Initialize CKEditor
    ClassicEditor
    .create(document.querySelector('#goodsBbsCnEditor'), {
        ckfinder: {
            uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'
        },
        toolbar: [], // 도구 모음 숨기기
        removePlugins: ['AutoGrow']
    })
    .then(editor => {
        window.editor = editor;
        const editable = editor.ui.view.editable.element;
        editable.style.height = '300px';  // 고정된 높이 설정
        editable.style.overflowY = 'auto';  // 세로 스크롤 가능
    })
    .catch(err => {
        console.error(err.stack);
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
}

.ck-editor__editable {
   margin-top:30px;
   height: 300px !important;  /* 높이를 400px로 고정 */
   overflow-y: auto !important;  /* 세로 스크롤바를 자동으로 생성 */
   resize: none;  /* 사용자가 크기를 조절할 수 없도록 설정 */
   border-radius: 8px !important; /* 모서리를 둥글게 설정 */
}


.ck.ck-editor__top.ck-reset_all {
	display:none;
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

.description {
    display: flex;
    align-items: center; /* 수직 가운데 정렬 */
    gap: 10px; /* 텍스트와 이미지 사이 간격 */
}
.ck.ck-reset.ck-editor.ck-rounded-corners {
	margin-top:-20px;
}
.tooltip-btn {
    position: relative;
    display: inline-flex;
    align-items: center;
    cursor: pointer; /* 마우스 커서 변경 */
}

.tooltip-btn .tooltiptext {
    visibility: hidden;
    width: 260px; /* 툴팁의 너비를 조정하여 길게 설정 */
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
    margin-left: 11px; /* 화살표를 중앙으로 맞추기 위한 오프셋 */
    border-width: 5px;
    border-style: solid;
    border-color: black transparent transparent transparent; /* 화살표 색상 설정 */
}

.tooltip-btn .tooltiptext::after {
    left: calc(50% - 10px); /* 왼쪽으로 조정하여 물음표와 맞추기 */
}

.tooltiptext {
    display: inline-block;
    text-align: left;
    width: auto;  /* 필요한 너비 설정 */
    padding: 8px;
    background-color: #f9f9f9;
    border: 1px solid #ccc;
    border-radius: 5px;
    max--width:40px !important;
}
</style>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>


    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 mt-5">
<div class="relative flex flex-col w-full h-full text-gray-700 bg-white rounded-lg bg-clip-border" style="min-width: 500px; min-height: 400px;">
    <div class="mx-auto max-w-[1280px] px-4 md:px-8 2xl:px-16 box-content" style="width: 100%; min-height: 300px;">
    
  	    <div>
              <h3 class="font-semibold text-slate-800 ml-7" style="font-size:20px; color:#4E7DF4; margin-top:50px;">상품 등록</h3>
        </div>
            
        <div class="mx-auto w-full max-w-[1000px] pt-[72px]">
<!--           <div class="bg-blue-100 border border-blue-300 text-blue-800 px-4 py-2 rounded-md mb-6 text-sm flex items-center " style="width:100%;height:150px;"> -->
<!-- 			    <i class="fi fi-rr-info" style="margin-top: 5px !important;margin-right:15px;"></i> -->
<!-- 			    <p style="line-height:1.6;">"이 커뮤니티는 회사 동료들 간의 신뢰를 바탕으로 운영됩니다."<br> -->
<!-- 					모든 거래는 실명으로 진행되며, 거래 중에는 예의를 지켜주십시오. 거래가 완료되면 ‘판매 완료’ 상태로 변경해주세요.<br> -->
<!-- 					또한, 회사 내부 규정을 준수하며, 업무 시간에 방해가 되지 않도록 거래 시간과 장소를 신중히 선택해 주시기 바랍니다. <br>불필요한 오해를 방지하기 위해 상품 설명과 상태를 정확히 기재하고, 상호 존중을 바탕으로 원활한 거래를 진행해 주세요.</p> -->
<!-- 		  </div> -->

        
		  <div class="mt-[-40px;] mb-5 p-4 bg-gray-50 border border-gray-300 rounded-md" style="width: 949px; !important;">
			    <h3 class="text-lg font-semibold text-gray-800 mb-2">유의사항 및 거래 가이드</h3>
			    
			    <ul class="text-sm text-gray-700 list-disc pl-6">
			        <li>
			            <a href="#" class="text-blue-600 hover:underline">안전한 거래를 위한 가이드</a>를 확인하여 거래 중 주의할 점을 숙지해 주세요.
			        </li>
			        <li class="mt-1">
			            회사 내부 규정에 따라 <span class="font-semibold">부적절한 상품 등록</span>은 제한됩니다. 규정을 준수하여 안전한 거래 환경을 조성합시다.
			        </li>
			        <li class="mt-1">
			            불법, 비도덕적인 상품이나 서비스, 회사 정책에 반하는 상품은 등록을 금지합니다.
			        </li>
			        <li class="mt-1">
			            거래 중 문제가 발생할 경우, 회사 커뮤니티 운영 규칙에 따라 문제를 해결해 주세요.
			        </li>
			    </ul>
			</div>
	 <div style="margin-left:-45px;">
		  <p class="font-semibold text-base lg:text-base mb-3 ml-5">상품 이미지</p>
            <div class="flex px-5 pb-1.5">
               <div class="bg-white rounded-md border border-gray-300 flex items-center justify-center" style="width:120px !important;height:110px !important;">
                    <input id="uploadFile" name="media" type="file" multiple=""
                           accept="image/png, image/jpeg, image/jpg" class="hidden" />
                    <button id="uploadBtn" class="flex items-center justify-center w-20 h-20 ml-1.5 mr-1.5 bg-jnGray-200 rounded">
                        <div class="flex flex-col">
                            <svg width="32px" height="32px" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                      d="M15.728 20.4461C13.6481 20.4461 11.9619 18.7599 11.9619 16.68C11.9619 14.6001 13.6481 12.9138 15.728 12.9138C17.8079 12.9138 19.4942 14.6001 19.4942 16.68C19.4942 18.7599 17.8079 20.4461 15.728 20.4461Z"
                                      fill="#C2C6CE"></path>
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                      d="M10.4564 7.32295C10.9376 6.00587 11.5097 5.15997 12.8118 5.15997H17.9241C19.2253 5.15997 19.7975 6.00463 20.2785 7.32003H20.7897C24.7543 7.32003 27.968 10.4192 27.968 14.2417V19.119C27.968 22.9409 24.7543 26.04 20.7897 26.04H10.6669C6.7023 26.04 3.48798 22.9409 3.48798 19.119V14.2417C3.48798 10.487 6.58918 7.4303 10.4564 7.32295ZM21.3772 16.68C21.3772 19.8001 18.8481 22.3292 15.728 22.3292C12.6079 22.3292 10.0788 19.8001 10.0788 16.68C10.0788 13.5599 12.6079 11.0308 15.728 11.0308C18.8481 11.0308 21.3772 13.5599 21.3772 16.68ZM21.5988 11.88C21.5988 12.4 22.0204 12.8216 22.5403 12.8216C23.0603 12.8216 23.4819 12.4 23.4819 11.88C23.4819 11.36 23.0603 10.9385 22.5403 10.9385C22.0204 10.9385 21.5988 11.36 21.5988 11.88Z"
                                      fill="#C2C6CE"></path>
                            </svg>
                            <p id="countImg" class="mt-1 text-sm text-jnGray-500" >0/10</p>
                        </div>
                    </button>
                </div>
                <ul id="filePreview" class="flex items-center" ></ul>
            </div>

<form id="registGoods" class="flex flex-col justify-center mt-6 lg:mt-8">
    <input type="hidden" id="goodsEmpNo" name="empNo" value="${empVO.empNo}"/>
    
    <!-- 상품명 입력 필드 -->
    <div class="flex flex-col px-5 space-y-5 mt-[-20px;]">
        <p class="font-semibold text-base lg:text-base">상품명</p>
        <div class="block">
            <input id="goodsBbsTtl" name="bbsTtl" type="text" placeholder="상품명" 
                class="py-1 px-3 md:px-5 w-full appearance-none border text-input text-base lg:text-base font-body placeholder-body min-h-10 transition duration-200 ease-in-out bg-white border-gray-300 focus:border-heading h-11 md:h-12 focus:outline-none rounded-md"
                autocomplete="off" spellcheck="false" aria-invalid="false">
        </div>
    </div>
    
    <!-- 판매 가격 입력 필드 -->
    <div class="flex flex-col px-5 mt-3">
        <p class="font-semibold text-base lg:text-base mb-3">판매가격</p>
        <label for="price" class="w-full bg-white rounded-md">
            <div class="flex items-center justify-between w-full border border-gray-300 rounded-md px-4 h-11 md:h-12">
                <span>₩</span>
                <input id="price" name="price" type="text" placeholder="판매가격" style="height:8px;"
                    class="py-1 px-3 md:px-5 w-full appearance-none text-input text-base lg:text-base font-body placeholder-body min-h-10 transition duration-200 ease-in-out bg-white h-11 md:h-12 focus:outline-none rounded-md placeholder:font-light"
                    autocomplete="off" spellcheck="false" aria-invalid="false">
            </div>
        </label>
    </div>

    <!-- CKEditor 적용된 상품 설명 필드 -->
    <div class="flex flex-col px-5 space-y-4 mt-3">
        <div class="description flex items-center gap-2">
            <p class="font-semibold text-base lg:text-base">상품 설명</p>
	      	<div class="tooltip-btn">
		        <img src="/resources/images/Q.png" style="width: 18px; height: 18px; margin-top: -1px; opacity: 0.7; margin-left: 10px !important;" />
				<span class="tooltiptext">
				    <ul style="text-align: left; padding: 0; margin: 0; list-style: none;">
				        <li>
				            <p><strong>제품 상태 : </strong> 새 제품, 사용감 등 상태</p>
				        </li>
				        <li>
				            <p><strong>사용 기간 : </strong> 사용 기간과 빈도</p>
				        </li>
				        <li>
				            <p><strong>특이사항 : </strong> 고장이나 수리 기록 등</p>
				        </li>
				    </ul>
				</span>
		    </div>
        </div>
        <div class="relative mt-[20px]">
            <div id="goodsBbsCnEditor" class="px-4 py-3 items-center w-full font-normal rounded-md appearance-none transition duration-300 ease-in-out text-heading text-sm focus:outline-none focus:ring-0 bg-white border border-gray-300 focus:shadow focus:border-heading placeholder-body inline-block w-full h-[220px] overflow-hidden resize-none mt-[80px]"></div>
        </div>
        <div class="flex gap-3 justify-end mt-8">             
             <button type="button" class="shadow-xs text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
					 style="background-color: #848484;" onclick="history.back()">취소</button>   
             <button type="button" id="registUsedGoods" class="shadow-xs text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
					 style="background-color: #4E7DF4;">등록</button>
        </div>
    </div>
</form>
</div>
                <br><br>
            </div>
        </div>
    </div>
</div>
<br><br>
