package kr.or.ddit.manage.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.manage.mapper.DocUploadMapper;
import kr.or.ddit.manage.service.DocUploadService;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DocUploadServiceImpl implements DocUploadService {
	
	@Inject
	DocUploadMapper docUploadMapper;
	
	@Inject
	UploadController uploadController;
	
	// 자료실 전체 리스트 조회
	@Override
	public List<BoardVO> list(Map<String, Object> map) {
		log.info("serviceImpl 왔다");
		return this.docUploadMapper.list(map);
	}
	
	// 자료실 전체 데이터 개수 조회
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.docUploadMapper.getTotal(map);
	}
	
	
	// 특정 자료(BBS_NO)에 대한 상세 조회
	@Override
	public BoardVO detail(String bbsNo) {
		return this.docUploadMapper.detail(bbsNo);
	}
	
	// 자료 등록
	@Override
	public int registDoc(BoardVO boardVO) {
		
		int result = 0;
		MultipartFile[] multipartFiles = boardVO.getUploadFile();
		
		//0.첨부파일이 있을 때만 1.2.을 수행함
		//multipartFiles[0].getOriginalFilename() : 1개 이상의 첨부파일이라고 하면 첫번째 첨부파일에 접근하여 그 본래 파일명
		//만약, 첨부파일이 없다면, 파일명의 길이는 0이므로 if문을 건너뜀.->noticeV의 fileGroupNo프로퍼티가 비어있게 됨
		if(multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);	
			//registPost->fileGroupNo : 48
			log.info("registPost->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록
			boardVO.setFileGroupNo(fileGroupNo);		
		}
		
		log.info("registDoc->boardVO : " + boardVO);
		result += this.docUploadMapper.registDoc(boardVO);
		
		return result;
	}
	
	// 파일 상세 정보 조회
	@Override
	public List<FileDetailVO> getFileDetails(int fileGroupNo) {
		return this.docUploadMapper.getFileDetails(fileGroupNo);
	}

	// 자료 수정
	@Override
	public int updateDoc(BoardVO boardVO) {
		
		int result = 0;
		
		MultipartFile[] multipartFiles = boardVO.getUploadFile();
		
		//안전장치.
		//파일이 있을 때만 1.2.를 시행함
		if(multipartFiles!=null && multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);		
			log.info("registPost->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록
			boardVO.setFileGroupNo(fileGroupNo);		
		}
		
		//수정할 데이 중 파일이 없다면 fileGroupNo의 값은 0(null)임
		result += this.docUploadMapper.updateDoc(boardVO);
		
		return result;
	}

	// 자료 삭제
	@Override
	public int deleteDoc(Map<String, Object> params) {
		return this.docUploadMapper.deleteDoc(params);
	}
		
	// 조회수 증가
	@Override
	public void increaseInq(String bbsNo) {
		this.docUploadMapper.increaseInq(bbsNo);
		
	}
	
	// 이전 게시물 조회
	@Override
	public BoardVO detailPrev(String bbsNo) {
		return this.docUploadMapper.detailPrev(bbsNo);
	}

	// 다음 게시물 조회
	@Override
	public BoardVO detailNext(String bbsNo) {
		return this.docUploadMapper.detailNext(bbsNo);
	}

}
