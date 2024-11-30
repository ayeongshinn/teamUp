package kr.or.ddit.planng.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class SurveyAnsVO {
	/**
	 * SRVY_ANS(설문 응답) 테이블
	 */
	private String ansNo; //설문 응답 번호
	private String srvyQstNo; //설문 질문 번호
	private String srvyNo; //설문 번호
	private String ansEmpNo; //응답자 번호
	private Date ansDate; //응답 날짜
	private String descAns; //서술형 응답
	private String multiAns; //객관식 응답(옵션 테이블 기본키)
	
	private List<String> multiAnsList; //객관식 응답 리스트
	private List<String> optionList; //보기 리스트
	
	private int answerCnt; //객관식 응답 개수
	private String optionCn; //보기 내용
	private String empNm; //사원 이름
	private String jbgdCd; //직급
	private String deptCd; //부서
}
