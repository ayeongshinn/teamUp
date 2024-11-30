package kr.or.ddit.mngmt.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.mngmt.mapper.MnHomeMapper;
import kr.or.ddit.mngmt.service.MnHomeService;

@Service
public class MnHomeServiceImpl implements MnHomeService {
	
	@Inject
	MnHomeMapper mnHomeMapper;
	
	//인사 -> 사원 휴가 리스트 조회
	@Override
	public List<HrVacationVO> list(Map<String, Object> map) {
		return mnHomeMapper.list(map);
	}
	
	//페이징 처리 -> 리스트 총 개수
	@Override
	public int getTotal(Map<String, Object> map) {
		return mnHomeMapper.getTotal(map);
	}

}
