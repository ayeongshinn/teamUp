package kr.or.ddit.cmmn.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.HeaderService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/tiles")
@Slf4j
@Controller
public class HeaderController {
	
    @Autowired
    private HeaderService headerService;  // HeaderService를 주입받아 사용

    /**
     * 부서명 및 직책명을 요청하는 API
     *
     * @param clsfCd 직책 코드와 부서 코드가 포함된 요청 데이터
     * @return CommonCodeVO 리스트 - 부서명 및 직책명 목록
     */
    @ResponseBody
    @PostMapping("/getDept")
    public List<CommonCodeVO> getDept(@RequestBody Map<String, Object> clsfCd) {
        
        log.info("getDept -> clsfCd : " + clsfCd);  // 요청 데이터 로깅
        
        // HeaderService를 통해 부서명 및 직책명 조회
        List<CommonCodeVO> commonCodeVOList = this.headerService.getDept(clsfCd);
        
        log.info("getDept -> commonCodeVOList : " + commonCodeVOList);  // 조회된 부서명 및 직책명 로깅
        
        return commonCodeVOList;  // 부서명 및 직책명 반환
    }
    
    /**
     * 사용자의 근태 상태를 요청하는 API
     *
     * @param empNo 사용자의 사원 번호
     * @return AttendanceVO - 사용자의 근태 상태 정보
     */
    @ResponseBody
    @PostMapping("/getEmpSttus")
    public AttendanceVO getEmpSttus(@RequestBody String empNo) {
        
        log.info("getEmpSttus -> empNo : " + empNo);  // 요청된 사원 번호 로깅
        
        // HeaderService를 통해 사용자의 근태 상태 조회
        AttendanceVO attendanceVO = this.headerService.getEmpSttus(empNo);
        
        log.info("getEmpSttus -> attendanceVO : " + attendanceVO);	// 조회된 근태 상태 로깅
        
        return attendanceVO;  // 근태 상태 정보 반환
    }
}

