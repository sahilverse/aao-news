<%@ page import="com.aaonews.models.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Admin Dashboard</title>
    <jsp:include page="../common/common.jsp"/>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f3f4f6;
            margin: 0;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .table-container {
            width: 40%;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background-color: #4f46e5;
            color: white;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        tbody tr:hover {
            background-color: #f1f1f1;
        }

        .crud-buttons button {
            margin-right: 5px;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .view-btn {
            background-color: #3b82f6;
            color: white;
        }

        .edit-btn {
            background-color: #f59e0b;
            color: white;
        }

        .delete-btn {
            background-color: #ef4444;
            color: white;
        }

        .add-user-btn {
            display: block;
            margin: 10px auto 20px auto;
            padding: 10px 20px;
            background-color: #10b981;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
        }

        .add-user-btn:hover {
            background-color: #059669;
        }
    </style>
</head>
<body>
<jsp:include page="../common/sidebar.jsp"/>


<div class="table-container">
    <table>
        <thead>
        <tr>
            <th>Id</th>
            <th>Name</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${users}">
            <tr>
                <td>${user.id}</td>
                <td>${user.fullName}</td>
                <td>${user.role}</td>
                <td class="crud-buttons">
                    <form action="view-user" method="get" style="display:inline;">
                        <input type="hidden" name="id" value="${user.id}">
                        <button type="submit" class="view-btn">Block</button>
                    </form>
                    <form action="edit-user.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="id" value="${user.id}">
                        <button type="submit" class="edit-btn">Edit</button>
                    </form>
                    <form action="delete-user" method="post" style="display:inline;"
                          onsubmit="return confirm('Are you sure?');">
                        <input type="hidden" name="id" value="${user.id}">
                        <button type="submit" class="delete-btn">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
