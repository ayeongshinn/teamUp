package kr.or.ddit.manage.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import lombok.Data;

@Data
public class BoardVO {
	
//	신지BoardVO추가
	private int rnum;
	private int rnum2;
	private String bbsNo;
	private String bbsTtl;
	private String empNo;
	private String empNm;
	private String bbsCn;
	private Date regDt;
	private int inqCnt;
	private String delYn;
	private String rcritSttusCd;
	private String delngSttusCd;
	private String bbsCd;
	private String sugestClsfCd;
	private int fileGroupNo;
	private String processSttusCd;
	private int price;
	private int replyCnt;
	
	private MultipartFile[] uploadFile;
	
	private List<FileDetailVO> fileDetailVOList;
	
	private String[] bbsNoList; // 선택 삭제를 위한 배열
	
	//FILE_DETAIL 테이블을 위함
	private String[] fileSnArr;
	private String[] fileGroupNoArr;
	
}
