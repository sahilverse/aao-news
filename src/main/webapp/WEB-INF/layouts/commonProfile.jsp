<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<div class="container profile-container" style="margin-top: 10px;">
    <!-- Load errors from request  -->
    <c:set var="errors" value="${requestScope.errors}"/>
    <div class="profile-page">
        <!-- Profile Header with Picture -->
        <div class="profile-header">
            <div class="container">
                <div class="header-content">
                    <div class="profile-picture-container">
                        <div class="profile-picture">
                            <img src="${pageContext.request.contextPath}/user-image?id=${sessionScope.currentUser.id}"
                                 alt="Profile Picture" id="profile-image">
                        </div>
                        <!-- Camera button on profile picture -->
                        <button class="camera-btn" id="camera-btn" aria-label="Change profile picture">
                            <i class="fas fa-camera"></i>
                        </button>


                    </div>
                    <div class="user-info">
                        <h1>${sessionScope.currentUser.fullName}
                            <c:if test="${sessionScope.currentUser.role == 'PUBLISHER'}">
                                <span>
                                    <c:if test="${sessionScope.currentPublisher.isVerified}">
                                        <i class="fas fa-check-circle verified-icon" title="Verified"></i>
                                    </c:if>
                                    <c:if test="${!sessionScope.currentPublisher.isVerified}">
                                        <i class="fas fa-exclamation-circle pending-icon" title="Not-Verified"></i>
                                    </c:if>
                                </span>

                            </c:if>

                        </h1>
                        <p>Member since
                            <fmt:formatDate value="${sessionScope.currentUser.createdAt}" pattern="dd MMM yyyy"/>
                        </p>

                    </div>

                </div>
            </div>
        </div>

        <!-- Personal Information -->
        <div class="profile-section">
            <div class="info-container">
                <h2>Personal Information</h2>
                <form id="personal-info-form" name="personal-info-form"
                      action="${pageContext.request.contextPath}/update-profile" method="post">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="${sessionScope.currentUser.fullName}"
                        >
                        <c:if test="${not empty errors.fullName}">
                            <p class="error">${errors.fullName}</p>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${sessionScope.currentUser.email}" readonly>
                    </div>
                    <div class="form-group">
                        <label for="lastLogin">Last Login</label>
                        <fmt:formatDate var="formattedLastLogin"
                                        value="${sessionScope.currentUser.lastLogin}"
                                        pattern="dd MMM yyyy, hh:mm a"/>

                        <input type="text" id="lastLogin" name="lastLogin"
                               value="${formattedLastLogin}" readonly>
                    </div>
                    <c:if test="${sessionScope.currentUser.role == 'PUBLISHER'}">


                        <div class="form-group">
                            <label for="verificationDate">Verification Date</label>
                            <fmt:formatDate var="formattedDate"
                                            value="${sessionScope.currentPublisher.verificationDate}"
                                            pattern="dd MMM yyyy"/>
                            <input type="text" id="verificationDate" name="verificationDate"
                                   value="${empty sessionScope.currentPublisher.verificationDate ? 'Not Verified' : formattedDate}"
                                   readonly>

                        </div>
                    </c:if>
                    <button type="submit" class="submit-btn" id="save-changes-btn" disabled>Save Changes</button>
                </form>
            </div>

            <!-- Security -->
            <div class="info-container">
                <h2>Security</h2>
                <form id="password-change-form" name="password-change-form"
                      action="${pageContext.request.contextPath}/update-password"
                      method="post">
                    <div class="form-group">
                        <label for="oldPassword">Old Password</label>
                        <div class="password-input-container">
                            <input type="password" id="oldPassword" name="oldPassword" placeholder="Enter Old Password"
                            >
                            <button type="button" class="password-toggle">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </div>
                        <c:if test="${not empty errors.oldPassword}">
                            <p class="error">${errors.oldPassword}</p>
                        </c:if>

                    </div>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>

                        <div class="password-input-container">
                            <input type="password" id="newPassword" name="newPassword" placeholder="Enter New Password"
                            >
                            <button type="button" class="password-toggle">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </div>
                        <c:if test="${not empty errors.newPassword}">
                            <p class="error">${errors.newPassword}</p>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <div class="password-input-container">
                            <input type="password" id="confirmPassword" name="confirmPassword"
                                   placeholder="Confirm New Password">
                            <button type="button" class="password-toggle">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </div>
                        <c:if test="${not empty errors.confirmPassword}">
                            <p class="error">${errors.confirmPassword}</p>
                        </c:if>
                    </div>
                    <button type="submit" class="submit-btn">Change Password</button>
                </form>
            </div>

        </div>

    </div>
</div>


<!-- Dialog -->
<div class="dialog" id="upload-dialog">
    <div class="dialog-content">
        <div class="dialog-header">
            <h2>Upload Profile Picture</h2>
        </div>
        <form action="${pageContext.request.contextPath}/upload-image" method="post" enctype="multipart/form-data">
            <label for="profile-upload">Select a JPEG image</label>
            <input type="file" id="profile-upload" name="profileImage" accept=".jpg,.jpeg" class="file-input" required/>
            <div class="flex-end" style="margin-top: 1rem;">
                <button type="button" class="btn btn-outline" id="cancel-upload">Cancel</button>
                <button type="submit" class="btn btn-default">Upload</button>
            </div>
        </form>
    </div>
</div>


<script src="${pageContext.request.contextPath}/assets/js/passwordToggle.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/formValidation.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>

