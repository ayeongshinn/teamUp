package kr.or.ddit.bsn.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.bsn.vo.CustomerVO;

public interface CustomerMapper {

	/** 고객 목록
	 * 
	 */
	public List<CustomerVO> customerList(Map<String, Object> map);
	
	/** 전체 행의 수
	 * 
	 * @return
	 */
	public int getTotal(Map<String, Object> map);
	
	/** 고객 등록 실행
	 * 
	 * @param customerVO
	 * @return
	 */
	public int registPost(CustomerVO customerVO);
	
	/** 고객 상세조회
	 * 
	 * @param custNo
	 * @return
	 */
	public CustomerVO detail(String custNo);
	
	/** 고객 수정 실행
	 * 
	 * @param customerVO
	 * @return
	 */
	public int updatePost(CustomerVO customerVO);
	
	/** 고객 삭제 실행
	 * 
	 * @param customerVO
	 * @return
	 */
	public int deletePost(String custNo);
	
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
