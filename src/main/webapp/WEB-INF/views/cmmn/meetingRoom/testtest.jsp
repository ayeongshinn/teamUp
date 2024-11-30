<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회의실 예약</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<style>
    body {
        font-family: Arial, sans-serif;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: center;
        font-size: 14px;
    }
    th {
        background-color: #f4f4f4;
    }
    td {
        cursor: pointer;
    }
    .modal {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 300px;
        padding: 20px;
        background-color: white;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.25);
        border-radius: 8px;
        z-index: 10;
    }
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 5;
    }
    .modal-header {
        font-weight: bold;
        margin-bottom: 10px;
    }
    .modal-body {
        margin-bottom: 20px;
    }
    .close-modal {
        display: inline-block;
        padding: 8px 16px;
        background-color: #4E7DF4;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        text-align: center;
    }
</style>
</head>
<body>

<h3>회의실 예약</h3>
<p>회의실 예약을 위한 시간표입니다. 원하는 시간 셀을 클릭하여 예약을 진행하세요.</p>

<table id="schedule">
    <thead>
        <tr>
            <th>시간</th>
            <th>회의실 1</th>
            <th>회의실 2</th>
            <th>회의실 3</th>
            <th>회의실 4</th>
            <th>회의실 5</th>
        </tr>
    </thead>
    <tbody>
        <!-- 시간표는 예시로 8:00부터 18:00까지 구성 -->
        <% for (let hour = 8; hour <= 18; hour++) { %>
        <tr>
            <td><%= hour %>:00</td>
            <td class="schedule-cell" data-time="<%= hour %>:00" data-room="회의실 1"></td>
            <td class="schedule-cell" data-time="<%= hour %>:00" data-room="회의실 2"></td>
            <td class="schedule-cell" data-time="<%= hour %>:00" data-room="회의실 3"></td>
            <td class="schedule-cell" data-time="<%= hour %>:00" data-room="회의실 4"></td>
            <td class="schedule-cell" data-time="<%= hour %>:00" data-room="회의실 5"></td>
        </tr>
        <% } %>
    </tbody>
</table>

<div class="modal-overlay"></div>

<div class="modal" id="reservationModal">
    <div class="modal-header">회의실 예약</div>
    <div class="modal-body">
        <p><span id="selectedTime"></span>에 <span id="selectedRoom"></span> 예약을 진행합니다.</p>
        <label for="reservationContent">예약 내용:</label><br>
        <input type="text" id="reservationContent" style="width: 100%;" placeholder="내용을 입력하세요">
    </div>
    <button class="close-modal" id="saveReservation">예약</button>
</div>

<script>
$(document).ready(function() {
    // 테이블 셀 클릭 이벤트
    $('.schedule-cell').on('click', function() {
        var time = $(this).data('time');
        var room = $(this).data('room');
        
        $('#selectedTime').text(time);
        $('#selectedRoom').text(room);
        $('#reservationModal').fadeIn();
        $('.modal-overlay').fadeIn();
    });
    
    // 예약 버튼 클릭 시
    $('#saveReservation').on('click', function() {
        var content = $('#reservationContent').val();
        if (content === "") {
            Swal.fire("예약 내용을 입력해주세요.");
            return;
        }
        
        Swal.fire("예약이 완료되었습니다.", "내용: " + content, "success");
        $('#reservationModal').fadeOut();
        $('.modal-overlay').fadeOut();
    });

    // 모달 외부 클릭 시 닫기
    $('.modal-overlay').on('click', function() {
        $('#reservationModal').fadeOut();
        $('.modal-overlay').fadeOut();
    });
});
</script>

</body>
</html>
