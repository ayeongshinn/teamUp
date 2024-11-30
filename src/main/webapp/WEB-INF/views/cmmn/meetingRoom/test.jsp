<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<!DOCTYPE html>
<html lang="ko">
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
</style>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회의실 예약 타임라인</title>

    <!-- DayPilot 라이브러리 로드 -->
    <script src="https://cdn.daypilot.org/daypilot-all.min.js"></script>

    <!-- DayPilot 스타일 -->
    <style>
        #dp {
            width: 100%;
            height: 350px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <!-- 타임라인을 렌더링할 div -->
    <div id="dp"></div>

</body>
    <!-- 스크립트 추가 -->
    <script>
        const dp = new DayPilot.Scheduler("dp", {
            timeHeaders: [
                {groupBy: "Year"},
                {groupBy: "Month"},
                {groupBy: "Cell", format: "d"}
            ],
            scale: "Manual",
            timeline: createTimeline(),
            treeEnabled: true,
            resources: [
                {name: "Room A", id: "A"},
                {name: "Room B", id: "B"},
                {name: "Room C", id: "C"},
                {name: "Room D", id: "D"},
                {name: "Room E", id: "E"},
                {name: "Room F", id: "F"},
                {name: "Room G", id: "G"},
                {name: "Room H", id: "H"},
                {name: "Room I", id: "I"},
                {name: "Room J", id: "J"},
                {name: "Room K", id: "K"},
            ],
            onTimeRangeSelected: async args => {
                const modal = await DayPilot.Modal.prompt("New event name:", "Event");
                dp.clearSelection();
                if (modal.canceled) {
                    return;
                }
                dp.events.add({
                    start: args.start,
                    end: args.end,
                    id: DayPilot.guid(),
                    resource: args.resource,
                    text: modal.result
                });
                dp.message("Created");
            },
            onBeforeTimeHeaderRender: args => {
                if (args.header.level === 2) {
                    var duration = new DayPilot.Duration(args.header.start, args.header.end);
                    if (duration.totalDays() > 1) {
                        args.header.html = "";
                    }
                }
            },
            height: 350
        });
        dp.init();

        function createTimeline() {
            const timeline = [];
            const start = new DayPilot.Date("2025-03-01");
            for (let i = 0; i < 31; i++) {
                const day = {};
                day.start = start.addDays(i);
                day.end = day.start.addDays(1);
                timeline.push(day);
            }

            for (let i = 0; i < 3; i++) {
                const month = {};
                month.start = start.addDays(31).addMonths(i);
                month.end = month.start.addMonths(1);
                month.width = 100;
                timeline.push(month);
            }
            return timeline;
        }
    </script>
</html>



