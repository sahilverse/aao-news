<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="user-management-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <h1 class="page-title">
                <i class="fas fa-users-cog"></i> User Management
            </h1>
            <p class="page-description">
                Manage verified publishers and their permissions
            </p>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/publisher-approval" class="action-button">
                <i class="fas fa-user-check"></i> Pending Approvals
            </a>
            <button class="action-button refresh-btn" onclick="window.location.reload();">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
        </div>
    </div>

    <!-- User Management Content -->
    <div class="user-management-content">
        <!-- User Statistics -->
        <div class="user-stats">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-check"></i>
                </div>
                <div class="stat-details">
                    <h3 class="stat-title">Verified Publishers</h3>
                    <p class="stat-value">${verified.size()}</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-newspaper"></i>
                </div>
                <div class="stat-details">
                    <h3 class="stat-title">Total Articles</h3>
                    <p class="stat-value" id="totalArticles">${totalArticles}</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-details">
                    <h3 class="stat-title">Avg. Articles/Publisher</h3>
                    <p class="stat-value" id="avgArticles">${averageArticlesPerPublisher}</p>
                </div>
            </div>
        </div>

        <!-- User Management Tools -->
        <div class="management-tools">
            <div class="search-filter">
                <div class="search-container">
                    <input type="text" id="userSearchInput" placeholder="Search publishers..." class="search-input">
                    <button class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </div>

                <div class="filter-container">
                    <select id="sortFilter" class="filter-select">
                        <option value="name_asc">Name (A-Z)</option>
                        <option value="name_desc">Name (Z-A)</option>
                        <option value="date_asc">Registration (Oldest)</option>
                        <option value="date_desc">Registration (Newest)</option>
                    </select>

                    <button class="filter-btn" id="exportBtn">
                        <i class="fas fa-download"></i> Export
                    </button>
                </div>
            </div>
        </div>

        <!-- Publishers Table -->
        <div class="table-container">
            <c:choose>
                <c:when test="${not empty verified}">
                    <table class="data-table" id="publishersTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Registration Date</th>
                            <th>Articles</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="publisher" items="${verified}">
                            <tr data-id="${publisher.publisherId}">
                                <td>${publisher.publisherId}</td>
                                <td class="user-info">

                                    <div class="user-details">
                                        <span class="user-name">${publisher.publisherName}</span>
                                        <span class="user-role">Publisher</span>
                                    </div>
                                </td>
                                <td>${publisher.email}</td>
                                <td>
                                    <fmt:formatDate value="${publisher.verificationDate}" pattern="MMM dd, yyyy" />
                                </td>
                                <td class="article-count">
                                    <span class="count-badge" id="articleCount-${publisher.publisherId}">${publisher.articleCount}</span>
                                </td>
                                <td>
                                    <span class="status-badge status-active">Active</span>
                                </td>
                                <td class="actions-cell">
                                    <div class="table-actions">
                                        <button class="action-btn unverify-btn" title="Unverify Publisher" onclick="confirmUnverify(${publisher.publisherId}, '${publisher.publisherName}')">
                                            <i class="fas fa-user-times"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <div class="pagination-container">
                        <div class="pagination-info">
                            Showing <span id="showing-start">1</span> to <span id="showing-end">${verified.size()}</span> of <span id="total-items">${verified.size()}</span> publishers
                        </div>
                        <div class="pagination-controls">
                            <button class="pagination-btn" id="prev-page" disabled>
                                <i class="fas fa-chevron-left"></i> Previous
                            </button>
                            <div class="pagination-pages" id="pagination-pages">
                                <button class="page-btn active">1</button>
                            </div>
                            <button class="pagination-btn" id="next-page" disabled>
                                Next <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-data-message">
                        <i class="fas fa-users-slash"></i>
                        <h3>No Verified Publishers</h3>
                        <p>There are currently no verified publishers in the system.</p>
                        <a href="${pageContext.request.contextPath}/admin/publisher-approval" class="action-button">
                            Check Pending Approvals
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Unverify Confirmation Modal -->
<div class="modal" id="unverifyModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Unverify Publisher</h3>
            <button class="close-btn" onclick="closeModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <p>Are you sure you want to unverify <span id="publisherName"></span>?</p>
            <p class="warning-text">
                <i class="fas fa-exclamation-triangle"></i>
                This action will revoke their publishing privileges.
            </p>
        </div>
        <div class="modal-footer">
            <button class="cancel-btn" onclick="closeModal()">Cancel</button>
            <form id="unverifyForm" method="post" action="${pageContext.request.contextPath}/admin/user-management">
                <input type="hidden" id="publisherId" name="id" value="">
                <button type="submit" class="confirm-btn">Unverify Publisher</button>
            </form>
        </div>
    </div>
</div>


</div>

<script>
    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        initializeSearch();
        initializeSorting();
        initializePagination();
        fetchPublisherStats();
    });

    // Search functionality
    function initializeSearch() {
        const searchInput = document.getElementById('userSearchInput');
        searchInput.addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const tableRows = document.querySelectorAll('#publishersTable tbody tr');

            let visibleCount = 0;

            tableRows.forEach(row => {
                const name = row.querySelector('.user-name').textContent.toLowerCase();
                const email = row.cells[2].textContent.toLowerCase();

                if (name.includes(searchTerm) || email.includes(searchTerm)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            updatePaginationInfo(visibleCount);
        });
    }

    // Sorting functionality
    function initializeSorting() {
        const sortFilter = document.getElementById('sortFilter');
        sortFilter.addEventListener('change', function() {
            const sortValue = this.value;
            const tableBody = document.querySelector('#publishersTable tbody');
            const rows = Array.from(tableBody.querySelectorAll('tr'));

            rows.sort((a, b) => {
                switch(sortValue) {
                    case 'name_asc':
                        return a.querySelector('.user-name').textContent.localeCompare(
                            b.querySelector('.user-name').textContent
                        );
                    case 'name_desc':
                        return b.querySelector('.user-name').textContent.localeCompare(
                            a.querySelector('.user-name').textContent
                        );
                    case 'date_asc':
                        return new Date(a.cells[3].textContent) - new Date(b.cells[3].textContent);
                    case 'date_desc':
                        return new Date(b.cells[3].textContent) - new Date(a.cells[3].textContent);
                    default:
                        return 0;
                }
            });

            // Clear table and append sorted rows
            while (tableBody.firstChild) {
                tableBody.removeChild(tableBody.firstChild);
            }

            rows.forEach(row => tableBody.appendChild(row));
        });

        // Export functionality
        document.getElementById('exportBtn').addEventListener('click', function() {
            exportTableToCSV('publishers_list.csv');
        });
    }

    // Pagination functionality
    function initializePagination() {

        document.getElementById('prev-page').addEventListener('click', function() {
            alert('Previous page functionality would be implemented here');
        });

        document.getElementById('next-page').addEventListener('click', function() {
            alert('Next page functionality would be implemented here');
        });
    }

    // Update pagination info based on visible rows
    function updatePaginationInfo(visibleCount) {
        document.getElementById('showing-end').textContent = visibleCount;
        document.getElementById('total-items').textContent = visibleCount;
    }


    // Unverify publisher confirmation
    function confirmUnverify(id, username) {
        document.getElementById('publisherId').value = id;
        document.getElementById('publisherName').textContent = username;
        document.getElementById('unverifyModal').style.display = 'flex';
    }

    // Close unverify modal
    function closeModal() {
        document.getElementById('unverifyModal').style.display = 'none';
    }


    // Export table to CSV
    function exportTableToCSV(filename) {
        const table = document.getElementById('publishersTable');
        let csv = [];
        const rows = table.querySelectorAll('tr');

        for (let i = 0; i < rows.length; i++) {
            const row = [], cols = rows[i].querySelectorAll('td, th');

            for (let j = 0; j < cols.length; j++) {
                // Skip the actions column
                if (j === cols.length - 1 && i > 0) continue;

                // Get text content and clean it
                let data = cols[j].textContent.replace(/(\r\n|\n|\r)/gm, '').trim();

                // Special handling for user info column
                if (j === 1 && i > 0) {
                    data = rows[i].querySelector('.user-name').textContent;
                }

                // Escape double quotes
                data = data.replace(/"/g, '""');
                // Add quotes around data
                row.push('"' + data + '"');
            }

            csv.push(row.join(','));
        }

        // Download CSV file
        downloadCSV(csv.join('\n'), filename);
    }

    function downloadCSV(csv, filename) {
        const csvFile = new Blob([csv], {type: 'text/csv'});
        const downloadLink = document.createElement('a');

        downloadLink.download = filename;
        downloadLink.href = window.URL.createObjectURL(csvFile);
        downloadLink.style.display = 'none';

        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        const unverifyModal = document.getElementById('unverifyModal');
        const editModal = document.getElementById('editModal');

        if (event.target === unverifyModal) {
            unverifyModal.style.display = 'none';
        }

        if (event.target === editModal) {
            editModal.style.display = 'none';
        }
    }
</script>