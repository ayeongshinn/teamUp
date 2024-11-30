<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- Include jQuery -->
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

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
<h1>화상회의 - 방 ID: ${room.roomId}</h1>

<div class="conference-container">
    <div id="videoContainer" class="video-section">
        <video id="localVideo" autoplay playsinline></video>
    </div>

    <div class="chat-section">
        <div class="chat-box">
            <div class="chat-messages" id="chatMessages">
                <!-- 여기에 채팅 메시지들이 들어감 -->
            </div>
            <div class="chat-input">
                <input type="text" id="chatInput" placeholder="메시지를 입력하세요..." />
                <button id="sendButton">보내기</button>
            </div>
        </div>
    </div>
</div>

<div id="controls">
    <button id="muteButton">마이크 끄기</button>
    <button id="cameraButton">카메라 끄기</button>
    <button id="leaveButton">회의 나가기</button>
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
