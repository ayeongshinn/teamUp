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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.10.377/pdf.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.10.377/pdf.worker.min.js"></script>
<title>설문 상세</title>
<script type="text/javascript">

	function del(srvyNo) {
	    Swal.fire({
	        title: '게시글을 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#4E7DF4',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	        customClass: {
	            popup: 'my-alert-class'
	        }
	    }).then((result) => {
	        if(result.isConfirmed) {
	            $.ajax({
	            	url: "/deleteSurvey",
	    			data: { "srvyNo": srvyNo },
	    			type: "post",
	    			beforeSend:function(xhr){
	    				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	    			},
	                success: function(result) {
	                    Swal.fire({
	                        title: '삭제되었습니다.',
	                        icon: 'success',
	                        confirmButtonText: '확인',
	                        confirmButtonColor: '#4E7DF4',
	                        customClass: {
		                        popup: 'my-alert-class'
		                    }
	                    }).then(() => {
	                        window.location.href = '/surveyList'; //삭제 후 목록으로 이동
	                    });
	                },
	            });
	        }
	    });
	}
	
	$(document).ready(function() {
		
		//라벨을 클릭해도 해당 radio가 선택되게
		 $('.option-list label').on('click', function() {
	        const radioId = $(this).attr('for');
	        $('#' + radioId).prop('checked', true);
	    });
		
		//제출 버튼 클릭 시
		$("#confirm").on("click", function(e) {
			e.preventDefault();
		
			Swal.fire({
				title: '설문을 제출하시겠습니까?',
	            icon: 'warning',
	            showCancelButton: true,
	            confirmButtonColor: '#4E7DF4',
	            confirmButtonText: '확인',
	            cancelButtonText: '취소',
	            reverseButtons: true,
	            customClass: {
                	popup: 'my-alert-class'
                }
	        }).then((result) => {
	            if (result.isConfirmed) {
	            	 Swal.fire({
                        title: '제출 완료되었습니다.',
                        icon: 'success',
                        confirmButtonText: '확인',
                        confirmButtonColor: '#4E7DF4',
                        customClass: {
	                        popup: 'my-alert-class'
	                    }
                    }).then(() => {
                    	$("#submitSurvey").submit();
                    });
	            }
			})
		});
		
		//삭제 버튼 클릭 시
		$("#deleteBtn").on("click", function() {
			const srvyNo = $(this).data("srvy-no");
			del(srvyNo);
		});
	})
	
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
	
	#qstOpt {
		resize: none;
		overflow-y: auto;
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
	
	.my-alert-class .swal2-icon { /* 아이콘 */ 
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
	
	textarea:focus {
		outline: none;
	}
</style>
</head>
<body>
<!-- 
샵{ansNo}, 샵{srvyNo}, 샵{srvyQstNo}, 샵{ansEmpNo}, SYSDATE,
				샵{descAns}, 샵{multiAns}
 -->
<form id="submitSurvey" action="/submitAnswer" method="post">
<input type="hidden" name="srvyNo" value="${surveyVO.srvyNo}"><!-- SRVY00002 -->
<input type="hidden" name="srvyEmpNo" value="${empVO.empNo}"><!-- 220001 -->
<c:set var="disabled" value="${(surveyVO.participated || surveyVO.endYn == 'Y') ? 'disabled' : ''}" />
	<div class="py-10">
		<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
			<div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
				<div class="p-14 bg-white border-b border-gray-200">
					<div class="pb-2 text-sm flex justify-between items-center">
						<a id="category" href="/surveyList" class="text-md">설문 조사</a>
						 <div class="inline-flex rounded-md" role="group">
					        <a href="/surveyList" class="px-2.5 py-1 rounded-l-lg border border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10">
					            목록
					        </a>
					        <a href="/surveyDetail?srvyNo=${nextSurvey.srvyNo}" class="px-3 py-1 border-t border-b border-gray-200 bg-white font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700"
					        		style="font-size: 0.4rem;">
					            ▲
					        </a>
					        <a href="/surveyDetail?srvyNo=${prevSurvey.srvyNo}" class="px-3 py-1 rounded-r-md border border-gray-200 bg-white font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700"
					        		style="font-size: 0.4rem;">
					           	▼
					        </a>
					    </div>
					</div>
					<!-- 제목과 등록일을 한 줄에 배치 -->
					<div class="title-wrapper flex items-center pb-3">
						<h3 class="title font-semibold">
							<c:if test="${surveyVO.annmsYn == 'N'}">
		                		<span class="bg-yellow-200 text-yellow-700 text-sm font-semibold px-2 py-1 rounded-lg mb-2 mr-1" id="annmsN">실명</span>
		                	</c:if>
		                	<c:if test="${surveyVO.annmsYn == 'Y'}">
		                		<span class="bg-blue-100 text-blue-700 text-sm font-semibold px-2 py-1 rounded-lg mb-2 mr-1" id="annmsY">익명</span>
		            		</c:if>
		            		${surveyVO.srvyTtl}
						</h3>
						<!-- 글 제목 -->
						<span class="date" class="text-md">
							<fmt:formatDate value="${surveyVO.srvyRegDate}" pattern="yyyy.MM.dd HH:mm"/>
						</span>
						<!-- 등록일 -->
					</div>
					
					<div class="text-sm text-gray-600 mb-1 items-center">
					    <span class="block">작성자:
					    <c:if test="${surveyVO.deptCd == 'A17-001'}">
			            		경영진
			            	</c:if>
			            	<c:if test="${surveyVO.deptCd == 'A17-002'}">
			            		기획부서
			            	</c:if>
			            	<c:if test="${surveyVO.deptCd == 'A17-003'}">
			            		관리부서
			            	</c:if>
			            	<c:if test="${surveyVO.deptCd == 'A17-004'}">
			            		영업부서
			            	</c:if>
			            	<c:if test="${surveyVO.deptCd == 'A17-005'}">
			            		인사부서
			            	</c:if>
			            	${surveyVO.empNm}
			            	<c:if test="${surveyVO.jbgdCd == 'A18-001'}">
			            		사원
			            	</c:if>
			            	<c:if test="${surveyVO.jbgdCd == 'A18-002'}">
			            		대리
			            	</c:if>
			            	<c:if test="${surveyVO.jbgdCd == 'A18-003'}">
			            		차장
			            	</c:if>
			            	<c:if test="${surveyVO.jbgdCd == 'A18-004'}">
			            		부장
			            	</c:if>
			            	<c:if test="${surveyVO.jbgdCd == 'A18-005'}">
			            		이사
			            	</c:if>
			            	<c:if test="${surveyVO.jbgdCd == 'A18-006'}">
			            		사장
			            	</c:if>
					    </span>
					    <span class="block">
					    	설문 기간: ${fn:replace(surveyVO.srvyBgngDate, '-', '.')} ${surveyVO.srvyBgngTm} - ${fn:replace(surveyVO.srvyEndDate, '-', '.')} ${surveyVO.srvyEndTm}
					    </span>
						<span class="block">설문 결과:
							<c:if test="${surveyVO.resOpenYn == 'Y'}">
								공개
							</c:if>
							<c:if test="${surveyVO.resOpenYn == 'N'}">
								비공개
							</c:if>
						</span>
						<span class="block">설문 대상:
							<c:if test="${surveyVO.srvyTarget == 'A03-006'}">
								<span class="text-bold">전체</span>
							</c:if>
							<c:if test="${surveyVO.srvyTarget == 'A17-001'}">
								<span class="font-bold">경영진</span>
							</c:if>
							<c:if test="${surveyVO.srvyTarget == 'A17-002'}">
								<span class="font-bold">기획부서</span>
							</c:if>
							<c:if test="${surveyVO.srvyTarget == 'A17-003'}">
			            		<span class="font-bold">관리부서</span>
			            	</c:if>
			            	<c:if test="${surveyVO.srvyTarget == 'A17-004'}">
			            		<span class="font-bold">영업부서</span>
			            	</c:if>
			            	<c:if test="${surveyVO.srvyTarget == 'A17-005'}">
			            		<span class="font-bold">인사부서</span>
			            	</c:if>
						</span>
					</div>
					
					<!-- 설문 내용 -->
					<div>
						<div id="srvyCn" class="w-full bg-gray-100 rounded-xl px-3 py-3 mt-4">${surveyVO.srvyCn}</div>
					</div>
					
					<!-- 설문 안내 -->
					<c:if test="${surveyVO.endYn == 'N'}">
					<div style="text-align: center;" class="mt-5 ">
						<c:choose>
							<%-- 설문 대상이 전체가 아니고, 로그인한 사원의 부서(empVO.deptCd)도 설문 대상이 아닐 때 --%>
						    <c:when test="${surveyVO.srvyTarget != 'A03-006' && surveyVO.srvyTarget != empVO.deptCd}">
						        <div class="block text-red-600 font-semibold mt-3 mb-5 flex items-center justify-center">
						            <img alt="" src="resources/images/warningIcon.png" class="w-[16px] h-[16px] mr-2 mt-1">
						            <span>설문 대상이 아닙니다.</span>
						        </div>
						    </c:when>
						    <c:when test="${surveyVO.participated}">
							    <div class="flex items-center justify-center mt-5 mb-5">
								    <div class="flex-grow border-t border-gray-300"></div>
								    <span class="px-4 font-semibold" style="color: #4E7DF4;">이미 응답한 설문입니다</span>
								    <div class="flex-grow border-t border-gray-300"></div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="block text-red-600 font-semibold mt-3 mb-3 flex itmes-center justify-center">
							        <img alt="" src="resources/images/warningIcon.png" class="w-[16px] h-[16px] mr-2 mt-1">
							        <span>설문 응답은 한 번 제출 후 수정할 수 없습니다. 신중하게 답변해 주세요.</span>
							    </div>
							</c:otherwise>
						</c:choose>
					</div>
					</c:if>
					
					<!-- 설문이 종료되었을 때 -->
					<c:if test="${surveyVO.endYn == 'Y'}">
					    <div class="flex items-center justify-center mt-5 mb-5">
					        <div class="flex-grow border-t border-gray-300"></div>
					        <span class="px-4 font-semibold text-gray-600">종료된 설문입니다</span>
					        <div class="flex-grow border-t border-gray-300"></div>
					    </div>
					</c:if>
					
					<!-- 설문 대상이 전체가 아니고, 로그인한 사원의 부서(empVO.deptCd)도 설문 대상이 아닐 때-->
					<c:if test="${surveyVO.srvyTarget == 'A03-006' || surveyVO.srvyTarget == empVO.deptCd}">
					<div id="qstOpt" class="mt-5 mb-3">
						<c:forEach var="surveyQstVO" items="${surveyQstVOList}" varStatus="status">
							<!-- 질문 -->
							<div class="question-block">
								<span class="font-semibold" style="font-size: 18px;">
								<input type="hidden" name="srvyQstVOList[${status.index}].srvyQstNo" value="${surveyQstVO.srvyQstNo}" />
								<input type="hidden" name="srvyQstVOList[${status.index}].quesCd" value="${surveyQstVO.quesCd}" />
								${status.count}. ${surveyQstVO.quesCn}
								</span><br>
								<c:choose>
									<c:when test="${!empty surveyQstVO.quesExp}">
										<span class="text-sm text-gray-500">${surveyQstVO.quesExp}</span>
									</c:when>	
									<c:otherwise>
									</c:otherwise>
								</c:choose>
							</div>
							
							<c:choose>
							<%-- 객관식 질문이면 --%>
							<c:when test="${surveyQstVO.quesCd == 'A27-001'}">
							<%-- 보기를 표시 --%>
							<ul class="option-list mb-5">
								<c:forEach var="optionList" items="${surveyQstVO.optionList}">
									<li class="text-sm text-gray-700 mt-1 flex items-center">
							            <input type="radio" id="option_${optionList.optionNo}" name="srvyQstVOList[${status.index}].multiAns" value="${optionList.optionNo}" class="mr-2" ${disabled}>
							            <label for="option_${optionList.optionNo}" class="pt-2">${optionList.optionCn}</label>
							        </li>
								</c:forEach>
							</ul>
							</c:when>
							
							<%-- 서술형 질문이면 --%>
							<c:when test="${surveyQstVO.quesCd == 'A27-002'}">
							<%-- textarea를 표시 --%>
								<div class="mt-3 mb-5">
									<textarea name="srvyQstVOList[${status.index}].descAns" placeholder="응답을 입력하세요." class="w-full border rounded p-2 focus:border-[#4E7DF4] focus:border" ${disabled}></textarea>
								</div>
							</c:when>
							</c:choose>
						</c:forEach>
					</div>
					</c:if>
					
					<c:if test="${surveyVO.endYn == 'N' && !surveyVO.participated}">
						<c:choose>
							<%-- 설문 대상일 경우 --%>
							<c:when test="${surveyVO.srvyTarget == 'A03-006' || surveyVO.srvyTarget == empVO.deptCd}">
								<div class="flex justify-center mb-5">
							        <input type="submit" id="confirm" class="text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									    	style="background-color: #4E7DF4;" value="제출">
								</div>
							</c:when>
							<c:otherwise>
							
							</c:otherwise>
						</c:choose>
					</c:if>
					
					<hr class="mb-3">					

					<!-- 버튼들 -->
					<div class="flex justify-end p-1" style="gap: 10px;">
					<c:if test="${empVO.empNo == surveyVO.srvyEmpNo}">
						<button type="button" id="updateBtn" class="shadow-xs text-gray-600 active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
						    style="background-color: #FFFFF;" onclick="location.href='/updateSurvey?srvyNo=${surveyVO.srvyNo}';">
						    수정
						</button>
				        <button type="button" id="deleteBtn" data-srvy-no="${surveyVO.srvyNo}" class="shadow-xs text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
						    style="background-color: #848484;">
						    삭제
						</button>
					</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
	<sec:csrfInput/>
	</form>
</body>
</html>

