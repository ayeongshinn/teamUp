<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>프로필 및 직인 이미지 확인</title>
</head>
<body>

<p>${employeeVO}</p>

<h2>프로필 사진</h2>
<c:choose>
    <c:when test="${not empty employeeVO.proflPhoto}">
        <!-- BASE64로 인코딩된 프로필 사진을 이미지로 출력 -->
        <img src="data:image/png;base64,${employeeVO.proflPhoto}" alt="프로필 사진" width="200" height="200"/>
    </c:when>
    <c:otherwise>
        <p>프로필 사진이 없습니다.</p>
    </c:otherwise>
</c:choose>

<h2>직인 이미지</h2>
<c:choose>
    <c:when test="${not empty employeeVO.offcsPhoto}">
        <!-- BASE64로 인코딩된 직인 이미지를 이미지로 출력 -->
        <img src="data:image/png;base64,${employeeVO.offcsPhoto}" alt="직인 이미지" width="200" height="200"/>
    </c:when>
    <c:otherwise>
        <p>직인 이미지가 없습니다.</p>
    </c:otherwise>
</c:choose>

</body>
</html>  
