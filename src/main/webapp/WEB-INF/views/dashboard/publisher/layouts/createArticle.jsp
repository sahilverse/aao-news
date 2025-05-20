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

    <!-- Display success message if any -->
    <!-- Display success message if any -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="success">
                ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <form id="articleForm" action="${pageContext.request.contextPath}/publisher/create" method="post" enctype="multipart/form-data">
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
                              placeholder="Write a brief summary of your article" maxlength="500">${article.summary}</textarea>
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
                        <button type="submit" id="publishButton" class="btn btn-primary">
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
                                <img id="imagePreview" src="${pageContext.request.contextPath}/assets/images/placeholder-image.jpg" alt="Featured image preview">
                            </div>
                            <div class="upload-controls">
                                <label for="featuredImage" class="btn btn-secondary upload-btn">
                                    <i class="fas fa-upload"></i> Choose Image
                                </label>
                                <input type="file" id="featuredImage" name="featuredImage" accept=".jpg,.jpeg" style="display: none;">
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

<script>
    // Initialize Jodit Editor
    const editor = Jodit.make('#articleContent', {
        height: 500,
        toolbarSticky: true,
        toolbarStickyOffset: 80,
        buttons: [
            'source', '|',
            'bold', 'italic', 'underline', 'strikethrough', '|',
            'ul', 'ol', '|',
            'paragraph', 'fontsize', 'brush', '|',
            'table', 'link', '|',
            'align', '|',
            'undo', 'redo', '|',
            'hr', 'eraser', 'fullsize'
        ],
        uploader: {
            url: '${pageContext.request.contextPath}/publisher/upload-image',
            format: 'json',
            pathVariableName: 'path',
            filesVariableName: 'files',
            prepareData: function (data) {
                return data;
            },
            isSuccess: function (resp) {
                return !resp.error;
            },
            getMessage: function (resp) {
                return resp.message;
            },
            process: function (resp) {
                return {
                    files: resp.files || [],
                    path: resp.path || '',
                    baseurl: resp.baseurl || '',
                    error: resp.error || 0,
                    message: resp.message || ''
                };
            },
            error: function (e) {
                this.jodit.events.fire('errorMessage', e.message, 'error', 4000);
            },
            defaultHandlerSuccess: function (data, resp) {
                if (data.files && data.files.length) {
                    data.files.forEach((file) => {
                        this.selection.insertImage(data.baseurl + data.path + file);
                    });
                }
            },
            defaultHandlerError: function (resp) {
                this.jodit.events.fire('errorMessage', resp.message);
            }
        }
    });

    // Character counters
    document.getElementById('articleTitle').addEventListener('input', function() {
        const count = this.value.length;
        document.getElementById('titleCharCount').textContent = count;
    });

    document.getElementById('articleSummary').addEventListener('input', function() {
        const count = this.value.length;
        document.getElementById('summaryCharCount').textContent = count;
    });

    // Initialize character counters on page load
    window.addEventListener('load', function() {
        const titleCount = document.getElementById('articleTitle').value.length;
        document.getElementById('titleCharCount').textContent = titleCount;

        const summaryCount = document.getElementById('articleSummary').value.length;
        document.getElementById('summaryCharCount').textContent = summaryCount;
    });

    // Image preview functionality
    document.getElementById('featuredImage').addEventListener('change', function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('imagePreview').src = e.target.result;
                document.getElementById('removeImageBtn').style.display = 'inline-block';
            }
            reader.readAsDataURL(file);
        }
    });

    document.getElementById('removeImageBtn').addEventListener('click', function() {
        document.getElementById('featuredImage').value = '';
        document.getElementById('imagePreview').src = '${pageContext.request.contextPath}/assets/images/placeholder-image.jpg';
        this.style.display = 'none';
    });

    // Auto-save functionality (mock)
    let autoSaveTimer;
    const autoSaveInterval = 30000; // 30 seconds

    function setupAutoSave() {
        const formInputs = document.querySelectorAll('#articleForm input, #articleForm textarea, #articleForm select');
        formInputs.forEach(input => {
            input.addEventListener('input', function() {
                clearTimeout(autoSaveTimer);
                document.getElementById('autoSaveStatus').textContent = 'Saving...';

                autoSaveTimer = setTimeout(function() {
                    // Mock auto-save - in a real implementation, this would send data to the server
                    document.getElementById('autoSaveStatus').textContent = 'All changes saved';
                }, 1500);
            });
        });

        // Also trigger for Jodit editor changes
        editor.events.on('change', function() {
            clearTimeout(autoSaveTimer);
            document.getElementById('autoSaveStatus').textContent = 'Saving...';

            autoSaveTimer = setTimeout(function() {
                document.getElementById('autoSaveStatus').textContent = 'All changes saved';
            }, 1500);
        });
    }

    // Form submission handling
    document.getElementById('saveDraftButton').addEventListener('click', function() {
        document.getElementById('articleStatus').value = 'draft';

        // Make sure the Jodit editor content is synced to the textarea
        editor.value = editor.getEditorValue();

        document.getElementById('articleForm').submit();
    });

    document.getElementById('publishButton').addEventListener('click', function(e) {
        e.preventDefault(); // Prevent default button behavior
        document.getElementById('articleStatus').value = 'publish';

        // Make sure the Jodit editor content is synced to the textarea
        editor.value = editor.getEditorValue();

        document.getElementById('articleForm').submit();
    });

    document.getElementById('previewButton').addEventListener('click', function() {
        // Open preview in new tab/window
        const form = document.getElementById('articleForm');
        const formData = new FormData(form);

        // In a real implementation, this would send the data to a preview endpoint
        // For now, we'll just show an alert
        alert('Preview functionality would open a new tab with the article preview');
    });

    // Initialize auto-save when the page loads
    window.addEventListener('load', setupAutoSave);
</script>