package kr.or.ddit.cmmn.vo;

import java.sql.Date;
import lombok.Data;

@Data
public class TaskDiaryVO {
	private String diaryNo;
	private String diaryTtl;
	private String diaryCn;
	private Date regDt;
	private String empNo;
	private String empNm;
	private String userCd;
	private String delYn;
	private int fileGroupNo;
	private int rnum;
	private int rnum2;
	
	private String jbgdNm;			//직급 명
	private String jbttlNm;			//직책 명
	private String deptNm;			//부서 명
}

