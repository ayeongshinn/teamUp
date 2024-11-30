package kr.or.ddit.mngmt.service;

import java.util.List;
import java.util.Map;
import kr.or.ddit.hr.vo.HrVacationVO;

public interface MnHomeService {
	
	//인사 -> 사원 휴가 리스트 조회
	public List<HrVacationVO> list(Map<String, Object> map);
	
	//페이징 처리 -> 리스트 총 개수
	public int getTotal(Map<String, Object> map);
}
