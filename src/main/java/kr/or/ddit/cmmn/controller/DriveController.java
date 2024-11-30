package kr.or.ddit.cmmn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.cmmn.service.DriveService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/drive")
public class DriveController {
	
	@Autowired
	DriveService driveServie;
	
	@GetMapping("/driveList")
	public String driveList() {
		return "cmmn/drive/driveList";
	}
}
