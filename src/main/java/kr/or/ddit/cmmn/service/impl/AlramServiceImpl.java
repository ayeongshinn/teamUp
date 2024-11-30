package kr.or.ddit.cmmn.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import kr.or.ddit.cmmn.mapper.AlramMapper;
import kr.or.ddit.cmmn.service.AlramService;
import kr.or.ddit.cmmn.vo.AlramVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AlramServiceImpl implements AlramService {

    @Inject
    private AlramMapper alramMapper; 

    @Override
    public List<AlramVO> alramList(String emoNo) {
        log.info("AlramServiceImpl list 왔냐?");
        return alramMapper.alramList(emoNo);
    }

    @Override
    public int insertAlram(AlramVO alramVO) {
        log.info("AlramServiceImpl 왔냐?");
        return alramMapper.insertAlram(alramVO);
    }

    @Override
    public int alramCount(String emoNo) {
        return alramMapper.alramCount(emoNo);
    }
    
    @Override
    public int alramClick(String ntcnNo) {
        log.info("알림 클릭 처리 시작: NTCN_NO = {}", ntcnNo);
        return alramMapper.alramClick(ntcnNo);
    }
}
