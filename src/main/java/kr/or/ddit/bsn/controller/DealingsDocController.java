package kr.or.ddit.bsn.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.bsn.service.DealingsDocService;
import kr.or.ddit.bsn.vo.CounterPartyVO;
import kr.or.ddit.bsn.vo.CustomerVO;
import kr.or.ddit.bsn.vo.DealingsDocVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/dealingsDoc")
@Slf4j
@Controller
public class DealingsDocController {

	@Inject
	DealingsDocService dealingsDocService;

	@Inject
	UploadController uploadController;

	// 서류 리스트
	@GetMapping("/list")
	public String delingsDocList(Model model,
			@RequestParam(value = "category", required = false, defaultValue = "") String category,
			@RequestParam(value = "gubun", required = false, defaultValue = "") String gubun,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {

		// 페이징 처리 및 검색
		Map<String, Object> map = new HashMap<>();
		map.put("category", category);
		map.put("gubun", gubun);
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		log.info("map 확인 : " + map);

		// 서류 리스트용
		List<DealingsDocVO> dealingsDocVOList = this.dealingsDocService.dealingsDocList(map);
		log.info("dealingsDocVOList 확인 : " + dealingsDocVOList);
		model.addAttribute("dealingsDocVOList", dealingsDocVOList);

		// 카테고리 목록 및 조회
		List<Map<String, Object>> categories = dealingsDocService.getCategories();
		model.addAttribute("categories", categories);

		// 전체 행의 수
		int total = this.dealingsDocService.getTotal(map);

		// 페이지네이션 객체
		ArticlePage<DealingsDocVO> articlePage = new ArticlePage<>(total, currentPage, 10, dealingsDocVOList, keyword);
		model.addAttribute("articlePage", articlePage);

		// 승인 건수
		model.addAttribute("getPass", dealingsDocService.getPass());
		model.addAttribute("getReturn", dealingsDocService.getReturn());
		model.addAttribute("getHold", dealingsDocService.getHold());
		model.addAttribute("getCurrent", dealingsDocService.getCurrent());

		return "bsn/dealingsDoc/list";
	}

	// 서류 상세 조회
	@GetMapping("detail")
	@ResponseBody
	public Map<String, Object> dealingsDocDetail(@RequestParam("docNo") String docNo) {

		DealingsDocVO dealingsDocVO = dealingsDocService.dealingsDocDetail(docNo);
		Map<String, Object> response = new HashMap<>();
		response.put("dealingsDocVO", dealingsDocVO);

		return response;
	}

	// 계약서 검토 요청 등록 폼으로 이동
	@GetMapping("/regist")
	public String dealingsDocRegist(Model model) {

		List<DealingsDocVO> indutynmList = dealingsDocService.indutynmList();
		model.addAttribute("indutynmList", indutynmList);

		return "bsn/dealingsDoc/regist";
	}
	
	// 계약서 검토 요청 등록 실행
	@PostMapping("/dealRegistPost")
	public String dealRegistPost(Model model,
	                             @ModelAttribute DealingsDocVO dealingsDocVO,
	                             @RequestParam("uploadFile") MultipartFile[] uploadFiles,
	                             @RequestParam("radioBtn") String radioSelection,
	                             @RequestParam(value = "custCtrtCnclsYmd", required = false) String custCtrtCnclsYmd,
	                             @RequestParam(value = "counterCtrtCnclsYmd", required = false) String counterCtrtCnclsYmd) {

	    log.info("dealingsDocVO 확인 : " + dealingsDocVO);
	    log.info("선택한 radioBtn 확인 : " + radioSelection);
	    
        try {
        	
            // 날짜 형식 변환을 위한 준비 (입력 받은 yyyy-MM-dd 형식 -> yyyyMMdd 형식으로 변환)
            SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sdfOutput = new SimpleDateFormat("yyyyMMdd");

            // 작성 일자(WrtYmd)가 있을 경우, yyyyMMdd 형식으로 변환하여 VO에 저장
            if (dealingsDocVO.getWrtYmd() != null && !dealingsDocVO.getWrtYmd().isEmpty()) {
                Date date = sdfInput.parse(dealingsDocVO.getWrtYmd());
                String formattedWrtYmd = sdfOutput.format(date);
                dealingsDocVO.setWrtYmd(formattedWrtYmd);
            }
            
            if (dealingsDocVO.getCustCtrtCnclsYmd() != null && !dealingsDocVO.getCustCtrtCnclsYmd().isEmpty()) {
            	Date date = sdfInput.parse(dealingsDocVO.getCustCtrtCnclsYmd());
            	String formattedgetCustCtrtCnclsYmd = sdfOutput.format(date);
            	dealingsDocVO.setCustCtrtCnclsYmd(formattedgetCustCtrtCnclsYmd);
            }
            
            if (dealingsDocVO.getCounterCtrtCnclsYmd() != null && !dealingsDocVO.getCounterCtrtCnclsYmd().isEmpty()) {
            	Date date = sdfInput.parse(dealingsDocVO.getCounterCtrtCnclsYmd());
            	String formattedgetCounterCtrtCnclsYmd = sdfOutput.format(date);
            	dealingsDocVO.setCounterCtrtCnclsYmd(formattedgetCounterCtrtCnclsYmd);
            }

            // 계약서 등록 처리
            int result = dealingsDocService.dealRegistPost(dealingsDocVO, radioSelection);
            
            // 결과 확인
            if (result > 0) {
                log.info("계약서 등록 및 거래처/고객 등록 성공");
                return "redirect:/dealingsDoc/list";
            } else {
                log.info("계약서 등록 실패");
                return "bsn/dealingsDoc/regist";
            }

        } catch (Exception e) {
            log.error("오류 발생: ", e);
            return "bsn/dealingsDoc/regist";
        }
    }
	
	// 파일 상세
	@ResponseBody
	@PostMapping("/getFileDetails")
	public List<FileDetailVO> getFileDetails(int fileGroupNo) {

		log.info("fileGroupNo 확인 : " + fileGroupNo);

		List<FileDetailVO> fileDetailVOList = this.dealingsDocService.getFileDetails(fileGroupNo);
		log.info("fileDetailVOList 확인 : " + fileDetailVOList);

		return fileDetailVOList;
	}

	// 요청 리스트 조회
	@GetMapping("/requestList")
	public String requestList(Model model, String docNo) {

		List<DealingsDocVO> dealingsDocVOList = dealingsDocService.requestList(docNo);
		model.addAttribute("dealingsDocVOList", dealingsDocVOList);

		model.addAttribute("getHold", dealingsDocService.getHold());
		model.addAttribute("getCurrentPass", dealingsDocService.getCurrentPass());
		model.addAttribute("getCurrentHold", dealingsDocService.getCurrentHold());
		model.addAttribute("getCurrent", dealingsDocService.getCurrent());

		return "bsn/dealingsDoc/requestlist";
	}
	
	// 계약서 검토 상세 페이지
	@GetMapping("/dealDetail")
	public String dealDetail(Model model, @RequestParam("docNo") String docNo, HttpSession session) {
	    DealingsDocVO dealingsDocVO = dealingsDocService.dealingsDocDetail(docNo);
	    String radioSelection = (String) session.getAttribute("radioSelection");

	    if (dealingsDocVO == null || radioSelection == null) {
	        return "redirect:/dealingsDoc/list";
	    }

	    model.addAttribute("dealingsDocVO", dealingsDocVO);

	    if ("counterparty".equals(radioSelection)) {
	        CounterPartyVO counterparty = (CounterPartyVO) session.getAttribute("counterpartyVO");
	        model.addAttribute("counterparty", counterparty);
	    } else if ("customer".equals(radioSelection)) {
	        CustomerVO customer = (CustomerVO) session.getAttribute("customerVO");
	        model.addAttribute("customer", customer);
	    }

	    return "bsn/dealingsDoc/detail";
	}
}
