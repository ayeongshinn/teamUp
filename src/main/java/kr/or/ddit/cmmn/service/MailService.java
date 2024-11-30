package kr.or.ddit.cmmn.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.MailDVO;
import kr.or.ddit.cmmn.vo.MailRVO;
import kr.or.ddit.hr.vo.EmployeeVO;



public interface MailService {

	List<MailDVO> AllReclist(Map<String, Object> map);

	int getTotal(Map<String, Object> map);

	List<MailDVO> sendList(Map<String, Object> map);

	int dmailDelete(Map<String, Object> map);
	
	int rmailDelete(Map<String, Object> map);

	List<EmployeeVO> getEeptCd(String deptCd);

	EmployeeVO getEmp(String empNo);

	int registDmail(Map<String, Object> map);

	String getMailNo();

	int registRmail(Map<String, Object> map2);

	int getRcptnSn();

	int getSendTotal(Map<String, Object> map);

	MailDVO rMailDetele(Map<String, Object> map);

	List<MailDVO> delList(Map<String, Object> map);

	int getDelTotal(Map<String, Object> map);

	int setPrsY(Map<String, Object> map);

	int setRspamY(Map<String, Object> map);

	int setRspamN(Map<String, Object> map);

	List<MailDVO> bookMarkList(Map<String, Object> map);

	int getBMTotal(Map<String, Object> map);

	List<MailDVO> toMeList(Map<String, Object> map);

	int gettoMeTotal(Map<String, Object> map);

	int setDmailDelN(Map<String, Object> map);

	int setRmailDelN(Map<String, Object> map);

	List<MailDVO> NReadMailList(Map<String, Object> map);

	int getNReadMailTotal(Map<String, Object> map);

	MailDVO toMeDetail(Map<String, Object> map);

	List<MailDVO> DMailDetail(Map<String, Object> map);

	List<MailRVO> recptnEmpList(String mailNo);


}
