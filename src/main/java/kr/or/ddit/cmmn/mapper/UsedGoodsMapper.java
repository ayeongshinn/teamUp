package kr.or.ddit.cmmn.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.manage.vo.CommentVO;

public interface UsedGoodsMapper {
	
	// 중고 거래 게시판 리스트
	public List<BoardVO> list(Map<String, Object> map);

	public int getTotal(Map<String, Object> map);

	public int registUsedGoods(BoardVO boardVO);

	public BoardVO getDetail(String bbsNo);

	public EmployeeVO getEmp(String empNo);

	public int replyUgBoard(CommentVO commentVO);

	public List<CommentVO> listUgComment(String bbsNo);

	public int updateComment(@Param("cmntNo") String cmntNo, @Param("cmntCn") String cmntCn);

	public int deleteUgGoods(@Param("bbsNo") String bbsNo);

	public int updateStatus(@Param("bbsNo") String bbsNo);

	public int deleteComment(@Param("cmntNo") String cmntNo);

	public int replyCnt(String bbsNo);

	//판매글 수정 시 이미지 삭제
	public int deleteUgGoodsMulti(Map<String, Object> map);

	//3. 수정할 데이 중 fileGroupNo의 값은 0(null)임(불변)
	public int updataUsedGood(BoardVO boardVO);

}
