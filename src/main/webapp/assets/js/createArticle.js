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
        'hr', 'eraser', 'fullsize',

    ]

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


document.getElementById('previewButton').addEventListener('click', function() {

    const form = document.getElementById('articleForm');
    const formData = new FormData(form);

    alert('Preview functionality would open a new tab with the article preview');
});

// Initialize auto-save when the page loads
window.addEventListener('load', setupAutoSave);