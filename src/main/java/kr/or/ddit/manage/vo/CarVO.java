package kr.or.ddit.manage.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

// 법인 차량 VO
// 작성자 : 김다희
@Data
public class CarVO {
	
	private int rnum;
	private String vhclId;   // 차량 아이디
	private String vhclNo;   // 차량 번호
	private String prchsYmd; // 구매 일자
	private String rmrkCn;   // 비고 내용
	private String vhclSttusCd; // 차량 상태 코드
	private String carmdlNmCd; // 차종 명 코드
	private String mkrCd;  // 제조사 코드
	private int fileGroupNo; // 파일 그룹 번호
	private String delYn; // 삭제 여부
	
	//선택 삭제를 위한 배열
	private String[] vhclIdList;
	
	//파일 객체
	private MultipartFile[] uploadFiles;
	
}
