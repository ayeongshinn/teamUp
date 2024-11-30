package kr.or.ddit.cmmn.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import java.nio.charset.StandardCharsets;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.MeetingRoomService;
import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.MeetingRoomVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/meetingRoom")
public class MeetingRoomController {
	
	@Inject
	MeetingRoomService meetingRoomService;

	// 회의실 예약 현황 리스트 출력
	@GetMapping("/list")
	public String list(Model model) {
		
		// <공통 코드 > 사원 부서 리스트 - 영업부, 기획부, 관리부  •••
		List<CommonCodeVO> deptList = this.meetingRoomService.deptList();
		// <공통 코드 > 회의실 리스트 - 회의실 1(A05-001), 회의실 2(A05-002), 회의실 3(A05-003) •••
		List<CommonCodeVO> mrList = this.meetingRoomService.meetingRoomList();
		
		log.info("deptList : " + deptList);
		log.info("meetingRoomList : " + mrList);
	
		model.addAttribute("deptList", deptList);
		model.addAttribute("mrList", mrList);
		
		return "cmmn/meetingRoom/list";
	}
	
	// 회의실 예약 등록
	@PostMapping("/registRes")
	public String registRes(Model model, MeetingRoomVO meetingRoomVO) {
		
		log.info("registRes -> meetingRoomVO : " + meetingRoomVO);
		
		
		// 예약 등록 처리
		int result = this.meetingRoomService.registRes(meetingRoomVO);
		log.info("result -> " + result );
		
		return "cmmn/meetingRoom/list";
	} 
	
	// 오늘 날짜 기준 예약 정보 조회
	@GetMapping("/getReservations")
	@ResponseBody
	public List<MeetingRoomVO> getReservations() {
		
		String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		log.info("today : " + today);
		 
		// 오늘 날짜의 모든 예약 정보 조회
		List<MeetingRoomVO> reservations = meetingRoomService.getAllReservations(today);
		log.info("reservations -> " + reservations);
		
		return reservations;
	}
	
	// 사원 정보 조회
	@PostMapping("/empSelect")
	@ResponseBody
	public EmployeeVO empSelect(@RequestParam("empNo") String empNo) {
		
		
		// 사원 번호로 조회
		EmployeeVO empVO = this.meetingRoomService.empSelect(empNo);
		log.info("empVO : " + empVO);
		
		return empVO;
	}
	
	// 회의실 예약 정보 상세
	@GetMapping("/detail")
	public String detail(Model model) {
		
		String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		log.info("today : " + today);
		 
		List<MeetingRoomVO> reservations = meetingRoomService.getAllReservations(today);
		log.info("reservations -> " + reservations);
		
		List<CommonCodeVO> mrList = this.meetingRoomService.meetingRoomList();
		log.info("meetingRoomList : " + mrList);
		
		model.addAttribute("reservations", reservations);
		model.addAttribute("mrList", mrList);
		
		return "cmmn/meetingRoom/detail";
	}
	
	// 회의실 예약 삭제
	@PostMapping("/deleteRes")
	@ResponseBody
	public String deleteRes(@RequestParam("rsvtNo") String rsvtNo) {
		log.info("삭제 컨트롤러에 왔다 🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀🦀");
		
		// 예약 번호로 예약 삭제
		int result = this.meetingRoomService.deleteRes(rsvtNo);
		log.info("❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️result -> " + result);
		
		return "success";
		
	}
	
	@GetMapping("/listN")
	public String testtest(Model model) {
		
		// <공통 코드 > 사원 부서 리스트 - 영업부, 기획부, 관리부  •••
		List<CommonCodeVO> deptList = this.meetingRoomService.deptList();
		// <공통 코드 > 회의실 리스트 - 회의실 1(A05-001), 회의실 2(A05-002), 회의실 3(A05-003) •••
		List<CommonCodeVO> mrList = this.meetingRoomService.meetingRoomList();
		
		log.info("deptList : " + deptList);
		log.info("meetingRoomList : " + mrList);
	
		model.addAttribute("deptList", deptList);
		model.addAttribute("mrList", mrList);
		
		return "cmmn/meetingRoom/listN";
	}
	
	@PostMapping("/registMRN")
	public ResponseEntity<String> registMRN(MeetingRoomVO meetingRoomVO) {
	    int chkResult = this.meetingRoomService.checkRes(meetingRoomVO);
	    log.info("⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕chkResult : " + chkResult);
	    if (chkResult != 0) {
	    	return ResponseEntity
	    	        .status(HttpStatus.CONFLICT)
	    	        .contentType(new MediaType("text", "plain", StandardCharsets.UTF_8))
	    	        .body("이미 예약된 시간입니다.");

	    }
	    
	    int result = this.meetingRoomService.registRes(meetingRoomVO);
	    return ResponseEntity.ok("예약이 완료되었습니다.");
	} 
}
