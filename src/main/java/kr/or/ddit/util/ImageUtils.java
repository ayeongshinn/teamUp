package kr.or.ddit.util;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.imageio.ImageIO;
import org.springframework.web.multipart.MultipartFile;

public class ImageUtils {

    // 이미지 크기 조정 메서드
	public static byte[] resizeImage(MultipartFile imageFile, int width, int height) throws IOException {
        // 이미지를 BufferedImage로 변환
        BufferedImage originalImage = ImageIO.read(imageFile.getInputStream());
        
        // 투명도(알파 채널)를 포함한 이미지 타입 설정
        BufferedImage resizedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        
        // Graphics2D 객체를 사용하여 이미지를 그리기 (투명도 포함)
        Graphics2D g2d = resizedImage.createGraphics();
        g2d.drawImage(originalImage.getScaledInstance(width, height, Image.SCALE_SMOOTH), 0, 0, null);
        g2d.dispose();
        
        // 변환된 이미지를 ByteArrayOutputStream에 저장
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(resizedImage, "png", baos);
        baos.flush();
        byte[] imageInByte = baos.toByteArray();
        baos.close();

        return imageInByte;
    }
}
