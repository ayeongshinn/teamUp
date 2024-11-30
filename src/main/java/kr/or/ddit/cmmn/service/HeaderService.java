package kr.or.ddit.cmmn.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;

public interface HeaderService {

	public List<CommonCodeVO> getDept(Map<String, Object> clsfCd);

	public AttendanceVO getEmpSttus(String empNo);

}
