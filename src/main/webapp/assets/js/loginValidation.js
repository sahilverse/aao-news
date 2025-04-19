// Login Form Validation Logic

// Show error message below the input field
function addErrorMessage(element, message) {
    let errorEl = element.nextElementSibling;
    if (errorEl && errorEl.classList.contains("error")) {
        errorEl.innerText = message;
    } else {
        const error = document.createElement("p");
        error.className = "error";
        element.insertAdjacentElement("afterend", error);
        error.innerText = message;
    }
}

// Remove existing error message
function removeError(element) {
    const nextEl = element.nextElementSibling;
    if (nextEl && nextEl.classList.contains("error")) {
        nextEl.remove();
    }
}

// Validate email using regex
function validateEmail(email) {
    const regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
    return regex.test(email.value);
}

// Handle form submission
function submitForm() {
    const form = document.forms["loginForm"];
    const email = form["email"];
    const password = form["password"];
    let isValid = true;

    if (!validateEmail(email)) {
        addErrorMessage(email, "Please enter a valid email.");
        isValid = false;
    } else {
        removeError(email);
    }

    if (!password.value.trim()) {
        addErrorMessage(password, "Password is required.");
        isValid = false;
    } else {
        removeError(password);
    }

    return isValid;
}
