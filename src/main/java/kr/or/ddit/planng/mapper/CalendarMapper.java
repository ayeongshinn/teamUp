package kr.or.ddit.planng.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.planng.vo.CalendarVO;

@Mapper
public interface CalendarMapper {
	
	//전체 일정 불러오기
	public List<CalendarVO> getAllEvents(String empNo);

	//공통 일정 불러오기
	public List<CalendarVO> getCommonEvents();
	
	//부서 일정 불러오기
	public List<CalendarVO> getDeptEvents(String empNo);

	//개인 일정 불러오기
	public List<CalendarVO> getPerEvents(String empNo);
	
	//일정 추가
	public int insertEvents(CalendarVO calendarVO);
	
	//일정 수정
	public int updateEvents(CalendarVO calendarVO);
	
	//일정 삭제
	public int deleteEvents(CalendarVO calendarVO);


	
}
