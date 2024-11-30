<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.0/dist/sweetalert2.min.js"></script>


<script type="text/javascript">

function handleImg(e){
	   //e.target : <input type="file" id="uploadFile"..>
	   let files = e.target.files;//선택한 파일들
	   //fileArr = [a.jpg,b.jpg,c.jpg]
	   let fileArr = Array.prototype.slice.call(files);
	   //f : a.jpg객체
	   let accumStr = "";
	   fileArr.forEach(function(f){
	      //이미지가 아니면
	      if(!f.type.match("image.*")){//MIME타입
//	       if(!f.type.match("*.jpg")){
	         alert("이미지 확장자만 가능합니다.");
	         return;//함수 종료
	      }
	      //이미지가 맞다면
	      let reader = new FileReader();
	      //e : reader가 이미지 객체를 읽는 이벤트
	      reader.onload = function(e){
	         accumStr += "<img src='"+e.target.result+"' style='width:20%;border:1px solid #D7DCE1;' />";
	   //요소.append : 누적, 요소.html : 새로고침, 요소.innerHTML : J/S에서 새로고침
	         $("#pImg").html(accumStr);
	      }
	      reader.readAsDataURL(f);
	   });
	}
	   

$(document).ready(function(){

   //이미지 미리보기 시작 /////
   $("#uploadFile").on("change",handleImg);
   //이미지 미리보기 끝 /////
   
   	// 이미지 파일 변경 시 기존 이미지 대체
	$("#modalUploadFile").on("change", function(e) {
	    let files = e.target.files;
	    let fileArr = Array.prototype.slice.call(files);
	    let imgPreview = "";
	
	    fileArr.forEach(function(f) {
	        // 이미지 파일만 허용
	        if (!f.type.match("image.*")) {
	            alert("이미지 파일만 가능합니다.");
	            return;
	        }
	        
	        let reader = new FileReader();
	        reader.onload = function(e) {
	            // 기존 이미지를 새 이미지로 대체
	            imgPreview += "<img src='" + e.target.result + "' style='width:20%;border:1px solid #D7DCE1;' />";
	            $("#divFileSaveLocate").html(""); // 기존 이미지를 제거
	            $("#modalImgPreview").html(imgPreview); // 새로운 이미지로 대체
	        };
	        reader.readAsDataURL(f);
	    });
	});
   
    $('#selectAll').change(function() {
        let isChecked = $(this).prop('checked');
        $('tbody input[type="checkbox"]').prop('checked', isChecked);
    });

    // 개별 체크박스 상태 변경 시 "전체 선택" 체크박스 상태 변경
    $('tbody input[type="checkbox"]').change(function() {
        if (!$(this).prop('checked')) {
            $('#selectAll').prop('checked', false);
        }

        if ($('tbody input[type="checkbox"]:checked').length === $('tbody input[type="checkbox"]').length) {
            $('#selectAll').prop('checked', true);
        }
    });
    
    
 
	// 비품 이름 클릭 이벤트 핸들러
    $('.open-detail-modal').click(function(event){
        event.preventDefault(); // 링크 기본 동작 방지

        // 데이터 속성 가져오기
        let vhclId = $(this).data('vhclId');
        let vhclNo = $(this).data('vhclNo');
        let prchsYmd = $(this).data('prchsYmd');
        let rmrkCn = $(this).data('rmrkCn');
        let vhclSttusCd = $(this).data('vhclSttusCd');
        let carmdlNmCd = $(this).data('carmdlNmCd');
        let mkrCd = $(this).data('mkrCd');        

        let fileGroupNo = $(this).data('fileGroupNo');
        console.log("fileGroupNo : ",fileGroupNo);
        
        if(fileGroupNo>0){
           console.log("fileGroupNo : " + fileGroupNo);
           
           $.ajax({
              url:"/car/getFileDetails",
              data:{"fileGroupNo":fileGroupNo},
              type:"post",
              dataType:"json",
              beforeSend: function(xhr) {
                   xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 포함
               },
              success:function(result){
                 console.log("result : ",result);
                 
                 // 모달의 input 필드에 데이터 삽입
                    $('#modalVhclId').val(vhclId);  // 비품 코드 (readonly)
                    $('#modalVhclNo').val(vhclNo);  // 이름
                    $('#modalVhclSttusCd').val(vhclSttusCd);  // 수량 (readonly)
                    $('#modalCarmdlNmCd').val(carmdlNmCd);  // 위치
                    $('#modalMkrCd').val(mkrCd);  // 상태
                    $('#modalPrchsYmd').val(prchsYmd);  // 구입일 (readonly)
                    $('#modalRmrkCn').val(rmrkCn);  // 비고

                    let str = "";
                    
                    //result : List<FileDetailVO>
                    $.each(result,function(idx,fileDetailVO){
                       str += "<img src='"+fileDetailVO.fileSaveLocate+"' />";
                       console.log("str : " , str);
                    });
                    
                    $("#divFileSaveLocate").html(str);
                    
                    // 모달 열기
                    $('#detailModal').modal('show');
              }
           });
        }else{
           console.log("개똥이");
           
           // 모달의 input 필드에 데이터 삽입
                    $('#modalVhclId').val(vhclId);  // 비품 코드 (readonly)
                    $('#modalVhclNo').val(vhclNo);  // 이름
                    $('#modalVhclSttusCd').val(vhclSttusCd);  // 수량 (readonly)
                    $('#modalCarmdlNmCd').val(carmdlNmCd);  // 위치
                    $('#modalMkrCd').val(mkrCd);  // 상태
                    $('#modalPrchsYmd').val(prchsYmd);  // 구입일 (readonly)
                    $('#modalRmrkCn').val(rmrkCn);  // 비고

            // 모달 열기
            $('#detailModal').modal('show');
        }
    });	
   
    // '저장' 버튼 클릭 시 수정된 데이터를 처리
    $('#saveChanges').click(function() {

        // 수정된 값 가져오기
        let vhclId = $('#modalVhclId').val();
        let vhclNo = $('#modalVhclNo').val();

        // select에서 선택한 위치 코드 및 상태 코드 가져오기
        let vhclSttusCd = $('#modalVhclSttusCd').val(); // 차량 상태 코드
        let carmdlNmCd = $('#modalCarmdlNmCd').val();  // 차종  코드
        let mkrCd = $('#modalMkrCd').val();  // 제조사 코드

        let prchsYmd = $('#modalPrchsYmd').val();
        let rmrkCn = $('#modalRmrkCn').val();

     // 첨부파일 가져오기
        let filesTemp = $("#modalUploadFile")[0].files;
        let files = Array.prototype.slice.call(filesTemp);

        
        // FormData 객체 생성
        let formData = new FormData();

        // 일반 데이터를 FormData에 추가
        formData.append("vhclId", vhclId);
        formData.append("vhclNo", vhclNo);
        formData.append("vhclSttusCd", vhclSttusCd);
        formData.append("carmdlNmCd", carmdlNmCd);
        formData.append("mkrCd", mkrCd);
        formData.append("prchsYmd", prchsYmd);
        formData.append("rmrkCn", rmrkCn);

        // 파일을 FormData에 추가 (다중 파일 지원)
        for (let i = 0; i < files.length; i++) {
            formData.append("uploadFiles", files[i]);
        }
        
        // 데이터 객체 생성
//        let data = {
//           fxtrsNo: fxtrsNo,
//            fxtrsNm: fxtrsNm,
//            fxtrsQy: fxtrsQy,
//            fxtrsPstnCd: fxtrsPstnCd,  // 위치 코드
//           fxtrsSttusCd: fxtrsSttusCd,  // 상태 코드
//            prchsYmd: prchsYmd,
//            rmrkCn: rmrkCn
//        };

        // AJAX 요청
        //          
        //    url: "/fixtures/updateAjax",
        //    contentType: "application/json;charset=utf-8",
        //    data: JSON.stringify(data),
        //    type: "POST",  // HTTP 메소드  
        
        $.ajax({
            url: "/car/updateAjax",
            processData: false,
            contentType: false,
            data: formData,
            type: "POST",            
            beforeSend: function(xhr) {
                // CSRF 토큰을 요청 헤더에 포함
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(result) {
                // 성공 시 SweetAlert2 알림
                Swal.fire({
                    icon: 'success',
                    title: '차량 정보가 성공적으로 수정되었습니다.'
                }).then(() => {
                    location.reload(); // 페이지 새로고침
                });
            },
            error: function(xhr, status, error) {
                console.error("업데이트 실패:", error);
                Swal.fire({
                    icon: 'error',
                    title: '업데이트 중 오류가 발생했습니다.'
                });
            }
        });
    });
    
 // 선택된 비품 삭제
    $('#deleteSelected').click(function() {
       
        // 선택된 비품 삭제 확인 (SweetAlert 적용)
        Swal.fire({
            title: '정말 삭제하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#4E7DF4',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
            reverseButtons: true,
        }).then((result) => {
            if (result.isConfirmed) {
                // 확인을 누른 경우만 삭제 진행

                // 선택된 체크박스의 비품 번호를 배열에 저장
                let selectedItems = [];
                
                let formData = new FormData();
                
                $('tbody input[type="checkbox"]:checked').each(function() {
                    let vhclId = $(this).data("vhclId"); // 비품 코드 가져오기
                    console.log("vhclId : ", vhclId);
                    selectedItems.push(vhclId);
                    
                    formData.append("vhclIdList", vhclId);
                });

                // 아무것도 선택되지 않은 경우 경고
                if (selectedItems.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: '삭제할 비품을 선택하세요.',
                    });
                    return;
                }

                // AJAX 요청으로 선택된 비품 삭제
                $.ajax({
                    url: '/car/deleteAjax', // 서버에서 처리할 URL
                    processData: false,
                    contentType: false,
                    type: 'POST',
                    data: formData, // 선택된 비품 번호를 JSON으로 전송
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 포함
                    },
                    dataType: "text",
                    success: function(result) {
                        // 삭제 성공 시 처리
                        Swal.fire({
                            icon: 'success',
                            title: '선택한 비품이 삭제되었습니다.',
                        }).then(() => {
                            location.reload(); // 페이지 새로고침
                        });
                    },
                    error: function(xhr, status, error) {
                        // 삭제 실패 시 처리
                        console.error("삭제 실패:", error);
                        Swal.fire({
                            icon: 'error',
                            title: '비품 삭제 중 오류가 발생했습니다.',
                        });
                    }
                });
            }
        });
    });

    
    
    // '비품 등록' 버튼 클릭 시 등록 모달 열기
    $('#insert').click(function() {
        // 비품 등록 모달 초기화
        $('#registerForm')[0].reset();  // 폼 리셋
        $('#registerModal').modal('show');  // 모달 열기
    });
    
    $("#registerAjax").on("click", function() {
        console.log("왔다");

        let formData = new FormData();

        // 입력값 가져오기
        let vhclId = $("#registerVhclId").val();
        let vhclNo = $("#registerVhclNo").val();
        let vhclSttusCd = $("#registerVhclSttusCd").val();
        let carmdlNmCd = $("#registerCarmdlNmCd").val();
        let mkrCd = $("#registerMkrCd").val();
        let prchsYmd = $("#registerPrchsYmd").val();
        let rmrkCn = $("#registerRmrkCn").val();
        
        // 첨부파일 가져오기
        let filesTemp = $("#uploadFile")[0].files;
        let files = Array.prototype.slice.call(filesTemp);
        
        console.log("files : " , files);
        
        
        // formData에 값 추가
        formData.append("vhclId",vhclId);
        formData.append("vhclNo", vhclNo);
        formData.append("vhclSttusCd", vhclSttusCd);
        formData.append("carmdlNmCd", carmdlNmCd);
        formData.append("mkrCd", mkrCd);
        formData.append("prchsYmd", prchsYmd);
        formData.append("rmrkCn", rmrkCn);
        
        // 파일을 formData에 추가 (다중 파일 지원)
        for (let i = 0; i < files.length; i++) {
            formData.append("uploadFiles", files[i]);
        }

        // AJAX 요청
        $.ajax({
            url: "/car/registPost",
            processData: false,
            contentType: false,
            data: formData,
            type: "post",
            dataType: "text",
          beforeSend:function(xhr){
            xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
         },
            success: function(result) {
                console.log("result", result);
                alert("차량이 성공적으로 등록되었습니다.");
                location.reload(); // 등록 후 페이지를 새로고침
            },
            error: function(xhr, status, error) {
                console.error("등록 실패:", error);
                alert("차량 등록 중 오류가 발생했습니다.");
            }
        });
    });

});

$(document).ready(function() {
    // currentDate를 가져와 형식 변환
    let dateStr = $("#formattedDate").text().trim(); // 공백 제거
    if (dateStr.length === 8) {  // 예상 길이가 맞는지 확인
        const formattedDate = dateStr.slice(0, 4) + "-" + dateStr.slice(4, 6) + "-" + dateStr.slice(6, 8);
        $("#formattedDate").text(formattedDate);
    } else {
        console.error("날짜 형식이 예상한 형식과 다릅니다:", dateStr);
    }
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

#deleteSelected {
    background-color: white;
    color: #848484;
}

#deleteSelected:hover {
    background-color: #848484;
    color: white;
}
</style>

<body>

<!-- <p>${carVOList}</p>  -->

  <div class="max-w-7xl mx-auto sm:px-6 lg:px-8"> 
	<div class="w-full flex justify-between items-center mb-1 mt-1 pl-3">
	    <div style="margin-top: 30px; margin-bottom: 10px;">
	        <h3 class="text-lg font-semibold text-slate-800">법인 차량 관리</h3>
	        <p class="text-slate-500">사내 법인 차량의 상태를 점검하고 관리할 수 있습니다</p>
	    </div>
	</div>
	
	   <!-- 대시보드 -->
		<div class="flex flex-col justify-center items-center">
			<div
				class="w-full mt-4 mb-2 grid grid-cols-1 gap-5 md:grid-cols-3 lg:grid-cols-3 2xl:grid-cols-3 3xl:grid-cols-3">

				<div
					class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
					<div class="flex-auto p-4">
						<div class="flex flex-wrap">
							<div class="relative w-full pr-4 max-w-full flex-grow flex-1">
								<h5 class="text-blueGray-400 uppercase font-bold text-sm mb-3">법인 소유 차량의 총 보유 대수</h5>
								<span class="font-bold text-xl">${count}</span>
							</div>
							<div class="relative w-auto pl-4 flex-initial">
								<div
									class="text-white p-3 text-center inline-flex items-center justify-center w-12 h-12 shadow-lg rounded-full bg-red-500" style="background-color: #4E7DF4;">
									<i class="far fa-chart-bar"></i>
								</div>
							</div>
						</div>
						<c:set var="yearlyChangeAbs" value="${dashYear.YEARLYCHANGEPERCENT < 0 ? -dashYear.YEARLYCHANGEPERCENT : dashYear.YEARLYCHANGEPERCENT}" />
						
						<p class="text-sm text-blueGray-500 mt-4">
						    <span class="text-emerald-500 mr-2" style="color:#4E7DF4">
						        <c:choose>
						            <c:when test="${dashYear.YEARLYCHANGEPERCENT >= 0}">
						                <i class="fas fa-arrow-up" style="color:#4E7DF4"></i>
						            </c:when>
						            <c:otherwise>
						                <i class="fas fa-arrow-down" style="color:#4E7DF4"></i>
						            </c:otherwise>
						        </c:choose>
						        ${yearlyChangeAbs}%
						    </span>
						    <span class="whitespace-nowrap">작년 대비</span>
						</p>
					</div>
				</div>

				<div
					class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
					<div class="flex-auto p-4">
						<div class="flex flex-wrap">
							<div class="relative w-full pr-4 max-w-full flex-grow flex-1">
								<h5 class="text-blueGray-400 uppercase font-bold text-sm mb-3">올해 등록 차량 현황</h5>
								<span class="font-bold text-xl">${currentYearCount.ITEMCOUNT}</span>
							</div>
							<div class="relative w-auto pl-4 flex-initial">
								<div
									class="text-white p-3 text-center inline-flex items-center justify-center w-12 h-12 shadow-lg rounded-full bg-red-500" style="background-color: #4E7DF4;">
									<i class="fas fa-chart-pie"></i>
								</div>
							</div>
						</div>
						<p class="text-sm text-blueGray-500 mt-4">
							<span
								class="whitespace-nowrap"><i class="fas fa-clock" style="color:#4E7DF4"></i> 최근 등록 일자 : </span><span class="text-emerald-500 mr-2" style="color:#4E7DF4"><span id="formattedDate">${currentDate}</span></span>
						</p>
					</div>
				</div>

				<div
					class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none">
					<div class="flex-auto p-4">
						<div class="flex flex-wrap">
							<div class="relative w-full pr-4 max-w-full flex-grow flex-1">
								<h5 class="text-blueGray-400 uppercase font-bold text-sm mb-3">현재 사용 가능 차량</h5>
								<span class="font-bold text-xl">${statusInA}</span>
							</div>
							<div class="relative w-auto pl-4 flex-initial">
								<div
									class="text-white p-3 text-center inline-flex items-center justify-center w-12 h-12 shadow-lg rounded-full bg-red-500" style="background-color: #4E7DF4;">
									<i class="fas fa-sync-alt"></i>
								</div>
							</div>
						</div>
						<p class="text-sm text-blueGray-500 mt-4">
							<div style="display: flex; align-items: center; gap: 20px;">
							    <!-- 사용 중 -->
							    <div style="display: flex; align-items: center;">
							        <span class="whitespace-nowrap text-sm" style="display: flex; align-items: center;">
							            <img src="/resources/images/AVL.png" alt="사용 가능" style="margin-right: 5px; width:10px;" />
							            사용 중 <i class="fas fa-angle-right ml-1" style="color: #4E7DF4"></i>
							        </span>
							        <span class="text-sm" style="color: black; margin-left: 5px;">${statusInU}</span>
							    </div>
							
							    <!-- 사용 불가 -->
							    <div style="display: flex; align-items: center;">
							        <span class="whitespace-nowrap text-sm" style="display: flex; align-items: center;">
							            <img src="/resources/images/UNAVL.png" alt="사용 불가" style="margin-right: 5px; width:10px;" />
							            사용 불가 <i class="fas fa-angle-right ml-1" style="color: #4E7DF4"></i>
							        </span>
							        <span class="text-sm" style="color: black; margin-left: 5px;">${statusU}</span>
							    </div>
							</div>
						</p>
					</div>
				</div>
			</div>
	   
<div class="flex justify-between items-center mb-3 w-full">
    <!-- 왼쪽에 삭제 버튼 -->
    <div class="flex-shrink-0">
        <input type="button" value="삭제" 
               class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 mt-2"
               onclick="deleteSurveys()" id="deleteSelected" />
    </div>

    <!-- 오른쪽에 검색 폼 -->
    <form id="searchForm" class="flex-grow">
        <div class="flex items-center justify-end space-x-3 mt-2">
            <!-- 기간 선택 -->
            <div class="flex items-center space-x-2">
                <label for="startDate" class="text-gray-700" style="width: 80px;">기간</label>
                <input type="date" id="startDate" name="startDate"
                       class="bg-white h-10 px-2 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
                       value="${param.startDate != null ? param.startDate : ''}"/>
                <span>-</span>
                <input type="date" id="endDate" name="endDate"
                       class="bg-white h-10 px-2 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
                       value="${param.endDate != null ? param.endDate : ''}"/>
            </div>

            <!-- 상태 선택 -->
            <div>
                <select name="status" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
                    <option value="" selected>상태</option>
                    <c:forEach var="status" items="${sttus}">
                        <option value="${status.clsfCd}" ${param.searchField == status.clsfCd ? 'selected' : ''}>${status.clsfNm}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- 차종 선택 -->
            <div>
                <select name="carType" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
                    <option value="" selected>차종</option>
                    <c:forEach var="carType" items="${carMdl}">
                        <option value="${carType.clsfCd}" ${param.searchField == carType.clsfCd ? 'selected' : ''}>${carType.clsfNm}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- 제조사 선택 -->
            <div>
                <select name="mfr" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
                    <option value="" selected>제조사</option>
                    <c:forEach var="mfr" items="${mkr}">
                        <option value="${mfr.clsfCd}" ${param.searchField == mfr.clsfCd ? 'selected' : ''}>${mfr.clsfNm}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- 검색 필드 및 버튼 -->
            <div class="relative">
                <input type="text" name="keyword" value="${param.keyword}"
                       class="bg-white w-48 h-10 pr-11 pl-3 py-2 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
                       placeholder="차량번호를 입력하세요." />
                <button type="submit" class="absolute h-8 w-8 right-1 top-1 my-auto flex items-center bg-white rounded">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-4 h-4 text-slate-600">
                        <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
                    </svg>
                </button>
            </div>
        </div>
    </form>
</div>

   
    <div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
	    <div class="card-body table-responsive p-0">	    	
				<table class="table table-hover text-nowrap" style="text-align: center;">
					<thead>
						<tr>
						    <th><input type="checkbox" id="selectAll" /></th>
							<th>번호</th>
							<th>차량번호</th>
							<th>상태</th>
							<th>차종</th>
							<th>제조사</th>
							<th>구입 일자</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="carVO" items="${articlePage.content}">
							<tr>
							    <td><input type='checkbox' data-vhcl-id="${carVO.vhclId}" /></td>
								<td>${carVO.rnum}</td>
								<td>
										 <a href="#" class="open-detail-modal" 
										   data-vhcl-id="${carVO.vhclId}" 
										   data-vhcl-no="${carVO.vhclNo}" 
										   data-prchs-ymd="${carVO.prchsYmd}" 
										   data-vhcl-sttus-cd="${carVO.vhclSttusCd}" 
										   data-carmdl-nm-cd="${carVO.carmdlNmCd}" 
										   data-mkr-cd="${carVO.mkrCd}" 
										   data-rmrk-cn="${carVO.rmrkCn}"
										   data-file-group-no="${carVO.fileGroupNo}">
										   
									   <c:set var="highlightKeyword" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
					                   <c:out value="${fn:replace(carVO.vhclNo, param.keyword, highlightKeyword)}" escapeXml="false" />
									</a>
								</td>
								<td>
									<c:forEach var="sttus" items="${sttus}">
										<c:if test="${sttus.clsfCd == carVO.vhclSttusCd}">
										
											<c:if test="${sttus.clsfNm == '수리 중'}">
												<span class="relative inline-block px-3 py-1 font-semibold text-red-900 leading-tight">
				                                        <span aria-hidden class="absolute inset-0 bg-red-200 opacity-50 rounded-full"></span>
														<span class="relative">수리중</span>
												</span>
										        </span>
											</c:if>
											
											<c:if test="${sttus.clsfNm == '사용 가능'}">
				                        		<span class="relative inline-block px-3 py-1 font-semibold leading-tight">
										            <span aria-hidden class="absolute inset-0 opacity-10 rounded-full" style="background-color: #4E7DF4;"></span>
										            <span class="relative" style="color: #4E7DF4;">가능</span>
										        </span> 
											</c:if>
											
											<c:if test="${sttus.clsfNm == '사용 중'}">
	                                       		<span class="relative inline-block px-3 py-1 font-semibold text-dark-900 leading-tight">
				                                        <span aria-hidden class="absolute inset-0 bg-gray-200 opacity-50 rounded-full"></span>
														<span class="relative">사용중</span>
												</span>
											</c:if>
											
											<c:if test="${sttus.clsfNm == '사용 불가'}">
												<span class="relative inline-block px-3 py-1 font-semibold text-red-900 leading-tight">
				                                        <span aria-hidden class="absolute inset-0 bg-red-200 opacity-50 rounded-full"></span>
														<span class="relative">불가</span>
												</span>
											</c:if>
											
										</c:if>
									</c:forEach>
								</td>
								<td>
									<c:forEach var="carMdl" items="${carMdl}">
										<c:if test="${carMdl.clsfCd == carVO.carmdlNmCd}">
											${carMdl.clsfNm}
										</c:if>
									</c:forEach>
								</td>
								<td>
									<c:forEach var="mkr" items="${mkr}">
										<c:if test="${mkr.clsfCd == carVO.mkrCd}">
											${mkr.clsfNm}
										</c:if>
									</c:forEach>
								</td>
								<td>
								    <fmt:parseDate value="${carVO.prchsYmd}" pattern="yyyyMMdd" var="parsedDate" />
								    <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" />
								</td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="7" style="text-align: right;">
								<button class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									    name="insert" id="insert" type="button">등록</button>  
							</td>
						</tr>
					</tfoot>
				</table>
			</div>
			
		<nav aria-label="Page navigation" style="margin-left: auto;margin-right: auto;margin-top: 20px;margin-bottom: 10px;">
			<ul class="inline-flex space-x-2">
				<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
				<li>
					<c:if test="${articlePage.startPage gt 5}">
						<a href="/car/list?currentPage=${articlePage.startPage-5}&startDate=${param.startDate}&endDate=${param.endDate}&status=${param.status}&carType=${param.carType}&mfr=${param.mfr}&keyword=${param.keyword}"
							class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
							<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
								<path d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
							</svg>
						</a>
					</c:if>
				</li>
				
				<!-- 총 페이징 -->
				<c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
					<c:if test="${articlePage.currentPage == pNo}">
						<li>
							<button id="button-${pNo}" 
								onclick="javascript:location.href='/car/list?currentPage=${pNo}&startDate=${param.startDate}&endDate=${param.endDate}&status=${param.status}&carType=${param.carType}&mfr=${param.mfr}&keyword=${param.keyword}';"
								class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
								style="background-color: #4E7DF4; color: white;">
								${pNo}
							</button>
						</li>
					</c:if>
					
					<c:if test="${articlePage.currentPage != pNo}">
						<li>
							<button id="button-${pNo}" 
								onclick="javascript:location.href='/car/list?currentPage=${pNo}&startDate=${param.startDate}&endDate=${param.endDate}&status=${param.status}&carType=${param.carType}&mfr=${param.mfr}&keyword=${param.keyword}';"
								class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
								style="color: #4E7DF4;">
								${pNo}
							</button>
						</li>
					</c:if>
				</c:forEach>
				
				<!-- endPage < totalPages일 때만 [다음] 활성화 -->
				<li>
					<c:if test="${articlePage.endPage lt articlePage.totalPages}">
						<a href="/car/list?currentPage=${articlePage.startPage+5}&startDate=${param.startDate}&endDate=${param.endDate}&status=${param.status}&carType=${param.carType}&mfr=${param.mfr}&keyword=${param.keyword}"
							class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
							<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
								<path d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
							</svg>
						</a>
					</c:if>
				</li>
			</ul>
		</nav>
	</div>
   </div>
</body>

<!-- 법인 차량 정보 수정 모달 -->
<div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="bg-white px-4 pb-4 pt-4">
                    <span class="ml-1 text-lg font-bold mb-3 block">법인 차량 정보</span>
                    <hr class="px-4 py-2">
                    <form id="detailForm">
                        <div class="form-group d-flex align-items-center">
                            <label for="modalVhclId" class="col-form-label col-4"><strong>차량 코드 : </strong></label>
                            <input type="text" class="form-control col-8" id="modalVhclId" readonly>
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="modalVhclNo" class="col-form-label col-4"><strong>차량 번호 : </strong></label>
                            <input type="text" class="form-control col-8" id="modalVhclNo">
                        </div>
						<div class="form-group d-flex align-items-center">
						    <label for="modalUploadFile" class="col-form-label col-4"><strong>첨부파일 :</strong></label>
						    <div class="col-8 d-flex align-items-center">
						        <label id="select-image" class="d-flex align-items-center">
						            <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
						            </svg>
						            <input type="file" id="modalUploadFile" name="uploadFile" multiple hidden />
						        </label>
						    </div>
						</div>
                        <!-- 이미지 화면 출력 -->
                        <div class="form-group d-flex justify-content-center" id="divFileSaveLocate"></div>
                        <!-- 수정된 이미지 출력 -->
                        <div class="form-group d-flex justify-content-center" id="modalImgPreview"></div>
                        <div class="form-group d-flex align-items-center">
                            <label for="modalVhclSttusCd" class="col-form-label col-4"><strong>상태 : </strong></label>
                            <select class="form-control col-8" id="modalVhclSttusCd">
                                <option value="">상태를 선택하세요</option>
                                <c:forEach var="sttus" items="${sttus}">
                                    <option value="${sttus.clsfCd}">${sttus.clsfNm}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="modalCarmdlNmCd" class="col-form-label col-4"><strong>차종 : </strong></label>
                            <select class="form-control col-8" id="modalCarmdlNmCd">
                                <option value="">차종을 선택하세요</option>
                                <c:forEach var="carMdl" items="${carMdl}">
                                    <option value="${carMdl.clsfCd}">${carMdl.clsfNm}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="modalMkrCd" class="col-form-label col-4"><strong>제조사 : </strong></label>
                            <select class="form-control col-8" id="modalMkrCd">
                                <option value="">제조사를 선택하세요</option>
                                <c:forEach var="mkr" items="${mkr}">
                                    <option value="${mkr.clsfCd}">${mkr.clsfNm}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="modalPrchsYmd" class="col-form-label col-4"><strong>구입일 : </strong></label>
                            <input type="text" class="form-control col-8" id="modalPrchsYmd" readonly>
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="modalRmrkCn" class="col-form-label col-4"><strong>비고 : </strong></label>
                            <textarea class="form-control col-8" id="modalRmrkCn"></textarea>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer bg-gray-50 px-4 py-3 flex justify-center">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="saveChanges">확인</button>
            </div>
        </div>
    </div>
</div>


<!-- 비품 등록 모달 -->
<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="registerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="bg-white px-4 pb-4 pt-4">
                    <span class="ml-1 text-lg font-bold mb-3 block">법인 차량 등록</span>
                    <hr class="px-4 py-2">
                    <form id="registerForm">
                        <div class="form-group d-flex align-items-center">
                            <input type="hidden" class="form-control col-8" id="registerFxtrsNo">
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="registerVhclNo" class="col-form-label col-4"><strong>차량 번호 : </strong></label>
                            <input type="text" class="form-control col-8" id="registerVhclNo">
                        </div>
                        <div class="form-group d-flex align-items-center">
						    <label for="uploadFile" class="col-form-label col-4"><strong>첨부파일 : </strong></label>
						    <div class="col-8 d-flex align-items-center">
						        <label id="select-image" class="d-flex align-items-center">
						            <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7 w-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
						            </svg>
						            <input type="file" id="uploadFile" name="uploadFile" hidden required />
						        </label>
						    </div>
						</div>
                        <div class="form-group d-flex justify-content-center" id="pImg"></div>
                        <div class="form-group d-flex align-items-center">
                            <label for="registerVhclSttusCd" class="col-form-label col-4"><strong>차량 상태 : </strong></label>
                            <select class="form-control col-8" id="registerVhclSttusCd">
                                <option value="" selected disabled>선택하세요</option>
                                <c:forEach var="sttus" items="${sttus}">
                                    <option value="${sttus.clsfCd}">${sttus.clsfNm}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="registerCarmdlNmCd" class="col-form-label col-4"><strong>차종 : </strong></label>
                            <select class="form-control col-8" id="registerCarmdlNmCd">
                                <option value="" selected disabled>선택하세요</option>
                                <c:forEach var="carMdl" items="${carMdl}">
                                    <option value="${carMdl.clsfCd}">${carMdl.clsfNm}</option>
                                </c:forEach>
                            </select>
                        </div>         
                        <div class="form-group d-flex align-items-center">
                            <label for="registerMkrCd" class="col-form-label col-4"><strong>제조사 : </strong></label>
                            <select class="form-control col-8" id="registerMkrCd">
                                <option value="" selected disabled>선택하세요</option>
                                <c:forEach var="mkr" items="${mkr}">
                                    <option value="${mkr.clsfCd}">${mkr.clsfNm}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="registerPrchsYmd" class="col-form-label col-4"><strong>구입일 : </strong></label>
                            <input type="date" class="form-control col-8" id="registerPrchsYmd">
                        </div>
                        <div class="form-group d-flex align-items-center">
                            <label for="registerRmrkCn" class="col-form-label col-4"><strong>비고 : </strong></label>
                            <textarea class="form-control col-8" id="registerRmrkCn"></textarea>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer bg-gray-50 px-4 py-3 flex justify-center">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="registerAjax">확인</button>
            </div>
        </div>
    </div>
</div>
<br>
