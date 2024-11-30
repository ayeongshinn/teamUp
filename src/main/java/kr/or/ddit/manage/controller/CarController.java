package kr.or.ddit.manage.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.service.CarService;
import kr.or.ddit.manage.vo.CarVO;
import kr.or.ddit.manage.vo.CarUseLedgerVO;
import kr.or.ddit.manage.vo.FixturesVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

@Slf4j
@Controller
@RequestMapping("/car")
public class CarController {
	
	@Inject
	CarService carService;
	
	// 차량 목록 조회
	@GetMapping("/list")
	public String list(Model model,
			@RequestParam(value="gubun",required=false,defaultValue="") String gubun,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
			@RequestParam(value="status", required=false, defaultValue="") String status,  // 차량 상태
			@RequestParam(value="carType", required=false, defaultValue="") String carType, // 차종
			@RequestParam(value="mfr", required=false, defaultValue="") String mfr, // 제조사
		    @RequestParam(value = "startDate", required = false) String startDate, // 구입 시작일
		    @RequestParam(value = "endDate", required = false) String endDate,     // 구입 종료일
			@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage
			) {
		
		// startDate, endDate의 하이픈 제거
	    if (startDate != null && !startDate.isEmpty()) {
	        startDate = startDate.replaceAll("-", ""); // 2024-09-25 -> 20240925
	    }

	    if (endDate != null && !endDate.isEmpty()) {
	        endDate = endDate.replaceAll("-", ""); // 2024-09-25 -> 20240925
	    }
		
	    // 검색 조건과 페이지 정보를 map에 저장
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("gubun",gubun);
		map.put("keyword", keyword);
		map.put("status", status);
		map.put("carType", carType);
		map.put("mfr", mfr);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("currentPage", currentPage);
		
		// 대시보드
		// 전체 총 개수
		int count = this.carService.getCount();
		log.info("*******************count : " +count);
		// 작년 대비
		Map<String,Object> dashYear = this.carService.dashYear();
		log.info("*******************dashYear : " +dashYear);
		//올해 총 개수
		Map<String,Object> currentYearCount = this.carService.currentYearCount();
		log.info("*******************currentYearCount : " +currentYearCount);
		//최근 등록 일자
		String currentDate = this.carService.currentDate();
		log.info("*******************currentDate : " +currentDate);		
		
		//현재 사용 가능 비품
		int statusInA = this.carService.statusInA();
		log.info("*******************statusInA : " +statusInA);
		//현재 사용 중 비품
		int statusInU = this.carService.statusInU();
		log.info("*******************statusInU : " +statusInU);
		//현재 사용 불가 비품
		int statusU = this.carService.statusU();
		log.info("*******************statusU : " +statusU);
		
		// 차량 목록 조회
		List<CarVO> carVOList = this.carService.list(map);
		log.info("carVOList => " + carVOList);
		
		// <공통 코드> 차량 상태, 차종, 제조사 목록 조회
		List<CommonCodeVO> sttus = this.carService.getSttus();  // 차량 상태
		List<CommonCodeVO> carMdl = this.carService.getCarMdl(); // 차종
		List<CommonCodeVO> mkr = this.carService.getMkr(); // 제조사
	    
		// 총 데이터 개수 조회
		int total = this.carService.getTotal(map);
		log.info("car -> total : " + total);
		
		//페이징 처리
		ArticlePage<CarVO> articlePage = new ArticlePage<CarVO> (total,currentPage,10,carVOList,keyword);
		
		model.addAttribute("carVOList", carVOList);
		model.addAttribute("articlePage", articlePage);
		model.addAttribute("sttus", sttus);
		model.addAttribute("carMdl", carMdl);
		model.addAttribute("mkr", mkr);
		model.addAttribute("count",count );
		model.addAttribute("dashYear", dashYear);
		model.addAttribute("currentYearCount", currentYearCount);
		model.addAttribute("currentDate", currentDate);
		model.addAttribute("statusInA", statusInA);
		model.addAttribute("statusInU", statusInU);
		model.addAttribute("statusU", statusU);
		
		return "manage/car/list";
	}
	
	// 파일 상세 정보 조회
	@ResponseBody
	@PostMapping("/getFileDetails")
	public List<FileDetailVO> getFileDetails(int fileGroupNo){
		log.info("getFileDetails->fileGroupNo : " + fileGroupNo);
		
		List<FileDetailVO> fileDetailVOList = this.carService.getFileDetails(fileGroupNo);
		log.info("getFileDetails->fileDetailVOList : " + fileDetailVOList);
		
		return fileDetailVOList;
	}
	
	// 차량 등록
	@ResponseBody
	@PostMapping("/registPost")
	public String registPost(CarVO carVO) {
		log.info("registPost -> carVO : " + carVO);
		
		// 차량 등록 처리
		int result = this.carService.registPost(carVO);
		log.info("result -> carVO : " + result);
		
		return "manage/car/list";
	}
	
	// 차량 정보 수정
	@ResponseBody
	@PostMapping("/updateAjax")
	public String updateAjax(CarVO carVO) {
		log.info("CarVO -> " + carVO);
		
		// 차량 정보 업데이트 처리 
		int result = this.carService.update(carVO);
		log.info("car (update) result -> " + result);
		
		return "manage/car/list";
	}
	
	// 차량 정보 삭제
	@ResponseBody
	@PostMapping("/deleteAjax")
	public String deleteAjax(CarVO carVO) {
		log.info("deleteAjax->carVO : " + carVO);
		
		// 삭제할 차량 ID 목록 생성
		String[] checks = carVO.getVhclIdList();
		
		// 받아온 value 값 for문으로 list에 넣어주기
		List<String> check_list = new ArrayList<String>();
		
		for(String id : checks) {
			check_list.add(id);
		}
		
		log.info("deleteAjax->check_list : " + check_list); 
		
		// 삭제 params 설정
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("checkList", check_list);
		
		// 차량 정보 삭제 처리
		int result = this.carService.deleteAjax(params);
		log.info("detailAjax->result : " + result);
		
		return "success";
		
	}
	
	// 차량 관리 대장 리스트 출력
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
		
		// 차량 관리 대장 목록 조회
		List<CarUseLedgerVO> carLedgerList = this.carService.carLedgerList(map);
		log.info("carLedgerList -> " + carLedgerList);
		
		// 직원 목록 및 차량 목록 조회
		List<EmployeeVO> empList = this.carService.empList();
		log.info("carLedgerList -> " + empList);
		List<CarVO> carList = this.carService.carList();
		log.info("carLedgerList -> " + carList);
		
		// 전체 데이터 개수 조회
		int total = this.carService.getLedgerTotal(map);
		log.info("car -> total : " + total);
		
		//페이징 처리
		ArticlePage<CarUseLedgerVO> articlePage = new ArticlePage<CarUseLedgerVO> (total,currentPage,10,carLedgerList,keyword);
		
		model.addAttribute("carLedgerList",carLedgerList);
		model.addAttribute("articlePage", articlePage);
		model.addAttribute("empList", empList);
		model.addAttribute("carList", carList);
		
		return "manage/car/carUseLedger";
		
	}
	
	// 차량 관리 대장 등록
	@PostMapping("/registLedger")
	public String registLedger (CarUseLedgerVO carUseLedgerVO) {
		log.info("registLedger : " + carUseLedgerVO);
		
	    // useYmd와 rtnYmd 필드에서 하이픈(-)을 제거하고 8자리로 변환
	    if (carUseLedgerVO.getUseYmd() != null) {
	        String useYmd = carUseLedgerVO.getUseYmd().replaceAll("-", "");
	        carUseLedgerVO.setUseYmd(useYmd);
	    }

	    if (carUseLedgerVO.getRtnYmd() != null) {
	        String rtnYmd = carUseLedgerVO.getRtnYmd().replaceAll("-", "");
	        carUseLedgerVO.setRtnYmd(rtnYmd);
	    }
	    
	    log.info("carUseLedgerVO : " + carUseLedgerVO);
		
	    // 차량 관리 대장 등록 처리
		int result = this.carService.registLedger(carUseLedgerVO);
		log.info("registLedger -> result : " + result);
		
		return "redirect:/car/ledger";
	}
	
	// 차량 관리 대장 수정
	@PostMapping("/updateLedger")
	public String updateLedger (CarUseLedgerVO carUseLedgerVO) {
		log.info("updateLedger : " + carUseLedgerVO);
		
	    // useYmd와 rtnYmd 필드에서 하이픈(-)을 제거하고 8자리로 변환
	    if (carUseLedgerVO.getUseYmd() != null) {
	        String useYmd = carUseLedgerVO.getUseYmd().replaceAll("-", ""); 
	        carUseLedgerVO.setUseYmd(useYmd);
	    }

	    if (carUseLedgerVO.getRtnYmd() != null) {
	        String rtnYmd = carUseLedgerVO.getRtnYmd().replaceAll("-", "");
	        carUseLedgerVO.setRtnYmd(rtnYmd);
	    }
		
	    // 차량 관리 대장 수정 처리
		int result = this.carService.updateLedger(carUseLedgerVO);
		log.info(" registLedger -> result : " + result);
		
		return "redirect:/car/ledger";
	}

}
