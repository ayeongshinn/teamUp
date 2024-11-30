package kr.or.ddit.manage.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.CarUseDocVO;
import kr.or.ddit.manage.vo.FixturesUseDocVO;

public interface FixturesUseDocService {
	
	// 자동 완성 기능을 위한 데이터 조회
	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap);

	// 비품 사용 신청서 등록
	public int fixRegist(FixturesUseDocVO fixturesUseDocVO);

	// 특정 번호에 따른 직원 정보 조회
	public EmployeeVO getEmpInfo(String empNo);

	// 차량 사용 신청서 등록
	public int carRegist(CarUseDocVO carUseDocVO);


}
