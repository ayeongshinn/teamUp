package kr.or.ddit.cmmn.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.cmmn.mapper.ApprovalMapper;
import kr.or.ddit.cmmn.service.ApprovalService;
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
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Transactional
@Service
public class ApprovalServiceImpl implements ApprovalService{

	@Autowired
	ApprovalMapper approvalMapper;

	@Override
	public List<ApprovalDocVO> getApprovalListP(Map<String, Object> map) {
		return this.approvalMapper.getApprovalListP(map);
	}

	@Override
	public ApprovalDocVO getApprovalTotal(String docNo) {
		
		ApprovalDocVO approvalDocVO = this.approvalMapper.getApprovalDoc(docNo);
		
		EmployeeVO employeeVO = this.approvalMapper.getEmpInfo(approvalDocVO.getDrftEmpNo());
		approvalDocVO.setEmployeeVO(employeeVO);
		
		List<ApprovalLineVO> approvalLineVOList = this.approvalMapper.getApprovalLine(approvalDocVO.getAtrzNo());
		
		for(ApprovalLineVO lineEmpNo : approvalLineVOList) {
			employeeVO = this.approvalMapper.getEmpInfo(lineEmpNo.getAtrzEmpNo());
			lineEmpNo.setEmployeeVO(employeeVO);
		}
		
		approvalDocVO.setApprovalLineVOList(approvalLineVOList);
		
	    return approvalDocVO;
	}

	@Override
	public int approveAjax(Map<String, Object> approval) {
		
		int res = 0;
		
		ApprovalLineVO approvalLineVO = new ApprovalLineVO();
		approvalLineVO.setAtrzNo(String.valueOf(approval.get("atrzNo")));
		approvalLineVO.setAtrzEmpNo(String.valueOf(approval.get("atrzEmpNo")));
		approvalLineVO.setAtrzOpinion(String.valueOf(approval.get("atrzOpinion")));
		
		res = this.approvalMapper.updateApproveLine(approvalLineVO);
		
		boolean isLastApprover = (boolean) approval.get("isLastApprover");
		
		if(isLastApprover) {
			res = this.approvalMapper.updateApproveDoc(String.valueOf(approval.get("atrzNo")));
		}
		
		return res;
	}

	@Override
	public int returnAjax(Map<String, Object> approval) {
		
		int res = 0;
		
		ApprovalLineVO approvalLineVO = new ApprovalLineVO();
		approvalLineVO.setAtrzNo(String.valueOf(approval.get("atrzNo")));
		approvalLineVO.setAtrzEmpNo(String.valueOf(approval.get("atrzEmpNo")));
		approvalLineVO.setRjctRsn(String.valueOf(approval.get("rjctRsn")));
		
		res = this.approvalMapper.updateReturnLine(approvalLineVO);
		
		res = this.approvalMapper.updateReturnDoc(String.valueOf(approval.get("atrzNo")));
		
		return res;
	}

	@Override
	public EmployeeVO getDrafterEmpNo(String drftEmpNo) {
		return this.approvalMapper.getEmpInfo(drftEmpNo);
	}

	@Override
	public HrMovementDocVO getHrMovementDoc(HrMovementDocVO hrMovementDocParamVO) {
		return this.approvalMapper.getHrMovementDoc(hrMovementDocParamVO);
	}

	@Override
	public VacationDocVO getVacationDoc(VacationDocVO vacationDocParamVO) {
		return this.approvalMapper.getVacationDoc(vacationDocParamVO);
	}

	@Override
	public ResignationDocVO getResignationDoc(ResignationDocVO resignationDocParamVO) {
		return this.approvalMapper.getResignationDoc(resignationDocParamVO);
	}

	@Override
	public SalaryDocVO getSalaryDoc(SalaryDocVO salaryDocParamVO) {
		return this.approvalMapper.getSalaryDoc(salaryDocParamVO);
	}

	@Override
	public SalaryDetailsDocVO getSalaryDetailsDoc(SalaryDetailsDocVO salaryDetailsDocParamVO) {
		return this.approvalMapper.getSalaryDetailsDoc(salaryDetailsDocParamVO);
	}

	@Override
	public FixturesUseDocVO getFixturesUseDoc(FixturesUseDocVO fixturesUseDocParamVO) {
		return this.approvalMapper.getFixturesUseDoc(fixturesUseDocParamVO);
	}

	@Override
	public CarUseDocVO getCarUseDoc(CarUseDocVO carUseDocParamVO) {
		return this.approvalMapper.getCarUseDoc(carUseDocParamVO);
	}

	@Override
	public List<EmployeeVO> getEmpList() {
		return this.approvalMapper.getEmpList();
	}

	@Override
	public List<EmployeeVO> getSearch(String empNm) {
		return this.approvalMapper.getSearch(empNm);
	}

	@Override
	public List<EmployeeVO> getApproveLines(Map<String, Object> map) {
		
		String empNo = "";
		List<EmployeeVO> employeeVOList = new ArrayList<EmployeeVO>();
		EmployeeVO employeeVO = new EmployeeVO();
		
		for(int i = 0; i < map.size(); i++){
			empNo = String.valueOf((map.get("empNo" + String.valueOf(i+1))));
			employeeVO = this.approvalMapper.getEmpInfo(empNo);
			employeeVOList.add(employeeVO);
		}
		
		return employeeVOList;
	}

	@Override
	public List<DocumentFormVO> getFormList() {
		return this.approvalMapper.getFormList();
	}

	@Override
	public List<CommonCodeVO> getDeptCd() {
		return this.approvalMapper.getDeptCd();
	}

	@Override
	public List<CommonCodeVO> getJbgdCd() {
		return this.approvalMapper.getJbgdCd();
	}
	
	@Override
	public int insertApproval(Map<String, Object> map) {
		
		int res = 0;
		
		String docNo = "";
		
		if(map.get("docCd").equals("A29-001")) {
			HrMovementDocVO hrMovementDocVO = new HrMovementDocVO();
			hrMovementDocVO.setDocTtl(String.valueOf(map.get("docTtl")));
			hrMovementDocVO.setDocCn(String.valueOf(map.get("docCn")));
			hrMovementDocVO.setWrtYmd(String.valueOf(map.get("wrtYmd")));
			hrMovementDocVO.setTrgtEmpNo(String.valueOf(map.get("trgtEmpNo")));
			hrMovementDocVO.setDeptCd(String.valueOf(map.get("deptCd")));
			hrMovementDocVO.setJbgdCd(String.valueOf(map.get("jbgdCd")));
			hrMovementDocVO.setTrgtEmpDay(String.valueOf(map.get("trgtEmpDay")).replaceAll("-", ""));
			hrMovementDocVO.setHtmlCd(String.valueOf(map.get("htmlCd")));
			hrMovementDocVO.setDocCd(String.valueOf(map.get("docCd")));
			hrMovementDocVO.setDrftEmpNo(String.valueOf(map.get("drftEmpNo")));
			
			res += this.approvalMapper.insertHrMovementDoc(hrMovementDocVO);
			if(res == 1) docNo = this.approvalMapper.getHrMovementDocMaxNum();
			
		} else if(map.get("docCd").equals("A29-002")) {
			VacationDocVO vacationDocVO = new VacationDocVO();
			vacationDocVO.setVcatnCd(String.valueOf(map.get("vcatnCd")));
			vacationDocVO.setDocTtl(String.valueOf(map.get(("docTtl"))));
			vacationDocVO.setWrtYmd(String.valueOf(map.get("wrtYmd")));
			vacationDocVO.setVcatnRsn(String.valueOf(map.get("vcatnRsn")));
			vacationDocVO.setUseVcatnDayCnt(Integer.parseInt(String.valueOf(map.get("useVcatnDayCnt"))));
			vacationDocVO.setSchdlBgngYmd(String.valueOf(map.get("schdlBgngYmd")).replaceAll("-", ""));
			vacationDocVO.setSchdlEndYmd(String.valueOf(map.get("schdlEndYmd")).replace("-", ""));
			vacationDocVO.setDocCd(String.valueOf(map.get("docCd")));
			vacationDocVO.setDrftEmpNo(String.valueOf(map.get("drftEmpNo")));
			vacationDocVO.setHtmlCd(String.valueOf(map.get("htmlCd")));
			
			res += this.approvalMapper.insertVacationDoc(vacationDocVO);
			if(res == 1) docNo = this.approvalMapper.getVacationDocMaxNum();
		}
		
		if(res == 1) {
			Map<String, Object> approval = (Map<String, Object>) map.get("approval");
			
			ApprovalDocVO approvalDocVO = new ApprovalDocVO();
			approvalDocVO.setDocNo(docNo);
			approvalDocVO.setAtrzTtl(String.valueOf(approval.get("atrzTtl")));
			approvalDocVO.setDrftEmpNo(String.valueOf(map.get("drftEmpNo")));
			approvalDocVO.setHtmlCd(String.valueOf(map.get("htmlCd")));
			approvalDocVO.setDocCdNm(String.valueOf(approval.get("docCdNm")));
			approvalDocVO.setEmrgncySttus(String.valueOf(approval.get("emrgncySttus")));
			approvalDocVO.setDocCd(String.valueOf(map.get("docCd")));
			
			res += this.approvalMapper.insertApprovalDoc(approvalDocVO);
			
			if(res == 2) {
				String approvalDocNo = this.approvalMapper.getApprovalDocMaxNum();
				
				ApprovalLineVO approvalLineVO = new ApprovalLineVO();
				approvalLineVO.setAtrzNo(approvalDocNo);
				
				Map<String, Object> atrzEmpNos = (Map<String, Object>) approval.get("atrzEmpNos");
				
				for(int i=0; i < atrzEmpNos.size(); i++) {
					approvalLineVO.setAtrzEmpNo(String.valueOf(atrzEmpNos.get("atrzEmpNo" + (i+1))));
					res += this.approvalMapper.insertApprovalLine(approvalLineVO);
				}
			}
		}
		
		return res;
	}

	@Override
	public String hrMovementDocNo() {
		return this.approvalMapper.getHrMovementDocMaxNum();
	}

	@Override
	public int getApprovalCount(Map<String, Object> map) {
		return this.approvalMapper.getApprovalCount(map);
	}

	@Override
	public ApprovalLineCountVO getApprovalLineCount(String empNo) {
		return this.approvalMapper.getApprovalLineCount(empNo);
	}

	@Override
	public List<ApprovalDocVO> getApprovalRequestList(Map<String, Object> map) {
		return this.approvalMapper.getApprovalRequestList(map);
	}

	@Override
	public int getApprovalRequestCount(Map<String, Object> map) {
		return this.approvalMapper.getApprovalRequestCount(map);
	}

	@Override
	public ApprovalLineCountVO getDsbApprovalRequestCount(String empNo) {
		return this.approvalMapper.getDsbApprovalRequestCount(empNo);
	}

	@Override
	public List<ApprovalDocVO> getApprovalDocList(Map<String, Object> map) {
		return this.approvalMapper.getApprovalDocList(map);
	}

	@Override
	public int getApprovalDocCount(Map<String, Object> map) {
		return this.approvalMapper.getApprovalDocCount(map);
	}

	@Override
	public ApprovalLineCountVO getDsbApprocalDocCount(String empNo) {
		return this.approvalMapper.getDsbApprocalDocCount(empNo);
	}

	@Override
	public String vacationDocNo() {
		return this.approvalMapper.getVacationDocMaxNum();
	}

	@Override
	public DocumentFormVO getDocumentForm(String formNo) {
		return this.approvalMapper.getDocumentForm(formNo);
	}

	@Override
	public int updateEmpInfo(Map<String, Object> map) {
		
		int res = 0;
		
		
		
		if(map.get("docCd").equals("A29-001")) {
			HrMovementDocVO hrMovementDocVO = this.approvalMapper.getHrMovementDocInfo(String.valueOf(map.get("docNo")));
			
			EmployeeVO employeeVO = new EmployeeVO();
			employeeVO.setEmpNo(hrMovementDocVO.getTrgtEmpNo());
			employeeVO.setDeptCd(hrMovementDocVO.getDeptCd());
			employeeVO.setJbgdCd(hrMovementDocVO.getJbgdCd());
			
			res += this.approvalMapper.updateEmpInfo(employeeVO);
		}
		
		if(res > 0) {
			res += this.approvalMapper.updateWork(String.valueOf(map.get("docNo")));
		}
		
		return res;
	}

	@Override
	public String getEmpNm(Map<String, Object> map) {
		String empNm = "";
		
		if(map.get("docCd").equals("A29-001")) {
			HrMovementDocVO hrMovementDocVO = this.approvalMapper.getHrMovementDocInfo(String.valueOf(map.get("docNo")));
			
			String trgtEmpNo = hrMovementDocVO.getTrgtEmpNo();
			empNm = this.approvalMapper.getEmpNm(trgtEmpNo);
			
		}
		
		return empNm;
	}

	@Override
	public String getAlramEmpNm(String empNo) {
		return this.approvalMapper.getEmpNm(empNo);
	}
}
