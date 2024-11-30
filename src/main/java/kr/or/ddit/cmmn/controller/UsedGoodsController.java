package kr.or.ddit.cmmn.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.UsedGoodsService;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.service.DocUploadService;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.manage.vo.CommentVO;
import kr.or.ddit.manage.vo.FixturesVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/usedGoods")
public class UsedGoodsController {
	
	@Inject
	UsedGoodsService usedGoodsService;
	
	@Inject
	DocUploadService docUploadService;
	
	@GetMapping("/list")
	public String list(
			Model model,
			@RequestParam(value="gubun",required=false,defaultValue="") String gubun,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
			@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage
			) {
		
		// 검색 조건 및 현재 페이지 map에 설정
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("gubun", gubun);
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		
	    List<BoardVO> ugBoardList = this.usedGoodsService.list(map);
	    log.info("usedGoods / list -> ugBoardList : " + ugBoardList);
	    
	    // 각 게시물의 댓글 수 설정
	    for (BoardVO board : ugBoardList) {
	        int replyCount = usedGoodsService.replyCnt(board.getBbsNo());
	        board.setReplyCnt(replyCount);
	    }
	    	    
	    // 변환된 날짜를 담을 리스트
	    List<Map<String, Object>> formattedList = new ArrayList<>();

	    // 현재 날짜와 regDt 비교하여 형식 변환
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	    for (BoardVO board : ugBoardList) {
	        Map<String, Object> boardMap = new HashMap<>();
	        boardMap.put("board", board); // 기존 board 정보

	        if (board.getRegDt() != null) {
	            long diffInMillies = new Date().getTime() - board.getRegDt().getTime();
	            long diffInHours = TimeUnit.HOURS.convert(diffInMillies, TimeUnit.MILLISECONDS);
	            long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

	            // 오늘 날짜에 올린 게시물이라면 시간 단위로 비교
	            if (diffInDays == 0) {
	                if (diffInHours < 1) {
	                    boardMap.put("formattedRegDt", "방금 전");
	                } else {
	                    boardMap.put("formattedRegDt", diffInHours + "시간 전");
	                }
	            } 
	            // 오늘이 아니면 일 단위로 표시
	            else if (diffInDays <= 31) {
	                boardMap.put("formattedRegDt", diffInDays + "일 전");
	            } else {
	                boardMap.put("formattedRegDt", sdf.format(board.getRegDt()));
	            }
	        } else {
	            boardMap.put("formattedRegDt", "");
	        }
	        
	        formattedList.add(boardMap);
	    }
	    
		// 전체 데이터 개수 조회
		int total = this.usedGoodsService.getTotal(map);
		log.info("usedGoods -> total : " + total);
		
		
		//페이징 처리
		//페이징 처리
		ArticlePage<Map<String, Object>> articlePage = new ArticlePage<Map<String, Object>>(total, currentPage, 12, formattedList, keyword);
		
		if (!ugBoardList.isEmpty()) {
		    BoardVO firstBoardVO = ugBoardList.get(0);
		    if (firstBoardVO.getFileDetailVOList() != null && !firstBoardVO.getFileDetailVOList().isEmpty()) {
		        FileDetailVO firstFileDetailVO = firstBoardVO.getFileDetailVOList().get(0);
		        model.addAttribute("firstFileDetailVO", firstFileDetailVO);
		    }
		}
		
	    // 변환된 리스트를 모델에 담기
	    model.addAttribute("ugBoardList", formattedList);
	    model.addAttribute("articlePage", articlePage);

	    return "cmmn/usedGoods/list";
	}
	
	@GetMapping("registGoods")
	public String registGoods() {
		return "cmmn/usedGoods/registGoods";
	}
	
	@PostMapping("/registUsedGoods")
	@ResponseBody
	public int registUsedGoods(BoardVO boardVO) {
		/*
		BoardVO(rnum=0, rnum2=0, bbsNo=null, bbsTtl=1, empNo=240005, empNm=null, bbsCn=<p>3</p>, regDt=null
		, inqCnt=0, delYn=null, rcritSttusCd=null, delngSttusCd=null, bbsCd=null, sugestClsfCd=null, fileGroupNo=0
		, price=2
		, uploadFile=[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@23c01e34, org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@485f3fd4, org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@76a751a9], 
		fileDetailVOList=null, bbsNoList=null)
		 */
		log.info("UsedGoods -> regist : " + boardVO);
		
		int result = this.usedGoodsService.registUsedGoods(boardVO);
		log.info("UsedGoods -> [regist] result : " + result);
		
		return result;
	}
	
	@GetMapping("/detail")
	public String getDetail(@RequestParam("bbsNo") String bbsNo, Model model) {
	    
	    // 게시물 상세 정보 가져오기
	    BoardVO boardVOList = this.usedGoodsService.getDetail(bbsNo);
	    EmployeeVO empVOList = this.usedGoodsService.getEmp(boardVOList.getEmpNo());
	    
	    // 날짜 변환 로직 추가
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	    String formattedRegDt = "";

	    if (boardVOList.getRegDt() != null) {
	        long diffInMillies = new Date().getTime() - boardVOList.getRegDt().getTime();
	        long diffInHours = TimeUnit.HOURS.convert(diffInMillies, TimeUnit.MILLISECONDS);
	        long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

	        // 오늘 날짜에 올린 게시물이라면 시간 단위로 비교
	        if (diffInDays == 0) {
	            if (diffInHours < 1) {
	                formattedRegDt = "방금 전";
	            } else {
	                formattedRegDt = diffInHours + "시간 전";
	            }
	        } 
	        // 오늘이 아니면 일 단위로 표시
	        else if (diffInDays <= 31) {
	            formattedRegDt = diffInDays + "일 전";
	        } else {
	            formattedRegDt = sdf.format(boardVOList.getRegDt());
	        }
	    }
	    
	    // 조회수 증가
		docUploadService.increaseInq(bbsNo);
		
		// 댓글 수 조회
		int replyCnt = this.usedGoodsService.replyCnt(bbsNo);
		boardVOList.setReplyCnt(replyCnt);
	    
	    List<CommentVO> commentVOList = this.usedGoodsService.listUgComment(bbsNo);
	    log.info("detail -> commentVOList : " + commentVOList);
	    
	    // 변환된 날짜를 모델에 추가
	    model.addAttribute("boardVOList", boardVOList);
	    model.addAttribute("formattedRegDt", formattedRegDt);
	    model.addAttribute("empVOList", empVOList);
	    model.addAttribute("commentVOList", commentVOList);
	    
	    return "cmmn/usedGoods/detailGoods";
	}
	
	@PostMapping("/replyUgBoard")
	public String replyUgBoard(@ModelAttribute CommentVO commentVO) {
		
		log.info("replyUgBoard -> commentVO : " + commentVO);
		
		int result = this.usedGoodsService.replyUgBoard(commentVO);
		log.info("replyUgBoard -> result : " + result);
		
		
		return "redirect:/usedGoods/detail?bbsNo="+commentVO.getBbsNo();
		
	}
	
	@PostMapping("/updateComment")
	@ResponseBody
	public int updateComment(@RequestParam("cmntNo") String cmntNo,
							 @RequestParam("cmntCn") String cmntCn) {
		
		int result = this.usedGoodsService.updateComment(cmntNo,cmntCn);
		log.info("updateComment -> result" + result);
		
		return result;
	}
	
	@GetMapping("/editGoods")
	public String editGoods(@RequestParam("bbsNo") String bbsNo, Model model) {
		log.info("⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕⭕👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉👉editUgBoard -> bbsNo : " + bbsNo);
		
	    BoardVO boardVOList = this.usedGoodsService.getDetail(bbsNo);
	    
	    model.addAttribute("boardVOList", boardVOList);
	    
	    return "cmmn/usedGoods/editGoods";
		
	}
	
	@PostMapping("/deleteUgGoods")
	@ResponseBody
	public String deleteUgGoods(@RequestParam("bbsNo") String bbsNo) {
		
		int result = this.usedGoodsService.deleteUgGoods(bbsNo);
		log.info("deleteUgBoard -> result : " + result);
		
		return "success";
	}
	
	@PostMapping("/updateStatus")
	@ResponseBody
	public String updateStatus(@RequestParam("bbsNo") String bbsNo) {
		
		int result = this.usedGoodsService.updateStatus(bbsNo);
		
		return "success";
	}
	
	@PostMapping("/replyToComment")
	public String replyToComment(@ModelAttribute CommentVO commentVO) {
		log.info("replyToComment -> commentVO : " + commentVO);
		
		int result = this.usedGoodsService.replyUgBoard(commentVO);
		log.info("replyToComment -> result : " + result);
		
		return "redirect:/usedGoods/detail?bbsNo="+commentVO.getBbsNo();
	}
	
	@PostMapping("/deleteComment")
	@ResponseBody
	public String deleteComment(@RequestParam("cmntNo") String cmntNo,
								@RequestParam("bbsNo") String bbsNo) {
		log.info("삭제다 삭제다 삭제 👉🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨 cmntNo : " + cmntNo);
		
		int result = this.usedGoodsService.deleteComment(cmntNo);
		
		return "redirect:/usedGoods/detail?bbsNo="+bbsNo;
	}
	
	//* * * * * -> * *
//	/usedGoods/editGoods?bbsNo=UG00047
	//신규파일 : 파일객체가 넘어옴(uploadFile..)
	//기존파일 : fileSnArr와 fileGroupNoArr이 넘어옴
	@PostMapping("/updateUsedGoods")
	@ResponseBody
	public String updataUsedGood(BoardVO boardVO) {
		/*
		boardVO : BoardVO(rnum=0, rnum2=0, bbsNo=UG00047, bbsTtl=아 졸리다, empNo=null, empNm=null, bbsCn=<p>졸림</p>, 
		regDt=null, inqCnt=0, delYn=null, rcritSttusCd=null, delngSttusCd=null, bbsCd=null, sugestClsfCd=null,
		 fileGroupNo=96, processSttusCd=null, price=2000, replyCnt=0, 
		 	uploadFile=[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@5978acf0], 
		 fileDetailVOList=null, bbsNoList=null, 
		 	fileSnArr=[1, 2], 
		 	fileGroupNoArr=[96, 96])
		 */
		log.info("updateUsedGood->boardVO : " + boardVO);
		
		int result = this.usedGoodsService.updataUsedGood(boardVO);
		log.info("updataUsedGood -> result : " + result);
		
		return "success";
	}

	
}
