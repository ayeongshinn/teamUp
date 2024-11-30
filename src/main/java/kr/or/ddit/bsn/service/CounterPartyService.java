package kr.or.ddit.bsn.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.bsn.vo.CounterPartyVO;

public interface CounterPartyService {
	
	// 거래처 리스트
	public List<CounterPartyVO> counterPartyList(Map<String, Object> map);
	
	// 전체 행의 수
	public int getTotal(Map<String, Object> map);
	
	// 거래처 등록 실행
	public int registPost(CounterPartyVO counterPartyVO);
	
	// 업종명 리스트
	public List<CounterPartyVO> indutynmList();
	
	// 거래처 상세조회
	public CounterPartyVO detail(String cnptNo);
	
	// 거래처 수정 실행
	public int updateCounterParty(CounterPartyVO counterPartyVO);
	
	// 거래처 삭제 실행
	public int deletePost(String cnptNo);
	
	// 전체 계약 수
	public int ctrtTotal();
	
	// 당월 계약 수
	public int ctrtMonth();
	
	// 전월 계약 수
	public int ctrtBeforeMonth();
	
	
}
