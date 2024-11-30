package kr.or.ddit.cmmn.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.mapper.HeaderMapper;
import kr.or.ddit.cmmn.service.HeaderService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;

@Service
public class HeaderServiceImpl implements HeaderService {
	
	/**
	 * HeaderService 인터페이스를 구현한 서비스 클래스
	 */

    @Autowired
    private HeaderMapper headerMapper;  // 데이터베이스 접근을 위한 Mapper 주입

    /**
     * 부서명과 직책명을 가져오는 메소드
     *
     * @param clsfCd 부서 코드와 직책 코드가 포함된 맵
     * @return List<CommonCodeVO> - 부서 정보 목록
     */
    @Override
    public List<CommonCodeVO> getDept(Map<String, Object> clsfCd) {
        
        List<CommonCodeVO> commonCodeList = new ArrayList<>();  // 부서 정보를 저장할 리스트
        
        // clsfCd 맵의 키를 순회하며 각 부서 정보를 조회
        for (String cd : clsfCd.keySet()) {
            // HeaderMapper를 통해 부서 정보를 가져옴
            CommonCodeVO commonCodeVO = this.headerMapper.getDept(String.valueOf(clsfCd.get(cd)));
            commonCodeList.add(commonCodeVO);  // 가져온 부서 정보를 리스트에 추가
        }
        
        return commonCodeList;  // 최종적으로 부서명 및 직책명 목록 반환
    }

    /**
     * 사용자의 근태 상태를 가져오는 메소드
     *
     * @param empNo 사용자의 사원 번호
     * @return AttendanceVO - 사용자의 근태 상태 정보
     */
    @Override
    public AttendanceVO getEmpSttus(String empNo) {
        // HeaderMapper를 통해 사용자의 근태 상태를 조회하여 반환
        return this.headerMapper.getEmpSttus(empNo);
    }
}

