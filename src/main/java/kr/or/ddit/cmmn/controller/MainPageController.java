package kr.or.ddit.cmmn.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.MainPageService;
import kr.or.ddit.cmmn.service.MyPageService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.ToDoListVO;
import kr.or.ddit.hr.mapper.EmployeeMapper;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.BoardVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainPageController {
	
	@Autowired
	MainPageService mainPageService;
	// 사원
	//DI(의존성 주입)
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	MyPageService myPageService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
    public String home(Locale locale, Model model,Principal principal) {
        log.info("하이하이하이하이하이하이하이 {}", locale);
      //로그인 된 아이디를 가져옴
		String username = principal.getName();
		
		//로그인 된 사원의 정보를 모두 가져옴
		EmployeeVO employeeVO = this.employeeMapper.getLogin(username);
		
		
		model.addAttribute("employeeVO", employeeVO);
        return "mainPage";
    }
	
	//정보수정
	@GetMapping("/infoUpdatePost")
	public String infoUpdatePost(
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="empIntrcn",required=false,defaultValue="") String empIntrcn
			) {
		if (empNo == null || empNo.isEmpty() || empIntrcn == null || empIntrcn.isEmpty()) {
		    log.error("Invalid empNo or empIntrcn");
		    return "redirect:/errorPage";  // 유효하지 않으면 에러 페이지로 리다이렉트
		}
		EmployeeVO employeeVO=new EmployeeVO();
		
		employeeVO.setEmpNo(empNo);
		employeeVO.setEmpIntrcn(empIntrcn);
		log.info("infoUpdatePost"+employeeVO);
		
		int result=this.mainPageService.infoUpdate(employeeVO);
		
		
		return "redirect:/";
			
			
	}
	
	@ResponseBody
	@PostMapping("/getEmpAttendTime")
	public AttendanceVO getEmpAttendTime(@RequestBody String empNo) {
		
		AttendanceVO attendanceVO = this.mainPageService.getEmpAttendTime(empNo);
		
		return attendanceVO;
	}
	
	@ResponseBody
	@GetMapping("/getNoticeImprtnc")
	public List<BoardVO> getNoticeImprtnc() {
		
		List<BoardVO> boardVO = this.mainPageService.getNoticeImprtnc();
		
		return boardVO;
	}
	
	@ResponseBody
	@GetMapping("/getNotice")
	public List<BoardVO> getNotice() {
		
		List<BoardVO> boardVO = this.mainPageService.getNotice();
		
		return boardVO;
	}
	
	@ResponseBody
	@PostMapping("/empSttusRunUpdate")
	public int empSttusRunUpdate(@RequestBody String empNo) {
		
		int res = this.mainPageService.empSttusRunUpdate(empNo);
		
		return res;
	}
	
	@ResponseBody
	@PostMapping("/empSttusReturnUpdate")
	public int empSttusReturnUpdate(@RequestBody String empNo) {
		
		int res = this.mainPageService.empSttusReturnUpdate(empNo);
		
		return res;
	}
	
	@ResponseBody
	@PostMapping("/getAdreesTim")
	public List<EmployeeVO> getAdreesTim(@RequestBody EmployeeVO employeeVO) {
		
		log.info("getAdreesTim!!!!!!!!!!!!!!!!!!!!!!!! -> employeeVO : " + employeeVO);
		
		List<EmployeeVO> employeeVOList = this.mainPageService.getAdreesTim(employeeVO);
		
		return employeeVOList;
	}
	
	
	//-------------------------------------
	//todoList 작성
		//기존 todolist 가져오기
		@GetMapping("/list")
		public String list(Model model) {
		    log.info("list 확인 ");
		    
		    // 로그인한 사용자 정보 가져오기
		    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		    String empNo = authentication.getName();
		    
		    // 서비스에서 할 일 목록 가져오기
		    List<ToDoListVO> todoListVOList = this.mainPageService.list(empNo);
		    log.info("list >> toDoListVOList : {}", todoListVOList);
		    
		    
		    // 각 ToDoListVO 객체에 사용자 정보 설정
		    for (ToDoListVO todo : todoListVOList) {
		        todo.setEmpNo(empNo);  // 각각의 할 일 항목에 empNo를 설정
		    }
		    
		    // 모델에 할 일 목록 추가
		    model.addAttribute("toDoListVOList", todoListVOList);
		    
		    return "cmmn/todoList/list";
		}
		
		// To-Do 항목 추가 메소드
		@ResponseBody
		@PostMapping("/insertTodo")
		public String insertTodo(@RequestBody ToDoListVO todo) {
		    log.info("insertTodo -> todo: " + todo);
		    
		    int result = mainPageService.insertTodo(todo);
		    log.info("result: " + result);

		    if (result > 0) {
		        return "성공적으로 추가되었습니다."; // 성공 메시지
		    } else {
		        return "추가에 실패했습니다."; // 실패 메시지
		    }
		}
		
	    // To-Do 항목 삭제 메소드
	    @ResponseBody
	    @PostMapping("/deletePost")
	    public String deletePost(ToDoListVO toDoListVO) {
	    	log.info("deletePost -> " + toDoListVO);
			
			int result = this.mainPageService.deletePost(toDoListVO);
			log.info("deletePost (update) result -> " + result);
	    	
	        return "cmmn/todoList/list";
	    }

	    
	    // To-Do 항목 수정 메소드
	    @ResponseBody
	    @PostMapping("/updatePost")
	    public String updateTodo(ToDoListVO toDoListVO) {
			log.info("toDoListVO -> " + toDoListVO);
			
			int result = this.mainPageService.updateTodo(toDoListVO);
			log.info("updateTodo result -> " + result);
			
			return "cmmn/todoList/list";
		}
}