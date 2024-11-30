package kr.or.ddit.bsn.vo;

import lombok.Data;

@Data
public class CustomerVO {
	
	private String custNo;				// 고객 번호
	private String custNm;				// 고객 명
	private String custRrno;			// 고객 주민등록번호
	private String custCrNm;			// 고객 직업명
	private String custTelno;			// 고객 전화번호
	private String custEmlAddr;			// 고객 이메일
	private String ctrtCnclsYmd;		// 계약 체결 일자
	private String custRoadNmZip;		// 고객 우편번호
	private String rmrkCn;				// 비고 내용
	private String custRoadNmAddr;		// 고객 도로명 주소
	private String custDaddr;			// 고객 상세 주소
	private String delYn;				// 삭제 여부
//	private String atrzSttusCd;			// 결제 상태 코드
	
	private int rnum;					// 순번
	
}
