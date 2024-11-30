<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
	    $('.truncate-text').each(function() {
	        var fullText = $(this).text();
	        if (fullText.length > 30) {
	            $(this).text(fullText.substring(0, 30) + '...');
	            $(this).parent('a').attr('title', fullText); // 툴팁으로 전체 텍스트 표시
	        }
	    });
	});

	$(function(){
		$("#totalListBtn").on("click", function(){
			location.href = "/approval/approvalDocList";
		})
		
		$("#approvalReqListBtn").on("click", function(){
			location.href = "/approval/approvalRequestList"
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
	
	#approvalReqListBtn:hover {
		background-color: #4E7DF4;
		color: white;
	}
	
	.blueBtn:hover {
	    background-color: #3A63C8; /* 약 20% 더 어두운 색상 */
	}
</style>
</head>
<body>
<%-- <p>${approvalDocVOList}</p> --%>
	<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
		<div class="w-full flex justify-between items-center pl-3">
			<div style="margin-top: 30px; margin-bottom: 10px;">
				<h3 class="text-lg font-semibold text-slate-800">결재 관리</h3>
				<p class="text-slate-500">결재한 문서들을 쉽게 찾고 편리하게 확인하세요.</p>
			</div>
		</div>
		
		<div class="flex flex-col justify-center items-center">
	      <div class="w-full mt-2 mb-4 grid grid-cols-1 gap-5 md:grid-cols-4 lg:grid-cols-4 2xl:grid-cols-4 3xl:grid-cols-4">
	         
	         <div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="height: 100px;">
	            <div class="ml-[18px] flex w-auto flex-row items-center">
	               <div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
	                  <span class="flex items-center text-brand-500">
	                    <i class="fa-solid fa-circle-check fa-2xl"></i>
	                  </span>
	               </div>
	            </div>
	            <div class="h-50 ml-4 flex w-auto flex-col justify-center">
	               <p class="request-text">승인한 결재</p>
	               <h4 class="mt-2 text-xl font-bold text-navy-700" id="wCntElement" countto="2"><a class="aBtn" href="/approval/approvalDocList?atrzSttusCd=A14-001">${dsbApprovalDocCountVO.countApprove}</a><span class="text-span"> 건</span></h4>
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
	               <p class="request-text">반려한 결재</p>
	               <h4 class="mt-2 text-xl font-bold text-navy-700" id="myNoticesElement" countto="0"><a class="aBtn" href="/approval/approvalDocList?atrzSttusCd=A14-002">${dsbApprovalDocCountVO.countReturn}</a><span class="text-span"> 건</span></h4>
	            </div>
	         </div>
	         
	         <div class="relative flex flex-grow !flex-row flex-col items-center rounded-[10px] rounded-[10px] border-[1px] border-gray-200 bg-white bg-clip-border shadow-md shadow-[#F3F3F3] dark:border-[#ffffff33] dark:!bg-navy-800 dark:text-white dark:shadow-none" style="height: 100px;">
	            <div class="ml-[18px] flex h-[90px] w-auto flex-row items-center">
	               <div class="rounded-full bg-lightPrimary p-3 dark:bg-navy-700">
	                  <span class="flex items-center text-brand-500">
	                     <i class="fa-solid fa-pen fa-2xl"></i>
	                  </span>
	               </div>
	            </div>
	            <div class="h-50 ml-4 flex w-auto flex-col justify-center">
	               <p class="request-text">최종 승인된 결재</p>
	               <h4 class="mt-2 text-xl font-bold text-navy-700" id="etcElement" countto="1511"><a class="aBtn" href="/approval/approvalDocList?lastAtrzSttusCd=A14-001">${dsbApprovalDocCountVO.lastCountApprove}</a><span class="text-span"> 건</span></h4>
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
	               <h4 class="mt-2 text-xl font-bold text-navy-700" id="etcElement" countto="1511"><a class="aBtn" href="/approval/approvalDocList?lastAtrzSttusCd=A14-003">${dsbApprovalDocCountVO.countWait}</a><span class="text-span"> 건</span></h4>
	            </div>
	         </div>

	      </div>
		</div>
		
		<div class="flex justify-between">
	    
		    <div class="flex justify-start items-end"> 
	            <button id="approvalReqListBtn" class="listMoveBtn" style="border-radius: 5px 0px 0px 0px; height: 50px;">상신 문서함</button>
	            <button class="listMoveBtn" style="border-radius: 0px 5px 0px 0px; border-top: 6px solid #4E7DF4; transform: scale(1.01);">결재 문서함</button>
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
			          <option value="writer">기안자</option>
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
							<th style="padding: 12px 20px 12px 20px;">제목</th>
							<th>기안자 / 부서 명</th>
							<th>결재 일시</th>
							<th>처리 상태</th>
						</tr>
					</thead>
					<!-- 해더 끝 -->
					
					<!-- 바디 시작 -->
					<tbody>
						<c:choose>
							<c:when test="${not empty approvalDocVOList}">
								<c:forEach var="items" items="${approvalDocVOList}" varStatus="stat">
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
										<td style="text-align: left; padding: 12px 20px 12px 20px; width: 414px;">
											<a class="aHover" href="/approval/approvalDetail?docNo=${items.docNo}">
												<span class="truncate-text">${items.atrzTtl}</span>
											</a>
										</td>
										<td><span>${items.employeeVO.empNm} ${items.employeeVO.jbgdNm} / </span>
											<span style="color: #9F9F9F;"> (${items.employeeVO.deptNm})</span>
										</td>
										<td><fmt:formatDate value="${items.approvalLineVOList[0].atrzDt}" pattern="yyyy.MM.dd(E) HH:mm" /></td>
										<c:choose>
											<c:when test="${items.approvalLineVOList[0].atrzSttusCd == 'A14-001'}">
												<td>
													<span class="relative inline-block px-3 py-1 font-semibold leading-tight">
											            <span aria-hidden="" class="absolute inset-0 opacity-10 rounded-full" style="background-color: #4E7DF4;"></span>
											            <span class="relative" style="color: #4E7DF4;">승인</span>
											        </span>
												</td>
											</c:when>
											<c:when test="${items.approvalLineVOList[0].atrzSttusCd == 'A14-002'}">
												<td>
													<span class="relative inline-block px-3 py-1 font-semibold text-red-900 leading-tight">
														<span aria-hidden="" class="absolute inset-0 bg-red-200 opacity-50 rounded-full"></span>
														<span class="relative">반려</span>
													</span>
												</td>
											</c:when>
										</c:choose>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="7">결재한 문서가 없습니다.</td>
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
								<button id="button-${pNo}" onclick="javascript:location.href='/approval/approvalRequestList?currentPage=${pNo}&searchField=${param.searchField}&keyword=${param.keyword}&startDate=${param.startDate}&endDate=${param.endDate}&atrzSttusCd=${param.atrzSttusCd}&lastAtrzSttusCd=${param.lastAtrzSttusCd}';" class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline" style="background-color: #4E7DF4; color: white;">
									${pNo}
								</button>
							</li>
						</c:if>

						<c:if test="${articlePage.currentPage != pNo}">
							<li>
								<button id="button-${pNo}" onclick="javascript:location.href='/approval/approvalRequestList?currentPage=${pNo}&searchField=${param.searchField}&keyword=${param.keyword}&startDate=${param.startDate}&endDate=${param.endDate}&atrzSttusCd=${param.atrzSttusCd}&lastAtrzSttusCd=${param.lastAtrzSttusCd}';" class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100" style="color: #4E7DF4;">${pNo}</button>
							</li>
						</c:if>
					</c:forEach>

					<!-- endPage < totalPages일 때만 [다음] 활성화 -->
					<li>
						<c:if test="${articlePage.endPage lt articlePage.totalPages}">
							<a href="/approval/approvalRequestList?currentPage=${articlePage.startPage+5}&searchField=${param.searchField}&keyword=${param.keyword}&startDate=${param.startDate}&endDate=${param.endDate}&atrzSttusCd=${param.atrzSttusCd}&lastAtrzSttusCd=${param.lastAtrzSttusCd}';" class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
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