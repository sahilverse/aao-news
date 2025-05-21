<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="create-article-container">
    <div class="page-header">
        <h1>Create New Article</h1>
        <div class="auto-save-status">
            <span id="autoSaveStatus">All changes saved</span>
        </div>
    </div>

    <!-- Display error message if any -->
    <c:if test="${not empty error}">
        <div class="alert">
                ${error}
        </div>
    </c:if>

    <!-- Display : Unverfied Publishers Cannot Create Articles -->


    <c:if test="${!sessionScope.currentPublisher.isVerified}">
        <div class="alert">
            <strong>Warning!</strong> Your account is not verified. You cannot create articles until your account is
            verified.
        </div>
    </c:if>


    <form id="articleForm" action="${pageContext.request.contextPath}/publisher/create" method="post"
          enctype="multipart/form-data">
        <div class="form-grid">
            <!-- Left Column -->
            <div class="main-content" style="margin-left: 0; margin-top: 0; ">
                <!-- Article Title -->
                <div class="form-group">
                    <label for="articleTitle">Article Title <span class="required">*</span></label>
                    <input type="text" id="articleTitle" name="title" required
                           placeholder="Enter a descriptive title" maxlength="150"
                           value="${article.title}">
                    <div class="char-counter">
                        <span id="titleCharCount">0</span>/150 characters
                    </div>
                </div>

                <!-- Article Content Editor -->
                <div class="form-group">
                    <label for="articleContent">Article Content <span class="required">*</span></label>
                    <textarea id="articleContent" name="content">${article.content}</textarea>
                </div>

                <!-- Article Summary -->
                <div class="form-group">
                    <label for="articleSummary">Article Summary <span class="required">*</span></label>
                    <textarea id="articleSummary" name="summary" rows="4"
                              placeholder="Write a brief summary of your article"
                              maxlength="500">${article.summary}</textarea>
                    <div class="char-counter">
                        <span id="summaryCharCount">0</span>/500 characters
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="sidebar-content">
                <!-- Publishing Options -->
                <div class="sidebar-card">
                    <h3>Publishing</h3>
                    <div class="form-group">
                        <label for="articleStatus">Status</label>
                        <select id="articleStatus" name="status">
                            <option value="draft">Save as Draft</option>
                            <option value="publish">Submit for Review</option>
                        </select>
                    </div>
                    <div class="action-buttons">
                        <button type="button" id="previewButton" class="btn btn-secondary">
                            <i class="fas fa-eye"></i> Preview
                        </button>
                        <button type="button" id="saveDraftButton" class="btn btn-secondary">
                            <i class="fas fa-save"></i> Save Draft
                        </button>
                        <button type="submit" id="publishButton" class="btn btn-primary" disabled="${!sessionScope.currentPublisher.isVerified}">
                            <i class="fas fa-paper-plane"></i> Submit
                        </button>
                    </div>
                </div>

                <!-- Category Selection -->
                <div class="sidebar-card">
                    <h3>Category <span class="required">*</span></h3>
                    <div class="form-group">
                        <select id="articleCategory" name="category" required>
                            <option value="">Select a category</option>
                            <option value="1" ${article.categoryId == 1 ? 'selected' : ''}>Technology</option>
                            <option value="2" ${article.categoryId == 2 ? 'selected' : ''}>Business</option>
                            <option value="3" ${article.categoryId == 3 ? 'selected' : ''}>Health</option>
                            <option value="4" ${article.categoryId == 4 ? 'selected' : ''}>Sports</option>
                            <option value="5" ${article.categoryId == 5 ? 'selected' : ''}>Culture</option>
                            <option value="6" ${article.categoryId == 6 ? 'selected' : ''}>Politics</option>
                            <option value="7" ${article.categoryId == 7 ? 'selected' : ''}>Science</option>
                            <option value="8" ${article.categoryId == 8 ? 'selected' : ''}>Entertainment</option>
                        </select>
                    </div>
                </div>

                <!-- Featured Image -->
                <div class="sidebar-card">
                    <h3>Featured Image</h3>
                    <div class="form-group">
                        <div class="image-upload-container">
                            <div id="imagePreviewContainer" class="image-preview">
                                <img id="imagePreview"
                                     src="${pageContext.request.contextPath}/assets/images/placeholder-image.jpg"
                                     alt="Featured image preview">
                            </div>
                            <div class="upload-controls">
                                <label for="featuredImage" class="btn btn-secondary upload-btn">
                                    <i class="fas fa-upload"></i> Choose Image
                                </label>
                                <input type="file" id="featuredImage" name="featuredImage" accept=".jpg,.jpeg"
                                       style="display: none;">
                                <button type="button" id="removeImageBtn" class="btn btn-danger" style="display: none;">
                                    <i class="fas fa-trash"></i> Remove
                                </button>
                            </div>
                        </div>
                        <div class="image-requirements">
                            <small>Recommended size: 1200 x 630 pixels (16:9 ratio)</small>
                            <small>Maximum file size: 2MB</small>
                            <small>Supported formats: JPG, JPEG</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script src="${pageContext.request.contextPath}/assets/js/createArticle.js"></script>