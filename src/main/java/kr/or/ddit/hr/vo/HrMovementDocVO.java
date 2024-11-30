package kr.or.ddit.hr.vo;

import lombok.Data;

@Data
/** 인사이동 서류(HR_MOVEMENT_DOC) VO
 * 최종 수정 일 : 2024-09-12
 * @author 장영원
 *
 */
public class HrMovementDocVO {
	private String docNo;		//서류 번호
	private String docTtl;		//서류 제목
	private String docCn;		//서류 내용
	private String wrtYmd;		//작성 일자
	private String trgtEmpNo;	//대상 사원 번호
	private String deptCd;		//부서_코드_A17
	private String jbgdCd;		//직급_코드_A18
	private String htmlCd;		//HTML 코드
	private String trgtEmpDay; 	//대상 사원 발령 일
	private String docCd; 		//참조_문서_카테고리_코드_A29
	private String drftEmpNo; 	//기안 사원 번호
	
	private String docCdNm; // 문서 카테고리 명
}