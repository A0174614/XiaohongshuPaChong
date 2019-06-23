package com.leijh.testpachong;

import java.io.IOException;

import us.codecraft.webmagic.Spider;

import com.opensymphony.xwork2.ActionSupport;

public class PaChongAction extends ActionSupport {
	private static final long serialVersionUID = 1L;
	
	private String url;
	private String article;

	public String paChong() throws IOException {
		String target_url = this.url;
		if(target_url != null && target_url != "") {
			MyPipeline myPipeline = new MyPipeline();
			Spider.create(new PaChong()).addUrl(target_url).addPipeline(myPipeline).thread(3).run();
			url = myPipeline.getUrl();
			article = myPipeline.getArticle();
		}
		return ActionSupport.SUCCESS;
	}
	
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getArticle() {
		return article;
	}

	public void setArticle(String article) {
		this.article = article;
	}

}
