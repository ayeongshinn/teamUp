package kr.or.ddit.planng.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import lombok.Data;

@Data
public class NoticeVO {
	private String ntcNo; //공지사항 기본키
	private String ntcTtl; //공지사항 제목
	private String ntcCn; //게시물 내용
	private String empNo; //사원 번호
	private Date regDt; //등록 일시
	private String regDtStr;//등록 일시를 문자형으로 변환
	private int inqCnt; //조회수
	private String imprtncYn; //중요 여부
	private String delYn; //삭제 여부
	private int fileGroupNo; //파일 그룹 번호
	private String aprvYn; //승인 여부
	private String empNm; //사원 이름
	private int wCnt; //승인 대기 중인 공지사항 수
	
	//<input type="file" id="uploadFile" name="uploadFile" multiple
	private MultipartFile[] uploadFile; //파일 객체
	
	//NOTICE_BOARD : FILE_DETAIL = 1 : N
	private List<FileDetailVO> fileDetailVOList;
	
	private String strRegDt; // 문자열 등록 일시
	
	private int rnum; //글 번호
	private int rnum2;
}
