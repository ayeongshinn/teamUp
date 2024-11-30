<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
	    $('.truncate-text').each(function() {
	        var fullText = $(this).text();
	        if (fullText.length > 30) {
	            $(this).text(fullText.substring(0, 30) + '...');
	            $(this).parent('a').attr('title', fullText); // 툴팁으로 전체 텍스트 표시
	        }
	    });
	    
	 	// '실행' 버튼에 클릭 이벤트 추가
	    $('table').on('click', '.run', function() {
	      // 클릭된 버튼의 부모 <td>를 찾습니다
	      var $parentTd = $(this).closest('td');
	      
	      // 해당 <td> 내의 input 요소
	      var docNo = $parentTd.find('.docNo').val();
	      var docCd = $parentTd.find('.docCd').val();
	      
	      let data = {
	    		  "docNo" : docNo,
	    		  "docCd" : docCd
	      }
	      
	      question(data);
	      
	    });
	});

	function success(data) {
		Swal.fire({
			title: '해당 업무처리가 완료되었습니다.',
			icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
			confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
			confirmButtonText: '확인',
		
		}).then((result) => {
			if (result.isConfirmed) {
				$.ajax({
	                url: "/approval/moveInfo",
	                contentType: "application/json;charset=utf-8",
	                data: JSON.stringify(data),
	                type: "post",
	                dataType: "text",  // 응답을 문자열로 처리
	                beforeSend: function(xhr){
	                    xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	                },
	                success: function(res){
	                	
	                    location.href = "/employee/list?jncmpStart=&jncmpEnd=&rsgntnStart=&rsgntnEnd=&delynField=all&searchField=all&keyword=" + res;
	                }
	            });
			}
		});
	};
	
	function question(data) {
	    Swal.fire({
	        title: '해당 업무처리를 실행하시겠습니까?',
	        icon: 'question',
	        showCancelButton: true, // 이 줄을 추가
	        confirmButtonColor: '#4E7DF4',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        reverseButtons: true,
	    }).then((result) => {
	        if (result.isConfirmed) {  // 확인 버튼을 눌렀을 때만 AJAX 요청 실행
	            $.ajax({
	                url: "/approval/workRun",
	                contentType: "application/json;charset=utf-8",
	                data: JSON.stringify(data),
	                type: "post",
	                beforeSend: function(xhr){
	                    xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
	                },
	                success: function(res){
	                    if(res > 1) success(data);
	                }
	            });
	        }
	    });
	};
	
	$(function(){
		$("#totalListBtn").on("click", function(){
			location.href = "/approval/approvalRequestList";
		})
		
		$("#approvalListBtn").on("click", function(){
			location.href = "/approval/approvalDocList"
		})
	})
</script>
<title></title>
<style type="text/css">
	.aHover:hover {
	    font-weight: bold;
	    color: #4E7DF4;
	}
	
	td {
		font-size: 15px;
	}
	
	.state {
		display: inline-block;
		padding: 8px;
		text-align: center;
		color: #fff;
		border-radius: 2px;
		letter-spacing: -1px;
		line-height: 7px;
		height: 25px;
		font-size: 13px;
		vertical-align: middle;
	}
	
	.state.emergency{
		background: none;
		border: 1px solid #ff9f9d;
		color: #fb4c49;
	}
	
	.state.wait {
	    background-color: #A3A3A3;
	    border: 1px solid #A3A3A3;
	}
	
	.state.approve {
	    background-color: #4E7DF4;
	    border: 1px solid #4E7DF4;
	}
	
	.state.return {
	    background-color: #ff616b;
	    border: 1px solid #ff616b;
	}
	
	.state.now {
	    background-color: #a6c76c;
	    border: 1px solid #a6c76c;
	}
	
	.aBtn:hover {
	    color: #4E7DF4;
	}
	
	/* 기본 상태에서 부드러운 트랜지션 적용 */
	.approval-card {
	    transition: transform 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease, color 0.3s ease;
	}
	
	/* 호버 시 확대 효과 적용 */
	.approval-card:hover {
	    transform: scale(1.05) !important;
	    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2) !important;
	    background-color: #4E7DF4 !important;
	    color: white !important;
	}
	
	.approval-card:hover a, 
	.approval-card:hover span,
	.approval-card:hover .request-text {
	    color: white !important;
	}
	
	.approval-card:hover .text-brand-500 {
	    color: white !important;
	}
	
	.text-span {
	    color: black; 
	    font-size: 18px;
	    vertical-align: 1px;
	}
	
	.request-text {
	    color: #4A5568; /* 원래 text-gray-600의 색상값 */
	    font-size: 0.875rem; /* text-sm 크기 */
	    font-weight: 500; /* font-medium */
	}
	
	.blueBtn {
	    width: 30%;
	    margin: 0px;
	    font-size: 15px;
	    border-radius: 10px;
	    background-color: #4E7DF4;
	    color: white;
	    border: none;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}
	
	.listMoveBtn {
		background-color: white;
		color: black;
		padding: 0px 25px;
		height: 56px;
		border-bottom: 1px solid #dee2e6;
		box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
	}
	
	#approvalListBtn:hover {
		background-color: #4E7DF4;
		color: white;
	}
	
	.run:hover {
		background-color: #666666 !important;
		border: 1px solid #666666;
		transition: background-color 0.3s ease, border 0.3s ease;
	}
	
	.blueBtn:hover {
	    background-color: #3A63C8; /* 약 20% 더 어두운 색상 */
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
</style>
</head>
<body>
<%-- <p>${approvalRequestVOList}</p> --%>
	<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
		<div class="w-full flex justify-between items-center pl-3">
			<div style="margin-top: 30px; margin-bottom: 10px;">
				<h3 class="text-lg font-semibold text-slate-800">결재 관리</h3>
				<p class="text-slate-500">상신 문서들을 쉽게 찾고 편리하게 확인하세요. </p>
			</div>
		</div>
		
		<div class="flex flex-col justify-center items-center">
	      <div class="w-full mt-2 mb-4 grid grid-cols-1 gap-5 md:grid-cols-4 lg:grid-cols-4 2xl:grid-cols-4 3xl:grid-cols-4">
	         
	         <div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="height: 100px;">
	            <div class="ml-[18px] flex w-auto flex-row items-center">
	               <div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
	                  <span class="flex items-center text-brand-500">
	                    <i class="fa-solid fa-triangle-exclamation fa-2xl"></i>
	                  </span>
	               </div>
	            </div>
	            <div class="h-50 ml-4 flex w-auto flex-col justify-center">
	               <p class="request-text">긴급 요청한 결재</p>
	               <h4 class="mt-2 text-xl font-bold text-navy-700" id="wCntElement" countto="2"><a class="aBtn" href="/approval/approvalRequestList?emrgncySttus=Y">${dsbApprovalDsbRequestCountVO.countEmrgncyY}</a><span class="text-span"> 건</span></h4>
	            </div>
	         </div>
	         
	         <div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="height: 100px;">
	            <div class="ml-[18px] flex h-[90px] w-auto flex-row items-center">
	               <div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
	                  <span class="flex items-center text-brand-500">
	                     <i class="fa-solid fa-circle-check fa-2xl"></i>
	                  </span>
	               </div>
	            </div>
	            <div class="h-50 ml-4 flex w-auto flex-col justify-center">
	               <p class="request-text">승인된 결재</p>
	               <h4 class="mt-2 text-xl font-bold text-navy-700" id="myNoticesElement" countto="0"><a class="aBtn" href="/approval/approvalRequestList?atrzSttusCd=A14-001">${dsbApprovalDsbRequestCountVO.countApprove}</a><span class="text-span"> 건</span></h4>
	            </div>
	         </div>
	         
	         <div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="height: 100px;">
	            <div class="ml-[18px] flex h-[90px] w-auto flex-row items-center">
	               <div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
	                  <span class="flex items-center text-brand-500">
	                     <i class="fa-solid fa-circle-xmark fa-2xl"></i>
	                  </span>
	               </div>
	            </div>
	            <div class="h-50 ml-4 flex w-auto flex-col justify-center">
	               <p class="request-text">반려된 결재</p>
	               <h4 class="mt-2 text-xl font-bold text-navy-700" id="etcElement" countto="1511"><a class="aBtn" href="/approval/approvalRequestList?atrzSttusCd=A14-002">${dsbApprovalDsbRequestCountVO.countReturn}</a><span class="text-span"> 건</span></h4>
	            </div>
	         </div>
	         
	         <div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="height: 100px;">
	            <div class="ml-[18px] flex h-[90px] w-auto flex-row items-center">
	               <div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
	                  <span class="flex items-center text-brand-500">
	                     <i class="fa-solid fa-clock fa-2xl"></i>
	                  </span>
	               </div>
	            </div>
	            <div class="h-50 ml-4 flex w-auto flex-col justify-center">
	               <p class="request-text">진행 중인 결재</p>
	               <h4 class="mt-2 text-xl font-bold text-navy-700" id="etcElement" countto="1511"><a class="aBtn" href="/approval/approvalRequestList?atrzSttusCd=A14-003">${dsbApprovalDsbRequestCountVO.countWait}</a><span class="text-span"> 건</span></h4>
	            </div>
	         </div>

	      </div>
		</div>
		
		<div class="flex justify-between">
	    
		    <div class="flex justify-start items-end"> 
	            <button class="listMoveBtn" style="border-radius: 5px 0px 0px 0px; border-top: 6px solid #4E7DF4; transform: scale(1.01);">상신 문서함</button>
	            <button id="approvalListBtn" class="listMoveBtn" style="border-radius: 0px 5px 0px 0px; height: 50px;">결재 문서함</button>
		    </div>
			
			<div class="flex justify-end mb-3">
			  <div class="flex items-center space-x-2 pt-2" style="margin-right: 30px;">
			  	<button id="totalListBtn" class="blueBtn" style="border-radius: 10px; width: 90px; height:40px; margin: 0px;">전체 목록</button>
			  </div>
			  <form id="searchForm">
			    <div class="flex justify-end space-x-3 mt-2">
			      <!-- 기간 검색 필드 추가 -->
			      <div class="flex items-center space-x-2">
			        <label for="startDate" class="text-gray-700" style="width: 162px; margin: 0px;">기안 일자</label>
			        <input type="date" id="startDate" name="startDate" class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" value="" max="">
			        		
			        <span>-</span>
			        <input type="date" id="endDate" name="endDate" class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" value="" max="">		        				
			      </div>
			      <!-- 검색 필드 -->
			      <div class="relative">
			        <select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
			          <option value="titleContent">제목</option>
			        </select>
			      </div>
			      <!-- 검색 필드 및 버튼 -->
			      <div>
			        <div class="w-full max-w-sm min-w-[200px] relative">
			          <div class="relative">
			            <input type="text" name="keyword" class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400" placeholder="검색어를 입력하세요." value="">
			            <button type="submit" class="absolute h-8 w-8 right-1 top-1 my-auto px-2 flex items-center bg-white rounded">
			              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-8 h-8 text-slate-600">
			                <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"></path>
			              </svg>
			            </button>
			          </div>
			        </div>
			      </div>
			    </div>
			  </form>
			</div>
	    </div>
		
		<div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border" style="box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);">
			<div class="card-body table-responsive p-0">
				<!-- 테이블 시작 -->
				<table style="text-align: center;" class="table table-hover text-nowrap">
					<!-- 해더 시작 -->
					<thead>
						<tr>
							<th>번호</th>
							<th>기안 일시</th>
							<th title="결재자의 대기문서 가장 상단에 표시됩니다.">긴급</th>
							<th style="padding: 12px 20px 12px 40px;">제목</th>
							<th>결재 일시</th>
							<th>처리 상태</th>
							<th>업무 처리</th>
						</tr>
					</thead>
					<!-- 해더 끝 -->
					
					<!-- 바디 시작 -->
					<tbody>
						<c:choose>
							<c:when test="${not empty approvalRequestVOList}">
								<c:forEach var="items" items="${approvalRequestVOList}" varStatus="stat">
									<tr>
										<td>${items.rn}</td>
										<td><fmt:formatDate value="${items.drftDt}" pattern="yyyy.MM.dd(E) HH:mm" /></td>
										<td>
											<c:choose>
												<c:when test="${items.emrgncySttus == 'Y'}">
													<span class="state emergency">긴급</span>
												</c:when>
												<c:otherwise>
													-
												</c:otherwise>
											</c:choose>
										</td>
										<td style="text-align: left; padding: 12px 20px 12px 40px; width: 414px;">
											<a class="aHover" href="/approval/approvalDetail?docNo=${items.docNo}">
												<span class="truncate-text">${items.atrzTtl}</span>
											</a>
										</td>
										<c:choose>
											<c:when test="${not empty items.lastAtrzDt}">
												<td><fmt:formatDate value="${items.lastAtrzDt}" pattern="yyyy.MM.dd(E) HH:mm" /></td>
											</c:when>
											<c:otherwise>
												<td>-</td>
											</c:otherwise>
										</c:choose>
										<c:choose>
											<c:when test="${items.atrzSttusCd == 'A14-003'}">
												<td>
													<span class="relative inline-block px-3 py-1 font-semibold text-dark-900 leading-tight">
					                                        <span aria-hidden="" class="absolute inset-0 bg-gray-200 opacity-50 rounded-full"></span>
															<span class="relative">진행</span>
													</span>
												</td>
											</c:when>
											<c:when test="${items.atrzSttusCd == 'A14-001'}">
												<td>
														<span class="relative inline-block px-3 py-1 font-semibold leading-tight">
											            <span aria-hidden="" class="absolute inset-0 opacity-10 rounded-full" style="background-color: #4E7DF4;"></span>
											            <span class="relative" style="color: #4E7DF4;">승인</span>
											        </span>
												</td>
											</c:when>
											<c:when test="${items.atrzSttusCd == 'A14-002'}">
												<td>
													<span class="relative inline-block px-3 py-1 font-semibold text-red-900 leading-tight">
														<span aria-hidden="" class="absolute inset-0 bg-red-200 opacity-50 rounded-full"></span>
														<span class="relative">반려</span>
													</span>
												</td>
											</c:when>
										</c:choose>
										<c:choose>
											<c:when test="${items.atrzSttusCd == 'A14-001'}">
												<c:choose>
													<c:when test="${items.taskPrcsSttus == 'N'}">
														<td>
															<a href="#"><span class="state wait run">실행</span></a>
															<input class="docNo" type="text" value="${items.docNo}" hidden="" />
															<input class="docCd" type="text" value="${items.docCd}" hidden="" />
														</td>
													</c:when>
													<c:when test="${items.taskPrcsSttus == 'Y'}">
														<td>
															<span class="state wait">완료</span>
														</td>
													</c:when>
												</c:choose>
											</c:when>
											<c:otherwise>
												<td>
													<span class="state wait" style="opacity: 0.5; cursor: not-allowed;">대기</span>
												</td>
											</c:otherwise>
										</c:choose>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="7">결재 요청한 문서가 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
					<!-- 바디 끝 -->
				</table>
				<!-- 테이블 끝 -->
			</div>
			<nav aria-label="Page navigation" style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
				<ul class="inline-flex space-x-2">
					<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
					<li>
						<c:if test="${articlePage.startPage gt 5}">
							<a href="/approval/approvalRequestList?currentPage=${articlePage.startPage-5}" class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20"><path d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path></svg>
							</a>
						</c:if>
					</li>

					<!-- 총 페이징 -->
					<c:forEach var="pNo" begin="${articlePage.startPage}"
						end="${articlePage.endPage}">
						<c:if test="${articlePage.currentPage == pNo}">
							<li>
								<button id="button-${pNo}" onclick="javascript:location.href='/approval/approvalRequestList?currentPage=${pNo}&searchField=${param.searchField}&keyword=${param.keyword}&startDate=${param.startDate}&endDate=${param.endDate}&emrgncySttus=${param.emrgncySttus}&atrzSttusCd=${param.atrzSttusCd}';" class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline" style="background-color: #4E7DF4; color: white;">
									${pNo}
								</button>
							</li>
						</c:if>

						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}" onclick="javascript:location.href='/approval/approvalRequestList?currentPage=${pNo}&searchField=${param.searchField}&keyword=${param.keyword}&startDate=${param.startDate}&endDate=${param.endDate}&emrgncySttus=${param.emrgncySttus}&atrzSttusCd=${param.atrzSttusCd}';" class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100" style="color: #4E7DF4;">${pNo}</button>
							</li>
						</c:if>
					</c:forEach>

					<!-- endPage < totalPages일 때만 [다음] 활성화 -->
					<li>
						<c:if test="${articlePage.endPage lt articlePage.totalPages}">
							<a href="/approval/approvalRequestList?currentPage=${articlePage.startPage+5}&searchField=${param.searchField}&keyword=${param.keyword}&startDate=${param.startDate}&endDate=${param.endDate}&emrgncySttus=${param.emrgncySttus}&atrzSttusCd=${param.atrzSttusCd}';" class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
								<svg class="w-4 h-4 fill-current" viewBox="0 0 20 20"><path d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path></svg>
							</a>
						</c:if>
					</li>
				</ul>
			</nav>
		</div>
		
	</div>
</body>
</html>