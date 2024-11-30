package kr.or.ddit.planng.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.planng.mapper.CalendarMapper;
import kr.or.ddit.planng.service.CalendarService;
import kr.or.ddit.planng.vo.CalendarVO;

@Service
public class CalendarServiceImpl implements CalendarService {
	
	@Autowired
	CalendarMapper calendarMapper;

	//전체 일정 불러오기
	@Override
	public List<CalendarVO> getAllEvents(String empNo) {
		return this.calendarMapper.getAllEvents(empNo);
	}
	
	//공통 일정 불러오기
	@Override
	public List<CalendarVO> getCommonEvents() {
		return this.calendarMapper.getCommonEvents();
	}
	
	//부서 일정 불러오기
	@Override
	public List<CalendarVO> getDeptEvents(String empNo) {
		return this.calendarMapper.getDeptEvents(empNo);
	}
	
	//개인 일정 불러오기
	@Override
	public List<CalendarVO> getPerEvents(String empNo) {
		return this.calendarMapper.getPerEvents(empNo);
	}
	
	//일정 추가
	@Override
	public int insertEvents(CalendarVO calendarVO) {
		return this.calendarMapper.insertEvents(calendarVO);
	}
	
	//일정 수정
	@Override
	public int updateEvents(CalendarVO calendarVO) {
		return this.calendarMapper.updateEvents(calendarVO);
	}
	
	//일정 삭제
	@Override
	public int deleteEvents(CalendarVO calendarVO) {
		return this.calendarMapper.deleteEvents(calendarVO);
	}
	



}
