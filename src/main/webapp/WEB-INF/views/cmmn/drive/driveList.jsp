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
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<!-- 스위트 알러트 임포트 시작 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<!-- 스위트 알러트 임포트 시작 -->
<script type="text/javascript">

	var folderPath = "";

    $(document).ready(function() {
    	
    	getFileList("");
    	
    	// 파일 목록 리로드
    	function getFileList(data){
	        $.ajax({
	            url: '/files/list', // 파일 목록 요청 URL
	            type: 'GET',
	            data: {folderPath: data},
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader($('meta[name="_csrf_header"]').attr('content'), $('meta[name="_csrf"]').attr('content'));
	            },
	            success: function(fileList) {
	                $('#noneFileList').empty(); // 기존 목록 초기화
	                
	                console.log("폴더 내용:", fileList);
                    $('#noneFileList').empty(); // 기존 목록 초기화
//                     $('#createBtn').css("display", "none");
                    
                    console.log(fileList);
                    
                 	// 폴더가 아닌 파일만 필터링
                 	
                    var filesOnly;
                 	if (data == "") filesOnly = fileList;
                 	else filesOnly = fileList.filter(file => !file.fileName.endsWith('/'));
                    
                    if (filesOnly.length > 0) {
                    	var totalFileSizeText = fileList[fileList.length - 1].totalFileSize; // "9.8 MB" 형식
                        var parts = totalFileSizeText.split(' '); // 스페이스바 기준으로 분리
                        var size = parseFloat(parts[0]); // 숫자 부분 (9.8)
                        var unit = parts[1]; // "MB" 부분
                        
                        var currentSize = 0;
                        var duration = 1000; // 1초 동안 애니메이션 진행
                        var startTime = null;

                        function animate(timestamp) {
                            if (!startTime) startTime = timestamp; // 시작 시간 설정
                            var progress = timestamp - startTime; // 경과 시간 계산
                            var percentage = Math.min(progress / duration, 1); // 진행 비율 (최대 1)
                            
                            currentSize = size * percentage; // 현재 크기를 진행 비율에 맞게 계산
                            $("#totalFileSize").text(currentSize.toFixed(1) + ' ' + unit); // 소수점 1자리로 표현
                            
                            if (progress < duration) {
                                requestAnimationFrame(animate); // 애니메이션 계속
                            } else {
                                currentSize = size; // 최종적으로 정확한 크기로 맞추기
                                $("#totalFileSize").text(currentSize.toFixed(1) + ' ' + unit); // 종료 시 최종값 설정
                            }
                        }

                        requestAnimationFrame(animate); // 애니메이션 시작
                    	
                        $('#noneFileList').html('<table style="width: 100%; table-layout: fixed; border-collapse: collapse;"><thead style="font-size: 12px; border-bottom: 1px solid #dee2e6">'
                                + '<tr><th style="width: 5%; padding: 11px 20px 11px 0px;"></th>'
                                + '<th style="width: 5%; padding: 11px 20px 11px 0px; text-align: center;">종류</th>'
                                + '<th style="width: 38%; padding: 11px 23px 11px 0px;">이름</th>'
                                + '<th style="width: 9%; padding: 11px 20px 11px 0px;">크기</th>'
                                + '<th style="width: 13%; padding: 11px 20px 11px 0px;">수정한 날짜</th>'
                                + '<th style="width: 9%; padding: 11px 20px 11px 0px;">수정한 사람</th>'
                                + '<th style="width: 14.5%; padding: 11px 20px 11px 0px;">생성한 날짜</th></tr></thead><tbody style="color: #71767a; font-size: 12px;"></tbody></table>');
                        
                        filesOnly.forEach(function(file) {
                            // null 체크 추가
                            var fileName = file.fileName ? file.fileName : '이름 없음';
                            var fileExtension = fileName.split('.').pop().toUpperCase(); // 파일명에서 확장자 추출
                            
                         	// 파일 확장자가 이미지 형식일 경우, 지정된 썸네일 URL로 설정
                            var thumbnailUrl;
                            var fileIcon;

                            if (fileName.endsWith('/')) {
                                // 폴더일 경우
                                thumbnailUrl = '/resources/images/cmmn_drive/bgFolder2.svg'; // 폴더 썸네일
                                fileIcon = '/resources/images/cmmn_drive/smFolder2.svg'; // 폴더 아이콘
                            } else if (['JPG', 'JPEG', 'PNG', 'GIF', 'BMP'].includes(fileExtension)) {
                                thumbnailUrl = file.thumbnailUrl ? file.thumbnailUrl : '/resources/images/cmmn_drive/bgImage.svg'; // 이미지 파일 썸네일
                                fileIcon = '/resources/images/cmmn_drive/smImage.svg'; // 이미지 파일 아이콘
                            } else if (fileExtension === 'EXE') {            
                                thumbnailUrl = '/resources/images/cmmn_drive/bgEXE.svg'; // EXE 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smEXE.svg'; // EXE 파일 아이콘
                            } else if (fileExtension === 'WORD') {           
                                thumbnailUrl = '/resources/images/cmmn_drive/bgWORD.svg'; // WORD 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smWORD.svg'; // WORD 파일 아이콘
                            } else if (fileExtension === 'HTML') {           
                                thumbnailUrl = '/resources/images/cmmn_drive/bgHTML.svg'; // HTML 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smHTML.svg'; // HTML 파일 아이콘
                            } else if (fileExtension === 'HWP') {            
                                thumbnailUrl = '/resources/images/cmmn_drive/bgHWP.svg'; // HWP 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smHWP.svg'; // HWP 파일 아이콘
                            } else if (fileExtension === 'PPTX') {           
                                thumbnailUrl = '/resources/images/cmmn_drive/bgPPTX.svg'; // PPTX 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smPPTX.svg'; // PPTX 파일 아이콘
                            } else if (fileExtension === 'PDF') {            
                                thumbnailUrl = '/resources/images/cmmn_drive/bgPDF.svg'; // PDF 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smPDF.svg'; // PDF 파일 아이콘
                            } else if (fileExtension === 'ZIP') {            
                                thumbnailUrl = '/resources/images/cmmn_drive/bgZIP.svg'; // ZIP 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smZIP.svg'; // ZIP 파일 아이콘
                            } else if (fileExtension === 'XLSX') {           
                                thumbnailUrl = '/resources/images/cmmn_drive/bgXLSX.svg'; // XLSX 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smXLSX.svg'; // XLSX 파일 아이콘
                            } else if (fileExtension === 'TXT') {            
                                thumbnailUrl = '/resources/images/cmmn_drive/bgWORD.svg'; // WORD 파일 아이콘
                                fileIcon = '/resources/images/cmmn_drive/smWORD.svg'; // WORD 파일 아이콘
                            } else {                                         
                                thumbnailUrl = '/resources/images/cmmn_drive/bgETC.svg'; // 다른 경우에는 기본값
                                fileIcon = '/resources/images/cmmn_drive/smETC.svg'; // 다른 경우에는 기본값
                            }
                            
                            var fileSize = file.fileSize ? file.fileSize : '-';
                            var lastModifiedDate = file.lastModifiedDate ? file.lastModifiedDate : '-';
                            var lastModifiedBy = file.lastModifiedBy ? file.lastModifiedBy : '-';
                            var creationDate = file.creationDate ? file.creationDate : '-';

                            $('#noneFileList tbody').append('<tr style="border-bottom: 1px solid #f1f3f5;" '
                            	    + 'data-file-icon="' + fileIcon + '" '
                            	    + 'data-thumbnail-url="' + thumbnailUrl + '" '
                            	    + 'data-file-name="' + fileName + '" '
                            	    + 'data-file-size="' + fileSize + '" '
                            	    + 'data-last-modified-date="' + lastModifiedDate + '" '
                            	    + 'data-last-modified-by="' + lastModifiedBy + '" '
                            	    + 'data-creation-date="' + creationDate + '">'
                                    + '<td style="width: 5%; text-align: center; vertical-align: middle; padding-top: 20px;">'
                                    + '<input class="fileSn" type="checkbox" style="transform: translateY(-50%);"></td>'
                                    + '<td style="width: 5%; padding: 11px 20px 11px 0px;"><div style="display: flex; justify-content: center; align-items: center;"><img src="' + fileIcon + '" style="height:24px;" class="thumbnail"/></div></td>'
                                    + '<td style="width: 38%; padding: 11px 23px 11px 0px;">' + fileName.replace("/", "") + '</td>'
                                    + '<td style="width: 9%; padding: 11px 20px 11px 0px;">' + fileSize + '</td>'
                                    + '<td style="width: 13%; padding: 11px 20px 11px 0px;">' + lastModifiedDate + '</td>'
                                    + '<td style="width: 9%; padding: 11px 20px 11px 0px;">' + lastModifiedBy + '</td>'
                                    + '<td style="width: 13%; padding: 11px 20px 11px 0px;">' + creationDate + '</td></tr>');
                            });
                    } else {
                        $('#noneFileList').html('<div style="display:flex; flex-direction: column; justify-content:center; align-items: center; height: 100%; ">'
                            + '<p style="margin-bottom: 30px;"><i class="fa-solid fa-file fa-2xl" style="font-size: 50px; color: #d3d3d3;"></i></p>'
                            + '<p style="font-size: 14px; color: #71767a">파일이 없습니다.</p>'
                            + '<p style="font-size: 14px; color: #71767a">내 드라이브에 올린 파일은 본인만 열람이 가능합니다.</p></div>');
                    }
	            },
	            error: function(xhr, status, error) {
	                alert('파일 목록 가져오기 실패: ' + error);
	            }
	        });
    	}
    	
    	// 선택된 파일 정보를 저장할 배열을 함수 외부로 이동
    	var selectedFiles = [];

    	// 파일 리스트에서 행 클릭 시 이벤트
    	$('#noneFileList').on('click', 'tr', function(e) {
    	    // 클릭된 요소가 체크박스인 경우엔 무시 (체크박스 자체 클릭 시 tr 클릭 이벤트 중복 방지)
    	    if ($(e.target).is('.fileSn')) {
    	        return;
    	    }

    	    var clickedFileName = $(this).data('file-name');
    	    var clickedFileThumbnailUrl = $(this).data('thumbnail-url');
    	    var clickedFileIcon = $(this).data('file-icon');
    	    var clickedFileSize = $(this).data('file-size');
    	    var clickedLastModifiedDate = $(this).data('last-modified-date');
    	    var clickedLastModifiedBy = $(this).data('last-modified-by');
    	    var clickedCreationDate = $(this).data('creation-date');
    	    var clickedfileExtension = clickedFileName.split('.').pop().toUpperCase();

    	    // UI 요소 업데이트
    	    $('#holdThumbnail').attr('src', clickedFileThumbnailUrl);
    	    $('#fileViewName').text(clickedFileName.replace("/", ""));
    	    $('#fileViewIcon').attr('src', clickedFileIcon);

    	    var encodedFileName = encodeURIComponent(clickedFileName);
    	    $('#downloadLink').attr('href', '/files/download/' + encodedFileName);

            let output;

            if (clickedfileExtension.endsWith('/')) {
                // clickedfileExtension이 '/'로 끝나면 폴더로 간주
                output = '<p style="margin-bottom: 10px;">폴더</p>';
            } else {
                // clickedfileExtension이 '/'로 끝나지 않으면 파일로 간주
                output = '<p style="margin-bottom: 10px;">' + clickedfileExtension + ' 파일</p>';
            }
            
    	    var htmlCategory = '<p style="margin-bottom: 10px;">종류</p>' +
    	                       '<p style="margin-bottom: 10px;">위치</p>' +
    	                       '<p style="margin-bottom: 10px;">크기</p>' +
    	                       '<p style="margin-bottom: 10px;">수정한 사람</p>' +
    	                       '<p style="margin-bottom: 10px;">수정한 날짜</p>' +
    	                       '<p style="margin-bottom: 10px;">생성한 날짜</p>';
			
    	    var htmlExplain = output +
    	                      '<p style="margin-bottom: 10px; max-width: 165px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="내 드라이브/'  + folderPath + (clickedFileName.endsWith('/') ? "" : clickedFileName) + '">내 드라이브/' + folderPath + (clickedFileName.endsWith('/') ? "" : clickedFileName) + '</p>' +
    	                      '<p style="margin-bottom: 10px;">' + clickedFileSize + '</p>' +
    	                      '<p style="margin-bottom: 10px;">' + clickedLastModifiedBy + '</p>' +
    	                      '<p style="margin-bottom: 10px;">' + (clickedLastModifiedDate !== "-" ? "20" + clickedLastModifiedDate : '-') + '</p>' +
    	                      '<p style="margin-bottom: 10px;">20' + clickedCreationDate + '</p>';

    	    var htmlShareBoundary = '<div style="display: flex; font-size: 13px; line-height: 19px; margin-top: 10px; border-top: 1px solid #f1f3f5; border-bottom: 1px solid #f1f3f5;">' +
    	                            '<div style="width: 34%;"><p style="margin-bottom: 20px; margin-top: 20px;">공유 범위</p></div>' +
    	                            '<div style="width: 66%;"><p style="margin-bottom: 20px; margin-top: 20px;">나</p></div></div>';

    	    $('#fileCategory').html(htmlCategory);
    	    $('#fileExplain').html(htmlExplain);
    	    $('#shareBoundary').html(htmlShareBoundary);

    	    // 선택 처리
    	    $('#noneFileList tbody tr').removeClass('selected');
    	    $(this).addClass('selected');

    	    // 체크박스 상태 변경
    	    var checkbox = $(this).find('.fileSn');
    	    checkbox.prop('checked', !checkbox.prop('checked'));

    	    // selectedFiles 배열 업데이트
    	    if (checkbox.prop('checked')) {
    	        if (!selectedFiles.includes(clickedFileName)) {
    	            selectedFiles.push(clickedFileName);
    	        }
    	    } else {
    	        selectedFiles = selectedFiles.filter(function(file) {
    	            return file !== clickedFileName;
    	        });
    	    }

    	    console.log("선택된 파일:", selectedFiles);
    	});

    	// 체크박스 클릭 시 이벤트 추가
    	$('#noneFileList').on('change', '.fileSn', function(e) {
    	    var checkbox = $(this);
    	    var clickedFileName = checkbox.closest('tr').data('file-name');

    	    if (checkbox.prop('checked')) {
    	        if (!selectedFiles.includes(clickedFileName)) {
    	            selectedFiles.push(clickedFileName);
    	        }
    	    } else {
    	        selectedFiles = selectedFiles.filter(function(file) {
    	            return file !== clickedFileName;
    	        });
    	    }

    	    console.log("선택된 파일:", selectedFiles);
    	});

    	// customCheckbox5의 클릭 이벤트 추가
    	$('#customCheckbox5').change(function() {
    	    // 체크박스의 체크 상태에 따라 모든 tr의 체크박스 상태 변경
    	    var isChecked = $(this).prop('checked');
    	    $('#noneFileList').find('.fileSn').prop('checked', isChecked).trigger('change');
    	});
    	
    	// 파일 리스트에서 행 더블 클릭 시 이벤트
    	$('#noneFileList').on('dblclick', 'tr', function() {
    	    var clickedFileName = $(this).data('file-name');
    	    
    	    // 파일명이 '/'로 끝나면 폴더로 간주하고 getFileList 호출
    	    if (clickedFileName.endsWith('/')) {
	    	    selectedFiles = [];
	    	    $('#drivePath').html('<span style="font-weight: 100;">내 드라이브&ensp;>&ensp;</span>' + '<span style="color: #4E7DF4;">' + clickedFileName.replace("/", "") + '</span>');
				$('#backBtn').css("display", "flex");
				$('#createBtn').css("display", "none");
				
				folderPath = clickedFileName;
    	        getFileList(clickedFileName); // 폴더의 내용 가져오기
    	        
				// customCheckbox5 선택 해제
		        $('#customCheckbox5').prop('checked', false);
    	    }
    	});

    	// 다운로드 버튼 클릭 이벤트
    	$('#downloadSelected').click(function() {
		    if (selectedFiles.length > 0) {
		        // folderPath를 각 selectedFile에 추가
		        var filesWithPath = selectedFiles.map(function(file) {
		            return folderPath + file;
		        });
		        
		        // 파일 경로들을 인코딩
		        var encodedFileNames = filesWithPath.map(encodeURIComponent).join(',');
		        
		        if (selectedFiles.length === 1) {
		            // 단일 파일 다운로드 (쿼리 파라미터로 전달)
		            window.location.href = '/files/download?file=' + encodedFileNames;
		        } else {
		            // 다중 파일 다운로드
		            window.location.href = '/files/download-multiple?files=' + encodedFileNames;
		        }
		    } else {
		    	warning();
		    }
		});

    	// 삭제 버튼 클릭 이벤트
    	$('#deleteSelected').click(function() {
    	    if (selectedFiles.length === 0) {
    	    	warning();
    	        return;
    	    }
    	    questionDelete();
    	});
   		
    	// 뒤로가기 버튼
    	$('#backBtn').click(function(){
    		selectedFiles = []; 
     		folderPath = "";
     		let data = folderPath;
     		getFileList(data);
    		$("#drivePath").text("내 드라이브");
     		$('#backBtn').css("display", "none");
     		$('#createBtn').css("display", "flex");
     		
     		// customCheckbox5 선택 해제
     	    $('#customCheckbox5').prop('checked', false);
     	})
    	
    	// 파일 업로드
        $(document).on('change', "#fileInputTop", function() {
		    var formData = new FormData();
		    var files = $('#fileInputTop')[0].files; // 다중 파일을 가져옴
		
		    // 선택한 파일들이 있을 경우
		    if (files.length > 0) {
		        for (var i = 0; i < files.length; i++) {
		            var file = files[i];
		            formData.append('file', file);
		
		            // 파일의 수정 날짜
		            var localModifiedDate = file.lastModified; // 파일의 마지막 수정 시간 (밀리초 단위)
		            formData.append('localModifiedDate', localModifiedDate);
		        }
		
		        let data = folderPath;
		
		        // 사원 번호 및 폴더 경로 추가
		        formData.append('empNo', ${empVO.empNo});
		        formData.append('folderPath', data);
		
		        // 파일들이 선택되면 AJAX로 서버에 업로드
		        $.ajax({
		            url: '/files/upload', // 파일 업로드 요청을 보낼 URL
		            type: 'POST',
		            data: formData,
		            contentType: false,
		            processData: false,
		            beforeSend: function(xhr) {
		                xhr.setRequestHeader($('meta[name="_csrf_header"]').attr('content'), $('meta[name="_csrf"]').attr('content'));
		            },
		            success: function(res) {
		                success();
		                getFileList(data);
		            },
		            error: function(xhr, status, error) {
		                alert('파일 업로드 실패: ' + error);
		            }
		        });
		    } else {
		        warning();
		    }
		});
        
     	// 폴더 생성
        $("#createFolderSelected").on("click", function(){
        	creatFolder();
        });
        
     	// 파일 업로드 위임
        $(document).on("click", ".wbds_empty_link1", function() {
            $("#fileInputTop").trigger("click"); // fileInput 요소 클릭 트리거
        });
     	
     	// 동적으로 테이블 폭 조정
        function adjustTableWidth() {
            var tbody = $('#noneFileList tbody');
            var thead = $('#noneFileList thead');

            if (tbody[0].scrollHeight > tbody.innerHeight()) {
                // 스크롤이 있을 때
                thead.css('width', 'calc(100% - 17px)'); // 스크롤바 너비를 빼줌
            } else {
                // 스크롤이 없을 때
                thead.css('width', '100%');
            }
        }
     	
     	/* 스위트 알러트 시작*/
     	/* 스위트 알러트 시작*/
     	/* 스위트 알러트 시작*/
     	/* 스위트 알러트 시작*/
	    function warning() {
			Swal.fire({
				title: '파일을 1개 이상 선택해주세요.',
				icon: 'warning', /* 종류 많음 맨 아래 링크 참고 */
				confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
				confirmButtonText: '확인',
			
			}).then((result) => {
			});
		};
		
		function success() {
			Swal.fire({
				title: '파일 등록이 완료되었습니다.',
				icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
				confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
				confirmButtonText: '확인',
			
			}).then((result) => {
			});
		};
		
		function successFolder() {
			Swal.fire({
				title: '폴더 생성이 완료되었습니다.',
				icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
				confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
				confirmButtonText: '확인',
			
			}).then((result) => {
			});
		};
		
		function successDelete() {
			Swal.fire({
				title: '삭제가 완료되었습니다.',
				icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
				confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
				confirmButtonText: '확인',
			
			}).then((result) => {
			});
		};
		
		function questionDelete() {
		    Swal.fire({
		        title: '선택한 파일을 삭제하시겠습니까?',
		        icon: 'warning',
		        input: 'text',
		        inputPlaceholder: '"파일 삭제"를 정확히 입력해주세요.',
		        showCancelButton: true,
		        confirmButtonColor: '#4E7DF4',
		        confirmButtonText: '삭제',
		        cancelButtonText: '취소',
		        reverseButtons: true, // 취소와 삭제 버튼 위치 변경
		        customClass: {
		            input: 'swal2-input', // 입력창에 사용자 정의 스타일 적용
		        },
		        preConfirm: (inputValue) => {
		            if (inputValue !== '파일 삭제') return inputValue;
		        },
		        willOpen: () => {
		            const confirmButton = Swal.getConfirmButton(); // SweetAlert의 확인 버튼 가져오기
		            confirmButton.style.opacity = 0.5; // 초기 투명도 설정
		            confirmButton.disabled = true; // 버튼 비활성화
		            confirmButton.style.cursor = 'not-allowed'; // 비활성화된 버튼의 커서 스타일

		            const inputField = Swal.getInput(); // 입력 필드 가져오기
		            inputField.addEventListener('input', () => {
		                // 입력값에 따라 버튼 상태 변경
		                if (inputField.value === '파일 삭제') {
		                    confirmButton.style.opacity = 1; // 투명도 정상으로 변경
		                    confirmButton.disabled = false; // 버튼 활성화
		                    confirmButton.style.cursor = 'pointer'; // 활성화된 버튼의 커서 스타일
		                } else {
		                    confirmButton.style.opacity = 0.5; // 투명도 다시 낮추기
		                    confirmButton.disabled = true; // 버튼 비활성화
		                    confirmButton.style.cursor = 'not-allowed'; // 비활성화된 버튼의 커서 스타일
		                }
		            });
		        }
		    }).then((result) => {
		        if (result.isConfirmed) {
		        	
		        	let data = folderPath;
		        	
		            $.ajax({
		                url: '/files/delete', // 삭제 요청 URL
		                type: 'DELETE',
		                contentType: 'application/json',
		                data: JSON.stringify({
		                    files: selectedFiles, // 선택된 파일명 배열
		                    folderPath: data // 현재 폴더 경로 추가
		                }),
		                beforeSend: function(xhr) {
		                    xhr.setRequestHeader($('meta[name="_csrf_header"]').attr('content'), $('meta[name="_csrf"]').attr('content'));
		                },
		                success: function(response) {
		                    successDelete();
		                    selectedFiles = []; // 배열 초기화
		                    getFileList(data); // 현재 폴더 경로로 파일 목록 갱신
		                },
		                error: function(xhr, status, error) {
		                    alert('파일 삭제 중 오류가 발생했습니다: ' + error); // 오류 메시지
		                }
		            });
		        }
		    });
		}
		
		function creatFolder() {
		    Swal.fire({
		        title: '생성할 폴더명을 입력해주세요.',
		        icon: 'question',
		        input: 'text',
		        inputPlaceholder: '폴더명 입력(특수문자 제외 20자 미만)',
		        showCancelButton: true,
		        confirmButtonColor: '#4E7DF4',
		        confirmButtonText: '확인',
		        cancelButtonText: '취소',
		        reverseButtons: true,
		        inputAttributes: {
		            maxlength: 20 // 입력 가능한 최대 글자 수 20자 미만 설정
		        },
		        customClass: {
		            input: 'swal2-input',
		        },
		        willOpen: () => {
		            const confirmButton = Swal.getConfirmButton();
		            confirmButton.style.opacity = 0.5;
		            confirmButton.disabled = true;
		            confirmButton.style.cursor = 'not-allowed';

		            const inputField = Swal.getInput();

		            inputField.addEventListener('input', () => {
		                // 입력 필드 값이 비어 있지 않고 정규식 검사 통과 시 버튼 활성화
		                const validFolderName = /^[a-zA-Z가-힣0-9]{1,20}$/.test(inputField.value);
		                const isNotEmpty = inputField.value.trim() !== '';

		                if (validFolderName && isNotEmpty) {
		                    confirmButton.style.opacity = 1;
		                    confirmButton.disabled = false;
		                    confirmButton.style.cursor = 'pointer';
		                } else {
		                    confirmButton.style.opacity = 0.5;
		                    confirmButton.disabled = true;
		                    confirmButton.style.cursor = 'not-allowed';
		                }
		            });
		        }
		    }).then((result) => {
		        if (result.isConfirmed) {
		            const folderName = result.value;
		            // 폴더 생성 로직 추가
		            $.ajax({
		                url: '/files/folder',
		                type: 'POST',
		                data: folderName,
		                contentType: 'text/plain; charset=utf-8',
		                processData: false,
		                beforeSend: function(xhr) {
		                    xhr.setRequestHeader($('meta[name="_csrf_header"]').attr('content'), $('meta[name="_csrf"]').attr('content'));
		                },
		                success: function(res) {
		                    successFolder();
		                    getFileList("");
		                },
		                error: function(xhr, status, error) {
		                    alert('폴더 생성 실패: ' + error);
		                }
		            });
		        }
		    });
		}
    });
    /* 스위트 알러트 끝*/
 	/* 스위트 알러트 끝*/
 	/* 스위트 알러트 끝*/
 	/* 스위트 알러트 끝*/
	    
</script>
<style type="text/css">
	/* 대쉬 보드 시작 */
	.dashboard {
		display: grid;
		grid-template-rows: 1fr; /* 자식 요소가 1개의 행을 차지하도록 설정 */
		height: 89vh;
		padding: 50px 60px;
	}
	
	.card {
		background-color: white;
		border-radius: 20px;
		padding: 50px 60px;
		box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		margin: 0px;
		height: 100%; /* 카드가 부모의 높이를 100% 차지하도록 설정 */
	}
	
	.wbds_empty_link1 {
	    padding: 8px 12px;
	    height: 36px;
	    line-height: 20px;
	    display: inline-block;
	    box-sizing: border-box;
	    border-radius: 8px;
	    text-decoration: none;
	    vertical-align: middle;
	    white-space: nowrap;
	    cursor: pointer;
	    transition: background-color .1s;
	    background-color: #4E7DF4;;
	    border: 0;
	    color: white;
	    font-weight: 700;
	}
	
	.wbds_empty_link1:hover {
	    background-color: #3A63C8; /* 약 20% 더 어두운 색상 */
	    color: white;
	}
	
	.blueBtn {
	    padding: 8px 12px;
	    height: 36px;
	    line-height: 20px;
	    display: inline-block;
	    box-sizing: border-box;
	    border-radius: 8px;
	    text-decoration: none;
	    vertical-align: middle;
	    white-space: nowrap;
	    cursor: pointer;
	    transition: background-color .1s;
	    background-color: #f8f9fa; /* 옅은 회색 배경 */
	    border: 1px solid #dee2e6; /* 얇은 회색 보더 */
	    color: #333; /* 텍스트 색상 (진한 회색) */
	    font-weight: 100;
	    font-size: 14px;
	}
	
	.blueBtn:hover {
	    background-color: #f1f3f5; /* 약간 더 진한 회색 */
	    color: #333; /* 텍스트 색상 유지 */
	}
	
	#noneFileList tbody tr:hover {
        background-color: #f8f9fa; /* 연한 회색 */
        cursor: pointer;
    }
    
    #noneFileList tbody tr.selected {
        background-color: #e6f0ff; /* 연한 파란색 */
    }
    
    #noneFileList tbody {
	    max-height: 598px; /* 원하는 높이 설정 */
	    overflow-y: scroll; /* 세로 스크롤 활성화 */
	    display: block; /* tbody를 블록으로 설정하여 높이를 적용 */
	}
	
	#noneFileList thead, 
	#noneFileList tbody tr {
	    display: table; /* 테이블 스타일 유지 */
	    width: 100%; /* 테이블의 너비를 100%로 설정 */
	    table-layout: fixed; /* 고정 레이아웃 */
	}
	
	
	/* 스위트 알러스 css 시작 */
	/* 스위트 알러스 css 시작 */
	/* 스위트 알러스 css 시작 */
	/* 스위트 알러스 css 시작 */
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
	}
	
	.swal2-title { /* 타이틀 텍스트 사이즈 */
		font-size: 18px !important;
		padding-top: 1.5em;
    	padding-bottom: 0.5em;
	}
	
	.swal2-container.swal2-center>.swal2-popup {
		padding-top: 30px;
		width: 450px;
	}
	
	.swal2-input {
	    font-size: 15px;
	    height: 2em;
	    padding-top: 18px;
	    padding-bottom: 18px;
	    width: 270px; /* 원하는 너비로 설정 */
	    margin: 0 auto; /* 가운데 정렬 */
	    display: block; /* 인풋 필드를 블록 요소로 만들어서 margin이 적용되도록 */
	    text-align: center;
	    margin-top: 20px;
    	margin-bottom: 5px;
	}
	
	.swal2-input:focus {
		border : 1px solid #4E7DF4;
	}
	
	.swal2-input::placeholder {
	    color: #7a7a7a; /* 어둡게 설정 */
	    font-weight: 100; /* 얇게 설정 */
	}
	/* 스위트 알러스 css 끝 */
	/* 스위트 알러스 css 끝 */
	/* 스위트 알러스 css 끝 */
	
</style>
</head>
<body>
	<div class="dashboard">
		<div class="card">
<!-- 			헤더 시작-->
<!-- 			헤더 시작-->
<!-- 			헤더 시작-->
<!-- 			헤더 시작-->
<!-- 			헤더 시작-->
<!-- 			헤더 시작-->
			<div class="w-full flex justify-between">
				<h3 id="drivePath" class="text-lg font-semibold text-slate-800">내 드라이브</h3>
			</div>
			
			<div class="w-full flex justify-between" style="border-bottom: 1px solid #dee2e6; align-items: center; height: 90px; padding-left: 10px; padding: 30px 0px 20px 0px;">
				<div style="display: flex; align-items: center;">
					<div class="custom-control custom-checkbox" style="border: 1px solid #dee2e6; height: 36px; width: 36px; border-radius: 8px; margin-right: 10px;">
						<div style="margin-left: 9px; margin-top: 5px;">
							<input class="custom-control-input custom-control-input-primary custom-control-input-outline" type="checkbox" id="customCheckbox5">
							<label for="customCheckbox5" class="custom-control-label"></label>
						</div>
					</div>
					<div style="display: flex; gap: 8px; align-items: center;">
						<div>
							<input hidden type="file" id="fileInputTop" name="file" multiple/>
							<button type="button" class="wbds_empty_link1" style="font-size: 14px;">
							<i class="fa-solid fa-square-plus"></i>&ensp;파일 올리기
							</button>
						</div>
						
						<div id="createBtn">
							<button id="createFolderSelected" class="blueBtn" style="display: flex;">폴더생성</button>
						</div>
						
						<div id="backBtn" style="display: none;">
							<button class="blueBtn">뒤로가기</button>
						</div>
						
						<div>
							<button id="downloadSelected" class="blueBtn" style="display: flex;">내려받기</button>
						</div>
						
						<div>
							<button id="deleteSelected" class="blueBtn" style="display: flex;">삭제하기</button>
						</div>
						
					</div>
				</div>
				<div>
					<div class="w-full max-w-sm min-w-[200px] relative">
						<div class="relative">
							<input type="text" name="keyword" class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-100 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" placeholder="이름, 문서/이미지 내 텍스트 검색" value="${param.keyword != null ? param.keyword : ''}">
							<button type="submit" class="absolute h-8 w-8 right-1 top-1 my-auto px-2 flex items-center bg-white rounded">
								<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-8 h-8 text-slate-600">
									<path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"></path>
								</svg>
							</button>
						</div>
					</div>
				</div>
			</div>
<!-- 			헤더 끝-->
<!-- 			헤더 끝-->
<!-- 			헤더 끝-->
<!-- 			헤더 끝-->
<!-- 			헤더 끝-->

<!-- 			바디 시작-->
<!-- 			바디 시작-->
<!-- 			바디 시작-->
<!-- 			바디 시작-->
<!-- 			바디 시작-->
			<div class="h-full w-full flex">
<!-- 				왼쪽 -->
<!-- 				왼쪽 -->
<!-- 				왼쪽 -->
<!-- 				왼쪽 -->
				<div id="noneFileList" style="width: 80%; border-right: 1px solid #dee2e6; min-height: 150px;">
				</div>
<!-- 				오른쪽 -->
<!-- 				오른쪽 -->
<!-- 				오른쪽 -->
<!-- 				오른쪽 -->
<!-- 				오른쪽 -->
<!-- 				오른쪽 -->
				<div style="width: 20%; padding: 24px 0px 24px 24px;">
				
					<div style="height: 81px; border-bottom: 1px solid #dee2e6; display: flex; flex-direction: column; justify-content: space-between;">
						<div style="display: flex;">
							<span>
								<img id="fileViewIcon" src="/resources/images/cmmn_drive/smFolder.svg" style="min-width: 24px; min-height: 24px;" />
							</span>
							<strong style="margin-left: 17px; max-width: 100%; word-break: break-all;">
								<span id="fileViewName" style="display: inline-block; white-space: normal;">내 드라이브</span>
							</strong>
						</div>
						<div style="display: flex;">
							<span style="color: #4E7DF4; font-size: 14px; font-weight: 700; border-bottom: 2px solid #4E7DF4;">상세정보</span>
						</div>
					</div>
					
					<div style="margin-top: 20px; height: 180px; background-color: #f9fafc; border-radius: 8px; display: flex; justify-content: center; align-items: center;">
						<span>
							<img style="height: 100px;" id="holdThumbnail" src="/resources/images/cmmn_drive/bgFolder.svg" />
						</span>
					</div>
					
					<div style="display: flex; font-size: 13px; line-height: 19px; margin-top: 25px;">
						<div id="fileCategory" style="width: 34%;">
							<p style="margin-bottom: 10px;">종류</p>
							<p style="margin-bottom: 10px;">사용 용량</p>
						</div>
						<div id="fileExplain" style="width: 66%;">
							<p style="margin-bottom: 10px;">내 드라이브</p>
							<p id="totalFileSize" style="margin-bottom: 10px;"></p>
						</div>
					</div>
					<div id="shareBoundary">
					</div>
				</div>
			</div>
<!-- 			바디 끝 -->
<!-- 			바디 끝 -->
<!-- 			바디 끝 -->
<!-- 			바디 끝 -->
<!-- 			바디 끝 -->
<!-- 			바디 끝 -->
		</div>
	</div>
</body>
</html>