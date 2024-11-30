package kr.or.ddit.cmmn.vo;

import java.util.List;

import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.Data;

@Data
public class CommonCodeVO {
	private String clsfCd;
	private String clsfNm;
	private int outptSn;
	private String groupCd;
	
	//부서 : 사원 = 1 : N
	private List<EmployeeVO> employeeVOList;
}
