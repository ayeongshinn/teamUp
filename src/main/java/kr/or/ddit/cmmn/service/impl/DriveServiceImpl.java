package kr.or.ddit.cmmn.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.cmmn.mapper.DriveMapper;
import kr.or.ddit.cmmn.service.DriveService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Transactional
@Service
public class DriveServiceImpl implements DriveService{
	
	@Autowired
	DriveMapper driveMapper;
}
