<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Error ${status}</title>

    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #eef1f5;
            margin: 0;
            padding: 0;
            text-align: center;
        }
    
        .container {
            margin-top: 120px;
            display: inline-block;
            background: #fff;
            padding: 40px 60px;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
        }
    
        h1 {
            font-size: 46px;
            color: #c0392b;
            margin-bottom: 15px;
            font-weight: 700;
        }
    
        .details {
            color: #444;
            font-size: 18px;
            margin-bottom: 35px;
            line-height: 1.6;
        }
    
        .details p {
            margin: 6px 0;
        }
    
        a {
            padding: 12px 30px;
            font-size: 16px;
            color: #fff;
            background-color: #2980b9;
            text-decoration: none;
            border-radius: 6px;
            transition: 0.25s ease;
        }
    
        a:hover {
            background-color: #1f6390;
            transform: translateY(-2px);
        }
    </style>
    
</head>
<body>

<div class="container">
    <h1>Error ${status}</h1>

    <div class="details">
        <p><strong>Error:</strong> ${error}</p>
        <p><strong>Message:</strong> ${message}</p>
        <p><strong>Path:</strong> ${path}</p>
    </div>

    <a href="${pageContext.request.contextPath}/bookstore/home">Go Home</a>
</div>

</body>
</html>
