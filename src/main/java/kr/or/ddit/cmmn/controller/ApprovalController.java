package kr.or.ddit.cmmn.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.ApprovalService;
import kr.or.ddit.cmmn.vo.ApprovalLineCountVO;
import kr.or.ddit.cmmn.vo.ApprovalDocVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.DocumentFormVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/approval")
public class ApprovalController {
	
	@Autowired
	ApprovalService approvalService;
	
	@GetMapping("/approvalList")
	public String approvalList(Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
	        @RequestParam(value = "searchField", required = false) String searchField,
	        @RequestParam(value = "keyword", required = false) String keyword,
	        @RequestParam(value = "startDate", required = false) String startDate,
	        @RequestParam(value = "endDate", required = false) String endDate,
	        @RequestParam(value = "emrgncySttus", required = false) String emrgncySttus,
	        @RequestParam(value = "approveNow", required = false) String approveNow
	        
			) {
		// 현재 인증된 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		// CustomUser로 캐스팅하여 EmployeeVO에 접근
		CustomUser customUser = (CustomUser) authentication.getPrincipal();
		EmployeeVO employeeVO = customUser.getEmployeeVO();
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", employeeVO.getEmpNo());
	    map.put("currentPage", currentPage);
	    map.put("searchField", searchField);
	    map.put("keyword", keyword);
	    map.put("startDate", startDate != null ? startDate.replace("-", "") : null);
	    map.put("endDate", endDate != null ? endDate.replace("-", "") : null);
	    map.put("emrgncySttus", emrgncySttus != null ? String.valueOf(emrgncySttus) : null);
	    map.put("approveNow", approveNow);
	    
	    int total = this.approvalService.getApprovalCount(map);
		
		List<ApprovalDocVO> approvalDocVOList = this.approvalService.getApprovalListP(map);
		
		log.info("approvalList -> approvalDocVOList : " + approvalDocVOList);
		
		ArticlePage<ApprovalDocVO> articlePage = new ArticlePage<ApprovalDocVO>(total, currentPage, 10);
		
		ApprovalLineCountVO approvalLineCountVO = this.approvalService.getApprovalLineCount(employeeVO.getEmpNo());
		
		model.addAttribute("approvalLineCountVO", approvalLineCountVO);
		model.addAttribute("approvalDocVOList", approvalDocVOList);
		model.addAttribute("articlePage", articlePage);
		
		return "cmmn/approval/approvalList";
	}
	
	@GetMapping("/approvalDetail")
	public String approvalDetail(@RequestParam("docNo") String docNo, Model model) {
		
		ApprovalDocVO approvalDocVO = this.approvalService.getApprovalTotal(docNo);
		
		model.addAttribute("approvalDocVO", approvalDocVO);
		
		return "cmmn/approval/approvalDetail";
	}
	
	@ResponseBody
	@PostMapping("/approveAjax")
	public int approveAjax(@RequestBody Map<String, Object> approval) {
		
		int res = this.approvalService.approveAjax(approval);
		
		return res;
	}
	
	@ResponseBody
	@PostMapping("/returnAjax")
	public int returnAjax(@RequestBody Map<String, Object> approval) {
		
		int res = this.approvalService.returnAjax(approval);
		
		return res;
	}
	
	@GetMapping("/docTest")
	public String docTest() {
		return "cmmn/approval/docTest";
	}
	
	@GetMapping("/approvalRegist")
	public String approvalRegist(Model model) {
		
		// 현재 인증된 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		// CustomUser로 캐스팅하여 EmployeeVO에 접근
		CustomUser customUser = (CustomUser) authentication.getPrincipal();
		EmployeeVO employeeVO = customUser.getEmployeeVO();
		
		String drftEmpNo = employeeVO.getEmpNo();
		
		employeeVO = this.approvalService.getDrafterEmpNo(drftEmpNo);
		model.addAttribute("employeeVO", employeeVO);
		
//		log.info("approvalRegist -> docNo : " + docNo);
//		log.info("approvalRegist -> docCd : " + docCd);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String currentDate = sdf.format(new Date());
		model.addAttribute("currentDate", currentDate);
		
		List<EmployeeVO> employeeListVO = this.approvalService.getEmpList();
		model.addAttribute("employeeListVO", employeeListVO);
		
		List<DocumentFormVO> documentFormVO = this.approvalService.getFormList();
		model.addAttribute("documentFormVO", documentFormVO);
		
//		List<CommonCodeVO> deptCommonCodeVO = this.approvalService.getDeptCd();
//		model.addAttribute("deptCommonCodeVO", deptCommonCodeVO);
//		
//		List<CommonCodeVO> jbgdCommonCodeVO = this.approvalService.getJbgdCd();
//		model.addAttribute("jbgdCommonCodeVO", jbgdCommonCodeVO);
		
		//A29-001	인사 이동 기획안 서류
		//A29-002	휴가 사용 서류
		//A29-003	퇴사 서류
		//A29-006	비품 사용 서류
		//A29-005	급여 명세서
		//A29-004	연봉 계약서
		//A29-007	법인 차량 사용 서류
		
		/*
		if(docCd.equals("A29-001")) {
			HrMovementDocVO hrMovementDocParamVO = new HrMovementDocVO();
			hrMovementDocParamVO.setDocNo(docNo);
			hrMovementDocParamVO.setDrftEmpNo(drftEmpNo);
			
			HrMovementDocVO hrMovementDocVO = this.approvalService.getHrMovementDoc(hrMovementDocParamVO);
			model.addAttribute("docVO", hrMovementDocVO);
			
		} else if(docCd.equals("A29-002")) {
			VacationDocVO vacationDocParamVO = new VacationDocVO();
			vacationDocParamVO.setDocNo(docNo);
			vacationDocParamVO.setDrftEmpNo(drftEmpNo);
			
			VacationDocVO vacationDocVO = this.approvalService.getVacationDoc(vacationDocParamVO);
			model.addAttribute("docVO", vacationDocVO);
			
		} else if(docCd.equals("A29-003")) {
			ResignationDocVO resignationDocParamVO = new ResignationDocVO();
			resignationDocParamVO.setDocNo(docNo);
			resignationDocParamVO.setDrftEmpNo(drftEmpNo);
			
			ResignationDocVO resignationDocVO = this.approvalService.getResignationDoc(resignationDocParamVO);
			model.addAttribute("docVO", resignationDocVO);
			
		} else if(docCd.equals("A29-004")) {
			SalaryDocVO salaryDocParamVO = new SalaryDocVO();
			salaryDocParamVO.setDocNo(docNo);
			salaryDocParamVO.setDrftEmpNo(drftEmpNo);
			
			SalaryDocVO salaryDocVO = this.approvalService.getSalaryDoc(salaryDocParamVO);
			model.addAttribute("docVO", salaryDocVO);
			
		} else if(docCd.equals("A29-005")) {
			SalaryDetailsDocVO salaryDetailsDocParamVO = new SalaryDetailsDocVO();
			salaryDetailsDocParamVO.setDocNo(docNo);
			salaryDetailsDocParamVO.setDrftEmpNo(drftEmpNo);
			
			SalaryDetailsDocVO salaryDetailsDocVO = this.approvalService.getSalaryDetailsDoc(salaryDetailsDocParamVO);
			model.addAttribute("docVO", salaryDetailsDocVO);
			
		} else if(docCd.equals("A29-006")) {
			FixturesUseDocVO fixturesUseDocParamVO = new FixturesUseDocVO();
			fixturesUseDocParamVO.setDocNo(docNo);
			fixturesUseDocParamVO.setDrftEmpNo(drftEmpNo);
			
			FixturesUseDocVO fixturesUseDocVO = this.approvalService.getFixturesUseDoc(fixturesUseDocParamVO);
			model.addAttribute("docVO", fixturesUseDocVO);
			
		} else if(docCd.equals("A29-007")) {
			CarUseDocVO carUseDocParamVO = new CarUseDocVO();
			carUseDocParamVO.setDocNo(docNo);
			carUseDocParamVO.setDrftEmpNo(drftEmpNo);
			
			CarUseDocVO carUseDocVO = this.approvalService.getCarUseDoc(carUseDocParamVO);
			model.addAttribute("docVO", carUseDocVO);
		}*/
		
		return "cmmn/approval/approvalRegist";
	}
	
	@ResponseBody
	@PostMapping("/getSearch")
	List<EmployeeVO> getSearch(@RequestBody String empNm){
		
		List<EmployeeVO> employeeVOList = this.approvalService.getSearch(empNm);
		
		return employeeVOList;
	}
	
	@ResponseBody
	@PostMapping("/getApproveLines")
	List<EmployeeVO> getApproveLines(@RequestBody Map<String, Object> map){
		
		List<EmployeeVO> employeeVOList = this.approvalService.getApproveLines(map);
		
		return employeeVOList;
	}
	
	@ResponseBody
	@PostMapping("/insertApproval")
	public int insertApproval(@RequestBody Map<String, Object> map) {
		log.info("insertApproval: " + map);
		
//		int res = this.approvalService.insertHrMovementDoc(map);
		int res = this.approvalService.insertApproval(map);
		
		return res;
	}
	
	@ResponseBody
	@GetMapping("/hrMovementDocNo")
	public String hrMovementDocNo() {
		
		String docNo = this.approvalService.hrMovementDocNo();
		
		return docNo;
	}
	
	@ResponseBody
	@GetMapping("/vacationDocNo")
	public String vacationDocNo() {
		
		String docNo = this.approvalService.vacationDocNo();
		
		return docNo;
	}
	
	@GetMapping("/approvalRequestList")
	public String approvalRequestList(Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "searchField", required = false) String searchField,
	        @RequestParam(value = "keyword", required = false) String keyword,
	        @RequestParam(value = "startDate", required = false) String startDate,
	        @RequestParam(value = "endDate", required = false) String endDate,
	        @RequestParam(value = "emrgncySttus", required = false) String emrgncySttus,
	        @RequestParam(value = "atrzSttusCd", required = false) String atrzSttusCd
			) {
		
		// 현재 인증된 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		// CustomUser로 캐스팅하여 EmployeeVO에 접근
		CustomUser customUser = (CustomUser) authentication.getPrincipal();
		EmployeeVO employeeVO = customUser.getEmployeeVO();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("drftEmpNo", employeeVO.getEmpNo());
		map.put("currentPage", currentPage);
	    map.put("searchField", searchField);
	    map.put("keyword", keyword);
	    map.put("startDate", startDate != null ? startDate.replace("-", "") : null);
	    map.put("endDate", endDate != null ? endDate.replace("-", "") : null);
	    map.put("emrgncySttus", emrgncySttus != null ? String.valueOf(emrgncySttus) : null);
	    map.put("atrzSttusCd", atrzSttusCd);
		
	    List<ApprovalDocVO> approvalRequestVOList = this.approvalService.getApprovalRequestList(map);
	    model.addAttribute("approvalRequestVOList", approvalRequestVOList);
	    
	    int total = this.approvalService.getApprovalRequestCount(map);
	    
	    ArticlePage<ApprovalDocVO> articlePage = new ArticlePage<ApprovalDocVO>(total, currentPage, 10);
	    model.addAttribute("articlePage", articlePage);
	    
	    ApprovalLineCountVO dsbApprovalRequestCountVO = this.approvalService.getDsbApprovalRequestCount(employeeVO.getEmpNo());
	    model.addAttribute("dsbApprovalDsbRequestCountVO", dsbApprovalRequestCountVO);
	    
		return "cmmn/approval/approvalRequestList";
	}
	
	@GetMapping("/approvalDocList")
	public String approvalDocList(Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "searchField", required = false) String searchField,
	        @RequestParam(value = "keyword", required = false) String keyword,
	        @RequestParam(value = "startDate", required = false) String startDate,
	        @RequestParam(value = "endDate", required = false) String endDate,
	        @RequestParam(value = "atrzSttusCd", required = false) String atrzSttusCd,
	        @RequestParam(value = "lastAtrzSttusCd", required = false) String lastAtrzSttusCd
			) {
		
		// 현재 인증된 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		// CustomUser로 캐스팅하여 EmployeeVO에 접근
		CustomUser customUser = (CustomUser) authentication.getPrincipal();
		EmployeeVO employeeVO = customUser.getEmployeeVO();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("atrzEmpNo", employeeVO.getEmpNo());
		map.put("currentPage", currentPage);
		map.put("searchField", searchField);
		map.put("keyword", keyword);
		map.put("startDate", startDate != null ? startDate.replace("-", "") : null);
	    map.put("endDate", endDate != null ? endDate.replace("-", "") : null);
		map.put("atrzSttusCd", atrzSttusCd);
		map.put("lastAtrzSttusCd", lastAtrzSttusCd);
		
		int total = this.approvalService.getApprovalDocCount(map);
		ArticlePage<ApprovalDocVO> articlePage = new ArticlePage<ApprovalDocVO>(total, currentPage, 10);
		model.addAttribute("articlePage", articlePage);
		
		ApprovalLineCountVO dsbApprovalDocCountVO = this.approvalService.getDsbApprocalDocCount(employeeVO.getEmpNo());
		model.addAttribute("dsbApprovalDocCountVO", dsbApprovalDocCountVO);
		
		List<ApprovalDocVO> approvalDocVOList = this.approvalService.getApprovalDocList(map);
		model.addAttribute("approvalDocVOList", approvalDocVOList);
		
		return "cmmn/approval/approvalDocList";
	}
	
	@ResponseBody
	@PostMapping("/getDocumentForm")
	public DocumentFormVO getDocumentForm(@RequestBody String formNo) {
		
		DocumentFormVO documentFormVO = this.approvalService.getDocumentForm(formNo);
		
		return documentFormVO;
	}
	
	@ResponseBody
	@PostMapping("/workRun")
	public int workRun(@RequestBody Map<String, Object> map) {
		
		int res = this.approvalService.updateEmpInfo(map);
		
		return res;
	}
	
	@ResponseBody
	@PostMapping(value = "/moveInfo", produces = "text/plain; charset=UTF-8")
	public String moveInfo(@RequestBody Map<String, Object> map) {
		String empNm = this.approvalService.getEmpNm(map);
		
		return empNm;
	}
	
	@ResponseBody
	@PostMapping(value = "/getAlramEmpNm", produces = "text/plain; charset=UTF-8")
	public String moveInfo(@RequestBody String empNo) {
		String empNm = this.approvalService.getAlramEmpNm(empNo);
		
		return empNm;
	}
}
