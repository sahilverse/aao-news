<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Admin Dashboard</title>
  <jsp:include page="../common/common.jsp"/>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@3.2.0/dist/fullcalendar.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/fullcalendar@3.2.0/dist/fullcalendar.min.css" rel="stylesheet" />
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 20px;
    }

    .dashboard-container {
      display: flex;
      flex-direction: column;
      gap: 80px;
      margin: 0 auto;
      max-width: 900px;
    }

    .cards {
      display: flex;
      gap: 20px;
      justify-content: space-between;
    }

    .card {
      flex: 1;
      background: white;
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      text-align: center;
    }
    .search-heading {
      font-size: 1.8rem;
      color: #2c3e50;
      margin-bottom: 20px;
    }

    .search-form {
      display: flex;
      gap: 10px;
      max-width: 600px;
      margin-bottom: 40px;
    }

    .search-input {
      width: 100%;
      padding: 10px;
      font-size: 1rem;
      border: 1px solid #ccc;
      border-radius: 8px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    .search-button {
      padding: 10px 20px;
      font-size: 1rem;
      background-color: #3498db;
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    .search-button:hover {
      background-color: #2980b9;
    }

    .search-results {
      margin-top: 20px;
    }

    .results-heading {
      font-size: 1.6rem;
      margin-bottom: 15px;
      color: #2c3e50;
    }

    .results-list {
      list-style-type: none;
      padding: 0;
    }

    .result-item {
      background-color: #fff;
      padding: 12px;
      margin-bottom: 10px;
      border-radius: 8px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      font-size: 1.1rem;
      color: #34495e;
    }

    .result-item:hover {
      background-color: #f1f1f1;
    }

    .no-results-text {
      font-size: 1rem;
      color: #7f8c8d;
    }

    .card h2 {
      font-size: 2rem;
      margin: 0;
    }

    .card p {
      color: gray;
    }

    canvas {
      background: white;
      border-radius: 12px;
      padding: 20px;
    }
  </style>
</head>
<body>
<jsp:include page="../common/sidebar.jsp"/>

<div class="dashboard-container">
  <!-- Display Total Users, Publishers, and Articles -->
  <div class="cards">
    <div class="card">
      <h2>${no_of_users}</h2>
      <p>Total Users</p>
    </div>
    <div class="card">
      <h2>${no_of_publishers}</h2>
      <p>Total Publishers</p>
    </div>
    <div class="card">
      <h2>${no_of_articles}</h2>
      <p>Total Articles</p>
    </div>
  </div>

  <!-- Chart Section -->
  <canvas id="overviewChart" width="400" height="150"></canvas>

  <!-- Search Section -->
  <h3 class="search-heading">Search Articles</h3>
  <form action="${pageContext.request.contextPath}/dashboard" method="get">
    <input type="text" name="searchQuery" placeholder="Search articles..." value="${searchQuery}" />
    <button type="submit">Search</button>
  </form>

  <div class="search-results">
    <h4 class="results-heading">Search Results</h4>
    <ul class="results-list">
      <c:if test="${empty searchResults}">
        <p class="no-result-text">No articles found matching your query.</p>
      </c:if>
      <c:forEach var="article" items="${searchResults}">

        <li class="result-item">${article.title}</li>
      </c:forEach>
    </ul>
  </div>

</div>

<script>
  // Chart for System Overview
  const ctx = document.getElementById('overviewChart').getContext('2d');
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['Users', 'Publishers', 'Articles'],
      datasets: [{
        label: 'System Overview',
        data: [${no_of_users}, ${no_of_publishers}, ${no_of_articles}],
        backgroundColor: ['#3498db', '#e67e22', '#2ecc71'],
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      scales: {
        y: { beginAtZero: true }
      }
    }
  });

</script>

</body>
</html>
