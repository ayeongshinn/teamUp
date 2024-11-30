package kr.or.ddit.cmmn.vo;

import java.util.Date;
import java.util.List;

import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.Data;

@Data
public class ApprovalDocVO {
	private String atrzNo;
	private String docNo;
	private String atrzSttusCd;
	private String taskPrcsSttus;
	private String atrzTtl;
	private String drftYmd;
	private String drftEmpNo;
	private int fileGroupNo;
	private String htmlCd;
	private Date drftDt;
	private String docCdNm;
	private String docCd;
	private String emrgncySttus;
	
	
	private String atrzSttusNm;
	private String docAtrzSttusNm;
	private String docAtrzSttusCd;
	
	private List<ApprovalLineVO> approvalLineVOList;
	
	private EmployeeVO employeeVO; // 기안 사원 정보
	
	private int rn;
	
	private Date lastAtrzDt;
}
