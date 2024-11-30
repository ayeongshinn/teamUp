package kr.or.ddit.hr.vo;

import lombok.Data;

@Data
/** 휴가(VACATION) VO
 * 최종 수정 일 : 2024-09-12
 * @author 장영원
 */
public class HrVacationVO {
	private String vcatnNo;			//휴가 번호
	private String empNo;			//사원 번호
	private int bscVcatnDayCnt;		//기본 휴가 일 수
	private int grntVcatnDayCnt;	//부여 휴가 일 수
	private int useVcatnDayCnt;		//사용 휴가 일 수
	private int holdVcatnDayCnt;	//보유 휴가 일 수
	private String fyrBgngYmd;		//회계연도 시작 일자
	private String fyrEndYmd;		//회계연도 종료 일자
	private String vcatnCd;			//휴가_카테고리_코드_A22
	private String useVcatnDay;		//휴가 사용일(휴가 시작일)
	
	private String empNm;			//사원 명
	private String deptCd;			//부서 코드 (공통코드)
	private String deptNm;			//부서 명 (공통코드)
	
	private String jbgdCd;			//직급_코드_A18
	private String jbgdNm;			//직급 명
	
	private String proflPhoto;		//프로필 사진
	
	private  int daysLeft; 			//휴가 만료일까지 남은날
	
}
