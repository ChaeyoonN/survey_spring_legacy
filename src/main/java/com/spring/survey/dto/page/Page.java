package com.spring.survey.dto.page;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
@AllArgsConstructor
@Builder
public class Page {
	private int pageNo; // 클라이언트가 보낸 페이지 번호
	private int amount; // 한 페이지에 보여질 게시물 수
	
	private boolean searchFlag; // 검색여부 판단
	
	//검색 요청에 필요한 필드를 추가
	private String keyword; // 검색 키워드
	private String condition; // 검색 조건
	
	//기본 생성자
	public Page() {
		//사용자가 처음 목록에 들어왔을 때는 페이지번호 보낼 수 없음
		this.pageNo = 1;
		this.amount = 10;
		this.searchFlag = false; // 기본적으로 검색 아닌 상태
	}
	
	//setter 커스터마이징
	public void setPageNo(int pageNo) {
		if(pageNo < 1 || pageNo > Integer.MAX_VALUE) {
			this.pageNo = 1;
			return;
		}
		this.pageNo = pageNo;
	}
	
	public void setAmount(int amount) {
		if(amount < 10 || amount > 30 || amount%10 != 0) {
			this.amount = 10;
			return;
		}
		this.amount = amount;
	}
	
	// 메서드 (인덱스가 되어 amount씩 조회)
	public int getPageStart() {
		/*
		 pageNo: 1 -> return 0
		 pageNo: 2 -> return 10
		 pageNo: 3 -> return 20
		 pageNo: 4 -> return 30
		 */
		return (pageNo - 1) * amount;
	}
	
	public int getPageEnd() {
		return pageNo * amount;
	}
}
