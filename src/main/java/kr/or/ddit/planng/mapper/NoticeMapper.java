package kr.or.ddit.planng.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.planng.vo.NoticeVO;

@Mapper
public interface NoticeMapper {
	
	//공지 목록(전체 열람 공지) :: 신아영
	public List<NoticeVO> noticeList(Map<String, Object> map);
	
	//전체 행의 수(전체 열람 공지) :: 신아영
	public int getTotalY(Map<String, Object> map);
	
	//조회수 증가 로직(전체 열람 공지) :: 신아영
	public void increaseViewCnt(String ntcNo);

	//공지 상세 보기(전체 열람 공지) :: 신아영
	public NoticeVO noticeDetail(String ntcNo);
	
	
	
	
	//공지 목록(기획부 열람 공지) :: 신아영
	public List<NoticeVO> noticeListN(Map<String, Object> map);
	
	//전체 행의 수(기획부 열람 공지) :: 신아영
	public int getTotalN(Map<String, Object> map);
	
	//대기 중인 공지사항 수(기획부 열람 공지) :: 신아영
	public int getWCnt();
	
	//사원이 작성한 게시글 수 가져오기(기획부 열람 공지) :: 신아영
	public int getMyNotices(String empNo);
	
	//공지 등록 처리(기획부 열람 공지) :: 신아영
	public int registNotice(NoticeVO noticeVO);

	//공지 상세 보기(기획부 열람 공지) :: 신아영
	public NoticeVO noticeDetailN(String ntcNo);
	
	//공지 상세 보기의 이전 글 조회(기획부 열람 공지) :: 신아영
	public NoticeVO noticeDetailNPrev(String ntcNo);
	
	//공지 상세 보기의 다음 글 조회(기획부 열람 공지) :: 신아영
	public NoticeVO noticeDetailNNxt(String ntcNo);
	
	//파일 상세 :: 신아영
	public List<FileDetailVO> getFileDetails(int fileGroupNo);

	//공지사항 수정 처리
	public int updateNotice(NoticeVO noticeVO);
	
	//공지사항 삭제
	public int deleteNotice(String ntcNo);
	
	//승인 상태 업데이트
	public int updateAprvStatus(NoticeVO noticeVO);

	//이미지 삭제 
	public int deleteImage(FileDetailVO fileDetailVO);
	
}
