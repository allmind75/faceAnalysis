<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <title>Facial Analysis</title>
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
	<style>
		.iphone {
			position: fixed;
			width: 100%;
			height: 100%;
			background: #fff;
			margin-top: 60px
		}

		.iphoneInner {
			width: 430px;
			height: 887px;
			margin-top: 50px;
			background: url(../resources/images/iphone6.png) no-repeat;
			margin: 0 auto;
			padding-top: 105px;
			padding-left: 27px;
		}

		.fa {
			font-size: 26px;
			position: absolute;
			top: 50px;
			right: 100px;
		}
	</style>
</head>

<body>
	<div class="iphone">
		<div class="iphoneInner">
			<iframe src="http://localhost:8080/m_index" width=376 height=668 frameborder=0></iframe>
		</div>
	</div>

	<script>
		window.onload = function() {
			var mobileKeyWords = new Array('iPhone', 'iPod', 'BlackBerry', 'Android', 'Windows CE', 'LG', 'MOT', 'SAMSUNG', 'SonyEricsson');
			for (var word in mobileKeyWords) {
				if (navigator.userAgent.match(mobileKeyWords[word]) != null) {
					//location.href = 'http://localhost:8080/m_index';
					break;
				}
			}
		}
	</script>
</body>
</html>