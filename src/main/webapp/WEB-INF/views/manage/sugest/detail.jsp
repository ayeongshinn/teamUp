<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<title>건의 상세</title>
<script type="text/javascript">
	$(function() {
		console.log("ddd");
		$("#btnList").on("click", function() {
			location.href = "/manage/sugest/list";
		});
		
		$("#processSttusCdY").on("click", function() {
			let result = confirm("처리완료하시겠습니까?");

			console.log(result);

			if (result == true) {
				location.href = "/manage/sugest/processSttusCdY?bbsNo=${boardVO.bbsNo}";
			} else {
				alert("취소되엇습니다");
			}
		});

		$("#btnDelete").on("click",function() {

			let result = confirm("삭제하시겠습니까?");

			console.log(result);

			if (result == true) {
				location.href = "/manage/sugest/deletePost?bbsNo=${boardVO.bbsNo}";
			} else {
				alert("삭제가 취소되엇습니다");
			}

		});

		//수정모드로 전환
		$("#btnEdit").on("click", function() {
			$("#div1").css("display", "none");
			$("#div2").css("display", "block");
			
			$("#showBbsTtl").css("display", "none");
			$("#bbsTtl").css("display", "block");
			
			$("#showBbsCn").css("display", "none");
			$("#bbsCn").css("display", "block");

			$(".form-control").removeAttr("readonly");


		});

		//일반 모드
		$("#btnCancel").on("click", function() {
			$("#div2").css("display", "none");
			$("#div1").css("display", "block");

			$(".form-control").attr("readonly", true);
			//첨부파일 가리기
			$(".input-group").css("display", "none");

			$("#bbsTtl").val("${boardVO.bbsTtl}");
			$("#bbsCn").val("${boardVO.bbsCn}");
			//CK에디터 없애기
			/*
			이전요소("#선택요소").prev()
			선택요소("#선택요소")
			다음요소("#선택요소").next()
			 */
			// 			$("#prodDetailTemp").next().remove();
		});

		//댓글삭제
		$(document)
				.on(
						"click",
						".clsDelete",
						function() {

							console.log("ddddd");
							let cmntNo = $(this).data("cmntNo");

							console.log(cmntNo);

							//<form></form>
							let formData = new FormData();
							//<form><input type="text" name="repNo" value="4" /></form>
							formData.append("cmntNo", cmntNo);

							formData.append("bbsNo", "${boardVO.bbsNo}");
							console.log(formData);

							$
									.ajax({
										url : "/manage/sugest/deleteCommentAjax",
										processData : false,
										contentType : false,
										data : formData,
										type : "post",
										dataType : "json",
										beforeSend : function(xhr) {
											xhr.setRequestHeader(
													"${_csrf.headerName}",
													"${_csrf.token}");
										},
										success : function(result) {
											console.log("result : ", result);

											let str = "";

											console.log("${boardVO.bbsNo}");
											location.href = "/manage/sugest/detail?bbsNo=${boardVO.bbsNo}";

										}

									});

						});

		$(document).on("click", ".clsUpdate", function() {
			console.log("ddd");

			let cmntNo = $(this).data("cmntNo");

			console.log(cmntNo);

			let cmntCn = $(this).parent().children().first().html();
			console.log(cmntCn);
			/* 댓글 수정
			   요청URI : /perSer/updateReplyAjax
			   요청파라미터 : JSON string{repNo=1,repContent=변경내용}
			   요청방식 : post
			 */
			let data = {
				"cmntNo" : cmntNo,
				"cmntCn" : cmntCn

			};
			console.log(data);
			$("#modalRepNo").val(cmntNo);
			$("#modalRepContent").val(cmntCn);

		});

		$("#idUpdate")
				.on(
						"click",
						function() {

							let cmntNo = $("#modalRepNo").val();
							console.log(cmntNo);
							let cmntCn = $("#modalRepContent").val();
							console.log(cmntCn);

							/* 댓글 수정
							   요청URI : /perSer/updateReplyAjax
							   요청파라미터 : JSON string{repNo=1,repContent=변경내용}
							   요청방식 : post
							 */
							let data = {
								"cmntNo" : cmntNo,
								"bbsNo" : "${boardVO.bbsNo}",
								"cmntCn" : cmntCn

							};
							console.log(data);
							$("#modalRepNo").val(cmntNo);
							$("#modalRepContent").val(cmntCn);

							$
									.ajax({
										url : "/manage/sugest/updateCommentAjax",
										contentType : "application/json;charset=utf-8",
										data : JSON.stringify(data),
										type : "post",
										dataType : "json",
										beforeSend : function(xhr) {
											xhr.setRequestHeader(
													"${_csrf.headerName}",
													"${_csrf.token}");
										},
										success : function(result) {
											console.log(result);
											location.href = "/manage/sugest/detail?bbsNo=${boardVO.bbsNo}";

										}
									});

						});

	});
	
	function commentInsert(insertData) {
	    console.debug("reply.socket", socket);

	    $.ajax({
	        url: '/manage/sugest/registCommentPost',  // 댓글 작성 요청 URL
	        type: 'post',              // POST 방식으로 요청
	        data: insertData,          // 전송할 데이터
	        processData: false,        // 데이터 처리 방식 설정
	        contentType: false,        // 콘텐츠 유형 설정
	        enctype: 'multipart/form-data',  // 데이터 인코딩 방식 설정
	        success: function(data) {
	            commentList();         // 댓글 작성 후 댓글 목록 새로고침
	            $('[name=content]').val('');  // 입력 필드 초기화
	            $('.myEditor').summernote('reset');  // Summernote 에디터 초기화

	            // 소켓을 통해 댓글 알림 전송
	            if (readWriter !== writer) {  // 작성자와 읽는 사람이 다를 경우
	                if (socket) {
	                    let socketMsg = "reply," + writer + "," + readWriter + "," + bno + "," + readTitle + "," + bgno;
	                    console.log(socketMsg);  // 전송할 메시지 로그 출력
	                    socket.send(socketMsg);  // WebSocket을 통해 메시지 전송
	                }
	            }
	        },
	        error: function(xhr, status, error) {
	            console.error("댓글 등록 오류:", error);  // 에러 로그 출력
	            alert("댓글 등록에 실패했습니다.");  // 에러 발생 시 사용자에게 알림
	        }
	    });
	}

	


</script>
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

#ntcCn {
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
.con-center{
	flex: 90%;
}

#formPost {
    width: 100%; /* 부모 div의 전체 너비를 차지 */
    display: block; /* 블록 요소로 설정 */
}

#formComment {
    width: 100%; /* 부모 div의 전체 너비를 차지 */
    display: block; /* 블록 요소로 설정 */
}
blockquote{
  display:block;
  background: #fff;
  padding: 15px 10px 15px 15px;
  margin: 0 0 20px;
  position: relative;
 
  /*Font*/
  font-size: 14px;
  line-height: 1.2;
  color: #666;
 
  /*Box Shadow - (Optional)*/
  -moz-box-shadow: 2px 2px 15px #ccc;
  -webkit-box-shadow: 2px 2px 15px #ccc;
  box-shadow: 2px 2px 15px #ccc;
 
  /*Borders - (Optional)*/
  border-left-style: solid;
  border-left-width: 15px;
  border-right-style: solid;
  border-right-width: 2px;
}
 
blockquote::before{
  content: &quot;\201C&quot;; /*Unicode for Left Double Quote*/
 
  /*Font*/
  font-size: 60px;
  font-weight: bold;
  color: #999;
 
  /*Positioning*/
  position: absolute;
  left: 5px;
  top:5px;
 
}
 
blockquote::after{
  /*Reset to make sure*/
  content: &quot;&quot;;
}
 
blockquote a{
  text-decoration: none;
  background: #eee;
  cursor: pointer;
  padding: 0 3px;
  color: #c76c0c;
}
 
blockquote a:hover{
 color: #666;
}

blockquote.bluejeans{
  border-left-color: #4E7DF4;
  border-right-color: #4E7DF4;
}
</style>
<body>

	<div class="py-14">
		<div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
			
			<div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
				<div class="p-6 bg-white border-b border-gray-200">
				
				
					<div class="pb-2 text-sm flex justify-between items-center">
						<a id="category" href="/noticeListN" class="text-md">건의 사항</a>
						<div class="inline-flex rounded-md" role="group">
							<c:if test="${empVO.deptCd=='A17-003'}">
									<c:if test="${boardVO.processSttusCd=='A20-002'}">
										<div class="inline-flex rounded-md" role="group">
											<button type="button" disabled="disabled"  id="processSttusCdY" class="px-2.5 py-1 rounded-lg border border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700" >
												처리완료<i class="fa-solid fa-check" style="color: #32c34a;"></i>
											</button>
										</div>
									</c:if>
									<c:if test="${boardVO.processSttusCd!='A20-002'}">
										<div class="inline-flex rounded-md" role="group">
											<button type="button" style="background-color:#4E7DF4 ;color: white;"  id="processSttusCdY" class="px-2.5 py-1 rounded-lg border border-gray-200 text-sm font-medium  hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700" >
												처리완료
											</button>
										</div>
									</c:if>
							</c:if>	
							<a href="/manage/sugest/list"
								class="px-2.5 py-1 rounded-l-lg border border-gray-200 bg-white text-sm font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700">
								목록 </a> <a href="/manage/sugest/detail?bbsNo=${nextboardVO.bbsNo}"
								class="px-3 py-1 border-t border-b border-gray-200 bg-white font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700"
								style="font-size: 0.4rem;"> ▲ </a> <a
								href="/manage/sugest/detail?bbsNo=${prevboardVO.bbsNo}"
								class="px-3 py-1 rounded-r-md border border-gray-200 bg-white font-medium text-gray-400 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700"
								style="font-size: 0.4rem;"> ▼ </a>
						</div>
					</div>



					<div class="pb-2 text-sm flex justify-between items-center">
						<form:form id="formPost" modelAttribute="boardVO" action="/manage/sugest/updatePost?${_csrf.parameterName}=${_csrf.token}"
														method="post" enctype="multipart/form-data">
							<div class="con-center" >
								<h3 id="showBbsTtl" class="title font-semibold">${boardVO.bbsTtl}</h3>
								<input type="text"
									class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-4/5 p-2.5 mr-4"
									id="bbsTtl" name="bbsTtl" value="${boardVO.bbsTtl}" style="display: none;">

							</div>
							<br>
							<hr style="boarder: 0px; height: 1px; color: white; ">
							<br>
							
							<div  class="con-center">
								<input type="text" class="form-control" id="empNo" name="empNo"
									value="${boardVO.empNo}" hidden /> <input type="text"
									class="form-control" id="bbsNo" name="bbsNo"
									value="${boardVO.bbsNo}" hidden />
								<div id="showBbsCn" class="mb-80" name="bbsCn">${boardVO.bbsCn}</div>	
								<textarea
									style="resize: none; overflow-y: auto; height: 400px; width: 90%; display: none;"
									id="bbsCn" name="bbsCn"> ${boardVO.bbsCn}</textarea>
							</div>

							<hr style="boarder: 0px; height: 1px; color: white;">
							<br>
							<!-- 첨부파일 -->
							<c:if test="${not empty fileVOList}">
							<div class="mb-4 flex items-center">
								<label class="text-md text-gray-600 mr-4">첨부파일</label>
								<div class="icons flex text-gray-500 m-2">
									<label id="select-image">
									<svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7"
											xmlns="http://www.w3.org/2000/svg" fill="none"
											viewBox="0 0 24 24" stroke="currentColor">
						                	<path stroke-linecap="round"
												stroke-linejoin="round" stroke-width="2"
												d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
						            </svg>
									</label>
									<div id="fileList" class="text-sm text-gray-500 pb-2 ml-2">
										<c:forEach var="file" items="${fileVOList}">
											<c:choose>
												 <%-- PDF 파일인 경우 이름 클릭 시 pdf 뷰어--%>
		                                         <c:when test="${fn:endsWith(file.fileOriginalNm, '.pdf')}">
		                                         	<div class="flex">
			                                         	<a href="/resources${file.fileSaveLocate}" class="viewPdf">${file.fileOriginalNm} [${file.fileFancysize}]</a>
			                                         	<span class="ml-1">|</span>
			                                            <a href="/download?fileName=${file.fileSaveLocate}" class="download-icon ml-1 text-[#4E7DF4]">다운로드</a>
		                                         	</div>
		                                         </c:when>
		                                         <%-- PDF 파일이 아닌 경우 이름 클릭 시 미리보기--%>
		                                         <c:otherwise>
		                                         	<a href="/resources${file.fileSaveLocate}">${file.fileOriginalNm} [${file.fileFancysize}]</a>
		                                         	<span>|</span>
		                                            <a href="/download?fileName=${file.fileSaveLocate}" class="download-icon text-[#4E7DF4]">다운로드</a>
		                                         </c:otherwise>
											</c:choose>
							            </c:forEach>
									</div>
								</div>
							</div>
							</c:if>

							<div  class="flex justify-end p-1"  style="gap: 10px;">
							
								<!-- 일반모드 -->
								<div id="div1"
									<c:if test="${empVO.empNo!=boardVO.empNo}">style="display:none;"</c:if>>
									<button type="button" id="btnEdit" class="shadow-xs text-gray-600 active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
									    style="background-color: #FFFFF;">
									    수정
									</button>
							        <button type="button" id="btnDelete" class="shadow-xs text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
									    style="background-color: #848484;">
									    삭제
									</button>	
								</div>
								<!-- 일반모드 끝 -->
								
								
								<!-- 수성모드 -->
								<div id="div2" style="display: none;">
									
									<button type="submit" id="btnConfirm" class="shadow-xs text-gray-600 active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
									    style="background-color: #FFFFF;" onclick="location.href='/updateNotice?ntcNo=${noticeVO.ntcNo}';">
									    확인
									</button>
							        <button type="button" id="btnCancel" class="shadow-xs text-white active:bg-indigo-600 font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 border border-[#848484] ease-linear transition-all duration-150"
									    style="background-color: #848484;">
									    취소
									</button>		
											
								</div>
								<!-- 수정모드 끝 -->
							</div>

							<sec:csrfInput />
						</form:form>
					</div>
					<hr style="boarder: 0px; height: 1px; color: white;">
					<br>
					<div class="pb-2 text-sm flex justify-between items-center">
						
						<form id="formComment" action="/manage/sugest/registCommentPost?${_csrf.parameterName}=${_csrf.token}"
							method="post" class="form-horizontal d-flex align-items-center">
								<!-- 어떤글에 -->
								<input type="text" name="bbsNo" id="bbsNo" value="${boardVO.bbsNo}"
									hidden />
								<!-- 누가 -->
								<input type="text" name="empNo" id="empNo" value="${empVO.empNo}"
									hidden />
								<!-- 어떤 내용을 -->
								
								<input type="text" name="cmntCn" id="cmntCn" style="flex: 1; margin-right: 10px; height: 40px;"
									class="form-control form-control-sm border border-indigo-500 rounded-full placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="댓글 입력">
								<button type="submit"
										class="text-indigo-500 font-bold uppercase text-sm px-4 py-2 rounded-full border border-indigo-500 hover:bg-indigo-500 hover:text-white transition-all duration-150" style="height: 40px;">댓글등록</button>
							<sec:csrfInput />
						</form>
					</div>
					
<!-- 					<div class="col-12"> -->
<!-- 						<blockquote class="bluejeans" style="width: 100%; border-radius:0.15rem; "> -->
<!-- 							<h4><span class="Cbluejeans">댓글목록</span></h4> -->
<!-- 						</blockquote> -->
<!-- 					</div>	 -->
							<div class="col-12" id="divReplyList"">
								<c:forEach var="commentVO" items="${commentVOList}" varStatus="stat">
									<div class="post">
									
										<div style="display: flex; align-items: center;">
											<span> <img src="/resources/images/tiles/karina.gif" class="img-circle" style="width: 30px; height: 30px; margin: 5px;"></span>
											<h2  style="margin: 0; margin-left: 5px;">${commentVO.nm}</h2>
										</div>
										<p style="margin-left: 45px;">
											<span >${commentVO.cmntCn}</span>
											<div  class="flex justify-end p-1"  style="gap: 10px;">
												<c:if test="${empVO.empNo==commentVO.empNo}">
													<button type="button" data-cmnt-no="${commentVO.cmntNo}"
														data-toggle="modal" data-target="#modalUpdateReply"
														 class="clsUpdate clsUpdate shadow-xs text-blue-500 font-bold uppercase text-sm px-3 py-1.5 rounded-full border border-blue-500 hover:border-blue-500 hover:text-blue-500"
										    				style="background-color: white;" >수정</button>
													<button type="button" data-cmnt-no="${commentVO.cmntNo}"
														class="clsDelete shadow-xs text-pink-500 font-bold uppercase text-sm px-3 py-1.5 rounded-full border border-pink-500 hover:border-pink-500 hover:text-pink-500"
										    				style="background-color: white;">삭제</button>
												</c:if>
											</div>
										</p>
									</div>
								</c:forEach>
							</div>
					
				</div>
			</div>
		</div>
	</div>




	<div class="modal fade" id="modalUpdateReply">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">댓글수정</h4>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p>
						<input type="text" id="modalRepNo" /> <input type="text"
							id="modalRepContent" class="form-control form-control-sm"
							placeholder="댓글등록" required "/>
					</p>

				</div>
				<div class="modal-footer justify-content-between">
					<button type="button" id="modalHide" class="btn btn-default"
						data-dismiss="modal">Close</button>
					<button type="button" id="idUpdate" class="btn btn-primary">저장</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>



</body>
</html>