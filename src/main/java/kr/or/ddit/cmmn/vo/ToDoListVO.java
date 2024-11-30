package kr.or.ddit.cmmn.vo;

import lombok.Data;

// ToDoList 
@Data
public class ToDoListVO {
	private String listNo;
	private String goalNm;
	private String empNo;
	private String delYn;
	private String checkSta;
	
	
	public String getListNo() {
	    return listNo;
	}

	public void setListNo(String listNo) {
	    this.listNo = listNo;
	}
}

