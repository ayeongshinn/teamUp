//근태 테이블 VO :: 신아영
package kr.or.ddit.cmmn.vo;

import java.util.List;

import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.Data;

@Data
public class AttendanceVO {
	private String dclzNo; //근태번호
	private String empNo; //사원번호
	private String attendYmd; //출근일자
	private String attendTm; //출근시각
	private String lvffcTm; //퇴근시각
	private String restHr; //휴게시간
	private String workHr; //근무시간
	private String mealHr; //식사시간
	private String ngtwrHr; //야근시간
	private String empSttusCd; //사원상태코드_A13
	private String empSttusNm; //사원상태코드명_A13
	private String username;
	
	//사원 이름 :: 장영원
	private String empNm;
	//사원의 부서 코드 :: 장영원
	private String deptCd;
	//사원의 직급 이름 :: 장영원
	private String jbgdNm;
	
	private String jbgdCd;
	
	// ATTENDANCE : COMMON_CODE = 1 : N
	private List<CommonCodeVO> commonCodeVOList;
}
