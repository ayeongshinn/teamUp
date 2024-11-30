package kr.or.ddit.hr.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrMovementDocVO;
import kr.or.ddit.hr.vo.HrVacationVO;


/** 휴가(VACATION) Mapper
 * 
 * @author 장영원
 */
public interface HrVacationMapper {

	//인사 -> 사원 휴가 리스트 조회
	public List<HrVacationVO> list(Map<String, Object> map);
	
	//페이징 처리 -> 리스트 총 개수
	public int getTotal(Map<String, Object> map);
	
	//보유 휴가 정렬 이벤트
	public List<HrVacationVO> getSortedVcatDay(String order);
	
	//특정 사원 휴가 최신화 데이터 조회
	public HrVacationVO lastVcatnDetail(String empNo);
	
	//특정 사원 휴가 추가 부여
	public int grantVacation(Map<String, Object> map);
	
	//현재 기준, 휴가가 많이 남은 사원
	public List<HrVacationVO> holdVcatnTop3();
}
