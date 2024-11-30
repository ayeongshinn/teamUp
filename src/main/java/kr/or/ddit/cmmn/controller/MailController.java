package kr.or.ddit.cmmn.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.service.MailService;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.cmmn.vo.MailDVO;
import kr.or.ddit.cmmn.vo.MailRVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.service.SugestBoardService;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/cmmn/mail")
@Slf4j
@Controller
public class MailController {

	@Autowired
	MailService MailService;
	
	@Inject
	SugestBoardService boardService;
	
	
	@GetMapping("/list")
	public String list(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value="cag",required=false,defaultValue="") String cag,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		map.put("cag", cag); //메일종류
	
		log.info("list->cag : " + cag);
		
		List<MailDVO> mailDVOList= this.MailService.AllReclist(map);
		model.addAttribute("mailDVOList", mailDVOList);
		
		log.info("list->mailDVOList : " + mailDVOList);
		int total=this.MailService.getTotal(map);
		
		ArticlePage<MailDVO> articlePage = 
				new ArticlePage<MailDVO>(total, currentPage, 15, mailDVOList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		
		return "cmmn/mail/list";
	}


	
	@GetMapping("/NReadMailList")
	public String NReadMailList(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		List<MailDVO> mailDVOList= this.MailService.NReadMailList(map);
		model.addAttribute("mailDVOList", mailDVOList);
		
		log.info("list->mailDVOList : " + mailDVOList);
		int total=this.MailService.getNReadMailTotal(map);
		
		ArticlePage<MailDVO> articlePage = 
				new ArticlePage<MailDVO>(total, currentPage, 20, mailDVOList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		
		return "cmmn/mail/NReadMailList";
	}
	
	@GetMapping("/bookMarkList")
	public String bookMarkList(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		List<MailDVO> mailDVOList= this.MailService.bookMarkList(map);
		model.addAttribute("mailDVOList", mailDVOList);
		
		log.info("list->mailDVOList : " + mailDVOList);
		int total=this.MailService.getBMTotal(map);
		
		ArticlePage<MailDVO> articlePage = 
				new ArticlePage<MailDVO>(total, currentPage, 20, mailDVOList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		
		return "cmmn/mail/bookMarkList";
	}
	
	@GetMapping("/toMeList")
	public String toMeList(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		List<MailDVO> mailDVOList= this.MailService.toMeList(map);
		model.addAttribute("mailDVOList", mailDVOList);
		
		log.info("list->mailDVOList : " + mailDVOList);
		int total=this.MailService.gettoMeTotal(map);
		
		ArticlePage<MailDVO> articlePage = 
				new ArticlePage<MailDVO>(total, currentPage, 20, mailDVOList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		
		return "cmmn/mail/toMeList";
	}
	
	@GetMapping("/delList")
	public String delList(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		List<MailDVO> mailDVOList= this.MailService.delList(map);
		model.addAttribute("mailDVOList", mailDVOList);
		
		log.info("list->mailDVOList : " + mailDVOList);
		int total=this.MailService.getDelTotal(map);
		
		ArticlePage<MailDVO> articlePage = 
				new ArticlePage<MailDVO>(total, currentPage, 20, mailDVOList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		
		return "cmmn/mail/delList";
	}
	
	@GetMapping("/detail")
	public String detail(Model model,
			@RequestParam(value="mailNo",required=false,defaultValue="") String mailNo,
			@RequestParam(value="rcptnSn",required=false,defaultValue="") String StRcptnSn) {
		
		int rcptnSn=Integer.parseInt(StRcptnSn);
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("mailNo", mailNo);
		map.put("rcptnSn", rcptnSn);
		
		Map<String, Object> map2=new HashMap<String, Object>();
		map2.put("rcptnSn", rcptnSn);
		
		int result=this.MailService.setPrsY(map2);
		
		MailDVO mailDVO=this.MailService.rMailDetele(map);
		model.addAttribute("mailDVO", mailDVO);

		List<FileDetailVO> fileVOList=this.boardService.getFileDetails(mailDVO.getFileGroupNo());
		model.addAttribute("fileVOList", fileVOList);
		
		return "cmmn/mail/detail";
	}
	
	@GetMapping("/toMeDetail")
	public String toMeDetail(Model model,
			@RequestParam(value="mailNo",required=false,defaultValue="") String mailNo) {
		
		
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("mailNo", mailNo);
		
		
		
		MailDVO mailDVO=this.MailService.toMeDetail(map);
		model.addAttribute("mailDVO", mailDVO);
		
		
		return "cmmn/mail/toMeDetail";
	}
	
	@GetMapping("/DMailDetail")
	public String DMailDetail(Model model,
			@RequestParam(value="mailNo",required=false,defaultValue="") String mailNo) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("mailNo", mailNo);
		
		List<MailDVO> mailDVOList=this.MailService.DMailDetail(map);
		log.info("DMailDetail->mailDVOList : " + mailDVOList);
		model.addAttribute("mailDVOList", mailDVOList);
		
		int fileGroupNo=0;
		
		for (MailDVO mail : mailDVOList) {
			fileGroupNo = mail.getFileGroupNo();
        }
		
		List<FileDetailVO> fileVOList=this.boardService.getFileDetails(fileGroupNo);
		model.addAttribute("fileVOList", fileVOList);
		
		return "cmmn/mail/DMailDetail";
	}
	
	
	
	
	@GetMapping("/sendList")
	public String sendList(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		List<MailDVO> mailDVOList= this.MailService.sendList(map);
		model.addAttribute("mailDVOList", mailDVOList);
		
		log.info("list->mailDVOList : " + mailDVOList);
		

		
		int total=this.MailService.getSendTotal(map);
		
		ArticlePage<MailDVO> articlePage = 
				new ArticlePage<MailDVO>(total, currentPage, 15, mailDVOList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		
		return "cmmn/mail/sendList";
	}
	@GetMapping("/showRPrs")
	public String showRPrs(Model model,
			@RequestParam(value = "searchField", required = false, defaultValue = "") String searchField,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("searchField", searchField); //검색 필드
		map.put("keyword", keyword); //검색어
		map.put("currentPage", currentPage);
		map.put("startDate", startDate); //시작일
		map.put("endDate", endDate); //종료일
		
		List<MailDVO> mailDVOList= this.MailService.sendList(map);
		model.addAttribute("mailDVOList", mailDVOList);
		
		log.info("list->mailDVOList : " + mailDVOList);
		
		int total=this.MailService.getSendTotal(map);
		
		ArticlePage<MailDVO> articlePage = 
				new ArticlePage<MailDVO>(total, currentPage, 20, mailDVOList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		
		return "cmmn/mail/showRPrs";
	}
	
	@GetMapping("/dmailDelPost")
	public String dmailDelPost(@RequestParam(value = "groupList", required = true) String groupList,
			@RequestParam(value = "empNo", required = true) String empNo) {
		
		log.info("delPost도착");
		
		log.info("delPost->groupList : " + groupList);
		log.info("delPost->empNo : " + empNo);
		
		
		String[] mailCode = groupList.split(",");
		
        

		int result=0;
		for(int i=0; i < mailCode.length; i++){
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("mailNo", mailCode[i]);
			
			result = this.MailService.dmailDelete(map);
			
		}
		
		return "redirect:/cmmn/mail/sendList?empNo="+empNo;
		
	}
	
	
	@GetMapping("/rmailDelPost")
	public String rmailDelPost(
			@RequestParam(value = "groupList", required = false) String groupList,
			@RequestParam(value = "rcptnSn", required = false) String rcptnSn,
			@RequestParam(value = "empNo", required = true) String empNo) {
		
		log.info("delPost도착");
		
		log.info("delPost->groupList : " + groupList);
		log.info("delPost->empNo : " + empNo);
		
		int result=0;
		if(groupList!=null) {
			String[] ArrrcptnSn = groupList.split(",");
			int[] intrcptnSn = new int[ArrrcptnSn.length];
	        
	        // String 배열을 int 배열로 변환
	        for (int i = 0; i < ArrrcptnSn.length; i++) {
	        	intrcptnSn[i] = Integer.parseInt(ArrrcptnSn[i]);
	        }
			
			for(int i=0; i < intrcptnSn.length; i++){
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("empNo", empNo);
				map.put("rcptnSn", intrcptnSn[i]);
				result = this.MailService.rmailDelete(map);
				
			}
		}
		
		if(rcptnSn!=null) {
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("empNo", empNo);
			map.put("rcptnSn", rcptnSn);
			result = this.MailService.rmailDelete(map);
			
		}
		
		return "redirect:/cmmn/mail/list?empNo="+empNo;
		
	}
	
	@GetMapping("/mailnDelCanclePost")
	public String mailnDelCanclePost(
			@RequestParam(value = "groupList", required = false) String groupList,
			@RequestParam(value = "groupRcptnSn", required = false) String groupRcptnSn,
			@RequestParam(value = "empNo", required = true) String empNo) {
		
		
		
		log.info("delPost->groupList : " + groupList);
		log.info("delPost->empNo : " + empNo);
		
		
		String[] mailNo = groupList.split(",");
		
		
		int result=0;
		for(int i=0; i < mailNo.length; i++){
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("mailNo", mailNo[i]);
			result = this.MailService.setDmailDelN(map);
			
		}
		
		
		if(groupRcptnSn!=null&& !groupRcptnSn.isEmpty()) {
			String[] rcptnSn = groupRcptnSn.split(",");
			int[] intrcptnSn = new int[rcptnSn.length];
	        
	        // String 배열을 int 배열로 변환
	        for (int i = 0; i < rcptnSn.length; i++) {
	        	intrcptnSn[i] = Integer.parseInt(rcptnSn[i]);
	        }
			
			for(int i=0; i < intrcptnSn.length; i++){
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("empNo", empNo);
				map.put("rcptnSn", intrcptnSn[i]);
				result = this.MailService.setRmailDelN(map);
				
			}
		}
		
		
		
		return "redirect:/cmmn/mail/delList?empNo="+empNo;
		
	}
	
	@GetMapping("/setPrsY")
	public String setPrsY(
			@RequestParam(value = "groupList", required = true) String groupList,
			@RequestParam(value = "empNo", required = true) String empNo) {
		
		log.info("delPost도착");
		
		log.info("delPost->groupList : " + groupList);
		log.info("delPost->empNo : " + empNo);
		
		
		String[] rcptnSn = groupList.split(",");
		int[] intrcptnSn = new int[rcptnSn.length];
		
		// String 배열을 int 배열로 변환
		for (int i = 0; i < rcptnSn.length; i++) {
			intrcptnSn[i] = Integer.parseInt(rcptnSn[i]);
		}
		
		int result=0;
		for(int i=0; i < intrcptnSn.length; i++){
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("rcptnSn", intrcptnSn[i]);
			result = this.MailService.setPrsY(map);
			
		}
		
		return "redirect:/cmmn/mail/list?empNo="+empNo;
		
	}
	
	
	@GetMapping("/rspamYnChange")
	public String rspamYnChange(
			@RequestParam(value = "rspamYn", required = true) String rspamYn,
			@RequestParam(value = "rcptnSn", required = true) String rcptnSn,
			@RequestParam(value = "empNo", required = true) String empNo) {
		
		log.info("rspamYnChange도착");                         
		
		log.info("delPost->rspamYn : " + rspamYn);
		log.info("delPost->empNo : " + empNo);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rcptnSn", rcptnSn);
		
		String N="N";
		
		int result=0;
		if(rspamYn.equals(N)){
			result=this.MailService.setRspamY(map);
		}else{
			result=this.MailService.setRspamN(map);
		}
		
		return "redirect:/cmmn/mail/list?empNo="+empNo;
		
	}
	
	
	@GetMapping("/send")
	public String send(Model model, @ModelAttribute MailDVO mailDVO) {

		return "cmmn/mail/send";
	}
	
	
	@ResponseBody
	@PostMapping("/getDeptCd")
	public List<EmployeeVO> getDeptCd(@RequestBody String DeptCd, Model model) {
		
		
		log.info("getEeptCd->DeptCd : " + DeptCd);
		List<EmployeeVO> employeeVOList=this.MailService.getEeptCd(DeptCd);
		
		
		return employeeVOList;
	}
	
	
	@ResponseBody
	@PostMapping("/getEmp")
	public EmployeeVO getEmp(@RequestBody String empNo, Model model) {
		
		
		log.info("getEmp->empNo : " + empNo);
		EmployeeVO employeeVO=this.MailService.getEmp(empNo);
		
		
		return employeeVO;
	}
	
	/*
	 {
           "groupList": groupList,
           "mailTtl": mailTtl,
           "mailCn": mailCn,
           "dsptchEmpNo": dsptchEmpNo,
           "imprtncYn": dimprtncYn
       }
	 */
	
	@ResponseBody
	@PostMapping("/sendMailAjax")
	public List<Map<String,Object>> sendMailAjax(@ModelAttribute  MailDVO mailDVO,
            				@RequestParam("uploadFile") MultipartFile[] uploadFile) {
		
		log.info("sendMailAjax 컨트롤러옴");
		
		mailDVO.setUploadFile(uploadFile);
		
		//메일아이디얻기
		String mailNo= this.MailService.getMailNo();
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("mailNo", mailNo);
		map.put("mailTtl", mailDVO.getMailTtl());
		map.put("mailCn", mailDVO.getMailCn());
		map.put("dsptchEmpNo", mailDVO.getDsptchEmpNo());
		map.put("imprtncYn", mailDVO.getImprtncYn());
		map.put("uploadFile", mailDVO.getUploadFile());
		
		log.info( mailNo);
		log.info( mailDVO.getMailTtl());
		log.info( mailDVO.getMailCn());
		log.info( mailDVO.getDsptchEmpNo());
		log.info( mailDVO.getImprtncYn());
		
		//Dmail등록
		int result=0;
		
		result = this.MailService.registDmail(map);
		
		//수신번호 얻기
		//groupList(받는 사람 1명 이상) : 112001,181001,001002
		String groupList=mailDVO.getGroupList();
		String imprtncYn=mailDVO.getImprtncYn();
		//[112001,181001,001002]
		String[] recptnEmpNo = groupList.split(",");
		log.info("수신자번호들"+ recptnEmpNo);
		
		
		
		int result2=0;
		
		List<Map<String,Object>> receiveEmpList = 
					new ArrayList<Map<String,Object>>();
		//보내는 사람들의 인원수만큼 반복
		for(int i=0; i < recptnEmpNo.length; i++){
			int rcptnSn=this.MailService.getRcptnSn();
			
			Map<String,Object> map2 = new HashMap<String, Object>();
			
			map2.put("rcptnSn", rcptnSn);
			map2.put("mailNo", mailNo);
			map2.put("recptnEmpNo", recptnEmpNo[i]);
			map2.put("imprtncYn", imprtncYn);
			
			receiveEmpList.add(map2);
			
			//보내는 사람들의 인원수만큼 실행
			result2 = this.MailService.registRmail(map2);
			
		}
		
		//문자열이 리턴  : dataType: "text",
		return receiveEmpList;
	}
	
	@ResponseBody
	@GetMapping("/sendMailAjaxTest")
	public String sendMailAjaxTest() {
		
		log.info("sendMailAjaxTest 왔다");
		
		return "success";
	}
	
	
}















