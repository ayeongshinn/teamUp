package kr.or.ddit.planng.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.planng.service.SurveyService;
import kr.or.ddit.planng.vo.NoticeVO;
import kr.or.ddit.planng.vo.SurveyAnsVO;
import kr.or.ddit.planng.vo.SurveyOptionVO;
import kr.or.ddit.planng.vo.SurveyQstVO;
import kr.or.ddit.planng.vo.SurveyVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class SurveyController {
	
	@Autowired
	SurveyService surveyService;
	
	//설문 목록
	@GetMapping("/surveyList")
	public String surveyList(@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
							 @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
							 @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
							 @RequestParam(value = "srvyNo", required = false, defaultValue= "") String srvyNo,
							 @RequestParam(value = "status", required=false, defaultValue="all") String status,
							 @RequestParam(value = "mySurveyList", required=false, defaultValue="false") boolean mySurveyList,
							 Model model) {
		
		//사원번호 가져옴
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String empNo = authentication.getName();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage); //현재 페이지
		map.put("srvyNo", srvyNo);
		map.put("status", status); //상태값 추가
		
		//내가 만든 설문 조회할 경우
		if (mySurveyList) {
			map.put("empNo", empNo);
		}
		
		// 전체 설문 목록 가져오기
        List<SurveyVO> surveyVOList = this.surveyService.surveyList(map);
        log.info("전체 설문 목록: " + surveyVOList);
		
		//현재 진행 중인 설문 가져오기
		List<SurveyVO> activeSurveyList = this.surveyService.getActiveSurveys(map);
        log.info("진행 중인 설문 목록: " + activeSurveyList);
        //현재 진행 중인 설문에서 설문 참여 여부 가져오기
        for(SurveyVO surveyVO : activeSurveyList) {
        	map.put("srvyNo", surveyVO.getSrvyNo());
        	map.put("empNo", empNo);
        	
        	int participated = this.surveyService.getParticipated(map);
        	
        	surveyVO.setParticipated(participated > 0 ? true : false);
        }
        
        //설문 참여 여부 가져오기
        for(SurveyVO surveyVO : surveyVOList) {
        	Map<String, Object> paramMap = new HashMap<>();
        	paramMap.put("srvyNo", surveyVO.getSrvyNo());
        	paramMap.put("empNo", empNo);
        	
        	int participated = this.surveyService.getParticipated(paramMap);
        	
        	surveyVO.setParticipated(participated > 0 ? true : false);
        }
        
        //설문에 참여한 인원 가져오기
        for(SurveyVO surveyVO : surveyVOList) {
        	int participatedCnt = this.surveyService.getParticipatedCnt(surveyVO.getSrvyNo());
        	surveyVO.setParticipatedCnt(participatedCnt);
        }
        
        //남은 시간 계산 로직 추가
        for (SurveyVO surveyVO : surveyVOList) {
            String srvyEndDate = surveyVO.getSrvyEndDate(); //종료 날짜
            String srvyEndTm = surveyVO.getSrvyEndTm(); //종료 시간
            
            //강제 종료 처리
            if ("Y".equals(surveyVO.getEndYn())) {
                surveyVO.setRemainingTime("종료");
                continue;
            }

            //String을 LocalDateTime으로 변환
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            LocalDateTime endDateTime = LocalDateTime.parse(srvyEndDate + " " + srvyEndTm, formatter);

            //현재 시간
            LocalDateTime now = LocalDateTime.now();

            //남은 시간 계산
            long totalHoursUntilEnd = ChronoUnit.HOURS.between(now, endDateTime);
            long totalMinutesUntilEnd = ChronoUnit.MINUTES.between(now, endDateTime); // 남은 분까지 계산
            long remainDays = totalHoursUntilEnd / 24;
            long remainHours = totalHoursUntilEnd % 24;
            long remainMinutes = totalMinutesUntilEnd % 60; // 남은 분

            String remainingTime; //남은 시간을 조건에 따라 String으로 생성
            if (totalHoursUntilEnd < 0) {
                remainingTime = "종료"; //이미 시간이 지났을 경우
            } else if (totalMinutesUntilEnd < 60) {
                remainingTime = remainMinutes + "분 후 종료"; //1시간 미만일 때 분만 표시
            } else if (totalHoursUntilEnd < 24) {
                remainingTime = remainHours + "시간 " + remainMinutes + "분 후 종료"; //24시간 미만일 때 시간과 분 표시
            } else {
                remainingTime = remainDays + "일 " + remainHours + "시간 후 종료"; //24시간 이상일 때 일수와 시간 표시
            }

            surveyVO.setRemainingTime(remainingTime); //남은 시간 저장
        }
		
		model.addAttribute("surveyVOList", surveyVOList);
		model.addAttribute("activeSurveyList", activeSurveyList);
		
		//전체 행의 수
		int total = this.surveyService.getTotal(map);
		log.info("total: " + total);
		
		//페이지네이션 객체
		ArticlePage<SurveyVO> articlePage = new ArticlePage<SurveyVO>(total, currentPage, 10, surveyVOList, keyword);
		
		model.addAttribute("articlePage", articlePage);
		
		return "planng/surveyList";
	}
	
	//설문 종료하기 - 기획부 권한
	@PostMapping("/endSurveysAjax")
	@ResponseBody
	public int endSurveysAjax(@RequestBody List<String> srvyNo) {
		
		int result = this.surveyService.endSurveysAjax(srvyNo);
		log.info("endSurveysAjax -> result: " + result);
		
		return result > 0 ? result : 0;
	}
	
	//설문 삭제하기 - 기획부 권한
	@PostMapping("/deleteSurveysAjax")
	@ResponseBody
	public int deleteSurveysAjax(@RequestBody List<String> srvyNo) {
		
		int result = this.surveyService.deleteSurveysAjax(srvyNo);
		log.info("deleteSurveysAjax -> result: " + result);
		
		return result > 0 ? result : 0;
	}
	
	//설문 등록 폼
	@GetMapping("/surveyForm")
	public String surveyForm() {
		
		return "planng/surveyForm";
	}
	
	//설문 등록 처리
	@PostMapping("/registSurvey")
	public String registSurvey(SurveyVO surveyVO, Model model) {
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
		log.info("registSurvey->surveyVO : " + surveyVO);

		int result = this.surveyService.registSurvey(surveyVO);
		log.info("registSurvey->result : " + result);
		
		//SurveyVO에 저장할 날짜와 시간
	   
		return "redirect:/surveyDetail?srvyNo=" + surveyVO.getSrvyNo();
	}
	
	//설문 상세
	@GetMapping("/surveyDetail")
	public String surveyDetail(@RequestParam("srvyNo") String srvyNo, Model model) {
		
		//사원 번호 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String empNo = authentication.getName();
		
		//현재 글 조회
		SurveyVO surveyVO = this.surveyService.surveyDetail(srvyNo);
		
		//질문과 옵션 조회
		List<SurveyQstVO> surveyQstVOList = this.surveyService.getSurveyQstOpt(srvyNo);
		log.info("surveyDetail -> surveyQstVOList:" + surveyQstVOList);
		
		//이전 글과 다음 글 조회
		SurveyVO prevSurvey = this.surveyService.surveyDetailNPrev(srvyNo);
		SurveyVO nextSurvey = this.surveyService.surveyDetailNNxt(srvyNo);
		
		//설문에 참여했는지 확인
		Map<String, Object> map = new HashMap<>(); 
		map.put("srvyNo", srvyNo);
		map.put("empNo", empNo);
	
		int participated = this.surveyService.getParticipated(map);
		
		surveyVO.setParticipated(participated > 0 ? true : false);
		
		model.addAttribute("surveyVO", surveyVO); //설문 
		model.addAttribute("surveyQstVOList", surveyQstVOList); //질문, 보기
		model.addAttribute("prevSurvey", prevSurvey);
		model.addAttribute("nextSurvey", nextSurvey);
		
		return "planng/surveyDetail";
	}
	
	//설문 삭제
	@PostMapping("/deleteSurvey")
	public String deleteSurvey(@RequestParam("srvyNo") String srvyNo) {
		
		int result = this.surveyService.deleteSurvey(srvyNo);
		log.info("deleteSurvey -> result: " + result);
		
		return "redirect:/surveyList";
	}
	
	//응답 제출
	@PostMapping("/submitAnswer")
	public String submitAnswer(@ModelAttribute SurveyVO surveyVO, Model model) {
		/* insert문이 3회(질문이 3개) 반복 
		#{ansNo}, #{srvyNo}, #{srvyQstNo}, #{ansEmpNo}, SYSDATE,
				#{descAns}, #{multiAns}
		 */
		/*
		surveyVO: SurveyVO(srvyNo=SRVY00002, srvyTtl=null, srvyCn=null, srvyEmpNo=220001, srvyRegDate=null, 
		srvyBgngDate=null, srvyBgngTm=null, srvyEndDate=null, srvyEndTm=null, resOpenYn=null, annmsYn=null, 
		delYn=null, endYn=null, srvyTarget=null, 
			srvyQstVOList=[
				SurveyQstVO(srvyQstNo=SQST00002, srvyNo=null, quesCn=null, quesCd=null, quesExp=null, optionList=null, surveyAnsVOList=null, multiAns=OPTN00002, descAns=null), 
				SurveyQstVO(srvyQstNo=SQST00003, srvyNo=null, quesCn=null, quesCd=null, quesExp=null, optionList=null, surveyAnsVOList=null, multiAns=OPTN00008, descAns=null), 
				SurveyQstVO(srvyQstNo=SQST00004, srvyNo=null, quesCn=null, quesCd=null, quesExp=null, optionList=null, surveyAnsVOList=null, multiAns=OPTN00014, descAns=null)],
				 questionList=null, quesExpList=null, quesCdList=null, remainDays=0, remainHours=0, remainingTime=null, empNm=null, deptCd=null, jbgdCd=null)
		 */
		log.info("submitAnswer -> surveyVO: " + surveyVO);
		
		int result = this.surveyService.submitAnswer(surveyVO);
		model.addAttribute("surveyVO", surveyVO);
				
		return "redirect:/surveyDetail?srvyNo=" + surveyVO.getSrvyNo();
	}
	
	//설문 결과 페이지로
	@GetMapping("/surveyResult")
	public String surveyResult(@RequestParam ("srvyNo") String srvyNo,
								@RequestParam ("srvyTarget") String srvyTarget,
								 Model model) {
		
		//설문 정보 
		SurveyVO surveyVO = this.surveyService.surveyResult(srvyNo);
		
		//질문과 옵션
		List<SurveyQstVO> surveyQstVOList = this.surveyService.getSurveyQstOpt(srvyNo);
		
		//객관식 응답과 서술형 응답 가져오기 
		List<SurveyAnsVO> multiAnsList = this.surveyService.getMultiAns(srvyNo);
		List<SurveyAnsVO> descAnsList = this.surveyService.getDescAns(srvyNo); 
		
		//각 질문의 전체 응답 수 가져오기
		Map<String, Object> allAnsCntMap = new HashMap<>();
		for(SurveyQstVO qst : surveyQstVOList) {
			Map<String, Object> map = new HashMap<>();
			map.put("srvyNo", srvyNo);
			map.put("srvyQstNo", qst.getSrvyQstNo());
			
			int allAnsCnt = this.surveyService.getAllAnsCnt(map);
			allAnsCntMap.put(qst.getSrvyQstNo(), allAnsCnt);
		}
		
		//각 설문의 전체 대상자 수 가져오기
		int allParticiCnt = this.surveyService.getAllPartici(srvyTarget);
		
		//설문의 참여자 수 가져오기
		int particiCnt = this.surveyService.getParticipatedCnt(srvyNo);
		
		model.addAttribute("surveyVO", surveyVO);
		model.addAttribute("surveyQstVOList", surveyQstVOList);
		model.addAttribute("multiAnsList", multiAnsList);
		model.addAttribute("descAnsList", descAnsList);
		model.addAttribute("allAnsCntMap", allAnsCntMap);
		model.addAttribute("allParticiCnt", allParticiCnt);
		model.addAttribute("particiCnt", particiCnt);
		
		return "planng/surveyResult";
	}
	
//	//설문 수정 페이지로
//	@GetMapping("/updateSurvey")
//	public String updateSurvey(@RequestParam("srvyNo") String srvyNo, Model model) {
//
//		SurveyVO surveyVO = this.surveyService.surveyDetail(srvyNo);
//		model.addAttribute("surveyVO", surveyVO);
//		
//		return "planng/updateSurvey";
//	}
//	
//	//설문 수정 처리
//	@PostMapping("/updateSurvey")
//	public String updateSurvey(@ModelAttribute SurveyVO surveyVO) {
//		
//		int result = this.surveyService.updateSurvey(surveyVO);
//		log.info("updateSurvey -> result: " + result);
//		
//		return "redirect:/surveyDetail?srvyNo=" + surveyVO.getSrvyNo();
//	}

	
	
	
}
