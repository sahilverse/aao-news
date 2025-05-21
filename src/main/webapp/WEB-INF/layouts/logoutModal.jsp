<div id="logoutModal" class="modal-overlay">
    <div class="modal-box">
        <h2>Are you sure?</h2>
        <p>You will be logged out of your account.</p>
        <div class="modal-actions">
            <form id="logoutForm" method="post" action="${pageContext.request.contextPath}/logout">
                <button type="submit" class="btn btn-danger">Yes, Logout</button>
            </form>
            <button class="btn cancel-btn"  onclick="hideLogoutModal()">Cancel</button>
        </div>
    </div>
</div>