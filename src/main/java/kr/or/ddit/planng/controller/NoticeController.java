//NoticeController :: 신아영
package kr.or.ddit.planng.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.bsn.vo.CounterPartyVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.planng.service.NoticeService;
import kr.or.ddit.planng.vo.NoticeVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NoticeController {
	
	@Autowired
	NoticeService noticeService;
	
	//공지 목록(공통 열람 공지)
	@GetMapping("/noticeList")
	public String noticeList(@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
							 @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
							 @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
							 @RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
							 @RequestParam(value = "endDate", required = false, defaultValue = "") String endDate,
							 @RequestParam(value = "ntcNo", required = false, defaultValue= "") String ntcNo,
							 Model model) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		List<NoticeVO> noticeVOList = this.noticeService.noticeList(map);
		
		model.addAttribute("noticeVOList", noticeVOList);
		
		//전체 행의 수
		int total = this.noticeService.getTotalY(map);
		log.info("total: " + total);
		
		//페이지네이션 객체
		ArticlePage<NoticeVO> articlePage = new ArticlePage<NoticeVO>(total, currentPage, 10, noticeVOList, keyword);
		
		model.addAttribute("articlePage", articlePage);
		
		return "planng/noticeList";
	}
	
	//공지 상세 페이지로 이동(공통 열람 공지)
	@GetMapping("/noticeDetail")
	public String noticeDetail(@RequestParam("ntcNo") String ntcNo, Model model) {
		
		//조회수 증가 로직
		noticeService.increaseViewCnt(ntcNo);
		
		//게시글 정보 가져오기
		NoticeVO noticeVO = noticeService.noticeDetail(ntcNo);
		model.addAttribute("noticeVO", noticeVO);
		
		//이전 글과 다음 글 조회
		NoticeVO prevNotice = noticeService.noticeDetailNPrev(ntcNo);
		NoticeVO nextNotice = noticeService.noticeDetailNNxt(ntcNo);
						
		model.addAttribute("prevNotice", prevNotice);
		model.addAttribute("nextNotice", nextNotice);
		
		return "planng/noticeDetail";
	}
	
	
	//-----------------------------------------
	
	//공지 목록(기획부 열람 공지)
	@GetMapping("/noticeListN")
	public String noticeListN(@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			 				  @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			 				  @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			 				  @RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			 				  @RequestParam(value = "status", required = false) String status,
			 				  @RequestParam(value = "endDate", required = false, defaultValue = "") String endDate,
			 				  @RequestParam(value = "myNoticeList", required = false, defaultValue="false") boolean myNoticeList,
			 				  Model model) {
		
		//사원번호 가져옴
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String empNo = authentication.getName();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage); //현재 페이지
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		map.put("status", status != null && !status.equals("all") ? status : null); //승인 상태
		
		//내가 작성한 게시글만 조회할 경우
		if (myNoticeList) {
			map.put("empNo", empNo);
		}

		//검색 결과 가져오기
		List<NoticeVO> noticeVOList = this.noticeService.noticeListN(map);
		
		//전체 행의 수
		int total = this.noticeService.getTotalN(map);
		
		log.info("mybatis 파라미터: " + map);
		log.info("searchField: " + searchField);
		log.info("keyword: " + keyword);
		log.info("noticeListN -> noticeVOList : " + noticeVOList);
		log.info("total: " + total);

		//페이지네이션 객체
		ArticlePage<NoticeVO> articlePage = new ArticlePage<NoticeVO>(total, currentPage, 10, noticeVOList, keyword);
		
		//대기 중인 공지사항 수 가져오기
		int wCnt = this.noticeService.getWCnt();
		log.info("wCnt: " + wCnt);
		
		//사원이 작성한 게시글 수 가져오기
		int myNotices = this.noticeService.getMyNotices(empNo);
		log.info("myNotices: ", myNotices);
		
		model.addAttribute("noticeVOList", noticeVOList);
		model.addAttribute("myNotices", myNotices);
		model.addAttribute("wCnt", wCnt);
		model.addAttribute("articlePage", articlePage);
		
		return "planng/noticeListN";
	}
	
	//공지 목록(기획부 열람 공지)
	@ResponseBody
	@PostMapping("/noticeListNAjax")
	public ArticlePage<NoticeVO> noticeListNAjax(@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			 				  @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			 				  @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			 				  @RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			 				  @RequestParam(value = "endDate", required = false, defaultValue = "") String endDate,
			 				  @RequestParam(value = "aprvYn", required = false, defaultValue = "") String aprvYn,
			 				  Model model) {
		
		//사원번호 가져옴
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String empNo = authentication.getName();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		map.put("aprvYn", aprvYn); //반려구분
		
		//상태(aprvYn)가 선택된 경우 empNo 조건을 제외
	    if (aprvYn == null || aprvYn.isEmpty()) {
	        map.put("empNo", empNo);
	    }
		
		log.info("searchField: ", searchField);
		log.info("keyword: ", keyword);
		log.info("map : ", map);
		
		//검색 결과 가져오기
		List<NoticeVO> noticeVOList = this.noticeService.noticeListN(map);
		model.addAttribute("noticeVOList", noticeVOList);
		
		//전체 행의 수
		int total = this.noticeService.getTotalN(map);
		log.info("total: ", total);

		//페이지네이션 객체
		ArticlePage<NoticeVO> articlePage = new ArticlePage<NoticeVO>(total, currentPage, 10, noticeVOList, keyword);

		return articlePage;
	}
	
	//공지 등록 폼 이동(기획부 열람 공지)
	@GetMapping("/registForm")
	public String registForm() {
		return "planng/registForm";
	}
	
	//공지 등록 처리(기획부 열람 공지)
	/**
	 * 
	 * 요청URI : /registNotice
    	요청파라미터 : {ntcTtl=제목,imprtncYn=Y,ntcCn=내용,uploadFile=파일객체}
	 */
	@PostMapping("/registNotice")
	public String registNotice(@ModelAttribute NoticeVO noticeVO,
								@RequestParam("uploadFile") MultipartFile[] uploadFile) {
		/*
		 NoticeVO(ntcNo=null, ntcTtl=1, ntcCn=<p>2</p>, empNo=null, regDt=null, inqCnt=0, imprtncYn=N, delYn=null, fileGroupNo=0, aprvYn=null
		 , empNm=null, 
		 uploadFile=[
			 org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@5af2aaef, 
			 org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@77e366f1]
		 , strRegDt=null, rnum=0)
		 */
		log.info("registNotice->noticeVO :" + noticeVO);
		
		//파일을 noticeVO에 설정
		//noticeVO.setUploadFile(uploadFile);
		
		//로그인한 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String empNo = authentication.getName();
		
		//VO에 사용자 정보 설정
		noticeVO.setEmpNo(empNo);
		
		int result = this.noticeService.registNotice(noticeVO);
		log.info("registNotice -> result: " + result);
		
		//상세 화면으로 이동
		return "redirect:/noticeDetailN?ntcNo=" + noticeVO.getNtcNo();
	}
	
	//공지 상세 보기(기획부 열람 공지)
	@GetMapping("/noticeDetailN")
	public String noticeDetailN(@RequestParam("ntcNo") String ntcNo, Model model) {
		
		//현재 글 조회
		NoticeVO noticeVO = this.noticeService.noticeDetailN(ntcNo);
		model.addAttribute("noticeVO", noticeVO);
				
		//이전 글과 다음 글 조회
		NoticeVO prevNotice = noticeService.noticeDetailNPrev(ntcNo);
		NoticeVO nextNotice = noticeService.noticeDetailNNxt(ntcNo);
				
		model.addAttribute("noticeVO", noticeVO);
		model.addAttribute("prevNotice", prevNotice);
		model.addAttribute("nextNotice", nextNotice);
		
		log.info("noticeDetailN -> noticeVO: " + noticeVO);
		
		return "planng/noticeDetailN";
	}
	
	//공지 수정 페이지로(기획부 열람 공지)
	@GetMapping("/updateNotice")
	public String updateNotice(@RequestParam("ntcNo") String ntcNo, Model model) {
			
		NoticeVO noticeVO = this.noticeService.noticeDetailN(ntcNo);
		model.addAttribute("noticeVO", noticeVO);
		
		return "planng/updateNotice";
	}
	
	//공지 게시글 수정 처리(기획부 열람 공지)
	/*
	 [이미지 삭제]
	 fileDetailVOList에 대상이 들어갈것임 
	 <input type="text" name="fileDetailVOList[0].fileSn" value="1">
	 <input type="text" name="fileDetailVOList[0].fileGroupNo" value="67">
	 */
	@PostMapping("/updateNotice")
	public String updateNotice(@ModelAttribute NoticeVO noticeVO) {
		log.info("updateNotice->noticeVO : " + noticeVO);
		
		//noticeVO의 각 필드 값 확인
	    log.info("empNo: " + noticeVO.getEmpNo());
	    log.info("ntcNo: " + noticeVO.getNtcNo());
	    log.info("ntcTtl: " + noticeVO.getNtcTtl());
	    log.info("ntcCn: " + noticeVO.getNtcCn());
	    
	    //파일 처리 확인
	    if (noticeVO.getUploadFile() != null) {
	        log.info("uploadFile count: " + noticeVO.getUploadFile().length);
	    } 
		
		int result = this.noticeService.updateNotice(noticeVO);
		log.info("result: " + result);
		
		return "redirect:/noticeDetailN?ntcNo=" + noticeVO.getNtcNo();
	}
	
	//공지 삭제 처리(기획부 열람 공지)
	@PostMapping("/deleteNotice")
	public String deleteNotice(@RequestParam("ntcNo") String ntcNo) {
		
		int result = this.noticeService.deleteNotice(ntcNo);
		log.info("result: " + result);
		
		return "redirect:/noticeListN";
	}
	
	//파일 상세
	@ResponseBody
	@PostMapping("/getFileDetails")
	public List<FileDetailVO> getFileDetails(int fileGroupNo){
		log.info("getFileDetails->fileGroupNo : " + fileGroupNo);
			
		List<FileDetailVO> fileDetailVOList = this.noticeService.getFileDetails(fileGroupNo);
		log.info("getFileDetails->fileDetailVOList : " + fileDetailVOList);
			
		return fileDetailVOList;
	}
	
	//승인 상태 업데이트
	@ResponseBody
	@PostMapping("/updateAprvStatus")
	public String updateAprvStatus(@ModelAttribute NoticeVO noticeVO) {
		
		int result = this.noticeService.updateAprvStatus(noticeVO);
		log.info("result: " + result);
		
		return "redirect:/noticeDetailN?ntcNo=" + noticeVO.getNtcNo();
	}
}
