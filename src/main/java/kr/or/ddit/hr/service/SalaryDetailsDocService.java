package kr.or.ddit.hr.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.SalaryVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.SalaryDetailsDocVO;

public interface SalaryDetailsDocService {

	//급여명세서 등록
	public int batchRegistPost(List<SalaryDetailsDocVO> salaryDetailsDocList);
	
	//특정 사원의 기본급 조회
	public SalaryVO getTrgtEmpNo(String empNo);
	
	//급여명세서 목록
	public List<SalaryDetailsDocVO> getSalaryDetailsDocList(Map<String, Object> map);
	
	//급여명세서 수
	public int getTotal(Map<String, Object> map);
	
	//특정 사원의 급여 명세서
	public SalaryDetailsDocVO getDetailDoc(Map<String, Object> map);
	
}
