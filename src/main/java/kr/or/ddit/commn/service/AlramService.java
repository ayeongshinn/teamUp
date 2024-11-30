package kr.or.ddit.commn.service;

import java.util.List;

import kr.or.ddit.commn.vo.AlramVO;

public interface AlramService {

	public void insertAlram(AlramVO alramVO);

	public int alramCount(String memberId);

	public List<AlramVO> alramList(String memberId);

	public void alramClick(String memberId, int bno);
	
}
