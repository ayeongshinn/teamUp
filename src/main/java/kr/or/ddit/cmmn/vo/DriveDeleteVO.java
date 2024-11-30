package kr.or.ddit.cmmn.vo;

import java.util.List;

import lombok.Data;

@Data
public class DriveDeleteVO {
	private List<String> files; // 선택된 파일명 리스트
    private String folderPath;   // 폴더 경로
}
