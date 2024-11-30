package kr.or.ddit.manage.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

// 비품 관리 VO
// 작성자 : 김다희
@Data
public class FixturesVO {
	
	private int rnum;       
	private String fxtrsNo; // 비품 코드
	private String fxtrsNm; // 비품 명
	private String prchsYmd; // 구매 일자
	private int fxtrsQy; // 비품 수량
	private String rmrkCn; // 비고 내용
	private String fxtrsPstnCd; // 비품 위치 코드
	private String fxtrsSttusCd; // 비품 상태 코드
	private String fxtrsPhoto; // 비품 사진
	private String delYn; // 비품 삭제 여부
	private int fileGroupNo;//파일 그룸 번호

	private String[] fxtrsNoList; // 선택 삭제를 위한 배열
	
	//파일 객체
	private MultipartFile[] uploadFiles;
	
	private String fxtrsPstnNm;  // 비품 위치 명
	private String fxtrsSttusNm; // 비품 상태 명
	
	private String currentDate;
}
