package kr.or.ddit.util;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

// 자바빈 객체 등록
@RequestMapping("/error")
@Slf4j
@Controller
public class ErrorController {
	// 요청URI : /error/error400
	@GetMapping("/error400")
	public String error400() {
		
		// forwarding : jsp
		return "error/error400";
	}
	
	// 요청URI : /error/error404
	@GetMapping("/error404")
	public String error404() {
		
		// forwarding : jsp
		return "error/error404";
	}
	
	// 요청URI : /error/error500
	@GetMapping("/error500")
	public String error500() {
		
		// forwarding : jsp
		return "error/error500";
	}
}
