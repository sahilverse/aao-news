<%@ page import="com.aaonews.models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.aaonews.models.Publisher" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Admin Dashboard</title>
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

        .table-container,.para {
            width: 40%;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
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




        .action-buttons a{
            color:black;

        }
    </style>
</head>
<body>


<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/common.jsp"/>


<c:choose>
    <c:when test="${empty pendingPublishers}">
        <p class="para">No pending publishers found.</p>
    </c:when>
    <c:otherwise>
        <table class="table-container">
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Status</th>
                <th>Action</th>

            </tr>
            </thead>
            <tbody>
            <c:forEach var="publisher" items="${pendingPublishers}">

                <tr>
                    <td>${publisher.getPublisherId()}</td>
                    <td>${publisher.getFullName()}</td>
                    <td>${publisher.getEmail()}</td>
                    <td>
                        <c:choose>
                            <c:when test="${publisher.getIsVerified()}">
                                Verified
                            </c:when>
                            <c:otherwise>
                                Pending
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="action-buttons">
                        <!-- Approve Form -->
                        <form action="${pageContext.request.contextPath}/admin/pending-publishers" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="${publisher.publisherId}" />
                            <input type="hidden" name="action" value="approve" />
                            <button type="submit">Approve</button>
                        </form>

                        <form action="${pageContext.request.contextPath}/admin/pending-publishers" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="${publisher.publisherId}" />
                            <input type="hidden" name="action" value="reject" />
                            <button type="submit">Reject</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

    </c:otherwise>
</c:choose>

</body>
</html>