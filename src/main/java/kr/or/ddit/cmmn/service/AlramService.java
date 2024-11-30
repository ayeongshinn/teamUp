package kr.or.ddit.cmmn.service;

import java.util.List;
import kr.or.ddit.cmmn.vo.AlramVO;


public interface AlramService {
	
	public List<AlramVO> alramList(String emoNo);

	public int alramCount(String emoNo);

	public int insertAlram(AlramVO alramVO);

	public int alramClick(String ntcnNo);
	
}