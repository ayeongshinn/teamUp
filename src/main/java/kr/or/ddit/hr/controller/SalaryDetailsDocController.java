package kr.or.ddit.hr.controller;

import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.SalaryVO;
import kr.or.ddit.hr.service.SalaryDetailsDocService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.SalaryDetailsDocVO;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/salaryDetails")
public class SalaryDetailsDocController {
	
	@Inject
	SalaryDetailsDocService service;
	
	@GetMapping("/regist")
	public String regist() {
		return "hr/salary/salaryDetailsRegist";
	}
	
	@GetMapping("/list")
	public String list(Model model,
	        @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
	        @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
	        @RequestParam(value = "trgtDt", required = false) String trgtDt) {
	    
	    // 오늘 날짜에서 연도와 월을 추출
	    if (trgtDt == null || trgtDt.isEmpty()) {
	        LocalDate today = LocalDate.now();
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMM");
	        trgtDt = today.format(formatter);
	    }

	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("keyword", keyword);
	    map.put("currentPage", currentPage);
	    map.put("trgtDt", trgtDt);
	    
	    List<SalaryDetailsDocVO> salaryDetailsDocVOList = service.getSalaryDetailsDocList(map);
	    int total = service.getTotal(map);
	    
	    ArticlePage<SalaryDetailsDocVO> articlePage =
	            new ArticlePage<SalaryDetailsDocVO>(total, currentPage, 10, salaryDetailsDocVOList, keyword);
	    
	    log.info("salaryDetailsDocVOList -->> {}", salaryDetailsDocVOList);
	    log.info("total -->> {}", total);
	    log.info("trgtDt -->> {}", trgtDt); // trgtDt 값도 로그에 추가

	    model.addAttribute("salaryDetailsDocVOList", salaryDetailsDocVOList);
	    model.addAttribute("articlePage", articlePage);
	    
	    return "hr/salary/salaryDetailsList";
	}

	
	@GetMapping("/docPopUp")
	public String docPopUp(Model model,
			@RequestParam(value = "empNo", required = false, defaultValue = "") String empNo,
			@RequestParam(value = "trgtDt", required = false) String trgtDt) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("trgtDt", trgtDt);
		
		log.info("맵의 값을 확인하겠습니다 ==>> {}", map);
		
		SalaryDetailsDocVO empSalaryVO = service.getDetailDoc(map);
		model.addAttribute("empSalaryVO", empSalaryVO);
		
		return "hr/salary/docPopUp";
	}
	
	@PostMapping("/batchRegistPost")
	public ResponseEntity<String> batchRegistPost(@RequestBody List<SalaryDetailsDocVO> salaryDetailsDocList) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		CustomUser customUser = (CustomUser) authentication.getPrincipal();
		EmployeeVO employeeVO = customUser.getEmployeeVO();
		
		log.info("일괄 등록 처리 시작. 사원 수 :: {}", salaryDetailsDocList.size());

	    try {
	        // 각각의 사원 데이터에 대해 처리
	        for (SalaryDetailsDocVO salaryDetailsDocVO : salaryDetailsDocList) {
	            log.info("처리 중인 급여명세서 :: {}", salaryDetailsDocVO);
	            String empNo = salaryDetailsDocVO.getTrgtEmpNo();
	            SalaryVO salaryVO = service.getTrgtEmpNo(empNo);
	            
	            int totalGiveAmt = salaryVO.getEmpBslry()
	            				 + salaryDetailsDocVO.getOtmPay()
	            				 + salaryDetailsDocVO.getHolPay()
	            				 + salaryDetailsDocVO.getNitPay()
	            				 + salaryDetailsDocVO.getFamAlwnc()
	            				 + salaryDetailsDocVO.getMealCt();
	            
	            int totalDdcAmt = salaryDetailsDocVO.getNpn()
	            				+ salaryDetailsDocVO.getHlthinsIrncf()
	            				+ salaryDetailsDocVO.getEmplyminsrncIrncf()
	            				+ salaryDetailsDocVO.getEcmt()
	            				+ salaryDetailsDocVO.getLlx();
	            
	            int realRecptAmt = totalGiveAmt - totalDdcAmt;
	            
	            salaryDetailsDocVO.setTotGiveAmt(totalGiveAmt);
	            salaryDetailsDocVO.setTotDdcAmt(totalDdcAmt);
	            salaryDetailsDocVO.setRealRecptAmt(realRecptAmt);
	            salaryDetailsDocVO.setDrftEmpNo(employeeVO.getEmpNo());
	        }
	        
			// 일괄 등록 처리
	        int insertResult = this.service.batchRegistPost(salaryDetailsDocList);
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
	
	@PostMapping("/uploadExcel")
	public String uploadExcel(@RequestParam("uploadFile") MultipartFile uploadFile, Model model) {
	    try {
	        InputStream inputStream = uploadFile.getInputStream();
	        Workbook workbook = WorkbookFactory.create(inputStream);
	        Sheet sheet = workbook.getSheetAt(0);

	        List<SalaryDetailsDocVO> salaryDetailsDocList = new ArrayList<>();

	        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
	            Row row = sheet.getRow(i);
	            SalaryDetailsDocVO salaryDetail = new SalaryDetailsDocVO();

	            // 사원 번호 (문자 또는 숫자로 입력될 수 있음, 숫자인 경우 문자열로 변환)
	            Cell empNoCell = row.getCell(0);
	            if (empNoCell != null && empNoCell.getCellType() == CellType.STRING) {
	                salaryDetail.setTrgtEmpNo(empNoCell.getStringCellValue());
	            } else if (empNoCell != null && empNoCell.getCellType() == CellType.NUMERIC) {
	                salaryDetail.setTrgtEmpNo(String.valueOf((long) empNoCell.getNumericCellValue()));
	            } else {
	                salaryDetail.setTrgtEmpNo("");  // 기본값 설정 (빈 문자열)
	            }

	            // 사원명
	            Cell empNmCell = row.getCell(1);
	            salaryDetail.setTrgtEmpNm(empNmCell != null ? empNmCell.getStringCellValue() : "");

	            // 연장근로수당 (숫자 처리)
	            Cell otmPayCell = row.getCell(2);
	            salaryDetail.setOtmPay(otmPayCell != null && otmPayCell.getCellType() == CellType.NUMERIC ? (int) otmPayCell.getNumericCellValue() : 0);

	            // 휴일근로수당
	            Cell holPayCell = row.getCell(3);
	            salaryDetail.setHolPay(holPayCell != null && holPayCell.getCellType() == CellType.NUMERIC ? (int) holPayCell.getNumericCellValue() : 0);

	            // 야간근로수당
	            Cell nitPayCell = row.getCell(4);
	            salaryDetail.setNitPay(nitPayCell != null && nitPayCell.getCellType() == CellType.NUMERIC ? (int) nitPayCell.getNumericCellValue() : 0);

	            // 가족 수당
	            Cell famAlwncCell = row.getCell(5);
	            salaryDetail.setFamAlwnc(famAlwncCell != null && famAlwncCell.getCellType() == CellType.NUMERIC ? (int) famAlwncCell.getNumericCellValue() : 0);

	            // 식대
	            Cell mealCtCell = row.getCell(6);
	            salaryDetail.setMealCt(mealCtCell != null && mealCtCell.getCellType() == CellType.NUMERIC ? (int) mealCtCell.getNumericCellValue() : 0);

	            // 국민연금
	            Cell npnCell = row.getCell(7);
	            salaryDetail.setNpn(npnCell != null && npnCell.getCellType() == CellType.NUMERIC ? (int) npnCell.getNumericCellValue() : 0);

	            // 건강보험
	            Cell hlthinsIrncfCell = row.getCell(8);
	            salaryDetail.setHlthinsIrncf(hlthinsIrncfCell != null && hlthinsIrncfCell.getCellType() == CellType.NUMERIC ? (int) hlthinsIrncfCell.getNumericCellValue() : 0);

	            // 고용보험
	            Cell emplyminsrncIrncfCell = row.getCell(9);
	            salaryDetail.setEmplyminsrncIrncf(emplyminsrncIrncfCell != null && emplyminsrncIrncfCell.getCellType() == CellType.NUMERIC ? (int) emplyminsrncIrncfCell.getNumericCellValue() : 0);

	            // 근로소득세
	            Cell ecmtCell = row.getCell(10);
	            salaryDetail.setEcmt(ecmtCell != null && ecmtCell.getCellType() == CellType.NUMERIC ? (int) ecmtCell.getNumericCellValue() : 0);

	            // 지방세
	            Cell llxCell = row.getCell(11);
	            salaryDetail.setLlx(llxCell != null && llxCell.getCellType() == CellType.NUMERIC ? (int) llxCell.getNumericCellValue() : 0);

	            // 선택적 필드 (문자열 또는 null 처리)
	            salaryDetail.setDocNo(row.getCell(12) != null ? row.getCell(12).getStringCellValue() : "");
	            salaryDetail.setDocTtl(row.getCell(13) != null ? row.getCell(13).getStringCellValue() : "");
	            salaryDetail.setDocCn(row.getCell(14) != null ? row.getCell(14).getStringCellValue() : "");
	            salaryDetail.setHtmlCd(row.getCell(15) != null ? row.getCell(15).getStringCellValue() : "");
	            salaryDetail.setDocCd(row.getCell(16) != null ? row.getCell(16).getStringCellValue() : "");
	            salaryDetail.setDrftEmpNo(row.getCell(17) != null ? row.getCell(17).getStringCellValue() : "");

	            // 로그 출력
	            log.info("엑셀에서 읽은 데이터: {}", salaryDetail);

	            salaryDetailsDocList.add(salaryDetail);
	        }

	        model.addAttribute("salaryDetailsDocList", salaryDetailsDocList); // JSP에서 사용할 데이터
	        workbook.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	        log.error("엑셀 처리 중 오류 발생: ", e);
	        return "redirect:/accessError";  // 예외 발생 시 오류 페이지로 리다이렉트
	    }
	    return "hr/salary/salaryDetailsRegist"; // JSP 페이지로 이동
	}

}