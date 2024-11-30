package kr.or.ddit.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import kr.or.ddit.hr.mapper.EmployeeMapper;
import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomUserDetailsService implements UserDetailsService {
    
    // 사원 정보를 조회하는 매퍼
    @Autowired
    EmployeeMapper employeeMapper;
    
    /**
     * 사용자 인증을 위한 사용자 정보 로드
     * @param empNo - 로그인 시 입력된 사원 번호
     * @return UserDetails - 인증된 사용자 정보
     * @throws UsernameNotFoundException - 사원 번호에 해당하는 사용자가 없을 경우 예외 발생
     */
    @Override
    public UserDetails loadUserByUsername(String empNo) throws UsernameNotFoundException {
        
        // 사원 번호로 사원 정보를 조회
        EmployeeVO employeeVO = this.employeeMapper.getLogin(empNo);
        log.info("employeeVO : " + employeeVO);
        
        // 사원 정보가 없으면 null 반환, 있으면 커스텀 UserDetails 반환
        return employeeVO == null ? null : new CustomUser(employeeVO);
    }
}

