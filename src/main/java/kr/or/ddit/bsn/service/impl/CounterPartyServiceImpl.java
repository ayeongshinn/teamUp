package kr.or.ddit.bsn.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.bsn.mapper.CounterPartyMapper;
import kr.or.ddit.bsn.service.CounterPartyService;
import kr.or.ddit.bsn.vo.CounterPartyVO;

@Service
public class CounterPartyServiceImpl implements CounterPartyService {

	@Inject
	CounterPartyMapper counterPartyMapper;
	
	// 거래처 리스트
	@Override
	public List<CounterPartyVO> counterPartyList(Map<String, Object> map) {
		
		return this.counterPartyMapper.counterPartyList(map);
	}
	
	// 전체 행의 수
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.counterPartyMapper.getTotal(map);
	}
	
	// 거래처 등록 실행
	@Override
	public int registPost(CounterPartyVO counterPartyVO) {
		return this.counterPartyMapper.registPost(counterPartyVO);
	}
	
	// 거래처 상세조회
	@Override
	public CounterPartyVO detail(String cnptNo) {
		return this.counterPartyMapper.detail(cnptNo);
	}
	
	// 거래처 수정 실행
    @Override
    public int updateCounterParty(CounterPartyVO counterPartyVO) {
        return counterPartyMapper.updateCounterParty(counterPartyVO);
    }
	
	
	// 거래처 삭제 실행
	@Override
	public int deletePost(String cnptNo) {
	    return counterPartyMapper.deletePost(cnptNo);  // cnptNo에 해당하는 거래처 삭제
	}
	
	// 업종명 리스트
	@Override
	public List<CounterPartyVO> indutynmList() {
		return this.counterPartyMapper.indutynmList();
	}
	
	// 전체 계약 수
	@Override
	public int ctrtTotal() {
		return this.counterPartyMapper.ctrtTotal();
	}
	
	// 당월 계약 수
	@Override
	public int ctrtMonth() {
		return this.counterPartyMapper.ctrtMonth();
	}
	
	// 전월 계약 수
	@Override
	public int ctrtBeforeMonth() {
		return this.counterPartyMapper.ctrtBeforeMonth();
	}
	

}
