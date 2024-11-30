package kr.or.ddit.planng.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.planng.vo.SurveyAnsVO;
import kr.or.ddit.planng.vo.SurveyOptionVO;
import kr.or.ddit.planng.vo.SurveyQstVO;
import kr.or.ddit.planng.vo.SurveyVO;

public interface SurveyService {
	
	//설문 목록
	public List<SurveyVO> surveyList(Map<String, Object> map);
	
	//전체 행의 수
	public int getTotal(Map<String, Object> map);
	
	//종료되지 않은 설문
	public List<SurveyVO> getActiveSurveys(Map<String, Object> map);
	
	//설문 등록
	public int registSurvey(SurveyVO surveyVO);
	
	//질문 등록
	public void insertQuestion(SurveyQstVO surveyQstVO);
	
	//보기 등록
	public void insertOption(SurveyOptionVO surveyOptionVO);
	
	//설문 종료
	public int endSurveysAjax(List<String> srvyNo);
	
	//설문 삭제 - 기획부 권한
	public int deleteSurveysAjax(List<String> srvyNo);
	
	//설문 상세
	public SurveyVO surveyDetail(String srvyNo);
	
	//설문 삭제
	public int deleteSurvey(String srvyNo);
	
	//이전 설문 조회
	public SurveyVO surveyDetailNPrev(String srvyNo);
	
	//다음 설문 조회
	public SurveyVO surveyDetailNNxt(String srvyNo);
	
	//질문과 옵션 조회
	public List<SurveyQstVO> getSurveyQstOpt(String srvyNo);

	//응답 제출
	public int submitAnswer(SurveyVO surveyVO);
	
	//설문에 참여했는지 확인
	public int getParticipated(Map<String, Object> map);
	
	//설문에 참여한 인원
	public int getParticipatedCnt(String srvyNo);
	
	//설문 결과
	public SurveyVO surveyResult(String srvyNo);
	
	//객관식 응답 가져오기
	public List<SurveyAnsVO> getMultiAns(String srvyNo);
	
	//서술형 응답 가져오기
	public List<SurveyAnsVO> getDescAns(String srvyNo);
	
	//각 질문의 전체 응답 가져오기
	public int getAllAnsCnt(Map<String, Object> map);
	
	//각 설문의 대상자 수 가져오기
	public int getAllPartici(String srvyTarget);
	
	//설문 수정 처리
	//public int updateSurvey(SurveyVO surveyVO);
	

}
