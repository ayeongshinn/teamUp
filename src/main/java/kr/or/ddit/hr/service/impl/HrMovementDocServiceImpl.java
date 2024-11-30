package kr.or.ddit.hr.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.DocumentVO;
import kr.or.ddit.hr.mapper.HrMovementDocMapper;
import kr.or.ddit.hr.service.HrMovementDocService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrMovementDocVO;
import kr.or.ddit.hr.vo.ResignationDocVO;
import kr.or.ddit.hr.vo.VacationDocVO;

/** 인사이동(HR_MOVEMENT_DOC) ServiceImpl
 * 
 * @author 장영원
 */
@Service
public class HrMovementDocServiceImpl implements HrMovementDocService {
	
	@Inject
	HrMovementDocMapper hrMovementDocMapper;
	
	// 인사이동 리스트
	@Override
	public List<HrMovementDocVO> hrMovementDoclist() {
		return hrMovementDocMapper.hrMovementDoclist();
	}
	
	//부서 리스트
	@Override
	public List<CommonCodeVO> deptList() {
		return hrMovementDocMapper.deptList();
	}
	
	//부서팀에 관한 사원
	@Override
	public CommonCodeVO deptEmpList(String deptCd) {
		return hrMovementDocMapper.deptEmpList(deptCd);
	}
	
	//사원의 상세정보
	@Override
	public EmployeeVO empDetail(String empNo) {
		return hrMovementDocMapper.empDetail(empNo);
	}
	
	//직급 리스트
	@Override
	public List<CommonCodeVO> jbgdList() {
		return hrMovementDocMapper.jbgdList();
	}
	
	//인사부서 팀장
	@Override
	public EmployeeVO hrLeader() {
		return hrMovementDocMapper.hrLeader();
	}

	//대표이사
	@Override
	public EmployeeVO ceo() {
		return hrMovementDocMapper.ceo();
	}
	
	//인사이동 서류 저장
	@Override
	public int hrMovementDocRegist(HrMovementDocVO hrMovementDocVO) {
		return hrMovementDocMapper.hrMovementDocRegist(hrMovementDocVO);
	}
	
	//특정 문서 읽어오기
	@Override
	public HrMovementDocVO getHrMovementDoc(String docNo) {
		return hrMovementDocMapper.getHrMovementDoc(docNo);
	}
	
	//사원 자동완성
	// ServiceImpl에서 처리
	@Override
	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap) {
	    String empNm = (String) paramMap.get("empNm");
	    paramMap.put("empNm", empNm + "%");  // 검색어의 끝에 %를 붙여 처리
	    return hrMovementDocMapper.autocomplete(paramMap);
	}
	
	//휴가 사유
	@Override
	public List<CommonCodeVO> vacationReasonList() {
		return hrMovementDocMapper.vacationReasonList();
	}
	
	//휴가 서류 저장
	@Override
	public int vacationDocRegist(VacationDocVO vacationDocVO) {
		return hrMovementDocMapper.vacationDocRegist(vacationDocVO);
	}
	
	//사직서 저장
	@Override
	public int resignationDocRegist(ResignationDocVO resignationDocVO) {
		return hrMovementDocMapper.resignationDocRegist(resignationDocVO);
	}

	
	//참조 문서 리스트
	@Override
	public List<DocumentVO> getAllDocList() {
		return hrMovementDocMapper.getAllDocList();
	}

}
