<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- DayPilot 라이브러리 추가 -->
<script src="/resources/js/daypilot-all.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/Loopple/loopple-public-assets@main/riva-dashboard-tailwind/riva-dashboard.css">

<script type="text/javascript" src="/resources/js/jquery.min.js"></script> <!-- jQuery 먼저 로드 -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.rwdImageMaps/1.6/jquery.rwdImageMaps.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(function() {
        const dp = new DayPilot.Scheduler("dp", {
            startDate: "2024-03-01T00:00:00",  // 시작 시간: 0시
            endDate: "2024-03-01T23:59:59",  // 끝나는 시간: 23시 59분
            days: 1,  // 하루만 표시 (0시 ~ 23시까지)
            scale: "Hour",  // 시간 단위로 스케줄러 설정
            cellDuration: 60,  // 1시간 간격으로 셀을 나눔
            treeEnabled: true,
            cellHeight: 40,  // 셀 높이
            eventHeight: 30,  // 이벤트 높이
            headerHeight: 50,  // 헤더 높이
            theme: "scheduler_custom",  // 커스텀 테마
            resources: [
                {name: "회의실1", id: "A"},
                {name: "회의실2", id: "B"},
                {name: "회의실3", id: "C"},
                {name: "회의실4", id: "D"},
                {name: "회의실5", id: "E"},
                {name: "회의실6", id: "F"},
                {name: "회의실7", id: "G"},
                {name: "회의실8", id: "H"},
                {name: "회의실9", id: "I"},
                {name: "회의실10", id: "J"}
            ],
            separators: [
                {color: "red", location: DayPilot.Date.parse("2024-03-05", "yyyy-MM-ddTHH:mm:ss")}
            ],
            onTimeRangeSelected: async args => {
                const modal = await DayPilot.Modal.prompt("New event name:", "Event");
                const name = modal.result;
                dp.clearSelection();
                if (!name) return;
                const e = new DayPilot.Event({
                    start: args.start,
                    end: args.end,
                    id: DayPilot.guid(),
                    resource: args.resource,
                    text: name
                });
                dp.events.add(e);
                dp.message("Created");
            }
        });

        dp.init();
    }, 0);
});
    
    console.log("DayPilot", typeof DayPilot !== "undefined" ? "loaded" : "not loaded");
    
    document.addEventListener('DOMContentLoaded', function() {
        const dpElement = document.getElementById('dp');
        dpElement.style.overflowX = 'hidden';  // 가로 스크롤바 숨기기
    });
</script>


<style>
    @font-face {
        font-family: 'Pretendard-Regular';
        src: url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
        font-weight: 100;
        font-style: normal;
    }

    body {
        font-family: 'Pretendard-Regular', sans-serif;
    }

    /* 큰 네모 박스 */
    .outer-square {
        width: 30px;
        height: 30px;
        border: 1px solid #c0c0c0;
        border-radius: 8px;
        display: flex;
        justify-content: left;
        align-items: left;
        top: 0; /* 위에서부터의 거리 */
        left: 300px; /* 왼쪽에서 오른쪽으로 이동 */
        margin-right : 10px;
    }

    /* 체크박스 스타일 */
    .custom-checkbox input[type="checkbox"] {
        width: 15px;
        height: 15px;
        border: 2px solid #c0c0c0;
        border-radius: 5.5px;
        appearance: none;
        -webkit-appearance: none;
        cursor: pointer;
        margin-left:7px;
        margin-top : 7px;
    }

    /* 체크박스가 선택되었을 때의 스타일 */
    .custom-checkbox input[type="checkbox"]:checked {
        background-color:  #4E7DF4;
        position: relative;
    }

    #myRes {
        margin-top : 6px;
    }
    
	/* 셀 스타일 */
	.scheduler_custom_cell {
	    background-color: white !important; /* 셀 배경을 연한 회색으로 */
	    border-right: 1px solid black !important; /* 셀 간의 구분선 */
	    border-bottom: 1px solid black !important; /* 셀 하단 구분선 */
	}
	
	/* 선택된 셀 스타일 */
	.scheduler_custom_selected {
	    background-color: rgba(78, 125, 244, 0.3) !important; /* 선택된 셀의 배경색 */
	}
	
	/* 스케줄 코너 (DEMO 부분) */
	
	
	
	/* 시간 헤더 스타일 */
	.scheduler_custom_timeheader_scroll {
	    background-color: #F5F5FC !important;  /* 원하는 배경색 */
	    		border-top : 1px solid #6b6b6b;
		border-bottom : 1px solid #6b6b6b;
	    color: #6b6b6b !important;  /* 글자 색상 */
	    text-align: center;
	}
	
	.scheduler_custom_corner {
		border-top : 1px solid #6b6b6b;
		border-bottom : 1px solid #6b6b6b;
		height : 30px !important;
	}
	
	.scheduler_custom_divider.scheduler_custom_splitter {
				border-right : 1px solid #6b6b6b;
	}
	
	.scheduler_custom_timeheadergroup.scheduler_custom_timeheader_cell.scheduler_custom_timeheader_cell_last{
				    display: none !important;  /* 해당 요소를 숨깁니다 */
	}
	
	.scheduler_custom_timeheadercol.scheduler_custom_timeheader_cell{
				text-align : center;
	}
	
	.scheduler_custom_timeheader_scroll{
		height : 30px !important;
	}
	
	.scheduler_custom_timeheadercol.scheduler_custom_timeheader_cell{
		margin-top : -50px;
		height : 30px !important;
		border-right : 1px solid #6b6b6b; 
	}
	
	.scheduler_custom_timeheadercol_inner.scheduler_custom_timeheader_cell_inner {
		margin-top : 5px;
	}
	
	
	.scheduler_custom_scrollable{
		margin-top : -70px;
	}
	
	.scheduler_custom_rowheader_scroll {
		margin-top : 8px;
	}
	
	.scheduler_custom_rowheader {
		margin-top : -8px;
		border-bottom : 1px solid #6b6b6b;
	}
	
	.scheduler_custom_rowheader_inner {
		margin-top : 7px;
	}
	
	.scheduler_custom_timeheader_cell[data-hour="23"] {
    	display: none !important;  /* 11 PM 셀을 숨기기 */
	}

   #divImg1{
   	 position:absolute;
   	 width:90px;
   	 height:70px;
     background-color:blue;
   	 left:763px;
   	 top:377px;
   	 cursor:pointer;
   } 
</style>

<br>
<h1>회의실</h1>
<p><br></p>
<div style="display: flex; align-items: center;">
    <div class="outer-square">
        <div class="custom-checkbox">
            <input type="checkbox" id="checkbox1">
        </div>
    </div>
    <button id="myRes" class="bg-primary hover:bg-primaryActive text-white text-sm py-2 px-3 mr-2 mb-2 rounded-xl transition duration-300">
        내 예약
    </button>
</div>

<hr style="margin-top:10px;">
<br><br>

<!-- <div id="divImg1" onclick="javascript:alert('파란색 사각형 선택됨!');"></div> -->

<div style="width:1101px;height:340px;">
<!-- 	<img src="/resources/images/meetingRoom1100.png" alt="회의실 이미지" style="background-color:transparent;display: block;width:1100px;" /> -->
	<!-- Save for Web Slices (meetingRoom1100_2.png) -->
	<table width="1101" height="340" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="12">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_01.gif" width="1100" height="131" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="131" alt=""></td>
		</tr>
		<tr>
			<td colspan="10">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_02.gif" width="1016" height="28" alt=""></td>
			<td rowspan="2">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_03.png" width="54" height="59" alt=""></td>
			<td rowspan="10">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_04.gif" width="30" height="249" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="28" alt=""></td>
		</tr>
		<tr>
			<td rowspan="9">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_05.gif" width="215" height="221" alt=""></td>
			<td rowspan="3">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_06.gif" width="60" height="66" alt=""></td>
			<td colspan="8" rowspan="2">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_07.gif" width="741" height="42" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="31" alt=""></td>
		</tr>
		<tr>
			<td rowspan="8">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_08.gif" width="54" height="190" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="11" alt=""></td>
		</tr>
		<tr>
			<td rowspan="7">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_09.gif" width="204" height="179" alt=""></td>
			<td rowspan="2">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_10.gif" width="37" height="33" alt=""></td>
			<td rowspan="3">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_11.gif" width="34" height="68" alt="회의실" title="회의실" onclick="chk('11')" style="cursor:pointer;"></td>
			<td rowspan="3">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_12.gif" width="81" height="68" alt="탕비실" title="탕비실" onclick="chk('12')" style="cursor:pointer;"></td>
			<td rowspan="2">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_13.gif" width="35" height="33" alt=""></td>
			<td colspan="3" rowspan="4">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_14.gif" width="350" height="76" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="24" alt=""></td>
		</tr>
		<tr>
			<td rowspan="6">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_15.gif" width="60" height="155" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="9" alt=""></td>
		</tr>
		<tr>
			<td>
				<img src="/resources/images/meetingroom/meetingRoom1100_2_16.gif" width="37" height="35" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/meetingRoom1100_2_17.gif" width="35" height="35" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="35" alt=""></td>
		</tr>
		<tr>
			<td colspan="4" rowspan="4">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_18.gif" width="187" height="111" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="8" alt=""></td>
		</tr>
		<tr>
			<td rowspan="3">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_19.gif" width="7" height="103" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/meetingRoom1100_2_20.gif" width="32" height="34" alt=""></td>
			<td rowspan="3">
				<img src="/resources/images/meetingroom/meetingRoom1100_2_21.gif" width="311" height="103" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="34" alt=""></td>
		</tr>
		<tr>
			<td>
				<img src="/resources/images/meetingroom/meetingRoom1100_2_22.gif" width="32" height="35" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="35" alt=""></td>
		</tr>
		<tr>
			<td>
				<img src="/resources/images/meetingroom/meetingRoom1100_2_23.gif" width="32" height="34" alt=""></td>
			<td>
				<img src="/resources/images/meetingroom/&#xc2a4;&#xd398;&#xc774;&#xc11c;.gif" width="1" height="34" alt=""></td>
		</tr>
	</table>

	<!-- End Save for Web Slices -->

</div>
<!-- usemap="#meetingRoomMap" -->
<!-- <map name="meetingRoomMap" id="meetingRoomMap"> -->
    <!-- 사각형 영역 정의   916 - 832 = width / 469 - 404 = height -->
<!--     <area shape="rect" coords="832,404,916,469" alt="파란색 사각형" href="#" onclick="javascript:alert('파란색 사각형 선택됨!');"> -->
<!--     <area shape="rect" coords="0,0,1000,346" alt="파란색 사각형" href="#" onclick="javascript:alert('파란색 사각형 선택됨!');"> -->
<!-- </map> -->

<br><br>
<div id="dp" style="height: 500px;"></div>
<script type="text/javascript">
function chk(no){
	console.log("no : " + no);
}
</script>