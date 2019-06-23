package com.leijh.testpachong;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import us.codecraft.webmagic.Page;
import us.codecraft.webmagic.ResultItems;
import us.codecraft.webmagic.Site;
import us.codecraft.webmagic.Spider;
import us.codecraft.webmagic.Task;
import us.codecraft.webmagic.pipeline.Pipeline;
import us.codecraft.webmagic.processor.PageProcessor;

public class PaChong implements PageProcessor {

    // 抓取网站的相关配置，包括编码、抓取间隔、重试次数等
    private Site site = Site.me().setRetryTimes(3).setSleepTime(100).setCharset("utf-8");

    public Site getSite() {
        return site;
    }

    public void process(Page page) {
    	page.putField("url", page.getHtml().regex("(?<=<meta itemprop=\"image\" content=\")https://ci.xiaohongshu.com/.+?(?=\\?ima)").all());
//    	page.putField("article", page.getHtml().regex("(?<=<p data-v-\\w{1,100}>).+?(?=</p>)").all());
    	page.putField("article", page.getHtml().regex("<p data-v-.+?>.*?</p>").all());
    }

    public static void main(String[] args) {
        Spider.create(new PaChong()).addUrl("http://t.cn/AiCSiMNH").addPipeline(new MyPipeline()).thread(3).run();
    }
}

// 自定义实现Pipeline接口
class MyPipeline implements Pipeline {
	private String article;
	private String url;

    public MyPipeline() {
    }

    public void process(ResultItems resultitems, Task task) {
        Map<String, Object> mapResults = resultitems.getAll();
        String urlString = mapResults.get("url").toString().replace(" ", "");
        urlString = urlString.substring(1, urlString.length() - 1);
        this.url = urlString;
        
        String articleString = mapResults.get("article").toString();
        String[] articleStringArg = articleString.substring(1, articleString.length() - 1).split(",");
        String[] newArticleStringArg = new String[articleStringArg.length - 1];
        for(int i = 1; i < articleStringArg.length; i++) {
        	newArticleStringArg[i-1] = articleStringArg[i].substring(1,articleStringArg[i].length());
        }
        articleString = StringUtils.join(newArticleStringArg, "\n");
        this.article = articleString;
    }
    
    public String getUrl(){
    	return url;
    }
    
    public String getArticle() {
		return article;
	}
    
}
