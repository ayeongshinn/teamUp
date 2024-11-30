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
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>
<script>
	
var empNo = "${empVO.empNo}";
	
$(function() {
		console.log("개똥이");
		//input type date 기간 제한
		var now_utc = Date.now() // 지금 날짜를 밀리초로
		var timeOff = new Date().getTimezoneOffset()*60000; // 분단위를 밀리초로 변환
		var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
		
		$("#startDate").attr("max", today);
		$("#endDate").attr("max", today);
		
		
		$("#btnRegist").on("click", function() {
			location.href = "/manage/sugest/regist";
		});

		$("#sugestClsfCd").on("change",function() {
			
			console.log("ㅎㅎㅎㅎ");
			let sugestClsfCd = $(this).val();
			console.log(sugestClsfCd);

			if (sugestClsfCd == 'All') {
				location.href = "/manage/sugest/list";
			} else {
				location.href = "/manage/sugest/cagList?sugestClsfCd="+ sugestClsfCd;
			}
		});
			//카테고리 넘기기

		
		//숫자 카운팅 애니메이션
		$("[countTo]").each(function() {
		    var $this = $(this);
		    var ID = $this.attr("id");
		    var value = $this.attr("countTo");
		    var decimalPlaces = $this.data("decimal");

		    var options = {};
		    if (decimalPlaces) {
		        options.decimalPlaces = 1;
		    }

		    var countUp = new CountUp(ID, value, options);

		    if (!countUp.error) {
		        countUp.start();
		    } else {
		        console.error(countUp.error);
		        $this.html(value);
		    }
		});
			
		$(".checkedboard").click(function() {
			if ($(this).is(":checked") === true) {
				$("#buttonDelete").prop("disabled", false);

			} else {
				$("#buttonDelete").prop("disabled", false);
			}
		});	
			
			
		$("#buttonDelete").click(function() {
			console.log("우와왕")

			
			Swal.fire({
				title: '건의사항 게시글을 삭제하시겠습니까?',
				icon: 'question', /* 종류 많음 맨 아래 링크 참고 */
				confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
				confirmButtonText: '확인',
				cancelButtonText: '취소',
				showCancelButton: true, /* 필요 없으면 지워도 됨, 없는 게 기본 */
				
				reverseButtons: true,
			
			}).then((result) => {
				if(result.isConfirmed){
					//스크립트 영역입니다 
					let groupList = "";
		
					$(".checkedboard:checked").each(
							function(idx, item) {
								if (idx == 0) {
									groupList += item.value;
								} else {
									groupList += ","
											+ item.value;
								}
		
							});
		
					console.log(groupList);
		
					location.href = "/manage/sugest/SgBoardDelPost?groupList="+groupList+ "&&empNo="+"${empVO.empNo}";
				}
			});
			
		});	

		//테이블 헤더의 [상태]가 변경되면 실행
		$("#statusSelect").on("change",function(){
			
			
			let keyword = $("input[name='keyword']").val();
			let searchField = $("input[name='searchField']").val();
			let startDate = $("#startDate").val();
			let endDate = $("#endDate").val();
			
			let data = {
					"searchField":searchField,
					"keyword":keyword,
					"currentPage":1,
					"startDate":startDate,
					"endDate":endDate
			};

			$.ajax({
				url:"/manage/sugest/list",
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
					

					$.each(result.content,function(i,boardVO){
						str += "<tr>";
						str += "<td>"+boardVO.rnum2+"</td>";
						str += "<td style='text-align: left;'><a href='/manage/sugest/detail?bbsNo="+boardVO.bbsNo+"'>"+ boardVO.bbsTtl + "</a></td>";
						str += "<td>"+boardVO.empNm+"</td>";
						let regDt = new Date(boardVO.regDt);
					    let formattedDate = regDt.getFullYear() + "." + 
					                        ('0' + (regDt.getMonth() + 1)).slice(-2) + "." + 
					                        ('0' + regDt.getDate()).slice(-2);

					    str += "<td>" + formattedDate + "</td>";
					    str += "<td style='text-align: center;'>"+boardVO.inqCnt+"</td>";
					    
					    str += "</tr>";
					    
					    $("#tby").html(str);
					})
					
					
				}
			});
		});
		
});

</script>
<title>건의사항</title>
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
		color: #4E7DF4
	}
	
	#myNoticesElement {
		text-decoration: underline;
		cursor: pointer;
	}
	
	#myNoticesElement:hover {
		color: #4E7DF4
	}
	
</style>
</head>
<body>
<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
    <div class="w-full flex justify-between items-center mt-1 pl-3">
        <div style="margin-top: 30px; margin-bottom: 10px;">
            <h3 class="text-lg font-semibold text-slate-800">
            	건의사항
            </h3>
            <p class="text-slate-500">다양한 의견을 건의해 보세요</p>
        </div>

	</div>
   
		
		<div class="flex justify-end mb-3">
	    	<c:if test="${empVO.deptCd=='A17-003'}">
          			<div class=" mt-2 inline-flex items-center rounded-md shadow-sm ml-8" id="btnRDSet" style="margin-bottom: 5px;margin-right: 20px;">
          				<button type="button" id="buttonDelete" disabled class="text-slate-800 hover:text-blue-600 text-sm bg-white hover:bg-slate-100 border border-slate-200 rounded font-medium px-4 py-2 inline-flex space-x-1 items-center">
		                <span>
		                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
		                    <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
		                  </svg>
		                  </span>
		                <span>삭제</span>
		            </button>
          			</div>
          		</c:if>
		  <form id="searchForm">
		    <div class="flex justify-end space-x-3 mt-2">
		    
		      	<select id="sugestClsfCd" name="sugestClsfCd" class="form-control">
					<option value="" selected disabled>선택해 주세요</option>
					<option value="All">전체</option>
					<option value="A25-001">비품</option>
					<option value="A25-002">사내 서비스</option>
					<option value="A25-003">기타</option>
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
		        <select name="searchField" class="h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400">
		          <option value="titleContent" ${param.searchField == 'titleContent' ? 'selected' : ''}>제목+내용</option>
		          <option value="title" ${param.searchField == 'title' ? 'selected' : ''}>제목</option>
		          <option value="content" ${param.searchField == 'content' ? 'selected' : ''}>내용</option>
		          <option value="writer" ${param.searchField == 'writer' ? 'selected' : ''}>작성자</option>
		        </select>
		      </div>
		      <!-- 검색 필드 및 버튼 -->
		      <div>
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
    <div class="relative flex flex-col w-full h-full text-gray-700 bg-white shadow-md rounded-lg bg-clip-border">
       <div class="card-body table-responsive p-0">
       <form id="selectStatus">
            <table style="text-align:center;"class="table table-hover text-nowrap">
               <thead>
                  <tr>
					<th style="width:5%;"></th>
					<th style="width:5%;">번호</th>
					<th style="width:5%;"></th>
					<th style="width:5%;"></th>					
					<th style="width:50%;">제목</th>
					<th style="width:10%;">사원명</th>
					<th style="width:15%;">일자</th>
					<th style="text-align: center;width:5%;">조회수</th>
					</tr>
               </thead>
               <tbody id="tby">
               <!-- 검색 결과가 없을 때 -->
               <c:if test="${empty boardVOList}">
               	<tr>
               		<td colspan="5" style="text-align: center; font-weight: bold; color: #848484;">
               			데이터가 존재하지 않습니다
               		</td>
               	</tr>
               </c:if>
                  <c:forEach var="boardVO" items="${boardVOList}">
					<tr>
						<td style="width:5%;">
							<c:if test="${empVO.deptCd=='A17-003'}">
	                  			<input type="checkbox" class="checkedboard" value="${boardVO.bbsNo}" >
	                  		</c:if>
						
						</td>
						
						<td style="width:5%;">
							<a href="/manage/sugest/detail?bbsNo=${boardVO.bbsNo}">${boardVO.rnum2}</a>
						</td>
						<td style="width:5%;"> 
							<c:if test="${boardVO.fileGroupNo!=0}">
								<img alt="clipIcon" src="/resources/images/clipIcon.png" class="h-[16px]"
										  style="vertical-align: middle; display: inline;">
							</c:if>
						</td>
						<td style="width:5%;"> 
							<c:if test="${boardVO.processSttusCd=='A20-002'}">
									<i class="fa-solid fa-check" style="color: #32c34a;"></i>
								</c:if>
						</td>
						<td style="text-align: left;width:60%;">
							<a href="/manage/sugest/detail?bbsNo=${boardVO.bbsNo}">
								
								<c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
                        		
								${fn:replace(boardVO.bbsTtl, param.keyword, word )}
								
							</a>
						</td>
						<td style="width:10%;">${boardVO.empNm}</td>
						<td style="width:15%;"><fmt:formatDate value="${boardVO.regDt}"
								pattern="yyyy.MM.dd" /></td>
						<td style="text-align: center;width:5%">${boardVO.inqCnt}</td>
					</tr>
				</c:forEach>
               </tbody>
	               <tfoot>
					<tr>
						<td colspan="8" style="text-align: right;">
							
								<button class="bg-indigo-500 text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
								        
								        type="button" id="btnRegist">
								    등록
								</button>
						</td>
					</tr>
				 </tfoot>
            </table>
            </form>
         </div>
       
		<c:if test="${articlePage.total != 0 }">
				<nav aria-label="Page navigation"
					style="margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 10px;">
					<ul class="inline-flex space-x-2">
						<!-- startPage가 5보다 클 때만 [이전] 활성화 -->
						<li><c:if test="${articlePage.startPage gt 5}">
								<a
									href="/manage/sugest/list?currentPage=${articlePage.startPage-5}&empNo=${empVO.empNo}"
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
										onclick="javascript:location.href='/manage/sugest/list?currentPage=${pNo}&empNo=${empVO.empNo}';"
										class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline"
										style="background-color: #4E7DF4;color: white">${pNo}</button>
								</li>
							</c:if>

							<c:if test="${articlePage.currentPage != pNo}">
								<li>
									<button id="button-${pNo}"
										onclick="javascript:location.href='/manage/sugest/list?currentPage=${pNo}&empNo=${empVO.empNo}';"
										class="w-10 h-10 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
										style="color: #4E7DF4">${pNo}</button>
								</li>
							</c:if>
						</c:forEach>

						<!-- endPage < totalPages일 때만 [다음] 활성화 -->
						<li><c:if
								test="${articlePage.endPage lt articlePage.totalPages}">
								<a
									href="/manage/sugest/list?currentPage=${articlePage.startPage+5}"
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
</body>
</html>