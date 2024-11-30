//package kr.or.ddit.commn.controller;
//
//import java.util.List;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestMethod;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//import kr.or.ddit.cmmn.service.TodoListService;
//import kr.or.ddit.commn.service.AlramService;
//import kr.or.ddit.commn.vo.AlramVO;
//import lombok.extern.slf4j.Slf4j;
//
//@Slf4j
//@Controller
//@RequestMapping("/common")
//public class AlramController {
//	
//	//서비스 명
//	@Autowired
//	AlramService alramService;
//	
//	//알람
//	@ResponseBody
//	@RequestMapping(value = "/commn/insertAlram", method=RequestMethod.POST)
//	public int insertAlram (AlramVO alramVO) throws Exception{
////		log.info("알람insert"+categori+"//"+fromId+toId+bno+categori+title);
//		int alram = 1;
//		
//		alramService.insertAlram(alramVO);
//		
//		return alram;
//	}
//
////알람수
//	@ResponseBody
//	@RequestMapping(value = "/commn/alramCount", method=RequestMethod.GET)
//	public int alramCount (String memberId) throws Exception{
//		
//		int alram = alramService.alramCount(memberId);
//		
//		return alram;
//	}	
//	
//	
//	//알람목록
//	@ResponseBody
//	@RequestMapping(value = "/commn/alramList", method=RequestMethod.GET)
//	public List<AlramVO> alramList(String memberId) throws Exception{
//							
//		return alramService.alramList(memberId);
//	}	
//	
//	
//	//알람클릭
//	@ResponseBody
//	@RequestMapping(value = "/commn/alramClick", method=RequestMethod.POST)
//	public String alramClick(String memberId, int bno) throws Exception{
//		log.info("알람클릭");
//		alramService.alramClick(memberId, bno);
//		
//		return null;
//	}
//	
//	
//	
//	
//	
//}
//
// 