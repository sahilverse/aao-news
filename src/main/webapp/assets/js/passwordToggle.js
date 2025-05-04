document.addEventListener("DOMContentLoaded", () => {
    const passwordToggles = document.querySelectorAll(".password-toggle")

    passwordToggles.forEach((toggle) => {
        toggle.addEventListener("click", () => {
            const container = toggle.closest(".password-input-container")

            const passwordInput = container.querySelector("input[type='password'], input[type='text']")

            if (passwordInput) {
                // Toggle the input type between password and text
                const type = passwordInput.getAttribute("type") === "password" ? "text" : "password"
                passwordInput.setAttribute("type", type)

                // Toggle the eye icon
                const icon = toggle.querySelector("i")
                if (type === "password") {
                    icon.classList.remove("fa-eye")
                    icon.classList.add("fa-eye-slash")
                } else {
                    icon.classList.remove("fa-eye-slash")
                    icon.classList.add("fa-eye")
                }
            }
        })
    })
})
