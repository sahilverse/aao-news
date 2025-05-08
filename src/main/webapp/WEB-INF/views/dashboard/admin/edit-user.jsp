<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
        }
        .avatar-icon{
            height: 120px;
            width: 120px;
            border-radius: 50%;
            border: 2px solid black;
            background-color: cornflowerblue;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-container {
            max-width: 500px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        form label {
            margin-top: 15px;
            display: block;
            font-weight: bold;
        }

        form input[type="text"],
        form input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            margin-top: 25px;
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/common.jsp"/>

<div class="form-container">
    <h2>Edit User</h2>
    <form action="${pageContext.request.contextPath}/edit-user" method="post" enctype="multipart/form-data">
        <label for="id">User ID</label>
        <input type="text" id="id" name="id" value="${user.id}" readonly />

        <label for="email">Email</label>
        <input type="email" id="email" name="email" value="${user.email}" required />

        <label for="full-name">Full Name</label>
        <input type="text" id="full-name" name="fullName" value="${user.fullName}" required />

        <label for="new-password">New Password</label>
        <input type="password" id="new-password" name="password"/>

        <<label for="role">Role:</label>
        <select id="role" name="role" required>
            <option value="1" ${user.role == 'READER' ? 'selected' : ''}>READER</option>
            <option value="2" ${user.role == 'PUBLISHER' ? 'selected' : ''}>PUBLISHER</option>
            <option value="3" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
        </select>
        <label for="profileImage">Profile picture</label>
        <div>
            <c:choose>
                <c:when test="${not empty user.profileImage}">
                    <img src="${pageContext.request.contextPath}/uploads/${user.profileImage}" alt="profile-pricutre" width="120" height="120" style="border-radius: 50%"/>

                </c:when>
                <c:otherwise>
                    <div class="avatar-icon">
                        ${user.fullName.charAt(0)}
                    </div>
                </c:otherwise>
            </c:choose>


        </div>
        <label for="profileImage">Profile Picture</label>
        <input type="file" name="image" id="profileImage" accept="image/*" />

        <button type="submit">Update User</button>
    </form>
</div>

</body>
</html>
