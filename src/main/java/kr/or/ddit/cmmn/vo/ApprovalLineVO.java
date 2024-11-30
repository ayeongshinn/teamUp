package kr.or.ddit.cmmn.vo;

import java.util.Date;

import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.Data;

@Data
public class ApprovalLineVO {
	private int atrzSn;
	private String atrzNo;
	private String atrzEmpNo;
	private String atrzYmd;
	private String rjctRsn;
	private String atrzSttusCd;
	private String helpDeptCd;
	private Date atrzDt;
	
	private String atrzSttusNm;
	private String helpDeptNm;
	
	private String atrzOpinion;
	
	private EmployeeVO employeeVO; // 결재 사원 정보
	
	private int rn;
	
	private String prevAtrzSttusCd;
}
