package kr.or.ddit.planng.controller;

import java.security.Principal;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.time.DateFormatUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.planng.service.CalendarService;
import kr.or.ddit.planng.vo.CalendarVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class CalendarController {
	
	@Autowired
	CalendarService calendarService;

	//캘린더 페이지로
	@GetMapping("/calendarList")
	public String calendarList(Model model) {
		
		return "planng/calendarList";
	}
	
	//전체 일정
	@GetMapping("/getAllEvents")
	@ResponseBody
	public List<CalendarVO> getAllEvents(Principal principal) {
		
		String empNo = principal.getName();
		
		return calendarService.getAllEvents(empNo);
	}
	
	//공통 일정
	@PostMapping("/getCommonEvents")
	@ResponseBody
	public List<CalendarVO> getCommonEvents() {
		
		List<CalendarVO> calendarVOList = this.calendarService.getCommonEvents();
		
		return calendarVOList;
	}
	
	//부서 일정
	@PostMapping("/getDeptEvents")
	@ResponseBody
	public List<CalendarVO> getDeptEvents(@RequestBody CalendarVO calendarVO) {
		
		String empNo = calendarVO.getEmpNo();
		
		List<CalendarVO> calendarVOList = this.calendarService.getDeptEvents(empNo);
		
		return calendarVOList;
	}
	
	//개인 일정
	@PostMapping("/getPerEvents")
	@ResponseBody
	public List<CalendarVO> getPerEvents(@RequestBody CalendarVO calendarVO) {
		
		String empNo = calendarVO.getEmpNo();
		
		List<CalendarVO> calendarVOList = this.calendarService.getPerEvents(empNo);
		
		return calendarVOList;
	}
	
	//일정 추가하기
	@PostMapping("/insertEvents")
	public String insertEvetns(@ModelAttribute CalendarVO calendarVO) {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String empNo = authentication.getName();
		
		calendarVO.setEmpNo(empNo);
		
		int result = this.calendarService.insertEvents(calendarVO);
		
		return "redirect:/calendarList";
	}
	
	//일정 수정하기
	@PostMapping("/updateEvents")
	public String updateEvents(@ModelAttribute CalendarVO calendarVO) {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String empNo = authentication.getName();
		String schdlNo = calendarVO.getSchdlNo();
		
		calendarVO.setEmpNo(empNo);
		calendarVO.setSchdlNo(schdlNo);
		
		log.info("updateEvents -> calendarVO: " + calendarVO);
		
		int result = this.calendarService.updateEvents(calendarVO);
		
		return "redirect:/calendarList";
	}
	
	//일정 삭제하기
	@PostMapping("/deleteEvents")
	public String deleteEvents(@RequestParam("schdlNo") String schdlNo) {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String empNo = authentication.getName();
		
		CalendarVO calendarVO = new CalendarVO();
		calendarVO.setSchdlNo(schdlNo);
		calendarVO.setEmpNo(empNo);
		
		int result = this.calendarService.deleteEvents(calendarVO);
		
		return "redirect:/calendarList";
	}
}
