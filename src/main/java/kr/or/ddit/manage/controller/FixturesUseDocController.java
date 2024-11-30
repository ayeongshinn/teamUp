package kr.or.ddit.manage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.service.FixturesUseDocService;
import kr.or.ddit.manage.vo.CarUseDocVO;
import kr.or.ddit.manage.vo.FixturesUseDocVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/fixturesUseDoc")
public class FixturesUseDocController {
	
	@Inject
	FixturesUseDocService fixturesUseDocService;
	
	// 비품 사용 신청서 작성 페이지로 이동
	@GetMapping("/regist")
	public String regist(Model model) { 
	    
		return "manage/fixturesUseDoc/regist";
	}
	
	//자동완성
	@PostMapping("/autocomplete")
	public @ResponseBody Map<String, Object> autocomplete(@RequestParam Map<String, Object> paramMap) throws Exception {
		
		List<Map<String, Object>> resultList = fixturesUseDocService.autocomplete(paramMap);
		
	    Map<String, Object> responseMap = new HashMap<>();
	    responseMap.put("resultList", resultList);

	    return responseMap;  // JSON 형태로 반환
	}
	
	// 비품 사용 등록 처리
	@PostMapping("/fixRegist")
	public String fixRegist (@RequestParam("htmlCd") String htmlCd, FixturesUseDocVO fixturesUseDocVO) {
        
		log.info("fixturesUseDocVO -> " + fixturesUseDocVO);
		
	    // htmlCd에 저장된 인코딩된 HTML 데이터 처리
	    log.info("Received HTML: " + htmlCd);
		
	    // 비품 사용 등록
		int result = fixturesUseDocService.fixRegist(fixturesUseDocVO);
		log.info("result : " + result);
		
	
		return "manage/fixturesUseDoc/regist";
	}
	
	// 직원 정보 조회
	@PostMapping("/getEmpInfo")
	@ResponseBody
	public EmployeeVO getEmpInfo(String empNo) {
		
	    EmployeeVO empVO = fixturesUseDocService.getEmpInfo(empNo);
	    log.info("empVO : " + empVO);
	    
	    return empVO;  // JSON 형식으로 반환
	}
	
	// 차량 사용 신청 등록 처리
	@PostMapping("/carRegist")
	public String carRegist (@RequestParam("htmlCd") String htmlCd, CarUseDocVO carUseDocVO) {
        
		log.info("carUseDocVO -> " + carUseDocVO);
		
	    // htmlCd에 저장된 인코딩된 HTML 데이터 처리
	    log.info("Received HTML: " + htmlCd);
		
		int result = fixturesUseDocService.carRegist(carUseDocVO);
		log.info("result : " + result);
		
	
		return "manage/fixturesUseDoc/regist";
	}
}
