package kr.or.ddit.mngmt.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.hr.vo.HrVacationVO;

public interface MnHomeMapper {
	
	//인사
	//인사 -> 사원 휴가 리스트 조회
	public List<HrVacationVO> list(Map<String, Object> map);
	public int getTotal(Map<String, Object> map);

}
