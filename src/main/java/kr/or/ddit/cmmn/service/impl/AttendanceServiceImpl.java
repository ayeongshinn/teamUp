package kr.or.ddit.cmmn.service.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.mapper.AttendanceMapper;
import kr.or.ddit.cmmn.service.AttendanceService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.security.JwtUtilNimbus;

@Service
public class AttendanceServiceImpl implements AttendanceService {
	
	@Autowired
	AttendanceMapper attendanceMapper;
	
	//큐알 스캔 후 출근 update :: 신아영
	@Override
	public int updateAttendAjax(AttendanceVO attendanceVO) {
		return attendanceMapper.updateAttendAjax(attendanceVO);
	}
	
	@Override
	public String findEmpNoByUsername(String empNo) {
	    return attendanceMapper.selectEmpNoByUsername(empNo);
	}
	
	public String generateToken(String empNo) throws Exception {
	    return JwtUtilNimbus.createToken(empNo);
	}

	//큐알 스캔 후 퇴근 update :: 신아영
	@Override
	public int updateLvffcAjax(AttendanceVO attendanceVO) {
		return attendanceMapper.updateLvffcAjax(attendanceVO);
	}

	//사원 리스트 :: 장영원
	@Override
	public List<AttendanceVO> list(Map<String, Object> map) {
		return attendanceMapper.list(map);
	}

	//사원 수 :: 장영원
	@Override
	public int getTotal(Map<String, Object> map) {
		return attendanceMapper.getTotal(map);
	}
    
    //로그인한 특정 사원의 정보 :: 장영원
	@Override
	public EmployeeVO getEmployee(String empNo) {
		return attendanceMapper.getEmployee(empNo);
	}
	
	//금일 미출근한 사원 정보 :: 장영원
	@Override
	public int absentCnt(Map<String, Object> map) {
		return attendanceMapper.absentCnt(map);
	}
	
	//근태 사원 수 조회 :: 장영원
	@Override
	public int deptTotal(String deptCd) {
		return attendanceMapper.deptTotal(deptCd);
	}
	
	//버튼으로 출근 update
	@Override
	public int updateAttendBtnAjax(AttendanceVO attendanceVO) {
		return attendanceMapper.updateAttendBtnAjax(attendanceVO);
	}


}
