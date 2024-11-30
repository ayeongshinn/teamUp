package kr.or.ddit.cmmn.vo;

import lombok.Data;

@Data
public class ApprovalLineCountVO {
	private int countWait;      		// A14-003의 개수
    private int countApprove;   		// A14-001의 개수
    private int countReturn;   			// A14-002의 개수
    private int countEmrgncyY;  		// EMRGNCY_STTUS가 'Y'인 개수
    private int countEmrgncyN;  		// EMRGNCY_STTUS가 'N'인 개수
    private int lastCountApprove;		// A14-001인 결재 마스터 개수
	
}
