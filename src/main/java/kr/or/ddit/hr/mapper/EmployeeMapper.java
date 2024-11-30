package kr.or.ddit.hr.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.hr.vo.EmployeeVO;

/** 사원(EMPLOYEE) Mapper
 * 
 * @author 정지훈
 */
@Mapper
public interface EmployeeMapper {
	
	/** 직원 로그인
	 * @param username
	 * @return EmployeeVO
	 */
	public EmployeeVO getLogin(String username);
	
	/** 사원 비밀번호 찾기 프로세스 :: 신아영
	 * @param employeeVO
	 * @return
	 */
	public EmployeeVO findPswdAjax(EmployeeVO employeeVO);
	
	/** 사원 비밀번호 재설정 프로세스 :: 신아영
	 * 
	 * @param employeeVO
	 * @return
	 */
	public int updatePswdAjax(EmployeeVO employeeVO);
	
	/** 그룹코드로 공통코드 찾기 :: 장영원
	 * 
	 * @param groupCd
	 * @return
	 */
	public List<CommonCodeVO> searchCommonCd(String groupCd);
	
	/** 사원 등록 실행 :: 장영원
	 * 
	 * @param employeeVO
	 * @return
	 */
	public int registPost(EmployeeVO employeeVO);
	
	
	//base64 test :: 장영원
	public EmployeeVO test(String empNo);
	
	//사내 전 사원 목록 :: 장영원
	public List<EmployeeVO> list(Map<String, Object> map);

	//사내 전 사원 수 :: 장영원
	public int getTotal(Map<String, Object> map);
	
	//사원 일괄 등록  실행 :: 장영원
	public int batchInsert(List<EmployeeVO> employeeList);
	
	//전 사원 수  :: 장영원
	public int empTotal();

	//금년 입사 사원 수 :: 장영원
	public int empJoin();

	//금년 퇴사 사원 수 :: 장영원
	public int empResign();
	
	//현재 재직자 수 :: 장영원
	public int empInOffice();
	
	//전년도 재직자 수 :: 장영원
	public int empLastYear();
	
	//사원 상세 정보 테스트
	public EmployeeVO detail(String empNo);
	
	//주소리스트 조회
	public List<EmployeeVO> addressList(Map<String, Object> map);
	
	//조직도 사원 조회
	public List<EmployeeVO> getEmpList();
	
	//주직도 부서별 조회
	public List<EmployeeVO> getEmployeeListByDept(String deptCd);

	public EmployeeVO getEmployeeByEmpNo(String empNo);
	
	//주소록 직원 가져오기
	public List<EmployeeVO> getAddressList(Map<String, Object> map);
	
	//주소록 직원 total
	public int getAddressTotal(Map<String, Object> map);
}

