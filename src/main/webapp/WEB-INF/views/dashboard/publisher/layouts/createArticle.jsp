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

    <form id="articleForm" action="${pageContext.request.contextPath}/publisher/article/create" method="post" enctype="multipart/form-data">
        <div class="form-grid">
            <!-- Left Column -->
            <div class="main-content" style="margin-left: 0; margin-top: 0; ">
                <!-- Article Title -->
                <div class="form-group">
                    <label for="articleTitle">Article Title <span class="required">*</span></label>
                    <input type="text" id="articleTitle" name="title" required
                           placeholder="Enter a descriptive title" maxlength="150">
                    <div class="char-counter">
                        <span id="titleCharCount">0</span>/150 characters
                    </div>
                </div>

                <!-- Article Content Editor -->
                <div class="form-group">
                    <label for="articleContent">Article Content <span class="required">*</span></label>
                    <textarea id="articleContent" name="content"></textarea>
                </div>

                <!-- Article Summary -->
                <div class="form-group">
                    <label for="articleSummary">Article Summary <span class="required">*</span></label>
                    <textarea id="articleSummary" name="summary" rows="4"
                              placeholder="Write a brief summary of your article" maxlength="500"></textarea>
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
                            <!-- Mock categories - replace with actual data from backend -->
                            <option value="1">Politics</option>
                            <option value="2">Technology</option>
                            <option value="3">Business</option>
                            <option value="4">Health</option>
                            <option value="5">Science</option>
                            <option value="6">Sports</option>
                            <option value="7">Entertainment</option>
                            <option value="8">World</option>
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
                                <input type="file" id="featuredImage" name="featuredImage" accept="image/*" style="display: none;">
                                <button type="button" id="removeImageBtn" class="btn btn-danger" style="display: none;">
                                    <i class="fas fa-trash"></i> Remove
                                </button>
                            </div>
                        </div>
                        <div class="image-requirements">
                            <small>Recommended size: 1200 x 630 pixels (16:9 ratio)</small>
                            <small>Maximum file size: 2MB</small>
                            <small>Supported formats: JPG, PNG, WebP</small>
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
        document.getElementById('articleForm').submit();
    });

    document.getElementById('publishButton').addEventListener('click', function() {
        document.getElementById('articleStatus').value = 'publish';
        // Form will be submitted normally
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
