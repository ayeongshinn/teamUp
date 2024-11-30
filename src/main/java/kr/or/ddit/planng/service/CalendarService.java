package kr.or.ddit.planng.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.planng.vo.CalendarVO;

public interface CalendarService {

	//전체 일정 가져오기
	public List<CalendarVO> getAllEvents(String empNo);
	
	//공통 일정 가져오기
	public List<CalendarVO> getCommonEvents();

	//부서 일정 불러오기
	public List<CalendarVO> getDeptEvents(String empNo);
	
	//개인 일정 가져오기
	public List<CalendarVO> getPerEvents(String empNo);
	
	//일정 추가
	public int insertEvents(CalendarVO calendarVO);
	
	//일정 수정
	public int updateEvents(CalendarVO calendarVO);
	
	//일정 삭제
	public int deleteEvents(CalendarVO calendarVO);
	

	
}
