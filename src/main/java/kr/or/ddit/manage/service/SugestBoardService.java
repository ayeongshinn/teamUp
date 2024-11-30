package kr.or.ddit.manage.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.manage.vo.CommentVO;


public interface SugestBoardService {

	public List<BoardVO> list(Map<String, Object> map);

	public BoardVO detail(String bbsNo);

	public int registPost(BoardVO boardVO);

	public BoardVO getBbsNo(BoardVO boardVO);

	public int delete(String bbsNo);

	public int updatePost(BoardVO boardVO);

	public List<BoardVO> cagList(Map<String,Object> map);

	public int countUp(Map<String, Object>map);
	
	public int getTotal(Map<String,Object> map);

	public int cagGetTotal(String sugestClsfCd);

	public int registCommentPost(CommentVO commentVO);

	public List<CommentVO> listComment(CommentVO commentVO);

	public int deleteCommentAjax(CommentVO commentVO);

	public int updateCommentAjax(CommentVO commentVO);

	public BoardVO prevboardDetail(String bbsNo);

	public BoardVO nextboardDetail(String bbsNo);

	public List<FileDetailVO> getFileDetails(int fileGroupNo);

	public int processSttusCdY(String bbsNo);
	
}
