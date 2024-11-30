//AttendanceController :: 신아영
package kr.or.ddit.cmmn.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import kr.or.ddit.cmmn.service.AttendanceService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.CommonCodeVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.planng.vo.NoticeVO;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.security.JwtUtilNimbus;
import kr.or.ddit.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AttendanceController {
	
	@Autowired
	AttendanceService attendanceService;
	
	//큐알 관련하여 선생님께서 적어 주신 ip 가져오는 소중한 코드 건들지 마시오 :: 신아영
	private static InetAddress getLocalHost() throws SocketException, UnknownHostException {
        try{
            
        	//NetworkInterface networkInterface = NetworkInterface.getByName("en1");
        	
        	Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
            
        	while(networkInterfaces.hasMoreElements()) {
        		NetworkInterface networkInterface = networkInterfaces.nextElement();
        		
        		for (Enumeration<InetAddress> addresses = networkInterface.getInetAddresses(); addresses.hasMoreElements(); ) {
                    InetAddress address = addresses.nextElement();
                    if (address instanceof Inet4Address && !address.isLoopbackAddress()) {
                        return address;
                    }
                }
        	}
            
        } catch(NullPointerException e){
            return InetAddress.getLocalHost();
        }
        return InetAddress.getLocalHost();
    }
	
	//큐알 생성
	@GetMapping("/createQr")
	public ResponseEntity<byte[]> createQr(Principal principal) throws Exception {
	    int width = 200;
	    int height = 200;

	    String ip = getLocalHost().getHostAddress();
	    String empNo = principal.getName(); // 사번(empNo) 가져오기

	    // Service를 통해 JWT 생성
	    String jwt = attendanceService.generateToken(empNo);

	    // URL에 JWT 포함
	    String url = "http://" + ip + "/updateAttendAjax?token=" + jwt;

	    // QR 코드 생성
	    BitMatrix matrix = new MultiFormatWriter().encode(url, BarcodeFormat.QR_CODE, width, height);

	    try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
	        MatrixToImageWriter.writeToStream(matrix, "PNG", out);
	        return ResponseEntity.ok().contentType(MediaType.IMAGE_PNG).body(out.toByteArray());
	    }
	}
	
	//큐알 촬영 시 출근 시각 update :: 신아영
	@GetMapping("/updateAttendAjax")
	@ResponseBody
	public String updateAttendAjax(@RequestParam("token") String token) throws Exception {
	    // Step 1: JWT 검증
	    if (!JwtUtilNimbus.validateToken(token)) {
	        return "FAIL: Invalid Token"; // 유효하지 않은 토큰 처리
	    }

	    // Step 2: JWT에서 empNo 추출
	    String empNo = JwtUtilNimbus.getEmpNoFromToken(token);

	    // Step 3: empNo로 출근 정보 업데이트
	    LocalDateTime attendTm = LocalDateTime.now();
	    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmmss");
	    String formattedTime = attendTm.format(timeFormatter);

	    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
	    String attendYmd = attendTm.format(dateFormatter);

	    AttendanceVO attendanceVO = new AttendanceVO();
	    attendanceVO.setEmpNo(empNo);
	    attendanceVO.setAttendTm(formattedTime);
	    attendanceVO.setAttendYmd(attendYmd);

	    int result = attendanceService.updateAttendAjax(attendanceVO);

	    return result > 0 ? "SUCCESS" : "FAIL";
	}

	
	//버튼 클릭 시 출근 시각 update :: 신아영
	@GetMapping("/updateAttendBtnAjax")
	@ResponseBody
	public int updateAttendBtnAjax() {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String empNo = authentication.getName();
		
		//현재 시각을 이와 같은 형식으로 가져옴 2024-09-14T22:23:36.951
		LocalDateTime attendTm = LocalDateTime.now();
		
		//컬럼 형식에 맞게 시각만 추출해서 포맷팅
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmmss");
		String formattedTime = attendTm.format(timeFormatter);
		
		//오늘 날짜 추출 포맷팅(yyyyMMdd)
		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		String attendYmd = attendTm.format(dateFormatter);
		
		AttendanceVO attendanceVO = new AttendanceVO();
		attendanceVO.setEmpNo(empNo);
		attendanceVO.setAttendTm(formattedTime);
		attendanceVO.setAttendYmd(attendYmd);
		
		int result = attendanceService.updateAttendBtnAjax(attendanceVO);
		
		if(result > 0) {
			return result;
		} else {
			return 0;
		}
	}
	
	   //퇴근 버튼 클릭 시 퇴근 update :: 신아영
	   @PostMapping("/updateLvffcAjax")
	   @ResponseBody
	   public int updateLvffcAjax() {
	      
	      //사원번호 가져옴
	      Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	      String empNo = authentication.getName();
	      
	      //현재 시각을 이와 같은 형식으로 가져옴 2024-09-14T22:23:36.951
	      LocalDateTime lvffcTm = LocalDateTime.now();
	      
	      //컬럼 형식에 맞게 시각만 추출해서 포맷팅
	      DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmmss");
	      String formattedTime = lvffcTm.format(timeFormatter);
	      
	      //오늘 날짜 추출 포맷팅(yyyyMMdd)
	      DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
	      String attendYmd = lvffcTm.format(dateFormatter);
	      
	      AttendanceVO attendanceVO = new AttendanceVO();
	      attendanceVO.setEmpNo(empNo);
	      attendanceVO.setLvffcTm(formattedTime);
	      attendanceVO.setAttendYmd(attendYmd);
	      
	      int result = attendanceService.updateLvffcAjax(attendanceVO);
	      
	      if(result > 0) {
	         return result;
	      } else {
	         return 0;
	      }
	      
	   }
	
	//사원 근태 조회 리스트(팀장 전용 기능) :: 장영원
	@GetMapping("/attendance/list")
	public String empAttendanceList(Model model,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "attendYmd", required = false) String attendYmd,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage
					) {
		
		// 오늘 날짜를 기본값으로 설정
	    if (attendYmd == null || attendYmd.isEmpty()) {
	        attendYmd = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")); // "yyyyMMdd" 형식
	    }
	    
	    // 현재 인증된 사용자 정보 가져오기
 		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
 		
 		// CustomUser로 캐스팅하여 EmployeeVO에 접근
 		CustomUser customUser = (CustomUser) authentication.getPrincipal();
 		EmployeeVO employeeVO = customUser.getEmployeeVO();
		
		String deptCd = employeeVO.getDeptCd();
		
		log.info("deptCd 부서 코드는 : ", deptCd);
		log.info("지정일~!~!~!~!~!~!~ 지정일``1!!~!~!!!~~!~~~" , attendYmd);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptCd", deptCd);
		map.put("keyword", keyword);
		map.put("attendYmd", attendYmd);
		map.put("currentPage", currentPage);
		
		List<AttendanceVO> attendanceVOList = this.attendanceService.list(map);
		
		log.info("attendanceVOList -> " + attendanceVOList);
		model.addAttribute("attendanceVOList", attendanceVOList);
		
		//사원 수
		int total = this.attendanceService.getTotal(map);
		log.info("list => total : " + total);
		
		//근태 사원 수 
		int deptTotal = this.attendanceService.deptTotal(deptCd);
		model.addAttribute("deptTotal", deptTotal);
		
		//미출근한 사원 수
		int absentCnt = this.attendanceService.absentCnt(map);
		model.addAttribute("absentCnt", absentCnt);
		
		// 페이지네이션 객체
		ArticlePage<AttendanceVO> articlePage = new ArticlePage<AttendanceVO>(total, currentPage, 10, attendanceVOList, keyword);
		
		model.addAttribute("articlePage", articlePage);
		model.addAttribute("attendYmd", attendYmd);
		
		return "cmmn/attendance/list";
	}
	
}
