package kr.or.ddit.cmmn.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.cmmn.mapper.MainPageMapper;
import kr.or.ddit.cmmn.service.MainPageService;
import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.ToDoListVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.BoardVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Transactional
@Service
public class MainPageServiceImpl implements MainPageService {

	@Autowired
	MainPageMapper mainPageMapper;

	@Override
	public AttendanceVO getEmpAttendTime(String empNo) {
		return this.mainPageMapper.getEmpAttendTime(empNo);
	}

	@Override
	public List<BoardVO> getNoticeImprtnc() {
		return this.mainPageMapper.getNoticeImprtnc();
	}
	
	@Override
	public List<BoardVO> getNotice() {
		return this.mainPageMapper.getNotice();
	}

	@Override
	public int empSttusRunUpdate(String empNo) {
		return this.mainPageMapper.empSttusRunUpdate(empNo);
	}
	
	@Override
	public int empSttusReturnUpdate(String empNo) {
		return this.mainPageMapper.empSttusReturnUpdate(empNo);
	}

	@Override
	public List<EmployeeVO> getAdreesTim(EmployeeVO employeeVO) {
		return this.mainPageMapper.getAdreesTim(employeeVO);
	}
	
	@Override
	public List<ToDoListVO> list(String empNo){
		
		log.info("listImpl 확인");
		
		return this.mainPageMapper.list(empNo);
	}

	@Override
	public int insertTodo(ToDoListVO toDoListVO) {
		log.info("insertImpl 확인");
		return this.mainPageMapper.insertTodo(toDoListVO);
	}

	@Override
	public int updateTodo(ToDoListVO toDoListVO) {
		return this.mainPageMapper.updateTodo(toDoListVO);
	}

	@Override
	public int deletePost(ToDoListVO toDoListVO) {
		return this.mainPageMapper.deletePost(toDoListVO);
	}

	@Override
	public int infoUpdate(EmployeeVO employeeVO) {
		// TODO Auto-generated method stub
		return this.mainPageMapper.infoUpdate(employeeVO);
	}
}
