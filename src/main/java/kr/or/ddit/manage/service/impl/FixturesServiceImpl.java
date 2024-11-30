package kr.or.ddit.manage.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.mapper.FixturesMapper;
import kr.or.ddit.manage.service.FixturesService;
import kr.or.ddit.manage.vo.FixturesUseLedgerVO;
import kr.or.ddit.manage.vo.FixturesVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FixturesServiceImpl implements FixturesService {
	
	@Inject
	FixturesMapper fixturesMapper;
	
	@Inject
	UploadController uploadController;
	
	// 비품 목록 조회
	@Override
	public List<FixturesVO> list(Map<String, Object> map) {
		return this.fixturesMapper.list(map);
	}
	
	// 비품 정보 수정
	@Override
	public int update(FixturesVO fixturesVO) {
		
		int result = 0;
		
		
		MultipartFile[] multipartFiles = fixturesVO.getUploadFiles();
		
		//안전장치.
		//파일이 있을 때만 1.2.를 시행함
		if(multipartFiles!=null && multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);		
			log.info("registPost->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록
			fixturesVO.setFileGroupNo(fileGroupNo);		
		}
		
		//수정할 데이 중 파일이 없다면 fileGroupNo의 값은 0(null)임
		result += this.fixturesMapper.update(fixturesVO);
		
		return result;
	}
	
	// 비품 등록
	@Override
	public int registPost(FixturesVO fixturesVO) {
		
		int result = 0;
		
		
		MultipartFile[] multipartFiles = fixturesVO.getUploadFiles();
		
		//안전장치.
		//파일이 있을 때만 1.2.를 시행함
		if(multipartFiles!=null && multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);		
			log.info("registPost->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록
			fixturesVO.setFileGroupNo(fileGroupNo);		
		}
		
		//수정할 데이 중 파일이 없다면 fileGroupNo의 값은 0(null)임
		result += this.fixturesMapper.registPost(fixturesVO);
		
		return result;				
	}
	
	// 비품 삭제 
	@Override
	public int deleteAjax(Map<String, Object> params) {
		return this.fixturesMapper.deleteAjax(params);
	}
	
	// 전체 비품 수 조회
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.fixturesMapper.getTotal(map);
	}

	// <공통 코드> 비품 위치 코드 목록 조회
	@Override
	public List<CommonCodeVO> getPositions() {
		return this.fixturesMapper.getPositions();
	}

	// <공통 코드> 비품 상태 코드 목록 조회
	@Override
	public List<CommonCodeVO> getStatuses() {
		return this.fixturesMapper.getStatuses();
	}

	// 파일 상세 정보 조회
	//{"fileGroupNo":fileGroupNo}
	@Override
	public List<FileDetailVO> getFileDetails(int fileGroupNo) {
		return this.fixturesMapper.getFileDetails(fileGroupNo);
	}
	
	// 비품 사용 관리 대장 목록 조회
	@Override
	public List<FixturesUseLedgerVO> fixturesLedgerList(Map<String, Object> map) {
		return this.fixturesMapper.fixturesLedgerList(map);
	}

	@Override
	public int getLedgerTotal(Map<String, Object> map) {
		return this.fixturesMapper.getLedgerTotal(map);
	}

	@Override
	public List<EmployeeVO> empList() {
		return this.fixturesMapper.empList();
	}

	@Override
	public int registFxtLedger(FixturesUseLedgerVO fixturesUseLedgerVO) {
		return this.fixturesMapper.registFxtLedger(fixturesUseLedgerVO);
	}

	// 자동 완성 기능을 위한 데이터 조회
	@Override
	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap) {
		String fxtrsNm = (String) paramMap.get("fxtrsNm");
		paramMap.put("fxtrsNm", fxtrsNm + "%");
		return this.fixturesMapper.autocomplete(paramMap);
	}

	@Override
	public int updateFxtLedger(FixturesUseLedgerVO fixturesUseLedgerVO) {
		return this.fixturesMapper.updateFxtLedger(fixturesUseLedgerVO);
	}

	@Override
	public int getCount() {
		return this.fixturesMapper.getCount();
	}

	@Override
	public Map<String, Object> dashYear() {
		return this.fixturesMapper.dashYear();
	}

	@Override
	public Map<String, Object> currentYearCount() {
		return this.fixturesMapper.currentYearCount();
	}

	@Override
	public String currentDate() {
		return this.fixturesMapper.currentDate();
	}

	@Override
	public int statusInA() {
		return this.fixturesMapper.statusInA();
	}

	@Override
	public int statusInU() {
		return this.fixturesMapper.statusInU();
	}

	@Override
	public int statusU() {
		return this.fixturesMapper.statusU();
	}


}
