package kr.or.ddit.bsn.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.bsn.service.CustomerService;
import kr.or.ddit.bsn.vo.CustomerVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

// 거래처 주소록 컨트롤러 :: 이재현

@RequestMapping("/customer")
@Slf4j
@Controller
public class CustomerController {
	
	@Inject
	CustomerService customerService;
	
	// 고객 리스트
	@GetMapping("/list")
	public String customer(Model model,
								@RequestParam(value = "category", required = false, defaultValue = "") String category,
								@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
								@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage
								) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category", category);
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		
		List<CustomerVO> customerVOList = this.customerService.customerList(map);
		
		log.info("customerVOList 확인 :" + customerVOList);
		
		model.addAttribute("customerVOList", customerVOList);
		
		// 전체 행의 수
		int total = this.customerService.getTotal(map);
		log.info("list => total : " + total);
		
		// 페이지네이션 객체
		ArticlePage<CustomerVO> articlePage = 
				new ArticlePage<CustomerVO>(total, currentPage, 10, customerVOList, keyword);
		
		model.addAttribute("articlePage", articlePage);
		
		// 전체 계약 수
		int ctrtTotal = this.customerService.ctrtTotal();
		log.info("ctrtTotal 확인 : " + ctrtTotal);
		model.addAttribute("ctrtTotal", ctrtTotal);
		
		// 당월 계약 수
		int ctrtMonth = this.customerService.ctrtMonth();
		log.info("ctrtMonth 확인 : " + ctrtMonth);
		model.addAttribute("ctrtMonth", ctrtMonth);
		
		// 전월 계약 수
		int ctrtBeforeMonth = this.customerService.ctrtBeforeMonth();
		log.info("ctrtBeforeMonth 확인 : " + ctrtBeforeMonth);
		model.addAttribute("ctrtBeforeMonth", ctrtBeforeMonth);
		
		// 전월 대비 계약률
		double ctrtChange =  (ctrtMonth / (double)ctrtBeforeMonth) * 100;
		log.info("ctrtChange 확인 : " + ctrtChange);
		
		model.addAttribute("ctrtChange", ctrtChange);
		
		return "bsn/customer/list";
	}
	
	// 고객등록 폼 이동
	@GetMapping("/regist")
	public String customerRegist() {
		
		return "bsn/customer/regist";
	}
	
	// 고객 등록 실행
	@PostMapping("/registPost")
	public String registPost(@ModelAttribute CustomerVO customerVO) {
		
		log.info("customerVO 확인 : " + customerVO);
		
		int result = this.customerService.registPost(customerVO);
		log.info("result 확인 : " + result);
		
		return "redirect:/customer/list";
	}
	
	@GetMapping("/detail")
	@ResponseBody  // JSON 응답을 반환하도록 설정
	public Map<String, Object> detail(@RequestParam("custNo") String custNo) {
	    CustomerVO customerVO = customerService.detail(custNo);
	    
	    // JSON으로 응답을 구성
	    Map<String, Object> response = new HashMap<>();
	    response.put("customerVO", customerVO);
	    
	    return response;  // JSON 응답 반환
	}
	
	// 고객 주소록 수정 실행
    @PostMapping("/update")
    @ResponseBody
    public String updatePost(@ModelAttribute CustomerVO customerVO) {
        
    	log.info("수정 customerVO 확인 : " + customerVO);
    	
    	// update 결과 처리
        int result = customerService.updatePost(customerVO);
        if (result > 0) {
            return "success";
        } else {
            return "fail";
        }
    }
	
    // 고객 주소록 삭제 실행
    @PostMapping("/deletePost")
    @ResponseBody // Ajax로 결과 반환 시 필요
    public String deletePost(@RequestParam("custNo") String custNo) {
        log.info("삭제할 거래처 번호: " + custNo);

        try {
            // 삭제 로직 실행
            int result = customerService.deletePost(custNo); // custNo를 기반으로 삭제
            if (result > 0) {
                return "success";
            } else {
                return "fail"; // 삭제 실패 시
            }
        } catch (Exception e) {
            log.error("삭제 중 오류 발생", e);
            return "error"; // 서버 측 오류 시
        }
    }
	
}
