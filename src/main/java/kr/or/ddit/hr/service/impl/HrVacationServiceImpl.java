package kr.or.ddit.hr.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.hr.mapper.HrVacationMapper;
import kr.or.ddit.hr.service.HrVacationService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrMovementDocVO;
import kr.or.ddit.hr.vo.HrVacationVO;

/** 휴가(VACATION) ServiceImpl
 * 
 * @author 장영원
 */
@Service
public class HrVacationServiceImpl implements HrVacationService {
	
	@Inject
	HrVacationMapper hrVacationMapper;
	
	//인사 -> 사원 휴가 리스트 조회
	@Override
	public List<HrVacationVO> list(Map<String, Object> map) {
		return hrVacationMapper.list(map);
	}
	
	//페이징 처리 -> 리스트 총 개수
	@Override
	public int getTotal(Map<String, Object> map) {
		return hrVacationMapper.getTotal(map);
	}

	@Override
	public List<HrVacationVO> getSortedVcatDay(String order) {
		return hrVacationMapper.getSortedVcatDay(order);
	}

	//특정 사원의 휴가 최신 데이터 조회
	@Override
	public HrVacationVO lastVcatnDetail(String empNo) {
		return hrVacationMapper.lastVcatnDetail(empNo);
	}
	
	//특정 사원 휴가 추가 부여
	@Override
	public int grantVacation(Map<String, Object> map) {
		return hrVacationMapper.grantVacation(map);
	}
	
	//현재 기준, 휴가가 많이 남은 사원
	@Override
	public List<HrVacationVO> holdVcatnTop3() {
		return hrVacationMapper.holdVcatnTop3();
	}

}
