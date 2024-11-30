package kr.or.ddit.hr.vo;

import lombok.Data;

@Data
public class SalaryDetailsDocVO {
	private String docNo;		//서류 번호
	private String docTtl;		//서류 제목
	private String docCn;		//서류 내용
	private String trgtEmpNo;	//대상 사원 번호
	private int bonus;			//상여금
	private int bnsRt;			//상여 비율
	private int trnsportCt;		//교통 비용
	private int mealCt;			//식사 비용
	private int totGiveAmt;		//총 지급 금액
	private int npn;			//국민연금
	private int hlthinsIrncf;	//건강보험
	private int emplyminsrncIrncf;	//고용보험
	private int iaciIrncf;		//산재보험
	private int ecmt;			//근로소득세
	private int llx;			//지방세
	private int totDdcAmt;		//총 공제 금액
	private int realRecptAmt;	//실제 수령 금액
	private String htmlCd;		//HTML 코드
	private String docCd; 		//참조_서류_카테고리_코드_A29
	private String drftEmpNo; 	//기안 사원 번호
	private int otmPay;			//연장 근로 수당
	private int holPay;			//휴일 근로 수당
	private int nitPay;			//야간 근로 수당
	private int famAlwnc;		//가족 수당
	private String trgtEmpNm;	//대상 사원 명
	private String docCdNm; 	// 서류 카테고리 명
	private String deptNm; 		// 서류 카테고리 명
	private String jbgdNm; 		// 서류 카테고리 명
    private String trgtDt; 		// 급여 대상일자
    private String trgtYear; 	// 급여 대상일자
    private String trgtMonth; 	// 급여 대상일자
    private String empNm; 		// 급여 대상이름
    private String fnstNm; 		// 금융기관 명
    private String giveActno; 	// 지급 계좌번호
    private String empAnslry; 	// 사원 연봉
    private String empBslry; 	// 사원 기본급
    private String jbgdCd; 		// 대상사원 직급
    private String deptCd; 		// 대상사원 부서
	private String empTelno;	//사원 전화번호
	private String empEmlAddr;	//사원 이메일 주소
	private String jbttlCd;		//직책_코드_A19
	private String sexdstnCd;	//성별_코드_A21
	private String jbttlNm;		//직책 명
	private String sexdstnNm;	//성별
	private String dsgnYmd;		//지정 일자
	
}
