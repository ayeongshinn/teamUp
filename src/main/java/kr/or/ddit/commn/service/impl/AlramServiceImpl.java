//package kr.or.ddit.commn.service.impl;
//
//import java.util.List;
//import java.util.Map;
//
//import javax.inject.Inject;
//
//import org.springframework.stereotype.Service;
//
//import kr.or.ddit.cmmn.vo.CommonCodeVO;
//import kr.or.ddit.commn.mapper.AlramMapper;
//import kr.or.ddit.commn.service.AlramService;
//import kr.or.ddit.commn.vo.AlramVO;
//import kr.or.ddit.hr.mapper.EmployeeMapper;
//import kr.or.ddit.hr.service.EmployeeService;
//import kr.or.ddit.hr.vo.EmployeeVO;
//
//@Service
//public class AlramServiceImpl implements AlramService {
//	
//	@Inject
//	AlramMapper alramMapper;
//	
//	public void insertAlram(AlramVO alramVO) {
//		return;
//	}
//
//	public int alramCount(String memberId) {
//		return alramMapper.alramCount(memberId);
//	}
//
//	
//	public List<AlramVO> alramList(String memberId){
//		return alramMapper.alramList(memberId);
//	}
//
//	public void alramClick(String memberId, int bno){
//		return;
//	}
//	
//	
//	
//}
