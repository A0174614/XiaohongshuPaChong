<%@ page language="java" pageEncoding="UTF-8"%>
<%
	String basePath = request.getContextPath() + "/";
	pageContext.setAttribute("basePath", basePath);
%>
<html>
<head>
<title>jQuery Image Picker</title>
<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="css/bootstrap-responsive.css">
<link rel="stylesheet" type="text/css" href="css/examples.css">
<!--必要文件--> 
<script src="js/jquery.min.js" type="text/javascript"></script>
</head>
<body>

<div id="container">
	<h1>小红书爬虫</h1>
	<p class='lead'>请输入要爬取的网页地址：
		<input style="height:40px;width:400px" type="text" id="target_url" name="target_url" />
		<input type="button" style="height:30px;width:100px" onclick="ok()" value="确定" />
	</p>
	
	<iframe class="contentFrame" width="110%" height="100%" src="${basePath}image_picker.jsp" frameborder="0" scrolling="auto"></iframe>
</div>

<script type="text/javascript">
    function ok() {
        window.frames[0].location.href = "myPaChong/PaChong.action?url=" + $("#target_url").val();
    }
</script>
</body>
</html>