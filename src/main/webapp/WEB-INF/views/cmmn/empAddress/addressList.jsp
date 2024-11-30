<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 로그인 후 정보 확인 시작 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!-- 로그인 후 정보 확인 끝 -->

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/motion-tailwind.css"
	rel="stylesheet">
<link rel="stylesheet" href="https://horizon-tailwind-react-corporate-7s21b54hb-horizon-ui.vercel.app/static/css/main.d7f96858.css" />
<script src="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/motion-tailwind/scripts/plugins/countup.min.js"></script>
<script src="/resources/adminlte/plugins/sweetalert2/sweetalert2.min.js"></script>
<link rel="stylesheet" href="/resources/adminlte/plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css">
 
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

#addressDiv::-webkit-scrollbar {
	display: none; /* Chrome, Safari */
}

#addressDiv {
	-ms-overflow-style: none; /* IE and Edge */
	scrollbar-width: none; /* Firefox */
}

.aHover:hover {
    font-weight: bold;
    color: #4E7DF4;
}

.quickMenu:hover {
    font-weight: bold !important;
    color: #4E7DF4 !important;
}

.quickMenu:hover i {
    color: #4E7DF4 !important; /* 아이콘 색상 덮어쓰기 */
}

.sortName:hover {
    font-weight: bold;
    color: #4E7DF4;
}

.custom-nav-link {
    display: flex;
    align-items: center;
    padding: 5px;
    color: #424242;
    text-decoration: none;
}

.custom-nav-link i, 
.custom-nav-link p {
    color: #424242;
    transition: color 0.3s ease;
}

.custom-nav-link:hover i, 
.custom-nav-link:hover p {
    color: #4E7DF4 !important;/* hover 시 텍스트와 아이콘의 색상을 파란색으로 변경 */
}

#closeSrvyBtn, #deleteBtn {
	background-color: white;
	color: #848484;
}

#closeSrvyBtn:hover, #deleteBtn:hover {
	background-color: #848484;
	color: white;
}

/* 모달 배경 */
.modal-background {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5); /* 배경 어둡게 */
    display: none; /* 기본적으로 숨김 */
    z-index: 999; /* 상단에 보이도록 */
}

/* 모달 창 */
#profileCard {
    position: relative;
    margin: 100px auto;
    max-width: 500px;
    background-color: white;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    z-index: 1000;
}

.content {
	background-color : white;
}
</style> 


<script type="text/javascript">

//부서 클릭 시 해당 부서로 이동
function navigateToDept(deptCd) {
    window.location.href = '/addressList?deptCd=' + deptCd + '&currentPage=1&keyword=';
}

//사원 목록을 숨기고 프로필 카드
function detailClick() {
    // 클릭한 요소의 부모 div에서 data-* 속성 값 가져오기
    var empNm = $(this).closest('div').data('empnm');
    var deptNm = $(this).closest('div').data('deptnm');
    var jbgdNm = $(this).closest('div').data('jbgdnm');
    var email = $(this).closest('div').data('email');
    var tel = $(this).closest('div').data('tel');
    var photo = $(this).closest('div').data('photo');
    var intrcn = $(this).closest('div').data('intrcn');

    // 사원 목록 숨기고 프로필 카드 보여주기
    document.getElementById("addressDiv").style.display = "none";
    document.getElementById("profileCard").style.display = "block";

    // 프로필 카드에 동적으로 값 설정
    if (photo) {
        $('#profileCard img').attr('src', 'data:image/png;base64,' + photo);
    } else {
        $('#profileCard img').attr('src', 'https://github.com/creativetimofficial/soft-ui-dashboard-tailwind/blob/main/build/assets/img/team-2.jpg?raw=true');
    }

    $('#profileNm').text(empNm); // 사원명 설정
    $('#profileDept').text('( ' + deptNm + ', ' + jbgdNm + ' )'); // 부서명, 직급 설정
    $('#profileTel').text('T. ' + tel.substring(0, 3) + '-' + tel.substring(3, 7) + '-' + tel.substring(7, 11)); // 전화번호 설정
    $('#profileEmail').text('E. ' + email); // 이메일 설정
    $('#profileIntrcn').text(intrcn ? intrcn : '한 줄 소개가 없습니다.'); // 한 줄 소개 설정
}


//프로필 카드를 숨기고 사원 목록
function closeProfile() {
    document.getElementById("profileCard").style.display = "none";
    document.getElementById("addressDiv").style.display = "block";
}

$(document).ready(function(){
	// 모든 토글 링크에 이벤트 리스너 추가
	document.querySelectorAll('.toggleCustomNav').forEach(function(toggleLink) {
	    toggleLink.addEventListener('click', function(e) {
	        e.preventDefault(); // 기본 링크 동작 방지

	        var targetId = this.getAttribute('data-target');
	        var customNavTreeView = document.getElementById(targetId);
	        var toggleIcon = this.querySelector('.custom-toggle-icon');

	        // 메뉴 열고 닫기
	        if (customNavTreeView.style.display === "none" || customNavTreeView.style.display === "") {
	            customNavTreeView.style.display = "block"; // 열기
	            toggleIcon.classList.remove("fa-angle-right");
	            toggleIcon.classList.add("fa-angle-down"); // 아이콘을 아래로 변경
	        } else {
	            customNavTreeView.style.display = "none"; // 닫기
	            toggleIcon.classList.remove("fa-angle-down");
	            toggleIcon.classList.add("fa-angle-right"); // 아이콘을 오른쪽으로 변경
	        }
	    });
	});
		
	// '전체 선택' 체크박스 클릭 시 모든 체크박스를 선택 또는 해제
	document.getElementById('allSelecet').addEventListener('change', function() {
	    const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]'); // tbody 안의 모든 체크박스 선택
	    checkboxes.forEach((checkbox) => {
	        checkbox.checked = this.checked; // 상단 체크박스 상태에 따라 하위 체크박스 상태 설정
	    }); 
	});

});

</script>


<!-- 주소록 :: 장영원 -->
<div class="sidebar-mini sidebar-closed sidebar-collapse">
	<div class="flex flex-row h-screen antialiased text-gray-800" style="height: 90vh;">
		<div class="w-1/5 flex-shrink-0 bg-white p-6" style="border-right: 1px solid #e0e0e0;">
			<div class="p-2 mt-6 mb-12">
				<h3 class="text-lg font-semibold text-slate-800">
					<a href="/addressList">주소록</a>
				</h3>
				<p class="text-slate-500">사원들의 연락처를 쉽게 찾고 관리하세요</p>
			</div>
			
			        
			<div class="mt-6 ">
				<input type="button" value="연락처 추가" class="w-full h-10 px-3 py-2 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400" />
			    <nav class="mt-6">
				    <ul class="custom-nav custom-nav-pills custom-nav-sidebar flex-column">
				        <li class="custom-nav-header"><hr style="margin: 0px; border: 0px; height:1px; color: white;"></li>
				        
				        <li class="custom-nav-item mb-2">
				            <a href="#" class="custom-nav-link toggleCustomNav" data-target="customNavTreeView1">
				                <i class="left fas fa-angle-right custom-toggle-icon mr-2" data-target="customNavTreeView1" style="color:#424242; vertical-align: middle;"></i>
				                <p>공용 주소록</p>
				            </a>
				            <ul class="custom-nav-treeview" id="customNavTreeView1" style="display: none;">
				                <li class="custom-nav-item">
				                    <a href="/addressList" class="custom-nav-link ml-2">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;teamUp</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="/addressList" class="custom-nav-link ml-2 text-gray-500">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;+ 연락처 주소록 추가</p>
				                    </a>
				                </li>
				            </ul>
				        </li>
						
				        <li class="custom-nav-item mb-2">
				            <a href="#" class="custom-nav-link toggleCustomNav" data-target="customNavTreeView2">
				                <i class="left fas fa-angle-right custom-toggle-icon mr-2" data-target="customNavTreeView2" style="color:#424242; vertical-align: middle;"></i>
				                <p>부서 주소록</p>
				            </a>
				            <ul class="custom-nav-treeview" id="customNavTreeView2" style="display: none;">
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2" onclick="navigateToDept('A17-001')">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;경영진</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2" onclick="navigateToDept('A17-002')">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;기획부서</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2" onclick="navigateToDept('A17-003')">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;관리부서</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2" onclick="navigateToDept('A17-004')">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;영업부서</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2" onclick="navigateToDept('A17-005')">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;인사부서</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="/addressList" class="custom-nav-link ml-2 text-gray-500">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;+ 연락처 주소록 추가</p>
				                    </a>
				                </li>
				            </ul>
				        </li>
				
				        <li class="custom-nav-item mb-2">
				            <a href="#" class="custom-nav-link toggleCustomNav" data-target="customNavTreeView3">
				                <i class="left fas fa-angle-right custom-toggle-icon mr-2" data-target="customNavTreeView3" style="color:#424242; vertical-align: middle;"></i>
				                <p>개인 주소록</p>
				            </a>
				            <ul class="custom-nav-treeview" id="customNavTreeView3" style="display: none;">
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;김다희</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;박수빈</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;신아영</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;신지</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;이재현</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;정지훈</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="#" class="custom-nav-link ml-2">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;장영원</p>
				                    </a>
				                </li>
				                <li class="custom-nav-item">
				                    <a href="/addressList" class="custom-nav-link ml-2 text-gray-500">
				                        <p style="font-size: 15px;margin-left: 20px;">&ensp;+ 연락처 주소록 추가</p>
				                    </a>
				                </li>
				            </ul>
				        </li>
				    </ul>
				</nav>
			</div>
		</div>
		
		<div class="flex flex-col h-full w-full bg-white px-4 py-6">
		    <div class="flex flex-col h-full overflow-hidden">
		        <!-- 주소록 제목 -->
		        <div class="flex flex-row justify-between mb-4 items-center">
				    <h3 class="text-lg font-semibold text-slate-800"></h3>
					<form id="addressList" action="/addressList">
					    <div class="w-full max-w-sm min-w-[200px] relative">
					        <div class="relative">
					        	<input type="hidden" name="deptCd" value="${param.deptCd }"/>
					            <input type="text" name="keyword" value="${param.keyword}"
					                class="bg-white w-full pr-11 h-10 pl-3 py-2 bg-transparent placeholder:text-slate-400 text-slate-700 text-sm border border-slate-200 rounded transition duration-200 ease focus:outline-none focus:border-slate-400 hover:border-slate-400"
					                placeholder="사원명을 입력하세요." />
					            <button type="submit" class="absolute h-8 w-8 right-1 top-1 my-auto px-2 flex items-center bg-white rounded">
					                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-8 h-8 text-slate-600">
					                    <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"/>
					                </svg>
					            </button>
					        </div>
					    </div>
				    </form>
				</div>
					
		        <!-- 테이블 영역 -->
		        <div id="addressDiv" class="flex-grow overflow-y-auto items-center">
					<div class="flex p-2 mb-2">
						<div class="mr-4 quickMenu">
							<button>
								<i class="fa-solid fa-plus mr-1" style="color:#1F2D3D;"></i>빠른 등록
							</button>
						</div>
						<div class="mr-4 quickMenu">
							<button class="mr-4 quickMenu">
								<i class="fa-solid fa-envelope mr-1" style="color:#1F2D3D;"></i>메일 발송
							</button>
						</div>
						<div class="mr-4 quickMenu">
							<button class="mr-4 quickMenu">
								<i class="fa-solid fa-trash-can mr-1" style="color:#1F2D3D;"></i>삭제
							</button>
						</div>
						<div class="mr-4 quickMenu">
							<button class="mr-4 quickMenu">
								<i class="fa-regular fa-copy mr-1" style="color:#1F2D3D;"></i>주소록 복사
							</button>
						</div>
						<div class="mr-4 quickMenu">
							<button class="mr-4 quickMenu">
								<i class="fa-solid fa-users-gear mr-1" style="color:#1F2D3D;"></i>그룹 관리
							</button>
						</div>
					</div>
					
		        	<div class="flex p-2 items-center"> 
					    <p class="font-bold text-gray-500 sortName" style="text-decoration: underline; color:#4E7DF4">전체</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㄱ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㄴ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㄷ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㄹ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅁ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅂ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅅ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅇ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅈ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅊ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅋ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅌ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅍ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;ㅎ</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;a-z</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest" style="font-size:15px;">&ensp;&ensp;0-9</p>
					    <p class="font-thin text-gray-500 sortName tracking-widest">&ensp;&ensp;etc</p>
					</div>
		            <table class="table table-hover text-nowrap items-center" style="text-align: center;">
		                <thead>
		                    <tr class="justify-center">
		                        <th style="width: 10px; vertical-align: middle;"><input type="checkbox" id="allSelecet" /></th>
		                        <th>사원명</th>
		                        <th>부서</th>
		                        <th>직급</th>
		                        <th>휴대폰</th>
		                        <th>이메일</th>
		                        <th>한 줄 소개</th>
		                    </tr>
		                </thead>
		                <tbody>
		                    <c:forEach var="employeeVO" items="${employeeVOList}">
		                        <tr>
		                        	<td style="vertical-align: middle;">
		                        		<input type="checkbox" class="justify-center" />
		                        	</td>
		                            <td>
									    <div class="flex items-center">
									        <div class="flex w-10 h-10 mx-4">
									            <img class="w-full h-full rounded-full mx-2 lazyload" src="data:image/png;base64,${employeeVO.proflPhoto}" alt="프로필사진" />
									        </div>
									        <div data-empno="${employeeVO.empNo}"
									             data-empnm="${employeeVO.empNm}"
									             data-deptnm="${employeeVO.deptNm}"
									             data-jbgdnm="${employeeVO.jbgdNm}"
									             data-intrcn="${employeeVO.empIntrcn}"
									             data-email="${employeeVO.empEmlAddr}"
									             data-tel="${employeeVO.empTelno}"
									             data-photo="${employeeVO.proflPhoto}">
									            <p class="text-gray-900 whitespace-no-wrap aHover" onclick="detailClick.call(this);">
									                <c:set var="word" value="<span style='color:#4E7DF4;'>${param.keyword}</span>" />
									                ${fn:replace(employeeVO.empNm, param.keyword, word)}
									            </p>
									        </div>
									    </div>
									</td>
		                            <td class="text-gray-900" style="vertical-align: middle;">
	                            		${employeeVO.deptNm }
	                            	</td>
		                            <td class="text-gray-900" style="vertical-align: middle;">${employeeVO.jbgdNm }</td>
		                            <td class="text-gray-900" style="vertical-align: middle;">
		                            	${fn:substring(employeeVO.empTelno, 0, 3)}-${fn:substring(employeeVO.empTelno, 3, 7)}-${fn:substring(employeeVO.empTelno, 7, 11)}
		                            </td>
		                            <td class="text-gray-900" style="vertical-align: middle;">${employeeVO.empEmlAddr }</td>
		                            <td class="text-gray-900" style="text-align: left; vertical-align: middle;">${employeeVO.empIntrcn }</td>
		                        </tr>
		                    </c:forEach>
		                </tbody>
		            </table>
		
		            <!-- 페이지 네비게이션 -->
		            <div class="flex justify-center mt-4">
		                <c:if test="${articlePage.total == 0 }">
		                    <p style="margin: 40px; text-align: center;">데이터가 존재하지 않습니다.</p>
		                </c:if>
		
		                <c:if test="${articlePage.total != 0 }">
		                    <nav aria-label="Page navigation">
							    <ul class="inline-flex space-x-2">
							        <!-- startPage가 5보다 클 때만 [이전] 활성화 -->
							        <li>
							            <c:if test="${articlePage.startPage gt 5}">
							                <a href="/addressList?deptCd=${param.deptCd}&currentPage=${articlePage.startPage-5}&keyword=${param.keyword}" style="color:#4E7DF4"
							                   class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
							                    <svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
							                        <path d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" 
							                              clip-rule="evenodd" fill-rule="evenodd">
							                        </path>
							                    </svg>
							                </a>
							            </c:if>
							        </li>
							
							        <!-- 총 페이징 -->
							        <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
							            <c:if test="${articlePage.currentPage == pNo}">
							                <li>
							                    <button id="button-${pNo}" onclick="javascript:location.href='/addressList?deptCd=${param.deptCd}&currentPage=${pNo}&keyword=${param.keyword}';"
							                            class="w-10 h-10 text-white transition-colors duration-150 bg-indigo-600 border border-r-0 border-indigo-600 rounded-full focus:shadow-outline"
							                            style="background-color:#4E7DF4">
							                        ${pNo}
							                    </button>
							                </li>
							            </c:if>
							
							            <c:if test="${articlePage.currentPage != pNo}">
							                <li>
							                    <button id="button-${pNo}" onclick="javascript:location.href='/addressList?deptCd=${param.deptCd}&currentPage=${pNo}&keyword=${param.keyword}';"
							                            class="w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100"
							                            style="color:#4E7DF4">
							                        ${pNo}
							                    </button>
							                </li>
							            </c:if>
							        </c:forEach>
							
							        <!-- endPage < totalPages일 때만 [다음] 활성화 -->
							        <li>
							            <c:if test="${articlePage.endPage lt articlePage.totalPages}">
							                <a href="/addressList?deptCd=${param.deptCd}&currentPage=${articlePage.startPage + 5}&keyword=${param.keyword}" 
							                   style="color:#4E7DF4"
							                   class="flex items-center justify-center w-10 h-10 text-indigo-600 transition-colors duration-150 rounded-full focus:shadow-outline hover:bg-indigo-100">
							                    <svg class="w-4 h-4 fill-current" viewBox="0 0 20 20">
							                        <path d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" 
							                              clip-rule="evenodd" fill-rule="evenodd">
							                        </path>
							                    </svg>
							                </a>
							            </c:if>
							        </li>
							    </ul>
							</nav>
		                </c:if>
		            </div>
		        </div>
		        
		        <!-- 상세보기 영역 -->
		        <div id="profileCard" class="relative max-w-md mx-auto md:max-w-2xl min-w-0 break-words bg-white w-full mb-6 shadow-lg rounded-xl mt-16" style="display: none; margin-top: 70px;">
				    <button id="closeDetail" onclick="closeProfile()"
						class="justify-end ml-2 mt-1 bg-white rounded-full p-2 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500">
						<svg class="h-4 w-4" style="color: #A3AED0"
							xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
		                	<path stroke-linecap="round" stroke-linejoin="round"
								stroke-width="2" d="M6 18L18 6M6 6l12 12" />
						</svg>
					</button>
				    <div class="px-6 pt-10">
				        <div class="flex flex-wrap justify-center">
				            <div class="w-full flex justify-center">
				                <div class="relative">
				                    <img src="https://github.com/creativetimofficial/soft-ui-dashboard-tailwind/blob/main/build/assets/img/team-2.jpg?raw=true" class="shadow-xl rounded-full align-middle border-none absolute -m-16 -ml-20 lg:-ml-16 max-w-[150px]"/>
				                </div>
				            </div>
				            <div class="w-full text-center mt-20">
				            </div>
				        </div>
				        <div class="text-center" style="margin-top: 50px;">
				            <h3 id="profileNm" class="text-2xl text-slate-700 font-bold leading-normal mb-1">사원명</h3>
				            <div id="profileDept" class="text-xs mt-0 mb-8 text-slate-400 font-bold uppercase">
				                (기획부서, 사원)
				            </div>
				            
				            <p id="profileTel" class="font-light leading-relaxed text-slate-600 mb-2">T. 010-0000-0000</p>
                    		<p id="profileEmail" class="font-light leading-relaxed text-slate-600 mb-4">E. example@email.com</p>
				        </div>
				        <div class="mt-6 py-6 border-t border-slate-200 text-center">
				            <div class="flex flex-wrap justify-center">
				                <div class="w-full px-4">
				                    <p id="profileIntrcn" class="font-light leading-relaxed text-slate-600 mb-4">한줄 소개 입니다</p>
				                </div>
				            </div>
				        </div>
				        
				        <div class="flex justify-center mb-5">
							<div class="flex flex-col items-center text-blue-500 hover:text-blue-700 mx-3 cursor-pointer"
								style="color: #4E7DF4;">
								<i class="fa-solid fa-comment-dots mb-1"
									style="color: #4E7DF4; vertical-align: middle;"></i> <span>메신저</span>
							</div>
			
							<div
								class="flex flex-col items-center text-blue-500 hover:text-blue-700 mx-3"
								style="color: #4E7DF4; cursor: pointer;"
								onclick="window.open('http://localhost/cmmn/mail/send', '메일', 'width=900,height=900');">
								<i class="fa-solid fa-envelope mb-1"
									style="color: #4E7DF4; vertical-align: middle;"></i> <span>메일</span>
							</div>
						</div>
				    </div>
				</div>
				<!-- 상세보기 끝 -->
		    </div>
		</div>
	</div>
</div>



