package kr.or.ddit.bsn.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.bsn.vo.CounterPartyVO;
import kr.or.ddit.bsn.vo.CustomerVO;
import kr.or.ddit.bsn.vo.DealingsDocVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;

public interface DealingsDocMapper {

    // 계약서 리스트 조회
    public List<DealingsDocVO> dealingsDocList(Map<String, Object> map);

    // 계약서 등록 실행
    public int dealRegistPost(DealingsDocVO dealingsDocVO);

    // 파일 상세 조회
    public List<FileDetailVO> getFileDetails(int fileGroupNo);

    // 승인 건수 조회
    public int getPass();

    // 반려 건수 조회
    public int getReturn();

    // 대기 건수 조회
    public int getHold();

    // 당월 요청 건수 조회
    public int getCurrent();

    // 계약서 상세 조회
    public DealingsDocVO dealingsDocDetail(String docNo);

    // 전체 계약서 행 수 조회
    public int getTotal(Map<String, Object> map);

    // 카테고리 목록 조회
    public List<Map<String, Object>> getCategories();

    // 결제 요청 리스트 조회
    public List<DealingsDocVO> requestList(String docNo);

    // 당월 승인 건수 조회
    public int getCurrentPass();

    // 당월 반려 건수 조회
    public int getCurrentHold();

    // 업종명 리스트 조회
    public List<DealingsDocVO> indutynmList();

    // 거래처 정보 삽입
    public int insertCounterParty(DealingsDocVO dealingsDocVO);

    // 고객 정보 삽입
    public int insertCustomer(DealingsDocVO dealingsDocVO);

    // 결재 상태 업데이트
    public int updateApprovalStatus(DealingsDocVO dealingsDocVO);

    // 거래처 정보 조회
    public CounterPartyVO getCounterpartyByDocNo(String docNo);

    // 고객 정보 조회
    public CustomerVO getCustomerByDocNo(String docNo);
}
