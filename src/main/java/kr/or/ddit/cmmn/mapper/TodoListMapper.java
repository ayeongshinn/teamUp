package kr.or.ddit.cmmn.mapper;

import java.util.List;
import kr.or.ddit.cmmn.vo.ToDoListVO;

public interface TodoListMapper {

	//<select id="list" parameterType="String" resultMap="todoListResultMap">
	public List<ToDoListVO> list(String empNo);
	
	public int insertTodo(ToDoListVO toDoListVO);
	
	public int updateTodo(ToDoListVO toDoListVO);

	public int deletePost(ToDoListVO toDoListVO);

	public int checkSta(String listNo);

	public int allDelete(ToDoListVO toDoListVO);

	public int checkStaOff(String listNo);

}
