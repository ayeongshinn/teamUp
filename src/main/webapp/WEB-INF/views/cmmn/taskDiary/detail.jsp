<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script type="text/javascript">

</script>

</head>
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

/* 제목과 등록일을 가로로 배치 */
.title-wrapper {
	display: flex;
	justify-content: space-between; /* 양쪽에 배치 */
	align-items: center;
	margin-bottom: 1rem;
	border-bottom: 2px solid #e5e7eb; /* 밑줄 추가 */
	padding-bottom: 0.5rem;
}

.title {
	font-size: 1.25rem; /* 제목을 크게 */
	font-weight: bold;
	color: #1f2937; /* 다크 그레이 */
	margin: 0;
}

.title-wrapper .date {
	font-size: 0.875rem; /* 날짜는 작게 */
	color: #6b7280; /* 중간 회색 */
}

#diaryCn {
	resize: none;
	overflow-y: auto;
	height: 400px;
	width: 100%;
}

.icons {
	margin-top: 10px;
	display: flex;
	align-items: center;
}

.icons svg {
	cursor: pointer;
	transition: color 0.2s ease;
}

.icons svg:hover {
	color: #4b5563; /* 아이콘 호버 시 색상 변경 */
}

.text-sm {
	font-size: 0.875rem; /* 작은 텍스트 크기 */
}

.flex {
	display: flex;
}

.justify-end {
	justify-content: flex-end;
}

#category {
	color: #4E7DF4;
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
</style>
</head>
<body>
	<div class="py-12">
		<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
			<div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
				<div class="p-14 bg-white border-b border-gray-200">
					<div class="pb-2 text-sm flex justify-between items-center">
						<a id="category" href="/taskDiary/list" class="text-md">업무 일지</a>
					</div>
					<!-- 제목과 등록일을 한 줄에 배치 -->
					<div class="title-wrapper">
						<h3 class="title font-semibold">${taskDiaryVO.diaryTtl}</h3>
						<!-- 글 제목 -->
						<span class="date" class="text-md"> <fmt:formatDate
								value="${taskDiaryVO.regDt}" pattern="yyyy.MM.dd" />
						</span>
						<!-- 등록일 -->
					</div>

					<div
						class="text-sm text-gray-600 mb-4 flex justify-start items-center">
						<span class="font-semibold text-md mr-4">작성자 : <span
							class="font-normal">${taskDiaryVO.empNm}</span></span> <span
							class="font-semibold text-md mr-4">부서명 : <span
							class="font-normal">${taskDiaryVO.deptNm}</span></span> <span
							class="font-semibold text-md">직&nbsp;&nbsp;급 : <span
							class="font-normal">${taskDiaryVO.jbgdNm}</span></span>
					</div>
					<br>

					<div class="mb-8">
						<div id="diaryCn" name="diaryCn">${taskDiaryVO.diaryCn}</div>
					</div>
					<hr>
				




				</div>
			</div>
		</div>
	</div>
</body>
</html>