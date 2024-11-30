<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
   uri="http://www.springframework.org/security/tags"%>

<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">

<script
   src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
   

<html>
<head>

<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<sec:authorize access="isAuthenticated()">
   <sec:authentication property="principal.employeeVO" var="empVO" />
</sec:authorize>
<!DOCTYPE html>
<script type="text/javascript">

   const loggedInEmpNo = "${empNo}";
   console.log("Logged in Employee Number: " + loggedInEmpNo);
   
   var sock = new SockJS("/alram");
   socket = sock; // socket 초기화
   
   function sendAfter() {
      Swal.fire({
         title: '메일을 성공적으로 발송하였습니다.',
         icon: 'success', /* 종류 많음 맨 아래 링크 참고 */
         showCancelButton: false, /* 필요 없으면 지워도 됨, 없는 게 기본 */
         confirmButtonColor: '#4E7DF4', /* 우리 포인트 색상 */
         confirmButtonText: '확인',
      }).then((result) => {
    	  window.close();
      });
   }//end sendAfter

 //파일 삭제 함수
	function removeFile(fileId) {
	 const input = $("#uploadFile")[0];
	    const dt = new DataTransfer();
	    
	    //기존 파일 중 삭제한 파일 제외
	    for(let i = 0; i < input.files.length; i++) {
	        if(i != fileId) {
	            dt.items.add(input.files[i]);
	        }
	    }
	    
	    //삭제 후의 파일 목록으로 input 값 설정
	    input.files = dt.files;
	    
	    //화면에서 해당 파일 아이템 삭제
	    $("#file-" + fileId).remove();
	}
   

   $(function() {
      console.log("sdfsdsfs");
      
      $(".ck-blurred").keydown(function(){
         //window.editor : CKEditor 객체
         console.log("str : " + window.editor.getData());

         $("#mailCn").val(window.editor.getData());
      });
      //CKEditor로부터 커서이동 또는 마우스 이동 시 실행
      $(".ck-blurred").on("focusout",function(){
         $("#mailCn").val(window.editor.getData());
      });

      
      $("#uploadFile").on("change", function() {
			
	        const files = $(this)[0].files;
	        let fileList = "";
	        for(let i = 0; i < files.length; i++) {
	            fileList += '<div class="file-item" id="file-' + i + '">' +
	                        files[i].name +
	                        ' <button type="button" class="remove-file" data-file-id="' + i + '">×</button>' +
	                        '</div>';
	        }
	        $("#fileList").html(fileList);
	        
	        //삭제 버튼 클릭 이벤트
	        $(".remove-file").on("click", function() {
	            const fileId = $(this).data("file-id");
	            removeFile(fileId);
	        });
	    });
      
      
      $("#cancel").on("click", function() {
    	  Swal.fire({
    	         title: '메일 발송을 취소 하시겠습니까?.',
    	         icon: 'question', /* 종류 많음 맨 아래 링크 참고 */
    	         showCancelButton: true, /* 필요 없으면 지워도 됨, 없는 게 기본 */
    	         confirmButtonColor: '#4E7DF4',
   				 confirmButtonText: '확인',
   				 cancelButtonText: '취소',
   				 reverseButtons: true
    	      }).then((result) => {
    	    	  if(result.isConfirmed){
    	    	  	window.close();
    	    	  }
    	      });
      });
      
      $("#selDeptCd").on("change", function() {
         console.log("aaaa");
         let DeptCd = $(this).val();
         console.log("DeptCd");
         
         $.ajax({
            url : "/cmmn/mail/getDeptCd",
            processData : false,
            contentType : false,
            data : DeptCd,
            type : "post",
            dataType : "json",
            beforeSend : function(xhr) {
               xhr.setRequestHeader(
                     "${_csrf.headerName}",
                     "${_csrf.token}");
            },
            success : function(result) {
               console.log("result : ", result);
               let str="";
               
               $("#dsptEmpNm").html("<option value='' selected disabled>선택해주세요</option>")
               
               $.each(result,function(idx,employeeVO){
                  
                  str += "<option value='" + employeeVO.empNo + "'>" + employeeVO.empNm + " (";

                   if (employeeVO.jbgdCd == 'A18-001') {
                       str += "사원";
                   } else if (employeeVO.jbgdCd == 'A18-002') {
                       str += "대리";
                   } else if (employeeVO.jbgdCd == 'A18-003') {
                       str += "차장";
                   } else if (employeeVO.jbgdCd == 'A18-004') {
                       str += "부장";
                   } else if (employeeVO.jbgdCd == 'A18-005') {
                       str += "이사";
                   } else if (employeeVO.jbgdCd == 'A18-006') {
                       str += "사장";
                   }

                   str += ")</option>";
               });
               $("#dsptEmpNm").append(str);
            }
         });
         
      });
      
      $("#dsptEmpNm").on("change", function() {
         
         console.log("dddd");
         let empNo = $(this).val();
         console.log(empNo);
         let  obj = document.getElementById("selectedEmps");
         $.ajax({
        	    url: "/cmmn/mail/getEmp",
        	    processData: false,
        	    contentType: false,
        	    data: empNo,
        	    type: "post",
        	    dataType: "json",
        	    beforeSend: function(xhr) {
        	        // CSRF 보호를 위한 헤더 설정
        	        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        	    },
        	    success: function(result) {
        	        console.log("result : ", result);

        	        // 중복 확인을 위한 함수
        	        function isValueDuplicate(newValue) {
        	            // 기존 DIV들에서 input 값들을 가져옴
        	            const existingInputs = obj.getElementsByTagName("input");
        	            for (let input of existingInputs) {
        	                if (input.value === newValue) {
        	                    return true; // 중복 발견
        	                }
        	            }
        	            return false; // 중복 없음
        	        }

        	        // 새로 추가할 값
        	        const newEmpValue = result.empNo;

        	        // 중복 여부 확인
        	        if (isValueDuplicate(newEmpValue)) {
        	            alert("중복된 사원은 선택할 수 없습니다");
        	        } else {
        	            // 중복되지 않는 경우에만 DIV 생성
        	            obj = document.getElementById("selectedEmps");
        	            newDiv = document.createElement("div");
        	            newDiv.setAttribute("id", "delEmp");
        	            newDiv.style.cursor = "pointer";

        	            // 직급에 따라 다른 내용 추가
        	            if (result.jbgdCd == 'A18-001') {
        	                newDiv.innerHTML = "<input type='text' name='recptnEmpNo' class='empList cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7' value='" + result.empNo + "' hidden='hidden'/><label style='border-radius: 10px; text-align: center; border: 1px solid skyblue; padding: 5px; width: 100px;' for='emp'>" + result.empNm + " (사원)</label> x  ";
        	            } else if (result.jbgdCd == 'A18-002') {
        	                newDiv.innerHTML = "<input type='text' name='recptnEmpNo' class='empList cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7' value='" + result.empNo + "' hidden='hidden'/><label style='border-radius: 10px; text-align: center; border: 1px solid skyblue; padding: 5px; width: 100px;' for='emp'>" + result.empNm + " (대리)</label> x";
        	            } else if (result.jbgdCd == 'A18-003') {
        	                newDiv.innerHTML = "<input type='text' name='recptnEmpNo' class='empList cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7' value='" + result.empNo + "' hidden='hidden'/><label style='border-radius: 10px; text-align: center; border: 1px solid skyblue; padding: 5px; width: 100px;' for='emp'>" + result.empNm + " (차장)</label> x";
        	            } else if (result.jbgdCd == 'A18-004') {
        	                newDiv.innerHTML = "<input type='text' name='recptnEmpNo' class='empList cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7' value='" + result.empNo + "' hidden='hidden'/><label style='border-radius: 10px; text-align: center; border: 1px solid skyblue; padding: 5px; width: 100px;' for='emp'>" + result.empNm + " (부장)</label> x";
        	            } else if (result.jbgdCd == 'A18-005') {
        	                newDiv.innerHTML = "<input type='text' name='recptnEmpNo' class='empList cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7' value='" + result.empNo + "' hidden='hidden'/><label style='border-radius: 10px; text-align: center; border: 1px solid skyblue; padding: 5px; width: 100px;' for='emp'>" + result.empNm + " (이사)</label> x";
        	            } else if (result.jbgdCd == 'A18-006') {
        	                newDiv.innerHTML = "<input type='text' name='recptnEmpNo' class='empList cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7' value='" + result.empNo + "' hidden='hidden'/><label style='border-radius: 10px; text-align: center; border: 1px solid skyblue; padding: 5px; width: 100px;' for='emp'>" + result.empNm + " (사장)</label> x";
        	            }

        	            // 새로운 DIV를 selectedEmps에 추가
        	            obj.appendChild(newDiv);
        	        }
        	    },
        	    error: function(xhr, status, error) {
        	        console.error("AJAX Error: ", status, error);
        	    }
        	});
         

      })

          
      $("#selectedEmps").on("click", "#delEmp", function() {
          var p = this.parentElement; // 부모 HTML 태그 요소
          p.removeChild(this); // 자신을 부모 태그로부터 제거
      });



       // btnRegistPost 클릭 이벤트
       $("#btnRegistPost").on("click", function() {
           // 필요한 변수와 데이터 수집
           //class="empList"인 요소들의 값을 가져와서
           //groupList(받는 사람 1명 이상) : 112001,181001,001002
           let groupList = $(".empList").map(function() { return this.value; }).get().join(",");
           let mailTtl = $("#mailTtl").val();
           let mailCn = $("#mailCn").val();
           let dsptchEmpNo = $("#dsptchEmpNo").val();
           let dimprtncYn = $("#dimprtncYn").is(":checked") ? 'Y' : 'N';

          let formData = new FormData(); // FormData 객체 생성
           
           let uploadFile = document.getElementById('uploadFile').files;
           for (let i = 0; i < uploadFile.length; i++) {
               formData.append("uploadFile", uploadFile[i]);
           }

        // 나머지 데이터를 FormData에 추가
           formData.append("groupList", groupList);
           formData.append("mailTtl", mailTtl);
           formData.append("mailCn", mailCn);
           formData.append("dsptchEmpNo", dsptchEmpNo);
           formData.append("imprtncYn", dimprtncYn);

           console.log("FormData: ", formData);
           
//            let jsonData = JSON.stringify({
//                groupList: groupList,
//                mailTtl: mailTtl,
//                mailCn: mailCn,
//                dsptchEmpNo: dsptchEmpNo,
//                imprtncYn: dimprtncYn
//            });
           
//            formData.append("jsonData", new Blob([jsonData], { type: "application/json" }));
//            console.log("formData : ", formData);


           $.ajax({
        	   url: "/cmmn/mail/sendMailAjax",
        	    contentType: false, // 파일 전송 시 false로 설정
        	    processData: false, // 데이터를 쿼리스트링으로 변환하지 않음
        	    data: formData, // FormData 객체를 전송
        	    type: "post",
        	    enctype: "multipart/form-data", // 파일 업로드 시 설정
        	    beforeSend: function(xhr) {
                   xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
               },

               success: function(result) {
            	   /*	
            	   sendMailAjax->result :  [
            		   {"mailNo":"m00000174","rcptnSn":215,"imprtncYn":"N","recptnEmpNo":"112001"},
            		   {"mailNo":"m00000174","rcptnSn":216,"imprtncYn":"N","recptnEmpNo":"010001"},
            		   {"mailNo":"m00000174","rcptnSn":217,"imprtncYn":"N","recptnEmpNo":"201001"}
            		  ]
            	   */
            	   console.log("sendMailAjax->result : ", result);

                   if (socket) {
                      $.each(result,function(idx,vo){
                          let url = 'cmmn/mail/list?empNo=' + vo.recptnEmpNo; // URL 설정
                          let icon = '<i class="fa-regular fa-envelope"></i>';
                          let message = " 메일이 도착했습니다.";
                          socket.send("1," + $("#dsptchEmpNo").val() + "," + vo.recptnEmpNo + "," + icon + "," + message + "," + url); // socket.send 호출
                      });
                   }
                   
                   sendAfter(); // 후처리 함수 호출
               },
               error: function(xhr, status, error) {
                   console.error("AJAX Error:", status, error); // 에러 처리
               }

           });
       });


   	  
       
         

   });
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

.ck-editor__editable {
   height: 400px !important; /* 높이를 400px로 고정 */
   overflow-y: auto !important; /* 세로 스크롤바를 자동으로 생성 */
   resize: none; /* 사용자가 크기를 조절할 수 없도록 설정 */
}

/*기본스타일을 없애고, 버튼모양을 구현*/
input[type='radio'] {
   -webkit-appearance: none; /*웹킷 브라우저에서 기본 스타일 제거*/
   -moz-appearance: none; /*모질라 브라우저에서 기본 스타일 제거*/
   appearance: none; /*기본 브라우저에서 기본 스타일 제거*/
   width: 18px;
   height: 18px;
   border: 2px solid #4E7DF4; /*체크되지 않았을 때의 테두리 색상*/
   border-radius: 50%;
   outline: none; /*focus 시에 나타나는 기본 스타일 제거*/
   cursor: pointer;
}

/*체크될 시에, 변화되는 스타일 설정*/
input[type='radio']:checked {
   background-color: #4E7DF4; /*체크 시 내부 원으로 표시될 색상*/
   border: 3px solid white; /*테두리가 아닌, 테두리와 원 사이의 색상*/
   box-shadow: 0 0 0 1.6px #4E7DF4; /*얘가 테두리가 됨*/
   /*그림자로 테두리를 직접 만들어야 함 (퍼지는 정도를 0으로 주면 테두리처럼 보입니다.)*/
   /*그림자가 없으면 그냥 설정한 색상이 꽉 찬 원으로만 나옵니다*/
}

.form-group {
   display: flex;
   flex-wrap: wrap;
   grid-template-columns: 1fr 1fr;
     grid-gap: 10px;
   gap: 6px; /* 간격을 줄 수 있습니다. */
   align-items: center;
}

.form-control {
   width: 15%; /* 두 개의 셀렉트 박스가 반씩 차지하도록 */
   min-width: 150px; /* 최소 너비 지정 */
}

.swal2-icon { /* 아이콘 */ 
		font-size: 8px !important;
		width: 40px !important;
		height: 40px !important;
	}

	.swal2-confirm, .swal2-cancel {
		font-size: 14px; /* 텍스트 크기 조정 */
		width: 75px;
		height: 35px;
		padding: 0px;
	}
	
	.swal2-styled.swal2-cancel {
	    font-size: 14px;
	    background-color: #f8f9fa;
	    color: black;
	    border: 1px solid #D9D9D9;
	}
	
	.swal2-styled.swal2-confirm {
	    font-size: 14px;
	}
	
	.swal2-title { /* 타이틀 텍스트 사이즈 */
		font-size: 18px !important;
		padding-top: 1.5em;
    	padding-bottom: 0.5em;
	}
	
	.swal2-container.swal2-center>.swal2-popup {
		padding-top: 30px;
		width: 450px;
	}
	
	.swal2-input {
	    font-size: 15px;
	    height: 2em;
	    padding-top: 18px;
	    padding-bottom: 18px;
	    width: 270px; /* 원하는 너비로 설정 */
	    margin: 0 auto; /* 가운데 정렬 */
	    display: block; /* 인풋 필드를 블록 요소로 만들어서 margin이 적용되도록 */
	    text-align: center;
	    margin-top: 20px;
    	margin-bottom: 5px;
	}
	
	.swal2-input:focus {
		border : 1px solid #4E7DF4;
	}
	
	.swal2-input::placeholder {
	    color: #7a7a7a; /* 어둡게 설정 */
	    font-weight: 100; /* 얇게 설정 */
	}

.empContainer {
        width: 98%;
        height: 140px;
        overflow:auto;
      }
.container::-webkit-scrollbar {
    width: 10px;
  }
  .container::-webkit-scrollbar-thumb {
    background-color: #4E7DF4;
    border-radius: 10px;
  }
  .container::-webkit-scrollbar-track {
    background-color: lightGray;
    border-radius: 10px;
  }
#delEmp{
   display: inline-block; 
   margin: 2px;
}
</style>
<body>


   <div class="py-6" style="background-color: #f9f9f9;">
      <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
         <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
            <div class="p-6 bg-white border-b border-gray-200">
			<div style="margin-bottom: 20px;">
	            <span class="text-lg text-gray-600 font-semibold" style="color:#4E7DF4;">메일 작성</span>
	        </div>

               <!-- 
   요청URI : /sugest/registPost
   요청파라미터 : {sugestClsfCd=,bbsTtl=,empNo=,bbsCn=,uploadFile=파일객체}
   요청방식 : post
    -->
               <form:form id="frm" modelAttribute="boardVO"
                  action="/manage/sugest/registPost?${_csrf.parameterName}=${_csrf.token}"
                  method="post" enctype="multipart/form-data">
                  <div class="mb-4 flex items-center">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" id="csrfToken" />
                     <label class="text-md text-gray-600 mt-1">제목&ensp;</label><span class="text-red-500 mr-3"> *</span> 
                     <input type="text"
                        class="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-4/5 p-2.5 mr-4"
                        id="mailTtl" name="mailTtl" placeholder="제목을 입력해주세요" required>
                     <label class="text-md text-gray-600 mr-2 mt-2" for="dimprtncYn">중요</label>
                     <input type="checkbox" id="dimprtncYn" name="dimprtncYn">
                  </div>

                  <div class="form-group">
                     <label class="text-md text-gray-600 mt-2" for="selDeptCd">부서&nbsp;</label><span class="text-red-500 mr-2"> *</span> <select
                        id="selDeptCd" name="selDeptCd" class="form-control" required>
                        <option value="" selected disabled>선택해주세요</option>
                        <option value="A17-001">경영진</option>
                        <option value="A17-002">기획부서</option>
                        <option value="A17-003">관리부서</option>
                        <option value="A17-004">영업부서</option>
                        <option value="A17-005">인사부서</option>
                     </select> <label class="text-md text-gray-600 mt-2 ml-3" for="dsptEmpNm">사원&nbsp;</label><span class="text-red-500 mr-2"> *</span><select
                        id="dsptEmpNm" name="dsptEmpNm" class="form-control" required>
                        <option value="" selected disabled>선택해주세요</option>
                        <c:forEach var="employeeVO" items="${employeeVOList}">
                           <option value="${employeeVO.empNo}">${employeeVO.empNo}</option>
                           <c:if test=""></c:if>
                        </c:forEach>
                     </select>
                  </div>

                  <div id="selectedEmps">
                     <label class="text-md text-gray-600 mr-4">받는 사람</label>
                  </div>
                  
                  <div class="mb-8">
                     <input type="text" id="dsptchEmpNo"
                        name="dsptchEmpNo" value="${empVO.empNo}" hidden="hidden" />
                     <textarea style="resize: none; overflow-y: auto; height: 400px;"
                        class="border-2 border-gray-500 w-full" id="mailCn"
                        name="mailCn" placeholder="내용을 입력해주세요"> </textarea>
                  </div>

                  <div class="mb-4 flex items-center">
						<label class="text-md text-gray-600 mr-4">첨부파일</label>
						<!-- 첨부파일 아이콘 -->
						 <div class="icons flex text-gray-500 m-2">
			                <label id="select-image">
			                    <svg class="mr-2 cursor-pointer hover:text-gray-700 border rounded-full p-1 h-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
			                    </svg>
			                   <input type="file" id="uploadFile" name="uploadFile" multiple hidden />
			                </label>
			                <!-- 파일 이름 출력 영역 -->
			                <div id="fileList" class="text-sm text-gray-500 mt-2">
	
			                </div>
			            </div>
			            <!-- 이미지 첨부 시 미리보기 영역 -->
			            <div id="pImg"></div>
					</div>
                  <div class="flex justify-end p-1" style="gap: 10px;">
                     <button type="button" id="cancel"
                        class=" text-gray-900  font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all border border-gray-300 duration-150"
                        type="button">취소</button>
                     <button type="button" id="btnRegistPost"
                        class=" text-white  font-bold uppercase text-sm px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                        style="background-color: #848484; "> 전송</button>
                  </div>
                  <sec:csrfInput />
               </form:form>
            </div>
         </div>
      </div>
   </div>

   <script>
       ClassicEditor
       .create(document.querySelector('#mailCn'), {
           ckfinder: {
               uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'
           },
           removePlugins: ['AutoGrow']  // 자동 크기 조정 플러그인 비활성화
       })
       .then(editor => {
           window.editor = editor;
   
           // 에디터의 편집 영역 고정
           const editable = editor.ui.view.editable.element;
           editable.style.height = '40vh';  // 고정된 높이 설정
           editable.style.overflowY = 'auto';  // 세로 스크롤 가능
       })
       .catch(err => {
           console.error(err.stack);
       });

    </script>
</body>
</html>

