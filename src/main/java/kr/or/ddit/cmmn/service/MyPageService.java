package kr.or.ddit.cmmn.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.hr.vo.SalaryDetailsDocVO;
import kr.or.ddit.hr.vo.VacationDocVO;

public interface MyPageService {

	int infoUpdate(EmployeeVO employeeVO);

	EmployeeVO getinfo(EmployeeVO employeeVO);

	int newPswd(Map<String, Object> map);

	String getpasswd(String empNo);

	List<AttendanceVO> attendList(Map<String, Object> map);

	String getDbattendYmd(Map<String, Object> tdAttendMap);

	AttendanceVO getTdWork(Map<String, Object> tdAttendMap);

	int setOvreWkTm(Map<String, Object> tdAttendMap);

	int setWKTime(Map<String, Object> tdAttendMap);

	String getweekNgtwrHr(String empNo);

	String getweekWorkHr(String empNo);

	HrVacationVO getMyVacation(String empNo);

	List<VacationDocVO> vacationDocVOList(Map<String, Object> map);

	List<AttendanceVO> teamAttendList(Map<String, Object> map);

	int countAttendEmp(Map<String, Object> map);

	int countNotAttendEmp(Map<String, Object> map);

	int vacationEmp(Map<String, Object> map);

	int busiTripEmp(Map<String, Object> map);

	int countTeamEmp(Map<String, Object> map);

	List<SalaryDetailsDocVO> getSalaryDocList(String empNo);

	SalaryDetailsDocVO getSalaryDoc(Map<String, Object> map);

	int getVacaDoc(Map<String, Object> map);

	int getAtteTotal(Map<String, Object> map);

	int upDateFrofl(Map<String, Object> map);

	String getPasswordByEmpNo(String empNo);

}
