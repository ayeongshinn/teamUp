package kr.or.ddit.cmmn.mapper;

import java.util.List;

import kr.or.ddit.cmmn.vo.AlramVO;

public interface AlramMapper {
	
	public List<AlramVO> alramList(String emoNo);
	
	public int insertAlram(AlramVO alramVO);

	public int alramCount(String emoNo);

	public int alramClick(String ntcnNo);
}
