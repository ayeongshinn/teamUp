package kr.or.ddit.planng.vo;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import lombok.Data;

@Data
public class SurveyVO {
	/**
	 *	SRVY(설문) 테이블
	 */
	private String srvyNo; //설문 번호
	private String srvyTtl; //설문 제목
	private String srvyCn; //설문 내용
	private String srvyEmpNo; //작성자
	private Date srvyRegDate; //설문 등록 일시
	private String srvyBgngDate; //설문 시작 일자
	private String srvyBgngTm; //설문 시작 시간
	private String srvyEndDate; //설문 종료 일자
	private String srvyEndTm; //설문 종료 시간
	private String resOpenYn; //결과 공개 여부
	private String annmsYn; //익명 여부
	private String delYn; //삭제 여부
	private String endYn; //종료 여부
	private String srvyTarget; //설문 대상
	
	//설문 게시글 : 질문 = 1 : N
	//SurveyVO : SurveyQstVO = 1 : N
	private List<SurveyQstVO> srvyQstVOList;
	
	private List<String> questionList; //질문 리스트
	private List<String> quesExpList; //질문 설명 리스트
	private List<String> quesCdList; //질문 코드 리스트(객관식/서술형)
	
	private long remainDays; //남은 날짜
	private long remainHours; //남은 시간
	private String remainingTime; //총 남은 시간
	private String empNo; //사원 번호
	private String empNm; //사원 이름
	private String deptCd; //사원 부서 코드
	private String jbgdCd; //사원 직급 코드
	
	private boolean participated; //설문에 참여한 사원
	private int participatedCnt; //설문에 참여한 사원 인원
	
}
