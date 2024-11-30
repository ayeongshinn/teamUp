package kr.or.ddit.bsn.vo;

import lombok.Data;

// 거래처 주소록용 VO :: 이재현
@Data
public class CounterPartyVO {

	private String cnptNo; 			// 거래처 번호
	private String cmrcNm; 	    	// 업체명
	private String rprsvNm; 		// 대표자명
	private String cnptBrno; 		// 사업자번호
	private String rprsTelno; 		// 대표 전화번호
	private String cnptFxno; 		// FAX 번호
	private String coRoadNmZip; 	// 우편번호
	private String fndnYmd; 		// 설립 일자
	private String rmrkCn; 			// 비고 내용
	private String ctrtCnclsYmd; 	// 계약 체결일
	private String coRoadNmAddr; 	// 도로명 주소
	private String coDaddr; 		// 상세주소
	private String indutyCd; 		// 업종 코드
	private String delYn; 			// 삭제여부
//	private String atrzSttusCd;		// 결제 상태 코드
	
	private String indutynm;		// 업종명
	private String category;		// 카테고리
	private int rnum;				// 순번
}
