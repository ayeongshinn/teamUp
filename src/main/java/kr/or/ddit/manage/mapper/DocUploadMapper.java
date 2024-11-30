package kr.or.ddit.manage.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.manage.vo.BoardVO;

public interface DocUploadMapper {
	
	// 자료 게시판 목록 조회
	public List<BoardVO> list(Map<String, Object> map);

	// 자료 게시판 총 게시글 개수 조회
	public int getTotal(Map<String, Object> map);

	// 특정 번호에 따른 게시물 상세 조회
	public BoardVO detail(@Param("bbsNo") String bbsNo);

	// 게시물 등록
	public int registDoc(BoardVO boardVO);

	// 파일 상세 정보 조회
	public List<FileDetailVO> getFileDetails(int fileGroupNo);

	// 게시물 정보 수정
	public int updateDoc(BoardVO boardVO);

	// 게시물 정보 삭제
	public int deleteDoc(Map<String, Object> params);

	// 조회수 증가 처리
	public void increaseInq(String bbsNo);

	// 이전 게시물 조회
	public BoardVO detailPrev(String bbsNo);

	// 다음 게시물 조회
	public BoardVO detailNext(String bbsNo);

}
