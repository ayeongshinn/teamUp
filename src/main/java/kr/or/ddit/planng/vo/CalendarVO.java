package kr.or.ddit.planng.vo;

import java.util.List;

import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.Data;

@Data
public class CalendarVO {
	private String schdlNo; //일정 번호
	private String schdlNm; //일정 제목
	private String schdlCn; //일정 내용
	private String schdlPlc; //일정 장소
	private String empNo; //사원 번호
	private String schdlBgngYmd; //일정 시작 일자
	private String schdlBgngTm; //일정 시작 시간
	private String schdlEndYmd; //일정 종료 일자
	private String schdlEndTm; //일정 종료 시간
	private String userCd; //사용자 코드 A03
	private String delYn; //삭제 여부
	private String backColor; //배경 색상
	private String fontColor; //글자 색상
	
	//calendar : employee = 1 : N
	private List<EmployeeVO> employeeVOList;
}
