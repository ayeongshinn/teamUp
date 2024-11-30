package kr.or.ddit.cmmn.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.mapper.MeetingRoomMapper;
import kr.or.ddit.cmmn.service.MeetingRoomService;
import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.MeetingRoomVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MeetingRoomServiceImpl implements MeetingRoomService {
	
	@Inject
	MeetingRoomMapper meetingRoomMapper;
	
	// <공통 코드> 부서 리스트 조회
	@Override
	public List<CommonCodeVO> deptList() {
		return this.meetingRoomMapper.deptList();
	}
	
	// <공통 코드> 회의실 리스트 조회
	@Override
	public List<CommonCodeVO> meetingRoomList() {
		return this.meetingRoomMapper.meetingRoomList();
	}
	
	// 회의실 예약 등록
	@Override
	public int registRes(MeetingRoomVO meetingRoomVO) {
		return this.meetingRoomMapper.registRes(meetingRoomVO);
	}
	
	// 특정 날짜 (당일) 모든 회의실 예약 조회
	@Override
	public List<MeetingRoomVO> getAllReservations(String today) {
		return this.meetingRoomMapper.getAllReservations(today);
	}
	
	// 특정 사원 정보 조회
	@Override
	public EmployeeVO empSelect(String empNo) {
		return this.meetingRoomMapper.empSelect(empNo);
	}
	
	// 회의실 예약 삭제
	@Override
	public int deleteRes(String rsvtNo) {
		return this.meetingRoomMapper.deleteRes(rsvtNo);
	}

	@Override
	public int checkRes(MeetingRoomVO meetingRoomVO) {
		return this.meetingRoomMapper.checkRes(meetingRoomVO);
	}

	

}
