<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html style="background-color:#EAEAEA">
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/room-device-test-2.css">
<title>화상회의 생성</title>
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
</style>

<script type="text/javascript">
$(document).ready(function() {
	// 비디오 장치와 연결하기 위한 코드
	navigator.mediaDevices.getUserMedia({ video: true })
		.then(function(stream) {
		    const video = document.querySelector('.previewVideo');
		    video.srcObject = stream;
		    video.play();
		})
		.catch(function(err) {
		    console.error('카메라 연결 오류: ', err);
		});
	
	$('#conferenceRegist').on('click', function() {
	    console.log('등록 버튼 클릭 ');

	    var roomTitle = $('#roomTitle').val();
	    console.log('등록 roomTitle ', roomTitle);

	    // Swal을 이용해 비밀번호 입력창 띄우기
	    Swal.fire({
	        title: '비밀번호를 설정해주세요',
	        input: 'password', // 입력 타입을 password로 설정
	        inputPlaceholder: '비밀번호 설정',
	        showCancelButton: true,
	        confirmButtonColor: '#4E7DF4', // 확인 버튼 색상
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	        preConfirm: (passwd) => {
	            if (!passwd) {
	                Swal.showValidationMessage('비밀번호를 설정해주세요');
	                return false; // 비밀번호가 없을 경우 경고
	            }
	            return passwd;
	        }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            var passwd = result.value; // 입력된 비밀번호 값
	            console.log('입력된 비밀번호 ', passwd);

	            // 방 이름과 비밀번호를 객체에 담아 JSON으로 변환
	            var obj = {
	                roomName: roomTitle,
	                passwd: passwd
	            };
	            var jsonObj = JSON.stringify(obj);

	            console.log('전송할 데이터 ', jsonObj);

	            // 비밀번호와 함께 방 생성 요청
	            $.ajax({
	                url: '/roomRegist',
	                type: 'POST',
	                data: jsonObj,  // JSON 데이터를 전송
	                contentType: 'application/json;charset=UTF-8',  // JSON 형식으로 Content-Type 설정
	                dataType: 'json',
	                beforeSend: function(xhr) {
	                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 추가
	                },
	                success: function(res) {
	                    console.log('화상회의가 생성되었습니다, 결과값: ', res);
	                    
	                    var roomId = res.data.room.roomId; // 서버로부터 받은 roomId
	                    console.log('생성된 roomId: ', roomId);
	                    
	                    // 방 URL을 요청하기 위한 AJAX 호출
	                    $.ajax({
						    url: '/getRoomUrl',
						    type: 'POST',  // 반드시 POST 메서드를 사용
						    data: { roomId: roomId },  // roomId를 데이터로 전송
						    beforeSend: function(xhr) {
	    	                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 추가
	    	                },
	    	                success: function(res) {
	    	                    console.log('방 URL 요청 성공, 결과값: ', res);  // roomRes 대신 res로 수정
	    	                    var roomUrl = res.data.url;  // 서버에서 받은 방 URL
	    	                    Swal.fire({
	    	                        title: '화상회의 생성이 완료되었습니다.',
	    	                        icon: 'success',
	    	                        confirmButtonColor: '#4E7DF4',
	    	                        confirmButtonText: '확인'
	    	                    }).then(() => {
	    	                        // 새로운 창에서 방을 열기
	    	                        window.open(roomUrl, '_blank');
	    	                     	// 기존 창 닫기
	    	                        window.close();
	    	                    });
	    	                },
						    error: function(xhr) {
						        console.log('오류 발생: ' + xhr.status);
						    }
						});
	                },
	                error: function(xhr) {
	                    Swal.fire({
	                        title: '오류 발생',
	                        text: '에러 코드: ' + xhr.status,  // xhr.status로 변경
	                        icon: 'error',
	                        confirmButtonColor: '#4E7DF4',
	                        confirmButtonText: '확인'
	                    });
	                }
	            });
	        }
	    });
	});


    // 마이크 테스트 예시
    navigator.mediaDevices.getUserMedia({ audio: true })
        .then(function(stream) {
            // 마이크 음량을 실시간으로 표시하는 로직 추가
        });
});
</script>
</head>

	<body style="background-color:#EAEAEA">
		<!-- 등록폼 구성 -->
		<div class="device-set-container mt-20 bg-white" style="margin-left: auto;margin-right: auto;">
			<div class="device-set-info">
				<div class="device-set-info-header pc">
					<a href="/videoList" target="_top" class="back-btn" tabindex="3"
						aria-label="돌아가기"></a>
				</div>
				<div class="device-set-info-body deviceSetInfoBody">
					<div class="device-set-info-title-container">
						<div class="device-set-info-room-type">
							<h2 class="device-set-info-room-type-text roomType" style="background-color: #4E7DF4; border-radius: 32px; padding: 0 16px; width: 58px; line-height: 32px; font-size: 14px;">회의</h2>
						</div>
						<div class="device-set-info-title-wrapper">
							<p class="device-set-info-title roomTitle">회의 제목</p>
							<input class="border border-gray-300 mb-6 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5" placeholder="회의 제목을 입력해주세요." required
								type="text" id="roomTitle" name="roomTitle" /> 
						</div>
						<div class="device-set-info-check-wrapper">
							<p class="device-set-info-check">카메라, 마이크, 스피커 상태를 확인한 후 입장해주세요.</p>
							<p class="device-set-info-check mt-10">마이크가 연결되어있지 않으면 미팅룸 접속 시 카메라 송출이 어려울 수 있습니다.</p>
						</div>
					</div>
				</div>
				<div class="device-set-info-footer pc">
					<div class="device-set-join-btn-wrapper">
						<a id="conferenceRegist" href="#" class="default-btn joinBtn" tabindex="3">입장하기</a>
					</div>
				</div>
			</div>
		
			<div class="device-set-preview">
				<div class="device-set-preview-header">
					<div class="device-set-preview-title-wrapper">
						<a href="/service/room" target="_top" class="back-btn mobile"></a>
						<h1 class="device-set-preview-title">장치 테스트</h1>
						<button class="device-set-info-show-btn mobile showRoomInfoBtn"
							tabindex="-1">정보</button>
					</div>
				</div>
				<div class="device-set-preview-body">
					<div class="device-set-preview-video-container">
						<div class="device-set-preview-video-wrapper previewVideoWrapper">
							<video autoplay="" muted="" playsinline=""
								class="device-set-preview-video mirror previewVideo"
								data-videoinput-id="" data-audioinput-id="default"
								data-audiooutput-id="default"
								data-csw-streamid="4424dc8b-df21-4ec6-a2b0-839c05a068bc"></video>
						</div>
					</div>
					<div class="device-set-preview-options-container optionsContainer"
						data-option-type="video">
						<div class="device-set-preview-options-header">
							<div class="device-set-preview-options-tabs">
								<button class="device-set-preview-options-tab-btn optionTabBtn"
									data-option-type="video" tabindex="3" aria-label="비디오 탭">비디오</button>
								<button class="device-set-preview-options-tab-btn optionTabBtn"
									data-option-type="audio" tabindex="3" aria-label="오디오 탭">오디오</button>
							</div>
						</div>
						<div class="device-set-preview-options-body">
							<div class="device-set-preview-option-contents"
								data-option-type="video">
								<div class="device-set-preview-option-section deviceSection"
									style="display: none;">
									<div class="device-set-preview-option-header">
										<div class="device-set-preview-option-title-wrapper">
											<h3 class="device-set-preview-option-title">카메라</h3>
										</div>
									</div>
									<div class="device-set-preview-option-body">
										<div class="device-set-preview-option-select-wrapper">
											<select class="form-select" data-device-type="videoinput"
												onchange="DeviceTest.onChangeDevice(event)" tabindex="3"></select>
										</div>
									</div>
								</div>
		
								<div class="device-set-preview-option-section">
									<div class="device-set-preview-option-header">
										<div class="device-set-preview-option-title-wrapper">
											<h3 class="device-set-preview-option-title">
												가상 배경
											</h3>
											<p class="device-set-preview-option-description">장치성능에 따라
												배경 설정 시 회의품질이 낮아질 수 있습니다.</p>
										</div>
									</div>
									<div class="device-set-preview-option-body">
										<div
											class="device-set-preview-option-virtual-background-container virtualBackgroundContainer"
											data-background-type="none">
											<button
												class="device-set-preview-option-virtual-background-btn none"
												onclick="DeviceTest.onChangeVirtualBackground('none')"
												tabindex="-1"></button>
											<button
												class="device-set-preview-option-virtual-background-btn blur"
												onclick="DeviceTest.onChangeVirtualBackground('blur')"
												tabindex="-1">
												<div
													class="coach-mark-preview-virtual-background blur mobile">
													<div class="coach-mark-guide blur mobile">
														<div class="coach-mark-guide-arrow">
															<img
																src="../../../images/coachmark/coachmark_arrow_blue_07.svg"
																alt="coach-mark-guide-arrow">
														</div>
														<div class="coach-mark-guide-text-container">
															<p class="coach-mark-guide-text">가상 배경 효과 선택</p>
														</div>
													</div>
												</div>
											</button>
											<button
												class="device-set-preview-option-virtual-background-btn inside_01"
												onclick="DeviceTest.onChangeVirtualBackground('inside_01')"
												tabindex="-1"></button>
											<button
												class="device-set-preview-option-virtual-background-btn inside_02"
												onclick="DeviceTest.onChangeVirtualBackground('inside_02')"
												tabindex="-1"></button>
											<button
												class="device-set-preview-option-virtual-background-btn inside_03"
												onclick="DeviceTest.onChangeVirtualBackground('inside_03')"
												tabindex="-1"></button>
											<button
												class="device-set-preview-option-virtual-background-btn inside_04"
												onclick="DeviceTest.onChangeVirtualBackground('inside_04')"
												tabindex="-1"></button>
											<button
												class="device-set-preview-option-virtual-background-btn outside_01"
												onclick="DeviceTest.onChangeVirtualBackground('outside_01')"
												tabindex="-1"></button>
											<button
												class="device-set-preview-option-virtual-background-btn outside_02"
												onclick="DeviceTest.onChangeVirtualBackground('outside_02')"
												tabindex="-1"></button>
											<div
												class="device-set-preview-option-virtual-background-btn-wrapper custom">
												<input type="file" name="add-virtual-background"
													id="add-virtual-background" style="display: none"
													oninput="DeviceTest.onInputVirtualBackground(event)"
													tabindex="-1">
												<button
													class="device-set-preview-option-virtual-background-btn apply"
													onclick="DeviceTest.onChangeVirtualBackground('custom')"
													tabindex="-1"></button>
												<label for="add-virtual-background"
													class="device-set-preview-option-virtual-background-btn custom"></label>
												<label for="add-virtual-background"
													class="device-set-preview-option-virtual-background-btn change"
													style="display: none">변경</label>
											</div>
										</div>
									</div>
									<div class="device-set-preview-option-disabled-wrapper">
										<p class="device-set-preview-option-disabled-text">
											사파리 브라우저와 iOS기기는<br>가상 배경 서비스 준비 중입니다.
										</p>
									</div>
								</div>
		
							</div>
							<div class="device-set-preview-option-contents"
								data-option-type="audio">
								<div class="device-set-preview-option-section deviceSection">
									<div class="device-set-preview-option-header">
										<div class="device-set-preview-option-title-wrapper">
											<h3 class="device-set-preview-option-title">마이크</h3>
										</div>
									</div>
									<div class="device-set-preview-option-body">
										<div class="device-set-preview-option-select-wrapper">
											<select class="form-select" data-device-type="audioinput"
												onchange="DeviceTest.onChangeDevice(event)" tabindex="3"><option
													class="device" data-device-id="default" value="default">기본값
													- 마이크 배열(Realtek(R) Audio)</option>
												<option class="device" data-device-id="communications"
													value="communications">커뮤니케이션 - 머리에 거는 수화기(왕왕시나이노)
													(Bluetooth)</option>
												<option class="device"
													data-device-id="176ca898b65a933137b7cb033437475ebe07169825e6c78daaf320cb4e5d30a9"
													value="176ca898b65a933137b7cb033437475ebe07169825e6c78daaf320cb4e5d30a9">머리에
													거는 수화기(왕왕시나이노) (Bluetooth)</option>
												<option class="device"
													data-device-id="c1306fb0dd1c6df59a12c9d685324c855416c46acf153b1e568717d39bd3fcaa"
													value="c1306fb0dd1c6df59a12c9d685324c855416c46acf153b1e568717d39bd3fcaa">마이크
													배열(Realtek(R) Audio)</option></select>
										</div>
										<div class="device-set-preview-option-mic-volume-wrapper">
											<div class="device-set-preview-option-mic-volume">
												<div
													class="device-set-preview-option-mic-volume-fill audioVolumeGauge"
													style="width: 2.19141%;"></div>
											</div>
										</div>
										<div class="device-set-preview-option-deep-hearing-container">
											<div class="toggle-btn-container">
												<input type="checkbox" name="deep-hearing" id="deep-hearing"
													class="toggle-btn deepHearing"> <label
													for="deep-hearing" class="toggle-label">
													<div class="toggle-info">
														<span class="toggle-label-text deep-hearing">AI 음성
															품질 향상</span>
														<div class="description-container">
															<button class="description-btn" tabindex="-1">?</button>
															<div class="description-modal">
																<p class="description-text">A.I를 이용한 노이즈 제거, 음성 강화,
																	음성 인식 전처리 기술 등을 통해 주변 소음을 제거하고 음성 신호만 깨끗하게 전달하는 기술입니다.</p>
															</div>
														</div>
													</div>
													<div class="toggle-status" tabindex="3"
														aria-label="AI 음성 품질 향상 꺼짐"></div>
												</label>
											</div>
										</div>
									</div>
								</div>
								<div class="device-set-preview-option-section deviceSection">
									<div class="device-set-preview-option-header">
										<div class="device-set-preview-option-title-wrapper">
											<h3 class="device-set-preview-option-title">스피커</h3>
										</div>
									</div>
									<div class="device-set-preview-option-body">
										<div class="device-set-preview-option-select-wrapper">
											<select class="form-select" data-device-type="audiooutput"
												onchange="DeviceTest.onChangeDevice(event)" tabindex="3"><option
													class="device" data-device-id="default" value="default">기본값
													- 헤드폰(왕왕시나이노) (Bluetooth)</option>
												<option class="device" data-device-id="communications"
													value="communications">커뮤니케이션 - 헤드폰(왕왕시나이노)
													(Bluetooth)</option>
												<option class="device"
													data-device-id="f77d331669970596bb31d703b960f896b38c0c65b230c3920e105a04ac74b9ba"
													value="f77d331669970596bb31d703b960f896b38c0c65b230c3920e105a04ac74b9ba">스피커(Realtek(R)
													Audio)</option>
												<option class="device"
													data-device-id="d8289dae73026665f886c776ac6f939be6b8deee79d736d7abbf28bb4c92ec70"
													value="d8289dae73026665f886c776ac6f939be6b8deee79d736d7abbf28bb4c92ec70">헤드폰(왕왕시나이노)
													(Bluetooth)</option></select>
										</div>
									</div>
								</div>
								<div
									class="device-set-preview-option-section micAndSpeakerTestSection"
									style="">
									<div
										class="device-set-preview-option-mic-speaker-test-btn-wrapper">
										<button
											class="device-set-preview-option-mic-speaker-test-btn deviceTestBtn"
											tabindex="3">마이크 &amp; 스피커 테스트</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="device-set-preview-help-container">
					<p class="device-set-preview-help-text">장치에 문제가 있나요?</p>
					<a
						href="https://bizguide.gooroomee.com/efc908fc-baa8-4a02-bbb1-48645a5e5d2b"
						target="_blank" class="device-set-preview-help-link" tabindex="-1">설정
						가이드 보기</a>
				</div>
				<div class="device-set-preview-footer">
					<div class="device-set-preview-join-room-btn-wrapper mobile">
						<a href="#" class="default-btn join joinBtn">입장하기</a>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>