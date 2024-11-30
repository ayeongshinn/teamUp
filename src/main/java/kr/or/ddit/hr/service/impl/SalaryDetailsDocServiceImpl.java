package kr.or.ddit.hr.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.vo.SalaryVO;
import kr.or.ddit.hr.mapper.SalaryDetailsDocMapper;
import kr.or.ddit.hr.service.SalaryDetailsDocService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.SalaryDetailsDocVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SalaryDetailsDocServiceImpl implements SalaryDetailsDocService{

	@Inject
	SalaryDetailsDocMapper mapper;
	
	@Override
	public int batchRegistPost(List<SalaryDetailsDocVO> salaryDetailsDocList) {
		return mapper.batchRegistPost(salaryDetailsDocList);
	}

	@Override
	public SalaryVO getTrgtEmpNo(String empNo) {
		return mapper.getTrgtEmpNo(empNo);
	}

	@Override
	public List<SalaryDetailsDocVO> getSalaryDetailsDocList(Map<String, Object> map) {
		return mapper.getSalaryDetailsDocList(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		return mapper.getTotal(map);
	}

	@Override
	public SalaryDetailsDocVO getDetailDoc(Map<String, Object> map) {
		return mapper.getDetailDoc(map);
	}

}
