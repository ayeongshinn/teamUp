package kr.or.ddit.bsn.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.bsn.mapper.BusinessProgressMapper;
import kr.or.ddit.bsn.service.BusinessProgressServie;
import kr.or.ddit.bsn.vo.BusinessProgressVO;

@Service
public class BusinessProgressServiceImpl implements BusinessProgressServie {
	
	@Inject
	BusinessProgressMapper businessProgressMapper;
	
	// 영업 진척도 등록
	@Transactional
	@Override
	public int businessInsert(BusinessProgressVO businessProgressVO) {
		
		return this.businessProgressMapper.businessInsert(businessProgressVO);
	}
	
	// Chart 데이터 조회
	@Override
	public List<BusinessProgressVO> chartDataList() {
		return this.businessProgressMapper.chartDataList();
	}
	
	// 영업 진척도 상세 조회
	@Override
	public BusinessProgressVO businessDetail(String manageNo) {
		return this.businessProgressMapper.businessDetail(manageNo);
	}

	// 영업 진척도 수정 페이지 용
	@Override
	public BusinessProgressVO businessUpdate(String manageNo) {
		return this.businessProgressMapper.businessUpdate(manageNo);
	}

	// 영업 진척도 수정 실행
	@Transactional
	@Override
	public int businessUpdatePost(BusinessProgressVO businessProgressVO) {
		return this.businessProgressMapper.businessUpdatePost(businessProgressVO);
	}
	
	// 영업 진척도 삭제 실행
	@Transactional
	@Override
	public int businessDeletePost(String bsnNm) {
		return this.businessProgressMapper.businessDeletePost(bsnNm);
	}

}
