package kr.or.ddit.cmmn.service;

import kr.or.ddit.hr.vo.EmployeeVO;

public interface LoginService {

	//비밀번호 찾기 :: 신아영
	public EmployeeVO findPswdAjax(EmployeeVO employeeVO);

	//비밀번호 재설정 :: 신아영
	public int updatePswdAjax(EmployeeVO employeeVO);
	
}
