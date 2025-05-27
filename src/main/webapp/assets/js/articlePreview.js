let isLiked = false
let isSaved = false
let likeCount = 0
let saveCount = 0


// Initialize page
document.addEventListener("DOMContentLoaded", () => {
    loadArticleLikeStatus()
    loadCommentCount()
    loadSavedCounts()
    loadBookmarkStatus()
    loadComments()
})

// Load saved counts
function loadSavedCounts() {
    fetch(`${contextPath}/bookmark?action=getCount&articleId=${currentArticleId}`)
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                saveCount = data.count
                document.getElementById("save-count").textContent = saveCount
            }
        })
        .catch((error) => console.error("Error loading bookmark count:", error))
}

// Load bookmark status
function loadBookmarkStatus() {
    if (!currentUser) return

    fetch(`${contextPath}/bookmark?action=checkBookmarked&articleId=${currentArticleId}`)
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                isSaved = data.bookmarked
                updateSaveButton()
            }
        })
        .catch((error) => console.error("Error checking bookmark status:", error))
}

// Load comment Like status and count
function loadCommentLikeStatus() {
    const commentItems = document.querySelectorAll(".comment-item")

    commentItems.forEach((commentItem) => {
        const commentId = commentItem.dataset.commentId
        if (!commentId) return

        const likeButton = commentItem.querySelector(".like-comment-btn")
        const likeCountSpan = likeButton?.querySelector(".like-count")
        const likeIcon = likeButton?.querySelector("i")

        if (!likeButton || !likeCountSpan || !likeIcon) return

        // Load like count for this comment
        fetch(`${contextPath}/comment-like?action=getCount&commentId=${commentId}`)
            .then((response) => response.json())
            .then((data) => {
                if (data.success) {
                    console.log("comment like data", data)
                    likeCountSpan.textContent = data.count
                }
            })
            .catch((error) => console.error(`Error loading like count for comment ${commentId}:`, error))

        // Load like status for current user (only if user is logged in)
        if (currentUser) {
            fetch(`${contextPath}/comment-like?action=checkLiked&commentId=${commentId}`)
                .then((response) => response.json())
                .then((data) => {
                    if (data.success) {
                        if (data.liked) {
                            likeIcon.className = "fas fa-heart"
                            likeButton.classList.add("liked")
                        } else {
                            likeIcon.className = "far fa-heart"
                            likeButton.classList.remove("liked")
                        }
                    }
                })
                .catch((error) => console.error(`Error loading like status for comment ${commentId}:`, error))
        }
    })
}

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

// Load comments with proper nesting
function loadComments() {
    fetch(`${contextPath}/comment?action=getComments&articleId=${currentArticleId}`)
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                console.log("Comments loaded successfully:", data.comments)
                const commentsList = document.querySelector(".comments-list")
                commentsList.innerHTML = ""

                // Separate parent comments and replies
                const parentComments = []
                const replies = []

                data.comments.forEach((comment) => {
                    if (comment.comment.parentId === null || comment.comment.parentId === 0) {
                        parentComments.push(comment)
                    } else {
                        replies.push(comment)
                    }
                })

                // Create parent comments first
                parentComments.forEach((comment) => {
                    const commentElement = createCommentElement(
                        comment.comment.id,
                        comment.user.fullName,
                        comment.comment.content,
                        comment.comment.createdAt,
                        comment.user.id,
                    )
                    commentsList.appendChild(commentElement)

                    // Find and add replies for this parent comment
                    const commentReplies = replies.filter((reply) => reply.comment.parentId === comment.comment.id)
                    const repliesContainer = commentElement.querySelector(".replies")

                    commentReplies.forEach((reply) => {
                        const replyElement = createReplyElement(
                            reply.comment.id,
                            reply.user.fullName,
                            reply.comment.content,
                            reply.comment.createdAt,
                            reply.user.id,
                        )
                        repliesContainer.appendChild(replyElement)
                    })
                })

                setTimeout(() => {
                    loadCommentLikeStatus()
                }, 100)
            } else {
                console.error("Failed to load comments:", data.message)
            }
        })
        .catch((error) => console.error("Error loading comments:", error))
}

// Toggle like functionality
function toggleLike() {
    if (!currentUser) {
        alert("Please log in to like articles")
        return
    }

    fetch(`${contextPath}/article-like`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=toggle&articleId=${currentArticleId}`,
    })
        .then((response) => {
            return response.json()
        })
        .then((data) => {
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

// Save functionality
function toggleSave() {
    if (!currentUser) {
        alert("Please log in to bookmark articles")
        return
    }

    fetch(`${contextPath}/bookmark`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=toggle&articleId=${currentArticleId}`,
    })
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                isSaved = data.bookmarked
                saveCount = data.bookmarkCount
                updateSaveButton()
                document.getElementById("save-count").textContent = saveCount
            } else {
                alert(data.message || "Failed to toggle bookmark")
            }
        })
        .catch((error) => {
            console.error("Error toggling bookmark:", error)
            alert("Error toggling bookmark: " + error.message)
        })
}

// Update save button appearance
function updateSaveButton() {
    const saveBtn = document.getElementById("save-btn")
    const saveIcon = document.getElementById("save-icon")

    if (isSaved) {
        saveIcon.className = "fas fa-bookmark"
        saveBtn.classList.add("active")
    } else {
        saveIcon.className = "far fa-bookmark"
        saveBtn.classList.remove("active")
    }
}

// Comment functionality
function focusCommentInput() {
    document.getElementById("comment-input").focus()
}

function addComment() {
    if (!currentUser) {
        alert("Please log in to add comments")
        return
    }

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
                // Access nested object structure
                const commentData = data.comments
                const commentsList = document.querySelector(".comments-list")
                if (commentsList) {
                    const newComment = createCommentElement(
                        commentData.comment.id,
                        commentData.user.fullName,
                        commentData.comment.content,
                        commentData.comment.createdAt,
                        commentData.user.id,
                    )
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
    if (!currentUser) {
        alert("Please log in to reply to comments")
        return
    }

    const commentItem = button.closest(".comment-item")
    const replyForm = commentItem.querySelector(".reply-form")

    // Close any other open reply forms first
    document.querySelectorAll(".reply-form").forEach((form) => {
        if (form !== replyForm) {
            form.style.display = "none"
            const formReplyButton = form.closest(".comment-content").querySelector(".reply-btn")
            if (formReplyButton) {
                formReplyButton.innerHTML = '<i class="fas fa-reply"></i> Reply'
                formReplyButton.classList.remove("active")
            }
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
    if (!currentUser) {
        alert("Please log in to reply to comments")
        return
    }

    const replyForm = button.closest(".reply-form")
    const textarea = replyForm.querySelector("textarea")
    const content = textarea.value.trim()

    if (!content) {
        alert("Please enter a reply")
        return
    }

    // Get parent comment ID - look for the main comment, not a nested reply
    const commentItem = replyForm.closest(".comment-item")
    let parentId = commentItem.dataset.commentId

    // If this is a reply to a reply, find the original parent comment
    if (commentItem.classList.contains("reply")) {
        const mainCommentItem = commentItem.closest(".comment-item:not(.reply)")
        if (mainCommentItem) {
            parentId = mainCommentItem.dataset.commentId
        }
    }

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
                // Access nested object structure for reply
                const replyData = data.reply

                // Find the main comment's replies container
                let mainCommentItem = replyForm.closest(".comment-item")
                if (mainCommentItem.classList.contains("reply")) {
                    mainCommentItem = mainCommentItem.closest(".comment-item:not(.reply)")
                }

                const repliesContainer = mainCommentItem.querySelector(".replies")
                const newReply = createReplyElement(
                    replyData.comment.id,
                    replyData.user.fullName,
                    replyData.comment.content,
                    replyData.comment.createdAt,
                    replyData.user.id,
                )

                // Add the new reply to the replies container
                repliesContainer.appendChild(newReply)

                // Clear and hide the form
                textarea.value = ""
                replyForm.style.display = "none"

                // Reset the reply button
                const replyButton = replyForm.closest(".comment-content").querySelector(".reply-btn")
                if (replyButton) {
                    replyButton.innerHTML = '<i class="fas fa-reply"></i> Reply'
                    replyButton.classList.remove("active")
                }

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
    if (replyButton) {
        replyButton.innerHTML = '<i class="fas fa-reply"></i> Reply'
        replyButton.classList.remove("active")
    }
}

// Comment like functionality
function toggleCommentLike(button) {
    if (!currentUser) {
        alert("Please log in to like comments")
        return
    }

    const commentItem = button.closest(".comment-item")
    const commentId = commentItem.dataset.commentId
    console.log("Toggling like for comment ID:", commentId) // Debug log

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

// Delete comment functionality
function deleteComment(button) {
    const commentItem = button.closest(".comment-item")
    const commentId = commentItem.dataset.commentId
    const isReply = commentItem.classList.contains("reply")

    if (!commentId) {
        alert("Comment ID not found")
        return
    }

    // Show confirmation dialog
    const confirmDelete = confirm("Are you sure you want to delete this comment?")
    if (!confirmDelete) {
        return
    }

    fetch(`${contextPath}/comment`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=delete&commentId=${commentId}`,
    })
        .then((response) => response.json())
        .then((data) => {
            if (data.success) {
                // Remove the comment element from DOM
                commentItem.remove()

                // Update comment count
                loadCommentCount()

                console.log("Comment deleted successfully")
            } else {
                alert(data.message || "Failed to delete comment")
            }
        })
        .catch((error) => {
            console.error("Error deleting comment:", error)
            alert("Error deleting comment. Please try again.")
        })
}

// Helper function to create a new comment element
function createCommentElement(commentId, authorName, content, createdAt, userId) {
    const commentDiv = document.createElement("div")
    commentDiv.className = "comment-item"
    commentDiv.dataset.commentId = commentId

    commentDiv.innerHTML = `
        <img src="${contextPath}/user-image?id=${userId}" alt="User Avatar" class="comment-avatar">
        <div class="comment-content">
            <div class="comment-header">
                <span class="comment-author">${authorName}</span>
                <span class="comment-date">${createdAt}</span>
            </div>
            <p class="comment-text">${content}</p>
            <div class="comment-actions-bar">
                <button class="comment-action-btn like-comment-btn" onclick="toggleCommentLike(this)" ${!currentUser ? "disabled" : ""}>
                    <i class="far fa-heart"></i>
                    <span class="like-count">0</span>
                </button>
                <button class="comment-action-btn reply-btn" onclick="toggleReply(this)" ${!currentUser ? "disabled" : ""}>
                    <i class="fas fa-reply"></i>
                    Reply
                </button>
                ${
        currentUser && currentUser === userId
            ? `<button class="comment-action-btn delete-comment-btn" onclick="deleteComment(this)" title="Delete comment">
                        <i class="fas fa-trash"></i>
                    </button>`
            : ""
    }
            </div>
            <div class="reply-form" style="display: none;">
                <div class="comment-input-container">
                    <div class="comment-input-wrapper">
                        <textarea 
                            placeholder="Write a reply..." 
                            class="comment-input small"
                            rows="2"
                        ></textarea>
                        <div class="comment-actions">
                            <button class="comment-submit-btn small" onclick="addReply(this)" ${!currentUser ? "disabled" : ""}>Reply</button>
                            <button class="comment-cancel-btn small" onclick="cancelReply(this)" ${!currentUser ? "disabled" : ""}>Cancel</button>
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
function createReplyElement(commentId, authorName, content, createdAt, userId) {
    const replyDiv = document.createElement("div")
    replyDiv.className = "comment-item reply"
    replyDiv.dataset.commentId = commentId

    replyDiv.innerHTML = `
        <img src="${contextPath}/user-image?id=${userId}" alt="User Avatar" class="comment-avatar small">
        <div class="comment-content">
            <div class="comment-header">
                <span class="comment-author">${authorName}</span>
                <span class="comment-date">${createdAt}</span>
            </div>
            <p class="comment-text">${content}</p>
            <div class="comment-actions-bar">
                <button class="comment-action-btn like-comment-btn" onclick="toggleCommentLike(this)" ${!currentUser ? "disabled" : ""}>
                    <i class="far fa-heart"></i>
                    <span class="like-count">0</span>
                </button>
                
                ${
        currentUser && currentUser === userId
            ? `<button class="comment-action-btn delete-comment-btn" onclick="deleteComment(this)" title="Delete reply">
                        <i class="fas fa-trash"></i>
                    </button>`
            : ""
    }
            </div>
      
        </div>
    `

    return replyDiv
}
