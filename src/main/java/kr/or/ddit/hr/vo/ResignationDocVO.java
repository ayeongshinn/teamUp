package kr.or.ddit.hr.vo;

import lombok.Data;

@Data
public class ResignationDocVO {
	private String htmlCd;
	private String docNo;
	private String docTtl;
	private String rsgntnRsn;
	private String rsgntnYmd;
	private String wrtYmd;
	private String docCd; 		//참조_문서_카테고리_코드_A29
	private String drftEmpNo; 	//기안 사원 번호
	
	private String docCdNm; // 문서 카테고리 명
}
