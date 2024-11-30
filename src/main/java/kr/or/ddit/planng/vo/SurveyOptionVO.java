package kr.or.ddit.planng.vo;

import java.util.List;

import lombok.Data;

@Data
public class SurveyOptionVO {
	/**
	 * SRVY_OPTION(설문 보기) 테이블
	 */
	private String optionNo; //보기 번호
	private String srvyQstNo; //설문 질문 번호
	private String srvyNo; //설문 번호
	private String optionCn; //보기 내용
	
	//보기 : 응답 = 1 : N
	private List<SurveyAnsVO> answerList; //응답 리스트
}
