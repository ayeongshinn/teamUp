package kr.or.ddit.manage.vo;

import lombok.Data;

@Data
public class CommentVO {
	private String cmntNo;
	private String replyNo;
	private String empNo;
	private String nm;
	private String cmntCn;
	private String regDt;
	private String delYn;
	private String ntcNo;
	private String bbsNo;
	private String processSttusCd;

	private String jbttlNm; // 직책명
	private String deptNm;  // 부서명
	private String proflPhoto; // 프로필 사진
}
