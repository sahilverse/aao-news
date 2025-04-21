package com.aaonews.controllers;


import com.aaonews.dao.UserDAO;
import com.aaonews.models.User;
import com.aaonews.utils.PasswordUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;


import java.io.IOException;



@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
        dispatcher.forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String check = request.getParameter("checkbox");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);
        if (user == null) {
            request.setAttribute("error","Email does not exist");
            response.sendRedirect("/login");
            return;
        }
        String hashedPassword = user.getPassword();
        boolean passwordMatch = PasswordUtil.comparePassword(password, hashedPassword);

        if (passwordMatch) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if (check!=null){
                Cookie emailCookie = new Cookie("email", email);
                Cookie passwordCookie = new Cookie("password", password);

                emailCookie.setMaxAge(60*60*24*7);
                passwordCookie.setMaxAge(60*60*24*7);

                response.addCookie(emailCookie);
                response.addCookie(passwordCookie);




            }
            response.sendRedirect("/WEB-INF/views/home.jsp");




        }
        else{
            request.setAttribute("error","Password does not match");
            response.sendRedirect(request.getContextPath()+ "/login");
        }

        System.out.println("email: " + email + ", password: " + password+ ", check: " + check);
    }
}
