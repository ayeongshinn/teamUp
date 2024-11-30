package kr.or.ddit.commn.socket;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.poi.hpsf.Date;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.apache.commons.lang3.StringUtils;


import kr.or.ddit.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class EchoHandler extends TextWebSocketHandler{
	//로그인 한 인원 전체
	private List<WebSocketSession> sessions = new ArrayList<WebSocketSession>();
	// 로그인중인 개별유저
	private Map<String, WebSocketSession> users = new ConcurrentHashMap<String, WebSocketSession>();
	
	
	// 클라이언트가 서버로 연결시
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {//클라이언트와 서버가 연결
		// TODO Auto-generated method stub
		log.info("Socket 연결");
		sessions.add(session);
		log.info(getMemberId(session));//현재 접속한 사람
		String senderId = getMemberId(session);
		users.put(senderId,session);
	}
	
	
	// 클라이언트가 Data 전송 시
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		log.info("handleTextMessage에 왔다");
		
		String senderId = getMemberId(session);
		log.info("handleTextMessage->senderId : " + senderId);
		
		String msg = message.getPayload();//자바스크립트에서 넘어온 Msg
		log.info("handleTextMessage->msg : "+msg);
		if (StringUtils.isNotEmpty(msg)) {
			log.info("if문 들어옴?");
			String[] strs = msg.split(",");
			if (strs != null) {
	            // 댓글 알림 처리 (기존)
	            if (strs.length == 6) {
	                String type = strs[0]; // 기능 구분
	                String replyWriter = strs[1]; // 댓글 작성자
	                String boardWriter = strs[2]; // 글 작성자
	                String bbsNo = strs[3]; // 게시글 번호
	                String title = strs[4]; // 게시글 제목
	                String bgno = strs[5]; // 게시글 카테고리
	                log.info("length 성공?" + type);

	                WebSocketSession replyWriterSession = users.get(replyWriter);
	                WebSocketSession boardWriterSession = users.get(boardWriter);
	                log.info("boardWriterSession=" + users.get(boardWriter));
	                log.info("boardWriterSession=" + boardWriterSession);

	                // 댓글 알림
	                if ("reply".equals(type) && boardWriterSession != null) {
	                    log.info("onmessage되나?");
	                    TextMessage tmpMsg = new TextMessage(replyWriter + "님이 "
	                            + "<a href='/manage/sugest/detail?bbsNo=" + bbsNo + "' style=\"color: black\">"
	                            + title + " 에 댓글을 달았습니다!</a>");
	                    boardWriterSession.sendMessage(tmpMsg);
	                }
	            }
	            
	            
	         // 메일 알림 처리 (추가된 부분)
	            else if (strs.length >= 4) { // 이메일 알림은 최소 4개 항목이 필요
	                String type = strs[0]; // 기능 구분
	                String sender = strs[1]; // 메일 발신자
	                String receiver = strs[2]; // 메일 수신자
	                String subject = strs[3]; // 메일 제목
	                String content = strs.length > 4 ? strs[4] : ""; // 메일 내용 (선택적)


	                // 수신자에 해당하는 세션을 찾아서 알림 메시지 전송
	                WebSocketSession receiverSession = users.get(receiver);
	                if (receiverSession != null) {
	                    TextMessage tmpMsg = new TextMessage(sender + "님이 \"" + subject + "\" 제목의 메일을 보냈습니다. 내용: " + content);
	                    receiverSession.sendMessage(tmpMsg);
	                }
	            }
					
				
			}
			
		}
	}
	
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
	    String senderId = getMemberId(session);
	    if (senderId != null) { // 로그인 값이 있는 경우만
	        log(senderId + " 연결 종료됨");
	        users.remove(senderId); // senderId에 해당하는 사용자를 제거
//			session.remove(session);
	    }
	}
	
	// 에러 발생시
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		log(session.getId() + " 익셉션 발생: " + exception.getMessage());

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
		
		log.info("체킁 {}",subinUser.getUsername());
		
		// 사용자 ID 가져오기
	    String getUsername = subinUser.getUsername(); // 세션에 저장된 사용자 이름
	    
	    // 로그로 가져온 사용자 ID 확인
	    log.info("getMemberId->empNo : {}", getUsername);
	    
	    // getUsername이 null인 경우 null을 그대로 반환
	    return getUsername; 
	}
}