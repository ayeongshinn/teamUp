package kr.or.ddit.cmmn.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MailDVO {
	private int rnum;
	private String mailNo;
	private String mailTtl;
	private String mailCn;
	private String dsptchEmpNo;
	private String dsptEmpNm;
	private Date dsptchDt;
	
	private String imprtncYn;
	private String prslYn;
	private String delYn;
	private String spamYn;
	
	private String dsptEmpDeptCd;
	//groupList(받는 사람 1명 이상) : 112001,181001,001002
	private String groupList;
	private String dimprtncYn;
	private String dprslYn;
	private String ddelYn;
	private String dspamYn;
	private int fileGroupNo;
	
	//발신 : 수신 = 1 : N
	private List<MailRVO> mailRVOList;
	
	private MultipartFile[] uploadFile;
	
	//NOTICE_BOARD : FILE_DETAIL = 1 : N
	private List<FileDetailVO> fileDetailVOList;
}
