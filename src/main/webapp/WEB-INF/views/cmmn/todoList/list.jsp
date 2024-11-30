<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/adminlte3/dist/css/adminlte.min.css">
<link rel="stylesheet" href="/todoList/style.css">

<head>
<title>TodoList</title>
<script type="text/javascript" src="./todo.js"></script>

<style type="text/css">

* {
    box-sizing: border-box;
}

h1 {
    margin: 0;
    margin-bottom: 12px;
}

.todo-container {
    max-width: 400px;
    width: 100%;
    background-color: #F9FAFC;
    text-align: center;
    padding: 20px;
    margin-top: 30px;
    margin-left: 30px;
    border-radius: 25px;
}

#inputField #todoInput {
    width: calc(100% - 45px);
    height:38px;
    border: 1px solid #eee;
    border-radius: 4px;
    padding: 10px;
}

#inputField #todoInput:focus {
    outline: none;
}

#inputField #addBtn {
    position: relative;
    width: 35px;
    height: 35px;
    border: none;
    background-color: #007bff;
    border-radius: 4px;
    cursor: pointer;
    vertical-align: middle;
}

#inputField #addBtn span {
    display: block;
    width: 2px;
    height: 15px;
    background-color: #F9FAFC;
    position: absolute;
    transform: translate(-50%,-50%);
    top: 50%;
    left: 50%;
}

#inputField #addBtn span:last-child {
    transform: translate(-50%,-50%) rotate(-90deg);
}

#todoList {
    list-style: none;
    margin: 0;
    padding: 10px;
    text-align: left;
}

#todoList li {
    padding: 10px 0;
    user-select: none;
}


.delete-btn-wrap button {
    cursor: pointer;
    border: none;
    border-radius: 8px;
    background-color: #007bff;
    color: #fff;
    padding: 8px;
}

#inputField {
    display: flex; /* 플렉스 박스로 배치 */
    margin-bottom: 20px; /* 아래쪽 마진 추가 */
}

#todoInput {
    flex-grow: 1; /* 입력 필드 확장 */
    padding: 10px; /* 패딩 추가 */
    border: 1px solid #ddd; /* 테두리 추가 */
    border-radius: 5px; /* 모서리 둥글게 */
    margin-right: 10px; /* 오른쪽 마진 추가 */
}

#addBtn {
    display: flex; /* 플렉스 박스 설정 */
    align-items: center; /* 수직 가운데 정렬 */
    justify-content: center; /* 수평 가운데 정렬 */
    padding: 10px; /* 버튼 패딩 */
    width: 35px;
    height: 35px;
    background-color: #28a745; /* 버튼 배경 색상 */
    color: white; /* 글씨 색상 */
    border: none; /* 테두리 제거 */
    border-radius: 5px; /* 모서리 둥글게 */
    cursor: pointer; /* 커서 포인터로 변경 */
    transition: background-color 0.3s; /* 호버 효과 */
}

#addBtn:hover {
    background-color: #218838; /* 호버 시 색상 변경 */
}

#todoList {
    list-style: none; /* 기본 목록 스타일 제거 */
    padding: 0; /* 패딩 제거 */
}

.thin-label {
    font-weight: 300; /* 글씨를 얇게 설정 */
    color: #333; /* 기본 글씨 색상 */
    margin-bottom: 10xp;
}

/* 완료된 항목의 label에만 취소선 추가 */
 .complete label { 
    color: gray; /* 완료 시 글씨 색상 회색으로 변경 */
    text-decoration: line-through; /* 완료 시 취소선 추가 */
 } 

/* li.complete 전체에는 취소선이 적용되지 않도록 설정 */
li.complete {
    text-decoration: none;
}  text-decoration: none;
}

.complete {
    padding: 5px; /* 패딩 추가 */
    border-radius: 5px; /* 모서리 둥글게 */
}

.todo-item {
        display: flex;              /* flexbox 사용 */
        justify-content: space-between;  /* 양쪽 끝에 요소를 배치 */
        align-items: center;         /* 수직으로 중앙 정렬 */
        padding: 8px 0;
        position: relative;
    }

   .todo-buttons {
        display: none; /* 기본적으로 숨김 */
        gap: 8px;
    }

    .todo-item:hover .todo-buttons {
        display: flex; /* 마우스를 올렸을 때 보이도록 설정 */
    }

    .edit-btn, .delete-btn {
        background-color: #f0f0f0;
        border: 1px solid #ccc;
        padding: 4px 8px;
        font-size: 12px;
        cursor: pointer;
    }

    .edit-btn:hover, .delete-btn:hover {
        background-color: #ddd;
    }

    .todo-content {
        display: flex;
        align-items: center;
    }
</style>

<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function () {
    const checkboxes = document.querySelectorAll('.todo-checkbox');

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            const listItem = this.closest('li'); // 체크박스의 부모 <li> 요소를 찾습니다.
            listItem.classList.toggle('complete'); // 완료 상태를 전환합니다.
            //saveItemsFn(); // 상태 저장 함수 호출 (필요한 경우 구현)
        });
    });
});

document.addEventListener("DOMContentLoaded", function() {
    // 모든 삭제 버튼에 클릭 이벤트 리스너 추가
    const deleteButtons = document.querySelectorAll(".delBtn");
    deleteButtons.forEach(button => {
        button.addEventListener("click", function() {
            const listNo = this.getAttribute("data-listno");
            
            // 확인 메시지
            if (confirm("정말로 이 항목을 삭제하시겠습니까?")) {
                // 비동기 요청 보내기
                fetch('/todo/deletePost', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ listNo: listNo }) // LIST_NO를 JSON 형태로 보냄
                })
                .then(response => {
                    if (response.ok) {
                        // 삭제 성공 시 리스트에서 항목 제거
                        this.closest("li").remove();
                    } else {
                        alert("삭제에 실패했습니다. 다시 시도해주세요.");
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                    alert("서버와 연결할 수 없습니다.");
                });
            }
        });
    });
});

document.addEventListener("DOMContentLoaded", function() {
    // 모든 수정 버튼에 클릭 이벤트 리스너 추가
    const updateButtons = document.querySelectorAll(".upBtn");
    updateButtons.forEach(button => {
        button.addEventListener("click", function() {
            const todoItem = this.closest(".todo-item");
            const listNo = todoItem.getAttribute("data-listno");
            const label = todoItem.querySelector(".thin-label");
            
            // 기존 내용을 input으로 변경
            const oldGoal = label.textContent;
            const input = document.createElement("input");
            input.type = "text";
            input.value = oldGoal;
            input.classList.add("edit-input");

            // 저장 버튼 추가
            const saveBtn = document.createElement("button");
			saveBtn.innerHTML = '<i class="fa-solid fa-check" style="color: #9c9c9c;"></i>';
			saveBtn.classList.add("saveBtn");

            // 기존 label과 수정 버튼 숨기고 input과 저장 버튼 추가
            label.style.display = "none";
            button.style.display = "none";
            todoItem.querySelector(".todo-content").appendChild(input);
            todoItem.querySelector(".todo-content").appendChild(saveBtn);

            // 저장 버튼 클릭 시 비동기식으로 서버에 수정 요청
            saveBtn.addEventListener("click", function() {
                const updatedGoal = input.value;

                fetch('/todo/updatePost', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ listNo: listNo, goalNm: updatedGoal })
                })
                .then(response => {
                    if (response.ok) {
                        // 수정 성공 시 input을 label로 다시 변경
                        label.textContent = updatedGoal;
                        label.style.display = "inline";
                        button.style.display = "inline";
                        input.remove();
                        saveBtn.remove();
                    } else {
                        alert("수정에 실패했습니다. 다시 시도해주세요.");
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                    alert("서버와 연결할 수 없습니다.");
                });
            });
        });
    });
});


</script>


<link rel="stylesheet" href="./style.css">
<script type="text/javascript" src="./todo.js"></script>
</head>


<body>
	
	<!-- 시작 바 -->
	<div class="card-header ui-sortable-handle" style="cursor: move;">
		<h1>
			<i class="ion ion-clipboard mr-1"></i> 
			To Do List
			<button type="button" class="btn btn-primary float-right">
				<i class="fas fa-plus"></i> To-Do List
			</button>
		</h1>
	</div>
	


<!-- 리스트 1 시작 -->
	<div class="todo-container">
    <h2>Todos</h2>
    <div id="inputField">
        <input type="text" id="todoInput" placeholder="할 일 추가하기">
        <button type="button" id="addBtn">
            <i class="fa-solid fa-plus fa-xl" style="color: #ffffff;"></i>
        </button>
    </div>
    <ul id="todoList">
        <c:forEach var="todo" items="${toDoListVOList}">
            <li class="todo-item" data-listno="${todo.listNo}">
                <div class="todo-content">
                    <input type="checkbox" id="todo-${todo.listNo}" class="todo-checkbox" />
                    <label for="todo-${todo.listNo}" class="thin-label">${todo.goalNm}</label>
                </div>
                <!-- 수정 및 삭제 버튼을 별도의 div로 분리 -->
                <div class="todo-buttons">
                    <button class="upBtn"><i class="fa-solid fa-pen-to-square cls1" style="color: #a3a3a3;"></i></button>
                    <button class="delBtn"><i class="fa-solid fa-trash-can cls2" style="color: #a3a3a3;"></i></button>
                </div>
            </li>
        </c:forEach>
    </ul>
    <div class="delete-btn-wrap">
        <button id="deleteAllBtn">전체 삭제</button>
    </div>
</div>

    <script type="text/javascript">
    $(document).ready(function () {
        const addBtn = $('#addBtn');
        const todoInput = $('#todoInput');
        const todoList = $('#todoList');

        addBtn.on('click', function () {
            const newTodoText = todoInput.val().trim();

            // 입력값이 비어있지 않은지 확인
            if (newTodoText === '') {
                alert("할 일을 입력하세요!");
                return;
            }

            // 비동기 요청 보내기
            $.ajax({
                url: '/todoList/insertTodo',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ goalNm: newTodoText, empNo: 1, delYn: 'N' }), // 사용자 번호 입력
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function (data) {
                    if (data.includes("성공적으로 추가되었습니다.")) {
                        // 새로운 항목 추가
                        const newListItem = $('<li></li>').addClass('todo-item').attr('data-listno', '새로운 LIST_NO'); // LIST_NO는 서버에서 받아와야 합니다.

                        newListItem.html(`
                            <div class="todo-content">
                                <input type="checkbox" class="todo-checkbox" />
                                <label class="thin-label">${newTodoText}</label>
                            </div>
                            <div class="todo-buttons">
                                <button class="upBtn"><i class="fa-solid fa-pen-to-square cls1" style="color: #a3a3a3;"></i></button>
                                <button class="delBtn"><i class="fa-solid fa-trash-can cls2" style="color: #a3a3a3;"></i></button>
                            </div>
                        `);

                        todoList.append(newListItem);
                        todoInput.val(''); // 입력 필드 초기화
                    } else {
                        alert(data); // 실패 메시지 표시
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Error:", error);
                    alert("서버와 연결할 수 없습니다.");
                }
            });
        });
    });
    </script>

</body>
</html>