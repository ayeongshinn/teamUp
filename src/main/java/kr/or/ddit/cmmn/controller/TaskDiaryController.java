package kr.or.ddit.cmmn.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.TaskDiaryService;
import kr.or.ddit.cmmn.vo.TaskDiaryVO;
import kr.or.ddit.hr.service.EmployeeService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.CommentVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/taskDiary")
public class TaskDiaryController {

    // 서비스 명
    @Autowired
    TaskDiaryService taskDiaryService;
    
    @Autowired
    EmployeeService employeeService;

    //업무 일지 리스트
    @GetMapping("/list")
    public String list(Model model,
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
            @RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
            @RequestParam(value = "endDate", required = false, defaultValue = "") String endDate
    ) {
        // 로그인한 사용자 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String empNo = authentication.getName();
        
        // 사용자의 직책과 부서 정보 가져오기
        EmployeeVO employee = employeeService.detail(empNo);
        String userJbttlNm = employee.getJbttlNm();
        String userDeptNm = employee.getDeptNm();

        // 파라미터 맵 구성
        Map<String, Object> map = new HashMap<>();
        map.put("empNo", empNo);
        map.put("userJbttlNm", userJbttlNm);
        map.put("userDeptNm", userDeptNm);
        map.put("keyword", keyword);
        map.put("currentPage", currentPage);
        map.put("searchField", searchField);
        map.put("startDate", startDate); 
        map.put("endDate", endDate); 
        
        // 업무 일지 리스트 조회
        List<TaskDiaryVO> taskDiaryVOList = this.taskDiaryService.list(map);
        log.info("list >> taskDiaryVOList: {}", taskDiaryVOList);
        model.addAttribute("taskDiaryVOList", taskDiaryVOList);

        // 전체 행의 수
        int total = this.taskDiaryService.getTotal(map);
        log.info("list => total: {}", total);

        // 페이지네이션 객체
        ArticlePage<TaskDiaryVO> articlePage = 
                new ArticlePage<>(total, currentPage, 10, taskDiaryVOList, keyword);
        model.addAttribute("articlePage", articlePage);

        // jsp의 위치
        return "cmmn/taskDiary/list";
    }



	
	 @GetMapping("/detail")
	    public String getDetail(@RequestParam(value="diaryNo", required = true) String diaryNo, Model model) {
		 
	        // 서비스 레이어에서 TaskDiaryVO 가져오기
	        TaskDiaryVO taskDiaryVO = taskDiaryService.detail(diaryNo);
	        log.info("detail->taskDiaryVO : " + taskDiaryVO);

	        // 모델에 데이터를 추가
	        model.addAttribute("taskDiaryVO", taskDiaryVO);

	        // JSP 
	        return "cmmn/taskDiary/detail";
	    }
	 
	    // 업무일지 등록 
		@GetMapping("/regist")
		public String taskDiaryRegist() {
			
			return "cmmn/taskDiary/regist";
		}
		
		// 업무일지 등록 처리 
		@PostMapping("/registPost")
		public String registPost(@ModelAttribute TaskDiaryVO taskDiaryVO) {
			
			log.info("taskDiaryVO 확인 : " + taskDiaryVO);
			
			//로그인한 사용자 정보 가져오기
			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			String empNo = authentication.getName();
			
			//VO에 사용자 정보 설정
			taskDiaryVO.setEmpNo(empNo);
			
			int result = this.taskDiaryService.registPost(taskDiaryVO);
			log.info("result 확인 : " + result);
			
			return "redirect:/taskDiary/list";
		}
		
		@PostMapping("/deletePost")
		public String deletePost(@ModelAttribute TaskDiaryVO taskDiaryVO) {
		    log.info("taskDiaryVO : " + taskDiaryVO);
		    
		    int result = taskDiaryService.deletePost(taskDiaryVO);
		    log.info("result 확인 : " + result);
		    
		    return "redirect:/taskDiary/list";
		}
		
		
		
		//업무일지 수정 페이지
		@GetMapping("/update")
		public String updateNotice(@RequestParam("diaryNo") String diaryNo, Model model) {
				
			TaskDiaryVO taskDiaryVO = this.taskDiaryService.detail(diaryNo);
			
			model.addAttribute("taskDiaryVO", taskDiaryVO);
			
			return "taskDiary/detail";
		}
		
		//업무일지 수정 
		@PostMapping("/updateAjax")
		public String updateAjax(@ModelAttribute TaskDiaryVO taskDiaryVO) {
			
			log.info("updateAjax -> taskDiaryVO: " + taskDiaryVO);
			
			int result = this.taskDiaryService.updateAjax(taskDiaryVO);
			log.info("result: ", result);
			
			return "redirect:/detail?diaryNo=" + taskDiaryVO.getDiaryNo();
		}
		
		
		
		@PostMapping("/registCommentPost")
		public String registCommentPost(@ModelAttribute @Validated CommentVO commentVO,Model model) { 
			
			
			log.info("registCommentPost->commentVO : " + commentVO);
			
			int result=this.taskDiaryService.registCommentPost(commentVO);
			
			//댓글 목록 가져오기
			
			
			
			return "redirect:/manage/sugest/detail?bbsNo="+commentVO.getBbsNo();
			
		}
		
		@ResponseBody
		@PostMapping("/deleteCommentAjax")
		public List<CommentVO> deleteCommentAjax(CommentVO commentVO){
			 log.info("deleteCommentAjax->commentVO : " + commentVO);
			 
			 int result =this.taskDiaryService.deleteCommentAjax(commentVO);
			 
			 List<CommentVO> commentVOList=this.taskDiaryService.listComment(commentVO);
			 
			 return commentVOList;
			
		}
		
		@ResponseBody
		@PostMapping("/updateCommentAjax")
		public List<CommentVO> updateCommentAjax(@RequestBody CommentVO commentVO, Model model) {
			
			int result =this.taskDiaryService.updateCommentAjax(commentVO);
			
			List<CommentVO> commentVOList=this.taskDiaryService.listComment(commentVO);
			
			
			return commentVOList;
		}


	
	
}

 