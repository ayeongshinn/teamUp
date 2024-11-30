<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- Include jQuery -->
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/room_renew.css">
<!-- Custom Styles -->
<style>
    @font-face {
        font-family: 'Pretendard-Regular';
        src: url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
        font-weight: 100;
        font-style: normal;
    }

    body {
        font-family: 'Pretendard-Regular', sans-serif;
        background-color: #f4f5f7;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    h1 {
        margin-top: 20px;
        font-size: 24px;
    }

    #videoContainer {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 60vh;
        width: 80%;
        background-color: #000;
        margin: 20px 0;
        border-radius: 8px;
    }

    video {
        width: 100%;
        height: auto;
    }

    #controls {
        text-align: center;
        margin: 20px 0;
    }

    button {
        padding: 10px 20px;
        margin: 0 10px;
        font-size: 16px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    button:hover {
        background-color: #0056b3;
    }
</style>

<!-- Page Content -->
<div class="room" tabindex="-1" data-room-mode="call" data-user-screenshare="false" data-right-side-on="true" data-right-side-view="true" data-subvideo-direction="0" data-live-presenter="true" data-buildtype="" data-mobile-device="false" data-call-ui-type="default" user-device-videoinput-len="1" user-device-audioinput-len="3" user-device-audiooutput-len="3" data-role-camera="true" data-roleid="speaker" data-role-mic="true" data-role-speaker="true" data-role-draw="true" data-record-enabled="false" data-r-id="ae95bd46a1b44c4d8fb01b41557b8b6c" data-group-license-id="free" data-group-id="_free" data-current-join-cnt="1" data-chat-use="true" data-waiting-room-use="false" data-my-video-mirror="true" data-my-noise-cancel="false" data-pip-video="false" data-app-type="" data-passwd="false" data-lock="false" data-call-type="p2p" data-live="false" data-live-mix-user="false" data-qnamode="false" data-show-room-doc-list="true" data-show-nickname-in-window="true" data-room-screenshare="false" data-media-play-state="pause">
	
	<div class="room-wrapper">
		<nav class="room-menu">
			<button class="logo" aria-label="방정보 설정" tabindex="3">
				<!-- <div class="logo-icon logo-icon-grm"></div> -->
				<div class="logo-icon logo-icon-2"></div>
			</button>
			<div class="room-timer">00:00:44</div>
			<ul class="room-menu-body">
				<li>
					<button data-menu="call" aria-label="영상통화" tabindex="3"></button>
				</li>
			</ul>
			<div class="room-menu-footer">
				
				<div data-menu="exit" data-allowed="all">
					<button class="default" aria-label="나가기" tabindex="99"></button>
					<button class="over" tabindex="-1"></button>
				</div>
			</div>
		</nav>
		
		<div class="room-main">
			<div class="grm-dialog-msg-layer room-setting">
				<div class="tabTrap" tabindex="1"></div>
				<div class="grm-dialog-top">
					<h4 class="grm-dialog-title">미팅룸 정보</h4>
					
					<div class="room-setting-top-btns">
						<button class="room-setting-top-btn" data-type="close" tabindex="1"><span>취소</span></button>
						<button class="room-setting-top-btn" data-type="ok" tabindex="1"><span class="confirm">확인</span></button>
					</div>
				</div>
				<div class="grm-dialog-body">
					<div class="room-setting-form-wrapper">
						<div class="room-setting-form">
							<label>라이브 모드</label>
							<div>
								<button id="roomLiveMode" data-grm-checkbox="toggle" data-grm-on="false" data-grm-text-on="켜짐" data-grm-text-off="꺼짐" tabindex="1" aria-live="assertive"><span>꺼짐</span></button>
							</div>
						</div>
						<div class="room-setting-form">
							<label>제목</label>
							<div class="room-title-input">
								<input type="text" name="roomTitle" maxlength="50" tabindex="1">
							</div>
						</div>
						<div class="room-setting-form isPublic">
							<label>공개 여부</label>
							<div class="openType">
								<button id="roomPublic" class="closed" data-grm-checkbox="toggle" data-grm-on="true" data-grm-text-on="공개" data-grm-text-off="비공개" data-grm-name="open-type" tabindex="1"><span>공개</span></button>
								<input type="password" class="room-pwd-field" name="passwd" maxlength="30" placeholder="비밀번호를 입력해주세요" tabindex="1">
								<div class="room-pwd-show">보기</div>
							</div>
						</div>
						<div class="room-setting-form roomUserRoleEnter">
							<div class="room-setting-form-room-userRole-enter">
								<label>입장 권한</label>
								<div>
									<span class="grm-select">
										<select name="defaultRoomUserRoleId" tabindex="1" aria-label="입장 권한">
											
												
											
												
													<option value="emcee">진행자</option>
												
											
												
													<option value="participant">참여자</option>
												
											
										</select>
									</span>
								</div>
							</div>
						</div>
						
						<div class="room-setting-form chat-activation">
							<div class="room-setting-form-label">
								<label>채팅 사용</label>
								<p class="form-label-desc-tx">
									참여자 모두 채팅을 사용할 수 있습니다. 기능을 끄면 참여자는 채팅을 사용할 수 없습니다.
								</p>
							</div>
							<div class="room-setting-form-toggle-btn">
								<button id="useChat" data-grm-checkbox="toggle" data-grm-on="true" data-grm-text-on="켜짐" data-grm-text-off="꺼짐" tabindex="1"><span>켜짐</span></button>
							</div>
						</div>
						<div class="room-setting-form livemode-mix-user">
							<label>참여자 영상보기</label>
							<div>
								<div id="liveModeMixUser" data-grm-checkbox="toggle" data-grm-on="false" data-grm-text-on="켜짐" data-grm-text-off="꺼짐" data-grm-name="isLiveModeMixUser"><span>꺼짐</span></div>
							</div>
						</div>
						<div class="room-setting-form rightSideView" style="display:none;">
							<div class="rightSideView-basic">
								<label>참여자 목록 &amp; 채팅 숨기기</label>
								<div>
									<div id="rightSideView" data-grm-checkbox="toggle" data-grm-on="false" data-grm-text-on="켜짐" data-grm-text-off="꺼짐" data-grm-name=""><span>꺼짐</span></div>
								</div>
							</div>
							<div class="rightSideViewOption" style="display: none;">
								<div class="grade-right-setting">
									<div class="selectUserRec">
										<label>발표자</label>
										<div class="toggleRec">
											<div data-user-type="speaker" data-grm-checkbox="toggle" data-grm-checkboxsize="S" data-grm-on="true" data-grm-name=""><span></span></div>
										</div>
									</div>
									<div class="selectUserRec">
										<label>진행자</label>
										<div class="toggleRec">
											<div data-user-type="emcee" data-grm-checkbox="toggle" data-grm-checkboxsize="S" data-grm-on="true" data-grm-name=""><span></span></div>
										</div>
									</div>
								</div>
								
							</div>
						</div>
						<div class="room-setting-form block-type video-layout-setting">
							<label>
								화면 레이아웃
							</label>
							
							<div class="screen-layout-type-select" layout-type="grid">
								<div class="screen-layout-type-header">
									<button class="layout-type-btn grid-btn" tabindex="1">격자형</button>
									<button class="layout-type-btn announce-btn" tabindex="1">발표형</button>
								</div>
								<div class="video-layout-type-list ps">
									<div class="screen-layout-type video-layout-type-list-body"><button class="video-layout-type" data-layout-type="auto" data-license-type="free" tabindex="1" aria-label="auto"></button><button class="video-layout-type" data-layout-type="ml_01_00" data-license-type="free" tabindex="1" aria-label="layout01"></button><button class="video-layout-type" data-layout-type="ml_02_00" data-license-type="free" tabindex="1" aria-label="layout02"></button><button class="video-layout-type" data-layout-type="ml_03_00" data-license-type="free" tabindex="1" aria-label="layout03"></button><button class="video-layout-type" data-layout-type="ml_04_00" data-license-type="free" tabindex="1" aria-label="layout04"></button><button class="video-layout-type" data-layout-type="ml_05_00" data-license-type="free" tabindex="1" aria-label="layout05"></button><button class="video-layout-type" data-layout-type="ml_06_00" data-license-type="free" tabindex="1" aria-label="layout06"></button><button class="video-layout-type" data-layout-type="ml_07_00" data-license-type="free" tabindex="1" aria-label="layout07"></button><button class="video-layout-type" data-layout-type="ml_08_00" data-license-type="free" tabindex="1" aria-label="layout08"></button><button class="video-layout-type" data-layout-type="ml_09_00" data-license-type="free" tabindex="1" aria-label="layout09"></button><button class="video-layout-type" data-layout-type="ml_10_00" data-license-type="free" tabindex="1" aria-label="layout10"></button><button class="video-layout-type" data-layout-type="ml_11_00" data-license-type="free" tabindex="1" aria-label="layout11"></button><button class="video-layout-type" data-layout-type="ml_12_00" data-license-type="free" tabindex="1" aria-label="layout12"></button><button class="video-layout-type" data-layout-type="ml_13_00" data-license-type="free" tabindex="1" aria-label="layout13"></button><button class="video-layout-type" data-layout-type="ml_16_00" data-license-type="free" tabindex="1" aria-label="layout16"></button><button class="video-layout-type" data-layout-type="ml_17_00" data-license-type="premium" tabindex="1" aria-label="layout17"></button><button class="video-layout-type" data-layout-type="ml_19_00" data-license-type="premium" tabindex="1" aria-label="layout19"></button><button class="video-layout-type" data-layout-type="ml_20_00" data-license-type="premium" tabindex="1" aria-label="layout20"></button><button class="video-layout-type" data-layout-type="ml_22_00" data-license-type="premium" tabindex="1" aria-label="layout22"></button><button class="video-layout-type" data-layout-type="ml_25_00" data-license-type="premium" tabindex="1" aria-label="layout25"></button><button class="video-layout-type" data-layout-type="ml_30_00" data-license-type="premium" tabindex="1" aria-label="layout30"></button><button class="video-layout-type" data-layout-type="ml_33_00" data-license-type="premium" tabindex="1" aria-label="layout33"></button><button class="video-layout-type" data-layout-type="ml_36_00" data-license-type="premium" tabindex="1" aria-label="layout36"></button><button class="video-layout-type" data-layout-type="ml_40_00" data-license-type="premium" tabindex="1" aria-label="layout40"></button><button class="video-layout-type" data-layout-type="ml_43_00" data-license-type="premium" tabindex="1" aria-label="layout43"></button><button class="video-layout-type" data-layout-type="ml_46_00" data-license-type="premium" tabindex="1" aria-label="layout46"></button><button class="video-layout-type" data-layout-type="ml_49_00" data-license-type="premium" tabindex="1" aria-label="layout49"></button><button class="video-layout-type" data-layout-type="ml_49_01" data-license-type="premium" tabindex="1" aria-label="layout49"></button><button class="video-layout-type" data-layout-type="ml_56_00" data-license-type="premium" tabindex="1" aria-label="layout56"></button><button class="video-layout-type" data-layout-type="ml_58_00" data-license-type="premium" tabindex="1" aria-label="layout58"></button><button class="video-layout-type" data-layout-type="ml_61_00" data-license-type="premium" tabindex="1" aria-label="layout61"></button><button class="video-layout-type" data-layout-type="ml_64_00" data-license-type="premium" tabindex="1" aria-label="layout64"></button><button class="video-layout-type" data-layout-type="ml_81_00" data-license-type="premium" tabindex="1" aria-label="layout81"></button><button class="video-layout-type" data-layout-type="ml_100_00" data-license-type="premium" tabindex="1" aria-label="layout100"></button><button class="video-layout-type" data-layout-type="ml_121_00" data-license-type="premium" tabindex="1" aria-label="layout121"></button><button class="video-layout-type" data-layout-type="ml_144_00" data-license-type="premium" tabindex="1" aria-label="layout144"></button></div>
									<div class="screen-layout-type announce-type">
										<button class="video-layout-type announce-layout-btn" data-layout-type="ml_02_03" data-license-type="free" tabindex="1" aria-label="layout02"></button>
										<button class="video-layout-type announce-layout-btn" data-layout-type="ml_05_01" data-license-type="free" tabindex="1" aria-label="layout05"></button>
										<button class="video-layout-type announce-layout-btn" data-layout-type="ml_11_01" data-license-type="free" tabindex="1" aria-label="layout11"></button>
										<button class="video-layout-type announce-layout-btn" data-layout-type="ml_12_01" data-license-type="free" tabindex="1" aria-label="layout12"></button>
										
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_21_00" data-license-type="premium" tabindex="1" aria-label="layout21"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_22_01" data-license-type="premium" tabindex="1" aria-label="layout22"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_31_00" data-license-type="premium" tabindex="1" aria-label="layout31"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_31_01" data-license-type="premium" tabindex="1" aria-label="layout31"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_32_00" data-license-type="premium" tabindex="1" aria-label="layout32"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_32_01" data-license-type="premium" tabindex="1" aria-label="layout32"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_41_00" data-license-type="premium" tabindex="1" aria-label="layout41"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_41_01" data-license-type="premium" tabindex="1" aria-label="layout41"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_42_00" data-license-type="premium" tabindex="1" aria-label="layout42"></button>
											<button class="video-layout-type announce-layout-btn" data-layout-type="ml_42_01" data-license-type="premium" tabindex="1" aria-label="layout42"></button>
										
									</div>
									<script>
										(function(){
											//var s = $('<select style="color: #000"></select>');
											var list = ['auto,free',
												//'ml_01_00', 'ml_02_00', 'ml_02_01', 'ml_03_00', 'ml_03_01', 'ml_04_00', 'ml_04_01',
												//'ml_01_00,premium', 'ml_02_00', 'ml_03_00', 'ml_04_00',
												'ml_01_00,free', 'ml_02_00', 'ml_03_00', 'ml_04_00',
												'ml_05_00,', 'ml_06_00', 'ml_07_00', 'ml_08_00', 'ml_09_00',
												'ml_10_00', 'ml_11_00', 'ml_12_00', 'ml_13_00', 'ml_16_00',
												'ml_17_00,premium','ml_19_00',
												'ml_20_00', 'ml_22_00', 'ml_25_00',
												'ml_30_00', 'ml_33_00', 'ml_36_00',
												'ml_40_00', 'ml_43_00', 'ml_46_00', 'ml_49_00', 'ml_49_01',
												'ml_56_00','ml_58_00',
												'ml_61_00', 'ml_64_00',
												'ml_81_00', 'ml_100_00',
												'ml_121_00', 'ml_144_00'
											]

											var license = 'free';
											var src = [];
											list.forEach(function(typeStr, i){
												var types = typeStr.split(',');
												var type = types[0].trim();
												var lic = types[1] && types[1].trim();
												if(lic){
													license = lic;
												}
												var startIndex = type.indexOf('_')+1;
												var endIndex = type.lastIndexOf('_');
												var label = 'layout'+type.substring(startIndex,endIndex);
												if(type==='auto'){
													label='auto'
												}
												if(license !== 'free'){
													src.push('<button class="video-layout-type" data-layout-type="'+type+'" data-license-type="'+license+'" tabindex="1" aria-label="'+label+'"></button>');
												}else{
													src.push('<button class="video-layout-type" data-layout-type="'+type+'" data-license-type="'+license+'" tabindex="1" aria-label="'+label+'"></button>');
												}
											});
											$('.video-layout-type-list-body').html(src.join(''));
										})();
									</script>
								<div class="ps__rail-x" style="left: 0px; bottom: 0px;"><div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div></div><div class="ps__rail-y" style="top: 0px; right: 0px;"><div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 0px;"></div></div></div>
							</div>
						</div>
					</div>
				</div>
				<div class="grm-dialog-footer">
					<button class="grm-btn cancel">취소</button>
					<button class="grm-btn ok">확인</button>
				</div>
				<div class="tabTrap" tabindex="1"></div>
			</div>

			<div class="room-status-msg-layer">
				<div class="room-status-msg-views">
				</div>
			</div>

			<div class="room-main-top">
				<div class="room-main-top-left">
					<div class="roomLock"></div>
					<div class="room-live-status">LIVE</div>
					<div class="room-title">나는야케첩될고요</div>
					
					<div class="room-title-line"></div>
					<div class="room-join-count">1</div>
					
					<div class="end-date-timer-layer">
					</div>
				</div>
				<div class="room-main-controls" data-my-mic="off" data-my-speaker="off" data-my-camera="off" data-my-fullscreen="off">
					<button class="icon-global-mic" data-btn-type="mic" aria-label="마이크 끄기" tabindex="3"><span class="device-status-tx">마이크</span></button>
					<button class="icon-global-mic-off" data-btn-type="mic" data-btn-off="true" aria-label="마이크 켜기" tabindex="3"><span class="device-status-tx">마이크</span></button>
					<button class="icon-volume-medium" data-btn-type="speaker" aria-label="스피커 끄기" tabindex="3"></button>
					<button class="icon-volume-mute2" data-btn-type="speaker" data-btn-off="true" aria-label="스피커 켜기" tabindex="3"></button>
					<button class="icon-global-camera" data-btn-type="camera" aria-label="카메라 끄기" tabindex="3"><span class="device-status-tx">카메라</span></button>
					<button class="icon-global-camera-off" data-btn-type="camera" data-btn-off="true" aria-label="카메라 켜기" tabindex="3"><span class="device-status-tx">카메라</span></button>
					<button class="mobileCameraRotateBtn" data-type="cameraRotate" tabindex="-1"><span class="device-status-tx">카메라 전환</span></button>
					<button class="icon-global-settings" data-btn-type="deviceSetting" aria-label="설정" tabindex="3"><span class="device-status-tx">설정</span></button>
					<button class="icon-global-size-increase" data-btn-type="fullscreen" data-btn-off="true" aria-label="전체화면" tabindex="3"><span class="device-status-tx">전체화면</span></button>
					<button class="icon-global-size-decrease" data-btn-type="fullscreen" aria-label="전체화면" tabindex="3"><span class="device-status-tx">전체화면</span></button>
				</div>
				<div class="room-main-sub-controls clearfix">
					<div class="rec-controls">
						<button class="icon-global-rec btn-rec" data-type="start" aria-label="녹화" tabindex="3">
							<div class="btn-record">
								<div class="circle"></div>
								<div class="txt">REC</div>
							</div>
							<div class="recordingTime "></div>
						</button>
						<div class="rec-control-btns btn-rec">
							<div class="btn-play">
								<div class="play" data-type="resume"></div>
								<div class="pause" data-type="pause"></div>
							</div>
							<div class="btn-stop" data-type="stop">
								<div class="stop"></div>
							</div>
						</div>
					</div>
					<button class="room-btn-invite btn-invite" data-type="invite" aria-label="초대" tabindex="3"></button>
					<div class="mobile-top-control">
						<button class="mobile-top-control-btn room-btn-invite btn-invite"></button>
						<button class="mobile-top-control-btn btn-device">장치</button>
					</div>
					
					<span class="icon-global-menu btn-right-side-toggle" data-type="menu" tabindex="3" aria-label="확장 메뉴 열기"></span>
					<span class="icon-global-menu menu-close btn-right-side-toggle" data-type="close" tabindex="3" aria-label="확장 메뉴 닫기"></span>
					<span class="icon-global-chat btn-right-side-toggle" data-type="chat" tabindex="3" aria-label="채팅 메세지">
						<span class="chat-badge-count"></span>
					</span>
				</div>
			</div>
			<!-- .room-main-top -->

			

			<!-- user-setting -->
			<div class="device-set-wrapper deviceSetWrapper" style="display: none" data-videoinputid="f7b0143a22afeec8c835dbe2b7c02c63a671b811db1c436b78a8ea4cddd32009" data-audioinputid="default" data-audiooutputid="default" tabindex="-1">
				<div class="tabTrap" tabindex="1"></div>
				<div class="device-set-container">
					<div class="device-set-preview">
						<div class="device-set-preview-header">
							<div class="device-set-preview-title-wrapper">
								<p class="device-set-preview-title">장치 설정</p>
								<button class="close-btn closeDeviceSettingBtn" tabindex="1" aria-label="장치설정 닫기"></button>
							</div>
						</div>
						<div class="device-set-preview-body">
							<div class="device-set-preview-video-container">
								<div class="device-set-preview-video-wrapper previewVideoWrapper">
									<video autoplay="" muted="" playsinline="" class="device-set-preview-video previewVideo"></video>
								</div>
								<div class="device-set-preview-status">
									<div class="device-set-preview-status-header"></div>
									<div class="device-set-preview-status-footer">
										<div class="device-set-preview-status-controls">
											<button class="device-set-preview-status-control mic micStatus" tabindex="-1"></button>
											<button class="device-set-preview-status-control camera cameraStatus" tabindex="-1"></button>
										</div>
									</div>
								</div>
							</div>
							<div class="device-set-preview-options-container optionsContainer" data-option-type="video">
								<div class="device-set-preview-options-header">
									<div class="device-set-preview-options-tabs">
										<button class="device-set-preview-options-tab-btn optionTabBtn" data-option-type="video" tabindex="1" aria-label="비디오 탭">비디오</button>
										<button class="device-set-preview-options-tab-btn optionTabBtn" data-option-type="audio" tabindex="1" aria-label="오디오 탭">오디오</button>
									</div>
								</div>
								<div class="device-set-preview-options-body">
									<div class="device-set-preview-option-contents" data-option-type="video">
										<div class="device-set-preview-option-section">
											<div class="device-set-preview-option-header">
												<div class="device-set-preview-option-title-wrapper">
													<h3 class="device-set-preview-option-title">카메라</h3>
												</div>
											</div>
											<div class="device-set-preview-option-body">
												<div class="device-set-preview-option-select-wrapper">
													<select class="form-select" data-device-type="videoinput" tabindex="1"><option value="f7b0143a22afeec8c835dbe2b7c02c63a671b811db1c436b78a8ea4cddd32009">HD Webcam (5986:211c)</option></select>
												</div>
												<div class="device-set-preview-option-video-mirror-container">
													<div class="toggle-btn-container">
														<input type="checkbox" name="video-mirror" id="video-mirror" class="toggle-btn videoMirror">
														<label for="video-mirror" class="toggle-label">
															<span class="toggle-label-text">영상 좌우반전</span>
															<div class="toggle-status" tabindex="1" aria-label="영상 좌우반전"></div>
														</label>
													</div>
												</div>
											</div>
										</div>
										<div class="device-set-preview-option-section video-resolution">
											<div class="device-set-preview-option-header">
												<div class="device-set-preview-option-title-wrapper">
													<h3 class="device-set-preview-option-title">영상 품질</h3>
													<p class="device-set-preview-option-description">네트워크 환경이 좋지 않다면 화질을 변경해주세요.</p>
												</div>
												<div class="device-set-preview-option-body">
													<ul class="device-set-preview-option-resolution">
														<li data-video-resolution="pc">
															<button class="device-set-block-btn" tabindex="1" aria-label="높음">높음</button>
														</li>
														<li data-video-resolution="mobile">
															<button class="device-set-block-btn" tabindex="1" aria-label="일반">일반</button>
														</li>
													</ul>
												</div>
											</div>
										</div>
										
										<div class="device-set-preview-option-section">
											<div class="device-set-preview-option-header">
												<div class="device-set-preview-option-title-wrapper">
													<h3 class="device-set-preview-option-title">가상 배경<span class="device-set-preview-option-beta"><img src="../../../images/icon/ico_beta_blue.svg"></span></h3>
													<p class="device-set-preview-option-description">장치성능에 따라 배경 설정 시 회의품질이 낮아질 수 있습니다.</p>
												</div>
											</div>
											<div class="device-set-preview-option-body">
												<div class="device-set-preview-option-virtual-background-container virtualBackgroundContainer" data-background-type="none">
													<button class="device-set-preview-option-virtual-background-btn none" onclick="VirtualBackground.onChangeVirtualBackground('none')" tabindex="-1"></button>
													<button class="device-set-preview-option-virtual-background-btn blur" onclick="VirtualBackground.onChangeVirtualBackground('blur')" tabindex="-1"></button>
													<button class="device-set-preview-option-virtual-background-btn inside_01" onclick="VirtualBackground.onChangeVirtualBackground('inside_01')" tabindex="-1"></button>
													<button class="device-set-preview-option-virtual-background-btn inside_02" onclick="VirtualBackground.onChangeVirtualBackground('inside_02')" tabindex="-1"></button>
													<button class="device-set-preview-option-virtual-background-btn inside_03" onclick="VirtualBackground.onChangeVirtualBackground('inside_03')" tabindex="-1"></button>
													<button class="device-set-preview-option-virtual-background-btn inside_04" onclick="VirtualBackground.onChangeVirtualBackground('inside_04')" tabindex="-1"></button>
													<button class="device-set-preview-option-virtual-background-btn outside_01" onclick="VirtualBackground.onChangeVirtualBackground('outside_01')" tabindex="-1"></button>
													<button class="device-set-preview-option-virtual-background-btn outside_02" onclick="VirtualBackground.onChangeVirtualBackground('outside_02')" tabindex="-1"></button>
													<div class="device-set-preview-option-virtual-background-btn-wrapper custom addVirtualBackgroundBtnWrapper">
														<input type="file" name="add-virtual-background" id="add-virtual-background" style="display: none" oninput="VirtualBackground.onInputVirtualBackground(event)" tabindex="-1">
														<button class="device-set-preview-option-virtual-background-btn apply" onclick="VirtualBackground.onChangeVirtualBackground('custom')" tabindex="-1"></button>
														<label for="add-virtual-background" class="device-set-preview-option-virtual-background-btn custom"></label>
														<label for="add-virtual-background" class="device-set-preview-option-virtual-background-btn change" style="display: none">변경</label>
													</div>
												</div>
											</div>
											<div class="device-set-preview-option-disabled-wrapper">
												<p class="device-set-preview-option-disabled-text">사파리 브라우저와 iOS기기는<br>가상 배경 서비스 준비 중입니다.</p>
											</div>
										</div>
										
									</div>
									<div class="device-set-preview-option-contents" data-option-type="audio">
										<div class="device-set-preview-option-section">
											<div class="device-set-preview-option-header">
												<div class="device-set-preview-option-title-wrapper">
													<h3 class="device-set-preview-option-title">마이크</h3>
												</div>
											</div>
											<div class="device-set-preview-option-body">
												<div class="device-set-preview-option-select-wrapper">
													<select class="form-select" data-device-type="audioinput" tabindex="-1"><option value="default">기본값 - 마이크 배열(Realtek(R) Audio)</option><option value="communications">커뮤니케이션 - 마이크 배열(Realtek(R) Audio)</option><option value="c1306fb0dd1c6df59a12c9d685324c855416c46acf153b1e568717d39bd3fcaa">마이크 배열(Realtek(R) Audio)</option></select>
												</div>
												<div class="device-set-preview-option-mic-volume-wrapper">
													<div class="device-set-preview-option-mic-volume">
														<div class="device-set-preview-option-mic-volume-fill audioVolumeGauge"></div>
													</div>
												</div>
												<div class="device-set-preview-option-deep-hearing-container">
													<div class="toggle-btn-container">
														<input type="checkbox" name="deep-hearing" id="deep-hearing" class="toggle-btn deepHearing">
														<label for="deep-hearing" class="toggle-label">
															<div class="toggle-info">
																<span class="toggle-label-text deep-hearing">AI 음성 품질 향상</span>
																<div class="description-container">
																	<button class="description-btn" tabindex="-1">?</button>
																	<div class="description-modal">
																		<p class="description-text">A.I를 이용한 노이즈 제거, 음성 강화, 음성 인식 전처리 기술 등을 통해 주변 소음을 제거하고 음성 신호만 깨끗하게 전달하는 기술입니다.</p>
																	</div>
																</div>
															</div>
															<div class="toggle-status" tabindex="1" aria-label="AI 음성 품질 향상"></div>
														</label>
													</div>
												</div>
											</div>
										</div>
										<div class="device-set-preview-option-section">
											<div class="device-set-preview-option-header">
												<div class="device-set-preview-option-title-wrapper">
													<h3 class="device-set-preview-option-title">스피커</h3>
												</div>
											</div>
											<div class="device-set-preview-option-body">
												<div class="device-set-preview-option-select-wrapper">
													<select class="form-select" data-device-type="audiooutput" tabindex="1"><option value="default">기본값 - 스피커(Realtek(R) Audio)</option><option value="communications">커뮤니케이션 - 스피커(Realtek(R) Audio)</option><option value="f77d331669970596bb31d703b960f896b38c0c65b230c3920e105a04ac74b9ba">스피커(Realtek(R) Audio)</option></select>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="device-set-preview-help-container">
							<p class="device-set-preview-help-text">장치에 문제가 있나요?</p>
							<a href="https://bizguide.gooroomee.com/efc908fc-baa8-4a02-bbb1-48645a5e5d2b" target="_blank" class="device-set-preview-help-link">설정 가이드 보기</a>
						</div>
						<div class="device-set-preview-footer">
							<div class="device-set-preview-join-room-btn-wrapper">
								<button class="default-btn saveDeviceSettingBtn" tabindex="1">저장</button>
								<div class="loading"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="tabTrap" tabindex="1"></div>
			</div>
			<!-- user-setting -->

			<!-- <div class="room-call-wrapper"></div> -->
			<div class="roomCallMainVideosRec">
			<!-- 	<div class="roomCallMainVideo"> -->

				<div class="room-call-main-videos clearfix" data-live-presenter="true" data-screensharemode="">
					
					<!-- <div class="mixing-guide-layer"></div> -->

					
				<div class="video-layer" data-userid="lxuuftaq6zrgz" data-user-roleid="speaker" data-my-video="true" data-device-status-camera="off" data-device-status-mic="off" data-device-status-speaker="off" data-screenshare="false">
			<video autoplay="autoplay" data-video-type="user" playsinline="" data-csw-streamid="9a3953d5-c462-43cd-badc-e2699336a17c" data-tid="@1d5ea8c6-9cb1-4f74-8a31-7d7f23eb6bd5@fb156f5c-c030-4e49-9129-17640d927706"></video>
			<div class="video-cover">
				<div class="user-device-status">
					<span data-device-type="mic"></span>
					<span class="roleIdSpeaker"></span>
					<span data-device-type="speaker"></span>
					<span data-device-type="camera"></span>
				</div>
				<div class="user-info-wrapper">
					<div class="user-info-rec">
						<div class="user-info user-volume">
							<span class="room-user-nickname" title="구루미">구루미</span> 
							<span class="editIco"></span>
						</div>
					</div>
				</div>
				<div class="user-camstudy">
					<div class="stopwatch">
						<div class="stopwatch-wrap">
							<span class="stopwatch-time"></span>
							<span class="pause" data-btn="stopwatch-pause"></span>
							<span class="reset" data-btn="stopwatch-reset"></span>
						</div>
					</div>
					<div class="my-msg">
						<div>
							<span data-cs-type="mymsg">메세지 입력</span>
							<button></button>
						</div>
					</div>
				</div>
			</div>
		</div></div>
			</div>

			<div class="room-call-sub-videos" data-video-count="0">
				<div class="room-call-sub-btns">
					<div class="room-call-subBtnRec">
						<div class="room-call-sub-btn" data-btn-type="toggleVideos">
							<span class="left"></span>
							<span class="right"></span>
						</div>
					</div>
				</div><div class="videos"></div>
			</div>
			
			<div class="room-doc" data-curr-page-cnt="1" data-page-list="false">
				<div class="room-doc-side">
					<div class="room-doc-side-top">
						<div class="room-doc-top-title">
							공유 자료
						</div>
					</div>
					<div class="back-room-doc-list">
						문서목록
					</div>
					<div class="room-doc-side-body ps">
						<div class="room-doc-list">
							<div class="room-doc-item fileItem active" data-file-ext="" draggable="true" data-docid="whiteboard" data-docseq="0" title="화이트보드">
				<div class="docMoreBtnRec">
					<button class="docMoreBtn"></button>
				</div>
				<div class="room-doc-item-img">
					<img alt="공유문서" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC">
				</div>
				<div class="room-doc-desc">화이트보드</div>
				<ul class="docMoreMenu" style="/*display: block;*/">
					<li class="docMoreItem" btn-type="save">저장</li>
					<li class="docMoreItem" btn-type="delete">삭제</li>
				</ul>
			</div><div class="room-doc-item room-doc-add" title="문서 또는 이미지 추가">
								<div class="room-doc-item-img">
									<div class="room-doc-add-text">
										파일 추가
									</div>
								</div>
								<input type="file" style="display: none;" multiple="multiple" accept="image/*,.pdf,.xls,.xlsx,.ppt,.pptx,.doc,.docx,.hwp,.hwpx" size="3">
							</div>
						</div>
						<div class="room-doc-page-list">
							<ol></ol>
						</div>
					<div class="ps__rail-x" style="left: 0px; bottom: 0px;"><div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div></div><div class="ps__rail-y" style="top: 0px; right: 0px;"><div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 0px;"></div></div></div>
				</div>
				<div class="room-doc-view-wrapper">
					<!-- [data-room-mode="docshare"] paging -->
					<div class="docPagingRec">
						<div class="docPaging">
							<ul>
								<li class="btnRec">
									<button class="btn" data-type="prev"></button>
								</li>
								<li class="pageRec">
									<input class="inputField currentPage" maxlength="3">
									<span class="divisionLine">/</span>
									<span class="totalPage"></span>
								</li>
								<li class="btnRec">
									<button class="btn" data-type="next"></button>
								</li>
							</ul>
						</div>
					</div>
					<div class="room-doc-view" draggable="false"><div style="position: relative; font-size: 10px; touch-action: none; width: 100%; height: calc(100% + 0px); margin-left: 0px; margin-top: 0px;"><div style="position: absolute; left: 0px; top: 0px;"><canvas id="_csc_1728094969969_0" draggable="false" width="0" height="0" style="user-select: none; font: 10px / 10px Lato, &quot;Noto Sans KR&quot;, &quot;맑은 고딕&quot;, &quot;Malgun Gothic&quot;, 돋움, dotum, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; position: absolute; inset: 0px; cursor: default; background-color: rgb(255, 255, 255);"></canvas><canvas id="_csc_1728094969969_1" draggable="false" width="0" height="0" style="user-select: none; font: 10px / 10px Lato, &quot;Noto Sans KR&quot;, &quot;맑은 고딕&quot;, &quot;Malgun Gothic&quot;, 돋움, dotum, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; position: absolute; inset: 0px;"></canvas><canvas id="_csc_1728094969970_4" draggable="false" width="0" height="0" style="user-select: none; font: 10px / 10px Lato, &quot;Noto Sans KR&quot;, &quot;맑은 고딕&quot;, &quot;Malgun Gothic&quot;, 돋움, dotum, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; position: absolute; inset: 0px;"></canvas><canvas id="_csc_1728094969970_5" draggable="false" width="0" height="0" style="user-select: none; font: 10px / 10px Lato, &quot;Noto Sans KR&quot;, &quot;맑은 고딕&quot;, &quot;Malgun Gothic&quot;, 돋움, dotum, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; position: absolute; inset: 0px; pointer-events: auto; cursor: url(&quot;images/room/doc/cursor_pencil_yellow.png&quot;), default;"></canvas></div></div></div>
					<div class="room-doc-view-v2">
						<div data-gooroomee-canvas="share" style="width: calc(95% - 10px); height: 99%;">
<!-- 							<div class="wrap" style="width: 100%; height: 100%;"></div> -->
						</div>
						<div class="cvs-resize-handle" style="
						    display: inline-block;
						    width: 5px;
						    height: 99%;
						    cursor: col-resize;
						"></div>
						<div data-gooroomee-canvas="mine" style="width: calc(5% - 10px); height: 99%;">
							<div class="syncBtnRec btn-send-mycanvas">
								<button class="syncBtn">
									<span></span>
								</button>
							</div>
<!-- 							<div class="wrap" style="width: 100%; height: 100%;"></div> -->
						</div>
					</div>
					<div class="room-doc-palette">
						<div class="icon-draw-pointer" data-toolkit="LaserPointer"></div>
						<div class="icon-draw-pen active" data-toolkit="Pencil"></div>
						<div class="icon-draw-marker" data-toolkit="Highlighter"></div>
						<div class="icon-draw-figure" data-toolkit="Line" data-toolkit2="figure">
							<div class="toolkit-subtools figure-palette clearfix">
								<span data-toolkit="Rectangle"></span>
								<span data-toolkit="Circle"></span>
								<span data-toolkit="Triangle"></span>
								<span data-toolkit="Pentagon"></span>
								<span data-toolkit="Star"></span>
								<span data-toolkit="Diamond"></span>
								<span data-toolkit="Line"></span>
								<span data-toolkit="TwoLines"></span>
							</div>
						</div>
						<div class="icon-draw-text" data-toolkit="Text" data-toolkit2="text">
							<div class="toolkit-subtools text-palette">
								<span class="icon-draw-text active" data-toolkit2="textSize" data-tsize="10"></span>
								<span class="icon-draw-text" data-toolkit2="textSize" data-tsize="20"></span>
								<span class="icon-draw-text" data-toolkit2="textSize" data-tsize="30"></span>
								<span class="icon-draw-text" data-toolkit2="textSize" data-tsize="45"></span>
								<span class="icon-draw-text" data-toolkit2="textSize" data-tsize="60"></span>
							</div>
						</div>
						<div class="icon-draw-eraser" data-toolkit="Eraser" data-toolkit2="eraser">
							<div class="toolkit-subtools eraser-palette">
								<div class="icon-draw-eraser-all fs2" data-toolkit2="eraseAll">
				                	<span class="path1"></span><span class="path2"></span>
				                	<span class="path3"></span><span class="path4"></span>
				                	<span class="path5"></span><span class="path6"></span>
				                	<span class="path7"></span>
				                </div>
							</div>
						</div>
						<div class="icon-draw-size" data-toolkit2="zoom">
							<div class="toolkit-subtools zoom-palette">
								<span class="icon-draw-size-plus" data-toolkit2="zoomIn"></span>
								<span class="icon-draw-size-minus" data-toolkit2="zoomOut"></span>
								<span class="icon-draw-size-fit fs3 active" data-toolkit2="zoomFit"></span>
								<span class="icon-draw-size-100 fs3" data-toolkit2="zoomOri"></span>
							</div>
						</div>
						<div class="icon-draw-hand" data-toolkit="Move"></div>
						<div class="room-doc-palette-line"></div>
						<div class="icon-draw-color" data-toolkit2="color">
							<div class="color-wrapper"><span class="color" style="background-color: rgb(0, 96, 255);"></span></div>
							<div class="toolkit-subtools color-palette"><span data-color="#FF0000" style="background-color:#FF0000"></span><span data-color="#FF9C00" style="background-color:#FF9C00"></span><span data-color="#FFF200" style="background-color:#FFF200"></span><span data-color="#00A651" style="background-color:#00A651"></span><span data-color="#0060FF" style="background-color:#0060FF"></span><span data-color="#2E3192" style="background-color:#2E3192"></span><span data-color="#EC008C" style="background-color:#EC008C"></span><span data-color="#FFFFFF" style="background-color:#FFFFFF"></span><span data-color="#000000" style="background-color:#000000"></span></div>
							<script>
							(function(){
								var src = [];
								'#FF0000,#FF9C00,#FFF200,#00A651,#0060FF,#2E3192,#EC008C,#FFFFFF,#000000'.split(',').forEach(function(color){
									src.push('<span data-color="#color#" style="background-color:#color#"></span>'.replace(/#color#/g, color.trim()));
								});
								$('.toolkit-subtools.color-palette').html(src.join(''));
							}());
							</script>
						</div>
						<div class="icon-draw-thickness" data-toolkit2="strokeWidth">
							<div class="grm-input-range toolkit-subtools stroke-width-palette" data-toolkit2="strokeWidthRange clearfix">
								<span class="grm-input-range-desc icon-draw-size-minus" data-btn-range="minus"></span>
								<span class="range-drag-rec">
									<input type="range" min="1" max="70">
								</span>
								<span class="grm-input-range-desc icon-draw-size-plus" data-btn-range="plus"></span>
							</div>
						</div>
					</div>
					<div class="room-doc-palette-v2">
						<div class="icon-draw-select" data-toolkit="select"></div>
						<div class="icon-draw-pointer" data-toolkit="laserpointer"></div>
						<div class="icon-draw-pen active" data-toolkit="pencil"></div>
						<div class="icon-draw-marker" data-toolkit="highlighter"></div>
						<div class="icon-draw-text" data-toolkit="textbox"></div>
						<div class="icon-draw" data-toolkit="link"></div>
						<div class="icon-draw-eraser" data-toolkit="eraser" data-toolkit2="eraser">
							<div class="toolkit-subtools eraser-palette">
								<div class="icon-draw-eraser-all fs2" data-toolkit2="eraseAll">
				                	<span class="path1"></span><span class="path2"></span>
				                	<span class="path3"></span><span class="path4"></span>
				                	<span class="path5"></span><span class="path6"></span>
				                	<span class="path7"></span>
				                </div>
							</div>
						</div>
						<div class="icon-draw-size" data-toolkit2="zoom">
							<div class="toolkit-subtools zoom-palette">
								<span class="icon-draw-size-plus" data-toolkit2="zoomIn"></span>
								<span class="icon-draw-size-minus" data-toolkit2="zoomOut"></span>
								<span class="icon-draw-size-fit fs3 active" data-toolkit2="zoomFit"></span>
								<span class="icon-draw-size-100 fs3" data-toolkit2="zoomOri"></span>
							</div>
						</div>
						<div class="icon-draw-hand" data-toolkit="move"></div>
						<div class="room-doc-palette-line"></div>
						<div class="icon-draw-color" data-toolkit2="color">
							<div class="color-wrapper"><span class="color"></span></div>
							<div class="toolkit-subtools color-palette"><span data-color="#FF0000" style="background-color:#FF0000"></span><span data-color="#FF9C00" style="background-color:#FF9C00"></span><span data-color="#FFF200" style="background-color:#FFF200"></span><span data-color="#00A651" style="background-color:#00A651"></span><span data-color="#0060FF" style="background-color:#0060FF"></span><span data-color="#2E3192" style="background-color:#2E3192"></span><span data-color="#EC008C" style="background-color:#EC008C"></span><span data-color="#FFFFFF" style="background-color:#FFFFFF"></span><span data-color="#000000" style="background-color:#000000"></span></div>
							<script>
							(function(){
								var src = [];
								'#FF0000,#FF9C00,#FFF200,#00A651,#0060FF,#2E3192,#EC008C,#FFFFFF,#000000'.split(',').forEach(function(color){
									src.push('<span data-color="#color#" style="background-color:#color#"></span>'.replace(/#color#/g, color.trim()));
								});
								$('.toolkit-subtools.color-palette').html(src.join(''));
							}());
							</script>
						</div>
						<div class="icon-draw-thickness" data-toolkit2="strokeWidth">
							<div class="grm-input-range toolkit-subtools stroke-width-palette" data-toolkit2="strokeWidthRange clearfix">
								<span class="grm-input-range-desc icon-draw-size-minus" data-btn-range="minus"></span>
								<span class="range-drag-rec">
									<input type="range" min="1" max="70">
								</span>
								<span class="grm-input-range-desc icon-draw-size-plus" data-btn-range="plus"></span>
							</div>
						</div>
					</div>

					<!-- 참여자 권한 시 확대/축소 버튼 -->
					<div class="roleDrawFalseZoomBtn">
						<span class="icon-draw-size-plus" data-toolkit2="zoomIn"></span>
						<span class="icon-draw-size-minus" data-toolkit2="zoomOut"></span>
						<span class="icon-draw-size-fit fs3 active" data-toolkit2="zoomFit"></span>
					</div>
				</div>

				<div class="popupLayerContainer docDownload" data-status="select" style="/*display:flex;*/">
					<div class="popupLayer docDownloadLayer">
						<div class="downloadSelect">
							<header class="popupLayerHeader noBorderType">
								<h4 class="popupLayerHeaderTitle">자료 다운로드</h4>
								<button class="clsBtn"></button>
							</header>
							<section class="popupLayerSec noFooter downloadGuide">
								<p class="popupLayerSecTx">다운로드 형태를 선택해주세요.</p>
								<div class="floatBtnRec clearfix">
									<button class="floatBtn half includeImg def" btn-type="original">원본 다운로드</button>
									<button class="floatBtn half includeImg draw" btn-type="with-drawing">판서 포함 다운로드</button>
								</div>
							</section>
						</div>
						<div class="downloadLoading">
							<header class="popupLayerHeader noBorderType">
								<h4 class="popupLayerHeaderTitle">자료 다운로드</h4>
							</header>
							<section class="popupLayerSec noFooter">
								<p class="popupLayerSecTx multiLine">
									다운로드중입니다.<br>잠시만 기다려 주세요.
								</p>
								<div class="docDownPercentBlock clearfix">
									<p class="percentNum"></p>
									<p class="percentTx">%</p>
								</div>
							</section>
						</div>
					</div>
				</div>
			</div> <!-- .room-doc -->

			

			<div class="room-mediashare" data-medialist-size="0" data-repeat="" data-play-state="pause">
				<div class="room-media-share-video">
					<div class="room-media-share-video-controls">
						<div class="controls-left">
							<div class="room-media-share-video-controls-btn play-btn"></div>
						</div>
						<div class="controls-center">
							<input type="range" class="media-timeRange" min="0" max="1000" value="0" step="1">
							<div class="play-time"></div>
							<div class="play-duration"></div>
						</div>
						<div class="controls-right">
							<div class="room-media-share-video-controls-btn play-volume"></div>
							<input type="range" class="media-volume" min="0" max="1" value="1" step="0.1">
						</div>
						
					</div>
					
					<!-- <video src="http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_50mb.mp4" autoplay="autoplay"></video> -->
					<video webkit-playsinline="" playsinline="" videoplay=""></video>
					<audio webkit-playsinline=""></audio>
					<div class="audioBgLayer">
						<svg class="editorial" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 24 150 28" preserveAspectRatio="none">
							<defs>
								<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z"></path>
							</defs>
							<g class="parallax">
								<use xlink:href="#gentle-wave" x="50" y="0" fill="#4579e2"></use>
								<use xlink:href="#gentle-wave" x="50" y="3" fill="#3461c1"></use>
								<use xlink:href="#gentle-wave" x="50" y="6" fill="#2d55aa"></use>  
							</g>
						</svg>
					</div>
					
					
					 <div class="noUploadFileLayer">
					 	<div class="noUploadFile">
						 	<p class="img"></p>
						 	<p class="title">아직 파일을 업로드하지 않으셨군요</p>
						 	<p class="tx">미디어 파일을 업로드해주세요</p>
							<p class="tx">[지원 형식]</p>
							<p class="tx">mp3, mp4(H.264), WebM(VP8, VP9), ogg</p>
						 	<button class="uploadBtn">파일 업로드</button>
					 	</div>
					 </div>
				</div>
				<div class="room-mediashare-remote" data-listshow="true">
					<div class="add-mediashare-source">
						<p class="titleRec"></p>
						<button class="btn-add-mediashare-source">
							<span class="icon-global-menu"></span>
						</button>
					</div>
					<div class="mediashare-source-list">
						<header>
							<h4>미디어 목록</h4>
							<button class="codecInfoBtn" data-tooltip-direction="right" title="코덱정보"></button>
							<button class="repeatBtn" data-tooltip-direction="right" title="반복"></button>
							<button class="clsBtn" data-tooltip-direction="right" title="숨기기"></button>
						</header>
						<div class="addbtnRec">
							<p class="addBtn">파일 추가</p>
						</div>
						<ul data-sample="" style="display: none;">
							<li class="ellipsis">
								<span class="title"></span>
								<span class="fileInfo">01:03:04</span>
								<span class="btn-del"></span>
							</li>
							<li class="ellipsis" data-upload="progress">
								<span class="title"></span>
								<p class="progressRec"><span class="progressBar" style="width: 0%;"></span></p>
								<span class="btn-del"></span>
							</li>
							<!-- 
							<li class="ellipsis">Marvel's Captain America- Civil War - Trailer2.mp4</li>
							<li class="ellipsis">FROZEN - Let It Go Sing-along - Official Disney HD.mp4</li>
							<li class="ellipsis">Som Sabadell flashmob - BANCO SABADELL - YouTube (720p).mp4</li>
							<li class="ellipsis play">하나면하나지둘이겠느냐.mp4</li>
							-->
						</ul>
						<ul class="media-list">
						</ul>
					</div>
				</div>
				<div class="codec-info-box">
					<h5>[지원 형식]</h5>
					<p class="codec-list-tx">mp3, mp4(H.264), WebM(VP8, VP9), ogg</p>
				</div>
			</div> <!-- .room-mediashare -->

			<div class="room-webshare">
				<div class="room-webshare-top">
					<div class="webshare-nav">
						<button data-nav-btn="prev">◀</button>
						<button data-nav-btn="next">▶</button>
					</div>
					<div class="webshare-nav">
						<input type="text" class="inp-url" placeholder="URL 을 입력해주세요" value="daum.net">
						<button data-nav-btn="go">go</button>
					</div>
				</div>
				<div class="room-webshare-body">
					<iframe class="ifr-view" width="100%" height="90%"></iframe>
				</div>
			</div> <!-- .room-webshare -->

			<div class="room-right-side">
				<link rel="stylesheet" href="ref/room/css/chat-userlist/chat.css?_dm=202408191403">
				<div class="room-right-side-header">
					<nav class="room-right-side-nav">
						<ul>
							<li><button data-chat="" class="room-right-side-nav-btn tab-chat active" tabindex="3" aria-label="채팅 탭">채팅</button></li>
							<li>
								<button class="room-right-side-nav-btn tab-member" tabindex="3" aria-label="참여자 탭">
									참여자
									
										<span class="member-tab-user-count">1</span>
									
								</button>
							</li>
						</ul>
						<div class="room-right-side-nav-more">
							<button class="room-right-side-nav-more-btn" aria-label="더보기" tabindex="3"></button>
							<ul class="room-right-side-nav-more-pop">
								<li>
									<button class="btn-notify" tabindex="3" aria-label="공지사항 탭">
										<span>공지사항</span>
									</button>
								</li>
								<li>
									<button class="btn-file" tabindex="3" aria-label="파일 탭">
										<span>파일</span>
									</button>
								</li>
								<li>
									<button class="btn-record" tabindex="3" aria-label="녹화 탭">
										<span>녹화</span>
									</button>
								</li>
							</ul>
						</div>
					</nav>
				</div>
				<section class="chat-main" data-notice="false">
					<div class="chat-set">
						<button class="chgName chat-set-name" tabindex="3" aria-label="대화명 변경" style="visibility: visible;">
							<figure>
								<figcaption>대화명 변경</figcaption>
							</figure>
						</button>
						<figure class="chat-set-more">
							<button class="chat-set-more-btn" tabindex="3" aria-label="설정">
								<figcaption>설정</figcaption>
							</button>
							<ul class="chat-set-more-pop">
								<li>
									<button class="chat-set-more-pop-btn toggle-alert-status-msg active" tabindex="3" role="alert">
										<p>채팅 알림</p>
										<span>ON</span>
										<span>OFF</span>
									</button>
								</li>
								<li>
									<button class="chat-set-more-pop-btn toggle-system-alert-status-msg active" tabindex="3" role="alert">
										<p>시스템 메세지</p>
										<span>ON</span>
										<span>OFF</span>
									</button>
								</li>
								<li>
									<button class="chatSave" tabindex="3">
										<p>대화내용 저장</p>
									</button>
								</li>
							</ul>
						</figure>
					</div>
					<div class="room-chat-layer">
						<div class="chat-msg-wrap room-chat-body ps">
							<div class="room-chat-msg-list"></div>
						<div class="ps__rail-x" style="left: 0px; bottom: 0px;"><div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div></div><div class="ps__rail-y" style="top: 0px; right: 0px;"><div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 0px;"></div></div></div>
						<div class="chat-input-container">
							<div class="chat-input-wrap">
								<div class="chat-input-field">
									<div class="chat-input-top">
										<div class="chat-input">
											<button class="chat-input-select" tabindex="3">
												<span>전체</span>
											</button>
											<div class="chat-input-select-user-wrap">
												<button class="chat-input-select-user" tabindex="3">
													<span class="chat-input-select-user-name"></span>
												</button>
											</div>
											<div class="chat-input-select-container">
												<button class="chat-input-select-btn active" tabindex="3">전체</button>
												<button class="chat-input-select-btn whisper" tabindex="3">귓속말</button>
											</div>
										</div>
										
											<div class="chat-input-btn-wrap">
												<button class="chat-input-btn-file" aria-label="파일 첨부" tabindex="3">
													<label for="file-upload" class="file-upload"></label>
													<input id="file-upload" class="file-upload" type="file">
												</button>
													
											</div>
										
									</div>
									<form class="chat-input-form">
										<textarea class="room-chat-msg-inp" maxlength="3000" placeholder="채팅하려면 여기에 내용을 입력하세요" tabindex="3"></textarea>
										<button class="chat-input-btn-send" tabindex="-1"></button>
									</form>
								</div>
								<div class="whisper-wrap partnerSelect">
									<div class="whisper-top">
										<form class="user-search">
											<input type="text" placeholder="귓속말 대상을 입력해주세요" tabindex="-1">
										</form>
									</div>
									<ul class="whisper-bottom"></ul>
								</div>
								<div class="chat-new-message">
									<button type="button" tabindex="-1">새로운 메세지가 있습니다</button>
								</div>
							</div>
							<div class="chat-input-disable">
								참여자는 채팅을 사용하실 수 없습니다
							</div>
						</div>
						<div class="chat-drag-file" style="display: none;">
							<div class="chat-drag-file-icon"></div>
							<p class="chat-drag-file-tx">
								파일을 여기에 끌어다 놓으세요
							</p>
						</div>
					</div>
				</section>
				<section class="member room-user-list-layer">
					<div class="member-header">
						<article class="member-info">
							<div class="member-menu">
								<div class="member-sort-wrap">
									<button class="btn-sort" tabindex="3">정렬</button>
									<div class="popup-sort">
										<button class="btn-sort-connect active" tabindex="3">접속순</button>
										<button class="btn-sort-name" tabindex="3">이름순</button>
										<div style="display:none" id="sort-describe">선택됨</div>
									</div>
								</div>
								<div class="member-authority-wrap">
									<button class="btn-authority" tabindex="3">권한</button>
									<div class="room-device-control">
										<div>
											<button data-btn-dc="onCameraAll" class="" tabindex="3">전체 카메라 켜기</button>
											<button data-btn-dc="offCameraAll" class="" tabindex="3">전체 카메라 끄기</button>
											<button data-btn-dc="grantCameraRoleAll" class="" tabindex="3">전체 카메라 권한 주기</button>
											<button data-btn-dc="revokeCameraRoleAll" tabindex="3">전체 카메라 권한 뺏기</button>
										</div>
										<div>
											<button data-btn-dc="onMicAll" class="" tabindex="3">전체 마이크 켜기</button>
											<button data-btn-dc="offMicAll" class="" tabindex="3">전체 마이크 끄기</button>
											<button data-btn-dc="grantMicRoleAll" class="" tabindex="3">전체 마이크 권한 주기</button>
											<button data-btn-dc="revokeMicRoleAll" tabindex="3">전체 마이크 권한 뺏기</button>
										</div>
										<div style="display:none;">
											<button data-btn-dc="grantSpeakerRoleAll" tabindex="3">전체 스피커 권한 주기</button>
											<button data-btn-dc="revokeSpeakerRoleAll" tabindex="3">전체 스피커 권한 뺏기</button>
										</div>
										<div>
											<button data-btn-dc="grantDrawRoleAll" tabindex="3">전체 그리기 권한 주기</button>
											<button data-btn-dc="revokeDrawRoleAll" tabindex="3">전체 그리기 권한 뺏기</button>
										</div>
										<div>
											<button data-btn-dc="kickAll" tabindex="3">전체 강제 퇴장 기능</button>
										</div>
									</div>
								</div>
							</div>
							<div class="member-invite-wrap">
								<button class="btn-member-invite" tabindex="3">초대</button>
								<button class="btn-search" tabindex="3" aria-label="검색"></button>
							</div>
						</article>
						<article class="member-search">
							<form class="member-search-form">
								<input type="text" placeholder="이름 검색" tabindex="3">
								<div class="member-search-btn">
									<button class="btn-cancel" tabindex="3">취소</button>
								</div>
							</form>
						</article>
					</div>
					<div class="room-user-list-body ps">
						<ul class="room-user-list member-list-wrap"><li class="room-user me" draggable="true" data-device-type="pc" data-userid="lxuuftaq6zrgz" data-join-date="Sat Oct 05 2024 11:22:53 +0900" data-user-roleid="speaker" data-user-opener="true" data-role-camera="true" data-status-camera="off" data-role-mic="true" data-status-mic="off" data-role-speaker="true" data-status-speaker="off" data-role-draw="true">
				<div class="room-user-info-wrap">
					<div class="room-user-device"></div>
					<div class="room-user-nickname-layer">
						<button class="room-user-nickname" tabindex="3" title="[개설자][발표자]구루미">구루미</button>
						<span class="room-user-rights-tx">발표</span>
					</div>
				</div>
				<div class="room-user-btns">
					<button class="room-user-btn icon-global-camera" data-btn-type="camera" tabindex="3" aria-label="카메라"></button>
					<button class="room-user-btn icon-global-mic" data-btn-type="mic" tabindex="3" aria-label="마이크"></button>
					<button class="room-user-btn icon-volume-medium" data-btn-type="speaker" tabindex="3" aria-label="스피커"></button>
					<button class="room-user-btn icon-draw-pen" data-btn-type="draw" tabindex="3" aria-label="그리기"></button>
					<button class="room-user-btn icon-global-more" data-btn-type="more" tabindex="3" aria-label="더보기"></button>
				</div>
			</li></ul>
					<div class="ps__rail-x" style="left: 0px; bottom: 0px;"><div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div></div><div class="ps__rail-y" style="top: 0px; right: 0px;"><div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 0px;"></div></div></div>
					<div class="room-user-more-layer">
						<div class="userRoleRec">
							<div class="tabTrap" tabindex="3"></div>
							<button class="room-user-role active" data-roleid="speaker" tabindex="3">
								발표자
							</button>
							<button class="room-user-role" data-roleid="emcee" tabindex="3">
								진행자
							</button>
							<button class="room-user-role" data-roleid="participant" tabindex="3">
								참여자
							</button>
							<button class="room-user-kick" data-roleid="kick" tabindex="3">
								강제퇴장
							</button>
							<!-- <div class="icon-global-close btn-close" data-roleid="close"></div> -->
							<div class="tabTrap" tabindex="3"></div>
						</div>
						<div class="room-user-device-info" data-id="show"></div>
					</div>
				</section>
				<section class="notify">
					<header class="notify-top">
						<h2>공지사항</h2>
						<button class="notify-btn-back" tabindex="3" aria-label="돌아가기"></button>
					</header>
					<ul class="notify-bottom"></ul>
					<div class="tabTrap" tabindex="3"></div>
				</section>
				<section class="file">
					<header class="file-top">
						<h2>파일</h2>
						<button class="file-btn-back" tabindex="3" aria-label="돌아가기"></button>
					</header>
					<ul class="file-bottom">

					</ul>
					<div class="tabTrap" tabindex="3"></div>
				</section>
				<section class="record">
					<header class="record-top">
						<h2>녹화</h2>
						<button class="record-btn-back" tabindex="3" aria-label="돌아가기"></button>
					</header>
					<div class="record-bottom">
						<ul>

						</ul>
					</div>
					<div class="tabTrap" tabindex="3"></div>
				</section>
			</div>

			<div class="camstudy-info-layer" data-show="true" style="display: none;">
				<div class="camStudyInfoHeader">
					<h6 class="camStudyInfoTitle">캠스터디 정보</h6>
					<button class="camStudyInfoBtn"></button>
				</div>
				<div class="camStudyInfoContent">
					<div class="camstudy-info">
						<label>현재 시간</label>
						<p data-type="currentTime"></p>
					</div>
					<div class="camstudy-info">
						<label>남은 기간</label>
						<p data-type="remainDays"></p>
					</div>
					<!-- 
					<div class="camstudy-info">
						<label>목표 :</label>
						<span data-type="targetDayTime"></span>
					</div>
					-->
					<div class="camstudy-info">
						<label>누적학습</label>
						<p data-type="myTotalStudyTime"></p>
					</div>
					<div class="camstudy-info">
						<label>오늘학습</label>
						<p data-type="myTodayStudyTime"></p>
					</div>
				</div>
			</div>

			<!-- external addressbook  -->
			<div class="roomAddressRec" data-show="">
				<div class="roomAddressWrap">
					<div class="roomAddress" data-type="inviteList">
						<!-- menu tab -->

						<header class="roomAddressHeader">
							<button class="tab btn01" data-btn-tab="inviteList">초대목록</button>
							<button class="tab btn02" data-btn-tab="addressBook">주소록</button>
						</header>
						<!-- invite list -->
						<section class="address-tab inviteList">
							<h3 class="title">이번 화상IR에 초대된 참여자의 참석여부를 알 수 있습니다!</h3>
							<ul>
								<li class="lastNameBtnRec">
									<button data-ad-nametab="all" class="selected">전체</button>
									<button data-ad-nametab="ㄱ">가</button>
									<button data-ad-nametab="ㄴ">나</button>
									<button data-ad-nametab="ㄷ">다</button>
									<button data-ad-nametab="ㄹ">라</button>
									<button data-ad-nametab="ㅁ">마</button>
									<button data-ad-nametab="ㅂ">바</button>
									<button data-ad-nametab="ㅅ">사</button>
									<button data-ad-nametab="지">아</button>
									<button data-ad-nametab="ㅈ">자</button>
									<button data-ad-nametab="ㅊ">차</button>
									<button data-ad-nametab="ㅋ">카</button>
									<button data-ad-nametab="ㅌ">타</button>
									<button data-ad-nametab="ㅍ">파</button>
									<button data-ad-nametab="ㅎ">하</button>
									<button data-ad-nametab="A" class="en">A-Z</button>
									<button data-ad-nametab="0" class="en">0-9</button>
								</li>
								<li class="searchRec">
									<button class="alignBtn">이름순</button>
									<!-- <button class="alignBtn">등록순</button> -->
									<div class="searchBoxRec">
										<select class="selectBox s-type">
											<option value="name">이름</option>
											<option value="company">회사</option>
											<option value="job">직군</option>
											<option value="email">이메일</option>
										</select>
										<input type="text" class="s-words" placeholder="검색어를 입력하세요" maxlength="200">
									</div>
								</li>
								<li class="tableRec">
									<table class="tableStyle01">
										<caption>정보입력</caption>
										<thead>
											<tr>
												<th class="col-xs-4 txC btn-address-select" data-sel-type="all"><input type="checkbox"></th>
												<th class="col-xs-16">이름</th>
												<th class="col-xs-20">회사</th>
												<th class="col-xs-20">직군</th>
												<th class="col-xs-30">이메일</th>
												<th class="col-xs-10 txC">참여</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td class="col-xs-4 txC btn-address-select"><input type="checkbox"></td>
												<td class="col-xs-16" data-v="name"></td>
												<td class="col-xs-20" data-v="company"></td>
												<td class="col-xs-20" data-v="job"></td>
												<td class="col-xs-30 email" data-v="email"></td>
												<td class="col-xs-10 txC" data-v-joined=""></td>
											</tr>
										</tbody>
									</table>
								</li>
								<li class="etcBtnRec">
									<div class="pagingBtnRec" style="display:none;">
										<button class="leftBtn"></button>
										<button class="selected">1</button>
										<button>2</button>
										<button class="rightBtn"></button>
									</div>
									<button class="inviteBtn">초대하기</button>
								</li>
							</ul>
						</section>
						<!-- address book -->
						<section class="address-tab addressBook">
							<ul>
								<li class="lastNameBtnRec">
									<button data-ad-nametab="all" class="selected">전체</button>
									<button data-ad-nametab="ㄱ">가</button>
									<button data-ad-nametab="ㄴ">나</button>
									<button data-ad-nametab="ㄷ">다</button>
									<button data-ad-nametab="ㄹ">라</button>
									<button data-ad-nametab="ㅁ">마</button>
									<button data-ad-nametab="ㅂ">바</button>
									<button data-ad-nametab="ㅅ">사</button>
									<button data-ad-nametab="ㅇ">아</button>
									<button data-ad-nametab="ㅈ">자</button>
									<button data-ad-nametab="ㅊ">차</button>
									<button data-ad-nametab="ㅋ">카</button>
									<button data-ad-nametab="ㅌ">타</button>
									<button data-ad-nametab="ㅍ">파</button>
									<button data-ad-nametab="ㅎ">하</button>
									<button data-ad-nametab="A" class="en">A-Z</button>
									<button data-ad-nametab="0" class="en">0-9</button>
								</li>
								<li class="searchRec">
									<button class="alignBtn">이름순</button>
									<!-- <button class="alignBtn">등록순</button> -->
									<div class="searchBoxRec">
										<select class="selectBox s-type">
											<option value="name">이름</option>
											<option value="company">회사</option>
											<option value="job">직군</option>
											<option value="email">이메일</option>
										</select>
										<input type="text" class="s-words" placeholder="검색어를 입력하세요" maxlength="200">
									</div>
								</li>
								<li class="tableRec">
									<table class="tableStyle01">
										<caption>정보입력</caption>
										<thead>
											<tr>
												<th class="col-xs-4 txC btn-address-select" data-sel-type="all"><input type="checkbox"></th>
												<th class="col-xs-16">이름</th>
												<th class="col-xs-20">회사</th>
												<th class="col-xs-20">직군</th>
												<th class="col-xs-30">이메일</th>
												<th class="col-xs-10 txC">참여</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td class="col-xs-4 txC btn-address-select"><input type="checkbox"></td>
												<td class="col-xs-16" data-v="name"></td>
												<td class="col-xs-20" data-v="company"></td>
												<td class="col-xs-20" data-v="job"></td>
												<td class="col-xs-30 email" data-v="email"></td>
												<td class="col-xs-10 txC" data-v-joined=""></td>
											</tr>
										</tbody>
									</table>
								</li>
								<li class="etcBtnRec">
									<div class="pagingBtnRec" style="display:none;">
										<button class="leftBtn"></button>
										<button class="selected">1</button>
										<button>2</button>
										<button class="rightBtn"></button>
									</div>
									<button class="inviteBtn">초대하기</button>
								</li>
							</ul>
						</section>
					</div>
					<button class="clsBtn"></button>
				</div>
			</div>
			
			<!-- TODO TEST -->
			<div class="room-qna-layer" data-type="list">
				<div class="room-qna-wrapper">
					<header class="room-qna-header">
						<h6>질의응답</h6>
					</header>
					<section class="room-qna-content">
						<div class="qna-menu">
							<button class="qna-menu-btn menu-btn-list selected" data-type="list">목록</button>
							<button class="qna-menu-btn menu-btn-form" data-type="form">질문하기</button>
						</div>
						<div class="qna-list">
							<ol class="sample" style="display: none;">
								<li class="qna-item">
									<div class="qna-item-wrapper">
										<div class="qna-q"></div>
										<div class="qna-content">
											<div class="qna-nickname"></div>
											<div class="qna-text"></div>
										</div>
									</div>
									<div class="btn-qna-item-remove"></div>
								</li>
							</ol>
							<div class="qna-list-wrapper">
								<div class="qna-list-empty">
									등록된 질문이 없습니다.
								</div>
								<div class="qna-item-list-wrap" style="display: none;">
									<ol class="qna-item-list"></ol>
								</div>
							</div>
						</div>
						<label class="chk-my-qna">
							<input type="checkbox" disabled="disabled"><span>내 질문만 보기</span>
						</label>
						<div class="qna-form">
							<div class="qna-form-wrapper">
								<div class="qna-form-header">
									<div class="qna-form-title">질문할 내용을 입력해 주세요</div>
									<div class="qna-form-len-layer">(<span class="qna-form-text-len">0</span> / 100)</div>
								</div>
								<div class="qna-form-body">
									<textarea placeholder="내용을 입력해 주세요 (최대 100자)" maxlength="100"></textarea>
								</div>
								<div class="qna-form-footer">
									질문 등록하기
								</div>
							</div>
						</div>
					</section>
					<div class="qna-list-btn-wrap">
						<button class="btn-qna-list-save">
							질문 내려받기
						</button>
					</div>
					<div class="qna-close-wrap">
						<button class="btn-qna-close"></button>	
					</div>
				</div>
			</div>

			<!-- toastRec -->
			<div class="toastRec" data-type="">
				<div class="lowNetworkMsg toast">
					<span class="icoLowNetwork"></span>
					<span class="msg txLevel01">네트워크 상황이 좋지 않아 영상 품질을 조절합니다</span>
					<span class="msg txLevel02">네트워크 상황이 좋지 않아 음성 통화만 유지합니다</span>
				</div>
			</div>

			<!-- pip -->
			<div class="pipRec" data-pip-video-layer="">
				<div class="room-video-pip-layer">
					<div class="video-pip-start-wrap">
						<button class="video-pip-start-btn"></button>
						<em class="video-pip-start-tx">새 창으로 보기</em>
					</div>
					<div class="video-pip-proceeding-wrap">
						<em class="video-pip-proceeding-tx">새 창에서 비디오 재생중입니다.</em>
						<button class="video-pip-exit-btn">새 창으로 보기 종료</button>
					</div>
				</div>
				<video data-pip-video="" autoplay="autoplay" playsinline="" style="filter: none; width: 100%; height: 100%;"></video>
				<div class="video-cover">
					<div class="user-device-status">
						<span data-device-type="mic"></span>
						<span data-device-type="speaker"></span>
						<span data-device-type="camera"></span>
					</div>
				</div>
			</div>

			<!-- waitingUser list -->
			<div class="popup-type-table waiting-user-list" style="display: none;">
				<div class="popup-header">
					<h1>대기자 리스트</h1>
					<div class="popup-cls-btn-wrap">
						<button class="popup-cls-btn" data-btn="close"></button>
					</div>
				</div>
				<div class="popup-body">
					<div data-tab="userlist" class="userlist">
						<ul class="user-list-header">
							<li class="list-view-type">
								<div data-user="usernum" class="header-item number">번호</div>
								<div data-user="username" class="header-item user-name">이름</div>
								<div data-user="joinDateTime" class="header-item enter-time">입장 요청 시간</div>
								<div data-user="totalStudyTime" class="header-item device-cam">카메라</div>
								<div data-user="totalStudyTime" class="header-item device-mic">마이크</div>
								<div data-user="userRole" class="header-item user-role">입장권한</div>
								<div data-user="email" class="header-item request-enter">입장요청</div>
							</li>
						</ul>
						<ol class="user-list-body">
							<li class="list-view-type tbody sample" data-camera-status="" data-mic-status="" style="display: none;">
								<div data-user="usernum" class="list-body-item number"></div>
								<div data-user="username" class="list-body-item user-name"></div>
								<div data-user="joinDateTime" class="list-body-item enter-time"></div>
								<div data-user="totalStudyTime" class="list-body-item device-cam success"><p style="color: blue;">정상</p></div>
								<div data-user="totalStudyTime" class="list-body-item device-cam error"><p style="color: red;">오류</p></div>
								<div data-user="totalStudyTime" class="list-body-item device-mic success"><p style="color: blue;">정상</p></div>
								<div data-user="totalStudyTime" class="list-body-item device-mic error"><p style="color: red;">오류</p></div>
								<div data-user="userRole" class="list-body-item user-role">
									<select class="interview-join-role">
										<option value="participant">참여자</option>
										<option value="emcee">진행자</option>
									</select>
								</div>
								
								<div data-user="email" class="list-body-item request-enter">
									<button type="button" class="enter-btn">수락</button>
									<button type="button" class="remove-btn">거부</button>
								</div>
							</li>
						</ol>
					</div>
					<div data-tab="userlist-mobile" class="userlist-mobile">
						<ol class="user-list-body">
							<li class="list-view-type tbody sample" style="display: none;">
								<div class="list-body-item-wrap-mobile">
									<em class="list-body-item-head-mobile">번호</em>
									<p data-user="usernum" class="list-body-item number"></p>
								</div>
								<div class="list-body-item-wrap-mobile">
									<em class="list-body-item-head-mobile">이름</em>
									<p data-user="username" class="list-body-item user-name"></p>
								</div>
								<div class="list-body-item-wrap-mobile">
									<em class="list-body-item-head-mobile">입장 요청 시간</em>
									<p data-user="joinDateTime" class="list-body-item enter-time"></p>
								</div>
								<div class="list-body-item-wrap-mobile">
									<em class="list-body-item-head-mobile">입장권한</em>
									<div data-user="userRole" class="list-body-item user-role">
										<select class="interview-join-role">
											<option value="participant">참여자</option>
											<option value="emcee">진행자</option>
										</select>
									</div>
								</div>
								<div class="list-body-item-wrap-mobile">
									<em class="list-body-item-head-mobile">입장요청</em>
									
									<div data-user="email" class="list-body-item request-enter">
										<button type="button" class="enter-btn">수락</button>
									</div>
								</div>
								<div class="list-body-item-wrap-mobile">
									<em class="list-body-item-head-mobile">입장거부</em>
									<div data-user="" class="list-body-item request-remove">
										<button type="button" class="remove-btn">거부</button>
									</div>
								</div>
							</li>
						</ol>
					</div>
				</div>
			</div>
		</div>
		<!-- .room-main -->
	</div>
	<!-- .room-wrapper -->
	
	<!-- Guide S -->
	<div class="room-guide-layer guide-device" style="display: none;">
		<div class="room-guide-bg"></div>
		<div class="room-guide-container">
			<div class="room-guide-device-pc">
				<div class="room-guide-device-pc-arrow"></div>
				<div class="room-guide-device-pc-text">장치 사용을 허용해 주세요</div>
			</div>
			<div class="room-guide-device-mobile">
				<div class="room-guide-device-mobile-arrow"></div>
				<div class="room-guide-device-mobile-text">장치 사용을 허용해 주세요</div>
			</div>
		</div>
	</div>
	<div class="room-guide-layer guide-use">
		<div class="room-guide-bg"></div>
		<div class="room-guide-container">
			<div class="room-guide room-guide-menu-info">
				<span>방정보 설정</span>
			</div>
			<div class="room-guide room-guide-menu-001">
				<span>영상통화</span>
			</div>
			<div class="room-guide room-guide-menu-002">
				<span>화면공유</span>
			</div>
			<div class="room-guide room-guide-menu-003">
				<span>문서공유</span>
			</div>
			<div class="room-guide room-guide-menu-exit">
				<span>나가기</span>
			</div>
			
			<div class="room-guide-menu-tool-layer">
				<div class="room-guide-menu-tool-arrow">
				</div>
				<div class="room-guide-menu-tool-text">장치제어 및 부가기능</div>
			</div>
			<div class="room-guide room-guide-menu-004">
				<div class="room-guide-menu-tool-line">
				</div>
				<div class="room-guide-menu-tool-text">초대</div>
			</div>
			<div class="room-guide room-guide-menu-005">
				<div class="room-guide-menu-tool-line2X">
				</div>
				<div class="room-guide-menu-tool-text">채팅 및 <br>참여자 목록</div>
			</div>
			
			<div class="room-guide-close">
				<div class="room-guide-close-txt">
					<input type="checkbox" id="_rgc_">
					<label for="_rgc_">두번 다시 안볼래요</label>
				</div>
				<div class="room-guide-btn">
					<span class="room-guide-close-btn-txt">닫기</span>
					<!-- <img src="images/room/btn/btn_close_white_30.png" /> -->
				</div>
			</div>
		</div>
	</div>
	<!-- Guide E -->
	
	<!-- Feedback S -->
	<div class="grm-dialog-msg-layer feedback-layer">
		<div class="grm-dialog-top">
			<h4 class="grm-dialog-title">Feedback</h4>
			<div class="desc">
				소중한 의견 진심으로 감사 드립니다.<br>더 좋은 서비스를 위해 반영하도록 하겠습니다.
			</div>
		</div>
		<div class="grm-dialog-body">
			<div class="feedback-form">
				<label>
					평점
				</label>
				<div>
					<div class="room-feedback-grade" data-grade="true"></div>
					<div class="room-feedback-grade" data-grade="true"></div>
					<div class="room-feedback-grade" data-grade="true"></div>
					<div class="room-feedback-grade" data-grade="true"></div>
					<div class="room-feedback-grade" data-grade="true"></div>
				</div>
			</div>
			<div class="feedback-form">
				<label>
					이메일
				</label>
				<div>
					<input type="email" data-inp="email" maxlength="100" autocomplete="email">
				</div>
			</div>
			<div class="feedback-form">
				<label>
					의견
				</label>
				<div>
					<textarea data-inp="msg" maxlength="1000"></textarea>
				</div>
			</div>
		</div>
		<div class="grm-dialog-footer">
			<button class="grm-btn cancel">취소</button>
			<button class="grm-btn ok">전송</button>
		</div>
	</div>
	<!-- Feedback E -->
</div>

<!-- JavaScript for handling video and audio -->
<script>
    let localStream;
    const localVideo = document.getElementById('localVideo');
    const muteButton = document.getElementById('muteButton');
    const cameraButton = document.getElementById('cameraButton');
    const leaveButton = document.getElementById('leaveButton');

    // Get media stream (video & audio) from the user's device
    async function startConference() {
        try {
            localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
            localVideo.srcObject = localStream;
        } catch (error) {
            console.error('Error accessing media devices.', error);
            alert('카메라와 마이크에 접근할 수 없습니다. 브라우저 설정을 확인하세요.');
        }
    }

    // Toggle mute/unmute for the microphone
    muteButton.addEventListener('click', () => {
        const audioTracks = localStream.getAudioTracks();
        if (audioTracks.length > 0) {
            audioTracks[0].enabled = !audioTracks[0].enabled;
            muteButton.textContent = audioTracks[0].enabled ? '마이크 끄기' : '마이크 켜기';
        }
    });

    // Toggle on/off for the camera
    cameraButton.addEventListener('click', () => {
        const videoTracks = localStream.getVideoTracks();
        if (videoTracks.length > 0) {
            videoTracks[0].enabled = !videoTracks[0].enabled;
            cameraButton.textContent = videoTracks[0].enabled ? '카메라 끄기' : '카메라 켜기';
        }
    });

    // Leave the conference and stop all media streams
    leaveButton.addEventListener('click', () => {
        if (localStream) {
            localStream.getTracks().forEach(track => track.stop());
        }
        window.location.href = '/leaveRoom'; // Redirect to leave room
    });

    // Start the conference when the page is loaded
    window.onload = startConference;
</script>
