package kr.or.ddit.hr.controller;


import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.DocumentVO;
import kr.or.ddit.hr.service.HrMovementDocService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrMovementDocVO;
import kr.or.ddit.hr.vo.ResignationDocVO;
import kr.or.ddit.hr.vo.VacationDocVO;
import lombok.extern.slf4j.Slf4j;

/** 인사이동(HR_MOVEMENT_DOC) Controller
 * 
 * @author 장영원
 */
@Slf4j
@Controller
@RequestMapping("/hrMovementDoc")
public class HrMovementDocController {
	
	//인사이동 서비스 명
	@Inject
	HrMovementDocService hrMovementDocService;
	
	//인사이동 리스트
	@GetMapping("/list")
	public String hrMovementDoclist(Model model) {
		
		List<HrMovementDocVO> hrMovementDocVOList = this.hrMovementDocService.hrMovementDoclist();
		log.info("hrMovementDocVOList : " + hrMovementDocVOList);
		model.addAttribute("hrMovementDocVOList", hrMovementDocVOList);
		
//		List<DocumentVO> documentVOList = this.hrMovementDocService.getAllDocList();
//		log.info("documentVOList " + documentVOList);
//		model.addAttribute("documentVOList", documentVOList);
		
		return "hr/hrMovementDoc/list";
	}
	
	//인사이동 등록
	@GetMapping("/regist")
	public String hrMovementDocRegist(Model model) {
		
		List<CommonCodeVO> deptList = this.hrMovementDocService.deptList();
		log.info("deptList : " + deptList);
		
		List<CommonCodeVO> jbgdList = this.hrMovementDocService.jbgdList();
		log.info("jbgdList : " + jbgdList);
		
		EmployeeVO hrLeader = this.hrMovementDocService.hrLeader();
		log.info("hrLeader : " + hrLeader);
		
		EmployeeVO ceo = this.hrMovementDocService.ceo();
		log.info("ceo : " + ceo);
		
		List<CommonCodeVO> vacationReasonList = this.hrMovementDocService.vacationReasonList();
		log.info("vacationReasonList : " + vacationReasonList);
		
		model.addAttribute("deptList", deptList);
		model.addAttribute("jbgdList", jbgdList);
		model.addAttribute("hrLeader", hrLeader);
		model.addAttribute("ceo", ceo);
		model.addAttribute("vacationReasonList", vacationReasonList);
		
		return "hr/hrMovementDoc/regist";
	}
	
	//인사이동 서류 저장.
	@PostMapping("/hrMovementDocRegist")
	public String hrMovementDocRegist(@RequestParam("htmlCd") String htmlCd, HrMovementDocVO hrMovementDocVO) {
		hrMovementDocVO.setHtmlCd(htmlCd); // 받은 HTML 코드를 EmployeeVO에 저장
		
	    int result = hrMovementDocService.hrMovementDocRegist(hrMovementDocVO); // 서비스로 전달하여 DB에 저장
		log.info("결 과 ... :" + result);
	    
		return "redirect:/hrMovementDoc/regist";
	}
	
	//휴가 서류 저장.
	@PostMapping("/vacationDocRegist")
	public String vacationDocRegist(@RequestParam("htmlCd") String htmlCd, VacationDocVO vacationDocVO) {
		vacationDocVO.setHtmlCd(htmlCd); // 받은 HTML 코드를 EmployeeVO에 저장
		
		int result = hrMovementDocService.vacationDocRegist(vacationDocVO); // 서비스로 전달하여 DB에 저장
		log.info("결 과 ... :" + result);
		
		return "redirect:/hrMovementDoc/regist";
	}

	//휴가 서류 저장.
	@PostMapping("/resignationDocRegist")
	public String resignationDocRegist(@RequestParam("htmlCd") String htmlCd, ResignationDocVO resignationDocVO) {
		resignationDocVO.setHtmlCd(htmlCd); // 받은 HTML 코드를 EmployeeVO에 저장
		
		int result = hrMovementDocService.resignationDocRegist(resignationDocVO); // 서비스로 전달하여 DB에 저장
		log.info("결 과 ... :" + result);
		
		return "redirect:/hrMovementDoc/regist";
	}
	
	//특정 문서 조회
	@GetMapping("/detail")
	public String getHrMovementDoc(Model model) {
		String docNo = "HRMVE00006";
		
		HrMovementDocVO hrMovementDocVO = hrMovementDocService.getHrMovementDoc(docNo);
		
		try {
			String decodedHtml = URLDecoder.decode(hrMovementDocVO.getHtmlCd(), "UTF-8");
            hrMovementDocVO.setHtmlCd(decodedHtml); // 디코딩된 HTML 코드를 VO에 저장
        } catch (Exception e) {
            e.printStackTrace(); // 오류 발생 시 로그 출력
        }
		
        model.addAttribute("hrMovementDocVO", hrMovementDocVO);
        
		return "hr/hrMovementDoc/detail";
	}
	
	//부서에 따른 사원 정보 가져오기
	@ResponseBody
	@PostMapping("/deptEmpList")
	public CommonCodeVO deptEmpList(@RequestBody CommonCodeVO commonCodeVO) {
		//부서번호
		String deptCd = commonCodeVO.getClsfCd();
		log.info("deptCd : " + deptCd);
		
		commonCodeVO = this.hrMovementDocService.deptEmpList(deptCd);
		log.info("commonCodeVO : " + commonCodeVO);
		
		return commonCodeVO;
	}
	
	//부서에 따른 사원 정보 가져오기
	@ResponseBody
	@PostMapping("/empDetail")
	public EmployeeVO empDetail(@RequestBody EmployeeVO employeeVO) {
		//부서번호
		String empNo = employeeVO.getEmpNo();
		log.info("empNo : " + empNo);
		
		employeeVO = this.hrMovementDocService.empDetail(empNo);
		log.info("employeeVO : " + employeeVO);
		
		return employeeVO;
	}
	
	//자동완성
	@PostMapping("/autocomplete")
	public @ResponseBody Map<String, Object> autocomplete(@RequestParam Map<String, Object> paramMap) throws Exception {
	    List<Map<String, Object>> resultList = hrMovementDocService.autocomplete(paramMap);

	    Map<String, Object> responseMap = new HashMap<>();
	    responseMap.put("resultList", resultList);

	    return responseMap;  // JSON 형태로 반환
	}
	
}

 