package kr.or.ddit.manage.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.FixturesUseLedgerVO;
import kr.or.ddit.manage.vo.FixturesVO;

public interface FixturesMapper {

	// 비품 목록 조회
	public List<FixturesVO> list(Map<String, Object> map);
	
    // 비품 정보 수정
	public int update(FixturesVO fixturesVO);

	// 비품 등록 
	public int registPost(FixturesVO fixturesVO);

	// 비품 삭제
	public int deleteAjax(Map<String, Object> params);

	// 전체 비품 수 조회
	public int getTotal(Map<String, Object> map);

	//위치 코드 목록 조회
	public List<CommonCodeVO> getPositions();

	// 상태 코드 목록 조회
	public List<CommonCodeVO> getStatuses();

	// 파일 상세 정보 조회
	//{"fileGroupNo":fileGroupNo}
	public List<FileDetailVO> getFileDetails(int fileGroupNo);
	
	// 비품 사용 관리 대장 목록 조회
	public List<FixturesUseLedgerVO> fixturesLedgerList(Map<String, Object> map);

	public int getLedgerTotal(Map<String, Object> map);

	public List<EmployeeVO> empList();

	public int registFxtLedger(FixturesUseLedgerVO fixturesUseLedgerVO);

	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap);

	public int updateFxtLedger(FixturesUseLedgerVO fixturesUseLedgerVO);

	public int getCount();

	public Map<String, Object> dashYear();

	public Map<String, Object> currentYearCount();

	public String currentDate();

	public int statusInA();

	public int statusInU();

	public int statusU();
}
