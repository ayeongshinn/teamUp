package kr.or.ddit.manage.vo;

import lombok.Data;

@Data
public class FixturesUseDocVO {
	
	private String htmlCd;
	private String docNo;
	private String docTtl;
	private String fxtrsNm;
	private String wrtYmd;
	private int fxtrsQy;
	private String usePrps;
	private String useBgngYmd;
	private String useEndYmd;
	private String docCd; 		//참조_문서_카테고리_코드_A29
	private String drftEmpNo; 	//기안 사원 번호
	
	private String docCdNm; // 문서 카테고리 명
}
