package kr.or.ddit.security;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.access.AccessDeniedHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {
    
	/**
	 * 사용자 정의 접근 거부 핸들러
	 * 권한이 없는 리소스에 접근 시 동작
	 */
	
    @Override    
    public void handle(HttpServletRequest request, HttpServletResponse response,
            AccessDeniedException accessDeniedException) throws IOException, ServletException {
        
        // 현재 인증된 사용자 정보 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        // 요청 관련 정보를 맵에 저장
        Map<String, Object> requestInfo = new HashMap<>();
        requestInfo.put("remoteAddr", request.getRemoteAddr());
        requestInfo.put("requestURI", request.getRequestURI());
        requestInfo.put("serverName", request.getServerName());
        requestInfo.put("serverPort", request.getServerPort());
        requestInfo.put("contextPath", request.getContextPath());
        
        // 접근 거부 관련 로그 기록
        log.info("Access Denied for user: {}", auth != null ? auth.getName() : "Anonymous");
        log.info("Authorities: {}", auth != null ? auth.getAuthorities() : "None");
        log.info("Request URI: {}", request.getRequestURI());
        log.info("Access Denied Exception: {}", accessDeniedException.getMessage());
        log.info("Request Info: {}", requestInfo);
        
        // 접근 거부 페이지로 리다이렉트
        response.sendRedirect("/accessError");
    }
}

