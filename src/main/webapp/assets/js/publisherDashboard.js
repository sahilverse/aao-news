import { Chart } from "@/components/ui/chart"
// Publisher Dashboard JavaScript

document.addEventListener("DOMContentLoaded", () => {
    // Sidebar Toggle
    const sidebarToggle = document.getElementById("sidebar-toggle")
    const sidebar = document.querySelector(".sidebar")
    const mainContent = document.querySelector(".main-content")

    if (sidebarToggle) {
        sidebarToggle.addEventListener("click", () => {
            sidebar.classList.toggle("active")

            if (sidebar.classList.contains("active")) {
                mainContent.style.marginLeft = "260px"
            } else {
                mainContent.style.marginLeft = "0"
            }
        })
    }

    // Close sidebar when clicking outside on mobile
    document.addEventListener("click", (event) => {
        const isClickInsideSidebar = sidebar.contains(event.target)
        const isClickOnToggle = sidebarToggle.contains(event.target)

        if (!isClickInsideSidebar && !isClickOnToggle && window.innerWidth <= 768 && sidebar.classList.contains("active")) {
            sidebar.classList.remove("active")
            mainContent.style.marginLeft = "0"
        }
    })

    // Tab Switching
    const tabButtons = document.querySelectorAll(".tab-btn")
    const tabContents = document.querySelectorAll(".tab-content")

    tabButtons.forEach((button) => {
        button.addEventListener("click", () => {
            // Remove active class from all buttons and contents
            tabButtons.forEach((btn) => btn.classList.remove("active"))
            tabContents.forEach((content) => content.classList.remove("active"))

            // Add active class to clicked button
            button.classList.add("active")

            // Show corresponding content
            const tabId = button.getAttribute("data-tab")
            document.getElementById(`${tabId}-tab`).classList.add("active")
        })
    })

    // Performance Chart
    const performanceChart = document.getElementById("performance-chart")

    if (performanceChart) {
        const ctx = performanceChart.getContext("2d")

        // Sample data - replace with actual data from backend
        const chartData = {
            labels: ["Apr 1", "Apr 5", "Apr 10", "Apr 15", "Apr 20", "Apr 25", "May 1", "May 5", "May 10"],
            datasets: [
                {
                    label: "Article Views",
                    data: [1200, 1900, 3000, 5000, 4000, 6000, 7000, 6500, 8000],
                    borderColor: "#4267b2",
                    backgroundColor: "rgba(66, 103, 178, 0.1)",
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true,
                },
                {
                    label: "Engagement",
                    data: [200, 400, 600, 800, 1000, 1200, 1400, 1300, 1600],
                    borderColor: "#34a853",
                    backgroundColor: "rgba(52, 168, 83, 0.1)",
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true,
                },
            ],
        }

        new Chart(ctx, {
            type: "line",
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: "top",
                    },
                    tooltip: {
                        mode: "index",
                        intersect: false,
                    },
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: "rgba(0, 0, 0, 0.05)",
                        },
                    },
                    x: {
                        grid: {
                            display: false,
                        },
                    },
                },
                interaction: {
                    mode: "nearest",
                    axis: "x",
                    intersect: false,
                },
            },
        })
    }

    // Chart Timeframe Selector
    const timeframeSelector = document.getElementById("chart-timeframe")

    if (timeframeSelector) {
        timeframeSelector.addEventListener("change", function () {
            // In a real application, this would fetch new data based on the selected timeframe
            console.log("Selected timeframe:", this.value)
            // Then update the chart with new data
        })
    }

    // Dropdown Menus
    const dropdownToggles = document.querySelectorAll(".notification-btn, .profile-btn")

    dropdownToggles.forEach((toggle) => {
        toggle.addEventListener("click", function (e) {
            e.stopPropagation()
            const dropdown = this.nextElementSibling

            // Close all other dropdowns
            document.querySelectorAll(".notification-dropdown, .profile-dropdown").forEach((menu) => {
                if (menu !== dropdown) {
                    menu.style.display = "none"
                }
            })

            // Toggle current dropdown
            dropdown.style.display = dropdown.style.display === "block" ? "none" : "block"
        })
    })

    // Close dropdowns when clicking outside
    document.addEventListener("click", () => {
        document.querySelectorAll(".notification-dropdown, .profile-dropdown").forEach((dropdown) => {
            dropdown.style.display = "none"
        })
    })

    // Prevent dropdown from closing when clicking inside it
    document.querySelectorAll(".notification-dropdown, .profile-dropdown").forEach((dropdown) => {
        dropdown.addEventListener("click", (e) => {
            e.stopPropagation()
        })
    })

    // Calendar Navigation
    const calendarPrev = document.querySelector(".calendar-nav.prev")
    const calendarNext = document.querySelector(".calendar-nav.next")
    const calendarTitle = document.querySelector(".calendar-header h3")

    if (calendarPrev && calendarNext && calendarTitle) {
        const months = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December",
        ]
        const currentDate = new Date()

        // Update calendar title
        function updateCalendarTitle() {
            calendarTitle.textContent = `${months[currentDate.getMonth()]} ${currentDate.getFullYear()}`
        }

        calendarPrev.addEventListener("click", () => {
            currentDate.setMonth(currentDate.getMonth() - 1)
            updateCalendarTitle()
            // In a real app, this would fetch events for the new month
        })

        calendarNext.addEventListener("click", () => {
            currentDate.setMonth(currentDate.getMonth() + 1)
            updateCalendarTitle()
            // In a real app, this would fetch events for the new month
        })
    }

    // Responsive adjustments
    function handleResize() {
        if (window.innerWidth > 768) {
            sidebar.classList.remove("active")
            mainContent.style.marginLeft = "260px"
        } else {
            mainContent.style.marginLeft = "0"
        }
    }

    window.addEventListener("resize", handleResize)

    // Initialize responsive state
    handleResize()
})
