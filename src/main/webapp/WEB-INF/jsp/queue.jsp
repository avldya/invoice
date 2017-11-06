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
				<a href="${pageContext.request.contextPath}/queue.action" class="aside_nav_list-item  selected">
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
				<a href="${pageContext.request.contextPath}/fault.action" class="aside_nav_list-item">
                    <i class="fa fa-times-circle-o aside_nav_list-item-icon"></i>
                    <span>报错发票</span>
                </a>
			</div>
		</aside>
		<div class="col-lg-10 main_content">
			<div class="panel panel-default">
			    <div class="panel-heading">
			        <h3 class="panel-title">缓冲队列（共<span id="waiting_num">0</span>个待完成任务)</h3>
			    </div>
			    <div class="panel-body waiting_list" style="height:550px;">
					<!-- <img src="image/rectangle.png" class="rect_img" />
					<img src="image/rectangle.png" class="rect_img" />
					<img src="image/rectangle.png" class="rect_img" />
					<img src="image/rectangle.png" class="rect_img" /> -->
			    </div>
			</div>
		</div>
	</main>

	<!-- 模态窗口 -->
	<div class="modal fade col-lg-10" id="showWaiting" tabindex="-1" aria-hidden="true" style="margin: 0px auto; ">
		<div>
	        <div class="modal-content">
	        	<div class="modal-header">
	        		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        		<h4 class="modal-title">等待任务</h4>
	        	</div>
	        	<div class="modal-body">
	        		<div style="width: 70%; margin-right: 3%; display: inline-block; vertical-align: top;">
	        			<img src="" style="width: 100%;" id="img_info" />
	        		</div>
	        		<div style="width: 25%; display: inline-block; vertical-align: top;">
	        			<div class="panel panel-primary">
						    <div class="panel-heading">
						        <h3 class="panel-title">
						            发送用户
						        </h3>
						    </div>
						    <div class="panel-body" id="user_info">
						        xxx
						    </div>
						</div>
						<div class="panel panel-primary">
						    <div class="panel-heading">
						        <h3 class="panel-title">
						            发送时间
						        </h3>
						    </div>
						    <div class="panel-body" id="time_info">
						        xxx
						    </div>
						</div>
						<div class="panel panel-primary">
						    <div class="panel-heading">
						        <h3 class="panel-title" id="detail_info">
						            备注信息
						        </h3>
						    </div>
						    <div class="panel-body">
						        xxx
						    </div>
						</div>
	        		</div>
	        	</div>
	        	<div class="modal-footer">
	                <button type="button" class="btn btn-default" data-dismiss="modal" id="certain_progress">确定</button>
	            </div>
	        </div>
	    </div>
	</div>

	<script type="text/javascript" src="script/common.js"></script>
	<script type="text/javascript">

        //生成随机数
        function GetRandomNum(Min,Max)
		{   
			var Range = Max - Min;   
			var Rand = Math.random();   
			return(Min + parseFloat(Rand * Range));   
		}  

        $(document).ready(function(){
        	// console.log(document.documentElement.clientHeight);
        	$("#showWaiting").css("marginTop", document.documentElement.clientHeight*0.08 + "px");
        	var img_width = parseFloat($("#img_info").width());
        	$("#img_info").css("height", img_info*invoice_height/invoice_width);

        	//发送ajax请求获取当前缓冲队列
        	$.ajax({
        		url : "http://" + ip2 + "/invoice/recognizeWait.action",
        		type : "POST",
        		data : {},
        		success: function(res){
        			var data = JSON.parse(res);
        			if(data.recognize_wait != undefined) {
	        			$("#waiting_num").text(data.recognize_wait.length.toString());
	            		for(var i = 0; i < data.recognize_wait.length; i++) {
	            			$(".waiting_list").append("<img src=\"pic/rectangle.png\" class=\"rect_img\" />");
	            			var opacity_ = parseFloat(data.recognize_wait[i].image_size / 500) > 1 ? 1 : parseFloat(data.recognize_wait[i].image_size / 500);
	            			$(".waiting_list img:last-child").css("opacity", opacity_);
	            			$(".waiting_list img:last-child").get(0).base_json = data.recognize_wait[i];
	            			$(".waiting_list img:last-child").click(function() {
			        			$("#showWaiting").modal('show');
			        			tellConsole($(this).get(0).base_json, 3);
			        			var temp_json = $(this).get(0).base_json;
			        			$("#user_info").text(temp_json.user_name);
			        			$("#time_info").text(temp_json.action_start_time);
			        			$("#img_info").get(0).src = temp_json.url;
			        		})
	            		}	
        			}
        		},
        		error: function(e) {
        			tellConsole(e, 1);
        		}
        	})

        })
	</script>
</body>
</html>