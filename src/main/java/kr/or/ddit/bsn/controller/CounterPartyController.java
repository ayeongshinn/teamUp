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

import kr.or.ddit.bsn.service.CounterPartyService;
import kr.or.ddit.bsn.vo.CounterPartyVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

// 거래처 주소록 컨트롤러 :: 이재현

@RequestMapping("/counterparty")
@Slf4j
@Controller
public class CounterPartyController {
	
	@Inject
	CounterPartyService counterPartyService;
	
	// 거래처 리스트
	@GetMapping("/list")
	public String counterparty(Model model,
								@RequestParam(value = "category", required = false, defaultValue = "") String category,
								@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
								@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage
								) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category", category);
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		
		List<CounterPartyVO> counterPartyVOList = this.counterPartyService.counterPartyList(map);
		
		log.info("counterPartyVOList 확인 :" + counterPartyVOList);
		
		model.addAttribute("counterPartyVOList", counterPartyVOList);
		
		// 전체 행의 수
		int total = this.counterPartyService.getTotal(map);
		log.info("list => total : " + total);
		
		// 페이지네이션 객체
		ArticlePage<CounterPartyVO> articlePage = 
				new ArticlePage<CounterPartyVO>(total, currentPage, 10, counterPartyVOList, keyword);
		
		model.addAttribute("articlePage", articlePage);
		
		// 전체 계약 수
		int ctrtTotal = this.counterPartyService.ctrtTotal();
		log.info("ctrtTotal 확인 : " + ctrtTotal);
		model.addAttribute("ctrtTotal", ctrtTotal);
		
		// 당월 계약 수
		int ctrtMonth = this.counterPartyService.ctrtMonth();
		log.info("ctrtMonth 확인 : " + ctrtMonth);
		model.addAttribute("ctrtMonth", ctrtMonth);
		
		// 전월 계약 수
		int ctrtBeforeMonth = this.counterPartyService.ctrtBeforeMonth();
		log.info("ctrtBeforeMonth 확인 : " + ctrtBeforeMonth);
		model.addAttribute("ctrtBeforeMonth", ctrtBeforeMonth);
		
		// 전월 대비 계약률
		double ctrtChange =  (ctrtMonth / (double)ctrtBeforeMonth) * 100;
		log.info("ctrtChange 확인 : " + ctrtChange);
		
		model.addAttribute("ctrtChange", ctrtChange);
		
		return "bsn/counterparty/list";
	}
	
	// 거래처 등록 폼 이동
	@GetMapping("/regist")
	public String counterRegist(Model model) {
		
		List<CounterPartyVO> indutynmList = counterPartyService.indutynmList();
		
		model.addAttribute("indutynmList", indutynmList);
		
		return "bsn/counterparty/regist";
	}
	
	// 거래처 등록 실행
	@PostMapping("/registPost")
	public String registPost(@ModelAttribute CounterPartyVO counterPartyVO) {
		
		log.info("counterPartyVO 확인 : " + counterPartyVO);
		
		int result = this.counterPartyService.registPost(counterPartyVO);
		log.info("result 확인 : " + result);
		
		return "redirect:/counterparty/list";
	}
	
	// 거래처 상세 조회
	@GetMapping("/detail")
	@ResponseBody  // JSON 응답을 반환하도록 설정
	public Map<String, Object> showCounterpartyDetail(@RequestParam("cnptNo") String cnptNo) {
	    CounterPartyVO counterPartyVO = counterPartyService.detail(cnptNo);
	    
	    // JSON으로 응답을 구성
	    Map<String, Object> response = new HashMap<>();
	    response.put("counterPartyVO", counterPartyVO);
	    
	    return response;  // JSON 응답 반환
	}
	
	// 거래처 수정 실행
    @PostMapping("/update")
    @ResponseBody
    public String updateCounterParty(@ModelAttribute CounterPartyVO counterPartyVO) {
        
    	log.info("수정 counterPartyVO 확인 : " + counterPartyVO);
    	
    	// update 결과 처리
        int result = counterPartyService.updateCounterParty(counterPartyVO);
        if (result > 0) {
            return "success";
        } else {
            return "fail";
        }
    }
	
	// 거래처 주소록 삭제 실행
    @PostMapping("/deletePost")
    @ResponseBody // Ajax로 결과 반환 시 필요
    public String deletePost(@RequestParam("cnptNo") String cnptNo) {
        log.info("삭제할 거래처 번호: " + cnptNo);

        try {
            // 삭제 로직 실행
            int result = counterPartyService.deletePost(cnptNo); // cnptNo를 기반으로 삭제
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
