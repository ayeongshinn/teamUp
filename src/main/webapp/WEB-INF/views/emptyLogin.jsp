<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>
<script src="https://cdn.tailwindcss.com"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<link rel="stylesheet" href="https://horizon-tailwind-react-corporate-7s21b54hb-horizon-ui.vercel.app/static/css/main.d7f96858.css" />
<script src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		//경영진
		$("#240001").on("click", function() {
			$("#username").val("240001");
			$("#password").val("0000");
		})
		
		//기획부 팀장
		$("#200001").on("click", function() {
			$("#username").val("200001");
			$("#password").val("0000");
		})
		
		//기획부 사원
		$("#220001").on("click", function() {
			$("#username").val("220001");
			$("#password").val("0000");
		})
		
		//영업부
		$("#240003").on("click", function() {
			$("#username").val("240003");
			$("#password").val("0000");
		})
		
		//관리부
		$("#240005").on("click", function() {
			$("#username").val("240005");
			$("#password").val("0000");
		})
		
		//인사부
		$("#240002").on("click", function() {
			$("#username").val("240002");
			$("#password").val("0000");
		})
		
		//경영 이사
		$("#240007").on("click", function() {
			$("#username").val("240007");
			$("#password").val("0000");
		})
		
		//경영 이사
		$("#230003").on("click", function() {
			$("#username").val("230003");
			$("#password").val("0000");
		})
	})
</script>
<style>
	.button-container {
        position: absolute;
        right: 20px;
        bottom: 20px;
        display: flex;
        flex-direction: column;
        gap: 10px; /* 버튼 사이의 간격 */
    }
    
    .shortcut {
    	cursor: pointer;
    }
    
</style>
</head>
<body style="min-height: 100vh; display: flex; justify-content: center; align-items: center;">
    <div class="login-container w-[800px]">
        <tiles:insertAttribute name="body" />
    </div>
    <div class="button-container">
        <button value="경영" id="240001" class="bg-white text-gray-400 text-sm shadow-sm w-10 h-10 rounded-full shortcut">경영</button>
        <button value="기획팀장" id="200001" class="bg-white text-gray-400 text-xs shadow-sm w-10 h-10 rounded-full shortcut">기획<br>팀장</button>
        <button value="기획사원" id="220001" class="bg-white text-gray-400 text-xs shadow-sm w-10 h-10 rounded-full shortcut">기획<br>사원</button>
        <button value="영업" id="240003" class="bg-white text-gray-400 text-sm shadow-sm w-10 h-10 rounded-full shortcut">영업</button>
        <button value="관리" id="240005" class="bg-white text-gray-400 text-sm shadow-sm w-10 h-10 rounded-full shortcut">관리</button>
        <button value="인사" id="240002" class="bg-white text-gray-400 text-sm shadow-sm w-10 h-10 rounded-full shortcut">인사</button>
        <button value="인사사원" id="230003" class="bg-white text-gray-400 text-xs shadow-sm w-10 h-10 rounded-full shortcut">인사<br>사원</button>
        <button value="경영이사" id="240007" class="bg-white text-gray-400 text-xs shadow-sm w-10 h-10 rounded-full shortcut">경영<br>이사</button>
    </div>
</body>
</html>