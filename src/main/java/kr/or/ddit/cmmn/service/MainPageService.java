package kr.or.ddit.cmmn.service;

import java.util.List;

import kr.or.ddit.cmmn.vo.AttendanceVO;
import kr.or.ddit.cmmn.vo.ToDoListVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.BoardVO;

public interface MainPageService {

	public AttendanceVO getEmpAttendTime(String empNo);

	public List<BoardVO> getNoticeImprtnc();
	
	public List<BoardVO> getNotice();

	public int empSttusRunUpdate(String empNo);
	
	public int empSttusReturnUpdate(String empNo);

	public List<EmployeeVO> getAdreesTim(EmployeeVO employeeVO);

	public List<ToDoListVO> list(String empNo);
	
	public int insertTodo(ToDoListVO toDoListVO);
	
	public int updateTodo(ToDoListVO toDoListVO);

	public int deletePost(ToDoListVO toDoListVO);

	public int infoUpdate(EmployeeVO employeeVO);
}
