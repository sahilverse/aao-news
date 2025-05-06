package com.aaonews.utils;

import com.aaonews.enums.Role;
import com.aaonews.models.Publisher;
import com.aaonews.models.User;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * Utility class for session and cookie management
 */
public class SessionUtil {

    private static final String USER_SESSION_KEY = "currentUser";
    private static final String PUBLISHER_SESSION_KEY = "currentPublisher";
    private static final String REMEMBER_ME_COOKIE = "aaonews_sess";
    private static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 7; // 7 days

    /**
     * Creates a session for a user
     *
     * @param request The HTTP request
     * @param user The user to create a session for
     */
    public static void createUserSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute(USER_SESSION_KEY, user);
    }

    /**
     * Creates a session for a publisher
     *
     * @param request The HTTP request
     * @param user The user to create a session for
     */

    public static void createPublisherSession(HttpServletRequest request, User user, Publisher publisher) {
        if(user.getId() == publisher.getPublisherId()) {
            HttpSession session = request.getSession(true);
            session.setAttribute(PUBLISHER_SESSION_KEY, publisher);
        }
    }


    /**
     * Gets the current user from the session
     *
     * @param request The HTTP request
     * @return The current user, or null if not logged in
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute(USER_SESSION_KEY);
        }
        return null;
    }

    /**
     * Invalidates the current session
     *
     * @param request The HTTP request
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    /**
     * Creates a "Remember Me" cookie
     *
     * @param response The HTTP response
     * @param userId The user ID to remember
     */
    public static void createRememberMeCookie(HttpServletResponse response, int userId) {
        String tokenValue = JWTUtil.generateToken(userId);
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, tokenValue);
        cookie.setMaxAge(COOKIE_MAX_AGE);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }

    /**
     * Gets the user ID from the "Remember Me" cookie
     *
     * @param request The HTTP request
     * @return The user ID, or -1 if not found
     */
    public static int getUserIdFromRememberMeCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_ME_COOKIE.equals(cookie.getName())) {
                    String token = cookie.getValue();
                    String userIdStr = JWTUtil.validateToken(token);
                    if (userIdStr != null) {
                        try {
                            return Integer.parseInt(userIdStr);
                        } catch (NumberFormatException e) {
                            System.err.println("Failed to parse user ID from token: " + e.getMessage());
                            return -1;
                        }
                    }
                }
            }
        }
        return -1;
    }

    /**
     * Clears the "Remember Me" cookie
     *
     * @param response The HTTP response
     */
    public static void clearRememberMeCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    /**
     * Sets a flash message in the session
     *
     * @param request The HTTP request
     * @param type The message type (success, error, info, warning)
     * @param message The message content
     */
    public static void setFlashMessage(HttpServletRequest request, String type, String message) {
        HttpSession session = request.getSession(true);
        session.setAttribute("flash_type", type);
        session.setAttribute("flash_message", message);
    }

    /**
     * Gets and clears the flash message from the session
     *
     * @param request The HTTP request
     * @return An array with [type, message], or null if no message
     */
    public static String[] getAndClearFlashMessage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String type = (String) session.getAttribute("flash_type");
            String message = (String) session.getAttribute("flash_message");

            if (type != null && message != null) {
                session.removeAttribute("flash_type");
                session.removeAttribute("flash_message");
                return new String[] { type, message };
            }
        }
        return null;
    }
}
