package kr.or.ddit.hr.vo;

import lombok.Data;

@Data
public class VacationDocVO {
	private String htmlCd;
	private String docNo;
	private String vcatnCd;
	private String docTtl;
	private String wrtYmd;
	private String vcatnRsn;
	private int useVcatnDayCnt;
	private String schdlBgngYmd;
	private String schdlEndYmd;
	private String docCd; 		//참조_문서_카테고리_코드_A29
	private String drftEmpNo; 	//기안 사원 번호
	
	private String docCdNm; // 문서 카테고리 명
	
	private String atrzNo;//휴가 결제문서번호
	private String atrzSttusCd;//휴가결제문서승인코드
}
