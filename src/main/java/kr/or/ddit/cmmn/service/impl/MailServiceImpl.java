package kr.or.ddit.cmmn.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.cmmn.mapper.MailMapper;
import kr.or.ddit.cmmn.service.MailService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.MailDVO;
import kr.or.ddit.cmmn.vo.MailRVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.hr.vo.HrVacationVO;
import kr.or.ddit.util.UploadController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MailServiceImpl implements MailService {
	@Autowired
	MailMapper mailMapper;
	@Inject
	UploadController uploadController;

	@Override
	public List<MailDVO> AllReclist(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.AllReclist(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.getTotal(map);
	}

	@Override
	public List<MailDVO> sendList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.sendList(map);
	}

	@Override
	public int dmailDelete(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.dmailDelete(map);
	}
	@Override
	public int rmailDelete(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.rmailDelete(map);
	}

	@Override
	public List<EmployeeVO> getEeptCd(String deptCd) {
		// TODO Auto-generated method stub
		return this.mailMapper.getEeptCd(deptCd);
	}

	@Override
	public EmployeeVO getEmp(String empNo) {
		// TODO Auto-generated method stub
		return this.mailMapper.getEmp(empNo);
	}

	@Override
	public int registDmail(Map<String, Object> map) {
		// TODO Auto-generated method stub
		int result = 0;
		MailDVO mailDVO=new MailDVO();
		MultipartFile[] multipartFiles = (MultipartFile[]) map.get("uploadFile");
		if(multipartFiles != null && multipartFiles.length > 0 && 
		    multipartFiles[0].getOriginalFilename() != null && 
		    multipartFiles[0].getOriginalFilename().length() > 0)  {
			//1. 첨부파일 처리
			int fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);	
			//registPost->fileGroupNo : 48
			log.info("registPost->fileGroupNo : " + fileGroupNo);
			
			//2. 데이터 등록
			mailDVO.setFileGroupNo(fileGroupNo);		
			map.put("fileGroupNo", mailDVO.getFileGroupNo());
		}
		result +=this.mailMapper.registDmail(map);
		
		return result;
	}

	@Override
	public String getMailNo() {
		// TODO Auto-generated method stub
		return this.mailMapper.getMailNo();
	}

	@Override
	public int registRmail(Map<String, Object> map2) {
		// TODO Auto-generated method stub
		return this.mailMapper.registRmail(map2);
	}

	@Override
	public int getRcptnSn() {
		// TODO Auto-generated method stub
		return this.mailMapper.getRcptnSn();
	}

	@Override
	public int getSendTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.getSendTotal(map);
	}

	@Override
	public MailDVO rMailDetele(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.rMailDetele(map);
	}

	@Override
	public List<MailDVO> delList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.delList(map);
	}

	@Override
	public int getDelTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.getDelTotal(map);
	}

	@Override
	public int setPrsY(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.setPrsY(map);
	}

	@Override
	public int setRspamY(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.setRspamY(map);
	}

	@Override
	public int setRspamN(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.setRspamN(map);
	}

	@Override
	public List<MailDVO> bookMarkList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.bookMarkList(map);
	}

	@Override
	public int getBMTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.getBMTotal(map);
	}

	@Override
	public List<MailDVO> toMeList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.toMeList(map);
	}

	@Override
	public int gettoMeTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.gettoMeTotal(map);
	}

	@Override
	public int setDmailDelN(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.setDmailDelN(map);
	}

	@Override
	public int setRmailDelN(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.setRmailDelN(map);
	}

	@Override
	public List<MailDVO> NReadMailList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.NReadMailList(map);
	}

	@Override
	public int getNReadMailTotal(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.getNReadMailTotal(map);
	}

	@Override
	public MailDVO toMeDetail(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.toMeDetail(map);
	}

	@Override
	public List<MailDVO> DMailDetail(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.mailMapper.DMailDetail(map);
	}

	@Override
	public List<MailRVO> recptnEmpList(String mailNo) {
		// TODO Auto-generated method stub
		return this.mailMapper.recptnEmpList(mailNo);
	}

}
