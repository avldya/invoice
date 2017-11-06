<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>中山大学发票识别监控系统</title>
	<meta charset="utf-8">
	<script src="script/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="script/bootstrap.min.js"></script>
	<script type="text/javascript" src="script/reconnecting-websocket.min.js"></script>
	<link rel="stylesheet" type="text/css" href="style/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="font-awesome-4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="style/layout.css">
</head>
</head>
<body>
	<header>
		<img src="pic/zhongda.jpg" style="height: 100%;" />
		<span style="display: inline-block; float: right; margin-right: 10px; line-height: 60px;">
			<i class="fa fa-user-circle" style="font-size: 30px"></i>
			<span style="margin-left: 10px; font-size: 16px;"><a href="">个人设置</a></span>
			<span style="margin-left: 10px; font-size: 16px;"><a href="login.html">退出登录</a></span>
		</span>
	</header>
	<main>
		<aside class="col-lg-2" style="margin-top: 20px;">
			<div class="aside_nav_list">
				<a href="${pageContext.request.contextPath}/queue.action" class="aside_nav_list-item">
                    <i class="fa fa-bar-chart aside_nav_list-item-icon"></i>
                    <span>缓冲队列</span>
                </a>
				<a href="${pageContext.request.contextPath}/show.action"  class="aside_nav_list-item">
                    <i class="fa fa-cog aside_nav_list-item-icon"></i>
                    <span>监控显示</span>
                </a>
				<a href="${pageContext.request.contextPath}/paint.action" class="aside_nav_list-item">
                    <i class="fa fa-clipboard aside_nav_list-item-icon"></i>
                    <span>模板库</span>
                </a>
				<a href="${pageContext.request.contextPath}/fault.action" class="aside_nav_list-item selected">
                    <i class="fa fa-times-circle-o aside_nav_list-item-icon"></i>
                    <span>报错发票</span>
                </a>
			</div>
		</aside>
		<div class="col-lg-10 main_content">
			<div class="panel panel-default">
			    <div class="panel-heading">
			        <h3 class="panel-title">未被识别图片</h3>
			    </div>
			    <div class="panel-body">
					<img src="1.bmp" class="fault_img" />
					<img src="2.bmp" class="fault_img" />
					<img src="3.bmp" class="fault_img" />
					<img src="4.bmp" class="fault_img" />
			    </div>
			</div>
		</div>
	</main>
	<script type="text/javascript" src="script/common.js"></script>
	<script type="text/javascript">
        $(document).ready(function(){
        	$(".fault_img").each(function(){
				$(this).get(0).style.height = parseFloat($(this).width() * parseFloat(invoice_height/invoice_width)) + "px";
			});
        	//connectEndpoint();
        	//ws.send("success");
        })
	</script>
</body>
</html>