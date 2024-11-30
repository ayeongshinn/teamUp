package kr.or.ddit.bsn.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.bsn.vo.BusinessProgressVO;

@Mapper
public interface BusinessProgressMapper {

	/** 영업 진척도 등록
	 * 
	 * @param businessProgressVO
	 * @return
	 */
	public int businessInsert(BusinessProgressVO businessProgressVO);
	
	
	/** Chart 데이터 조회
	 * 
	 * @return
	 */
	public List<BusinessProgressVO> chartDataList();

	/** 영업 진척도 상세 조회
	 * 
	 * @param manageNo
	 * @return
	 */
	public BusinessProgressVO businessDetail(String manageNo);

	/** 영업 진척도 수정 페이지용
	 * 
	 * @param manageNo
	 * @return
	 */
	public BusinessProgressVO businessUpdate(String manageNo);

	/** 영업 진척도 수정 실행
	 * 
	 * @param businessProgressVO
	 * @return
	 */
	public int businessUpdatePost(BusinessProgressVO businessProgressVO);

	/** 영업 진척도 삭제 실행
	 * 
	 * @param bsnNm
	 * @return
	 */
	public int businessDeletePost(String bsnNm);

}
