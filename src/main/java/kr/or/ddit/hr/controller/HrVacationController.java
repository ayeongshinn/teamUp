package kr.or.ddit.hr.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.bsn.vo.CounterPartyVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.hr.service.HrMovementDocService;
import kr.or.ddit.hr.service.HrVacationService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

/** 휴가(VACATION) Controller
 * 
 * @author 장영원
 */
@Slf4j
@Controller
@RequestMapping("/hrVacation")
public class HrVacationController {
	
	//휴가 서비스
	@Inject
	HrVacationService hrVacationService;
	
	//부서 리스트 가져오기 위한 인사이동 서비스
	@Inject
	HrMovementDocService hrMovementDocService;
	
	//휴가 리스트 출력
	@GetMapping("/list")
	public String hrVacationList(Model model,
	                             @RequestParam(value = "deptCd", required = false, defaultValue = "") String deptCd,
	                             @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
	                             @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
	                             @RequestParam(value = "orderBy", required = false, defaultValue = "") String orderBy,
	                             @RequestParam(value = "sortOrder", required = false, defaultValue = "") String sortOrder ) {

	    // 검색 및 정렬 파라미터를 맵에 추가
	    Map<String, Object> map = new HashMap<>();
	    map.put("deptCd", deptCd);
	    map.put("keyword", keyword);
	    map.put("currentPage", currentPage);
        map.put("orderBy", orderBy);
        map.put("sortOrder", sortOrder);
	    
	    // 휴가 리스트 가져오기
	    List<HrVacationVO> hrVacationVOList = this.hrVacationService.list(map);
	    log.info("hrVacationVOList -> " + hrVacationVOList);
	    model.addAttribute("hrVacationVOList", hrVacationVOList);

	    // 전체 행의 수
	    int total = this.hrVacationService.getTotal(map);
	    log.info("list => total : " + total);
	    
	    // 페이지네이션 객체
	    ArticlePage<HrVacationVO> articlePage = new ArticlePage<>(total, currentPage, 10, hrVacationVOList, keyword);
	    model.addAttribute("articlePage", articlePage);

	    // 부서 리스트 가져오기
	    List<CommonCodeVO> deptList = this.hrMovementDocService.deptList();
	    log.info("deptList : " + deptList);
	    model.addAttribute("deptList", deptList);
	    
	    //잔여 휴가가 많이 남은 사원
	    List<HrVacationVO> holdVcatnTop3 = this.hrVacationService.holdVcatnTop3();
	    log.info("holdVcatnTop3 : " + holdVcatnTop3);
	    model.addAttribute("holdVcatnTop3", holdVcatnTop3);

	    // 부서 코드 매핑
	    Map<String, String> deptNmMap = new HashMap<>();
	    deptNmMap.put("A17-001", "경영진");
	    deptNmMap.put("A17-002", "기획부서");
	    deptNmMap.put("A17-003", "관리부서");
	    deptNmMap.put("A17-004", "영업부서");
	    deptNmMap.put("A17-005", "인사부서");
	    deptNmMap.put("전체", "전체");
	    model.addAttribute("deptNmMap", deptNmMap);

	    return "hr/hrVacation/list";
	}
	
	//특정 사원의 휴가 최신 데이터 조회
	@PostMapping("/lastVcatnDetail")
	public ResponseEntity<HrVacationVO> lastVcatnDetail(@RequestParam("empNo") String empNo) {
		
		HrVacationVO hrVacationVO = this.hrVacationService.lastVcatnDetail(empNo);
		log.info("hrVacationVO" + hrVacationVO);
		
		 // 직원 정보가 없으면 404 Not Found 반환
        if (hrVacationVO == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        // 정상적으로 직원 정보를 JSON 형태로 반환
        return new ResponseEntity<>(hrVacationVO, HttpStatus.OK);
	}
	
	//특정 사원에 추가로 휴가 부여
	@PostMapping("/grantVacation")
    public String grantVacation(@RequestParam("grntVcatnDayCnt") int grntVcatnDayCnt,
                                @RequestParam("reason") String reason,
                                @RequestParam("empNo") String empNo,
                                Model model) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("grntVcatnDayCnt", grntVcatnDayCnt);
		map.put("reason", reason);
		
        int result = this.hrVacationService.grantVacation(map);
        log.info("과연 휴가 추가로 부여하기가 성공했을 것인가??!!  " + result);

        // 저장 후 다른 페이지로 이동 또는 메세지 반환
        return "redirect:/hrVacation/list"; // 성공 시 리다이렉트
    }
}
