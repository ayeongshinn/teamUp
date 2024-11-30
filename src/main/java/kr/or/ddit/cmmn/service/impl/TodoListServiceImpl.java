package kr.or.ddit.cmmn.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.ddit.cmmn.mapper.TodoListMapper;
import kr.or.ddit.cmmn.service.TodoListService;
import kr.or.ddit.cmmn.vo.ToDoListVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TodoListServiceImpl implements TodoListService {
	
	@Autowired
	TodoListMapper todoListMapper;
	
	@Override
	public List<ToDoListVO> list(String empNo){
		
		log.info("listImpl 확인");
		
		return this.todoListMapper.list(empNo);
		
	}

	@Override
	public int insertTodo(ToDoListVO toDoListVO) {
		log.info("insertImpl 확인");
		return this.todoListMapper.insertTodo(toDoListVO);
	}

	@Override
	public int updateTodo(ToDoListVO toDoListVO) {
		return this.todoListMapper.updateTodo(toDoListVO);
	}

	@Override
	public int deletePost(ToDoListVO toDoListVO) {
		return this.todoListMapper.deletePost(toDoListVO);
	}
	
	@Override
	public int allDelete(ToDoListVO toDoListVO) {
		return this.todoListMapper.allDelete(toDoListVO);
	}
	
	@Override
	public int checkSta(String listNo) {
		return this.todoListMapper.checkSta(listNo);
	}

	@Override
	public int checkStaOff(String listNo) {
		return this.todoListMapper.checkStaOff(listNo);
	}
	
	
	
	

}
