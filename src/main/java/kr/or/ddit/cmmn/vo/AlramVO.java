package kr.or.ddit.cmmn.vo;

import lombok.Data;

@Data
public class AlramVO {
	private String ntcnNo;   // 알림 번호
	private String toid;     // 보내는 사람
	private String fromid;   // 받는 사람
	private String text;   	 // 내용
	private String icon;   	 // 내용
	private String categori; // 알림 카테고리
	private String url; 	 // 주소
	private String noCheck;  // 확인
	
	// 알림 분류 (CATEGORI)
	// 1 >> 메일
	// 2 >> 일정
	// 3 >> 설문
}



