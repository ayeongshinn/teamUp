package kr.or.ddit.cmmn.controller;

import java.security.Principal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.apache.catalina.authenticator.SpnegoAuthenticator.AuthenticateAction;
import org.apache.taglibs.standard.tag.common.fmt.ParseDateSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.cmmn.service.MyPageService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.MailDVO;
import kr.or.ddit.hr.mapper.EmployeeMapper;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.hr.vo.SalaryDetailsDocVO;
import kr.or.ddit.hr.vo.VacationDocVO;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;
@RequestMapping("/cmmn/myPage")
@Slf4j
@Controller
public class MyPageController {
	@Autowired
	MyPageService myPageService;
	
	// 사원
	//DI(의존성 주입)
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Inject
	PasswordEncoder bcryptPasswordEncoder;
	
	@GetMapping("/teamAttend")
	public String teamAttend(Model model,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="deptCd",required=false,defaultValue="") String deptCd) {
		Map<String, Object> map=new HashMap<String, Object>();
		
		map.put("empNo", empNo);
		map.put("deptCd", deptCd);
		
		//총팀원
		
		int countTeamEmp =this.myPageService.countTeamEmp(map);
		
		
		//출근인원
		int countAttendEmp =this.myPageService.countAttendEmp(map);
		
		//미출근인원
		int countNotAttendEmp=this.myPageService.countNotAttendEmp(map);
		
		//휴가인원
		int vacationEmp=this.myPageService.vacationEmp(map);
		
		//출장 인원
		int busiTripEmp=this.myPageService.busiTripEmp(map);
		
		model.addAttribute("countTeamEmp",countTeamEmp);
		model.addAttribute("countAttendEmp",countAttendEmp);
		model.addAttribute("countNotAttendEmp",countNotAttendEmp);
		model.addAttribute("vacationEmp",vacationEmp);
		model.addAttribute("busiTripEmp",busiTripEmp);
		
		
		//팀원 리스트
		
		
		List<AttendanceVO> attendanceVOList =this.myPageService.teamAttendList(map);
		
	    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
		
		List<AttendanceVO> formattedList = new ArrayList<>();
	    
	    
	    for (AttendanceVO vo : attendanceVOList) {
	    	AttendanceVO newVo = new AttendanceVO();
	    	
	    	if(!vo.getAttendTm().equals("0")) {
		    	//출근시간 포멧팅
		    	try {
		    		newVo.setAttendTm(timeFormat.format(new SimpleDateFormat("HHmmss").parse(vo.getAttendTm())));
		    	} catch (ParseException e) {
		    		// TODO Auto-generated catch block
		    		e.printStackTrace();
		    	}
	    	}else {
	    		newVo.setAttendTm(vo.getAttendTm());
	    	}
	    	
	    	
	    	if(!vo.getLvffcTm().equals("0")) {
		    	//퇴근 시간포멧팅
		    	try {
		    		newVo.setLvffcTm(timeFormat.format(new SimpleDateFormat("HHmmss").parse(vo.getLvffcTm())));
		    	} catch (ParseException e) {
		    		// TODO Auto-generated catch block
		    		e.printStackTrace();
		    	}
	    	}else {
	    		newVo.setLvffcTm(vo.getLvffcTm());
	    	}
//	    	A18-001	A18	사원
//	    	A18-002	A18	대리
//	    	A18-003	A18	차장
//	    	A18-004	A18	부장
//	    	A18-005	A18	이사
//	    	A18-006	A18	사장
	    	
	    	if(vo.getJbgdCd().equals("A18-001")) {
	    		newVo.setJbgdNm("사원");
	    	}else if(vo.getJbgdCd().equals("A18-002")){
	    		newVo.setJbgdNm("대리");
	    	}else if(vo.getJbgdCd().equals("A18-003")){
	    		newVo.setJbgdNm("차장");
	    	}else if(vo.getJbgdCd().equals("A18-004")){
	    		newVo.setJbgdNm("부장");
	    	}else if(vo.getJbgdCd().equals("A18-005")){
	    		newVo.setJbgdNm("이사");
	    	}else if(vo.getJbgdCd().equals("A18-006")){
	    		newVo.setJbgdNm("사장");
	    	}
	    	
//	    	근무 중
//	    	미 출근
//	    	출장 중
//	    	휴가 중
//	    	퇴근
//	    	자리 비움
	    	
	    	if(vo.getEmpSttusCd().equals("A13-001")) {
	    		newVo.setEmpSttusNm("근무중");
	    	}else if(vo.getEmpSttusCd().equals("A13-002")){
	    		newVo.setEmpSttusNm("미출근");
	    	}else if(vo.getEmpSttusCd().equals("A13-003")){
	    		newVo.setEmpSttusNm("출장중");
	    	}else if(vo.getEmpSttusCd().equals("A13-004")){
	    		newVo.setEmpSttusNm("휴가중");
	    	}else if(vo.getEmpSttusCd().equals("A13-005")){
	    		newVo.setEmpSttusNm("퇴근");
	    	}else if(vo.getEmpSttusCd().equals("A13-006")){
	    		newVo.setEmpSttusNm("자리비움");
	    	}
	    	
	    	
            newVo.setEmpNo(vo.getEmpNo());
            newVo.setEmpNm(vo.getEmpNm());
            newVo.setJbgdCd(vo.getJbgdCd());
	    	
	    	
            formattedList.add(newVo);
	    }
		model.addAttribute("formattedList",formattedList);
		
		return "cmmn/myPage/teamAttend";
	}
	
	
	@GetMapping("/showAttend")
	public String showAttend(Model model,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		Map<String, Object>map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("currentPage", currentPage);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		
		
		int result =0;
		Date date = new Date();
		SimpleDateFormat toDayformat = new SimpleDateFormat("yyyyMMdd");
		String attendYmd = toDayformat.format(date);
		
		log.info("showAttend => stToday"+attendYmd);//20241002
		
		Map<String, Object> tdAttendMap=new HashMap<String, Object>();
		
		tdAttendMap.put("empNo", empNo);
		tdAttendMap.put("attendYmd", attendYmd);
		
		String dbattendYmd= this.myPageService.getDbattendYmd(tdAttendMap);
		
		
		AttendanceVO tdAttendVO= new AttendanceVO();
		
		if(dbattendYmd.equals(attendYmd)) {
			log.info("디비최신날짜랑 오늘이란 같아서 이프 통과");
			
			//오늘 출퇴근가져오기
			tdAttendVO = this.myPageService.getTdWork(tdAttendMap);
			if(tdAttendVO.getAttendTm()!=null) {
			// 시, 분, 초를 분리
			String attendTm = tdAttendVO.getAttendTm(); // 예: "085139"
			int aTHours = Integer.parseInt(attendTm.substring(0, 2)); // "08" -> 8
			int atMinutes = Integer.parseInt(attendTm.substring(2, 4)); // "51" -> 51
			int aTSeconds = Integer.parseInt(attendTm.substring(4, 6)); // "39" -> 39
			log.info("aTHours/atMinutes/aTSeconds=>"+aTHours+"/"+atMinutes+"/"+aTSeconds);
			
			
			// 시간을 밀리세컨드로 변환
			long atMilliseconds = (aTHours * 3600 + atMinutes * 60 + aTSeconds) * 1000;
			
			String StattendTm = String.valueOf(aTHours) + "시 " + String.valueOf(atMinutes) + "분";
			tdAttendVO.setAttendTm(StattendTm);
			
				if(tdAttendVO.getLvffcTm()!=null) {
					// 시간 문자열 (HHmmss 형식)
		
					// 시간 문자열 (HHmmss 형식)
					String lVtendTm = tdAttendVO.getLvffcTm(); // 예: "085139"
		
					// 시, 분, 초를 분리
					int lVHours = Integer.parseInt(lVtendTm.substring(0, 2)); // "08" -> 8
					int lVMinutes = Integer.parseInt(lVtendTm.substring(2, 4)); // "51" -> 51
					int lVSeconds = Integer.parseInt(lVtendTm.substring(4, 6)); // "39" -> 39
		
					log.info("showAttend => 퇴근시간="+ lVHours+lVMinutes+lVSeconds);
					
					// 시간을 밀리세컨드로 변환
					long lVMilliseconds = (lVHours * 3600 + lVMinutes * 60 + lVSeconds) * 1000;
					log.info("showAttend => lVMilliseconds="+ lVMilliseconds);
					
					String StlvffcTm=  lVHours + "시 " + lVMinutes + "분";
					tdAttendVO.setLvffcTm(StlvffcTm);
					
					//야근시간구하기
					long eighteenPMMilliseconds = 64800000;
					// 퇴근 시간이 18시 이후라면 야근 시간 계산
					long overtimeMilliseconds = 0;
					double overtimeHours = 0.0;
					if (lVMilliseconds > eighteenPMMilliseconds) {
						overtimeMilliseconds = lVMilliseconds - eighteenPMMilliseconds;
						lVMilliseconds = eighteenPMMilliseconds; // 야근 시간만큼은 제외한 퇴근 시간
						log.info("showAttend => overtimeMilliseconds="+ overtimeMilliseconds);
						log.info("showAttend => lVMilliseconds="+ lVMilliseconds);
						
						// 야근 시간을 소수점 시간으로 변환
						overtimeHours = (double) overtimeMilliseconds / (1000 * 60 * 60);
					
					}
		
					// 야근 시간을 문자열로 변환하여 `ngtwrHr`에 저장
			        String ngtwrHr = String.format("%.1f", overtimeHours); // 소수점 한 자리까지 표현
					
			        log.info("showAttend => ngtwrHr="+ ngtwrHr);
			        
					tdAttendMap.put("ngtwrHr",ngtwrHr);
					//야근 시간 db에 저장
					result=this.myPageService.setOvreWkTm(tdAttendMap);
					log.info("setOvreWkTm까지 완료");
					
					
					//근무 밀리세컨드
					long WKMilliseconds = lVMilliseconds - atMilliseconds + overtimeMilliseconds;
					// 휴식 시간과 식사 시간(단위: 시간)을 숫자로 변환
					int rTInHours = Integer.parseInt(tdAttendVO.getRestHr()); // 휴식 시간
					int mTInHours = Integer.parseInt(tdAttendVO.getMealHr());
					// 휴식 시간과 식사 시간을 밀리세컨드로 변환
					long rMilliseconds = rTInHours * 60 * 60 * 1000;
					long mMilliseconds = mTInHours * 60 * 60 * 1000;
					log.info("showAttend => 빼기전 WKMilliseconds="+ WKMilliseconds);
					
					
					
					//근무시간에서 휴식,점심시간 빼기
					WKMilliseconds= WKMilliseconds-rMilliseconds-mMilliseconds;
					
					log.info("showAttend => 뺀 후 WKMilliseconds="+ WKMilliseconds);
					
					long WKHours = WKMilliseconds / (1000 * 60 * 60); // 시간
				    long WKMinutes = (WKMilliseconds % (1000 * 60 * 60)) / (1000 * 60); // 분
				    long WKSeconds = (WKMilliseconds % (1000 * 60)) / 1000; // 초
				    log.info("WKHours/WKMinutes/WKSeconds=>"+WKHours+"/"+WKMinutes+"/"+WKSeconds);
				    
				    // 각 값을 두 자리 수로 맞추기
				    String formattedHours = String.format("%02d", WKHours);
				    String formattedMinutes = String.format("%02d", WKMinutes);
				    String formattedSeconds = String.format("%02d", WKSeconds);
		
				    
				    // "070821" 형식으로 변환
				    String workHr = formattedHours + formattedMinutes + formattedSeconds;
				    log.info("showAttend => WKTimeString="+ workHr);
				   	
				    //db에 근무시간 업데이트
				    tdAttendMap.put("workHr", workHr);
				    
				    log.info("showAttend => tdAttendMap="+ tdAttendMap);
				    
				    
				   	result=this.myPageService.setWKTime(tdAttendMap);
				  
				    // "7시간 08분 근무"와 같은 형식으로 변환
				    String readableTimeString = WKHours + "시간 " + String.format("%02d", WKMinutes) + "분";
					
				    tdAttendVO.setWorkHr(readableTimeString);
				    
				    
					
				}
		
			}
		
		}
		
		log.info("showAttend => tdAttendVO"+tdAttendVO);
		
		model.addAttribute("tdAttendVO",tdAttendVO);
		
		String weekNgtwrHr=this.myPageService.getweekNgtwrHr(empNo);
		model.addAttribute("weekNgtwrHr",weekNgtwrHr);
		
		String weekWorkHr=this.myPageService.getweekWorkHr(empNo);
		
		String wWHours="";
		String wWMinutes="";
		String wWSeconds="";
		
		if(!weekWorkHr.equals("0")) {
			wWHours = weekWorkHr.substring(0, 2); // "08" -> 8
			wWMinutes = weekWorkHr.substring(2, 4); // "51" -> 51
			wWSeconds = weekWorkHr.substring(4, 6); // "39" -> 39
			weekWorkHr= wWHours+"시간"+wWMinutes+"분";
		}
		
		
		model.addAttribute("weekWorkHr",weekWorkHr);
		
		
		
		List<AttendanceVO> attendVOList=this.myPageService.attendList(map);
		log.info("showAttend => attendVOList"+attendVOList);
		int total=this.myPageService.getAtteTotal(map);
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd");
	    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
		
	    List<AttendanceVO> formattedList = new ArrayList<>();
	    
	    
	    for (AttendanceVO vo : attendVOList) {
	    	 AttendanceVO newVo = new AttendanceVO();
	    	
	    	//출근일자 포멧팅
	    	try {
	    		newVo.setAttendYmd(dateFormat.format(new SimpleDateFormat("yyyyMMdd").parse(vo.getAttendYmd())));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    	//출근시간 포멧팅
	    	try {
	    		newVo.setAttendTm(timeFormat.format(new SimpleDateFormat("HHmmss").parse(vo.getAttendTm())));
	    	} catch (ParseException e) {
	    		// TODO Auto-generated catch block
	    		e.printStackTrace();
	    	}
	    	
	    	//퇴근 시간포멧팅
	    	try {
	    		newVo.setLvffcTm(timeFormat.format(new SimpleDateFormat("HHmmss").parse(vo.getLvffcTm())));
	    	} catch (ParseException e) {
	    		// TODO Auto-generated catch block
	    		e.printStackTrace();
	    	}
	    	
	    	//근무시간포멧팅
	    	try {
	    		newVo.setWorkHr(timeFormat.format(new SimpleDateFormat("HHmmss").parse(vo.getWorkHr())));
	    	} catch (ParseException e) {
	    		// TODO Auto-generated catch block
	    		e.printStackTrace();
	    	}
	    	
	    	newVo.setDclzNo(vo.getDclzNo());
            newVo.setEmpNo(vo.getEmpNo());
            newVo.setRestHr(vo.getRestHr());
            newVo.setMealHr(vo.getMealHr());
            newVo.setNgtwrHr(vo.getNgtwrHr());
            newVo.setEmpSttusCd(vo.getEmpSttusCd());
	    	
            formattedList.add(newVo);
	    }
	    log.info("showAttend => formattedList"+formattedList);
		
		
		model.addAttribute("formattedList",formattedList);
		
		ArticlePage<AttendanceVO> articlePage = 
				new ArticlePage<AttendanceVO>(total, currentPage, 10, formattedList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		log.info("내출퇴근 컨트롤러끝");
		
		return "cmmn/myPage/showAttend";
	}
	
	@GetMapping("/myVacation")
	public String myVacation(Model model,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword,
			@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
			@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate) {
		
		HrVacationVO HrVacationVO=this.myPageService.getMyVacation(empNo);
		
		model.addAttribute("HrVacationVO",HrVacationVO);
		log.info("HrVacationVO=>"+HrVacationVO);
		
		Map<String, Object>map=new HashMap<String, Object>();
		map.put("empNo", empNo);
		map.put("currentPage", currentPage);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		
		
		List<VacationDocVO> vacationDocVOList =this.myPageService.vacationDocVOList(map);
		int total=this.myPageService.getVacaDoc(map);
		
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd");
		
		List<VacationDocVO> formattedList = new ArrayList<>();
	    for (VacationDocVO vo : vacationDocVOList) {
	    	VacationDocVO newVo = new VacationDocVO();
	    	
	    	//신청일 포멧팅
	    	try {
	    		newVo.setWrtYmd(dateFormat.format(new SimpleDateFormat("yyyyMMdd").parse(vo.getWrtYmd())));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    	//휴가시작날짜 포멧팅
	    	try {
	    		newVo.setSchdlBgngYmd(dateFormat.format(new SimpleDateFormat("yyyyMMdd").parse(vo.getSchdlBgngYmd())));
	    	} catch (ParseException e) {
	    		// TODO Auto-generated catch block
	    		e.printStackTrace();
	    	}
	    	
	    	//휴가 종료날짜 시간포멧팅
	    	try {
	    		newVo.setSchdlEndYmd(dateFormat.format(new SimpleDateFormat("yyyyMMdd").parse(vo.getSchdlEndYmd())));
	    	} catch (ParseException e) {
	    		// TODO Auto-generated catch block
	    		e.printStackTrace();
	    	}
	    	
	    	newVo.setHtmlCd(vo.getHtmlCd());
	    	newVo.setDocNo(vo.getDocNo());
	    	newVo.setVcatnCd(vo.getVcatnCd());
	    	newVo.setDocTtl(vo.getDocTtl());
	    	newVo.setVcatnRsn(vo.getVcatnRsn());
	    	newVo.setUseVcatnDayCnt(vo.getUseVcatnDayCnt());
	    	newVo.setDocCd(vo.getDocCd());
	    	newVo.setDrftEmpNo(vo.getDrftEmpNo());
	    	newVo.setDocCdNm(vo.getDocCdNm());
	    	newVo.setAtrzNo(vo.getAtrzNo());
	    	newVo.setAtrzSttusCd(vo.getAtrzSttusCd());
	    	
            formattedList.add(newVo);
	    }
		model.addAttribute("formattedList",formattedList);
		
		ArticlePage<VacationDocVO> articlePage = 
				new ArticlePage<VacationDocVO>(total, currentPage, 10, formattedList, keyword);
		model.addAttribute("articlePage", articlePage);
		
		
		return "cmmn/myPage/myVacation";
	}
	
	
	@GetMapping("/myInfoSecu")
	public String myInfoSecu(Model model,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo) {
		
		return "cmmn/myPage/myInfoSecu";
	}
	
	//내 정보 -> 로그인이 필수 -> principal 있다고 봄
	@GetMapping("/myInfo")
	public String myInfo(Principal principal, Model model) {
		
		//로그인 된 아이디를 가져옴
		String username = principal.getName();
		
		//로그인 된 사원의 정보를 모두 가져옴
		EmployeeVO employeeVO = this.employeeMapper.getLogin(username);
		log.info("employeeVO : " + employeeVO);
		
		model.addAttribute("employeeVO", employeeVO);
		
		return "cmmn/myPage/myInfo";
	}
	
	
	@GetMapping("/myDoc")
	public String myDoc(Model model,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo) {
		
		List<SalaryDetailsDocVO> salaryDetailsDocVOList=this.myPageService.getSalaryDocList(empNo);
		log.info("salaryDetailsDocVOList"+salaryDetailsDocVOList);
		
		model.addAttribute("salaryDetailsDocVOList",salaryDetailsDocVOList);
		
		
		
		return "cmmn/myPage/myDoc";
	}
	
	@GetMapping("/salsryDoc")
	public String salsryDoc(Model model,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
		@RequestParam(value="trgtDt",required=false,defaultValue="") String trgtDt) {
		
		Map<String, Object> map=new HashMap<String, Object>();
		
		map.put("empNo", empNo);
		map.put("trgtDt", trgtDt);
		
		SalaryDetailsDocVO salaryDetailsDocVO =this.myPageService.getSalaryDoc(map);
		
		model.addAttribute("salaryDetailsDocVO",salaryDetailsDocVO);
		
		return "cmmn/myPage/salsryDoc";
	}
	
	
	@PostMapping("/myInfoSecuPost")
	public String myInfoSecuPost(Model model,Principal principal,
			@RequestParam(value="empNo",required=false,defaultValue="") String empNo,
			@RequestParam(value="inputPassword",required=false,defaultValue="") String inputPassword
			) {
		
		log.info("myInfoSecuPost 왓따");
		String encodedPswd = bcryptPasswordEncoder.encode(inputPassword);
		
		String empPswd=this.myPageService.getpasswd(empNo);
		
		boolean isMatch = bcryptPasswordEncoder.matches(inputPassword, empPswd);
		
		String result="";
		
		if(isMatch) {
			//로그인 된 아이디를 가져옴
			String username = principal.getName();
			//로그인 된 사원의 정보를 모두 가져옴
			EmployeeVO employeeVO = this.employeeMapper.getLogin(username);
			log.info("employeeVO : " + employeeVO);
			
			model.addAttribute("employeeVO", employeeVO);
			result="cmmn/myPage/myInfo";
		}else {
			model.addAttribute("notCorrect","다시 입력해 주세요");
			result="cmmn/myPage/myInfoSecu";
			
		}
		
		return result;
	}
	
	//프사변경
	////{empNo:240003,proflPhoto:/9j/4AAQSkZJRgABAQAAAQA}	
	@ResponseBody
	@PostMapping("/upDateFrofl")
	public EmployeeVO upDateFrofl( @RequestBody EmployeeVO empVO,HttpSession session
			) {
		
		log.info("upDateFrofl->empVO : " + empVO);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("empNo", empVO.getEmpNo());
		map.put("proflPhoto",empVO.getProflPhoto());
		
		log.info("upDateFrofil map =>"+map);
		
		int result = this.myPageService.upDateFrofl(map);
		log.info("upDateFrofil->result : " + result);
		
		EmployeeVO newEmpVO=this.myPageService.getinfo(empVO);
		log.info("upDateFrofil empVO =>"+empVO);
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		List<GrantedAuthority> authorityList = new ArrayList<GrantedAuthority>(auth.getAuthorities());
		
		Authentication newAuth = new UsernamePasswordAuthenticationToken(new CustomUser(newEmpVO), auth.getCredentials(), authorityList);
		
		//세션반영
		SecurityContextHolder.getContext().setAuthentication(newAuth);
		
		//session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
		
		
		return newEmpVO;
	
	
	}
	
	//정보수정
	@PostMapping("/infoUpdatePost")
	public String infoUpdatePost(Model model,EmployeeVO employeeVO) {
		
		log.info("infoUpdatePost"+employeeVO);
		
		int result=0;
		
		if(employeeVO.getEmpPswd()!=null) {
			String empPswd = bcryptPasswordEncoder.encode(employeeVO.getEmpPswd());
			Map<String, Object>map=new HashMap<String, Object>();
			map.put("empPswd", empPswd);
			map.put("empNo", employeeVO.getEmpNo());
			
			
			result = this.myPageService.newPswd(map);
		}
		
		int result2=0;
		
		result2=this.myPageService.infoUpdate(employeeVO);
		
//		EmployeeVO newEmpVO=this.myPageService.getinfo(employeeVO);
		
//		model.addAttribute("newEmpVO",newEmpVO);
		
		return "redirect:/cmmn/myPage/myInfo";
		
		
	}
	
	@GetMapping("/myPageUpdatePswd")
    public String updatePswd() {
    	return "cmmn/myPage/myPageUpdatePswd";
    }
	
	@PostMapping("/checkPassword")
	@ResponseBody
	public String checkPassword(@RequestParam("empNo") String empNo, @RequestParam("password") String inputPassword) {
	    // DB에서 저장된 암호화된 비밀번호 가져오기
	    String savedPassword = this.myPageService.getPasswordByEmpNo(empNo);
	    
	    System.out.println("empNo: [" + empNo + "]");
	    System.out.println("inputPassword: [" + inputPassword + "]");
	    System.out.println("savedPassword: [" + savedPassword + "]");
	    
	    // BCrypt로 비교
	    if(bcryptPasswordEncoder.matches(inputPassword, savedPassword)) {
	        return "success";
	    }
	    return "fail";
	}

}
