package kr.or.ddit.manage.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.mapper.FixturesUseDocMapper;
import kr.or.ddit.manage.service.FixturesUseDocService;
import kr.or.ddit.manage.vo.CarUseDocVO;
import kr.or.ddit.manage.vo.FixturesUseDocVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class fixturesUseDocServiceImpl implements FixturesUseDocService {
	
	@Inject
	FixturesUseDocMapper fixturesUseDocMapper;
	
	// 자동 완성 기능을 위한 데이터 조회
	@Override
	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap) {
		String fxtrsNm = (String) paramMap.get("fxtrsNm");
		paramMap.put("fxtrsNm", fxtrsNm + "%");
		return this.fixturesUseDocMapper.autocomplete(paramMap);
	}

	// 비품 사용 신청서 등록
	@Override
	public int fixRegist(FixturesUseDocVO fixturesUseDocVO) {
		return this.fixturesUseDocMapper.fixRegist(fixturesUseDocVO);
	}

	// 직원 정보 조회
	@Override
	public EmployeeVO getEmpInfo(String empNo) {
		return this.fixturesUseDocMapper.getEmpInfo(empNo);
	}

	// 차량 사용 신청서 등록
	@Override
	public int carRegist(CarUseDocVO carUseDocVO) {
		return this.fixturesUseDocMapper.carRegist(carUseDocVO);
	}

}
