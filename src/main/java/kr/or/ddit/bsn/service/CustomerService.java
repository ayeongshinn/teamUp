package kr.or.ddit.bsn.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.bsn.vo.CustomerVO;

public interface CustomerService {
	
	// 고객 리스트
	public List<CustomerVO> customerList(Map<String, Object> map);
	
	// 전체 행의 수
	public int getTotal(Map<String, Object> map);
	
	// 고객 등록 실행
	public int registPost(CustomerVO customerVO);
	
	// 고객 상세조회
	public CustomerVO detail(String custNo);
	
	// 고객 수정 실행
	public int updatePost(CustomerVO customerVO);
	
	// 고객 삭제 실행
	public int deletePost(String custNo);
	
	// 전체 계약 수
	public int ctrtTotal();
	
	// 당월 계약 수
	public int ctrtMonth();
	
	// 전월 계약 수
	public int ctrtBeforeMonth();
	
}
