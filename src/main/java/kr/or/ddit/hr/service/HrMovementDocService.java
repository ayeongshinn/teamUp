package kr.or.ddit.hr.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.DocumentVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrMovementDocVO;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.hr.vo.ResignationDocVO;
import kr.or.ddit.hr.vo.VacationDocVO;

/** 인사이동(HR_MOVEMENT_DOC) Service
 * 
 * @author 장영원
 */
public interface HrMovementDocService {

	// 인사이동 리스트
	public List<HrMovementDocVO> hrMovementDoclist();
	
	//부서 리스트
	public List<CommonCodeVO> deptList();
	
	//부서팀에 관한 사원
	public CommonCodeVO deptEmpList(String deptCd);

	//사원의 상세정보
	public EmployeeVO empDetail(String empNo);

	//직급 리스트
	public List<CommonCodeVO> jbgdList();
	
	//인사부서 팀장
	public EmployeeVO hrLeader();
	
	//대표이사
	public EmployeeVO ceo();
	
	//인사이동 서류 저장
	public int hrMovementDocRegist(HrMovementDocVO hrMovementDocVO);
	
	//특정 문서 읽어오기
	public HrMovementDocVO getHrMovementDoc(String docNo);
	
	//사원 자동완성
	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap);
	
	//휴가 사유 리스트
	public List<CommonCodeVO> vacationReasonList();
	
	//휴가 서류 저장
	public int vacationDocRegist(VacationDocVO vacationDocVO);
	
	//사직서 저장
	public int resignationDocRegist(ResignationDocVO resignationDocVO);
	
	//참조 문서 리스트
	public List<DocumentVO> getAllDocList();
}
