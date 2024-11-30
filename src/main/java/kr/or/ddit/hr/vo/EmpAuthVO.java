package kr.or.ddit.hr.vo;

import lombok.Data;

@Data
/** 사원 권한(EMP_AUTH) VO
 * 최종 수정 일 : 2024-09-12
 * @author 정지훈
 *
 */
public class EmpAuthVO {
	private String empNo;		//사원 번호
	private String authority;	//사용자 권한 코드
	
	/*
	AUTHORITY		USERNAME
	-------------------------
	ROLE_USER		user
	ROLE_MEMBER		member
	ROLE_ADMIN		admin
	ROLE_MEMBER		admin
	 */
}
