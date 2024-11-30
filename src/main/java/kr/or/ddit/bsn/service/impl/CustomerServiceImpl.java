package kr.or.ddit.bsn.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.bsn.mapper.CustomerMapper;
import kr.or.ddit.bsn.service.CustomerService;
import kr.or.ddit.bsn.vo.CustomerVO;

@Service
public class CustomerServiceImpl implements CustomerService {

	@Inject
	CustomerMapper customerMapper;
	
	// 고객 리스트
	@Override
	public List<CustomerVO> customerList(Map<String, Object> map) {
		
		return this.customerMapper.customerList(map);
	}
	
	// 전체 행의 수
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.customerMapper.getTotal(map);
	}
	
	// 고객 등록 실행
	@Override
	public int registPost(CustomerVO customerVO) {
		return this.customerMapper.registPost(customerVO);
	}
	
	// 고객 상세조회
	@Override
	public CustomerVO detail(String custNo) {
		return this.customerMapper.detail(custNo);
	}
	
	// 고객 수정 실행
	@Override
	public int updatePost(CustomerVO customerVO) {
		return this.customerMapper.updatePost(customerVO);
	}
	
	
	// 고객 삭제 실행
	@Override
	public int deletePost(String custNo) {
		return this.customerMapper.deletePost(custNo);
	}
	
	// 전체 계약 수
	@Override
	public int ctrtTotal() {
		return this.customerMapper.ctrtTotal();
	}
	
	// 당월 계약 수
	@Override
	public int ctrtMonth() {
		return this.customerMapper.ctrtMonth();
	}
	
	// 전월 계약 수
	@Override
	public int ctrtBeforeMonth() {
		return this.customerMapper.ctrtBeforeMonth();
	}

}
