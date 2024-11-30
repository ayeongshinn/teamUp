package kr.or.ddit.bsn.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import lombok.Data;

@Data
public class DealingsDocVO {
	
	private String htmlCd;				// HTML 코드
	private String docNo;				// 서류 번호
	private String docTtl;				// 서류 제목
	private String ctrtCn;				// 계약 내용
	private String wrtYmd;				// 작성 일자
	private String rbprsnEmpNo;			// 담당자
	private int ctrtAmt;				// 계약 금액
	private String cnptNo;				// 거래처 번호
	private String custNo;				// 고객 번호
	private String atrzSttusCd;			// 결제 상태 코드
	private int fileGroupNo;			// 파일 그룹 번호
	
	private String rprsvNm;				// 거래처 대표명
	private String custNm;				// 고객 성명
	private String empNm;				// 담당자 성명
	private String clsfNm;				// 결제 상태명
	private String category;			// 카테고리
	private int rnum;					// 순번
	
	private String dealingsDocHtmlCd;   // HTML CLOB 프로퍼티
	
	private String selectBtn;			// radio 버튼을 위한 VO
	
	private String indutyCd;			// 업종 코드
	private String indutynm;			// 업종명
	
	private MultipartFile[] uploadFile; // 파일 객체
	
	// Dealings_DOC : FILE_DETAIL = 1 : N
	private List<FileDetailVO> fileDetailVOList;

	// 고객 VO
	private String custRrno;			// 고객 주민등록번호
	private String custCrNm;			// 고객 직업명
	private String custTelno;			// 고객 전화번호
	private String custEmlAddr;			// 고객 이메일
	private String custCtrtCnclsYmd;	// 고객 계약 체결 일자
	private String custRoadNmZip;		// 고객 우편번호
	private String custRmrkCn;			// 비고 내용
	private String custRoadNmAddr;		// 고객 도로명 주소
	private String custDaddr;			// 고객 상세 주소
	private String custAtrzSttusCd;		// 결제 상태 코드
	
	// 거래처VO
	private String cmrcNm; 	    	// 업체명
	private String cnptBrno; 		// 사업자번호
	private String rprsTelno; 		// 대표 전화번호
	private String cnptFxno; 		// FAX 번호
	private String coRoadNmZip; 	// 우편번호
	private String fndnYmd; 		// 설립 일자
	private String rmrkCn; 			// 비고 내용
	private String counterCtrtCnclsYmd; 	// 계약 체결일
	private String coRoadNmAddr; 	// 도로명 주소
	private String coDaddr; 		// 상세주소
	private String counterAtrzSttusCd;			// 결제 상태 코드
	
}
