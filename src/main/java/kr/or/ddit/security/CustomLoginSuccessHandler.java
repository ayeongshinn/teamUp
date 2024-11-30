package kr.or.ddit.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomLoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    /**
     * 로그인 성공 후 호출되는 메소드
     * 로그인한 사용자 정보를 로그에 기록하고, 권한 목록을 추출하여 출력
     * @param request - HttpServletRequest 객체
     * @param response - HttpServletResponse 객체
     * @param auth - 인증 정보
     * @throws ServletException
     * @throws IOException
     */
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth) 
    		throws ServletException, IOException {
        
        // 로그인 성공 로그 출력
        log.info("onAuthenticationSuccess : 로그인 성공");

        // 인증된 사용자 정보 가져오기 (User 객체)
        User customUser = (User) auth.getPrincipal();

        // 사용자명 출력
        log.info("username : " + customUser.getUsername());

        // 사용자 권한 목록을 리스트에 저장
        List<String> roleNames = new ArrayList<>();
        auth.getAuthorities().forEach(authority -> {
            roleNames.add(authority.getAuthority());
        });

        // 권한 목록 출력
        log.info("roleNames : " + roleNames);

        // 기본 로그인 성공 처리 (SavedRequestAwareAuthenticationSuccessHandler가 제공하는 기본 로직 실행)
        super.onAuthenticationSuccess(request, response, auth);
    }
}

