package kr.or.ddit.cmmn.mapper;

import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;

public interface HeaderMapper {

	public CommonCodeVO getDept(String clsfCd);

	public AttendanceVO getEmpSttus(String empNo);

}
