// Form Validation for Personal Information
attachFormValidator("personal-info-form", {
    fullName: [
        { required: { message: "Full name is required." } }
    ]
});
// Form Validation for Password
attachFormValidator("password-change-form", {
    oldPassword: [
        {required: {message: "Old password is required."}}
    ],
    newPassword: [
        {required: {message: "Password is required."}}
    ],
    confirmPassword: [
        {required: {message: "Please confirm your password."}},
        {match: {message: "Passwords do not match.", matchField: "newPassword"}}
    ]
});


// Check for form changes
const personalForm = document.getElementById("personal-info-form");
const saveBtn = document.getElementById("save-changes-btn");

// Get initial form values
const initialFormData = {};
Array.from(personalForm.elements).forEach(input => {
    if (input.name) {
        initialFormData[input.name] = input.value;
    }
});

// Function to check for changes
const checkForChanges = () => {
    for (let input of personalForm.elements) {
        if (input.name && input.value !== initialFormData[input.name]) {
            saveBtn.disabled = false;
            return;
        }
    }
    saveBtn.disabled = true;
};

// Attach input listeners
personalForm.addEventListener("input", checkForChanges);


//  Camera Button
const openBtn = document.getElementById("camera-btn");
const dialog = document.getElementById("upload-dialog");
const cancelBtn = document.getElementById("cancel-upload");

openBtn.addEventListener("click", () => {
    dialog.style.display = "flex";
});

cancelBtn.addEventListener("click", () => {
    dialog.style.display = "none";
});

dialog.addEventListener("click", (e) => {
    if (e.target === dialog) {
        dialog.style.display = "none";
    }
});