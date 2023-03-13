<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>
     
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload </title>
</head>
<body>
	<h2>Upload </h2>
	<form action = "${pageContext.request.contextPath}/upload " method= "post" enctype = "multipart/form-data">
	<p> ${error}</p>
		<p> 
			<label>Hình Ảnh : </label>
			<input type = "file" name = "hinhanh">
		</p>
		<input type= "submit" value = "úphình">
		
	</form>
	
	
	<c:if test="${not empty fileName }">
	<c:url value="/resources/files" var = "img"></c:url>
		<img src ="${img}/${fileName}">
	</c:if>
</body>
</html>