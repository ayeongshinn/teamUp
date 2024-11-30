<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<!DOCTYPE html>
<html>
<head>

<!-- 토큰 -->
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<!-- chart.js 설치 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- SweetAlert2 라이브러리 로드 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>


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
   
.modal {
    display: flex;
    justify-content: center; /* 수평 중앙 정렬 */
    align-items: center;     /* 수직 중앙 정렬 */
    position: fixed;
    z-index: 10;
    inset: 0;
    overflow-y: auto;
    min-height: 100vh; /* 화면 높이만큼 중앙 정렬 */
    background-color: rgba(0, 0, 0, 0.5); /* 회색 반투명 배경 유지 */
}

.modal-content {
    position: relative;
    background-color: white;
    padding: 30px;
    border-radius: 10px;
    max-width: 600px; /* 모달의 최대 너비 설정 */
    width: 100%;      /* 화면 크기에 맞게 조정 */
    margin: auto;     /* 중앙으로 정렬 */
    margin-left: 40%; /* 오른쪽으로 50px 만큼 이동 */
}

/* 필요시 모달을 화면 상단에 배치하는 방법 */
.modal-content-top {
    margin-top: 6%;
}

/* 회색 배경을 유지하면서 모달만 이동 */
.modal-background {
    background-color: rgba(0, 0, 0, 0.5); /* 회색 배경 유지 */
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

<script type="text/javascript">
	// 토큰
	const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
	const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

</script>

<script>

//DOMContentLoaded 이벤트를 사용하여 DOM이 완전히 로드된 후 차트를 생성
document.addEventListener('DOMContentLoaded', function() {
	
    $.ajax({
        type: "GET",
        url: "/businessProgress/chartData",  // 데이터를 가져오는 API
        dataType: "json",
        success: function(data) {
            const labels = data.map(item => item.bsnNm);  // 거래처명
            const progressValues = data.map(item => item.bsnProgrs);  // 진행도 값

            // 데이터에 맞춰 Chart.js를 업데이트하는 함수 호출
            updateChart(labels, progressValues);
        },
        error: function(xhr, status, error) {
            console.error("데이터 로드 오류:", error);
        }
    });
	
    function updateChart(labels, dataValues) {
		
    	const ctx = document.querySelector('#businessChart');
	    
    	// 현재 월을 구하는 함수
	    function getCurrentMonth() {
	        const today = new Date();
	        const month = today.getMonth() + 1;  // 월을 0부터 계산하므로 1을 더함
	        return month;
	    }
	    const currentMonth = getCurrentMonth();  // 현재 월 가져오기
		
	    const chart = new Chart(ctx, {
		    type: 'horizontalBar',  // 가로 막대 차트
		    data: {
		        // y축 데이터
		        labels: labels,
		        // 데이터 속성
		        datasets: [
		            {
		                label: '당월 영업 진척도',  // 데이터셋의 라벨
		            	data: dataValues,
		            	// 조건에 따른 Bar 색상 결정
		                backgroundColor: dataValues.map(value => {
                            if (value < 60) return '#DADFF3'; // 60% 미만
                            if (value >= 60 && value < 100) return '#8EA6F7'; // 60% 이상 100% 미만
                            return '#4A6FF0'; // 100%
                        }),
		            	maxBarThickness: 20 // Bar 최대 두께
		            }
		        ]
		    },
		    options: {
		    	scales: {
	                // 하단 X축 (영업 진척도 데이터)
		    		xAxes: [
	                    {
	                        id: 'x-axis-1',
	                        position: 'top',
	                        ticks: {
	                            max: 100, // x축 최대값 100으로 고정
	                            stepSize: 5,  // 5% 단위로 설정
	                            beginAtZero: true,  // 0부터 시작
	                           	fontColor: 'black'
	                        }
	                    }
	                ],
	                // y축
		    		yAxes: [{
		    			ticks: {
		    				beginAtZero: true,
		    				fontColor: 'black'
		    			}
		    		}]
		    	},
		    	// 범례 숨김
	            legend: {
	                display: false  // 범례를 숨김
	            },
	            // 차트 제목 추가
	            title: {
	                display: true,
	                text: currentMonth + '월 영업 진척도 현황',  // 차트 상단 제목
	                fontSize: 19
	            },
	            // 툴팁 옵션 설정
	            tooltips: {
	                callbacks: {
	                    label: function(tooltipItem, data) {
	                    	const value = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];  // 해당 데이터셋의 값
	                        return '현재 진척도' + ' : ' + value + '%';  // 원하는 형식으로 반환
	                    }
	                }
	            },
                onClick: function(event, activeElements) {
                    if (activeElements.length > 0) {
                        const activeIndex = activeElements[0]._index;
                        const selectedBsnNm = labels[activeIndex];  // 선택한 bar의 거래처명

                        // 상세 페이지로 이동 (예: /businessProgress/detail?bsnNm=거래처명)
                        window.location.href = '/businessProgress/detail?bsnNm=' + encodeURIComponent(selectedBsnNm);
                    }
                }
    		}
		});
    }
}); 
	
//Modal 띄우기 이벤트
$(document).on('click', '.modal-btn', function(){
	
	$('body').css('overflow', 'hidden'); // 페이지 스크롤 비활성화
	$('#inputModal').css('display', 'block');

});
	
// 진행률 select 요소에 0%부터 100%까지 5% 단위로 옵션을 추가하는 함수
function populateProgressOptions() {
    const select = document.getElementById('bsnProgrs');
    for (let i = 0; i <= 100; i += 5) {
        const option = document.createElement('option');
        option.value = i;
        option.text = i + '%';
        select.appendChild(option);
    }
}

// DOM이 로드되면 옵션을 추가
document.addEventListener('DOMContentLoaded', populateProgressOptions);

$(document).on('click', '#submitBtn', function(e) {
	
	// 기본 폼 제출 방지
	e.preventDefault();
	
	// 스윗 얼럿을 통한 확인 창
	Swal.fire({
		title: '영업 진척도를 등록하시겠습니까?',
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#4E7DF4',
		confirmButtonText: '확인',
		cancelButtonText: '취소',
		reverseButtons: true,
	}).then((result) => {
		if (result.isConfirmed) {
	
			// input에 입력된 값 가져오기
			const data = {
		        bsnTtl: $('#bsnTtl').val(),
		        bsnProgrs: $('#bsnProgrs').val(),
		        bsnCn: $('#bsnCn').val(),
		        bsnNm: $('#bsnNm').val(),
		        regDt: $('#regDt').val(),
		        tkcgEmpNo: $('#tkcgEmpNo').val(),
		        rbprsnEmpNo: $('#rbprsnEmpNo').val(),
		        bsnBgngYmd: $('#bsnBgngYmd').val(),
		        bsnEndYmd: $('#bsnEndYmd').val()	
			};
			
			console.log("Ajax 요청 시작");
			
			// AJAX 데이터 전송
			$.ajax({
			    type: "POST",
			    url: "/businessProgress/businessInsert",
			    contentType: "application/json; charset=utf-8",
			    data: JSON.stringify(data),
			    beforeSend: function(xhr) {
			        xhr.setRequestHeader(csrfHeader, csrfToken);
			    },
			    success: function(response) {
					if (response > 0) {
						Swal.fire({
							title: '성공!',
							text: '데이터가 성공적으로 등록되었습니다!',
							icon: 'success',
							confirmButtonText: '확인'
						}).then(() => {
							$('#inputModal').css('display', 'none');
							$('body').css('overflow', 'auto');
							location.reload();
						});
					} else {
						Swal.fire('오류', '등록 중 오류가 발생했습니다.', 'error');
						console.log('Response:', response);  // 응답 내용을 출력
					}
				},
			    error: function(xhr, status, error) {
			        console.error('Error during registration:', xhr, status, error);  // 에러 로그
			        alert('등록 중 오류가 발생했습니다.');
			    }
			});
		}
	})
})

//Modal 닫기 버튼
function closeModal() {
	Swal.fire({
		title: '영업 진척도 작성을 취소하시겠습니까?',
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#4E7DF4',
		confirmButtonText: '확인',
		cancelButtonText: '취소',
		reverseButtons: true,
	}).then((result) => {
		if(result.isConfirmed) {
			$('body').css('overflow', 'auto'); // 페이지 스크롤 활성화
		    $('#inputModal').css('display', 'none');  // Modal을 닫음
		}
	});
}

</script>

</head>
<body>

<div class="max-w-7xl mx-auto mb-3" style="max-width: 84.5rem;">
	 <div class="w-full flex justify-between items-center mt-1 mb-3">
		<div style="margin-top: 30px; margin-bottom: 10px;">
			<h3 class="text-lg font-semibold text-slate-800 pt-8">영업 진척도</h3>
			<p class="text-slate-500">영업 진척도를 쉽게 확인하고 관리하세요</p>
		</div>
	</div>
			
<div class="card" style="padding: 5px; width: 1350px; height: 690px; padding-top: 30px;">
	<div class="card-body table-responsive p-0">
			<div style="width:1250px; height:550px; margin-left: 4%; margin-top: 10px;">
				<canvas id="businessChart" style="width: 98%; height: 98%;" ></canvas>
			</div>
			<div class="mt-4" style="display: flex; justify-content: flex-end; width:1300px;">
		    	<button id="editBtn" class="bg-[#848484] text-white px-4 py-2 rounded modal-btn">등록</button>
			</div>
		</div>
	</div>
</div>

<!-- Chart 등록용 Modal -->
<div id="inputModal" class="modal" style="display: none;">
	    <div class="modal-content modal-content-top">
			<div id="modalHeader">
				<span id="closeModal"
					  class="close text-right cursor-pointer text-m font-bold"
					  onclick="closeModal()">
					 ✕
			    </span>
				<h2 class="block mb-2 text-lg font-medium text-gray-900 dark:text-gray-300" style="color: black;">영업 진척도 등록</h2>
			</div>
			
			<br>
			
			<div id="modalBody">
				<!-- 여기 아래에 input 태그 추가 -->
				<div class="grid gap-3 mb-3 lg:grid-cols-4">
					<div class="lg:col-span-3">
						<label for="bsnTtl" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300" style="color: black;">
							제목 <code> *</code>
						</label>
						<input type="text" id="bsnTtl" name="bsnTtl"
							   class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   required>
					</div>
					<div>
						<label for="bsnProgrs" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300" style="color: black;">
							 진행률<code> *</code>
						</label>
						<select id="bsnProgrs" name="bsnProgrs" class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
								required>
								
						</select>
					</div>
				</div>
				<div class="grid gap-3 mb-3">	
					<div>
						<label for="bsnCn" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300" style="color: black;">
							내용 <code> *</code>
						</label>
						<textarea id="bsnCn" name="bsnCn" rows="3"
							   class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   required></textarea>
					</div>
				</div>
				<div class="grid gap-3 mb-3 lg:grid-cols-2">	
					<div>
						<label for="bsnNm" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300" style="color: black;">
							거래처명 <code> *</code>
						</label>
						<input type="text" id="bsnNm" name="bsnNm"
							   class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   required>
					</div>
					<div>
						<label for="regDt" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300" style="color: black;">
							등록 일자 <code> *</code>
						</label>
						<input type="date" id="regDt" name="regDt"
							   class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   required>
					</div>
				</div>
				<div class="grid gap-3 mb-3 lg:grid-cols-2">	
					<div>
						<label for="tkcgEmpNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300" style="color: black;">
							담당 사원 번호 <code> *</code>
						</label>
						<input type="text" id="tkcgEmpNo" name="tkcgEmpNo" value="${empVO.empNo}"
							   class="bg-gray-100 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly style="background-color: #f1f3f5; color: black;">
					</div>
					<div>
						<label for="rbprsnEmpNo" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">
							책임 사원 번호 <code> *</code>
						</label>
						<input type="text" id="rbprsnEmpNo" name="rbprsnEmpNo" value="240003"
							   class="bg-gray-100 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   readonly style="background-color: #f1f3f5; color: black;">
					</div>
				</div>
				<div class="grid gap-3 mb-3 lg:grid-cols-2">	
					<div>
						<label for="bsnBgngYmd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300" style="color: black;">
							영업 시작일 <code> *</code>
						</label>
						<input type="date" id="bsnBgngYmd" name="bsnBgngYmd"
							   class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
							   required>
					</div>
					<div>
						<label for="bsnEndYmd" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300" style="color: black;">
							영업 종료일
						</label>
						<input type="date" id="bsnEndYmd" name="bsnEndYmd"
							   class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
					</div>
				</div>	
				<div class="flex justify-end">
					<button id="submitBtn"
						class="bg-[#848484] text-white px-4 py-2 rounded mr-2">등록</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
