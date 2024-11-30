package kr.or.ddit.cmmn.vo;

import lombok.Data;

@Data
public class SalaryVO {
	private String empNo;		//사원 번호
	private String fnstNm;		//금융기관 명
	private String giveActno;	//지급 계좌번호
	private int empAnslry;		//사원 연봉
	private int empBslry;		//사원 기본급
	private String dsgnYmd;		//지정 일자
	
}
