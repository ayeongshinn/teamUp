package kr.or.ddit.cmmn.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FileDetailVO {
	private int fileSn;
	private int fileGroupNo;
	private String fileOriginalNm;
	private String fileSaveNm;
	private String fileSaveLocate;
	private long fileSize;
	private String fileExt;
	private String fileMime;
	private String fileFancysize;
	private Date fileSaveDate;
	private int fileDowncount;
}
