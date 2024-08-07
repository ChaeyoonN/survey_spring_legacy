package com.spring.survey.batch;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.transaction.annotation.Transactional;

import com.spring.survey.entity.Member;
import com.spring.survey.mapper.ISurveyMapper;

public class MemberItemWriter implements ItemWriter<Member> {

    private final ISurveyMapper memberMapper;
    //private final DataSource kjhDataSource;

    public MemberItemWriter(ISurveyMapper memberMapper) {
        this.memberMapper = memberMapper;
        //this.kjhDataSource = kjhDataSource;
    }

    @Override
    @Transactional
    public void write(List<? extends Member> items) throws Exception {
    	System.out.println("Writing members: " + items);
        System.out.println("Writing members 개수: " + items.size());
        
    	// Interface_member 테이블이 비어있는지 확인
	        if (memberMapper.selectAllInterfaceMembers().isEmpty()) {
	            // TB_00_MEMBER의 모든 데이터를 Interface_member에 삽입
	            for (Member member : items) {
	                memberMapper.insertMember(member);
	            }
	        } else {
	            // 현재 Interface_member 테이블 데이터 pk IN (tb_00_member pk)
	            List<Member> membersToUpdate = memberMapper.selectMembersInTb00();
	
	            // insert or update members
	            for (Member member : items) {
	                boolean exists = false;
	                for (Member m : membersToUpdate) {
	                    if (member.getUserId().equals(m.getUserId())) {
	                        exists = true;
	                        if(member.equals(m)) {
	                            break;
	                        } else {
	                            memberMapper.updateMember(member);
	                        }
	                    }
	                }
	                if (!exists) {
	                    memberMapper.insertMember(member);
	                }
	            }
	
	            // delete members not in tb_00_member
	            List<Member> membersToDelete = memberMapper.selectMembersNotInTb00();
	            for (Member member : membersToDelete) {
	                memberMapper.deleteMember(member);
	            }
	        }
       
    }
}

