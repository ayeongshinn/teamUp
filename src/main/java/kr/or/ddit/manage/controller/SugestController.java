package kr.or.ddit.manage.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.mapper.EmployeeMapper;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.service.SugestBoardService;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.manage.vo.CommentVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/manage/sugest")
@Slf4j
@Controller
public class SugestController {

	@Inject
	SugestBoardService boardService;
	
	// 사원
	//DI(의존성 주입)
	@Autowired
	EmployeeMapper employeeMapper;

	@GetMapping("/list")
	public String list(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			  @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			  @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			  @RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			  @RequestParam(value = "endDate", required = false, defaultValue = "") String endDate
			
			) {
		log.info("list컨트롤러 왔당 ");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		List<BoardVO> boardVOList = this.boardService.list(map);
		log.info("list->boardVOList : " + boardVOList);

		int total = this.boardService.getTotal(map);
		model.addAttribute("boardVOList", boardVOList);
		
		ArticlePage<BoardVO> articlePage = 
				new ArticlePage<BoardVO>(total, currentPage, 10, boardVOList, keyword);
		
		model.addAttribute("articlePage", articlePage);

		return "manage/sugest/list";

	}
	
	@GetMapping("/cagList")
	public String cagList(@RequestParam(value = "sugestClsfCd",required = true) String sugestClsfCd,Model model,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword) {
		log.info("cagList컨트롤러 왔당 ");
		log.info(sugestClsfCd);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		map.put("sugestClsfCd", sugestClsfCd);
		map.put("keyword", keyword);
		
		List<BoardVO> boardVOList = this.boardService.cagList(map);
		log.info("cagList->boardVOList : " + boardVOList);

		//카테고리 별 전체 행 수
		int total = this.boardService.cagGetTotal(sugestClsfCd);
		log.info("cagList->total : " + total);
		
		ArticlePage<BoardVO> articlePage = 
				new ArticlePage<BoardVO>(total, currentPage, 10, boardVOList, keyword);
		
		model.addAttribute("boardVOList", boardVOList);
		model.addAttribute("articlePage", articlePage);

		return "manage/sugest/list";

	}
	

	
	@GetMapping("/detail")
	public String detail(@RequestParam(value = "bbsNo", required = true) String bbsNo, Model model,Principal principal) {
		//조회수 올리기
		String empNo = principal.getName();
		
		Map<String, Object>map=new HashMap<String, Object>();
		map.put("bbsNo", bbsNo);
		map.put("empNo", empNo);
		
		
		int result=this.boardService.countUp(map);
		
		BoardVO boardVO = this.boardService.detail(bbsNo);
		log.info("detail->boardVO : " + boardVO);
		BoardVO prevboardVO = this.boardService.prevboardDetail(bbsNo);
		BoardVO nextboardVO = this.boardService.nextboardDetail(bbsNo);
		List<FileDetailVO> fileVOList=this.boardService.getFileDetails(boardVO.getFileGroupNo());
		List<FileDetailVO> prevbFileVOList=this.boardService.getFileDetails(prevboardVO.getFileGroupNo());
//		List<FileDetailVO> nextbFileVOList=this.boardService.getFileDetails(nextboardVO.getFileGroupNo());
		
		
		model.addAttribute("fileVOList", fileVOList);
		model.addAttribute("fileVOList", fileVOList);
		model.addAttribute("fileVOList", fileVOList);
		model.addAttribute("boardVO", boardVO);
		model.addAttribute("prevboardVO", prevboardVO);
		model.addAttribute("nextboardVO", nextboardVO);
		log.info("detail->prevboardVO : " + prevboardVO);
		log.info("detail->nextboardVO : " + nextboardVO);
//		
		CommentVO commentVO =new CommentVO();
		commentVO.setBbsNo(bbsNo);
		List<CommentVO> commentVOList=this.boardService.listComment(commentVO);
		log.info("뎃글까지 완료");
		log.info("detail->commentVOList : " + commentVOList);
		model.addAttribute("commentVOList",commentVOList);

		return "manage/sugest/detail";
	}

	@GetMapping("/regist")
	public String re(Model model, @ModelAttribute BoardVO boardVO) {

		return "manage/sugest/regist";
	}
	
	
	@PostMapping("/registPost")
	public String registPost(@ModelAttribute @Validated BoardVO boardVO,Model model,
			@RequestParam("uploadFile") MultipartFile[] uploadFile) { 
		
		int result=this.boardService.registPost(boardVO);
		log.info("registPost->boardVO : " + boardVO);
		
		BoardVO boardVO2 =this.boardService.getBbsNo(boardVO);
		
		log.info("registPost->boardVO2 : " + boardVO2);
		
		
		return "redirect:/manage/sugest/detail?bbsNo="+boardVO2.getBbsNo();
		
	}
	
	@GetMapping("/deletePost")
	public String deletePost(@RequestParam(value = "bbsNo", required = true) String bbsNo) {
		
		log.info("deletePost도착");
		
		log.info("deletePost->bbsNo : " + bbsNo);
		
		int result = this.boardService.delete(bbsNo);
		
		return "redirect:/manage/sugest/list";
		
	}
	
	@GetMapping("/processSttusCdY")
	public String processSttusCdY(@RequestParam(value = "bbsNo", required = true) String bbsNo) {
		
		log.info("processSttusCdY도착");
		
		int result = this.boardService.processSttusCdY(bbsNo);
		
		return "redirect:/manage/sugest/detail?bbsNo="+bbsNo;
		
	}
	@GetMapping("/SgBoardDelPost")
	public String SgBoardDelPost(
			@RequestParam(value = "groupList", required = true) String groupList) {
		
		log.info("SgBoardDelPost도착");
		
		
		String[] bbsNoList = groupList.split(",");
		
        

		int result=0;
		for(int i=0; i < bbsNoList.length; i++){
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("bbsNo", bbsNoList[i]);
			
			result = this.boardService.delete(bbsNoList[i]);
			
		}
		
		
		
		
		return "redirect:/manage/sugest/list";
		
	}
	
	@PostMapping("/updatePost")
	public String updatePost(@ModelAttribute @Validated BoardVO boardVO,Model model) { 
		
		log.info("updatePost도착");
		log.info("updatePost->boardVO : " + boardVO);
		int result=this.boardService.updatePost(boardVO);
		
		
		
		return "redirect:/manage/sugest/detail?bbsNo="+boardVO.getBbsNo();
		
	}
	
	@PostMapping("/registCommentPost")
	public String registCommentPost(@ModelAttribute @Validated CommentVO commentVO,Model model) { 
		
		
		log.info("registCommentPost->commentVO : " + commentVO);
		
		int result=this.boardService.registCommentPost(commentVO);
		
		//댓글 목록 가져오기
		
		
		
		return "redirect:/manage/sugest/detail?bbsNo="+commentVO.getBbsNo();
		
	}
	
	@ResponseBody
	@PostMapping("/deleteCommentAjax")
	public List<CommentVO> deleteCommentAjax(CommentVO commentVO){
		 log.info("deleteCommentAjax->commentVO : " + commentVO);
		 
		 int result =this.boardService.deleteCommentAjax(commentVO);
		 
		 List<CommentVO> commentVOList=this.boardService.listComment(commentVO);
		 
		 return commentVOList;
		
	}
	
	@ResponseBody
	@PostMapping("/updateCommentAjax")
	public List<CommentVO> updateCommentAjax(@RequestBody CommentVO commentVO, Model model) {
		
		int result =this.boardService.updateCommentAjax(commentVO);
		
		List<CommentVO> commentVOList=this.boardService.listComment(commentVO);
		
		
		return commentVOList;
	}
	
	@ResponseBody
	@PostMapping("/getFileDetails")
	public List<FileDetailVO> getFileDetails(int fileGroupNo){
		log.info("getFileDetails->fileGroupNo : " + fileGroupNo);
			
		List<FileDetailVO> fileDetailVOList = this.boardService.getFileDetails(fileGroupNo);
		log.info("getFileDetails->fileDetailVOList : " + fileDetailVOList);
			
		return fileDetailVOList;
	}
	

}
