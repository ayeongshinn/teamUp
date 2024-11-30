package kr.or.ddit.cmmn.vo;

import lombok.Data;

@Data
public class MailRVO {
	private int rcptnSn;
	private String mailNo;
	private String recptnEmpNo;
	private String recptnEmpNm;
	
	private String imprtncYn;
	private String prslYn;
	private String delYn;
	private String delYnDespatch;
	private String spamYn;
	
	private String rimprtncYn;
	private String rprslYn;
	private String rdelYn;
	private String rspamYn;
	private String recmailaddr;
}
