package kr.or.ddit.planng.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.planng.vo.SurveyOptionVO;
import kr.or.ddit.planng.vo.SurveyQstVO;
import kr.or.ddit.planng.vo.SurveyVO;

@Mapper
public interface SurveyOptionMapper {

	//설문 목록
	public List<SurveyVO> surveyList(Map<String, Object> map);
	
	//설문 전체 행의 수
	public int getTotal(Map<String, Object> map);
	
	//종료되지 않은 설문
	public List<SurveyVO> getActiveSurveys(Map<String, Object> map);
	
	//설문 등록
	public int registSurvey(SurveyVO surveyVO);
	
	//질문 등록
	public Object insertQuestion(SurveyQstVO surveyQstVO);
	
	//보기 등록
	public Object insertOption(SurveyOptionVO surveyOptionVO);

}
