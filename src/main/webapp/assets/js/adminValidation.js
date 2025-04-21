attachFormValidator("adminForm", {
    adminCode: [
        { required: { message: "Admin code is required." } }
    ],
    email: [
        { email: { message: "Please enter a valid email address." } },
        { required: { message: "Email is required." } }
    ],
    fullName: [
        { required: { message: "Full name is required." } }
    ],
    password: [
        { required: { message: "Password is required." } }
    ],
    confirmPassword: [
        { required: { message: "Please confirm your password." } },
        { match: { message: "Passwords do not match.", matchField: "password" } }
    ]
});
