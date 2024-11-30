package kr.or.ddit.cmmn.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cmmn.vo.FileDetailVO;
import kr.or.ddit.cmmn.vo.TaskDiaryVO;
import kr.or.ddit.hr.vo.EmployeeVO;
import kr.or.ddit.manage.vo.CommentVO;

public interface TaskDiaryMapper {

	public List<TaskDiaryVO> list(Map<String, Object> map);
	
	public int getTotal(Map<String, Object> map);

	public TaskDiaryVO detail(String diaryNo);

	public int registPost(TaskDiaryVO takDiaryVO);

	public int updateAjax(TaskDiaryVO taskDiaryVO);

	public int updatePost(TaskDiaryVO taskDiaryVO);

	public int deletePost(TaskDiaryVO taskDiaryVO);
	
	

	public int registCommentPost(CommentVO commentVO);

	public int deleteCommentAjax(CommentVO commentVO);

	public List<CommentVO> listComment(CommentVO commentVO);

	public int updateCommentAjax(CommentVO commentVO);

	public EmployeeVO getEmployeeInfo(String empNo);

}
