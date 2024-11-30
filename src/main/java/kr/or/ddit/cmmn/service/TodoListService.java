package kr.or.ddit.cmmn.service;

import java.util.List;
import kr.or.ddit.cmmn.vo.ToDoListVO;


public interface TodoListService {

	public List<ToDoListVO> list(String empNo);
	
	public int insertTodo(ToDoListVO toDoListVO);
	
	public int updateTodo(ToDoListVO toDoListVO);

	public int deletePost(ToDoListVO toDoListVO);

	public int allDelete(ToDoListVO toDoListVO);

	public int checkSta(String listNo);

	public int checkStaOff(String listNo);


}
