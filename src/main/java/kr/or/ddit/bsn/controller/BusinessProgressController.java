package kr.or.ddit.bsn.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.bsn.service.BusinessProgressServie;
import kr.or.ddit.bsn.vo.BusinessProgressVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/businessProgress")
@Slf4j
@Controller
public class BusinessProgressController {
	
	@Inject
	BusinessProgressServie businessProgressServie;
	
	// 영업 진척도 list
	@GetMapping("/list")
	public String businessProgressList() {
		
		return "bsn/businessProgress/list";
	}
	
	// Chart 데이터 조회
	@GetMapping("/chartData")
	@ResponseBody
	public List<BusinessProgressVO> chartData() {
		
		List<BusinessProgressVO> chartData = businessProgressServie.chartDataList();
		
		return chartData;
	}
	
	// 영업 진척도 등록
	@PostMapping("/businessInsert")
	@ResponseBody
	public int businessInsert(@RequestBody BusinessProgressVO businessProgressVO) throws ParseException {
		
		log.info("businessProgressVO 확인 : " + businessProgressVO);
		
        // 날짜 형식 변환을 위한 준비 (입력 받은 yyyy-MM-dd 형식 -> yyyyMMdd 형식으로 변환)
        SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdfOutput = new SimpleDateFormat("yyyyMMdd");
        
        // 영업 시작일(bsnBgngYmd)가 있을 경우, yyyyMMdd 형식으로 변환하여 VO에 저장
        if (businessProgressVO.getBsnBgngYmd() != null && !businessProgressVO.getBsnBgngYmd().isEmpty()) {
            Date date = sdfInput.parse(businessProgressVO.getBsnBgngYmd());
            String formattedBsnBgngYmd = sdfOutput.format(date);
            businessProgressVO.setBsnBgngYmd(formattedBsnBgngYmd);
        }
        
        log.info("businessProgressVO 확인2 : ");
        
        // 영업 종료일(bsnEndYmd)가 있을 경우, yyyyMMdd 형식으로 변환하여 VO에 저장
        if (businessProgressVO.getBsnEndYmd() != null && !businessProgressVO.getBsnEndYmd().isEmpty()) {
        	Date date = sdfInput.parse(businessProgressVO.getBsnEndYmd());
        	String formattedBsnEndYmd = sdfOutput.format(date);
        	businessProgressVO.setBsnEndYmd(formattedBsnEndYmd);
        }
        
        log.info("businessProgressVO 확인3" + businessProgressVO);
	
        int result = this.businessProgressServie.businessInsert(businessProgressVO);
		log.info("insert 결과 : " + result);
		
		return result;
	}
	
	// 영업 진척도 상세
	@GetMapping("/detail")
	public String businessDetail(Model model,
								 @RequestParam("bsnNm") String bsnNm) {
		
		log.info("detail 컨트롤러 확인");
		
		BusinessProgressVO businessProgressVO = this.businessProgressServie.businessDetail(bsnNm);
		log.info("businessProgressVO 확인 : " + businessProgressVO);
		
		model.addAttribute("businessProgressVO", businessProgressVO);
		
		return "bsn/businessProgress/detail";
	}
	
	// 영업 진척도 수정 페이지로
	@GetMapping("/update")
	public String businessUpdate(Model model,
								 @RequestParam("manageNo") String manageNo) {
		
		log.info("manageNo 확인 : " + manageNo);
		
		BusinessProgressVO businessProgressVO = this.businessProgressServie.businessUpdate(manageNo);
		model.addAttribute("businessProgressVO", businessProgressVO);
		log.info("businessProgressVO update 확인 : " + businessProgressVO);
		
		return "bsn/businessProgress/update";
	}
	
	// 영업 진척도 수정 실행
	@PostMapping("/updatePost")
	public String businessUpdatePost(@ModelAttribute BusinessProgressVO businessProgressVO) {
		
		log.info("businessProgressVO 확인 : " + businessProgressVO);
		
		int result = this.businessProgressServie.businessUpdatePost(businessProgressVO);
		log.info("resutl 확인 : " + result);
		
		return "redirect:/businessProgress/list";
	}
	
	// 영업 진척도 삭제 실행
	@PostMapping("/deletePost")
	public String businessDeletePost(@RequestParam("bsnNm") String bsnNm) {
		
		int result = this.businessProgressServie.businessDeletePost(bsnNm);
		log.info("result 확인 : " + result);
		
		return "redirect:/businessProgress/list";
	}
	
}
