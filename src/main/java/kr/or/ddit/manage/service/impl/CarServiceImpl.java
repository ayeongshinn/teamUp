package kr.or.ddit.manage.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.mapper.CarMapper;
import kr.or.ddit.manage.service.CarService;
import kr.or.ddit.manage.vo.CarUseLedgerVO;
import kr.or.ddit.manage.vo.CarVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class CarServiceImpl implements CarService {
	
	@Inject
	CarMapper carMapper;
	
	@Inject
	UploadController uploadController;
	
	// 차량 목록 조회
	@Override
	public List<CarVO> list(Map<String, Object> map) {
		return this.carMapper.list(map);
	}
	
	// 전체 차량 수 조회
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.carMapper.getTotal(map);
	}
	
	// 파일 상세 정보 조회
	@Override
	public List<FileDetailVO> getFileDetails(int fileGroupNo) {
		return this.carMapper.getFileDetails(fileGroupNo);
	}
	
	// <공통 코드> 차량 상태 코드 목록 조회
	@Override
	public List<CommonCodeVO> getSttus() {
		return this.carMapper.getSttus();
	}

	// <공통 코드> 차량 차종 코드 목록 조회
	@Override
	public List<CommonCodeVO> getCarMdl() {
		return this.carMapper.getCarMdl();
	}

	// <공통 코드> 차량 제조사 코드 목록 조회
	@Override
	public List<CommonCodeVO> getMkr() {
		return this.carMapper.getMkr();
	}
	
	// 차량 정보 수정
	@Override
	public int update(CarVO carVO) {
		
		int result = 0;
		
		
		MultipartFile[] multipartFiles = carVO.getUploadFiles();
		
		//안전장치.
		//파일이 있을 때만 1.2.를 시행함
		if(multipartFiles!=null && multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);		
			log.info("registPost->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록
			carVO.setFileGroupNo(fileGroupNo);	
		}
		
		result += this.carMapper.update(carVO);
		
		return result;

	}
	
	// 차량 정보 삭제
	@Override
	public int deleteAjax(Map<String, Object> params) {
		return this.carMapper.deleteAjax(params);
	}
	
	// 차량 정보 등록
	@Override
	public int registPost(CarVO carVO) {
		
		
		int result = 0;
		
		
		MultipartFile[] multipartFiles = carVO.getUploadFiles();
		
		//안전장치.
		//파일이 있을 때만 1.2.를 시행함
		if(multipartFiles!=null && multipartFiles[0].getOriginalFilename().length()>0) {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);		
			log.info("registPost->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록
			carVO.setFileGroupNo(fileGroupNo);	
		}
		
		result += this.carMapper.registPost(carVO);
		
		return result;
	}
	
	// 차량 관리 대장 목록 조회
	@Override
	public List<CarUseLedgerVO> carLedgerList(Map<String, Object> map) {
		return this.carMapper.carLedgerList(map);
	}
	
	// 차량 관리 대장 총 개수 조회
	@Override
	public int getLedgerTotal(Map<String, Object> map) {
		return this.carMapper.getLedgerTotal(map);
	}

	// 직원 목록 조회
	@Override
	public List<EmployeeVO> empList() {
		return this.carMapper.empList();
	}

	// 차량 목록 조회
	@Override
	public List<CarVO> carList() {
		return this.carMapper.carList();
	}

	// <공통 코드> 부서 코드 목록 조회
	@Override
	public List<CommonCodeVO> deptList() {
		return this.carMapper.deptList();
	}

	// 차량 관리 대장 등록
	@Override
	public int registLedger(CarUseLedgerVO carUseLedgerVO) {
		return this.carMapper.registLedger(carUseLedgerVO);
	}

	// 차량 관리 대장 수정
	@Override
	public int updateLedger(CarUseLedgerVO carUseLedgerVO) {
		return this.carMapper.updateLedger(carUseLedgerVO);
	}
	
	@Override
	public int getCount() {
		return this.carMapper.getCount();
	}

	@Override
	public Map<String, Object> dashYear() {
		return this.carMapper.dashYear();
	}

	@Override
	public Map<String, Object> currentYearCount() {
		return this.carMapper.currentYearCount();
	}

	@Override
	public String currentDate() {
		return this.carMapper.currentDate();
	}

	@Override
	public int statusInA() {
		return this.carMapper.statusInA();
	}

	@Override
	public int statusInU() {
		return this.carMapper.statusInU();
	}

	@Override
	public int statusU() {
		return this.carMapper.statusU();
	}

}
