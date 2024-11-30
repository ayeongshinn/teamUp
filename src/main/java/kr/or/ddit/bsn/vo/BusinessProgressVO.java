package kr.or.ddit.bsn.vo;

import lombok.Data;

@Data
public class BusinessProgressVO {

	private String bsnNm;			// 거래처명
	private String manageNo;		// 관리 번호
	private String bsnTtl;			// 영업 제목
	private String bsnCn;			// 영업 내용
	private String tkcgEmpNo;		// 담당 사원 번호
	private String rbprsnEmpNo;		// 책임 사원 번호
	private String bsnBgngYmd;		// 영업 시작일
	private String bsnEndYmd;		// 영업 종료일
	private int bsnProgrs;			// 영업 진행도
	private String regDt;			// 등록 일자
	private String delYn;			// 삭제 여부
	private String cnptNo;			// 거래처 번호
	private String custNo;			// 고객 번호
	private int fileGroupNo;		// 파일 그룹 번호
	
	private String tkcgEmpNm;		// 담당 사원 이름
	private String tkcgEmpJbttlNm;	// 담당자 직급명
	private String rbprsnEmpNm;		// 책임 사원 이름
	private String rbprsnEmpJbttlNm;	// 책임자 직급명
	
}
