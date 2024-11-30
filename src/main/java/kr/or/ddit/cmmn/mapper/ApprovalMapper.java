package kr.or.ddit.cmmn.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.cmmn.vo.ApprovalDocVO;
import kr.or.ddit.cmmn.vo.ApprovalLineCountVO;
import kr.or.ddit.cmmn.vo.ApprovalLineVO;
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

@Mapper
public interface ApprovalMapper {

	List<ApprovalDocVO> getApprovalListP(Map<String, Object> map);
	
	ApprovalDocVO getApprovalDoc(String docNo);
	
	EmployeeVO getEmpInfo(String empNo);
	
	List<ApprovalLineVO> getApprovalLine(String atrzNo);
	
	int updateApproveDoc(String atrzNo);
	
	int updateApproveLine(ApprovalLineVO approvalLineVo);

	int updateReturnDoc(String atrzNo);
	
	int updateReturnLine(ApprovalLineVO approvalLineVO);

	HrMovementDocVO getHrMovementDoc(HrMovementDocVO hrMovementDocParamVO);

	VacationDocVO getVacationDoc(VacationDocVO vacationDocParamVO);

	ResignationDocVO getResignationDoc(ResignationDocVO resignationDocParamVO);

	SalaryDocVO getSalaryDoc(SalaryDocVO salaryDocParamVO);

	SalaryDetailsDocVO getSalaryDetailsDoc(SalaryDetailsDocVO salaryDetailsDocParamVO);

	FixturesUseDocVO getFixturesUseDoc(FixturesUseDocVO fixturesUseDocParamVO);

	CarUseDocVO getCarUseDoc(CarUseDocVO carUseDocParamVO);

	List<EmployeeVO> getEmpList();

	List<EmployeeVO> getSearch(String empNm);

	List<DocumentFormVO> getFormList();

	List<CommonCodeVO> getDeptCd();

	List<CommonCodeVO> getJbgdCd();
	
	int insertApprovalDoc(ApprovalDocVO approvalDocVO);
	
	int insertApprovalLine(ApprovalLineVO approvalLineVO);
	
	int insertHrMovementDoc(HrMovementDocVO hrMovementDocVO);
	
	String getHrMovementDocMaxNum();
	
	String getApprovalDocMaxNum();

	int getApprovalCount(Map<String, Object> map);

	ApprovalLineCountVO getApprovalLineCount(String empNo);

	List<ApprovalDocVO> getApprovalRequestList(Map<String, Object> map);

	int getApprovalRequestCount(Map<String, Object> map);

	ApprovalLineCountVO getDsbApprovalRequestCount(String empNo);

	List<ApprovalDocVO> getApprovalDocList(Map<String, Object> map);

	int getApprovalDocCount(Map<String, Object> map);

	ApprovalLineCountVO getDsbApprocalDocCount(String empNo);

	int insertVacationDoc(VacationDocVO vacationDocVO);

	String getVacationDocMaxNum();

	DocumentFormVO getDocumentForm(String formNo);

	HrMovementDocVO getHrMovementDocInfo(String docNo);

	int updateEmpInfo(EmployeeVO employeeVO);

	int updateWork(String valueOf);

	String getEmpNm(String trgtEmpNo);
}
