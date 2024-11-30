package kr.or.ddit.cmmn.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import kr.or.ddit.cmmn.service.TodoListService;
import kr.or.ddit.cmmn.vo.ToDoListVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/todoList")
public class TodoListController {
	
	//서비스 명
	@Autowired
	TodoListService todoListService;
	
	
	@GetMapping("/list")
	@ResponseBody
	public ResponseEntity<?> list() {
	    log.info("할 일 목록 조회 시작");
	    
	    try {
	        // 로그인한 사용자 정보 가져오기
	        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	        String empNo = authentication.getName();
	        log.info("현재 로그인한 사용자: {}", empNo);
	        
	        // 서비스에서 할 일 목록 가져오기
	        List<ToDoListVO> todoListVOList = this.todoListService.list(empNo);
	        log.info("조회된 할 일 목록: {}", todoListVOList);
	        
	        // 각 할 일 항목에 대해 추가 정보 설정
	        List<Map<String, Object>> enhancedList = todoListVOList.stream().map(todo -> {
	            Map<String, Object> enhancedTodo = new HashMap<>();
	            enhancedTodo.put("listNo", todo.getListNo());
	            enhancedTodo.put("goalNm", todo.getGoalNm());
	            enhancedTodo.put("checkSta", todo.getCheckSta());
	            enhancedTodo.put("delYn", todo.getDelYn());
	            // 필요한 경우 여기에 더 많은 필드를 추가할 수 있습니다.
	            return enhancedTodo;
	        }).collect(Collectors.toList());
	        
	        return ResponseEntity.ok(enhancedList);
	    } catch (Exception e) {
	        log.error("할 일 목록 조회 중 오류 발생", e);
	        Map<String, String> errorResponse = new HashMap<>();
	        errorResponse.put("error", "할 일 목록을 가져오는 중 오류가 발생했습니다.");
	        errorResponse.put("message", e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
	    }
	}
	
	// To-Do 항목 추가 메소드
	@ResponseBody
	@PostMapping("/insertTodo")
	public ResponseEntity<?> insertTodo(@RequestBody ToDoListVO todo) {
	    log.info("insertTodo -> todo: " + todo);
	    
	    //로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String empNo = authentication.getName();
	    
	    //VO에 사용자 정보 설정
	    todo.setEmpNo(empNo);
	    
	    int result = todoListService.insertTodo(todo);
	    log.info("insertTodo result: " + result);

	    Map<String, Object> response = new HashMap<>();
	    if (result > 0) {
	        response.put("status", "SUCCESS");
	        response.put("listNo", todo.getListNo()); // 새로 생성된 listNo 반환
	        return ResponseEntity.ok(response);
	    } else {
	        response.put("status", "FAIL");
	        return ResponseEntity.badRequest().body(response);
	    }
	}
	
    // To-Do 항목 삭제 메소드
    @ResponseBody
    @PostMapping("/deletePost")
    public String deletePost(ToDoListVO toDoListVO) {
    	log.info("deletePost -> " + toDoListVO);
		
		int result = this.todoListService.deletePost(toDoListVO);
		log.info("deletePost (update) result -> " + result);
    	
        return "cmmn/todoList/list";
    }
    
    // To-Do 항목 전체 삭제 메소드
    @ResponseBody
    @PostMapping("/allDelete")
    public String allDelete(ToDoListVO toDoListVO) {
    	log.info("allDelete -> " + toDoListVO);
		
		int result = this.todoListService.allDelete(toDoListVO);
		log.info("allDelete (update) result -> " + result);
    	
        return "cmmn/todoList/list";
    }

    
    // To-Do 항목 수정 메소드
    @ResponseBody
    @PostMapping("/updatePost")
    public String updateTodo(ToDoListVO toDoListVO) {
		log.info("toDoListVO -> " + toDoListVO);
		
		int result = this.todoListService.updateTodo(toDoListVO);
		log.info("updateTodo result -> " + result);
		
		return "cmmn/todoList/list";
	}
    
    @ResponseBody
    @PostMapping("/checkSta")
    public ResponseEntity<String> checkSta(@RequestParam("listNo") String listNo) {
        try {
            log.info("체크박스 상태 업데이트 - listNo: {}", listNo);
            
            int result = todoListService.checkSta(listNo);
            
            if (result > 0) {
                return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            log.error("체크박스 상태 업데이트 중 오류 발생", e);
            return new ResponseEntity<>("ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @ResponseBody
    @PostMapping("/checkStaOff")
    public ResponseEntity<String> checkStaOff(@RequestParam("listNo") String listNo) {
        try {
            log.info("체크박스 상태 업데이트 - listNo: {}", listNo);
            
            int result = todoListService.checkStaOff(listNo);
            
            if (result > 0) {
                return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("FAIL", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            log.error("체크박스 상태 업데이트 중 오류 발생", e);
            return new ResponseEntity<>("ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
	
	
}

 