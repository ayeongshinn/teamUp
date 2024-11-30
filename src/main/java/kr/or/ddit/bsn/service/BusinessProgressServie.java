package kr.or.ddit.bsn.service;

import java.util.List;

import kr.or.ddit.bsn.vo.BusinessProgressVO;

public interface BusinessProgressServie {
	
	// 영업 진척도 등록
	public int businessInsert(BusinessProgressVO businessProgressVO);
	
	// Chart 데이터 조회
	public List<BusinessProgressVO> chartDataList();
	
	// 영업 진척도 상세 조회
	public BusinessProgressVO businessDetail(String manageNo);
	
	// 영업 진척도 수정 페이지용
	public BusinessProgressVO businessUpdate(String manageNo);
	
	// 영업 진척도 수정 실행
	public int businessUpdatePost(BusinessProgressVO businessProgressVO);
	
	// 영업 진척도 삭제 실행
	public int businessDeletePost(String bsnNm);

}
