package kr.or.ddit.planng.vo;

import java.util.List;

import lombok.Data;

@Data
public class SurveyQstVO {
	/**
	 * SRVY_QST(설문 질문) 테이블
	 */
	private String srvyQstNo; //설문 질문 번호
	private String srvyNo; //설문 번호
	private String quesCn; //질문 내용
	private String quesCd; //질문 유형 코드
	private String quesExp; //질문 설명
	
	//질문 : 보기 = 1 : N
	private List<SurveyOptionVO> optionList; //보기 리스트
	
	//질문 : 응답 = 1 : N
	private List<SurveyAnsVO> surveyAnsVOList; //응답 리스트
	
	//하나의 질문에 대한 하나의 답변
	private String multiAns;
	private String descAns;
}
