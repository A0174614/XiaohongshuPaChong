package com.leijh.testpachong;

import java.util.Map;

import us.codecraft.webmagic.Page;
import us.codecraft.webmagic.ResultItems;
import us.codecraft.webmagic.Site;
import us.codecraft.webmagic.Spider;
import us.codecraft.webmagic.Task;
import us.codecraft.webmagic.pipeline.Pipeline;
import us.codecraft.webmagic.processor.PageProcessor;

public class MyPaChong implements PageProcessor {

    // 抓取网站的相关配置，包括编码、抓取间隔、重试次数等
    private Site site = Site.me().setRetryTimes(3).setSleepTime(100);

    public Site getSite() {
        return site;
    }

    public void process(Page page) {
    	page.putField("url", page.getHtml().regex("(?<=<meta itemprop=\"image\" content=\")https://ci.xiaohongshu.com/.+?(?=\\?ima)").all());
    }

    public static void main(String[] args) {
        Spider.create(new MyPaChong()).addUrl("http://t.cn/AiCSiMNH").addPipeline(new MyPipeline())
        		.thread(3).run();
    }
}

// 自定义实现Pipeline接口
class MyTestPipeline implements Pipeline {

    public MyTestPipeline() {
    }

    public void process(ResultItems resultitems, Task task) {
        Map<String, Object> mapResults = resultitems.getAll();
        String urlString = mapResults.get("url").toString().replace(" ", "");
        String[] url = urlString.substring(1, urlString.length() - 1).split(",");
        System.out.println("Url:");
        for(int i = 0; i < url.length; i++) {
        	System.out.println(url[i]);
        }
    }
}
