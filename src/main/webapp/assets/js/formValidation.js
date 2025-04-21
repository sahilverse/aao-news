// Utility to show error message
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

// Utility to remove error
function removeError(element) {
    const nextEl = element.nextElementSibling;
    if (nextEl && nextEl.classList.contains("error")) {
        nextEl.remove();
    }
}

// Email validation
function validateEmail(value) {
    const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return regex.test(value.trim());
}

// Field validator dispatcher
const validators = {
    required: (field) => field.value.trim() !== '',
    email: (field) => validateEmail(field.value),
    match: (field, allFields, matchFieldName) => field.value === allFields[matchFieldName].value
};

// General validation engine
function validateForm(formName, rules) {
    const form = document.forms[formName];
    let isValid = true;

    Object.keys(rules).forEach((fieldName) => {
        const field = form[fieldName];
        const validations = rules[fieldName];

        removeError(field); // Clear previous error

        validations.forEach((validation) => {
            let valid = true;
            let message = "";

            if (typeof validation === "string") {
                valid = validators[validation](field, form);
                if (!valid) message = `${fieldName} is invalid.`;
            } else if (typeof validation === "object") {
                const [rule, msg] = Object.entries(validation)[0];
                valid = validators[rule](field, form, rule === "match" ? msg.matchField : undefined);
                if (!valid) message = msg.message;
            }

            if (!valid) {
                addErrorMessage(field, message);
                isValid = false;
            }
        });
    });

    return isValid;
}

// Attach validator to form
function attachFormValidator(formName, rules) {
    document.addEventListener("DOMContentLoaded", () => {
        const form = document.forms[formName];
        if (!form) return;

        form.addEventListener("submit", (event) => {
            if (!validateForm(formName, rules)) {
                event.preventDefault();
            }
        });
    });
}
