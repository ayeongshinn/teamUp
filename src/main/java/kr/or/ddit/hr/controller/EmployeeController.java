package kr.or.ddit.hr.controller;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.hr.service.EmployeeService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.EncryptUtil;
import kr.or.ddit.util.ImageUtils;
import lombok.extern.slf4j.Slf4j;

import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

//사원 컨트롤러 :: 장영원
@Slf4j
@RequestMapping("/employee")
@Controller
public class EmployeeController {
	
	@Inject
	EmployeeService employeeService;
	
	// 사원 등록 페이지 :: 장영원
	@GetMapping("/regist")
	public String empRegist(Model model) {
		
		String groupCd = "A18";
		List<CommonCodeVO> commonCodeVOList = this.employeeService.searchCommonCd(groupCd);
		log.info("직급 코드 : " + commonCodeVOList);
		model.addAttribute("A18List", commonCodeVOList);
		
		groupCd = "A19";
		commonCodeVOList = this.employeeService.searchCommonCd(groupCd);
		log.info("직책 코드 : " + commonCodeVOList);
		model.addAttribute("A19List", commonCodeVOList);
		
		groupCd = "A17";
		commonCodeVOList = this.employeeService.searchCommonCd(groupCd);
		log.info("부서 코드 : " + commonCodeVOList);
		model.addAttribute("A17List", commonCodeVOList);
		
		groupCd = "A21";
		commonCodeVOList = this.employeeService.searchCommonCd(groupCd);
		log.info("성별 코드 : " + commonCodeVOList);
		model.addAttribute("A21List", commonCodeVOList);
		
		return "hr/employee/regist";
	}
	
	//사원 등록 실행 :: 장영원
	@PostMapping("/registPost")
	public String registPost(@ModelAttribute EmployeeVO employeeVO) {

	    log.info("employeeVO 확인 :: {}", employeeVO);

	    try {
	    	// 주민등록번호 암호화 처리
	        String empRrno = employeeVO.getEmpRrno();  // 주민등록번호 가져오기
	        if (empRrno != null && !empRrno.isEmpty()) {
	            String encryptedRrno = EncryptUtil.encrypt(empRrno);  // 암호화
	            employeeVO.setEmpRrno(encryptedRrno);  // 암호화된 주민등록번호 설정
	            log.info("주민등록번호 암호화 완료");
	        } else {
	            log.warn("주민등록번호가 없습니다.");
	        }
	    	
	        // 직인 이미지 처리
	        MultipartFile offcsFile = employeeVO.getOffcsFile();
	        if (offcsFile != null && !offcsFile.isEmpty()) {
	            // 이미지 크기를 조정 (예: 500x500 크기로 조정)
	            byte[] resizedOffcsFile = ImageUtils.resizeImage(offcsFile, 500, 500);
	            String base64OffcsPhoto = Base64.getEncoder().encodeToString(resizedOffcsFile);
	            
	            // CLOB 컬럼에 저장할 데이터 설정
	            employeeVO.setOffcsPhoto(base64OffcsPhoto); 
	            log.info("직인 이미지 처리 완료");
	        } else {
	            log.info("직인 이미지 파일이 없습니다.");
	        }

	        // 프로필 사진 처리
	        MultipartFile proflFile = employeeVO.getProflFile();
	        if (proflFile != null && !proflFile.isEmpty()) {
	            // 이미지 크기를 조정 (예: 500x500 크기로 조정)
	            byte[] resizedProflFile = ImageUtils.resizeImage(proflFile, 500, 500);
	            String base64ProflPhoto = Base64.getEncoder().encodeToString(resizedProflFile);
	            
	            // CLOB 컬럼에 저장할 데이터 설정
	            employeeVO.setProflPhoto(base64ProflPhoto); 
	            log.info("프로필 사진 처리 완료");
	        } else {
	            log.info("프로필 사진 파일이 없습니다.");
	        }

	        // 사원 정보 등록 처리
	        int insertResult = this.employeeService.registPost(employeeVO);
	        log.info("insertResult :: {}", insertResult);

	        if (insertResult > 0) {
	            return "hr/employee/proflImage";  // 성공 시 성공 페이지로 리다이렉트
	        } else {
	            log.error("사원 정보 등록 실패");
	            return "redirect:/error";  // 실패 시 오류 페이지로 리다이렉트
	        }

	    } catch (Exception e) {
	        log.error("사원 정보 등록 중 오류 발생", e);
	        return "redirect:/error";  // 예외 발생 시 오류 페이지로 리다이렉트
	    }
	}
	
	//사원  일괄 등록 실행 :: 장영원
	@PostMapping("/batchRegist")
	public ResponseEntity<String> batchRegist(@RequestBody List<EmployeeVO> employeeList) {

	    log.info("일괄 등록 처리 시작. 사원 수 :: {}", employeeList.size());

	    try {
	        // 각각의 사원 데이터에 대해 처리
	        for (EmployeeVO employeeVO : employeeList) {
	            log.info("처리 중인 사원 :: {}", employeeVO);
	            
	            // 주민등록번호 암호화 처리
		        String empRrno = employeeVO.getEmpRrno();  // 주민등록번호 가져오기
		        if (empRrno != null && !empRrno.isEmpty()) {
		        	try {
	                    log.info("Encrypting 주민등록번호...");
	                    String encryptedRrno = EncryptUtil.encrypt(empRrno);  // 암호화 시도
	                    employeeVO.setEmpRrno(encryptedRrno);  // 암호화된 주민등록번호 설정
	                    log.info("주민등록번호 암호화 완료");
	                } catch (Exception e) {
	                    log.error("주민등록번호 암호화 중 오류 발생", e);  // 예외 처리
	                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("주민등록번호 암호화 중 오류 발생");
	                }
		        } else {
		            log.warn("주민등록번호가 없습니다.");
		        }
	            
	            // 직인 이미지 처리
	            MultipartFile offcsFile = employeeVO.getOffcsFile();
	            if (offcsFile != null && !offcsFile.isEmpty()) {
	                byte[] resizedOffcsFile = ImageUtils.resizeImage(offcsFile, 500, 500);
	                String base64OffcsPhoto = Base64.getEncoder().encodeToString(resizedOffcsFile);
	                employeeVO.setOffcsPhoto(base64OffcsPhoto);  // CLOB 컬럼에 저장
	                log.info("직인 이미지 처리 완료 for 사원: {}", employeeVO.getEmpNm());
	            } else {
	                log.info("직인 이미지 파일이 없습니다 for 사원: {}", employeeVO.getEmpNm());
	            }

	            // 프로필 사진 처리
	            MultipartFile proflFile = employeeVO.getProflFile();
	            if (proflFile != null && !proflFile.isEmpty()) {
	                byte[] resizedProflFile = ImageUtils.resizeImage(proflFile, 500, 500);
	                String base64ProflPhoto = Base64.getEncoder().encodeToString(resizedProflFile);
	                employeeVO.setProflPhoto(base64ProflPhoto);  // CLOB 컬럼에 저장
	                log.info("프로필 사진 처리 완료 for 사원: {}", employeeVO.getEmpNm());
	            } else {
	                log.info("프로필 사진 파일이 없습니다 for 사원: {}", employeeVO.getEmpNm());
	            }
	        }

	        // 일괄 등록 처리
	        int insertResult = this.employeeService.batchRegistPost(employeeList);
	        log.info("일괄 등록 결과 :: {}", insertResult);

	        if (insertResult > 0) {
	            return ResponseEntity.ok("일괄 등록 성공");  // 성공 시 200 응답
	        } else {
	            log.error("사원 정보 일괄 등록 실패");
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("일괄 등록 실패");
	        }

	    } catch (Exception e) {
	        log.error("사원 정보 일괄 등록 중 오류 발생", e);
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("일괄 등록 중 오류 발생");
	    }
	}


	//사원 일괄 등록
	@PostMapping("/empRegistPost")
	@ResponseBody
	public ResponseEntity<EmployeeVO> empRegistPost(@ModelAttribute EmployeeVO employeeVO) {
	    log.info("employeeVO 확인 :: {}", employeeVO);

	    try {
	        // 직인 이미지 처리 (이미지가 없을 경우 처리)
	        MultipartFile offcsFile = employeeVO.getOffcsFile();
	        if (offcsFile != null && !offcsFile.isEmpty()) {
	            byte[] resizedOffcsFile = ImageUtils.resizeImage(offcsFile, 500, 500);
	            String base64OffcsPhoto = Base64.getEncoder().encodeToString(resizedOffcsFile);
	            employeeVO.setOffcsPhoto(base64OffcsPhoto); 
	        }

	        // 프로필 사진 처리 (이미지가 없을 경우 처리)
	        MultipartFile proflFile = employeeVO.getProflFile();
	        if (proflFile != null && !proflFile.isEmpty()) {
	            byte[] resizedProflFile = ImageUtils.resizeImage(proflFile, 500, 500);
	            String base64ProflPhoto = Base64.getEncoder().encodeToString(resizedProflFile);
	            employeeVO.setProflPhoto(base64ProflPhoto); 
	        }

	        // 성공적으로 등록된 사원 정보를 클라이언트로 전달
	        return ResponseEntity.ok(employeeVO);

	    } catch (Exception e) {
	        log.error("사원 등록 중 오류 발생", e);  // 서버 측 로그에 오류 메시지 출력
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);  // 예외 발생 시 500 응답
	    }
	}

	
	//인사부서 사원리스트 :: 장영원
	@GetMapping("/list")
	public String list(Model model,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "attendYmd", required = false) String attendYmd,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(value = "jncmpStart", required = false, defaultValue = "") String jncmpStart,
            @RequestParam(value = "jncmpEnd", required = false, defaultValue = "") String jncmpEnd,
            @RequestParam(value = "rsgntnStart", required = false, defaultValue = "") String rsgntnStart,
            @RequestParam(value = "rsgntnEnd", required = false, defaultValue = "") String rsgntnEnd,
            @RequestParam(value = "delynField", required = false, defaultValue = "all") String delynField,
            @RequestParam(value = "searchField", required = false, defaultValue = "all") String searchField) {
		
		//test data
		String deptCd = "A17-005";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptCd", deptCd);
		map.put("keyword", keyword);
		map.put("attendYmd", attendYmd);
		map.put("currentPage", currentPage);
		map.put("jncmpStart", jncmpStart);
	    map.put("jncmpEnd", jncmpEnd);
	    map.put("rsgntnStart", rsgntnStart);
	    map.put("rsgntnEnd", rsgntnEnd);
	    map.put("delynField", delynField);  // 퇴사 여부 (전체, 재직, 퇴직)
	    map.put("searchField", searchField);  // 검색 필드 (부서, 직급, 사원명)
	    log.info("map 데이터는 ??!!" + map);
	    
		List<EmployeeVO> employeeVOList = this.employeeService.list(map);
		log.info("employeeVOList -> " + employeeVOList);
		model.addAttribute("employeeVOList", employeeVOList);
		
		//사원 수
		int total = this.employeeService.getTotal(map);
		log.info("list => total : " + total);
		
		// 페이지네이션 객체
		ArticlePage<EmployeeVO> articlePage = 
				new ArticlePage<EmployeeVO>(total, currentPage, 10, employeeVOList, keyword);
		
		model.addAttribute("articlePage", articlePage);
		
		//전 사원 수
		int empTotal = this.employeeService.empTotal();
		log.info("empTotal : " + empTotal);
		model.addAttribute("empTotal", empTotal);
		
		//금년 입사자 수
		int empJoin = this.employeeService.empJoin();
		log.info("empJoin : " + empJoin);
		model.addAttribute("empJoin", empJoin);
		
		//금년 퇴사자 수
		int empResign = this.employeeService.empResign();
		log.info("empResign : " + empResign);
		model.addAttribute("empResign", empResign);
		
		//현재 재직자 수
		int empInOffice = this.employeeService.empInOffice();
		log.info("empInOffice : " + empInOffice);
		model.addAttribute("empInOffice", empInOffice);
		
		//전년도 재직자 수
		int empLastYear = this.employeeService.empLastYear();
		log.info("empLastYear" + empLastYear);
		
		double empLast =  (empResign / (double)empLastYear) * 100;
		log.info("empLast는 ??? " + empLast);
		
		model.addAttribute("empLast", empLast);
		
		return "hr/employee/list";
	}
	
	// 사원 디테일
    @PostMapping("/getDetail")
    public ResponseEntity<EmployeeVO> getDetail(@RequestParam("empNo") String empNo) {
        // 사원 상세 정보 조회
        EmployeeVO employeeVO = this.employeeService.detail(empNo);
        log.info("employeeVO :: " + employeeVO);

        // 직원 정보가 없으면 404 Not Found 반환
        if (employeeVO == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        // 정상적으로 직원 정보를 JSON 형태로 반환
        return new ResponseEntity<>(employeeVO, HttpStatus.OK);
    }
	
	//다수의 사원을 등록하기 위한 폼 :: 장영원
	@GetMapping("/empRegistForm")
	public String empRegistForm(Model model) {
		
		return "hr/employee/empRegistForm";
	}
	
	//base64 등록 잘 되었는지 테스트 :: 장영원
	@GetMapping("/test")
	public String proflImage(Model model) {
		
		String empNo = "240020";
		
		EmployeeVO test = employeeService.test(empNo);
		log.info("test 데이터입니다. :: " + test);
		
		model.addAttribute("employeeVO", test);
		
		return "hr/employee/proflImage";
	}
	
	//엑셀 업로드 :: 장영원
	@PostMapping("/uploadExcel")
	public String uploadExcel(@RequestParam("uploadFile") MultipartFile uploadFile, Model model) {
	    try {
	        InputStream inputStream = uploadFile.getInputStream();
	        Workbook workbook = WorkbookFactory.create(inputStream);
	        Sheet sheet = workbook.getSheetAt(0);
	        
	        List<EmployeeVO> employeeList = new ArrayList<>();

	        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
	            Row row = sheet.getRow(i);
	            EmployeeVO employee = new EmployeeVO();
	            
	            // 사원명 (문자열)
	            if (row.getCell(0).getCellType() == CellType.STRING) {
	                employee.setEmpNm(row.getCell(0).getStringCellValue());
	            } else if (row.getCell(0).getCellType() == CellType.NUMERIC) {
	                employee.setEmpNm(String.valueOf(row.getCell(0).getNumericCellValue()));
	            }

	            // 주민등록번호 (문자 또는 숫자)
	            if (row.getCell(1).getCellType() == CellType.NUMERIC) {
	                employee.setEmpRrno(String.valueOf((long) row.getCell(1).getNumericCellValue()));  // 숫자면 변환
	            } else {
	                employee.setEmpRrno(row.getCell(1).getStringCellValue());  // 문자열 그대로
	            }

	            // 생년월일 (문자 또는 숫자)
	            if (row.getCell(2).getCellType() == CellType.NUMERIC) {
	                employee.setEmpBrdt(String.valueOf((long) row.getCell(2).getNumericCellValue()));
	            } else {
	                employee.setEmpBrdt(row.getCell(2).getStringCellValue());
	            }

	            // 전화번호
	            if (row.getCell(3).getCellType() == CellType.NUMERIC) {
	                employee.setEmpTelno(String.valueOf((long) row.getCell(3).getNumericCellValue()));
	            } else {
	                employee.setEmpTelno(row.getCell(3).getStringCellValue());
	            }

	            // 이메일 주소
	            employee.setEmpEmlAddr(row.getCell(4).getStringCellValue());

	            // 입사일 (문자 또는 숫자)
	            if (row.getCell(5).getCellType() == CellType.NUMERIC) {
	                employee.setJncmpYmd(String.valueOf((long) row.getCell(5).getNumericCellValue()));
	            } else {
	                employee.setJncmpYmd(row.getCell(5).getStringCellValue());
	            }

	            // 우편번호
	            if (row.getCell(6).getCellType() == CellType.NUMERIC) {
	                employee.setRoadNmZip(String.valueOf((long) row.getCell(6).getNumericCellValue()));
	            } else {
	                employee.setRoadNmZip(row.getCell(6).getStringCellValue());
	            }

	            // 도로명 주소
	            employee.setRoadNmAddr(row.getCell(7).getStringCellValue());

	            // 상세 주소
	            employee.setDaddr(row.getCell(8).getStringCellValue());

	            // 직급 코드
	            employee.setJbgdCd(row.getCell(9).getStringCellValue());

	            // 직책 코드
	            employee.setJbttlCd(row.getCell(10).getStringCellValue());

	            // 부서 코드
	            employee.setDeptCd(row.getCell(11).getStringCellValue());

	            // 성별 코드
	            employee.setSexdstnCd(row.getCell(12).getStringCellValue());

	            // 로그 출력
	            log.info("엑셀에서 읽은 데이터: {}", employee);

	            employeeList.add(employee);
	        }

	        model.addAttribute("employeeList", employeeList); // JSP에서 사용할 데이터
	        workbook.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	        log.error("엑셀 처리 중 오류 발생: ", e);
	        return "redirect:/accessError";  // 예외 발생 시 오류 페이지로 리다이렉트
	    }
	    return "hr/employee/empRegistForm"; // JSP 페이지로 이동
	}

	
}
