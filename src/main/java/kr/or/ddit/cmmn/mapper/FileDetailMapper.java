package kr.or.ddit.cmmn.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.cmmn.vo.FileDetailVO;

@Mapper
public interface FileDetailMapper {

	//sqlSessionTemplate을 안씀
	
	//FILE_DETAIL 테이블에 insert
	public int insertFileDetail(FileDetailVO fileDetailVO);
	/*
	 fileDetailVO[
	 	{fileSn=1,fileGroupNo=1,...},
	 	{fileSn=2,fileGroupNo=1,...}
	 ]
	 */
	public int getFileGroupNo();
	
	public int getFileSn(int fileGroupNo);
}
