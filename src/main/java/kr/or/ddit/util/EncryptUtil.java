package kr.or.ddit.util;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class EncryptUtil {
	
    private static final String ALGORITHM = "AES";
    // 공백이 있을 경우 trim()을 통해 제거한 후 키를 설정
    private static final String KEY = "my-secret-key-12".trim(); // 공백 제거 적용

    static {
        // 키의 길이 출력
        System.out.println("AES Key length: " + KEY.getBytes().length + " bytes");
    }

    public static String encrypt(String data) throws Exception {
        System.out.println("EncryptUtil.encrypt() called");
        SecretKeySpec secretKey = new SecretKeySpec(KEY.getBytes("UTF-8"), ALGORITHM);
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        return Base64.getEncoder().encodeToString(cipher.doFinal(data.getBytes()));
    }


    public static String decrypt(String encryptedData) throws Exception {
        SecretKeySpec secretKey = new SecretKeySpec(KEY.getBytes("UTF-8"), ALGORITHM);
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, secretKey);
        return new String(cipher.doFinal(Base64.getDecoder().decode(encryptedData)));
    }
}

