let isLiked = false
let isSaved = false
let likeCount = 247 // This will be loaded from server
let saveCount = 89

// Get context path and article ID from window object



console.log("Context Path:", contextPath)

// Initialize page
document.addEventListener("DOMContentLoaded", () => {
    loadArticleLikeStatus()
    loadCommentCount()
})

// Load article like status and count
function loadArticleLikeStatus() {
    fetch(`${contextPath}/article-like?action=getCount&articleId=${currentArticleId}`)
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                likeCount = data.count
                document.getElementById("like-count").textContent = likeCount
            }
        })
        .catch((error) => console.error("Error loading like count:", error))

    fetch(`${contextPath}/article-like?action=checkLiked&articleId=${currentArticleId}`)
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                isLiked = data.liked
                updateLikeButton()
            }
        })
        .catch((error) => console.error("Error checking like status:", error))
}

// Load comment count
function loadCommentCount() {
    fetch(`${contextPath}/comment?action=getCount&articleId=${currentArticleId}`)
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                document.getElementById("comment-count").textContent = data.count
                document.querySelector(".comment-section-title").textContent = `Comments (${data.count})`
            }
        })
        .catch((error) => console.error("Error loading comment count:", error))
}

// Toggle like functionality
function toggleLike() {
    fetch(`${contextPath}/article-like`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=toggle&articleId=${currentArticleId}`,
    })
        .then((response) => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);

            // Check if response is ok
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            // Check if response is JSON
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                throw new Error('Response is not JSON');
            }

            return response.json();
        })
        .then((data) => {
            console.log('Response data:', data);

            if (data.success) {
                isLiked = data.liked
                likeCount = data.likeCount
                updateLikeButton()
                document.getElementById("like-count").textContent = likeCount
            } else {
                alert(data.message || "Failed to toggle like")
            }
        })
        .catch((error) => {
            console.error("Error toggling like:", error)
            alert("Error toggling like: " + error.message)
        })
}

// Update like button appearance
function updateLikeButton() {
    const likeBtn = document.getElementById("like-btn")
    const likeIcon = document.getElementById("like-icon")

    if (isLiked) {
        likeIcon.className = "fas fa-heart"
        likeBtn.classList.add("active")
    } else {
        likeIcon.className = "far fa-heart"
        likeBtn.classList.remove("active")
    }
}

// Save functionality (placeholder - implement similar to like)
function toggleSave() {
    // Implement save functionality similar to like
    const saveBtn = document.getElementById("save-btn")
    const saveIcon = document.getElementById("save-icon")
    const saveCountElement = document.getElementById("save-count")

    if (isSaved) {
        saveIcon.className = "far fa-bookmark"
        saveBtn.classList.remove("active")
        saveCount--
        isSaved = false
    } else {
        saveIcon.className = "fas fa-bookmark"
        saveBtn.classList.add("active")
        saveCount++
        isSaved = true
    }

    saveCountElement.textContent = saveCount
}

// Comment functionality
function focusCommentInput() {
    document.getElementById("comment-input").focus()
}

function addComment() {
    const input = document.getElementById("comment-input")
    const content = input.value.trim()

    if (!content) {
        alert("Please enter a comment")
        return
    }

    fetch(`${contextPath}/comment`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=add&articleId=${currentArticleId}&content=${encodeURIComponent(content)}`,
    })
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                // Create new comment element
                const commentsList = document.querySelector(".comments-list")
                if (commentsList) {
                    const newComment = createCommentElement(data.commentId, data.authorName, data.content, data.createdAt)
                    // Add the new comment to the top of the list
                    commentsList.insertBefore(newComment, commentsList.firstChild)
                }

                // Clear input
                input.value = ""

                // Update comment count
                loadCommentCount()
            } else {
                alert(data.message || "Failed to add comment")
            }
        })
        .catch((error) => {
            console.error("Error adding comment:", error)
            alert("Error adding comment. Please try again.")
        })
}

function cancelComment() {
    document.getElementById("comment-input").value = ""
}

// Reply functionality
function toggleReply(button) {
    const commentItem = button.closest(".comment-item")
    const replyForm = commentItem.querySelector(".reply-form")

    // Close any other open reply forms first
    document.querySelectorAll(".reply-form").forEach((form) => {
        if (form !== replyForm) {
            form.style.display = "none"
            const formReplyButton = form.closest(".comment-content").querySelector(".reply-btn")
            formReplyButton.innerHTML = '<i class="fas fa-reply"></i> Reply'
            formReplyButton.classList.remove("active")
        }
    })

    if (replyForm.style.display === "none" || replyForm.style.display === "") {
        replyForm.style.display = "block"
        replyForm.querySelector("textarea").focus()
        button.innerHTML = '<i class="fas fa-times"></i> Cancel Reply'
        button.classList.add("active")
    } else {
        replyForm.style.display = "none"
        button.innerHTML = '<i class="fas fa-reply"></i> Reply'
        button.classList.remove("active")
        replyForm.querySelector("textarea").value = ""
    }
}

function addReply(button) {
    const replyForm = button.closest(".reply-form")
    const textarea = replyForm.querySelector("textarea")
    const content = textarea.value.trim()

    if (!content) {
        alert("Please enter a reply")
        return
    }

    // Get parent comment ID
    const commentItem = replyForm.closest(".comment-item")
    const parentId = commentItem.dataset.commentId || 0

    fetch(`${contextPath}/comment`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=reply&articleId=${currentArticleId}&parentId=${parentId}&content=${encodeURIComponent(content)}`,
    })
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                // Create new reply element
                const repliesContainer = replyForm.closest(".comment-content").querySelector(".replies")
                const newReply = createReplyElement(data.commentId, data.authorName, data.content, data.createdAt)

                // Add the new reply to the replies container
                repliesContainer.appendChild(newReply)

                // Clear and hide the form
                textarea.value = ""
                replyForm.style.display = "none"

                // Reset the reply button
                const replyButton = replyForm.closest(".comment-content").querySelector(".reply-btn")
                replyButton.innerHTML = '<i class="fas fa-reply"></i> Reply'
                replyButton.classList.remove("active")

                // Update comment count
                loadCommentCount()
            } else {
                alert(data.message || "Failed to add reply")
            }
        })
        .catch((error) => {
            console.error("Error adding reply:", error)
            alert("Error adding reply. Please try again.")
        })
}

function cancelReply(button) {
    const replyForm = button.closest(".reply-form")
    const commentContent = replyForm.closest(".comment-content")
    const replyButton = commentContent.querySelector(".reply-btn")

    replyForm.querySelector("textarea").value = ""
    replyForm.style.display = "none"
    replyButton.innerHTML = '<i class="fas fa-reply"></i> Reply'
    replyButton.classList.remove("active")
}

// Comment like functionality
function toggleCommentLike(button) {
    const commentItem = button.closest(".comment-item")
    const commentId = commentItem.dataset.commentId

    if (!commentId) {
        alert("Comment ID not found")
        return
    }

    fetch(`${contextPath}/comment-like`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=toggle&commentId=${commentId}`,
    })
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                const icon = button.querySelector("i")
                const countSpan = button.querySelector(".like-count")

                if (data.liked) {
                    icon.className = "fas fa-heart"
                    button.classList.add("liked")
                } else {
                    icon.className = "far fa-heart"
                    button.classList.remove("liked")
                }

                countSpan.textContent = data.likeCount
            } else {
                alert(data.message || "Failed to toggle comment like")
            }
        })
        .catch((error) => {
            console.error("Error toggling comment like:", error)
            alert("Error toggling comment like. Please try again.")
        })
}

// Helper function to create a new comment element
function createCommentElement(commentId, authorName, content, createdAt) {
    const commentDiv = document.createElement("div")
    commentDiv.className = "comment-item"
    commentDiv.dataset.commentId = commentId

    commentDiv.innerHTML = `
        <img src="${contextPath}/user-image?id=default" alt="User Avatar" class="comment-avatar">
        <div class="comment-content">
            <div class="comment-header">
                <span class="comment-author">${authorName}</span>
                <span class="comment-date">${createdAt}</span>
            </div>
            <p class="comment-text">${content}</p>
            <div class="comment-actions-bar">
                <button class="comment-action-btn like-comment-btn" onclick="toggleCommentLike(this)">
                    <i class="far fa-heart"></i>
                    <span class="like-count">0</span>
                </button>
                <button class="comment-action-btn reply-btn" onclick="toggleReply(this)">
                    <i class="fas fa-reply"></i>
                    Reply
                </button>
            </div>
            
            <div class="reply-form" style="display: none;">
                <div class="comment-input-container">
                    <img src="${contextPath}/user-image?id=default" alt="Your Avatar" class="comment-avatar small">
                    <div class="comment-input-wrapper">
                        <textarea 
                            placeholder="Write a reply..." 
                            class="comment-input small"
                            rows="2"
                        ></textarea>
                        <div class="comment-actions">
                            <button class="comment-submit-btn small" onclick="addReply(this)">Reply</button>
                            <button class="comment-cancel-btn small" onclick="cancelReply(this)">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="replies"></div>
        </div>
    `

    return commentDiv
}

// Helper function to create a new reply element
function createReplyElement(commentId, authorName, content, createdAt) {
    const replyDiv = document.createElement("div")
    replyDiv.className = "comment-item reply"
    replyDiv.dataset.commentId = commentId

    replyDiv.innerHTML = `
        <img src="${contextPath}/user-image?id=default" alt="User Avatar" class="comment-avatar small">
        <div class="comment-content">
            <div class="comment-header">
                <span class="comment-author">${authorName}</span>
                <span class="comment-date">${createdAt}</span>
            </div>
            <p class="comment-text">${content}</p>
            <div class="comment-actions-bar">
                <button class="comment-action-btn like-comment-btn" onclick="toggleCommentLike(this)">
                    <i class="far fa-heart"></i>
                    <span class="like-count">0</span>
                </button>
                <button class="comment-action-btn reply-btn" onclick="toggleReply(this)">
                    <i class="fas fa-reply"></i>
                    Reply
                </button>
            </div>
            
            <div class="reply-form" style="display: none;">
                <div class="comment-input-container">
                    <img src="${contextPath}/user-image?id=default" alt="Your Avatar" class="comment-avatar small">
                    <div class="comment-input-wrapper">
                        <textarea 
                            placeholder="Write a reply..." 
                            class="comment-input small"
                            rows="2"
                        ></textarea>
                        <div class="comment-actions">
                            <button class="comment-submit-btn small" onclick="addReply(this)">Reply</button>
                            <button class="comment-cancel-btn small" onclick="cancelReply(this)">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="replies"></div>
        </div>
    `

    return replyDiv
}
