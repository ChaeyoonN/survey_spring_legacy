<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>설문조사 결과 메일</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            padding: 20px;
        }
        .container {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 0 auto;
        }
        h2 {
            color: #333;
        }
        p {
            color: #666;
            margin-bottom: 20px;
        }
        button {
            background-color: #FC5230;
            color: white;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin-top: 20px;
            border-radius: 4px;
            cursor: pointer;
            border: none;
        }
        button:hover {
            background-color: #fc3210;
        }
    </style>
</head>
<body>
<div class="container">
    <img src='cid:logoImage' alt="로고 이미지">
    <h2>안녕하세요, <span><c:out value="${id}"/></span>님</h2>
    <p><span>[<c:out value="${title}" escapeXml="true"/>]</span> 설문조사가 완료되었습니다.</p>
    <p>참여해 주셔서 감사합니다.</p>
    <a href="${resultPopupLink}">
        <button type="button">결과 보러가기</button>
    </a>
</div>
</body>
</html>
