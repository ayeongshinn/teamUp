package kr.or.ddit.cmmn.vo;

import lombok.Data;

// 작성자 : 김다희

@Data
public class MeetingRoomVO {
	
	private String rsvtNo;       // 예약 번호
	private String rsvtYmd;      // 예약 일자
	private String rsvtBgngTm;   // 예약 시작 시간
	private String rsvtEndTm;    // 예약 종료 시간
	private String empNo;        // 사원 번호
	private String mtgroomCd;    // 회의실_코드_A05
	private String delYn;        // 삭제 여부
	private String rsvtCn;       // 예약 내용
	private String empNm;        // 사원 이름
	private String deptName;     // 부서 명
	
}