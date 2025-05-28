<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="publisher-approval-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <h1 class="page-title">
                <i class="fas fa-user-check"></i> Publisher Approval
            </h1>
            <p class="page-description">
                Review and approve pending publisher applications
            </p>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/user-management" class="action-button">
                <i class="fas fa-users"></i> Manage Users
            </a>
            <button class="action-button refresh-btn" onclick="window.location.reload();">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
        </div>
    </div>

    <!-- Approval Statistics -->
    <div class="approval-stats">
        <div class="stat-card pending-card">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Pending Applications</h3>
                <p class="stat-value">${pendingPublishers.size()}</p>
                <p class="stat-description">Awaiting review</p>
            </div>
        </div>

        <div class="stat-card approved-card">
            <div class="stat-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Approved Today</h3>
                <p class="stat-value" id="approvedToday">0</p>
                <p class="stat-description">Publishers approved</p>
            </div>
        </div>

        <div class="stat-card rejected-card">
            <div class="stat-icon">
                <i class="fas fa-times-circle"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Rejected Today</h3>
                <p class="stat-value" id="rejectedToday">0</p>
                <p class="stat-description">Applications rejected</p>
            </div>
        </div>

        <div class="stat-card processing-card">
            <div class="stat-icon">
                <i class="fas fa-hourglass-half"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Avg. Processing Time</h3>
                <p class="stat-value">2.5 days</p>
                <p class="stat-description">Average review time</p>
            </div>
        </div>
    </div>

    <!-- Publisher Approval Content -->
    <div class="approval-content">
        <!-- Filter and Search -->
        <div class="approval-tools">
            <div class="search-container">
                <input type="text" id="publisherSearchInput" placeholder="Search by name, email, or organization..." class="search-input">
                <button class="search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </div>

            <div class="filter-container">
                <select id="sortFilter" class="filter-select">
                    <option value="date_desc">Newest First</option>
                    <option value="date_asc">Oldest First</option>
                    <option value="name_asc">Name (A-Z)</option>
                    <option value="name_desc">Name (Z-A)</option>
                </select>

                <button class="filter-btn" id="bulkActionsBtn">
                    <i class="fas fa-tasks"></i> Bulk Actions
                </button>
            </div>
        </div>

        <!-- Pending Publishers -->
        <div class="publishers-container">
            <c:choose>
                <c:when test="${not empty pendingPublishers}">
                    <div class="bulk-actions-bar" id="bulkActionsBar" style="display: none;">
                        <div class="bulk-info">
                            <span id="selectedCount">0</span> publisher(s) selected
                        </div>
                        <div class="bulk-buttons">
                            <button class="bulk-btn approve-bulk" onclick="bulkApprove()">
                                <i class="fas fa-check"></i> Approve Selected
                            </button>
                            <button class="bulk-btn reject-bulk" onclick="bulkReject()">
                                <i class="fas fa-times"></i> Reject Selected
                            </button>
                            <button class="bulk-btn cancel-bulk" onclick="cancelBulkSelection()">
                                Cancel
                            </button>
                        </div>
                    </div>

                    <div class="publishers-grid" id="publishersGrid">
                        <c:forEach var="publisher" items="${pendingPublishers}">
                            <div class="publisher-card" data-id="${publisher.publisherId}">
                                <div class="card-header">
                                    <div class="selection-checkbox">
                                        <input type="checkbox" class="publisher-checkbox" value="${publisher.publisherId}">
                                    </div>

                                </div>

                                <div class="card-body">
                                    <div class="publisher-info">
                                        <h3 class="publisher-name">${publisher.publisherName}</h3>
                                        <p class="publisher-email">${publisher.publisherEmail}</p>


                                    </div>

                                    <div class="application-details">
                                        <div class="detail-item">
                                            <i class="fas fa-user"></i>
                                            <span>User ID: ${publisher.publisherId}</span>
                                        </div>
                                        <div class="detail-item">
                                            <i class="fas fa-envelope"></i>
                                            <span>Email Verified:
                                                <c:choose>
                                                    <c:when test="${publisher.isVerified}">
                                                        <span class="verified">Yes</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="not-verified">No</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                    </div>
                                </div>

                                <div class="card-footer">
                                    <div class="action-buttons">
                                        <button class="action-btn approve-btn" onclick="approvePublisher(${publisher.publisherId}, '${publisher.publisherName}')" title="Approve Publisher">
                                            <i class="fas fa-check"></i>
                                            Approve
                                        </button>
                                        <button class="action-btn reject-btn" onclick="rejectPublisher(${publisher.publisherId}, '${publisher.publisherName}')" title="Reject Application">
                                            <i class="fas fa-times"></i>
                                            Reject
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Load More Button -->
                    <div class="load-more-section">
                        <button class="load-more-btn" id="loadMoreBtn" style="display: none;">
                            <i class="fas fa-plus"></i>
                            Load More Applications
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-pending-message">
                        <i class="fas fa-check-circle"></i>
                        <h3>All Caught Up!</h3>
                        <p>There are no pending publisher applications at the moment.</p>
                        <p>New applications will appear here when submitted.</p>
                        <a href="${pageContext.request.contextPath}/admin/user-management" class="action-button">
                            <i class="fas fa-users"></i> Manage Existing Publishers
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Publisher Details Modal -->
<div class="modal" id="publisherDetailsModal">
    <div class="modal-content large-modal">
        <div class="modal-header">
            <h3>Publisher Application Details</h3>
            <button class="close-btn" onclick="closeDetailsModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body" id="publisherDetailsContent">
            <!-- Content will be loaded dynamically -->
        </div>
        <div class="modal-footer">
            <button class="cancel-btn" onclick="closeDetailsModal()">Close</button>
            <button class="approve-btn" id="modalApproveBtn">
                <i class="fas fa-check"></i> Approve
            </button>
            <button class="reject-btn" id="modalRejectBtn">
                <i class="fas fa-times"></i> Reject
            </button>
        </div>
    </div>
</div>

<!-- Approval Confirmation Modal -->
<div class="modal" id="approvalModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Approve Publisher</h3>
            <button class="close-btn" onclick="closeApprovalModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <div class="confirmation-content">
                <div class="confirmation-icon approve-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <p>Are you sure you want to approve <span id="approvePublisherName"></span> as a publisher?</p>
                <p class="confirmation-note">
                    This will grant them permission to create and publish articles on the platform.
                </p>
            </div>
        </div>
        <div class="modal-footer">
            <button class="cancel-btn" onclick="closeApprovalModal()">Cancel</button>
            <form id="approveForm" method="post" action="${pageContext.request.contextPath}/admin/publisher-approval?action=approve">
                <input type="hidden" id="approvePublisherId" name="publisherId" value="${publisher.publisherId}">
                <input type="hidden" name="action" value="approve">
                <button type="submit" class="confirm-btn approve-confirm">
                    <i class="fas fa-check"></i> Approve Publisher
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Rejection Confirmation Modal -->
<div class="modal" id="rejectionModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Reject Application</h3>
            <button class="close-btn" onclick="closeRejectionModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <div class="confirmation-content">
                <div class="confirmation-icon reject-icon">
                    <i class="fas fa-times-circle"></i>
                </div>
                <p>Are you sure you want to reject <span id="rejectPublisherName"></span>'s application?</p>

            </div>
        </div>
        <div class="modal-footer">
            <button class="cancel-btn" onclick="closeRejectionModal()">Cancel</button>
            <form id="rejectForm" method="post" action="${pageContext.request.contextPath}/admin/publisher-approval?action=reject">
                <input type="hidden" id="rejectPublisherId" name="publisherId" value="${publisher.publisherId}">
                <button type="submit" class="confirm-btn reject-confirm">
                    <i class="fas fa-times"></i> Reject Application
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        initializeSearch();
        initializeSorting();
        initializeBulkActions();
        updateStats();
    });

    // Search functionality
    function initializeSearch() {
        const searchInput = document.getElementById('publisherSearchInput');
        searchInput.addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const publisherCards = document.querySelectorAll('.publisher-card');

            let visibleCount = 0;

            publisherCards.forEach(card => {
                const name = card.querySelector('.publisher-name').textContent.toLowerCase();
                const email = card.querySelector('.publisher-email').textContent.toLowerCase();
                const organization = card.querySelector('.publisher-organization p');
                const orgText = organization ? organization.textContent.toLowerCase() : '';

                if (name.includes(searchTerm) || email.includes(searchTerm) || orgText.includes(searchTerm)) {
                    card.style.display = '';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }

    // Sorting functionality
    function initializeSorting() {
        const sortFilter = document.getElementById('sortFilter');
        sortFilter.addEventListener('change', function() {
            const sortValue = this.value;
            const container = document.getElementById('publishersGrid');
            const cards = Array.from(container.querySelectorAll('.publisher-card'));

            cards.sort((a, b) => {
                switch(sortValue) {
                    case 'name_asc':
                        return a.querySelector('.publisher-name').textContent.localeCompare(
                            b.querySelector('.publisher-name').textContent
                        );
                    case 'name_desc':
                        return b.querySelector('.publisher-name').textContent.localeCompare(
                            a.querySelector('.publisher-name').textContent
                        );
                    case 'date_asc':
                        return new Date(a.querySelector('.application-date').textContent.trim()) -
                            new Date(b.querySelector('.application-date').textContent.trim());
                    case 'date_desc':
                        return new Date(b.querySelector('.application-date').textContent.trim()) -
                            new Date(a.querySelector('.application-date').textContent.trim());
                    default:
                        return 0;
                }
            });

            // Clear container and append sorted cards
            while (container.firstChild) {
                container.removeChild(container.firstChild);
            }

            cards.forEach(card => container.appendChild(card));
        });
    }

    // Bulk actions functionality
    function initializeBulkActions() {
        const bulkActionsBtn = document.getElementById('bulkActionsBtn');
        const checkboxes = document.querySelectorAll('.publisher-checkbox');

        bulkActionsBtn.addEventListener('click', function() {
            const bulkBar = document.getElementById('bulkActionsBar');
            const isVisible = bulkBar.style.display !== 'none';

            if (isVisible) {
                cancelBulkSelection();
            } else {
                bulkBar.style.display = 'flex';
                this.textContent = 'Cancel Bulk';
                this.innerHTML = '<i class="fas fa-times"></i> Cancel Bulk';
            }
        });

        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', updateBulkSelection);
        });
    }

    function updateBulkSelection() {
        const selectedCheckboxes = document.querySelectorAll('.publisher-checkbox:checked');
        const selectedCount = selectedCheckboxes.length;

        document.getElementById('selectedCount').textContent = selectedCount;

        const bulkButtons = document.querySelectorAll('.bulk-btn:not(.cancel-bulk)');
        bulkButtons.forEach(btn => {
            btn.disabled = selectedCount === 0;
        });
    }

    function cancelBulkSelection() {
        const bulkBar = document.getElementById('bulkActionsBar');
        const bulkActionsBtn = document.getElementById('bulkActionsBtn');
        const checkboxes = document.querySelectorAll('.publisher-checkbox');

        bulkBar.style.display = 'none';
        bulkActionsBtn.innerHTML = '<i class="fas fa-tasks"></i> Bulk Actions';

        checkboxes.forEach(checkbox => {
            checkbox.checked = false;
        });

        updateBulkSelection();
    }

    function bulkApprove() {
        const selectedIds = Array.from(document.querySelectorAll('.publisher-checkbox:checked'))
            .map(cb => cb.value);

        if (selectedIds.length === 0) return;

        if (confirm(`Are you sure you want to approve ${selectedIds.length} publisher(s)?`)) {
            // In a real implementation, you would send this to the server
            alert(`Bulk approval of ${selectedIds.length} publishers would be processed here.`);
            cancelBulkSelection();
        }
    }

    function bulkReject() {
        const selectedIds = Array.from(document.querySelectorAll('.publisher-checkbox:checked'))
            .map(cb => cb.value);

        if (selectedIds.length === 0) return;

        if (confirm(`Are you sure you want to reject ${selectedIds.length} application(s)?`)) {
            // In a real implementation, you would send this to the server
            alert(`Bulk rejection of ${selectedIds.length} applications would be processed here.`);
            cancelBulkSelection();
        }
    }

    // Publisher actions
    function viewPublisherDetails(publisherId) {
        // In a real implementation, you would fetch detailed data from the server
        const modal = document.getElementById('publisherDetailsModal');
        const content = document.getElementById('publisherDetailsContent');

        content.innerHTML = `
            <div class="loading-spinner">
                <i class="fas fa-spinner fa-spin"></i>
                Loading publisher details...
            </div>
        `;

        modal.style.display = 'flex';

        // Simulate loading
        setTimeout(() => {
            content.innerHTML = `
                <div class="detailed-publisher-info">
                    <h4>Detailed Publisher Information</h4>
                    <p>This would contain comprehensive publisher details, portfolio, writing samples, etc.</p>
                    <p>Publisher ID: ${publisherId}</p>
                </div>
            `;
        }, 1000);
    }

    function approvePublisher(publisherId, publisherName) {
        document.getElementById('approvePublisherId').value = publisherId;
        document.getElementById('approvePublisherName').textContent = publisherName;
        document.getElementById('approvalModal').style.display = 'flex';
    }

    function rejectPublisher(publisherId, publisherName) {
        document.getElementById('rejectPublisherId').value = publisherId;
        document.getElementById('rejectPublisherName').textContent = publisherName;
        document.getElementById('rejectionModal').style.display = 'flex';
    }

    // Modal functions
    function closeDetailsModal() {
        document.getElementById('publisherDetailsModal').style.display = 'none';
    }

    function closeApprovalModal() {
        document.getElementById('approvalModal').style.display = 'none';
    }

    function closeRejectionModal() {
        document.getElementById('rejectionModal').style.display = 'none';
    }

    // Handle rejection form submission
    document.getElementById('rejectForm').addEventListener('submit', function(e) {
        const reason = document.getElementById('rejectionReason').value;
        document.getElementById('rejectReasonInput').value = reason;
    });

    // Update statistics
    function updateStats() {
        document.getElementById('approvedToday').textContent = Math.floor(Math.random() * 10);
        document.getElementById('rejectedToday').textContent = Math.floor(Math.random() * 5);
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
</script>