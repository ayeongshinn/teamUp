package kr.or.ddit.cmmn.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.cmmn.mapper.TaskDiaryMapper;
import kr.or.ddit.cmmn.service.TaskDiaryService;
import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.cmmn.vo.TaskDiaryVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.CommentVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TaskDiaryServiceImpl implements TaskDiaryService {
	
	@Inject
	TaskDiaryMapper taskDiaryMapper;
	
	
	@Override
	public List<TaskDiaryVO> list(Map<String, Object> map){
		log.info("listImpl 확인");
		
		return this.taskDiaryMapper.list(map);
	}
	
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.taskDiaryMapper.getTotal(map);
	}
	
	@Override
	public TaskDiaryVO detail(String diaryNo) {
		 log.info("taskDiaryVO 확인");
		 return taskDiaryMapper.detail(diaryNo);
	}
	
	
	
	@Override
	public int registPost(TaskDiaryVO takDiaryVO) {
		return this.taskDiaryMapper.registPost(takDiaryVO);
	}
	
	@Override
	public int deletePost(TaskDiaryVO taskDiaryVO) {
		return this.taskDiaryMapper.deletePost(taskDiaryVO);
	}
	
	@Override
	public int updateAjax(TaskDiaryVO taskDiaryVO) {
		return this.taskDiaryMapper.updateAjax(taskDiaryVO);
	}


	@Override
	public int updatePost(TaskDiaryVO taskDiaryVO) {
		return this.taskDiaryMapper.updatePost(taskDiaryVO);
	}
	
	@Override
	public EmployeeVO getEmployeeInfo(String empNo){
		return this.taskDiaryMapper.getEmployeeInfo(empNo);
	}
	
	
	
	
	@Override
	public int registCommentPost(CommentVO commentVO){
		return this.taskDiaryMapper.registCommentPost(commentVO);
	}

	@Override
	public int deleteCommentAjax(CommentVO commentVO){
		return this.taskDiaryMapper.deleteCommentAjax(commentVO);
	}
	
	@Override
	public List<CommentVO> listComment(CommentVO commentVO){
		return this.taskDiaryMapper.listComment(commentVO);
	}

	@Override
	public int updateCommentAjax(CommentVO commentVO){
		return this.taskDiaryMapper.updateCommentAjax(commentVO);
	}

	
	
}
