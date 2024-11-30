package kr.or.ddit.manage.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.CarUseLedgerVO;
import kr.or.ddit.manage.vo.CarVO;

public interface CarService {
	
	// 차량 목록 조회
	public List<CarVO> list(Map<String, Object> map);

	// 전체 차량 수 조회
	public int getTotal(Map<String, Object> map);

	// 파일 상세 정보 조회
	public List<FileDetailVO> getFileDetails(int fileGroupNo);

	// <공통 코드> 차량 상태 코드 조회
	public List<CommonCodeVO> getSttus();

	// <공통 코드> 차량 차종 코드 조회
	public List<CommonCodeVO> getCarMdl();

	// <공통 코드> 차량 제조사 코드 조회
	public List<CommonCodeVO> getMkr();

	// 차량 정보 수정
	public int update(CarVO carVO);

	// 차량 정보 삭제
	public int deleteAjax(Map<String, Object> params);

	// 차량 정보 등록
	public int registPost(CarVO carVO);

	// 차량 관리 대장 목록 조회
	public List<CarUseLedgerVO> carLedgerList(Map<String, Object> map);

	// 차량 관리 대장 총 개수 조회
	public int getLedgerTotal(Map<String, Object> map);

	// 직원 목록 조회
	public List<EmployeeVO> empList();

	// 차량 목록 조회
	public List<CarVO> carList();

	// <공통 코드> 부서 코드 목록 조회
	public List<CommonCodeVO> deptList();

	// 차량 관리 대장 등록
	public int registLedger(CarUseLedgerVO carUseLedgerVO);

	// 차량 관리 대장 수정
	public int updateLedger(CarUseLedgerVO carUseLedgerVO);
	
	public int getCount();

	public Map<String, Object> dashYear();

	public Map<String, Object> currentYearCount();

	public String currentDate();

	public int statusInA();

	public int statusInU();

	public int statusU();

}
