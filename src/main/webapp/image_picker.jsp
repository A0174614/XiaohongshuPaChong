<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
<title>jQuery Image Picker</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>/css/bootstrap-responsive.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>/css/examples.css">
<!--必要文件--> 
<link rel="stylesheet" type="text/css" href="<%=basePath%>/css/image-picker.css">
<script src="<%=basePath%>/js/jquery.min.js" type="text/javascript"></script>
<!--瀑布流布局插件-->
<script src="<%=basePath%>/js/jquery.masonry.min.js" type="text/javascript"></script>
<!--图片选择器插件-->
<script src="<%=basePath%>/js/image-picker.min.js" type="text/javascript"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.5/jszip.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
<!--剪贴板-->
<script type="text/javascript" src="<%=basePath%>/js/clipboard.min.js"></script>
</head>
<body>

<div id="container">
	<div class="picker">
		<div id="article">
			${article}
		</div>
		<button id="button" onclick="copy()" class="btn">复制到剪贴板</button><span id="status0"></span>
		<br/><br/><br/>
		<button id="button1" onclick="packageImages('status')">下载</button><span id="status"></span>
		<select id="my-image-picker" class="image-picker masonry" multiple="multiple">
		</select>
		<input type="hidden" id="url" name="url" value="${url}"/>
		<button id="button2" onclick="packageImages('status1')">下载</button><span id="status1"></span>
	</div>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		var img_url = $("#url").val().split(",");
		$("#button").hide();
		$("#button1").hide();
		$("#button2").hide();
		if(img_url != "") {
			$.each(img_url, function(index, obj){
	        	$("select[class='image-picker masonry']").append("<option data-img-src='" + obj + "' value='" + index + "'/>");
	        	$("ul[class='thumbnails image_picker_selector']").append("<li><div class='thumbnail'><img class='image_picker_image' src='" + obj +"'></div></li>");
	        });
			$("#button").show();
			$("#button1").show();
			$("#button2").show();
		}
	
		$("select.image-picker").imagepicker({
			hide_select:true
		});
		
		//瀑布流布局
		var container = $("select.image-picker.masonry").next("ul.thumbnails");
		
		container.imagesLoaded(function(){ 
			container.masonry({ 
				itemSelector:"li"
			}); 
		});
		
	});
	
	function copy() {
		var clipboard = new ClipboardJS('.btn', {
	        text: function() {
	            return $.trim($("#article").text());
	        }
	    });
	    clipboard.on('success', function(e) {//复制成功执行的回调，可选
	    	$("#status0").text('复制成功');
	    });
	}

	function packageImages(sele){
		var status = $("#" + sele);
		status.text('处理中。。。。。');
		
		var imgs = $("div[class='thumbnail selected']").children('img');
		var imgBase64 = [];
		var imageSuffix = [];//图片后缀
		var zip = new JSZip();
	    var img = zip.folder("images");
	    
		for(var i=0;i<imgs.length;i++){
			var src = imgs[i].getAttribute("src");
			var suffix = ".jpg";
			console.log(suffix);
			imageSuffix.push(suffix);
			
			getBase64(imgs[i].getAttribute("src"))
			         .then(function(base64){
			         	imgBase64.push(base64.substring(22));
			         },function(err){
			               console.log(err);//打印异常信息
			         }); 
		}
		
		function tt(status){
			setTimeout(function(){
				if(imgs.length == imgBase64.length){
					for(var i=0;i<imgs.length;i++){
						img.file(i+imageSuffix[i], imgBase64[i], {base64: true});
					}
					zip.generateAsync({type:"blob"}).then(function(content) {
				        saveAs(content, "images.zip");
				    });
					status.text('处理完成。。。。。');
				    
				}else{
					status.text('已完成：'+imgBase64.length+'/'+imgs.length);
					tt(status);
				}
			},100);
			
		}
		tt(status);
	}
	
    //传入图片路径，返回base64
    function getBase64(img){
        function getBase64Image(img,width,height) {
          var canvas = document.createElement("canvas");
          canvas.width = width ? width : img.width;
          canvas.height = height ? height : img.height;
 
          var ctx = canvas.getContext("2d");
          ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
          var dataURL = canvas.toDataURL();
          return dataURL;
        }
        var image = new Image();
        image.crossOrigin = 'Anonymous';
        image.src = img;
        var deferred=$.Deferred();
        if(img){
          image.onload =function (){
            deferred.resolve(getBase64Image(image));
          }
          return deferred.promise();
        }
      }
</script>
</body>
</html>