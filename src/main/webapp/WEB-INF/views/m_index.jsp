<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Face Analysis</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0 user-scalable=no, maximum-scale=1.0, minimum-scale=1.0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--safari에서 버튼과 주소창 안보이게-->
    
    <!-- 바로가기 아이콘-->
    <link rel="shorcut icon" href="../resources/images/favicon.ico">
    
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
    <link href="../resources/css/style.css" rel="stylesheet" type="text/css">
    <script src="https://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4=" crossorigin="anonymous"></script>
    <script type="text/javascript" src="../resources/js/prefixfree.min.js"></script>
    
    <link rel="apple-touch-icon" sizes="57x57" href="../resources/images/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="../resources/images/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="../resources/images/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="../resources/images/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="../resources/images/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="../resources/images/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="../resources/images/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="../resources/images/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="../resources/images/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="../resources/images/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../resources/images/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="../resources/images/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="../resources/images/favicon-16x16.png">
    <link rel="manifest" href="../resources/images/manifest.json">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-TileImage" content="../resources/images/ms-icon-144x144.png">
    <meta name="theme-color" content="#ffffff">
</head>

<body>
    <h1>Face Analysis</h1>
    
    <section>
        <img id="pic">
        <div class="fileBox">
            <!--<input type="text" class="fileName" readonly="readonly">-->
            <label for="cameraBtn" class="btn_file"><i class="fa fa-camera"></i></label>
            <input type="file" id="cameraBtn" class="cameraBtn" name="file" capture="camera" accept="image/*">
			<label for="albumBtn" class="btn_album"><i class="fa fa-image"></i></label>
            <input type="file" id="albumBtn" name="album">
        </div>
    </section>

    <section class="result-wrap">
        <ul>
            <li class="sex">
                <p id="sex">?</p>
                <div class="line"></div>
                <p class="confidence">정확도 <span id="sex-confidence">?</span></p>
            </li>
            <li class="age">
                <p id="age">?</p>
                <div class="line"></div>
                <p class="confidence">정확도 <span id="age-confidence">?</span></p>
            </li>
            <li class="emotion">
                <p id="emotion">?</p>
                <div class="line"></div>
                <p class="confidence">정확도 <span id="emotion-confidence">?</span></p>
            </li>
        </ul>
    </section>

	<div class="searching-bg"></div>
	<div class="load"></div>
	
    <a href="http://developers.naver.com" target="_blank">
        <img class="naver-api-img" src="../resources/images/naverOpenAPI2.png" alt="NAVER 오픈 API">
    </a>
    
    <script>
	    var emotionType = {
	    	    angry: "화남",
	    	    disgust: "싫어",
	    	    fear: "겁먹음",
	    	    laugh: "웃겨",
	    	    neutral: "무표정",
	    	    sad: "슬퍼",
	    	    surprise: "놀람",
	    	    smile: "방긋",
	    	    talking: "말함"
	    	};

    	$('#cameraBtn, #albumBtn').change(function(e) {

    	    $('.searching-bg').css({
    	        "display": "block"
    	    }); //투명배경 on
    	    $('.load').css({
    	        "display": "block"
    	    });

    	    var imgFile = URL.createObjectURL(e.target.files[0]); //파일 이름
    	    var file = e.target.files[0]; //파일 가져오기
    	    var formData = new FormData();
    	    formData.append("file", file);

    	    $('#pic').attr('src', imgFile);

    	    $.ajax({
    	        url: '/uploadFile',
    	        data: formData,
    	        dataType: 'text',
    	        processData: false,
    	        contentType: false,
    	        type: 'POST',
    	        success: function(data) {

    	            var jsonData = JSON.parse(data);

    	            if (jsonData.info.faceCount == 1) {
    	                alert("완료되었습니다.");
    	                var jsonObject = jsonData.faces[0];
    	                addResult(jsonObject);
    	            } else {
    	                alert('사진 인식에 실패하였습니다.')
    	                $('#pic').attr('src', '');
    	            }
    	            $('.searching-bg').css({
    	                "display": "none"
    	            }); //투명 배경 off
    	            $('.load').css({
    	                "display": "none"
    	            });
    	        }
    	    });
    	});

    	$(document).ready(function() {
    	    if (!('url' in window) && ('webkitURL' in window)) {
    	        window.URL = window.webkitURL;
    	    }

    	    $('.searching-bg').css({
    	        "display": "none"
    	    }); //투명 배경 off
    	    $('.load').css({
    	        "display": "none"
    	    });
    	});

    	function searchEmotion(emotion) {
    	    for (var key in emotionType) {
    	        console.log(key);
    	        if (emotion == key) {
    	            console.log(emotionType[key])
    	            return emotionType[key];
    	        }
    	    }
    	}

    	function addResult(jsonObject) {
    	    var gender = jsonObject.gender.value;
    	    var age = jsonObject.age.value;
    	    var emotion = jsonObject.emotion.value;

    	    if (gender == 'male') {
    	        $('#sex').html('<i class="fa fa-male"></i>');
    	        $('.sex').css({
    	            'background-color': '#00bcd4'
    	        })
    	    } else {
    	        $('#sex').html('<i class="fa fa-female"></i>');
    	        $('.sex').css({
    	            'background-color': "#e91e63"
    	        })
    	    }

    	    $('#sex-confidence').html(Math.round(jsonObject.gender.confidence * 100) + '%');
    	    $('#age').html(age + '세');
    	    $('#age-confidence').html(Math.round(jsonObject.age.confidence * 100) + '%');
    	    $('#emotion').html(searchEmotion(emotion));
    	    $('#emotion-confidence').html(Math.round(jsonObject.emotion.confidence * 100) + '%');
    	}
    </script>
</body>
</html>