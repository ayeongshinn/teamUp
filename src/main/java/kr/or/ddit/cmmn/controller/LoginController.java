package kr.or.ddit.cmmn.controller;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.LoginService;
import kr.or.ddit.hr.vo.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginController {
	
	@Autowired
	LoginService loginService;
	
	//암호화 처리 빈 객체
	@Inject
	PasswordEncoder bcryptPasswordEncoder;
	
	//<security:form-login login-page="/login" />
	//요청URI : /login
	//요청방식 : get
	//오류 메시지와 로그아웃 메시지를 파라미터로 사용해보자(없을 수도 있음)
	@GetMapping("/login")
	public String loginForm(String error, String logout, Model model) {
		log.info("error : " + error);
		log.info("logout : " + logout);
		
		if(error != null) {
			model.addAttribute("error", "일치하는 사원 정보가 없습니다");
		}
		
		if(logout != null) {
			model.addAttribute("logout", "Logout!!");
		}
		//forwarding
		return "cmmn/loginForm";
	}
	
	@GetMapping("/home")
	public String home() {
		return "home";
	}
	
	//비밀번호 찾기 페이지로 이동 :: 신아영
	@GetMapping("/findPswd")
	public String findPswd() {
		return "cmmn/findPswd";
	}
	
	//비밀번호 찾기 처리 :: 신아영
    @PostMapping("/findPswdAjax")
    @ResponseBody
    public EmployeeVO findPswdAjax (@RequestBody EmployeeVO employeeVO) {
    	
    	EmployeeVO empVO = this.loginService.findPswdAjax(employeeVO);
    	
    	if(empVO != null) {
    		empVO.setEmpRrno(null);
    	} else {
    		employeeVO.setEmpPswd("ERROR");
    	}
    
    	return employeeVO; 
    }
    
    //비밀번호 재설정 페이지로 이동 :: 신아영
    @GetMapping("/updatePswd")
    public String updatePswd() {
    	return "cmmn/updatePswd";
    }
    
    //비밀번호 재설정 처리 :: 신아영
    @PostMapping("/updatePswdAjax")
    @ResponseBody
    public EmployeeVO updatePswdAjax(@RequestBody EmployeeVO employeeVO) {
    	
    	//비밀번호 암호화
    	String encodedPswd = bcryptPasswordEncoder.encode(employeeVO.getEmpPswdNew());
    	log.info("encodedPswd :" + encodedPswd);
    	employeeVO.setEmpPswdNew(encodedPswd);
    	//{empNo=20240001,empPswdNew=dsaflkjfdsalkfdsj}
    	log.info("employeeVO : " + employeeVO);
    	
    	int result = this.loginService.updatePswdAjax(employeeVO);
    	
    	//비밀번호 재설정 로직 구현
    	if(result > 0) {
    		employeeVO.setEmpPswd("SUCCESS");
    	} else { 
    		employeeVO.setEmpPswd("ERROR");
    	}
    	return employeeVO;
    }
    
    
    
}
