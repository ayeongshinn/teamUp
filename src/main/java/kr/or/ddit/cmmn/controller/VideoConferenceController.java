package kr.or.ddit.cmmn.controller;

import java.io.IOException;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import oracle.jdbc.proxy.annotation.Post;

@Slf4j
@Controller
public class VideoConferenceController {
	
	@GetMapping("/videoList")
	public String videoList(Model model) throws Exception {
		OkHttpClient client = new OkHttpClient();

		Request request = new Request.Builder()
		  .url("https://openapi.gooroomee.com/api/v1/room/list?page=1&limit=10&sortCurrJoinCnt=true")
		  .get()
		  .addHeader("accept", "application/json")
		  .addHeader("X-GRM-AuthToken", "12056163501988613cf51b7b51cdd8140bb172761d02211a8b")
		  .build();

		Response response = client.newCall(request).execute();
		
		JSONParser jsonParser = new JSONParser();
		Object obj = jsonParser.parse(response.body().string());
		JSONObject jsonObj = (JSONObject) obj;
		
		model.addAttribute("roomList", jsonObj);
		
		return "cmmn/videoConference/videoList";
	}
	
	@GetMapping("/videoRegist")
	public String videoRegis() {
		return "cmmn/videoConference/videoRegist";
	}
	
	
	@PostMapping("/roomRegist")
	@ResponseBody
	public JSONObject videoRegist(@RequestBody Map<String, Object> value) throws Exception {
	    
	    // 클라이언트에서 전달된 방 이름과 비밀번호 추출
	    String roomName = value.get("roomName").toString();
	    String passwd = value.get("passwd").toString();

	    log.info("roomName: " + roomName);
	    log.info("passwd: " + passwd);

	    OkHttpClient client = new OkHttpClient();

	    MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
	    okhttp3.RequestBody body = okhttp3.RequestBody.create(mediaType, "callType=P2P&liveMode=false&maxJoinCount=4&liveMaxJoinCount=100&layoutType=4&sfuIncludeAll=true&roomTitle="+roomName+"&passwd="+passwd);
	    Request request = new Request.Builder()
	      .url("https://openapi.gooroomee.com/api/v1/room")
	      .post(body)
	      .addHeader("accept", "application/json")
	      .addHeader("content-type", "application/x-www-form-urlencoded")
	      .addHeader("X-GRM-AuthToken", "12056163501988613cf51b7b51cdd8140bb172761d02211a8b")
	      .build();

	    Response response = client.newCall(request).execute();
	    log.info("방 생성 응답 코드: " + response.code());
	    
//	    client = new OkHttpClient();
//	    request = new Request.Builder()
//		  .url("https://openapi.gooroomee.com/api/v1/room/list?page=1&limit=10&sortCurrJoinCnt=true")
//		  .get()
//		  .addHeader("accept", "application/json")
//		  .addHeader("X-GRM-AuthToken", "12056163501988613cf51b7b51cdd8140bb172761d02211a8b")
//		  .build();
//
//		response = client.newCall(request).execute();
		
		JSONParser jsonParser = new JSONParser();
		Object obj = jsonParser.parse(response.body().string());
		JSONObject jsonObj = (JSONObject) obj;
	    
		log.info("jsonObj : {}", jsonObj);
		
	    return jsonObj;
	}
	
	
	@PostMapping("/getRoomUrl")
	@ResponseBody
	public JSONObject getRoomUrl(@RequestParam("roomId") String roomId) throws Exception {
		// 현재 인증된 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		// CustomUser로 캐스팅하여 EmployeeVO에 접근
		CustomUser customUser = (CustomUser) authentication.getPrincipal();
		EmployeeVO employeeVO = customUser.getEmployeeVO();
		
	    OkHttpClient client = new OkHttpClient();

	    // 요청에 필요한 데이터 생성 (roomId를 함께 전달)
	    MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
	    okhttp3.RequestBody body = okhttp3.RequestBody.create(mediaType, "roleId=participant&ignorePasswd=false&roomId=" + roomId + "&username=" + employeeVO.getEmpNm() + "&apiUserId" + employeeVO.getEmpNo());

	    // 요청을 빌드
	    Request request = new Request.Builder()
	      .url("https://openapi.gooroomee.com/api/v1/room/user/otp/url")
	      .post(body)
	      .addHeader("accept", "application/json")
	      .addHeader("content-type", "application/x-www-form-urlencoded")
	      .addHeader("X-GRM-AuthToken", "12056163501988613cf51b7b51cdd8140bb172761d02211a8b") // 유효한 인증 토큰 필요
	      .build();

	    // 요청 실행 및 응답 처리
	    Response response = client.newCall(request).execute();

	    // 응답을 JSON으로 파싱
	    JSONParser jsonParser = new JSONParser();
	    Object obj = jsonParser.parse(response.body().string());
	    JSONObject jsonObj = (JSONObject) obj;

	    // 로그에 JSON 응답 출력
	    log.info("getRoomUrl jsonObj : {}", jsonObj);

	    return jsonObj; // JSON 응답 반환
	}


	@PostMapping("/videoDetail")
	public String videoDetail(@RequestParam("roomId") String roomId,
	                          @RequestParam("passwd") String passwd, Model model) throws Exception {

	    log.info("roomId: " + roomId);
	    log.info("passwd: " + passwd);

	    OkHttpClient client = new OkHttpClient();

	    // 방 정보에서 비밀번호 가져오는 로직
	 // 확인해야 할 부분 - 방 정보 조회 경로가 올바른지
	    Request passwordRequest = new Request.Builder()
	        .url("https://openapi.gooroomee.com/api/v1/room/" + roomId)  // 경로 확인
	        .get()
	        .addHeader("accept", "application/json")
	        .addHeader("X-GRM-AuthToken", "12056163501988613cf51b7b51cdd8140bb172761d02211a8b")
	        .build();


	    Response passwordResponse = client.newCall(passwordRequest).execute();
	    log.info("API 응답 코드: " + passwordResponse.code());

	    if (!passwordResponse.isSuccessful()) {
	        log.error("방 정보를 가져오는 데 실패했습니다. 응답 코드: " + passwordResponse.code());
	        model.addAttribute("error", "방 정보를 가져오는 데 실패했습니다.");
	        return "error/error500"; 
	    }

	    JSONParser jsonParser = new JSONParser();
	    JSONObject roomData = (JSONObject) jsonParser.parse(passwordResponse.body().string());
	    log.info("받아온 roomData JSON: " + roomData.toJSONString());

	    // 방이 존재하지 않는 경우 확인
	    if ("GRM_703".equals(roomData.get("resultCode"))) {
	        log.error("방이 존재하지 않습니다: " + roomData.get("description"));
	        model.addAttribute("error", "방이 존재하지 않습니다.");
	        return "error/error500";
	    }

	    // 비밀번호 필드가 존재하는지 확인
	    String storedPassword = (String) roomData.get("passwd");
	    if (storedPassword == null || storedPassword.isEmpty()) {
	        log.error("방에 비밀번호가 설정되지 않았습니다.");
	        model.addAttribute("error", "방에 비밀번호가 설정되지 않았습니다.");
	        return "error/error500";
	    }

	    // 입력된 비밀번호와 비교
	    if (!passwd.equals(storedPassword)) {
	        log.error("비밀번호가 일치하지 않습니다.");
	        model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
	        return "error/error500";
	    }

	    // 비밀번호가 일치하면 회의 OTP URL 요청
	    MediaType mediaType = MediaType.parse("application/x-www-form-urlencoded");
	    okhttp3.RequestBody body = okhttp3.RequestBody.create(mediaType, 
	        "roleId=participant" +        // 역할 설정
	        "&apiUserId=gooroomee-tester" + // 사용자 ID
	        "&ignorePasswd=false" +         // 비밀번호 무시 여부 (false로 설정)
	        "&roomId=" + roomId);          // 필수 roomId 추가
	    
	    Request request = new Request.Builder()
	        .url("https://openapi.gooroomee.com/api/v1/room/user/otp/url")
	        .post(body)
	        .addHeader("accept", "application/json")
	        .addHeader("content-type", "application/x-www-form-urlencoded")
	        .addHeader("X-GRM-AuthToken", "12056163501988613cf51b7b51cdd8140bb172761d02211a8b")
	        .build();

	    Response response = client.newCall(request).execute();
	    log.info("OTP URL 요청 응답 코드: " + response.code());

	    if (!response.isSuccessful()) {
	        log.error("회의 참여 URL을 가져오지 못했습니다. 응답 코드: " + response.code());
	        model.addAttribute("error", "회의 참여 URL을 가져오지 못했습니다.");
	        return "error/error500";
	    }

	    // OTP URL 가져오기
	    Object obj = jsonParser.parse(response.body().string());
	    JSONObject jsonObj = (JSONObject) obj;

	    // 모델에 OTP URL 정보 추가
	    model.addAttribute("room", jsonObj);

	    return "cmmn/videoConference/videoDetail"; // 성공 시 회의 상세 페이지로 이동
	}

}
