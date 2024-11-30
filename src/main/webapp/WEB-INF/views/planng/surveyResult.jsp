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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
<script type="text/javascript">
	$(document).ready(function() {
	    //동적으로 참여자 수를 가져오기 (정수로 변환)
	    var allParticiCnt = ${allParticiCnt};
	    var particiCnt = ${particiCnt};
		
	    console.log(allParticiCnt);
	    
	    // 참여율 계산
	    var percentage = 0;
	    if (allParticiCnt > 0) {
	        percentage = (particiCnt / allParticiCnt) * 100;
	    }
	
	    // 계산된 퍼센트 값을 진행 바 및 퍼센트 텍스트에 업데이트
	    $("#progressBarFill").css("width", percentage + "%");
	    $("#progressPercentage").text(percentage.toFixed(2) + "%");
	});
</script>
<title>설문 결과</title>
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
	input[type="radio"]:checked + label {
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
	
	#scrollTopBtn {
		display:none;
		position: fixed;
		bottom: 40px;
		right: 40px;
		z-index: 99;
		background-color: #333;
		color: white;
		border: none;
		padding: 10px;
		border-radius: 50%;
	}

</style>
<body>
	<input type="hidden" name="srvyEmpNo" value="${empVO.empNo}" />
	<!-- 설문 제목 입력 -->
	<div class="flex justify-center">
		<div class="w-[700px]">
			<div class="h-auto bg-white rounded-xl mb-3">
				<div class="flex px-10 pt-10 items-center">
		           <div class="inline-flex rounded-md mr-2" role="group">
					    <c:if test="${surveyVO.srvyTarget == 'A03-006'}">
					        <input type="radio" id="all" value="A03-006" name="srvyTarget" class="hidden" checked disabled>
					        <label for="all" class="filter-link px-2.5 py-1 rounded-lg border text-sm font-medium text-white bg-blue-700 cursor-not-allowed">
					            전체
					        </label>
					    </c:if>
					    <c:if test="${surveyVO.srvyTarget != 'A03-006'}">
					        <input type="radio" id="dept" value="${empVO.deptCd}" name="srvyTarget" class="hidden" checked disabled>
					        <label for="dept" class="filter-link px-2.5 py-1 rounded-lg border text-sm font-medium text-white bg-blue-700 cursor-not-allowed">
					            <c:choose>
									<c:when test="${surveyVO.srvyTarget == 'A17-001'}">
										경영진
									</c:when>
									<c:when test="${surveyVO.srvyTarget == 'A17-002'}">
										기획부서
									</c:when>
									<c:when test="${surveyVO.srvyTarget == 'A17-003'}">
										관리부서
									</c:when>
									<c:when test="${surveyVO.srvyTarget == 'A17-004'}">
										영업부서
									</c:when>
									<c:when test="${surveyVO.srvyTarget == 'A17-005'}">
										인사부서
									</c:when>
								</c:choose>
					        </label>
					    </c:if>
					</div>
						<c:if test="${surveyVO.annmsYn == 'N'}">
	                		<span class="bg-yellow-200 text-yellow-700 text-sm font-semibold px-2 py-1 rounded-lg mb-2" id="annmsN">실명</span>
	                	</c:if>
	                	<c:if test="${surveyVO.annmsYn == 'Y'}">
	                		<span class="bg-blue-100 text-blue-700 text-sm font-semibold px-2 py-1 rounded-lg mb-2" id="annmsY">익명</span>
	            		</c:if>
	            </div>
				 <div class="flex px-10 mb-1 items-center">
	                <span class="text-lg font-bold w-full">${surveyVO.srvyTtl}</span>
	            </div>
				<div class="px-10 pb-1 mt-2 text-gray-500">
					<span id="srvyEmpNo" class="w-full">${surveyVO.empNm}</span>
				</div>
				<div class="px-10 pb-4 text-gray-500">
					<span id="srvyBgngDate" class="w-full">${fn:replace(surveyVO.srvyBgngDate, '-', '.')}</span>
					<span id="srvyBgngTm" class="w-full">${surveyVO.srvyBgngTm} - </span>
					<span id="srvyEndDate" class="w-full">${fn:replace(surveyVO.srvyEndDate, '-', '.')}</span>
					<span id="srvyEndTm" class="w-full">${surveyVO.srvyEndTm}</span>
					<!-- 응답율 통계 -->
					<div class="flex items-center border rounded p-2 mx-10 mt-4">
					    <!-- 참여자 정보 -->
					    <div class="flex-1">
					        <span>전체 참여자: <span id="totalParticipants bold">${allParticiCnt}</span>명</span>
					        <span class="pl-4">참여율: <span id="currentParticipants bold">${particiCnt}</span>명</span>
					    </div>
					    
					    <!-- 진행 바 -->
					    <div class="flex items-center ml-4 w-1/2">
					        <div class="w-full bg-gray-200 rounded-full h-2">
					            <div id="progressBarFill" class="bg-blue-400 h-2 rounded-full" style="width: ;"></div>
					        </div>
					        <span class="ml-4 font-semibold" id="progressPercentage">0%</span>
					    </div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 설문 제목 입력 끝 -->
	
	<c:if test="${empty multiAnsList && empty descAnsList}">
	    <!-- 설문 전체에 대해 응답이 없을 때 -->
	    <div class="flex justify-center">
	        <div class="w-[700px]">
	            <div class="h-auto bg-white rounded-xl">
	                <div class="px-10 py-10 text-center">
	                    <p class="text-lg text-gray-800 mb-2">응답 결과가 없습니다.</p>
	                    <p class="text-gray-400">응답이 인입되면 자동 취합한 결과를 확인할 수 있습니다.</p>
	                </div>
	            </div>
	        </div>
	    </div>
	</c:if>
	
	<%-- 질문과 보기, 해당 질문의 응답 결과 차트  --%>
	<c:if test="${!empty multiAnsList || !empty descAnsList}">
	<c:forEach var="surveyQstVO" items="${surveyQstVOList}" varStatus="status">
	    <div class='flex justify-center' id='descriptDiv_${status.index}'>
	        <div class='w-[700px] relative mb-3'>
	            <div class='h-auto bg-white rounded-xl pb-5'>
	                <div class='flex px-10 mb-1 items-center pt-5 w-full'>
	                    <span class="font-semibold" style="font-size: 18px;">
	                    <input type="hidden" name="srvyQstVOList[${status.index}].srvyQstNo" value="${surveyQstVO.srvyQstNo}" />
	                    <input type="hidden" name="srvyQstVOList[${status.index}].quesCd" value="${surveyQstVO.quesCd}" />
	                    ${status.count}. ${surveyQstVO.quesCn}
	                    </span><br>
	                </div>
	
	                <div class='px-10 pb-2 w-full'>
	                    <c:choose>
	                        <c:when test="${!empty surveyQstVO.quesExp}">
	                            <span class="text-sm text-gray-500">${surveyQstVO.quesExp}</span>
	                        </c:when>
	                    </c:choose>
	                </div>
	
	                <div class='px-10 w-full'>
	                    <c:choose>
	                        <%-- 객관식 응답 처리 --%>
	                        <c:when test="${surveyQstVO.quesCd == 'A27-001'}">
								<%-- 차트 --%>
								<div class="flex justify-center mt-3">
									<div class="chart-container" style="position: relative; height:40vh; width:40vw;">
									    <canvas id="myDoughnutChart_${status.index}"></canvas>
									</div>
								</div>
								<%-- 객관식 응답 결과 표시 --%>
								<c:if test="${surveyVO.annmsYn == 'N'}">
		                            <ul class="option-list mb-3 pt-3 ">
										<c:set var="optionMap" value="" scope="page"/> <!-- 빈 문자열 생성 -->
											<c:forEach var="multiAns" items="${multiAnsList}">
											    <c:if test="${multiAns.srvyQstNo == surveyQstVO.srvyQstNo}">
											        <c:choose>
											            <%-- 만약 optionMap에 해당 optionCn이 없다면 --%>
											            <c:when test="${fn:indexOf(optionMap, multiAns.optionCn) == -1}">
											                <li class="text-sm text-gray-700 mt-1">
											                    <span class="bold">∙ ${multiAns.optionCn}: </span>
											                    <%-- 투표자 이름들 출력 --%>
											                    <c:forEach var="innerMultiAns" items="${multiAnsList}" varStatus="innerStatus">
											                        <c:if test="${innerMultiAns.optionCn == multiAns.optionCn}">
											                            <span>
											                            	<c:if test="${innerMultiAns.deptCd == 'A17-001'}">
											                            		<span style="color: #4E7DF4">경영진</span>
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.deptCd == 'A17-002'}">
											                            		<span style="color: #4E7DF4">기획부서</span>
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.deptCd == 'A17-003'}">
											                            		<span style="color: #4E7DF4">관리부서</span>
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.deptCd == 'A17-004'}">
											                            		<span style="color: #4E7DF4">영업부서</span>
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.deptCd == 'A17-005'}">
											                            		<span style="color: #4E7DF4">인사부서</span>
											                            	</c:if>
											                            	${innerMultiAns.empNm}
											                            	<c:if test="${innerMultiAns.jbgdCd == 'A18-001'}">
											                            		사원
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.jbgdCd == 'A18-002'}">
											                            		대리
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.jbgdCd == 'A18-003'}">
											                            		차장
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.jbgdCd == 'A18-004'}">
											                            		부장
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.jbgdCd == 'A18-005'}">
											                            		이사
											                            	</c:if>
											                            	<c:if test="${innerMultiAns.jbgdCd == 'A18-006'}">
											                            		사장
											                            	</c:if>
											                            </span>
											                            <c:if test="${!innerStatus.last}"> </c:if>
											                        </c:if>
											                    </c:forEach>
											                </li>
											                <%-- 이미 출력된 optionCn을 맵에 추가 --%>
											                <c:set var="optionMap" value="${optionMap}${multiAns.optionCn}" scope="page"/>
											            </c:when>
											        </c:choose>
											    </c:if>
											</c:forEach>
										</ul>
									</c:if>
	                        </c:when>
	
	                        <%-- 서술형 응답 처리 --%>
	                        <c:when test="${surveyQstVO.quesCd == 'A27-002'}">
							    <div class="mt-3 mb-3">
							    <c:if test="${empty descAnsList}">
						            <div class="text-gray-500">
	                    				<p class="text-gray-400">제출된 응답이 없습니다.</p>
						            </div>
						        </c:if>
							        <c:forEach var="descAns" items="${descAnsList}">
							            <c:if test="${descAns.srvyQstNo == surveyQstVO.srvyQstNo}">
							                <div class="bg-gray-100 rounded-lg p-3 mt-2 flex justify-between items-center">
							                    <span class="block text-gray-800 text-base leading-relaxed flex-1">
							                    	 <!-- 익명 여부 확인 후 사원명 출력 -->
							                    	 <span class="font-bold">${descAns.descAns}</span>
							                    </span>
							                    <span class="text-right text-gray-700 text-sm">
							                        <c:choose>
							                            <c:when test="${surveyVO.annmsYn == 'N'}">
							                            	<c:if test="${descAns.deptCd == 'A17-001'}">
											            		<span class="text-sm" style="color: #4E7DF4">경영진</span>
											            	</c:if>
											            	<c:if test="${descAns.deptCd == 'A17-002'}">
											            		<span class="text-sm" style="color: #4E7DF4">기획부서</span>
											            	</c:if>
											            	<c:if test="${descAns.deptCd == 'A17-003'}">
											            		<span class="text-sm" style="color: #4E7DF4">관리부서</span>
											            	</c:if>
											            	<c:if test="${descAns.deptCd == 'A17-004'}">
											            		<span class="text-sm" style="color: #4E7DF4">영업부서</span>
											            	</c:if>
											            	<c:if test="${descAns.deptCd == 'A17-005'}">
											            		<span class="text-sm" style="color: #4E7DF4">인사부서</span>
											            	</c:if>
							                                <span class="font-semibold text-gray-700 text-sm">${descAns.empNm}</span>
											            	<c:if test="${descAns.jbgdCd == 'A18-001'}">
											            		<span class="text-sm"> 사원</span>
											            	</c:if>
											            	<c:if test="${descAns.jbgdCd == 'A18-002'}">
											            		<span class="text-sm"> 대리</span>
											            	</c:if>
											            	<c:if test="${descAns.jbgdCd == 'A18-003'}">
											            		<span class="text-sm"> 차장</span>
											            	</c:if>
											            	<c:if test="${descAns.jbgdCd == 'A18-004'}">
											            		<span class="text-sm"> 부장</span>
											            	</c:if>
											            	<c:if test="${descAns.jbgdCd == 'A18-005'}">
											            		<span class="text-sm"> 이사</span>
											            	</c:if>
											            	<c:if test="${descAns.jbgdCd == 'A18-006'}">
											            		<span class="text-sm"> 사장</span>
											            	</c:if>
							                            </c:when>
							                        </c:choose>
							                    </span>
							                </div>
							            </c:if>
							        </c:forEach>
							    </div>
							</c:when>
	                    </c:choose>
	                </div>
	            </div>
	        </div>
	    </div>
	</c:forEach>
	</c:if>

<!-- 스크롤 상단으로 이동 버튼 -->
<button id="scrollTopBtn">
    ↑
</button>

</body>
<script>
$(document).ready(function() {
	 //각 객관식 질문에 대해 차트 그리기
    <c:forEach var="surveyQstVO" items="${surveyQstVOList}" varStatus="status">
        <c:if test="${surveyQstVO.quesCd == 'A27-001'}">
            var ctx = document.getElementById("myDoughnutChart_${status.index}").getContext("2d");

            //사용할 데이터 초기화
            var chartLabels = [];
            var chartData = [];
            var answerCounts = [];

            //optionList 초기화 및 차트 데이터 초기화
            <c:forEach var="option" items="${surveyQstVO.optionList}">
                chartLabels.push('${option.optionCn}'); //선택지
                chartData.push(0);  //기본 퍼센트 값 0
                answerCounts.push(0); //기본 응답자 수 0
            </c:forEach>
                
            console.log('Chart Labels:', chartLabels);

            //multiAnsList에서 데이터를 집계
            <c:forEach var="multiAns" items="${multiAnsList}">
	            <c:if test="${multiAns.srvyQstNo == surveyQstVO.srvyQstNo}">
		            var optionCn = '${multiAns.optionCn}'; //현재 선택지
		            var index = chartLabels.indexOf(optionCn.trim()); //해당 선택지의 인덱스 찾기
	
		            if (index === -1) {
		                console.error(`옵션 매칭 오류: '${optionCn}'을(를) chartLabels에서 찾을 수 없습니다.`);
		            } else {
		                answerCounts[index] += ${multiAns.answerCnt};
		                console.log('옵션: ', optionCn, ' 인덱스: ', index, ' 응답자 수: ', answerCounts[index]);
		            }
		        </c:if>
            </c:forEach>
            
            console.log('최종 Answer Counts:', answerCounts);

            //퍼센트 계산
            var totalAnsCnt = parseInt("${allAnsCntMap[surveyQstVO.srvyQstNo]}");
            for (var i = 0; i < chartLabels.length; i++) {
                if (totalAnsCnt > 0) {
                    var percent = (answerCounts[i] / totalAnsCnt) * 100;
                    chartData[i] = percent.toFixed(2);  //퍼센트 계산
                }
            }
            
            console.log('차트 데이터 (퍼센트):', chartData);
            console.log('응답 수 확인:', answerCounts);
            
            //차트 생성
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: chartLabels,  //옵션 내용
                    datasets: [{
                        data: chartData,   //응답 퍼센트
                        backgroundColor: [
                            '#FF8474', '#67A7B7', '#FFEE93', '#4A7C59', '#FFCDA3', '#D8BFD8'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    layout: {
                        padding: {
                        	top: 20,  //도넛 상단 마진
                        }
                    },
                    plugins: {
	                    legend: {
                            display: true,
                            position: 'bottom',
                            align: 'center',
                            labels: {
                            	boxWidth: 20,
                            	padding: 40, //범례 내부 패딩
                            	font: {
                            		size: 14,	
                            	},
                                color: '#848484',
                            },
                            usePointStyle: true,
                        },
                        tooltip: {
                            callbacks: {
                                label: function(tooltipItem) {
                                	 var index = tooltipItem.dataIndex;
                                     var answerCount = answerCounts[index];
                                     var value = tooltipItem.raw;
                                     
                                     console.log('툴팁 인덱스: ', index);
                                     console.log('answerCounts에서 가져온 값: ', answerCount);
                                     
                                     return ' ' + answerCount + '명 (' + value + '%)';
                                }
                            }
                        },
                        datalabels: {
                        	color: function(context) {
								return context.dataset.backgroundColor[context.dataIndex];                        		
                        	},
                        	font: {
                        		weight: 'bold',
                        		size: 16
                        	},
                            anchor: 'end',
                            align: 'end',
                        	formatter: function(value, context) {
                        		 return value > 0 ? value + '%' : null;
                            }
                        }
                    }
                },
                plugins: [ChartDataLabels]
            });
        </c:if>
    </c:forEach>
});
</script>
</html>