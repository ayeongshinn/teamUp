package kr.or.ddit.bsn.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.bsn.vo.CounterPartyVO;

public interface CounterPartyMapper {

	/** 거래처 목록
	 * 
	 */
	public List<CounterPartyVO> counterPartyList(Map<String, Object> map);
	
	/** 전체 행의 수
	 * 
	 * @return
	 */
	public int getTotal(Map<String, Object> map);
	
	/** 거래처 등록 실행
	 * 
	 * @param counterPartyVO
	 * @return
	 */
	public int registPost(CounterPartyVO counterPartyVO);
	
	/** 거래처 상세조회
	 * 
	 * @param custNum
	 * @return
	 */
	public CounterPartyVO detail(String cnptNo);
	
	/** 거래처 수정 실행
	 * 
	 * @param counterPartyVO
	 * @return
	 */
    public int updateCounterParty(CounterPartyVO counterPartyVO);
	
	/** 거래처 삭제 실행
	 * 
	 * @param counterPartyVO
	 * @return
	 */
	public int deletePost(String cnptNo);
	
	
	/** 업종명 리스트
	 * 
	 * @return
	 */
	public List<CounterPartyVO> indutynmList();
	
	/** 전체 계약 수
	 * 
	 */
	public int ctrtTotal();
	
	/** 당월 계약 수
	 * 
	 * @return
	 */
	public int ctrtMonth();
	
	/** 전월 계약 수
	 * 
	 * @return
	 */
	public int ctrtBeforeMonth();
	
}
