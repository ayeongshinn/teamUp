package kr.or.ddit.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.mapper.UsedGoodsMapper;
import kr.or.ddit.cmmn.service.UsedGoodsService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.BoardVO;
import kr.or.ddit.manage.vo.CommentVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UsedGoodsServiceImpl implements UsedGoodsService {
	
	@Inject
	UsedGoodsMapper usedGoodsMapper;
	
	@Inject
	UploadController uploadController;
	
	// 중고 거래 게시판 리스트
	@Override
	public List<BoardVO> list(Map<String, Object> map) {
		return this.usedGoodsMapper.list(map);
	}


	@Override
	public int getTotal(Map<String, Object> map) {
		return this.usedGoodsMapper.getTotal(map);
	}


	@Override
	public int registUsedGoods(BoardVO boardVO) {
		
		int result = 0;
		
		/*
		BoardVO(rnum=0, rnum2=0, bbsNo=null, bbsTtl=1, empNo=240005, empNm=null, bbsCn=<p>3</p>, regDt=null
		, inqCnt=0, delYn=null, rcritSttusCd=null, delngSttusCd=null, bbsCd=null, sugestClsfCd=null, fileGroupNo=0
		, price=2
		, uploadFile=[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@23c01e34, org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@485f3fd4, org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@76a751a9], 
		fileDetailVOList=null, bbsNoList=null)
		 */
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
		result += this.usedGoodsMapper.registUsedGoods(boardVO);
		
		return result;		
	}
	
	//판매글 수정
	@Override
	public int updataUsedGood(BoardVO boardVO) {
		
		/*
		boardVO : BoardVO(rnum=0, rnum2=0, bbsNo=UG00047, bbsTtl=아 졸리다, empNo=null, empNm=null, bbsCn=<p>졸림</p>, 
		regDt=null, inqCnt=0, delYn=null, rcritSttusCd=null, delngSttusCd=null, bbsCd=null, sugestClsfCd=null,
		 fileGroupNo=96, processSttusCd=null, price=2000, replyCnt=0, 
		 	uploadFile=[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@5978acf0], 
		 fileDetailVOList=null, bbsNoList=null, 
		 	fileSnArr=[1, 2], 
		 	fileGroupNoArr=[96, 96])
		 */
		
		int result = 0;
		
		/* 1. 
		 fileSnArr=[1, 2], 
		 fileGroupNoArr=[96, 96])
		 이 정보를 통해 FILE_DETAIL테이블의 삭제된 이미지를 delete
		 */
		String fileGroupNO = Integer.toString(boardVO.getFileGroupNo());
		if(boardVO.getFileSnArr()!=null) {//삭제할 대상이이지가 있을 때만 실행
			fileGroupNO = boardVO.getFileGroupNoArr()[0];//어차피 하나의 값이므로
			log.info("updataUsedGood->fileGroupNO : " + fileGroupNO);
		
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("fileSnArr", boardVO.getFileSnArr());
			map.put("fileGroupNo", fileGroupNO);//어차피 하나의 값이므로
			result += this.usedGoodsMapper.deleteUgGoodsMulti(map);
		}
		
		//2. uploadFile=[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@5978acf0], 
		// 이 정보와 fileGroupNoArr=[96, 96]) 정보를 통해 파일 업로드 처리 후 FILE_DETAIL 테이블에 insert
		/*
		BoardVO(rnum=0, rnum2=0, bbsNo=null, bbsTtl=1, empNo=240005, empNm=null, bbsCn=<p>3</p>, regDt=null
		, inqCnt=0, delYn=null, rcritSttusCd=null, delngSttusCd=null, bbsCd=null, sugestClsfCd=null, fileGroupNo=0
		, price=2
		, uploadFile=[org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@23c01e34, org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@485f3fd4, org.springframework.web.multipart.support.StandardMultipartHttpServletRequest$StandardMultipartFile@76a751a9], 
		fileDetailVOList=null, bbsNoList=null)
		 */
		MultipartFile[] multipartFiles = boardVO.getUploadFile();
		
		//안전장치.
		//파일이 있을 때만 1.2.를 시행함
		if(multipartFiles!=null && multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUploadSameFileGroupNo(multipartFiles,fileGroupNO);		
			log.info("updataUsedGood->fileGroupNo : " + fileGroupNo);
			
			//3. 데이터 등록은 생략함
//			boardVO.setFileGroupNo(fileGroupNo);		
		}
		
		//3. 수정할 데이 중 fileGroupNo의 값은 0(null)임(불변)
		result += this.usedGoodsMapper.updataUsedGood(boardVO);
		
		return result;		
	}


	@Override
	public BoardVO getDetail(String bbsNo) {
		return this.usedGoodsMapper.getDetail(bbsNo);
	}


	@Override
	public EmployeeVO getEmp(String empNo) {
		return this.usedGoodsMapper.getEmp(empNo);
	}


	@Override
	public int replyUgBoard(CommentVO commentVO) {
		return this.usedGoodsMapper.replyUgBoard(commentVO);
	}


	@Override
	public List<CommentVO> listUgComment(String bbsNo) {
		return this.usedGoodsMapper.listUgComment(bbsNo);
	}


	@Override
	public int updateComment(String cmntNo, String cmntCn) {
		return this.usedGoodsMapper.updateComment(cmntNo, cmntCn);
	}


	@Override
	public int deleteUgGoods(String bbsNo) {
		return this.usedGoodsMapper.deleteUgGoods(bbsNo);
	}


	@Override
	public int updateStatus(String bbsNo) {
		return this.usedGoodsMapper.updateStatus(bbsNo);
	}


	@Override
	public int deleteComment(String cmntNo) {
		return this.usedGoodsMapper.deleteComment(cmntNo);
	}


	@Override
	public int replyCnt(String bbsNo) {
		return this.usedGoodsMapper.replyCnt(bbsNo);
	}

}
