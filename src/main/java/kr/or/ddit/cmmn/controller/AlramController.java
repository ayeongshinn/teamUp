package kr.or.ddit.cmmn.controller;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.AlramService;
import kr.or.ddit.cmmn.vo.AlramVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/cmmn")
public class AlramController {

    @Autowired
    AlramService alramService;
    
 // 로그인된 사용자의 알림 리스트 조회 API
    @GetMapping("/list")
    @ResponseBody
    public List<AlramVO> list() {
        // 로그인된 사용자 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String empNo = authentication.getName(); // 로그인된 사용자의 empNo
        log.info("로그인한 사용자 empNo: {}", empNo);

        // 사용자의 알림 목록 조회
        List<AlramVO> alramListVO = alramService.alramList(empNo);
        log.info("조회된 알림 목록: {}", alramListVO);

        return alramListVO; // 알림 목록 반환
    }
    
 // 알림 클릭 시 읽음 상태 업데이트 API
    @PostMapping("/updateCheck")
    @ResponseBody
    public String updateCheck(@RequestParam("ntcnNo") String ntcnNo) {
        log.info("알림 클릭: NTCN_NO = {}", ntcnNo);

        try {
            int result = alramService.alramClick(ntcnNo);
            if (result > 0) {
                log.info("알림 읽음 상태 업데이트 성공: NTCN_NO = {}", ntcnNo);
                return "success";
            } else {
                log.error("알림 읽음 상태 업데이트 실패: NTCN_NO = {}", ntcnNo);
                return "fail";
            }
        } catch (Exception e) {
            log.error("알림 업데이트 중 오류 발생: NTCN_NO = {}", ntcnNo, e);
            return "error";
        }
    }
    
    
}

 