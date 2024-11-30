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
<script type="text/javascript">

	function deleteSurveys() {
		Swal.fire({
			title: '선택한 설문을 삭제하시겠습니까?',
			icon: 'warning',
			showCancelButton: true,
	        confirmButtonColor: '#4E7DF4',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	    }).then(function(result) {
	    	if(result.isConfirmed) {
		    	//체크된 설문
		    	var selectedSurveys = [];
		    	$("input[name='checkboxBody']:checked").each(function() {
	                selectedSurveys.push($(this).val());
	            });
		    	
		    	console.log("선택된 설문: ", selectedSurveys);
		    	
		    	//체크된 설문이 없으면
		    	 if (selectedSurveys.length == 0) {
	                Swal.fire({
	                    title: '선택된 설문이 없습니다',
	                    icon: 'warning',
	                    confirmButtonColor: '#4E7DF4',
	                    confirmButtonText: '확인',
	                }); return;
	            }
		            
		        //설문 삭제 요청
		    	 $.ajax({
		                type: 'POST',
		                url: '/deleteSurveysAjax',
		                data: JSON.stringify(selectedSurveys),
		                contentType: 'application/json; charset=utf-8',
		                beforeSend: function(xhr) {
				            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
				        },
		                success: function(result) {
		                    if (result > 0) {
		                        Swal.fire({
		                            title: '설문이 삭제되었습니다.',
		                            icon: 'success',
		                            confirmButtonColor: '#4E7DF4',
		                            confirmButtonText: '확인',
		                        }).then(function() {
		                            location.reload();
		                        });
		                    }
		                }
		            });
	    	}
		})
	}
	
	function endSurveys() {
	    Swal.fire({
	        title: '선택한 설문을 종료하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#4E7DF4',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	    }).then(function(result) {
	        if (result.isConfirmed) {
	            // 체크된 설문
	            var selectedSurveys = [];
	            $("input[name='checkboxBody']:checked").each(function() {
	                selectedSurveys.push($(this).val());
	            });
	
	            console.log("선택된 설문: ", selectedSurveys);
	
	            // 체크된 설문이 없으면
	            if (selectedSurveys.length == 0) {
	                Swal.fire({
	                    title: '선택된 설문이 없습니다',
	                    icon: 'warning',
	                    confirmButtonColor: '#4E7DF4',
	                    confirmButtonText: '확인',
	                }); return;
	            }
	            
	            // 설문 종료 요청
	            $.ajax({
	                type: 'POST',
	                url: '/endSurveysAjax',
	                data: JSON.stringify(selectedSurveys),
	                contentType: 'application/json; charset=utf-8',
	                beforeSend: function(xhr) {
			            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			        },
	                success: function(result) {
	                    if (result > 0) {
	                        Swal.fire({
	                            title: '설문이 종료되었습니다.',
	                            icon: 'success',
	                            confirmButtonColor: '#4E7DF4',
	                            confirmButtonText: '확인',
	                        }).then(function() {
	                            location.reload();
	                        });
	                    }
	                }
	            });
	        }
	    });
	}

	
	$(document).ready(function () {
		
		//제목 '...' 처리
		$(".dashTtl").each(function() {
			var text = $(this).text().trim();
		    var maxLength = 15;
		    
		    if (text.length > maxLength) {
		        $(this).text(text.substring(0, maxLength) + '...');
		    }
		})
		
		//설문 참여 버튼 클릭 시
		$(document).on("click", ".goToSurvey", function() {
			var srvyNo = $(this).data("srvy-no");
			window.location.href = "/surveyDetail?srvyNo=" + srvyNo;
		})
		
		//내가 만든 설문 버튼 클릭 시
		$("#mySurveyList").on("click", function() {
			window.location.href = "/surveyList?mySurveyList=true";
		});
		
		//제목 maxlength값 주기
		$(".truncate-text").each(function() {
	        var text = $(this).text().trim();
	        var maxLength = 30; // 원하는 글자 수 설정
	        
	        if(text.length > maxLength) {
	            $(this).text(text.substring(0, maxLength) + '...');
	        }
	    });
		
		//결과 보기 버튼 클릭 시
		$(".showResult").on("click", function() {
			var srvyNo = $(this).data("srvy-no");
			var srvyTarget = $(this).data("srvy-target");
			window.open('/surveyResult?srvyNo=' + srvyNo + "&srvyTarget=" + srvyTarget, '_blank');
		})
		
		//select 박스 변화 시 자동 폼 제출
		$("#statusSelect").on("change", function() {
			$("#statusForm").submit();
		})
		
	    //checkboxHead 클릭 시 모든 checkboxBody 체크박스 선택/해제
	    $("#checkboxHead").on("click", function() {
	        $("input[name='checkboxBody']").prop("checked", this.checked);
	    });
	    
	    //모든 checkboxBody가 체크되면 checkboxHead도 체크, 하나라도 체크 해제되면 checkboxHead 해제
	    $("input[name='checkboxBody']").on("click", function() {
	        if ($("input[name='checkboxBody']:checked").length === $("input[name='checkboxBody']").length) {
	            $("#checkboxHead").prop("checked", true);
	        } else {
	            $("#checkboxHead").prop("checked", false);
	        }
	    });
	});
	
</script>
<title></title>
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
	
	.btn:hover {
		background-color: #4E7DF4;
		color: white;
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
	
	#showResult {
		background-color: white;
		color: #4E7DF4;
		border: 1px solid #4E7DF4;
	}
	
	#noShowResult{
		background-color: white;
		color: #848484;
		border: 1px solid #848484;
		cursor: default;
	}
	
	#showResult:hover {
		color: #ffffff;
		background-color: #4E7DF4;
	}

	.survey-card {
	  height: 250px; /* 고정된 높이 */
	  min-height: 250px; /* 최소 높이 */
	  max-height: 250px; /* 최대 높이 */
	}
	
	#closeSrvyBtn, #deleteBtn {
		background-color: white;
		color: #848484;
	}
	
	#closeSrvyBtn:hover, #deleteBtn:hover {
		background-color: #848484;
		color: white;
	}
	
	#mySurveyList {
		background-color: #4E7DF4;
		color: white; 
	}
	
	#mySurveyList:hover {
		background-color: #3F6CC9;
		color: white;
	}
	
	#insertSrvy {
		background-color: #4E7DF4;
		color: white;
	}
	
	#insertSrvy:hover {
		background-color: #3F6CC9;
		color: white;
	}
	
	/* 툴팁 */
	[data-tooltip] {
	  cursor: pointer;
	  color: #848484;
	  display: inline-block;
	  line-height: 1;
	  position: relative;
	}
	
	[data-tooltip]::after {
	  background-color: rgba(51, 51, 51, 0.9);
	  border-radius: 0.3rem;
	  color: #fff;
	  content: attr(data-tooltip);
	  font-size: 85%;
	  font-weight: normal;
	  line-height: 1.15rem;
	  opacity: 0;
	  padding: 0.25rem 0.5rem;
	  position: absolute;
	  text-align: center;
	  text-transform: none;
	  transition: opacity 0.2s;
	  visibility: hidden;
	  white-space: nowrap;
	  z-index: 1;
	}
	
	[data-tooltip].tooltip-right::after {
	  top: 50%;
	  left: calc(100% + 0.3rem);
	  transform: translateY(-50%);
	}
	
	[data-tooltip].tooltip-right::before {
	  border-color: transparent rgba(51, 51, 51, 0.9) transparent transparent;
	  border-style: solid;
	  border-width: 0.3rem;
	  content: "";
	  left: calc(100% + 0.1rem);
	  position: absolute;
	  top: 50%;
	  transform: translateY(-50%);
	  visibility: hidden;
	  opacity: 0;
	  transition: opacity 0.2s;
	}
	
	[data-tooltip]:hover::after,
	[data-tooltip]:hover::before {
	  visibility: visible;
	  opacity: 1;
	} 
	
	.filter-link.filterSelected {
	    background-color: #4E7DF4 !important;
	    color: white !important;
	    border-color: #4E7DF4 !important;
	}
	
</style>
</head>
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 mb-3">
    <div class="w-full flex justify-between items-center mt-1 pl-3">
        <div style="margin-top: 30px; margin-bottom: 20px;">
            <h3 class="text-lg font-semibold text-slate-800">
            	<a href="/surveyList">설문조사</a>
            	<c:if test="${empVO.deptCd == 'A17-002'}">
            		<a href="/surveyList">관리</a>
            	</c:if>
            </h3>
            <p class="text-slate-500">설문에 참여하고 구성원들과 의견을 공유하세요</p>
        </div>
	</div>
    <div class="mb-3">
    	<input type="button" id="mySurveyList" value="내가 만든 설문"
    			class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease">
    </div>
    <div class="flex justify-between">
   		<!--현재 진행 중인 설문-->
   		<c:forEach var="surveyVO" items="${activeSurveyList}">
	   		<div class="survey-card border border-slate-200 w-1/4 bg-white mr-2 rounded-xl">
	   		<c:choose>
	   			<c:when test="${surveyVO.participated}">
	   				<span class="relative inline-block px-3 py-1 mt-4 ml-4 font-semibold text-dark-900 leading-tight">
                        <span aria-hidden class="absolute inset-0 bg-gray-200 opacity-50 rounded-full"></span>
						<span class="relative">참여</span>
					</span>
				</c:when>
				<c:otherwise>
			        <span class="relative inline-block px-3 py-1 mt-4 ml-4 font-semibold text-red-800 leading-tight">
			            <span aria-hidden class="absolute inset-0 opacity-10 rounded-full" style="background-color: #4E7DF4;"></span>
						<span class="relative" style="color: #4E7DF4;">미참여</span>
					</span>
				</c:otherwise>
			</c:choose>
			    <div class="pt-3 pl-4 pr-4 pb-4">
			        <h3 class="dashTtl text-lg font-semibold text-slate-800 mb-1">
			            ${surveyVO.srvyTtl}
			        </h3>
			        <p class="text-sm text-slate-500 mb-2">
			        	${fn:replace(surveyVO.srvyBgngDate, '-', '.')}
			        	-
			        	${fn:replace(surveyVO.srvyEndDate, '-', '.')}
			        </p>
			        <div class="text-sm text-slate-600 mb-2">
			            <p>작성자:
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
			            </p>
			        </div>
			        <div class="text-sm text-slate-600 mb-1">
			            <p>설문 결과:
			            	<c:if test="${surveyVO.resOpenYn == 'Y'}">
			            		공개
			            	</c:if>	
			            	<c:if test="${surveyVO.resOpenYn == 'N'}">
			            		비공개
			            	</c:if>	
			            </p>
			        </div>
			    </div>
			    <button class="btn goToSurvey w-full text-gray-900 py-2.5 border-t-gray-300 rounded-b-xl" data-srvy-no="${surveyVO.srvyNo}">
			        참여하기
			    </button>
	   		</div>
   		</c:forEach>
    </div>
    
		<div class="flex justify-between mb-3.5 mt-3.5">
		  <div class="flex space-x-3 items-center">
		  <form id="statusForm" action="/surveyList" method="get">
			<select name="status" id="statusSelect" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
		        <option value="all" ${param.status == 'all' ? 'selected' : ''}>전체</option>
		        <option value="started" ${param.status == 'started' ? 'selected' : ''}>진행중</option>
		        <option value="finished" ${param.status == 'finished' ? 'selected' : ''}>종료</option>
		      </select>
		   </form>
		      <c:if test="${empVO.deptCd == 'A17-002'}">
			   <input type="button" value="삭제" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400"
			        onclick="deleteSurveys()" id="deleteBtn"/>
			    <input type="button" value="설문 종료하기" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400"
			        onclick="endSurveys()" id="closeSrvyBtn"/>
		  	  </c:if>
		  	 <div class="tooltip-right mt-1" data-tooltip="내가 참여한 설문이거나 결과를 공개하는 설문일 때 결과 열람이 가능해요">
		          <i class="fas fa-question-circle" focusable="false" aria-hidden="true"></i>
		     </div>
		  </div>
		
		  <form id="searchForm" class="flex space-x-3 items-center">
		    <!-- 정렬 조건 -->
		    <div>
		      <select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
		        <option value="titleContent">제목+내용</option>
		        <option value="title">제목</option>
		        <option value="content">내용</option>
		        <option value="writer">작성자</option>
		      </select>
		    </div>
		    
		    <!-- 검색창 필드 -->
		    <div class="w-full max-w-sm min-w-[200px] relative">
		      <input type="text" name="keyword"
		             class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
		             placeholder="검색어를 입력하세요."
		             value="${param.keyword != null ? param.keyword : ''}"/>
		      <button type="submit" class="absolute h-8 w-8 right-1 top-1 my-auto px-2 flex items-center bg-white rounded">
		        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-8 h-8 text-slate-600">
		          <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
		        </svg>
		      </button>
		    </div>
		  </form>
		</div>
		<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
			<div class="card-body table-responsive p-0">
				<table style="text-align: center;"
					class="table table-hover text-nowrap">
					<thead>
						<tr>
							<c:if test="${empVO.deptCd == 'A17-002'}">
								<th>
									<input type="checkbox" id="checkboxHead"/>
			   					</th>
		   					</c:if>
							<th>상태</th>
							<th>제목</th>
							<th>기간</th>
							<th>작성자</th>
							<th> </th>
						</tr>
					</thead>
					<tbody>
						<!-- 검색 결과가 없을 때 -->
						<c:if test="${empty surveyVOList}">
							<tr>
								<td colspan="6"
									style="text-align: center; font-weight: bold; color: #848484;">
									데이터가 존재하지 않습니다</td>
							</tr>
						</c:if>
						<c:forEach var="surveyVO" items="${surveyVOList}">
						<tr>
							<c:if test="${empVO.deptCd == 'A17-002'}">
								<td class="align-middle"><input type="checkbox" name="checkboxBody" id="checkboxBody" value="${surveyVO.srvyNo}"/></td>
							</c:if>
							<td class="align-middle">
							<c:choose>
								<c:when test="${surveyVO.participated}">
									<span class="relative inline-block px-3 py-1 font-semibold text-dark-900 leading-tight">
                                        <span aria-hidden class="absolute inset-0 bg-gray-200 opacity-50 rounded-full"></span>
										<span class="relative">참여</span>
									</span>
								</c:when>
								<c:otherwise>
									<span class="relative inline-block px-3 py-1 font-semibold leading-tight">
							            <span aria-hidden class="absolute inset-0 opacity-10 rounded-full" style="background-color: #4E7DF4;"></span>
										<span class="relative" style="color: #4E7DF4;">미참여</span>
									</span>
								</c:otherwise>
							</c:choose>
							</td>
							<td style="text-align: left;" >
								<div class="font-semibold">
									<a href="/surveyDetail?srvyNo=${surveyVO.srvyNo}">
										<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
                        					<span class="truncate-text">
	                        					<c:out value="${fn:replace(surveyVO.srvyTtl, param.keyword, word )}" escapeXml="false"/>
                        					</span>
									</a>
								</div>
								<div class="text-sm text-gray-500">
								<c:choose>
									<c:when test="${surveyVO.endYn == 'Y'}">
										종료
									</c:when>
									<c:otherwise>
										${surveyVO.remainingTime} · 
										<c:choose>
											<c:when test="${surveyVO.srvyTarget == 'A17-001'}">
												경영진 · 
											</c:when>
											<c:when test="${surveyVO.srvyTarget == 'A17-002'}">
												기획부서 ·
											</c:when>
											<c:when test="${surveyVO.srvyTarget == 'A17-003'}">
												관리부서 ·
											</c:when>
											<c:when test="${surveyVO.srvyTarget == 'A17-004'}">
												영업부서 ·
											</c:when>
											<c:when test="${surveyVO.srvyTarget == 'A17-005'}">
												인사부서 ·
											</c:when>
											<c:otherwise>
												전체 ·
											</c:otherwise>
										</c:choose>
										<span class="ml-1"><i class="fas fa-user"></i> ${surveyVO.participatedCnt}</span>
									</c:otherwise>
								</c:choose>
								</div>
							</td>
							<td class="align-middle">
								${fn:replace(surveyVO.srvyBgngDate, '-', '.')}
								-
								${fn:replace(surveyVO.srvyEndDate, '-', '.')}
							</td>
							<td class="align-middle">${surveyVO.empNm}</td>
								<td class="align-middle">
								<c:if test="${(surveyVO.resOpenYn == 'Y' && surveyVO.participated) || empVO.empNo == surveyVO.empNo || empVO.deptCd == 'A17-002'}">
										<input id="showResult" type="button" class="showResult rounded-lg py-1 px-2 text-sm"
												data-srvy-no="${surveyVO.srvyNo}" data-srvy-target="${surveyVO.srvyTarget}" value="결과 보기">
								</c:if>
								<c:if test="${surveyVO.resOpenYn == 'N' && empVO.deptCd != 'A17-002'}">
									<input id="noShowResult" type="button" class="noShowResult rounded-lg py-1 px-3 text-sm border-gray-700 text-gray-700" value="비공개">
								</c:if>
							</td>
						</tr>
						</c:forEach>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="7" style="text-align: right;">
								<a href="/surveyForm" target="_blank">
									<button class="uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
									        id="insertSrvy">
									    등록
									</button>	    
								</a>
							</td>
						</tr>
					</tfoot>
				</table>
			</div>

			<nav aria-label="Page navigation"
				style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
				<ul class="inline-flex space-x-2">
					<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
					<li><c:if test="${articlePage.startPage gt 5}">
							<a href="/noticeList?currentPage=${articlePage.startPage-5}"
								class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
								<path
										d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
										clip-rule="evenodd" fill-rule="evenodd"></path>
							</svg>
							</a>
						</c:if></li>

					<!-- 총 페이징 -->
					<c:forEach var="pNo" begin="${articlePage.startPage}"
						end="${articlePage.endPage}">
						<c:if test="${articlePage.currentPage == pNo}">
							<li>
								<button id="button-${pNo}"
									onclick="javascript:location.href='/noticeList?currentPage=${pNo}';"
									class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
									style="background-color: #4E7DF4; color: white;">${pNo}
								</button>
							</li>
						</c:if>

						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}"
									onclick="javascript:location.href='/surveyList?currentPage=${pNo}';"
									class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
									style="color: #4E7DF4;">${pNo}</button>
							</li>
						</c:if>
					</c:forEach>

					<!-- endPage < totalPages일 때만 [다음] 활성화 -->
					<li><c:if
							test="${articlePage.endPage lt articlePage.totalPages}">
							<a href="/noticeList?currentPage=${articlePage.startPage+5}"
								class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
								<path
										d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
										clip-rule="evenodd" fill-rule="evenodd"></path>
							</svg>
							</a>
						</c:if></li>
				</ul>
			</nav>
		</div>
	</div>
</body>
</html>