package kr.or.ddit.planng.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.planng.vo.NoticeVO;

public interface NoticeService {
	
	//공지 목록 (공통 열람 공지) :: 신아영
	public List<NoticeVO> noticeList(Map<String, Object> map);

	//전체 행의 수 (공통 열람 공지) :: 신아영
	public int getTotalY(Map<String, Object> map);
	
	//조회수 증가 로직(공통 열람 공지)
	public void increaseViewCnt(String ntcNo);
	
	//공지 상세 보기(공통 열람 공지)
	public NoticeVO noticeDetail(String ntcNo);
	
	
	//공지 목록(기획부 열람 공지) :: 신아영
	public List<NoticeVO> noticeListN(Map<String, Object> map);

	//대기 중인 공지사항 수 가져오기(기획부 열람 공지) :: 신아영
	public int getWCnt();
	

	//전체 행의 수(기획부 열람 공지) :: 신아영
	public int getTotalN(Map<String, Object> map);
	
	//공지 등록 처리(기획부 열람 공지) :: 신아영
	public int registNotice(NoticeVO noticeVO);
	
	//공지 상세 보기(기획부 열람 공지) :: 신아영
	public NoticeVO noticeDetailN(String ntcNo);
	
	//공지 상세 보기의 이전 글 조회(기획부 열람 공지) :: 신아영
	public NoticeVO noticeDetailNPrev(String ntcNo);
	
	//공지 상세 보기의 다음 글 조회(기획부 열람 공지) :: 신아영
	public NoticeVO noticeDetailNNxt(String ntcNo);
	
	//사원이 작성한 게시글 수 가져오기(기획부 열람 공지) :: 신아영
	public int getMyNotices(String empNo);
	
	//파일 업로드 :: 신아영
	public List<FileDetailVO> getFileDetails(int fileGroupNo);

	//공지사항 수정(기획부 열람 공지)
	public int updateNotice(NoticeVO noticeVO);
	
	//공지사항 삭제(기획부 열람 공지)
	public int deleteNotice(String ntcNo);
	
	//승인 상태 업데이트
	public int updateAprvStatus(NoticeVO noticeVO);

}
