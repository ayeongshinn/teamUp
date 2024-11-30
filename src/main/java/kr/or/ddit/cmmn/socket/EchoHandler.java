 package kr.or.ddit.cmmn.socket;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.poi.hpsf.Date;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.apache.commons.lang3.StringUtils;

import kr.or.ddit.cmmn.service.AlramService;
import kr.or.ddit.cmmn.vo.AlramVO;
import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class EchoHandler extends TextWebSocketHandler{
	//로그인 한 인원 전체
	private List<WebSocketSession> sessions = new ArrayList<WebSocketSession>();
	// 로그인중인 개별유저
	private Map<String, WebSocketSession> users = new ConcurrentHashMap<String, WebSocketSession>();
	
	@Autowired
    private AlramService alramService;

	
	
	
	// afterConnectionEstablished - 서버 연결 성공 시
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {//클라이언트와 서버가 연결
		log.info("Socket 연결");
		sessions.add(session);
		log.info("현재 접속한 사람 : " + getMemberId(session));//현재 접속한 사람
		String senderId = getMemberId(session);
		log.info("senderId!! : " + senderId);
		users.put(senderId,session);
	}
	
	
	// 클라이언트가 Data 전송 시
	// handleTextMessage - 알림 송수신 시
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
	    log.info("handleTextMessage에 왔다");

	    String senderId = getMemberId(session);
	    log.info("handleTextMessage->senderId : " + senderId);

	    String msg = message.getPayload(); // 자바스크립트에서 넘어온 메시지
	    log.info("handleTextMessage->msg : " + msg);

	    if (StringUtils.isNotEmpty(msg)) {
	        String[] strs = msg.split(",");
	        log.info("strs.length : " + strs.length);

	        // 메일 알림
	        if (strs != null && "1".equals(strs[0])) {
	            String type = strs[0];     // 기능 구분
	            String sender = strs[1];   // 발신자
	            String receiver = strs[2]; // 수신자
	            String icon = strs[3];     // 아이콘 (<i class='fa-regular fa-envelope'></i>)
	            String text = strs[4];     // 텍스트 (새로운 메일이 왔습니다)
	            String url = strs[5];      // URL (cmmn/mail/list?empNo=240004)

	            // 알림 객체 생성 및 설정
	            AlramVO alramVO = new AlramVO();
	            alramVO.setCategori(type);  // 기능 구분
	            alramVO.setToid(sender);  // 수신자
	            alramVO.setFromid(receiver);  // 발신자
	            alramVO.setIcon(icon);      // 아이콘
	            alramVO.setText(text);      // 텍스트
	            alramVO.setUrl(url);        // URL


	            // 알림 테이블에 저장
	            try {
	                int result = this.alramService.insertAlram(alramVO);
	                if (result > 0) {
	                    log.info("알림이 성공적으로 저장되었습니다.");
	                } else {
	                    log.error("알림 저장에 실패했습니다.");
	                }
	            } catch (Exception e) {
	                log.error("알림 저장 중 오류 발생: ", e);
	            }
	        

	            log.info("type : " + type + ", sender : " + sender + ", receiver : " + receiver + 
	            		 ", icon : " + icon + ", text : " + text + ", url : " + url);

	            log.info("users : " + users);

	            // 수신자의 세션을 찾아 알림 메시지 전송
	            WebSocketSession receiverSession = users.get(receiver);
	            log.info("receiverSession : " + receiverSession);

	            if (receiverSession != null) {
	                String fullMessage = icon + "," + text + "," + url;
	                TextMessage tmpMsg = new TextMessage(fullMessage);
	                receiverSession.sendMessage(tmpMsg);

	                log.info(receiver + "님에게 전송 성공!");
	            }
	        }
	        
	        
	     // 캘린더 일정 등록 알림
	        else if (strs != null && "2".equals(strs[0])) {
	            String type = strs[0];     // 기능 구분 (3: 일정 등록)
	            String creator = strs[1];  // 일정 등록자
	            String participant = strs[2]; // 일정 참여자 ("ALL"인 경우 전체 사원)
	            String icon = strs[3];     // 아이콘
	            String text = strs[4];     // 텍스트
	            String url = strs[5];      // URL

	            // 알림 객체 생성 및 설정
	            AlramVO alramVO = new AlramVO();
	            alramVO.setCategori(type);
	            alramVO.setFromid(creator);
	            alramVO.setToid(participant);
	            alramVO.setIcon(icon);
	            alramVO.setText(text);
	            alramVO.setUrl(url);

	            log.info("Schedule Notification - type: " + type + ", creator: " + creator + 
	                     ", participant: " + participant + ", icon: " + icon + 
	                     ", text: " + text + ", url: " + url);

	            // 알림 테이블에 저장
	            try {
	                int result = this.alramService.insertAlram(alramVO);
	                if (result > 0) {
	                    log.info("일정 등록 알림이 성공적으로 저장되었습니다.");
	                } else {
	                    log.error("일정 등록 알림 저장에 실패했습니다.");
	                }
	            } catch (Exception e) {
	                log.error("일정 등록 알림 저장 중 오류 발생: ", e);
	            }

	            // 모든 사원에게 알림 전송
	            String fullMessage = icon + "," + text + "," + url;
	            TextMessage tmpMsg = new TextMessage(fullMessage);

	            for (WebSocketSession userSession : sessions) {
	                if (userSession.isOpen()) {
	                    userSession.sendMessage(tmpMsg);
	                }
	            }

	            log.info("일정 등록 알림이 모든 사원에게 전송되었습니다.");
	        }  
	        
	        
	        // 설문조사 등록 알림
	        else if (strs != null && "3".equals(strs[0])) {
	            String type = strs[0];     // 기능 구분 (3: 설문조사)
	            String creator = strs[1];  // 설문 작성자
	            String participant = strs[2]; // 설문 참여자 ("ALL"인 경우 전체 사원)
	            String icon = strs[3];     // 아이콘
	            String text = strs[4];     // 텍스트
	            String url = strs[5];      // URL

	            // 알림 객체 생성 및 설정
	            AlramVO alramVO = new AlramVO();
	            alramVO.setCategori(type);
	            alramVO.setFromid(creator);
	            alramVO.setToid(participant);
	            alramVO.setIcon(icon);
	            alramVO.setText(text);
	            alramVO.setUrl(url);

	            // 알림 테이블에 저장
	            try {
	                int result = this.alramService.insertAlram(alramVO);
	                if (result > 0) {
	                    log.info("설문조사 알림이 성공적으로 저장되었습니다.");
	                } else {
	                    log.error("설문조사 알림 저장에 실패했습니다.");
	                }
	            } catch (Exception e) {
	                log.error("설문조사 알림 저장 중 오류 발생: ", e);
	            }

	            // 모든 사원에게 알림 전송
	            String fullMessage = icon + "," + text + "," + url + "," + alramVO.getNtcnNo(); // ntcnNo 추가
	            TextMessage tmpMsg = new TextMessage(fullMessage);

	            for (WebSocketSession userSession : sessions) {
	                if (userSession.isOpen()) {
	                	log.info("개똥이!->userSession : "+userSession.getId());
	                    userSession.sendMessage(tmpMsg);
	                }
	            }

	            log.info("설문조사 알림이 모든 사원에게 전송되었습니다.");
	        }
	    
        
	        

	       
	        
	        
	    }
	}

	
	
	
	//afterConnectionClosed - 연결 종료 시
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
	    String senderId = getMemberId(session);
	    if (senderId != null) { // 로그인 값이 있는 경우만
	        log(senderId + " 연결 종료됨");
	        users.remove(senderId); // senderId에 해당하는 사용자를 제거
	    }
	}
	
	// 로그 메시지
	private void log(String logmsg) {
		System.out.println(new Date() + " : " + logmsg);
	}
	
	// 웹소켓에 id 가져오기
    // 접속한 유저의 http세션을 조회하여 id를 얻는 함수
	private String getMemberId(WebSocketSession session) {
		
		SecurityContext subinContext =  (SecurityContext)session.getAttributes().get("SPRING_SECURITY_CONTEXT");	
		CustomUser subinUser = (CustomUser)subinContext.getAuthentication().getPrincipal();
		
		log.info("체크 {}",subinUser.getUsername());
		
		// 사용자 ID 가져오기
	    String getUsername = subinUser.getUsername(); // 세션에 저장된 사용자 이름
	    
	    // 로그로 가져온 사용자 ID 확인
	    log.info("getMemberId->empNo : {}", getUsername);
	    
	    return getUsername; 
	}
}