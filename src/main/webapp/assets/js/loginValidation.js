attachFormValidator("loginForm", {
    email: [
        { email: { message: "Please enter a valid email address." } },
        { required: { message: "Email is required." } }
    ],
    password: [
        { required: { message: "Password is required." } }
    ]
});
