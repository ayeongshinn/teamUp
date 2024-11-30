package kr.or.ddit.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import kr.or.ddit.hr.vo.EmpAuthVO;
import kr.or.ddit.hr.vo.EmployeeVO;

// 스프링 시큐리티에서 제공하는 User 클래스를 확장한 사용자 정의 User 클래스
@SuppressWarnings("serial")
public class CustomUser extends User {
    // JSP에서 사용할 수 있는 EmployeeVO 객체
    private EmployeeVO employeeVO;

    /**
     * 스프링 시큐리티의 User 객체를 생성하기 위한 생성자
     * @param empNo - 사원 번호
     * @param password - 비밀번호
     * @param authorities - 사용자의 권한 목록
     */
    public CustomUser(String empNo, String password, Collection<? extends GrantedAuthority> authorities) {
        super(empNo, password, authorities);
    }
    
    /**
     * 사용자 정보를 기반으로 CustomUser 객체를 생성하는 생성자
     * @param employeeVO - 사원 정보와 권한이 포함된 EmployeeVO 객체
     */
    public CustomUser(EmployeeVO employeeVO) {
        // 스프링 시큐리티에서 요구하는 User 클래스의 인자에 맞게 데이터를 전달
        super(employeeVO.getEmpNo(), employeeVO.getEmpPswd(), getCollect(employeeVO));
        this.employeeVO = employeeVO;
    }

    /**
     * EmployeeVO 객체에서 권한 정보를 추출하여 권한 목록을 생성
     * @param employeeVO - 사원 정보 객체
     * @return 권한 목록 (SimpleGrantedAuthority 객체의 리스트)
     */
    public static List<SimpleGrantedAuthority> getCollect(EmployeeVO employeeVO){
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();

        // EmployeeVO에서 권한 목록을 가져옴
        List<EmpAuthVO> empAuthVOList = employeeVO.getEmpAuthVOList();        
        if(empAuthVOList != null) {
            for(EmpAuthVO empAuthVO : empAuthVOList) {            
                // 각 권한을 SimpleGrantedAuthority 객체로 변환하여 리스트에 추가
                SimpleGrantedAuthority authority = new SimpleGrantedAuthority(empAuthVO.getAuthority());
                authorities.add(authority);
            }
        }
        
        return authorities;
    }
    
    /**
     * EmployeeVO 객체를 반환
     * @return EmployeeVO - 사원 정보
     */
    public EmployeeVO getEmployeeVO() {
        return employeeVO;
    }

    /**
     * EmployeeVO 객체를 설정
     * @param employeeVO - 사원 정보
     */
    public void setEmployeeVO(EmployeeVO employeeVO) {
        this.employeeVO = employeeVO;
    }
}


