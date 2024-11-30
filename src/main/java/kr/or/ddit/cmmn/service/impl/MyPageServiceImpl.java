package kr.or.ddit.cmmn.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.mapper.MyPageMapper;
import kr.or.ddit.cmmn.service.MyPageService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.hr.vo.SalaryDetailsDocVO;
import kr.or.ddit.hr.vo.VacationDocVO;

@Service
public class MyPageServiceImpl implements MyPageService {

	@Autowired
	MyPageMapper myPageMapper;

	@Override
	public int infoUpdate(EmployeeVO employeeVO) {
		// TODO Auto-generated method stub
		return this.myPageMapper.infoUpdate(employeeVO);
	}

	@Override
	public EmployeeVO getinfo(EmployeeVO employeeVO) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getinfo(employeeVO);
	}

	@Override
	public int newPswd(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.newPswd(map);
	}

	@Override
	public String getpasswd(String empNo) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getpasswd(empNo);
	}

	@Override
	public List<AttendanceVO> attendList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.attendList(map);
	}

	@Override
	public String getDbattendYmd(Map<String, Object> tdAttendMap) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getDbattendYmd(tdAttendMap);
	}

	@Override
	public AttendanceVO getTdWork(Map<String, Object> tdAttendMap) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getTdWork(tdAttendMap);
	}

	@Override
	public int setOvreWkTm(Map<String, Object> tdAttendMap) {
		// TODO Auto-generated method stub
		return this.myPageMapper.setOvreWkTm(tdAttendMap);
	}

	@Override
	public int setWKTime(Map<String, Object> tdAttendMap) {
		// TODO Auto-generated method stub
		return this.myPageMapper.setWKTime(tdAttendMap);
	}

	@Override
	public String getweekNgtwrHr(String empNo) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getweekNgtwrHr(empNo);
	}

	@Override
	public String getweekWorkHr(String empNo) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getweekWorkHr(empNo);
	}

	@Override
	public HrVacationVO getMyVacation(String empNo) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getMyVacation(empNo);
	}

	@Override
	public List<VacationDocVO> vacationDocVOList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.vacationDocVOList(map);
	}

	@Override
	public List<AttendanceVO> teamAttendList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.teamAttendList(map);
	}

	@Override
	public int countAttendEmp(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.countAttendEmp(map);
	}

	@Override
	public int countNotAttendEmp(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.countNotAttendEmp(map);
	}

	@Override
	public int vacationEmp(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.vacationEmp(map);
	}

	@Override
	public int busiTripEmp(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.busiTripEmp(map);
	}

	@Override
	public int countTeamEmp(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.countTeamEmp(map);
	}

	@Override
	public List<SalaryDetailsDocVO> getSalaryDocList(String empNo) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getSalaryDocList(empNo);
	}

	@Override
	public SalaryDetailsDocVO getSalaryDoc(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getSalaryDoc(map);
	}

	@Override
	public int getVacaDoc(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getVacaDoc(map);
	}

	@Override
	public int getAtteTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.getAtteTotal(map);
	}

	@Override
	public int upDateFrofl(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.myPageMapper.upDateFrofl(map);
	}

	@Override
	public String getPasswordByEmpNo(String empNo) {
		return this.myPageMapper.getPasswordByEmpNo(empNo);
	}
	
	
	
}
