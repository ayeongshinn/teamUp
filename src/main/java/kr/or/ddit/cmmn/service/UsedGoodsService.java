package kr.or.ddit.cmmn.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.manage.vo.CommentVO;

public interface UsedGoodsService {

	// 중고 거래 게시판 리스트
	public List<BoardVO> list(Map<String, Object> map);

	// 중고 거래 게시물 총 개수
	public int getTotal(Map<String, Object> map);

	// 상품 등록
	public int registUsedGoods(BoardVO boardVO);

	// 게시물 상세
	public BoardVO getDetail(String bbsNo);

	// 직원 정보
	public EmployeeVO getEmp(String empNo);

	// 댓글 등록
	public int replyUgBoard(CommentVO commentVO);

	// 특정 게시물에 대한 댓글 목록
	public List<CommentVO> listUgComment(String bbsNo);

	// 등록 댓글 수정
	public int updateComment(String cmntNo, String cmntCn);

	// 등록 상품 삭제
	public int deleteUgGoods(String bbsNo);

	// 판매 상태 업데이트 (판매중 -> 판매완료)
 	public int updateStatus(String bbsNo);
	
	// 댓글 삭제
	public int deleteComment(String cmntNo);
	
	// 댓글 수 조회
	public int replyCnt(String bbsNo);
	
	//판매글 수정
	public int updataUsedGood(BoardVO boardVO);

	
	

}
