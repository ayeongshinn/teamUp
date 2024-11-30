package kr.or.ddit.security;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CommonController {

    /**
     * 접근 거부 처리를 위한 컨트롤러
     * 접근 거부 시 호출되는 메서드
     * 
     * @param auth 현재 인증된 사용자의 인증 정보
     * @param model 뷰에 전달할 데이터를 담는 객체
     * @return 접근 거부 메시지를 표시할 뷰의 이름
     */
	
    @GetMapping("/accessError")
    public String accessDenied(Authentication auth, Model model) {
        // 접근 거부된 인증 정보를 로그에 기록
        log.info("접근 거부: {}", auth);

        // 뷰에 전달할 메시지 설정
        model.addAttribute("msg", "접근 거부됨");

        // 접근 거부 메시지를 표시할 뷰로 포워딩
        return "security/accessError";
    }
}