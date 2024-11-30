<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal.employeeVO" var="empVO" />
	</sec:authorize>
<!DOCTYPE html>
<html>
<head>
<link rel="preconnect" href="https://rsms.me/">
<link rel="stylesheet" href="https://rsms.me/inter/inter.css">
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>

<script type="text/javascript">

$(function() {
	
	$("#selection_all").click(function(){
		if(  $(this).is(":checked") === true){
    		$(".checkedMail").prop("checked", true);
    		$("#buttonRead").prop("disabled", false);
    		$("#buttonDelete").prop("disabled", false);
			
		}else{
			$(".checkedMail").prop("checked", false);
			$("#buttonRead").prop("disabled", true);
			$("#buttonDelete").prop("disabled", true);
		}
    });

	$(".checkedMail").click(function(){
		if(  $(this).is(":checked") === true){
			$("#buttonRead").prop("disabled", false);
    		$("#buttonDelete").prop("disabled", false);
			
		}else{
			$("#buttonRead").prop("disabled", false);
    		$("#buttonDelete").prop("disabled", false);
		}
    });

	
		
	$("#buttonDelete").click(function(){
		console.log("우와왕")
		
		//스크립트 영역입니다 

	    let groupList = "";

	    $(".checkedMail:checked").each(function(idx, item){
	        if(idx == 0){
	            groupList += item.value;
	        } else {
	            groupList += "," + item.value;
	        }

	    });
    
       console.log(groupList);
   
	
	   location.href = "/cmmn/mail/rmailDelPost?groupList="+ groupList+"&&empNo="+"${empVO.empNo}";
	});
	
	$(".rspamYnChange").click(function(){
		console.log("qweasd")
		let rspamYn = this.querySelector('.rspamYn').value;
		let rcptnSn = this.querySelector('.rcptnSn').value;
		console.log(rspamYn)
		
	   location.href = "/cmmn/mail/rspamYnChange?rspamYn="+rspamYn+"&&empNo="+"${empVO.empNo}&&rcptnSn="+rcptnSn;
		
	});
	
	
	
	$("#buttonRead").click(function(){
		console.log("우와왕")
		
		//스크립트 영역입니다 

	    let groupList = "";

	    $(".checkedMail:checked").each(function(idx, item){
	        if(idx == 0){
	            groupList += item.value;
	        } else {
	            groupList += "," + item.value;
	        }

	    });
    
       console.log(groupList);
   
	
	   location.href = "/cmmn/mail/setPrsY?groupList="+ groupList+"&&empNo="+"${empVO.empNo}";
	});
	
	
	$("#statusSelect").on("change",function(){
		
		
		let keyword = $("input[name='keyword']").val();
		let searchField = $("input[name='searchField']").val();
		let startDate = $("#startDate").val();
		let endDate = $("#endDate").val();
		let empNo = $("#empNo").val();
		
		let data = {
				"searchField":searchField,
				"keyword":keyword,
				"currentPage":1,
				"startDate":startDate,
				"endDate":endDate,
				"empNo":empNo
		};

		$.ajax({
			url:"/cmmn/mail/list",
			data: data,
			type:"post",
			dataType:"json",
			beforeSend:function(xhr){
				xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
			},
			success:function(result){
				console.log("result : ", result);
				
				//<table 의 <tbody id="tby"></tbody>
				$("#tby").html("");
				
				//지역변수
				let str = "";
				

				$.each(result.content,function(i,mailDVO){
					$.each(mailRVOList.content,function(i,mailRVO){
					
						if(mailRVO.rprslYn == 'Y'){
							str += "<tr style='background-color: #f4f4f4;'>";
							
						}else{
							
							str += "<tr>";
						}
						
						str += "<td><input type='checkbox' class='checkedMail' value='"+mailRVO.rcptnSn+"'></td>";
						str += "<td><div class='rspamYnChange'><input class='rspamYn' value='"+ mailRVO.rspamYn + "'hidden/>";
						str += "<div class='rspamYnChange'><input class='rcptnSn' value='"+ mailRVO.rcptnSn + "'hidden/>";
						if(mailRVO.rspamYn == 'N'){
							str += "<i class='fa-regular fa-star' style='color: #d4d6d8;'></i>";
						}else if(mailRVO.rspamYn == 'Y'){
							str += "<i class='fa-solid fa-star' style='color: #FFD43B;'></i></div></td>";
						}
						
						str += "<td style='text-align: left;'>";
						str += "<a href='/cmmn/mail/detail?mailNo="+mailDVO.mailNo+"rcptnSn="+mailRVO.rcptnSn+"'>";
						if(mailDVO.dimprtncYn == 'Y'){
							str += "<i class='fa-solid fa-exclamation' style='color: #f94e4e;'></i>"+mailDVO.mailTtl+"</a></td>";
						}else{
							str += mailDVO.mailTtl+"</a></td>";
						}
						
						
						str += "<td>"+mailDVO.dsptEmpNm+"</td>";
						
						let regDt = new Date(mailDVO.dsptchDt);
					    let formattedDate = regDt.getFullYear() + "." + 
					                        ('0' + (regDt.getMonth() + 1)).slice(-2) + "." + 
					                        ('0' + regDt.getDate()).slice(-2);
	
					    str += "<td>" + formattedDate + "</td>";
					    
					    str += "</tr>";
					    
					    $("#tby").html(str);
				    
					})
				})
				
				
			}
		});
	});
	
	document.querySelectorAll('.resultTitle').forEach(function(el) {
        el.innerHTML = el.innerHTML.replace(/\$\{param\.keyword\}/g, '<span style="color:#4E7DF4;">${param.keyword}</span>');
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
	
	.bg-indigo-500 {
	  background-color: #4E7DF4;
	}
	
	mark {
		background: #ff0; !important;
		color: #000; !important;
	}
	
	svg {
		color: #4E7DF4;
	}
	
	#wCntElement {
		text-decoration: underline;
		cursor: pointer;
	}
	
	#wCntElement:hover {
		color: #ffffff
	}
	
	#myNoticesElement {z
		text-decoration: underline;
		cursor: pointer;
	}
	
	#myNoticesElement:hover {
		color: #ffffff
	}
	.sidebar .nav-link {
	  color: #9F9F9F !important;
	}
	
	.sidebar .nav-link:hover {
	  background-color: #f4f4f4 !important;
	  transform: scale(1.01) !important;
	  color: #ffffff !important;
	}
	
	.sidebar .nav-link:hover i {
	  color: #ffffff !important;
	}
	.logo-link {
		display: inline-flex;
		align-items: center;
		text-decoration: none;
		background-color: white;
		padding: 20px 20px 20px 10px;
	}

	.logo-image {
		margin-right: 10px; /* 이미지와 텍스트 사이의 간격 */
		
	}

	.logo-text {
		font-size: 18px; /* 텍스트 크기 조정 */
		color: #9F9F9F; /* 텍스트 색상 */
		width: 100%;
	}
	
	.logoCls {
		background-color: white;
	}
	table thead, table tbody tr {
	  display: table;
	  width: 100%;
	}
</style>

</head>
<body>
	<div class="max-w-7xl mx-auto sm:px-8 lg:px-10">
		<div class="w-full flex justify-between items-center mt-1 pl-3">
			<div style="margin-top: 30px; margin-bottom: 10px;">
				<h3 class="text-lg font-semibold text-slate-800">
					<a href="/noticeListN">메일</a>
				</h3>
				<p class="text-slate-500">내게쓴 메일함</p>
			</div>

		</div>
		<!-- 대시보드 -->
		<div class="flex flex-col justify-center items-center">
			<div
				class="w-full mt-2 mb-3 grid grid-cols-1 gap-5 md:grid-cols-1 lg:grid-cols-1 2xl:grid-cols-1 3xl:grid-cols-1">
				<div 
					class="border border-slate-200 relative flex flex-col w-full mt-3  text-gray-700 bg-white rounded-lg bg-clip-border">
					<div class="card-body table-responsive p-1">
						<form id="searchForm">
							<div class="flex justify-end space-x-3 mt-2 mb-2">
								<div class="inline-flex items-center rounded-md shadow-sm"
									id="btnRDSet">
									<button type="button" id="buttonRead" disabled
										class="text-slate-800 hover:text-blue-600 text-sm bg-white hover:bg-slate-100 border-y border-slate-200 rounded font-medium px-4 py-2 inline-flex space-x-1 items-center">
										<span> <svg xmlns="http://www.w3.org/2000/svg"
												fill="none" viewBox="0 0 24 24" stroke-width="1.5"
												stroke="currentColor" class="w-4 h-4">
					                        <path stroke-linecap="round"
													stroke-linejoin="round"
													d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z" />
					                        <path stroke-linecap="round"
													stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
					                      </svg>
										</span> <span>읽음</span>
									</button>
									<button type="button" id="buttonDelete" disabled
										class="text-slate-800 hover:text-blue-600 text-sm bg-white hover:bg-slate-100 border border-slate-200 rounded font-medium px-4 py-2 inline-flex space-x-1 items-center">
										<span> <svg xmlns="http://www.w3.org/2000/svg"
												fill="none" viewBox="0 0 24 24" stroke-width="1.5"
												stroke="currentColor" class="w-4 h-4">
					                    <path stroke-linecap="round"
													stroke-linejoin="round"
													d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
					                  </svg>
										</span> <span>삭제</span>
									</button>
								</div>
						      	<select style="width: 150px;" id="mailCtgSel" name="mailCtgSel" class="form-control">
									
									<option value="" selected disabled>모든메일</option>
									<option value="">중요 메일</option>
								</select>
								
						      <!-- 기간 검색 필드 추가 -->
						      <div class="flex items-center space-x-2">
								
						        <label for="startDate" class="text-gray-700" style="width: 80px;">기간</label>
						        <input type="date" id="startDate" name="startDate"
						               class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
						               value="${param.startDate != null ? param.startDate : ''}"/>
						        		
						        <span>-</span>
						        <input type="date" id="endDate" name="endDate"
						               class="bg-white w-full h-10 px-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
						               value="${param.endDate != null ? param.endDate : ''}"/>		        				
						      </div>
						      <!-- 검색 필드 -->
						      <div class="relative">
						      	<input name="empNo" style="display: none;" value="${empVO.empNo}" >
						        <select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
						          <option value="titleContent" ${param.searchField == 'titleContent' ? 'selected' : ''}>제목+내용</option>
						          <option value="title" ${param.searchField == 'title' ? 'selected' : ''}>제목</option>
						          <option value="content" ${param.searchField == 'content' ? 'selected' : ''}>내용</option>
						          <option value="writer" ${param.searchField == 'writer' ? 'selected' : ''}>작성자</option>
						        </select>
						      </div>
						      <!-- 검색 필드 및 버튼 -->
						      <div class="mr-3">
						        <div class="w-full max-w-sm min-w-[200px] relative">
						          <div class="relative">
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
						        </div>
						      </div>
						      
						    </div>
						</form>
						
					</div>
				</div>

			</div>

			<div
				class="relative flex flex-col w-full  text-gray-700 bg-white shadow-md rounded-lg bg-clip-border"
				style="height: 90%; margin-top: 5px;">
				<div class="card-body p-0"
					style="max-height: 800px; width: 100%; overflow: hidden;">
					<form id="selectStatus">
						<table class="table table-hover text-nowrap mb-0"
							style="text-align: center; width: 100%;">
							<thead
								style="position: sticky; top: 0; background: #4E7DF4; color:white; z-index: 10;">
									<tr>
										<th  style="width:10%;"><input type="checkbox" id="selection_all"
											class="button_checkbox blind"> 전체선택</th>
										<th  style="width:10%;">
											<span class="text" >즐겨찾기</span>
										</th>
										<th  style="width:60%;">
											<span class="text">제목</span>
										</th>
										<th  style="width:20%;">
											<span class="text">보낸일시</span>
										</th>
									</tr>
								</thead>
								<tbody id="tby" style="display: block; max-height: 400px;width: 100%;">
									<c:forEach var="mailDVO" items="${mailDVOList}">
										<c:forEach var="mailRVO" items="${mailDVO.mailRVOList}">
										
			
											<c:if test="${mailRVO.rprslYn == 'Y'}">
											    <tr style="background-color: #f4f4f4;">
											</c:if>
											<c:if test="${mailRVO.rprslYn != 'Y'}">
											    <tr>
											</c:if>
											
												<td style="width:10%;"><input type="checkbox" class="checkedMail" value="${mailRVO.rcptnSn}" ></td>
												<td style="width:10%;">
												<div class="rspamYnChange">
													<input class="rspamYn" value="${mailRVO.rspamYn}" hidden/>
													<input class="rcptnSn" value="${mailRVO.rcptnSn}" hidden/>
						                        	<c:if test="${mailRVO.rspamYn == 'N'}">
						                        		<i class="fa-regular fa-star" style="color: #d4d6d8;"></i>
						                        	</c:if>
						                        	<c:if test="${mailRVO.rspamYn == 'Y'}">
						                        		<i class="fa-solid fa-star" style="color: #FFD43B;"></i>
						                        	</c:if>
												</div>
						                        </td>
						                        
												<td style="text-align: left;width:60%;">
													<a href="/cmmn/mail/toMeDetail?mailNo=${mailDVO.mailNo}">
													    <c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
													    <c:set var="resultTitle" value="${fn:replace(mailDVO.mailTtl, param.keyword, word)}" />
														<c:if test="${mailDVO.dimprtncYn == 'Y'}">
														    <i class="fa-solid fa-exclamation" style="color: #f94e4e;"></i>
														</c:if>
														
														<!-- resultTitle의 길이가 30글자를 초과할 때 -->
														<c:if test="${fn:length(resultTitle) > 30}">
														    <span class="resultTitle">${fn:substring(resultTitle, 0, 30)}...</span>
														</c:if>
														
														<!-- resultTitle의 길이가 30글자 이하일 때 그대로 출력 -->
														<c:if test="${fn:length(resultTitle) <= 30}">
														    <span class="resultTitle">${resultTitle}</span>
														</c:if>
													</a>
												</td>
												
												<td style="width:20%;"><fmt:formatDate value="${mailDVO.dsptchDt}"
														pattern="yyyy.MM.dd HH:mm" /></td>
											</tr>
										</c:forEach>
									</c:forEach>
								</tbody>
							</table>
							</form>
						</div>
			
						<c:if test="${articlePage.total == 0 }">
					<p style="margin: 40px; text-align: center;">데이터가 존재하지 않습니다.</p>
				</c:if>

				<c:if test="${articlePage.total != 0 }">
					<nav aria-label="Page navigation"
						style="margin-left: auto; margin-right: auto; margin-top: 9px; margin-bottom: 5px;">
						<ul class="inline-flex space-x-2">
							<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
							<li><c:if test="${articlePage.startPage gt 5}">
									<a
										href="/cmmn/mail/toMeList?currentPage=${articlePage.startPage-5}&empNo=${empVO.empNo}"
										style="color: #4E7DF4"
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
											onclick="javascript:location.href='/cmmn/mail/toMeList?currentPage=${pNo}&empNo=${empVO.empNo}';"
											class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
											style="color: #4E7DF4">${pNo}</button>
									</li>
								</c:if>

								<c:if test="${articlePage.currentPage != pNo}">
									<li>
										<button id="button-${pNo}"
											onclick="javascript:location.href='/cmmn/mail/toMeList?currentPage=${pNo}&empNo=${empVO.empNo}';"
											class="w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
											style="color: #4E7DF4">${pNo}</button>
									</li>
								</c:if>
							</c:forEach>

							<!-- endPage < totalPages일 때만 [다음] 활성화 -->
							<li><c:if
									test="${articlePage.endPage lt articlePage.totalPages}">
									<a
										href="/cmmn/mail/toMeList?currentPage=${articlePage.startPage+5}&empNo=${empVO.empNo}"
										style="color: #4E7DF4"
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
				</c:if>

			</div>
		</div>

	</div>
	</body>
</html>