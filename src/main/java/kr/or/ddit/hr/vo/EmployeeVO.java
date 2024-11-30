package kr.or.ddit.hr.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import lombok.Data;
import java.io.Serializable;


/** 사원(EMPLOYEE) VO
 * 최종 수정 일 : 2024-09-12
 * @author 장영원 (최조작성자 : 정지훈)
 *
 */
@Data
public class EmployeeVO implements Serializable { // Serializable 구현
    private static final long serialVersionUID = 1L; // serialVersionUID 추가
    
	private String empNo;			//사원 번호
	private String empPswd;			//사원 비밀번호
	private String empNm;			//사원 명
	private String empRrno;			//사원 주민등록번호
	private String empBrdt;			//사원 생년월일
	private String empTelno;		//사원 전화번호
	private String empEmlAddr;		//사원 이메일 주소
	private String jncmpYmd;		//입사 일자
	private String rsgntnYmd;		//퇴사 일자
	private String roadNmZip;		//도로 명 우편번호
	private String roadNmAddr;		//도로 명 주소
	private String daddr;			//상세주소
	private String empIntrcn;		//사원 소개
	private String delYn;			//삭제 여부
	@JsonIgnore
	private MultipartFile offcsFile;  // 직인 파일을 받기 위한 필드
	@JsonIgnore
	private MultipartFile proflFile;  // 프로필 사진 파일을 받기 위한 필드
	private String offcsPhoto;        // BASE64로 변환된 직인 이미지
	private String proflPhoto;        // BASE64로 변환된 프로필 사진
	private String jbgdCd;			//직급_코드_A18
	private String jbttlCd;			//직책_코드_A19
	private String deptCd;			//부서_코드_A17
	private String sexdstnCd;		//성별_코드_A21
	private String enabled;			//사용 여부
	
	private String jbgdNm;			//직급 명
	private String jbttlNm;			//직책 명
	private String deptNm;			//부서 명
	private String sexdstnNm;		//성별
	
	private String fnstNm;			//금융기관 명
	private String giveActno;		//지급 계좌번호
	private int empAnslry;			//사원 연봉
	private int empBslry;			//사원 기본급
	private String dsgnYmd;			//지정 일자
	
	//새 비밀번호 :: 신아영
	private String empPswdNew;
	
	// 사원 : 사원 권한 = 1 : N
	private List<EmpAuthVO> empAuthVOList;
	
	// 사원 : 급여명세서 = 1 : N
	private List<SalaryDetailsDocVO> salaryDetailsDocVOList;
}
