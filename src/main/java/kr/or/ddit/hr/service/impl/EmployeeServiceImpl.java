package kr.or.ddit.hr.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.hr.mapper.EmployeeMapper;
import kr.or.ddit.hr.service.EmployeeService;
import kr.or.ddit.hr.vo.EmployeeVO;

@Service
public class EmployeeServiceImpl implements EmployeeService {
	
	@Inject
	EmployeeMapper employeeMapper;
	
	//공통 코드 찾기 :: 장영원
	@Override
	public List<CommonCodeVO> searchCommonCd(String groupCd) {
		return employeeMapper.searchCommonCd(groupCd);
	}

	//사원 등록 실행 :: 장영원
	@Override
	public int registPost(EmployeeVO employeeVO) {
		return employeeMapper.registPost(employeeVO);
	}

	//base64 test :: 장영원
	@Override
	public EmployeeVO test(String empNo) {
		return employeeMapper.test(empNo);
	}

	//사내 전 사원 목록 :: 장영원
	@Override
	public List<EmployeeVO> list(Map<String, Object> map) {
		return employeeMapper.list(map);
	}

	//사내 전 사원 수 :: 장영원
	@Override
	public int getTotal(Map<String, Object> map) {
		return employeeMapper.getTotal(map);
	}
	
	//사원 일괄 등록  실행 :: 장영원
	@Override
	public int batchRegistPost(List<EmployeeVO> employeeList) {
		return employeeMapper.batchInsert(employeeList);  // 일괄 처리
	}

	//전 사원 수  :: 장영원
	@Override
	public int empTotal() {
		return employeeMapper.empTotal();
	}

	//금년 입사 사원 수 :: 장영원
	@Override
	public int empJoin() {
		return employeeMapper.empJoin();
	}

	//금년 퇴사 사원 수 :: 장영원
	@Override
	public int empResign() {
		return employeeMapper.empResign();
	}
	
	//현재 재직자 수 :: 장영원
	@Override
	public int empInOffice() {
		return employeeMapper.empInOffice();
	}
	
	//전년도 재직자 수 :: 장영원
	@Override
	public int empLastYear() {
		return employeeMapper.empLastYear();
	}
	
	//사원 상세 정보 테스트
	@Override
	public EmployeeVO detail(String empNo) {
		return employeeMapper.detail(empNo);
	}

	//주소리스트 조회
	@Override
	public List<EmployeeVO> addressList(Map<String, Object> map) {
		return employeeMapper.addressList(map);
	}
	
	//조직도 사원 조회
	@Override
	public List<EmployeeVO> getEmpList() {
		return employeeMapper.getEmpList();
	}

	//주직도 부서별 조회
	@Override
	public List<EmployeeVO> getEmployeeListByDept(String deptCd) {
		return employeeMapper.getEmployeeListByDept(deptCd);
	}
	
	@Override
	public EmployeeVO getEmployeeByEmpNo(String empNo) {
		return employeeMapper.getEmployeeByEmpNo(empNo);
	}

	@Override
	public List<EmployeeVO> getAddressList(Map<String, Object> map) {
		return employeeMapper.getAddressList(map);
	}

	@Override
	public int getAddressTotal(Map<String, Object> map) {
		return employeeMapper.getAddressTotal(map);
	}
	
}
