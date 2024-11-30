package kr.or.ddit.manage.vo;

import lombok.Data;

@Data
public class CarUseLedgerVO {
	
	private int rnum;
	private String empNo;  	  // 사원 번호
	private String mngNo;  	  // 관리 번호
	private String useYmd; 	  // 사용 일자
	private String rtnYmd; 	  // 반납 일자
	private String usePrps;	  // 사용 목적
	private String rmrkCn; 	  // 비고
	private String vhclId; 	  // 차량 아이디
	private String destLoc;   // 도착지
	private String driveDist; // 운행 거리
	private String driveCost; // 지출 비용
	private String srcLoc;    // 출발지
	private String empNm;
	private String vhclNo;
	private String deptCd;

}
