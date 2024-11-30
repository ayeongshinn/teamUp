package kr.or.ddit.security;

import org.springframework.security.crypto.password.PasswordEncoder;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder {

    /**
     * 개발 및 테스트 환경에서만 사용, 실제 운영 환경에서는 사용하지 말 것
     */

    @Override
    public String encode(CharSequence rawPassword) {
        // 비밀번호를 인코딩하지 않고 그대로 반환
        log.warn("Encoding password: {}", rawPassword);
        return rawPassword.toString();
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        // 원본 비밀번호와 저장된 비밀번호를 비교하여 일치 여부 반환
        log.warn("Checking password match: {} vs {}", rawPassword, encodedPassword);
        return rawPassword.toString().equals(encodedPassword);
    }
}

