<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>

<style>
	.sidebar .nav-link {
	  color: #9F9F9F !important;
	}
	
	.sidebar .nav-link:hover {
	  background-color: #f4f4f4 !important;
	  transform: scale(1.01) !important;
	  color: #4E7DF4 !important;
	}
	
	.sidebar .nav-link:hover i {
	  color: #4E7DF4 !important;
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
</style>

<script type="text/javascript">
$(document).ready(function() {
	
	let empNo = $('#empNo').data('empno');
	console.log("empNo: " + empNo);
	
    // Ajax를 통해 사원 정보 가져오기
    $.ajax({
        url: '/employee/getDetail',
        type: 'post',
        dataType:"json",
        data : {empNo:empNo},
        beforeSend: function(xhr) {
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 포함
        },
        success: function(empVO) {
			console.log("로그인한 사원의 정보 : ", empVO);
			
			// 사원의 deptCd 값을 기준으로 HTML 삽입
            if (empVO.deptCd === 'A17-001') {	//경영진
                $('#menuContainer').append(`
                    <ul class="nav nav-treeview">
                    
                        <li class="nav-item">
                            <a href="/mngmt/mnHome" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;부서별 업무 조회</p>
                            </a>
                        </li>
                        
                    </ul>
                `);
            } else if (empVO.deptCd === 'A17-002') {	//기획부서
                $('#menuContainer').append(`
                    <ul class="nav nav-treeview">
                		<li class="nav-item">
	                        <a href="/taskDiary/list" class="nav-link">
	                            <p style="font-size: 15px;">&ensp;&ensp;&ensp;업무 일지</p>
	                        </a>
                   		</li>	
                        <li class="nav-item">
                            <a href="/noticeListN" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;공지사항 관리</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/surveyList" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;설문 관리</p>
                            </a>
                        </li>
                    </ul>
                `);
            } else if (empVO.deptCd === 'A17-003') {	//관리부서
                $('#menuContainer').append(`
                    <ul class="nav nav-treeview">
                		<li class="nav-item">
                        <a href="/taskDiary/list" class="nav-link">
                            <p style="font-size: 15px;">&ensp;&ensp;&ensp;업무 일지</p>
                        </a>
                    	</li>
                        <li class="nav-item">
                            <a href="/manage/sugest/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;건의사항 관리</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/fixtures/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;비품 관리</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/car/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;법인차량 관리</p>
                            </a>
                        </li>
                    </ul>
                `);
            } else if (empVO.deptCd === 'A17-004') {	//영업부서
                $('#menuContainer').append(`
                    <ul class="nav nav-treeview">
                		<li class="nav-item">
	                        <a href="/taskDiary/list" class="nav-link">
	                            <p style="font-size: 15px;">&ensp;&ensp;&ensp;업무 일지</p>
	                        </a>
	                    </li>
                        <li class="nav-item">
                            <a href="/counterparty/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;거래처 관리</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/customer/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;고객 관리</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/businessProgress/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;영업 진척도 관리</p>
                            </a>
                        </li>
                    </ul>
                `);
            } else if (empVO.deptCd === 'A17-005') {	//인사부서
                $('#menuContainer').append(`
                    <ul class="nav nav-treeview">
                		<li class="nav-item">
	                        <a href="/taskDiary/list" class="nav-link">
	                            <p style="font-size: 15px;">&ensp;&ensp;&ensp;업무 일지</p>
	                        </a>
	                    </li>
                        <li class="nav-item">
                            <a href="/employee/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;사원 관리</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/hrVacation/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;휴가 관리</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/salaryDetails/list" class="nav-link">
                                <p style="font-size: 15px;">&ensp;&ensp;&ensp;급여명세서 관리</p>
                            </a>
                        </li>
                    </ul>
                `);
            }
        },
        error: function() {
            console.log("사원 정보를 불러오는데 실패했습니다.", error);
        }
    });
    
    $("#mailSend").on("click", function() {
        var popupOptions = "width=900, height=900,scrollbars=yes,resizable=yes";
        window.open('/cmmn/mail/send', 'mailSendWindow', popupOptions);
    });
});

</script>

<aside class="main-sidebar sidebar-primary elevation-4" style="font-family:Pretendard-Regular; font-weight: lighter;">
	<input type="hidden" id="empNo" data-empno="${empVO.empNo}" />
	
	<!-- Brand Logo -->
	<div class="logoCls">
		<a href="/" class="logo-link">
			<img src="/resources/images/tiles/logo.png" alt="logo" class="logo-image">
			<span class="logo-text">teamUP</span>
		</a>
	</div>
	
	
	<!-- /.Brand Logo -->

	<!-- Sidebar -->
	<div class="sidebar overflow-y-auto" style="background-color: white;">

		<!-- Sidebar Menu -->
		<nav class="mt-2">
			<ul id="mainMenu" class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class with font-awesome or any other icon font library -->
               
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-comment-dots fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;&ensp;메신저</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/addressList" class="nav-link">
						<i class="fa-solid fa-address-book fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;&ensp;주소록</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/calendarList" class="nav-link">
						<i class="fa-regular fa-calendar fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;&ensp;캘린더</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/drive/driveList" class="nav-link">
						<i class="fa-solid fa-cloud-arrow-up fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;드라이브</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/videoList" class="nav-link">
						<i class="fa-solid fa-video fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;화상 회의</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/meetingRoom/listN" class="nav-link">
						<i class="fa-solid fa-people-line fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;회의실 예약</p>
					</a>
				</li>
				
				<li class="nav-item">
					<a href="/surveyList" class="nav-link">
						<i class="fa-solid fa-clipboard-list fa-lg" style="color:#424242; vertical-align: middle; margin-left: 5px;"></i>
						<p>&ensp;&ensp;설문 조사</p>
					</a>
				</li>

				<c:if test="${empVO.jbttlCd == 'A19-002'}">
					<li class="nav-item">
						<a href="/attendance/list" class="nav-link">
							<i class="fa-solid fa-clipboard-user fa-lg" style="color: #424242; vertical-align: middle; margin-left: 5px;"></i>
							<p>&ensp;&ensp;근태 관리</p>
						</a>
					</li>
				</c:if>
				
				<li class="nav-header"><hr style="margin: 0px; boarder : 0px; height:1px; color: white;"></li>
				
				<li class="nav-item">
					<a href="/cmmn/mail/list?empNo=${empVO.empNo}" class="nav-link">
						<i class="fa-solid fa-envelope fa-lg" style="color:#424242; vertical-align: middle; margin-left: 2px;"></i>
						<p>&ensp;메일</p>
						<i class="right fas fa-angle-left" style="color:#424242; vertical-align: middle;"></i>
					</a>
	               <ul class="nav nav-treeview">
	                  <li class="nav-item">
	                     <a href="javascript:void(0);" id="mailSend" class="nav-link">
	                        <p style="font-size: 15px;">&ensp;&ensp;&ensp;메일쓰기</p>
	                     </a>
	                  </li>
	                  <li class="nav-item">
	                     <a href="/cmmn/mail/list?empNo=${empVO.empNo}" class="nav-link">
	                        <p style="font-size: 15px;">&ensp;&ensp;&ensp;받은 메일함</p>
	                     </a>
	                  </li>
	                  
	                  <li class="nav-item">
	                     <a href="/cmmn/mail/sendList?empNo=${empVO.empNo}" class="nav-link">
	                        <p style="font-size: 15px;">&ensp;&ensp;&ensp;보낸 메일함</p>
	                     </a>
	                  </li>
	                  
	                  <li class="nav-item">
	                     <a href="/cmmn/mail/NReadMailList?empNo=${empVO.empNo}" class="nav-link">
	                        <p style="font-size: 15px;">&ensp;&ensp;&ensp;안읽은메일</p>
	                     </a>
	                  </li>
	                  
	                  <li class="nav-item">
	                     <a href="/cmmn/mail/showRPrs?empNo=${empVO.empNo}" class="nav-link">
	                        <p style="font-size: 15px;">&ensp;&ensp;&ensp;수신확인함</p>
	                     </a>
	                  </li>
	                  
	                  <li class="nav-item">
	                     <a href="/cmmn/mail/toMeList?empNo=${empVO.empNo}" class="nav-link">
	                        <p style="font-size: 15px;">&ensp;&ensp;&ensp;내게쓴메일</p>
	                     </a>
	                  </li>
	                  <li class="nav-item">
	                     <a href="/cmmn/mail/bookMarkList?empNo=${empVO.empNo}" class="nav-link">
	                        <p style="font-size: 15px;">&ensp;&ensp;&ensp;즐겨찾기메일</p>
	                     </a>
	                  </li>
	                  <li class="nav-item">
	                     <a href="/cmmn/mail/delList?empNo=${empVO.empNo}" class="nav-link">
	                        <p style="font-size: 15px;">&ensp;&ensp;&ensp;휴지통</p>
	                     </a>
	                  </li>
	               </ul>
				</li>
				
				<li class="nav-header"><hr style="margin: 0px; boarder : 0px; height:1px; color: white;"></li>
				
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-user-group fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;커뮤니티
							<i class="right fas fa-angle-left" style="color:#424242; vertical-align: middle;"></i>
						</p>
					</a>
					
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="/noticeList" class="nav-link">
								<p style="font-size: 15px;">&ensp;&ensp;&ensp;공지사항</p>
							</a>
						</li>
						
						<li class="nav-item">
							<a href="/manage/sugest/list" class="nav-link">
								<p style="font-size: 15px;">&ensp;&ensp;&ensp;건의사항</p>
							</a>
						</li>
						
						<li class="nav-item">
							<a href="/usedGoods/list" class="nav-link">
								<p style="font-size: 15px;">&ensp;&ensp;&ensp;중고 거래</p>
							</a>
						</li>
						
						<li class="nav-item">
							<a href="#" class="nav-link">
								<p style="font-size: 15px;">&ensp;&ensp;&ensp;동호회</p>
							</a>
						</li>
						
						<li class="nav-item">
							<a href="/docUpload/list" class="nav-link">
								<p style="font-size: 15px;">&ensp;&ensp;&ensp;자료실</p>
							</a>
						</li>
					</ul>
				</li>
				
				<li class="nav-header"><hr style="margin: 0px; boarder : 0px; height:1px;"></li>
				
				<li class="nav-item">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-user-check fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;결재 관리
							<i class="right fas fa-angle-left" style="color:#424242; vertical-align: middle;"></i>
						</p>
					</a>
					
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="/approval/approvalRegist" class="nav-link">
								<p style="font-size: 15px;">&ensp;&ensp;&ensp;기안서 작성</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="/approval/approvalList" class="nav-link">
								<p style="font-size: 15px;">&ensp;&ensp;&ensp;결재 요청 관리</p>
							</a>
						</li>
						<li class="nav-item">
							<a href="/approval/approvalRequestList" class="nav-link">
								<p style="font-size: 15px;">&ensp;&ensp;&ensp;결재 문서함</p>
							</a>
						</li>
					</ul>
				</li>
				
				<li class="nav-header"><hr style="margin: 0px; boarder : 0px; height:1px;"></li>
				
				<li class="nav-item" id="menuContainer">
					<a href="#" class="nav-link">
						<i class="fa-solid fa-folder fa-lg" style="color:#424242; vertical-align: middle;"></i>
						<p>&ensp;부서 업무
							<i class="right fas fa-angle-left" style="color:#424242; vertical-align: middle;"></i>
						</p>
					</a>
				</li>
				
			</ul>
		</nav>
		<!-- /.sidebar-menu -->
	</div>
	<!-- /.sidebar -->
</aside>