package kr.or.ddit.cmmn.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.ApprovalService;
import kr.or.ddit.hr.service.EmployeeService;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class empAddressController {
    
    @Inject
    private EmployeeService employeeService;
    
    private static final int PAGE_SIZE = 20; // 한 페이지에 가져올 데이터 수
    
/*
    // 주소록 페이지 호출
    @GetMapping("/addressList")
    public String addressList(Model model,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "keyword", defaultValue = "") String keyword) {

        int offset = (currentPage - 1) * PAGE_SIZE;
        Map<String, Object> pagingMap = createPagingMap(offset, PAGE_SIZE);
        pagingMap.put("keyword", keyword);
        
        // 직원 목록 가져오기
//        List<EmployeeVO> employeeVOList = this.employeeService.getEmpList();
//        log.debug("Loaded employeeVOList size: {}", employeeVOList.size());
//        model.addAttribute("employeeVOList", employeeVOList);

        // 주소 리스트 가져오기
        List<EmployeeVO> addressList = employeeService.addressList(pagingMap);
        log.debug("Loaded addressList size: {}", addressList.size());
        model.addAttribute("addressList", addressList);
        
        return "cmmn/empAddress/addressList";
    }
*/

    // 비동기로 페이지별 직원 리스트 가져오기
    @GetMapping("/addressListSelect")
    @ResponseBody
    public List<EmployeeVO> addressListSelect(@RequestParam(value = "page", defaultValue = "1") int currentPage,
    					@RequestParam(value = "keyword", defaultValue = "") String keyword) {

        int offset = (currentPage - 1) * PAGE_SIZE;
        Map<String, Object> pagingMap = createPagingMap(offset, PAGE_SIZE);
        pagingMap.put("keyword", keyword);
        log.info("keyword ===============> {}", keyword);
        // 비동기로 해당 페이지에 대한 직원 목록 가져오기
        List<EmployeeVO> employeeVOList = employeeService.addressList(pagingMap);
        log.debug("Loaded employeeVOList size for page {}: {}", currentPage, employeeVOList.size());

        return employeeVOList; // JSON 형태로 반환
    }
    
    @PostMapping("/getEmployeeByDept")
    @ResponseBody
    public List<EmployeeVO> getEmployeeByDept(@RequestParam("deptCd") String deptCd) {
        List<EmployeeVO> employeeList = this.employeeService.getEmployeeListByDept(deptCd); // 부서별 직원 목록을 가져오는 서비스 호출
        return employeeList;
    }

    // 페이징 관련 Map 생성 메서드
    private Map<String, Object> createPagingMap(int offset, int limit) {
        Map<String, Object> map = new HashMap<>();
        map.put("offset", offset);
        map.put("limit", limit);
        return map;
    }
    
    @GetMapping("/addressList")
    public String addressList(Model model,
                              @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
                              @RequestParam(value = "keyword", defaultValue = "") String keyword,
                              @RequestParam(value = "deptCd", defaultValue = "") String deptCd) {

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("keyword", keyword);
        map.put("currentPage", currentPage);
        map.put("deptCd", deptCd);
        
        // 직원 목록 가져오기
        List<EmployeeVO> employeeVOList = this.employeeService.getAddressList(map);
        int employeeTotal = this.employeeService.getAddressTotal(map);
        
        log.info("employeeVOList {}", employeeVOList);
        log.info("employeeTotal {}", employeeTotal);
        
        ArticlePage<EmployeeVO> articlePage =
                new ArticlePage<EmployeeVO>(employeeTotal, currentPage, 10, employeeVOList, keyword);
        
        model.addAttribute("employeeVOList", employeeVOList);
        model.addAttribute("articlePage", articlePage);

        return "cmmn/empAddress/addressList";
    }
}
