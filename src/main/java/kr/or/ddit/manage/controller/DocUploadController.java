package kr.or.ddit.manage.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.beust.jcommander.Parameter;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.manage.service.DocUploadService;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.manage.vo.FixturesVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/docUpload")
public class DocUploadController {

	@Inject
	DocUploadService docUploadService;
	
	// 자료 게시판 전체 리스트
	@GetMapping("/list")
	public String list(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
		    @RequestParam(value = "startDate", required = false) String startDate, // 구입 시작일
		    @RequestParam(value = "endDate", required = false) String endDate,     // 구입 종료일
			@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage
			) {
		
		// 검색 조건 및 현재 페이지 map에 저장
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("searchField", searchField);
		map.put("keyword", keyword);
	    map.put("startDate", startDate);
	    map.put("endDate", endDate);
		map.put("currentPage", currentPage);
		
		// 검색 조건에 따른 자료 조회
		List<BoardVO> docUploadList = this.docUploadService.list(map);
		log.info("docUploadList -> " + docUploadList);
		
		// 전체 데이터 개수 조회
		int total = this.docUploadService.getTotal(map);
		log.info("fixtures -> total : " + total);
		
		//페이징 처리
		ArticlePage<BoardVO> articlePage = new ArticlePage<BoardVO> (total,currentPage,10,docUploadList,keyword);
		
		model.addAttribute("docUploadList", docUploadList);
		model.addAttribute("articlePage", articlePage);
		
		return "manage/docUpload/list";
	}
	
	// 자료 게시판 상세
	@GetMapping("/detail")
	public String detail(String bbsNo, Model model) {
		
		//조회수 증가 처리
		docUploadService.increaseInq(bbsNo);
		
		// 특정 번호를 통한 게시글 정보 조회
		BoardVO boardVO = this.docUploadService.detail(bbsNo);
		log.info("boardVO -> " + boardVO);
		
		//파일 정보 가져오기
		List<FileDetailVO> fileDetailList = this.docUploadService.getFileDetails(boardVO.getFileGroupNo());
		 		
		// 이전 목록 보기
		BoardVO prevNo = docUploadService.detailPrev(bbsNo);
		// 다음 목록 보기
		BoardVO nextNo = docUploadService.detailNext(bbsNo);
			
		model.addAttribute("boardVO", boardVO);
		model.addAttribute("fileDetailList", fileDetailList); // 파일 리스트 추가
		model.addAttribute("prevNo", prevNo); // 이전
		model.addAttribute("nextNo", nextNo); // 다음
		
		return "manage/docUpload/detail";
	}
	
	// 자료 등록 페이지로 이동
	@GetMapping("/regist")
	public String regist() {
		return "manage/docUpload/regist";
	}
	
	// 자료 등록
	@PostMapping("/registDoc")
	public String registDoc(
			@ModelAttribute BoardVO boardVO,
			@RequestParam("uploadFile") MultipartFile[] uploadFile
			) {
		
		log.info("registDoc -> boardVO : " + boardVO);
		
		//로그인한 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String empNo = authentication.getName();
		
		log.info("empNo : " + empNo);
		boardVO.setEmpNo(empNo);
		
		// 자료 등록 처리
		int result = this.docUploadService.registDoc(boardVO);
		log.info("registDoc : result -> " + result);
		
		
		return "redirect:/docUpload/detail?bbsNo=" + boardVO.getBbsNo();
	}
	
	// 자료 수정 페이지 이동
	@GetMapping("/edit")
	public String updateDoc(
			Model model,
			@RequestParam("bbsNo") String bbsNo
			) {
		
		// 특정 번호를 통해 수정할 게시글 정보 조회
		BoardVO boardVO = this.docUploadService.detail(bbsNo);
		log.info("docUpload -> edit : " + boardVO );
		
		//파일 정보 가져오기
		List<FileDetailVO> fileDetailList = this.docUploadService.getFileDetails(boardVO.getFileGroupNo());
		log.info("docUpload -> fileDetailList : " + fileDetailList);
		
		model.addAttribute("boardVO", boardVO);		
		model.addAttribute("fileDetailList", fileDetailList); // 파일 리스트 추가
		
		return "manage/docUpload/edit";
	}
	
	// 자료 수정
	@PostMapping("/updateDoc")
	public String updateDoc(@ModelAttribute BoardVO boardVO) {
		
		log.info("updateDoc -> boardVO : " + boardVO);
		
		// 자료 업데이트 처리
		int result = this.docUploadService.updateDoc(boardVO);
		log.info("updateDoc : result -> " + result);
		
		return "redirect:/docUpload/detail?bbsNo=" + boardVO.getBbsNo();
	}
	
	// 자료 삭제
	@ResponseBody
	@PostMapping("/deleteDoc")
	public String deleteDoc(BoardVO boardVO) {
		//...fxtrsNoList=[B0002, B0005, B0006])
		log.info("deleteDoc->boardVO : " + boardVO);
		
		// 삭제할 게시글 번호 목록 생성
		String[] checks = boardVO.getBbsNoList();
		
		// 받아온 value 값 for문으로 list에 넣어주기
		List<String> check_list = new ArrayList<String>();
	    
	    for(String id : checks) {
	    	check_list.add(id);
	    }
	    
	    // 생략가능 
	    System.out.println("deleteDoc->check_list : " + check_list); // [B0002, B0005, B0006]
	    
	    Map<String, Object> params = new HashMap<String, Object>();
	    // map에 list 넣어주기 [B0002, B0005, B0006]
	   	params.put("checkList", check_list);
	   	
	   	// 자료 삭제 처리
	   	int result = this.docUploadService.deleteDoc(params);
	   	log.info("deleteAjax->result : " + result);
		
		return "success";
	}
	
	// 파일 상세 정보 조회
	@ResponseBody
	@PostMapping("/getFileDetails")
	public List<FileDetailVO> getFileDetails(int fileGroupNo){
		log.info("getFileDetails->fileGroupNo : " + fileGroupNo);
		
		// 파일 그룹 번호에 대한 파일 상세 정보 조회
		List<FileDetailVO> fileDetailVOList = this.docUploadService.getFileDetails(fileGroupNo);
		log.info("getFileDetails->fileDetailVOList : " + fileDetailVOList);
		
		return fileDetailVOList;
	}
	
}
