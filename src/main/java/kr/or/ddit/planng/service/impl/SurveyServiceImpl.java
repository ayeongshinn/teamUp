package kr.or.ddit.planng.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.planng.mapper.SurveyMapper;
import kr.or.ddit.planng.service.SurveyService;
import kr.or.ddit.planng.vo.SurveyAnsVO;
import kr.or.ddit.planng.vo.SurveyOptionVO;
import kr.or.ddit.planng.vo.SurveyQstVO;
import kr.or.ddit.planng.vo.SurveyVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SurveyServiceImpl implements SurveyService {
	
	@Autowired
	SurveyMapper surveyMapper;
	
	@Autowired
	UploadController uploadController;

	//설문 목록
	@Override
	public List<SurveyVO> surveyList(Map<String, Object> map) {
		return this.surveyMapper.surveyList(map);
	}
	
	//전체 행의 수
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.surveyMapper.getTotal(map);
	}
	
	//종료되지 않은 설문
	@Override
	public List<SurveyVO> getActiveSurveys(Map<String, Object> map) {
		return this.surveyMapper.getActiveSurveys(map);
	}
	
	//설문 등록
	@Override
	public int registSurvey(SurveyVO surveyVO) {
		/*
		 registSurvey->surveyVO : SurveyVO(
		 srvyNo=null, srvyTtl=설문 제목 테스트2, srvyCn=<p>asdf</p>, srvyEmpNo=, srvyRegDate=null, srvyBgngDate=2024-10-16
		 , srvyBgngTm=14:29, srvyEndDate=2024-10-24, srvyEndTm=14:29, resOpenYn=N, annmsYn=N, delYn=null, endYn=null
		 , srvyTarget=A03-006, 
		 질문1
		 srvyQstVOList=[
			 SurveyQstVO(srvyQstNo=null, srvyNo=null, quesCn=q1, quesCd=null, quesExp=n1, 
				 optionList=[
				 보기1
				 SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=11), 
				 보기2
				 SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=12), 
				 보기3
				 SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=13), 
				 보기4
				 SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=14)]
			 ),
		질문2 
		SurveyQstVO(srvyQstNo=null, srvyNo=null, quesCn=q2, quesCd=null, quesExp=n2, 
			 optionList=[
			 	 보기1
				 SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=21), 
				 보기2
				 SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=22), 
				 보기3
				 SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=23), 
				 보기4
				 SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=24)])], 
		 
		 questionList=null, quesExpList=null, quesCdList=[A27-001, A27-001], 
		 optionList=null, remainDays=0, remainHours=0, remainingTime=null, empNm=null, deptCd=null, jbgdCd=null)
		 */
		 	surveyVO.setSrvyBgngDate(surveyVO.getSrvyBgngDate());
		    surveyVO.setSrvyBgngTm(surveyVO.getSrvyBgngTm());
		    surveyVO.setSrvyEndDate(surveyVO.getSrvyEndDate());
		    surveyVO.setSrvyEndTm(surveyVO.getSrvyEndTm());
			
			//1. 설문 테이블에 데이터 저장(SRVY)
			int result = this.surveyMapper.registSurvey(surveyVO);
			//성공시(selectKey에 의해서 기본키 데이터가 채워져있을것) : SurveyVO(srvyNo=SQST00005, srvyTtl=설문 제목 테스트2..
			log.info("registSurvey -> result :" + result);
			
			//2. 설문 질문 테이블에 각 질문 저장(SRVY_QST)
			List<SurveyQstVO> srvyQstVOList = surveyVO.getSrvyQstVOList();
			log.info("srvyQstVOList 확인: " + srvyQstVOList);
			int qstCounter = 0;
			for(SurveyQstVO surveyQstVO : srvyQstVOList) {
				//SurveyQstVO(srvyQstNo=null, srvyNo=null, quesCn=q2, quesCd=null, quesExp=n2, 
				surveyQstVO.setSrvyQstNo("");//selectKey에 의해 자동 생성 예정(P.K)
				surveyQstVO.setSrvyNo(surveyVO.getSrvyNo()); //설문 번호(P.K)
				surveyQstVO.setQuesCn(surveyQstVO.getQuesCn()); //질문 내용
				surveyQstVO.setQuesCd(surveyVO.getQuesCdList().get(qstCounter)); //질문 유형 코드
				qstCounter++;
				surveyQstVO.setQuesExp(surveyQstVO.getQuesExp()); //질문 설명

				//질문 저장 로직 호출
				result += this.surveyMapper.insertQuestion(surveyQstVO);
				//성공시 : //SurveyQstVO(srvyQstNo=SQST00002, srvyNo=SRVY00002, quesCn=q2, quesCd=null, quesExp=n2, 
				
				//3-1. 옵션이 있을 때
				List<SurveyOptionVO> optionList = surveyQstVO.getOptionList();
				
				//3-2. 옵션 저장(하나의 질의에 종속됨) 
				if (optionList != null && optionList.size() > 0) {
		            for (SurveyOptionVO surveyOptionVO : optionList) {
		            	surveyOptionVO.setOptionNo("");//selectKey로 자동 처리 그 질문의 옵션 ,,,N
		                surveyOptionVO.setSrvyQstNo(surveyQstVO.getSrvyQstNo());//그 설문 질문.. N  ,,,1
		                surveyOptionVO.setSrvyNo(surveyVO.getSrvyNo());//어떤 설문인가?1
		                //SurveyOptionVO(optionNo=null, srvyQstNo=null, srvyNo=null, optionCn=11), 
		                //surveyOptionVO.setOptionCn(; //생략(이미 들어 있으니까 )

		                //옵션 저장
		                result += this.surveyMapper.insertOption(surveyOptionVO);		                
		            }
		        }
			}	
			
		return result;
	}
	
	//질문 등록
	@Override
	public void insertQuestion(SurveyQstVO surveyQstVO) {
		this.surveyMapper.insertQuestion(surveyQstVO);
	}
	
	//보기 등록
	@Override
	public void insertOption(SurveyOptionVO surveyOptionVO) {
		this.surveyMapper.insertOption(surveyOptionVO);
	}
	
	//설문 종료
	@Override
	public int endSurveysAjax(List<String> srvyNo) {
		return this.surveyMapper.endSurveysAjax(srvyNo);
	}
	
	//설문 삭제 - 기획부 권한
	@Override
	public int deleteSurveysAjax(List<String> srvyNo) {
		return this.surveyMapper.deleteSurveysAjax(srvyNo);
	}
	
	//설문 상세
	@Override
	public SurveyVO surveyDetail(String srvyNo) {
		return this.surveyMapper.surveyDetail(srvyNo);
	}
	
	//설문 삭제
	@Override
	public int deleteSurvey(String srvyNo) {
		return this.surveyMapper.deleteSurvey(srvyNo);
	}
	
	//이전 설문 조회
	@Override
	public SurveyVO surveyDetailNPrev(String srvyNo) {
		return this.surveyMapper.surveyDetailNPrev(srvyNo);
	}
	
	//다음 설문 조회
	@Override
	public SurveyVO surveyDetailNNxt(String srvyNo) {
		return this.surveyMapper.surveyDetailNNxt(srvyNo);
	}
	
	//각 설문의 질문과 옵션 조회
	@Override
	public List<SurveyQstVO> getSurveyQstOpt(String srvyNo) {
		return this.surveyMapper.getSurveyQstOpt(srvyNo);
	}
	
	//응답 제출
	@Override
	public int submitAnswer(SurveyVO surveyVO) {
		
		//1. 설문 답변 저장
		int result = 0;
		
		/* insert문이 3회(질문이 3개) 반복 
		#{ansNo}, #{srvyNo}, #{srvyQstNo}, #{ansEmpNo}, SYSDATE,
				#{descAns}, #{multiAns}
		 */
		/*
		surveyVO: SurveyVO(srvyNo=SRVY00002, srvyTtl=null, srvyCn=null, srvyEmpNo=220001, srvyRegDate=null, 
		srvyBgngDate=null, srvyBgngTm=null, srvyEndDate=null, srvyEndTm=null, resOpenYn=null, annmsYn=null, 
		delYn=null, endYn=null, srvyTarget=null, 
			srvyQstVOList=[
				SurveyQstVO(srvyQstNo=SQST00002, srvyNo=null, quesCn=null, quesCd=A27-001, quesExp=null, optionList=null, surveyAnsVOList=null, multiAns=OPTN00002, descAns=null), 
				SurveyQstVO(srvyQstNo=SQST00003, srvyNo=null, quesCn=null, quesCd=A27-001, quesExp=null, optionList=null, surveyAnsVOList=null, multiAns=OPTN00008, descAns=null), 
				SurveyQstVO(srvyQstNo=SQST00004, srvyNo=null, quesCn=null, quesCd=A27-001, quesExp=null, optionList=null, surveyAnsVOList=null, multiAns=OPTN00014, descAns=null)],
				 questionList=null, quesExpList=null, quesCdList=null, remainDays=0, remainHours=0, remainingTime=null, empNm=null, deptCd=null, jbgdCd=null)
		 */
		//surveyVO(설문)에서 srvyQstVOList(질문들) 을 꺼냄 
		List<SurveyQstVO> srvyQstVOList = surveyVO.getSrvyQstVOList();
		
		for(SurveyQstVO surveyQstVO : srvyQstVOList) {
			SurveyAnsVO surveyAnsVO = new SurveyAnsVO();
			surveyAnsVO.setAnsNo(""); //자동생성
			surveyAnsVO.setSrvyNo(surveyVO.getSrvyNo());
			surveyAnsVO.setSrvyQstNo(surveyQstVO.getSrvyQstNo());
			surveyAnsVO.setAnsEmpNo(surveyVO.getSrvyEmpNo());

			if("A27-001".equals(surveyQstVO.getQuesCd())) {
				surveyAnsVO.setDescAns("");
				surveyAnsVO.setMultiAns(surveyQstVO.getMultiAns());
			} else if("A27-002".equals(surveyQstVO.getQuesCd())) {
				surveyAnsVO.setMultiAns("");
				surveyAnsVO.setDescAns(surveyQstVO.getDescAns());
			}			
			
			result += this.surveyMapper.insertSurveyAnswer(surveyAnsVO);
			log.info("submitAnswer -> result: " + result);
		}
		
		return result;
	}
	
	//설문에 참여했는지 확인
	@Override
	public int getParticipated(Map<String, Object> map) {
		return this.surveyMapper.getParticipated(map);
	}
	
	//설문에 참여한 인원
	@Override
	public int getParticipatedCnt(String srvyNo) {
		return this.surveyMapper.getParticipatedCnt(srvyNo);
	}
	
	//설문 결과
	@Override
	public SurveyVO surveyResult(String srvyNo) {
		return this.surveyMapper.surveyResult(srvyNo);
	}
	
	//객관식 응답 가져오기
	@Override
	public List<SurveyAnsVO> getMultiAns(String srvyNo) {
		return this.surveyMapper.getMultiAns(srvyNo);
	}
	
	//서술형 응답 가져오기
	@Override
	public List<SurveyAnsVO> getDescAns(String srvyNo) {
		return this.surveyMapper.getDescAns(srvyNo);
	}
	
	//각 질문의 전체 응답 가져오기
	public int getAllAnsCnt(Map<String, Object> map) {
		return this.surveyMapper.getAllAnsCnt(map);
	}
	
	//각 설문의 대상자 수 가져오기
	@Override
	public int getAllPartici(String srvyTarget) {
		return this.surveyMapper.getAllPartici(srvyTarget);
	}

	//설문 수정 처리
//	@Override
//	public int updateSurvey(SurveyVO surveyVO) {
//		return this.surveyMapper.updateSurvey(surveyVO);
//	}
}
