package kr.or.ddit.cmmn.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrVacationVO;

public interface AttendanceService {

	//큐알 스캔 후 출근 update :: 신아영
	public int updateAttendAjax(AttendanceVO attendanceVO);
	
	//큐알 스캔 후 퇴근 update :: 신아영
	public int updateLvffcAjax(AttendanceVO attendanceVO);
	
	public String findEmpNoByUsername(String empNo);

	public String generateToken(String empNo) throws Exception;
	
	//사원 리스트 :: 장영원
	public List<AttendanceVO> list(Map<String, Object> map);

	//사원 수 :: 장영원
	public int getTotal(Map<String, Object> map);

    //로그인한 특정 사원의 정보 :: 장영원
	public EmployeeVO getEmployee(String empNo);
	
	//금일 미출근한 사원 정보 :: 장영원
	public int absentCnt(Map<String, Object> map);

	//근태 사원 수 조회 :: 장영원
	public int deptTotal(String deptCd);
	
	//버튼으로 출근 update
	public int updateAttendBtnAjax(AttendanceVO attendanceVO);


}
