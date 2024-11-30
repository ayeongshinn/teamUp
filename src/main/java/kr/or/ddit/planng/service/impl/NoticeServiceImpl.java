package kr.or.ddit.planng.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.planng.mapper.NoticeMapper;
import kr.or.ddit.planng.service.NoticeService;
import kr.or.ddit.planng.vo.NoticeVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NoticeServiceImpl implements NoticeService {
	
	@Autowired
	NoticeMapper noticeMapper;
	
	@Inject
	UploadController uploadController;
	
	//파일 상세 :: 신아영
	@Override
	public List<FileDetailVO> getFileDetails(int fileGroupNo) {
		return this.noticeMapper.getFileDetails(fileGroupNo);
	}
	
	//공지 목록(전체 열람 공지) :: 신아영
	@Override
	public List<NoticeVO> noticeList(Map<String, Object> map) {
		return this.noticeMapper.noticeList(map);
	}

	//전체 행의 수(전체 열람 공지) :: 신아영
	@Override
	public int getTotalY(Map<String, Object> map) {
		return this.noticeMapper.getTotalY(map);
	}

	
	
	
	//공지 목록(기획부 열람 공지) :: 신아영
	@Override
	public List<NoticeVO> noticeListN(Map<String, Object> map) {
		return this.noticeMapper.noticeListN(map);
	}
	
	//전체 행의 수(기획부 열람 공지) :: 신아영
	@Override
	public int getTotalN(Map<String, Object> map) {
		return this.noticeMapper.getTotalN(map);
	}

	//대기 중인 공지사항수(기획부 열람 공지) :: 신아영
	@Override
	public int getWCnt() {
		return this.noticeMapper.getWCnt();
	}
	
	//사원이 작성한 게시글 수 가져오기 :: 신아영
	@Override
	public int getMyNotices(String empNo) {
		return this.noticeMapper.getMyNotices(empNo);
	}
	
	//공지 등록 처리(기획부 열람 공지) :: 신아영
	@Override
	public int registNotice(NoticeVO noticeVO) {

		int result = 0;
		MultipartFile[] multipartFiles = noticeVO.getUploadFile();
		
		//0.첨부파일이 있을 때만 1.2.을 수행함
		//multipartFiles[0].getOriginalFilename() : 1개 이상의 첨부파일이라고 하면 첫번째 첨부파일에 접근하여 그 본래 파일명
		//만약, 첨부파일이 없다면, 파일명의 길이는 0이므로 if문을 건너뜀.->noticeV의 fileGroupNo프로퍼티가 비어있게 됨
		if(multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);	
			//registPost->fileGroupNo : 48
			log.info("registPost->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록
			noticeVO.setFileGroupNo(fileGroupNo);		
		}
		
		log.info("registPost->noticeVO : " + noticeVO);
		result += this.noticeMapper.registNotice(noticeVO);
		
		return result;
	}
	
	//공지 수정 처리(기획부 열람 공지) :: 신아영
	@Override
	public int updateNotice(NoticeVO noticeVO) {
		
		 int result = 0;
	    
	    // 파일 삭제 처리
	    List<FileDetailVO> fileDetailVOList = noticeVO.getFileDetailVOList();
	    if (fileDetailVOList != null && !fileDetailVOList.isEmpty()) {
	        for (FileDetailVO fileDetailVO : fileDetailVOList) {
	            result += this.noticeMapper.deleteImage(fileDetailVO);
	        }
	    }

	    // 첨부파일 처리 로직
	    MultipartFile[] multipartFiles = noticeVO.getUploadFile();
	    if (multipartFiles != null && multipartFiles.length > 0 && multipartFiles[0].getOriginalFilename().length() > 0) {
	        // 1. 첨부파일 업로드
	        int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);        
	        log.info("updateNotice->fileGroupNo : " + fileGroupNo);
	        
	        // 2. 새 파일 그룹 번호 설정
	        noticeVO.setFileGroupNo(fileGroupNo);
	    }

	    // fileGroupNo가 없을 때 기본값 설정 또는 생략 가능
	    if (noticeVO.getFileGroupNo() == 0) {
	        log.info("fileGroupNo 값이 없으므로 파일 그룹 업데이트를 생략합니다.");
	    }

	    log.info("updateNotice->noticeVO : " + noticeVO);
	    
	    // 공지사항 업데이트
	    result += this.noticeMapper.updateNotice(noticeVO);
		
		return result;
	}

	//공지 상세 보기(기획부 열람 공지) :: 신아영
	@Override
	public NoticeVO noticeDetailN(String ntcNo) {
		return this.noticeMapper.noticeDetailN(ntcNo);
	}
	
	//공지 상세 보기의 이전 글 조회(기획부 열람 공지) :: 신아영
	@Override
	public NoticeVO noticeDetailNPrev(String ntcNo) {
		return this.noticeMapper.noticeDetailNPrev(ntcNo);
	}
	
	//공지 상세 보기의 다음 글 조회(기획부 열람 공지)
	@Override
	public NoticeVO noticeDetailNNxt(String ntcNo) {
		return this.noticeMapper.noticeDetailNNxt(ntcNo);
	}

	//공지사항 삭제
	@Override
	public int deleteNotice(String ntcNo) {
		return this.noticeMapper.deleteNotice(ntcNo);
	}
	
	//조회수 증가 로직
	@Override
	public void increaseViewCnt(String ntcNo) {
		this.noticeMapper.increaseViewCnt(ntcNo);
	}
	
	//공지 상세 정보(공통 열람 공지)
	@Override
	public NoticeVO noticeDetail(String ntcNo) {
		return this.noticeMapper.noticeDetail(ntcNo);
	}
	
	//승인 상태 업데이트
	@Override
	public int updateAprvStatus(NoticeVO noticeVO) {
		return this.noticeMapper.updateAprvStatus(noticeVO);
	}
	
}
