package kr.or.ddit.manage.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.service.FixturesService;
import kr.or.ddit.manage.vo.CarUseLedgerVO;
import kr.or.ddit.manage.vo.FixturesUseLedgerVO;
import kr.or.ddit.manage.vo.FixturesVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/fixtures")
public class FixturesController {
	
	@Inject
	FixturesService fixturesService;
	
	// 비품 목록 조회
	@GetMapping("/list")
	public String list(
			Model model,
			@RequestParam(value="gubun",required=false,defaultValue="") String gubun,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
			@RequestParam(value = "position", required = false) String position,  // 위치 검색 추가
		    @RequestParam(value = "status", required = false) String status,      // 상태 검색 추가
		    @RequestParam(value = "startDate", required = false) String startDate, // 구입 시작일
		    @RequestParam(value = "endDate", required = false) String endDate,     // 구입 종료일
			@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage
			) {
		log.info("Selected position: " + position);
		
		// 날짜에서 (-) 제거
	    if (startDate != null && !startDate.isEmpty()) {
	        startDate = startDate.replaceAll("-", ""); // 2024-09-25 -> 20240925
	    }

	    if (endDate != null && !endDate.isEmpty()) {
	        endDate = endDate.replaceAll("-", ""); // 2024-09-25 -> 20240925
	    }

		// 검색 조건 및 현재 페이지 map에 설정
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("gubun",gubun);
		map.put("keyword", keyword);
		map.put("position", position);
		map.put("status", status);
	    map.put("startDate", startDate);
	    map.put("endDate", endDate);
		map.put("currentPage", currentPage);
		
		log.info("list -> map : " + map);
		
		// 대시보드
		// 전체 총 개수
		int count = this.fixturesService.getCount();
		log.info("*******************count : " +count);
		// 작년 대비
		Map<String,Object> dashYear = this.fixturesService.dashYear();
		log.info("*******************dashYear : " +dashYear);
		//올해 총 개수
		Map<String,Object> currentYearCount = this.fixturesService.currentYearCount();
		log.info("*******************currentYearCount : " +currentYearCount);
		//최근 등록 일자
		String currentDate = this.fixturesService.currentDate();
		log.info("*******************currentDate : " +currentDate);		
		
		//현재 사용 가능 비품
		int statusInA = this.fixturesService.statusInA();
		log.info("*******************statusInA : " +statusInA);
		//현재 사용 중 비품
		int statusInU = this.fixturesService.statusInU();
		log.info("*******************statusInU : " +statusInU);
		//현재 사용 불가 비품
		int statusU = this.fixturesService.statusU();
		log.info("*******************statusU : " +statusU);
		
		// 검색 조건에 따른 비품 목록 조회
		List<FixturesVO> fixturesVOList = this.fixturesService.list(map);
		log.info("fixturesVOList => " + fixturesVOList);
		
		// <공통 코드> 비품 위치 코드 목록 및 비품 상태 코드 목록 조회
		List<CommonCodeVO> positions = this.fixturesService.getPositions();  // 위치 코드 리스트 조회
		List<CommonCodeVO> statuses = this.fixturesService.getStatuses();    // 상태 코드 리스트 조회
		log.info("positions : " + positions);
		log.info("statuses : " + statuses);
		
		// 전체 데이터 개수 조회
		int total = this.fixturesService.getTotal(map);
		log.info("fixtures -> total : " + total);
		
		//페이징 처리
		ArticlePage<FixturesVO> articlePage = new ArticlePage<FixturesVO> (total,currentPage,10,fixturesVOList,keyword);
		
		model.addAttribute("fixturesVOList", fixturesVOList);
		model.addAttribute("articlePage", articlePage);
		model.addAttribute("positions", positions);
		model.addAttribute("statuses", statuses);
		model.addAttribute("count",count );
		model.addAttribute("dashYear", dashYear);
		model.addAttribute("currentYearCount", currentYearCount);
		model.addAttribute("currentDate", currentDate);
		model.addAttribute("statusInA", statusInA);
		model.addAttribute("statusInU", statusInU);
		model.addAttribute("statusU", statusU);
		
		return "manage/fixtures/list";
	}
	
	// 비품 정보 수정
	@ResponseBody
	@PostMapping("/updateAjax")
	public String updateAjax(FixturesVO fixturesVO) {
		log.info("updateAjax->fixturesVO : " + fixturesVO );
		
		// 비품 정보 업데이트 처리
		int result = this.fixturesService.update(fixturesVO);
		log.info("result -> " + result);
		
		
		return "manage/fixtures/list";
	}
	
	// 비품 정보 등록
	@PostMapping("/registPost")
	public String registPost(FixturesVO fixturesVO) {
		
	    log.info("registPost -> fixturesVO : " + fixturesVO);
	   
	    // 비품 정보 등록 처리
	    int result = this.fixturesService.registPost(fixturesVO);
	    log.info("result -> " + result);
	    
	    return "manage/fixtures/list";
	}
	
	//formData는 RequestBody가 아님
	//https://velog.io/@sorakim92/mybatismysql-update%EB%AC%B8-where-%EC%A1%B0%EA%B1%B4-in-%EB%A1%9C-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B3%B4%EB%82%B4%EA%B8%B0
	//참고하기
	@ResponseBody
	@PostMapping("/deleteAjax")
	public String deleteAjax(FixturesVO fixturesVO) {
		//...fxtrsNoList=[B0002, B0005, B0006])
		log.info("deleteAjax->fixturesVO : " + fixturesVO);
		
		// 삭제할 비품 번호 목록 생성 
		String[] checks = fixturesVO.getFxtrsNoList();
		
		// 받아온 value 값 for문으로 list에 넣어주기
		List<String> check_list = new ArrayList<String>();
	    
	    for(String id : checks) {
	    	check_list.add(id);
	    }
	    
	    // 생략가능 
	    System.out.println("deleteAjax->check_list : " + check_list); // [B0002, B0005, B0006]
	    
	    Map<String, Object> params = new HashMap<String, Object>();
	    // map에 list 넣어주기 [B0002, B0005, B0006]
	   	params.put("checkList", check_list);
	   	
	    // 비품 삭제 처리
	   	int result = this.fixturesService.deleteAjax(params);
	   	log.info("deleteAjax->result : " + result);
		
		return "success";
	}
	
	// 파일 상세 정보 조회
	//{"fileGroupNo":3}
	@ResponseBody
	@PostMapping("/getFileDetails")
	public List<FileDetailVO> getFileDetails(int fileGroupNo){
		log.info("getFileDetails->fileGroupNo : " + fileGroupNo);
		
		// 파일 그룹 번호에  대한 파일 상세 정보 조회
		List<FileDetailVO> fileDetailVOList = this.fixturesService.getFileDetails(fileGroupNo);
		log.info("getFileDetails->fileDetailVOList : " + fileDetailVOList);
		
		return fileDetailVOList;
	}
	
	@GetMapping("/ledger")
	public String ledger(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="gubun",required=false,defaultValue="") String gubun,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
		    @RequestParam(value = "startDate", required = false) String startDate, // 구입 시작일
		    @RequestParam(value = "endDate", required = false) String endDate,     // 구입 종료일
		    @RequestParam(value = "minDriveDist", required = false, defaultValue = "") String minDriveDist, // 운행 거리 최소값
		    @RequestParam(value = "maxDriveDist", required = false, defaultValue = "") String maxDriveDist, // 운행 거리 최대값
			@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage
			) {
		
	    // startDate & endDate 하이픈 제거
	    if (startDate != null && !startDate.isEmpty()) {
	        startDate = startDate.replace("-", "");
	    }
	    if (endDate != null && !endDate.isEmpty()) {
	        endDate = endDate.replace("-", "");
	    }
		
	    // 검색 조건 map에 설정
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("searchField",searchField);
		map.put("gubun",gubun);
		map.put("keyword", keyword);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("minDriveDist", minDriveDist);
		map.put("maxDriveDist", maxDriveDist);
		map.put("currentPage", currentPage);
		
		List<FixturesUseLedgerVO> fixturesLedgerList = this.fixturesService.fixturesLedgerList(map);
	    log.info("fixturesLedgerList -> " + fixturesLedgerList);
	    
	    List<EmployeeVO> empList = this.fixturesService.empList();
	    log.info("empList : " + empList);
	    List<FixturesVO> fixturesVOList = this.fixturesService.list(map);
	    
		// 전체 데이터 개수 조회
		int total = this.fixturesService.getLedgerTotal(map);
		log.info("fixturesLedger -> total : " + total);
		
		//페이징 처리
		ArticlePage<FixturesUseLedgerVO> articlePage = new ArticlePage<FixturesUseLedgerVO> (total,currentPage,10,fixturesLedgerList,keyword);

		model.addAttribute("fixturesLedgerList", fixturesLedgerList);
		model.addAttribute("articlePage", articlePage);
		model.addAttribute("empList", empList);
		model.addAttribute("fixturesVOList", fixturesVOList);
		
		return "manage/fixtures/fixturesUseLedger";
	}
	
	//자동완성
	@PostMapping("/autocomplete")
	public @ResponseBody Map<String, Object> autocomplete(@RequestParam Map<String, Object> paramMap) throws Exception {
		log.info("Received paramMap: {}", paramMap);
		
		List<Map<String, Object>> resultList = fixturesService.autocomplete(paramMap);
		
	    Map<String, Object> responseMap = new HashMap<>();
	    responseMap.put("resultList", resultList);

	    return responseMap;  // JSON 형태로 반환
	}
	
	
	@PostMapping("/registFxtLedger")
	public String registFxtLedger(FixturesUseLedgerVO fixturesUseLedgerVO) {
		log.info("registFxtLedger : " + fixturesUseLedgerVO);
		
	    // useYmd와 rtnYmd 필드에서 하이픈(-)을 제거하고 8자리로 변환
	    if (fixturesUseLedgerVO.getUseYmd() != null) {
	        String useYmd = fixturesUseLedgerVO.getUseYmd().replaceAll("-", "");
	        fixturesUseLedgerVO.setUseYmd(useYmd);
	    }

	    if (fixturesUseLedgerVO.getRtnYmd() != null) {
	        String rtnYmd = fixturesUseLedgerVO.getRtnYmd().replaceAll("-", "");
	        fixturesUseLedgerVO.setRtnYmd(rtnYmd);
	    }
	    
	    log.info("fixturesUseLedgerVO" + fixturesUseLedgerVO);
	    
	    int result = this.fixturesService.registFxtLedger(fixturesUseLedgerVO);
	    log.info("registFxtLedger -> result : " + result);
	    
	    return "redirect:/fixtures/ledger";
	}
	
	@PostMapping("/updateFxtLedger")
	public String updateFxtLedger (FixturesUseLedgerVO fixturesUseLedgerVO) {
		log.info("updateFxtLedger : " + fixturesUseLedgerVO);
		
	    // useYmd와 rtnYmd 필드에서 하이픈(-)을 제거하고 8자리로 변환
	    if (fixturesUseLedgerVO.getUseYmd() != null) {
	        String useYmd = fixturesUseLedgerVO.getUseYmd().replaceAll("-", ""); 
	        fixturesUseLedgerVO.setUseYmd(useYmd);
	    }

	    if (fixturesUseLedgerVO.getRtnYmd() != null) {
	        String rtnYmd = fixturesUseLedgerVO.getRtnYmd().replaceAll("-", "");
	        fixturesUseLedgerVO.setRtnYmd(rtnYmd);
	    }
	    
	    int result = this.fixturesService.updateFxtLedger(fixturesUseLedgerVO);
	    log.info("updateFxtLedger -> result : " + result);
	    
	    return "redirect:/fixtures/ledger";
	    
	}
	
	
	
}





