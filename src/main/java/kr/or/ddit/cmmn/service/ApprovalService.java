package kr.or.ddit.cmmn.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.ApprovalDocVO;
import kr.or.ddit.cmmn.vo.ApprovalLineCountVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.DocumentFormVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrMovementDocVO;
import kr.or.ddit.hr.vo.ResignationDocVO;
import kr.or.ddit.hr.vo.SalaryDetailsDocVO;
import kr.or.ddit.hr.vo.SalaryDocVO;
import kr.or.ddit.hr.vo.VacationDocVO;
import kr.or.ddit.manage.vo.CarUseDocVO;
import kr.or.ddit.manage.vo.FixturesUseDocVO;

public interface ApprovalService {

	List<ApprovalDocVO> getApprovalListP(Map<String, Object> map);

	ApprovalDocVO getApprovalTotal(String docNo);

	int approveAjax(Map<String, Object> approval);

	int returnAjax(Map<String, Object> approval);

	EmployeeVO getDrafterEmpNo(String drftEmpNo);

	HrMovementDocVO getHrMovementDoc(HrMovementDocVO hrMovementDocParamVO);

	VacationDocVO getVacationDoc(VacationDocVO vacationDocParamVO);

	ResignationDocVO getResignationDoc(ResignationDocVO resignationDocParamVO);

	SalaryDocVO getSalaryDoc(SalaryDocVO salaryDocParamVO);

	SalaryDetailsDocVO getSalaryDetailsDoc(SalaryDetailsDocVO salaryDetailsDocParamVO);

	FixturesUseDocVO getFixturesUseDoc(FixturesUseDocVO fixturesUseDocParamVO);

	CarUseDocVO getCarUseDoc(CarUseDocVO carUseDocParamVO);

	List<EmployeeVO> getEmpList();

	List<EmployeeVO> getSearch(String empNm);

	List<EmployeeVO> getApproveLines(Map<String, Object> map);

	List<DocumentFormVO> getFormList();

	List<CommonCodeVO> getDeptCd();

	List<CommonCodeVO> getJbgdCd();
	
	int insertApproval(Map<String, Object> map);

	String hrMovementDocNo();

	int getApprovalCount(Map<String, Object> map);

	ApprovalLineCountVO getApprovalLineCount(String empNo);

	List<ApprovalDocVO> getApprovalRequestList(Map<String, Object> map);

	int getApprovalRequestCount(Map<String, Object> map);

	ApprovalLineCountVO getDsbApprovalRequestCount(String empNo);

	List<ApprovalDocVO> getApprovalDocList(Map<String, Object> map);

	int getApprovalDocCount(Map<String, Object> map);

	ApprovalLineCountVO getDsbApprocalDocCount(String empNo);

	String vacationDocNo();

	DocumentFormVO getDocumentForm(String formNo);

	int updateEmpInfo(Map<String, Object> map);

	String getEmpNm(Map<String, Object> map);

	String getAlramEmpNm(String empNo);
}
