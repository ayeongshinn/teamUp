package kr.or.ddit.cmmn.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.service.LoginService;
import kr.or.ddit.hr.mapper.EmployeeMapper;
import kr.or.ddit.hr.vo.EmployeeVO;

@Service
public class LoginServiceImpl implements LoginService {
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	/* 비밀번호 찾기 :: 신아영
	 * 요청URI: /findPswdAjax
	 * 요청파라미터: employeeVO
	 * 요청방식: post
	 */
	@Override
	public EmployeeVO findPswdAjax(EmployeeVO employeeVO) {
		return employeeMapper.findPswdAjax(employeeVO);
	}
	
	/* 비밀번호 재설정 :: 신아영
	 * 요청URI: /updatePswdAjax
	 * 요청파라미터: employeeVO
	 * 요청방식: post
	 */
	@Override
	public int updatePswdAjax(EmployeeVO employeeVO) {
		return employeeMapper.updatePswdAjax(employeeVO);
	}

}
