package kr.or.ddit.security;

import java.util.Date;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.context.annotation.PropertySource;

import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.*;
import com.nimbusds.jwt.*;

@Component
@PropertySource("classpath:application.properties")
public class JwtUtilNimbus {

    @Value("${jwt.secret-key}") // application.properties에서 jwt.secret-key 값을 주입받음
    private String secretKey;

    // JWT 생성
    public String createToken(String empNo) throws Exception {
        JWSSigner signer = new MACSigner(secretKey.getBytes()); // 주입받은 secretKey 사용

        // JWT에 empNo 포함
        JWTClaimsSet claimsSet = new JWTClaimsSet.Builder()
                .subject(empNo) // empNo를 토큰의 주체로 설정
                .issueTime(new Date()) // 토큰 발급 시간
                .expirationTime(new Date(System.currentTimeMillis() + 3600000)) // 1시간 유효
                .build();

        SignedJWT signedJWT = new SignedJWT(
                new JWSHeader(JWSAlgorithm.HS256),
                claimsSet
        );

        signedJWT.sign(signer); // 서명 생성
        return signedJWT.serialize(); // JWT 문자열 반환
    }

    // JWT 검증
    public boolean validateToken(String token) throws Exception {
        SignedJWT signedJWT = SignedJWT.parse(token);
        JWSVerifier verifier = new MACVerifier(secretKey.getBytes()); // 주입받은 secretKey 사용

        // 토큰 서명과 유효기간 검증
        return signedJWT.verify(verifier) &&
               new Date().before(signedJWT.getJWTClaimsSet().getExpirationTime());
    }

    // empNo 추출
    public String getEmpNoFromToken(String token) throws Exception {
        SignedJWT signedJWT = SignedJWT.parse(token);
        return signedJWT.getJWTClaimsSet().getSubject(); // 주체에서 empNo 반환
    }
}
