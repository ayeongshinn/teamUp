package kr.or.ddit.mngmt.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.hr.controller.HrVacationController;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mngmt")
public class MnHomeController {
	
	
	@GetMapping("/mnHome")
	public String home() {
		return "/mngmt/mnHome";
	}
	
	
	
}

 