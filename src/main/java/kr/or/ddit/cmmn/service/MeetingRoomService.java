package kr.or.ddit.cmmn.service;

import java.util.List;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.MeetingRoomVO;
import kr.or.ddit.hr.vo.EmployeeVO;

public interface MeetingRoomService {
	
	// <공통 코드> 부서 리스트 조회
	public List<CommonCodeVO> deptList();

	// <공통 코드> 회의실 리스트 조회
	public List<CommonCodeVO> meetingRoomList();

	// 회의실 예약 등록
	public int registRes(MeetingRoomVO meetingRoomVO);
	
	// 특정 날짜 (당일)의 모든 회의실 예약 조회
	public List<MeetingRoomVO> getAllReservations(String today);

	// 특정 사원 정보 조회
	public EmployeeVO empSelect(String empNo);

	// 회의실 예약 삭제 
	public int deleteRes(String rsvtNo);

	public int checkRes(MeetingRoomVO meetingRoomVO);
	



}
