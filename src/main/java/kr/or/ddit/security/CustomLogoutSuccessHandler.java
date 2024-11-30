package kr.or.ddit.security;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {
	
	/**
	 * 사용자 정의 로그아웃 성공 핸들러
	 * 로그아웃 성공 시 세션 무효화 및 로그인 페이지로 리다이렉션을 처리
	 */
	
    @Override
    public void onLogoutSuccess(HttpServletRequest request, 
                                HttpServletResponse response, 
                                Authentication auth) throws IOException, ServletException {
        
        // 인증 객체가 존재하고 세부 정보가 있는 경우 세션 무효화
        if (auth != null && auth.getDetails() != null) {
            try {
                // 현재 세션 무효화
                request.getSession().invalidate();
            } catch (Exception e) {
                // 세션 무효화 중 발생한 예외 처리
                e.printStackTrace();
            }
        }
        
        // 응답 상태를 OK로 설정
        response.setStatus(HttpServletResponse.SC_OK);
        
        // 로그인 페이지로 리다이렉션
        response.sendRedirect("/login");
    }
}


