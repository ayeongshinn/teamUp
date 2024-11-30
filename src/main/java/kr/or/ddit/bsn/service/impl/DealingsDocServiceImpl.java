package kr.or.ddit.bsn.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.bsn.mapper.DealingsDocMapper;
import kr.or.ddit.bsn.service.DealingsDocService;
import kr.or.ddit.bsn.vo.CounterPartyVO;
import kr.or.ddit.bsn.vo.CustomerVO;
import kr.or.ddit.bsn.vo.DealingsDocVO;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DealingsDocServiceImpl implements DealingsDocService {

    @Inject
    private DealingsDocMapper dealingsDocMapper;
    
    @Inject
    UploadController uploadController;

    // 계약서 리스트
    @Override
    public List<DealingsDocVO> dealingsDocList(Map<String, Object> map) {
        return dealingsDocMapper.dealingsDocList(map);
    }
    
    // 계약서 등록 처리
    @Transactional
    @Override
    public int dealRegistPost(DealingsDocVO dealingsDocVO, String radioSelection) {
        int result = 0;
        MultipartFile[] multipartFiles = dealingsDocVO.getUploadFile();

        // 파일 업로드 처리
        if (multipartFiles != null && multipartFiles.length > 0) {
            int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);
            log.info("fileGroupNo 확인: {}", fileGroupNo);
            dealingsDocVO.setFileGroupNo(fileGroupNo);
        }

        // 계약서 등록 처리
        log.info("계약서 등록 처리: {}", dealingsDocVO);
        result += this.dealingsDocMapper.dealRegistPost(dealingsDocVO);
        
        if (result <= 0) {
        	log.info("계약서 등록 실패");
        }
        
        // 거래처 등록 처리
        if("counterRadioBtn".equals(radioSelection)) {
        	result += this.dealingsDocMapper.insertCounterParty(dealingsDocVO);
        	
        	if(result <= 1) {
        		log.info("거래처 등록 실패");
        	}else if(result == 2) {
        		log.info("거래처 등록 성공");
        	}
        };
        
        // 고객 등록 처리
        if("custRadioBtn".equals(radioSelection)) {
        	result += this.dealingsDocMapper.insertCustomer(dealingsDocVO);
        	
        	if(result <= 1) {
        		log.info("고객 등록 실패");
        	}else if(result == 2) {
        		log.info("고객 등록 성공");
        	}
        };
        
        log.info("result 확인 : " + result);

        return result; // 처리된 결과 반환
    }
    
    // 파일 상세 조회
    @Override
    public List<FileDetailVO> getFileDetails(int fileGroupNo) {
        return dealingsDocMapper.getFileDetails(fileGroupNo);
    }

    // 승인 건수 조회
    @Override
    public int getPass() {
        return dealingsDocMapper.getPass();
    }

    // 반려 건수 조회
    @Override
    public int getReturn() {
        return dealingsDocMapper.getReturn();
    }

    // 대기 건수 조회
    @Override
    public int getHold() {
        return dealingsDocMapper.getHold();
    }

    // 당월 요청 건수 조회
    @Override
    public int getCurrent() {
        return dealingsDocMapper.getCurrent();
    }

    // 계약서 상세 조회
    @Override
    public DealingsDocVO dealingsDocDetail(String docNo) {
        return dealingsDocMapper.dealingsDocDetail(docNo);
    }

    // 결재 상태 업데이트
    @Override
    public int updateApprovalStatus(DealingsDocVO dealingsDocVO) {
        log.info("결재 상태 업데이트: {}", dealingsDocVO);
        return dealingsDocMapper.updateApprovalStatus(dealingsDocVO);
    }

    // 전체 행의 수 조회
    @Override
    public int getTotal(Map<String, Object> map) {
        return dealingsDocMapper.getTotal(map);
    }

    // 카테고리 목록 조회
    @Override
    public List<Map<String, Object>> getCategories() {
        return dealingsDocMapper.getCategories();
    }

    // 결제 요청 리스트 조회
    @Override
    public List<DealingsDocVO> requestList(String docNo) {
        return dealingsDocMapper.requestList(docNo);
    }

    // 당월 승인 건수 조회
    @Override
    public int getCurrentPass() {
        return dealingsDocMapper.getCurrentPass();
    }

    // 당월 반려 건수 조회
    @Override
    public int getCurrentHold() {
        return dealingsDocMapper.getCurrentHold();
    }

    // 업종명 리스트 조회
    @Override
    public List<DealingsDocVO> indutynmList() {
        return dealingsDocMapper.indutynmList();
    }

    // 거래처 정보 조회
    @Override
    public CounterPartyVO getCounterpartyByDocNo(String docNo) {
        return dealingsDocMapper.getCounterpartyByDocNo(docNo);
    }

    // 고객 정보 조회
    @Override
    public CustomerVO getCustomerByDocNo(String docNo) {
        return dealingsDocMapper.getCustomerByDocNo(docNo);
    }


}
