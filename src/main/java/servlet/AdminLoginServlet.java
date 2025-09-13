package servlet;

import beans.Admin;
import dao.AdminDAO;
import utils.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin/login"})
public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/admin_login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        AdminDAO dao = new AdminDAO();
        try {
            Admin a = dao.findByUsername(username);
            if (a != null && PasswordUtil.verify(a.getSalt(), a.getPasswordHash(), password)) {
                HttpSession session = req.getSession(true);
                session.setAttribute("adminId", a.getId());
                resp.sendRedirect(req.getContextPath() + "/admin/menu");
                return;
            }
            req.setAttribute("errorKey", "INVALID_ADMIN_LOGIN");
            req.getRequestDispatcher("/jsp/admin_login.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

