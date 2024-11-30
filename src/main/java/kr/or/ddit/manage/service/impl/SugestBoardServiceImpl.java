package kr.or.ddit.manage.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.manage.mapper.SugestBoardMapper;
import kr.or.ddit.manage.service.SugestBoardService;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.manage.vo.CommentVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SugestBoardServiceImpl implements SugestBoardService {

	@Inject
	SugestBoardMapper boardMapper;
	
	@Autowired
	UploadController uploadController;
	

	@Override
	public List<BoardVO> list(Map<String,Object> map) {
		// TODO Auto-generated method stub
		log.info("list 서비스임플까지옴");
		
		return this.boardMapper.list(map);
	}

	@Override
	public BoardVO detail(String bbsNo) {
		// TODO Auto-generated method stub
		return this.boardMapper.detail(bbsNo);
	}

	@Override
	public int registPost(BoardVO boardVO) {
		// TODO Auto-generated method stub
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
		
		
		
		result += this.boardMapper.insertBoard(boardVO);
		
		return result;
	}

	@Override
	public BoardVO getBbsNo(BoardVO boardVO) {
		// TODO Auto-generated method stub
		return this.boardMapper.getBbsNo(boardVO);
	}

	@Override
	public int delete(String bbsNo) {
		// TODO Auto-generated method stub
		return this.boardMapper.delete(bbsNo);
	}

	@Override
	public int updatePost(BoardVO boardVO) {
		int result = 0;
		MultipartFile[] multipartFiles = boardVO.getUploadFile();
		
		/*
		 [이미지 삭제]
		 fileDetailVOList에 대상이 들어갈것임 
		 <input type="text" name="fileDetailVOList[0].fileSn" value="1">
		 <input type="text" name="fileDetailVOList[0].fileGroupNo" value="67">
		 */
		List<FileDetailVO> fileDetailVOList = boardVO.getFileDetailVOList();
		for(FileDetailVO fileDetailVO : fileDetailVOList) {
			result += this.boardMapper.deleteImage(fileDetailVO);
		}
		
		
		//0.첨부파일이 있을 때만 1.2.을 수행함
		//multipartFiles[0].getOriginalFilename() : 1개 이상의 첨부파일이라고 하면 첫번째 첨부파일에 접근하여 그 본래 파일명
		//만약, 첨부파일이 없다면, 파일명의 길이는 0이므로 if문을 건너뜀.->noticeV의 fileGroupNo프로퍼티가 비어있게 됨
		if(multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);		
			log.info("updateNotice->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록->groupNo가 새로 생성 (기존 NOTICE_BOARD 테이블의 FILE_GROUP_NO가 새롭게 업로드 된 파일의 번호로 덮어쓰기)
			boardVO.setFileGroupNo(fileGroupNo);		
		}
		log.info("updatePost 서비스임플까지옴");
		return this.boardMapper.updatePost(boardVO);
	}

	@Override
	public List<BoardVO> cagList(Map<String,Object> map) {
		// TODO Auto-generated method stub
		return this.boardMapper.cagList(map);
	}

	@Override
	public int countUp(Map<String, Object>map) {
		// TODO Auto-generated method stub
		return this.boardMapper.countUp(map);
	}

	@Override
	public int getTotal(Map<String,Object> map) {
		// TODO Auto-generated method stub
		return this.boardMapper.getTotal(map);
	}

	@Override
	public int cagGetTotal(String sugestClsfCd) {
		return this.boardMapper.cagGetTotal(sugestClsfCd);
	}

	@Override
	public int registCommentPost(CommentVO commentVO) {
		// TODO Auto-generated method stub
		return this.boardMapper.registCommentPost(commentVO);
	}

	@Override
	public List<CommentVO> listComment(CommentVO commentVO) {
		// TODO Auto-generated method stub
		return this.boardMapper.listComment(commentVO);
	}

	@Override
	public int deleteCommentAjax(CommentVO commentVO) {
		// TODO Auto-generated method stub
		return this.boardMapper.deleteCommentAjax(commentVO);
	}

	@Override
	public int updateCommentAjax(CommentVO commentVO) {
		// TODO Auto-generated method stub
		return this.boardMapper.updateCommentAjax(commentVO);
	}

	@Override
	public BoardVO prevboardDetail(String bbsNo) {
		// TODO Auto-generated method stub
		return this.boardMapper.prevboardDetail(bbsNo);
	}

	@Override
	public BoardVO nextboardDetail(String bbsNo) {
		// TODO Auto-generated method stub
		return this.boardMapper.nextboardDetail(bbsNo);
	}

	@Override
	public List<FileDetailVO> getFileDetails(int fileGroupNo) {
		// TODO Auto-generated method stub
		return this.boardMapper.getFileDetails(fileGroupNo);
	}

	@Override
	public int processSttusCdY(String bbsNo) {
		// TODO Auto-generated method stub
		return this.boardMapper.processSttusCdY(bbsNo);
	}
	
	
	
	
	
}
