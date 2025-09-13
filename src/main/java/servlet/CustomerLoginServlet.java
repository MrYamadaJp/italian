package servlet;

import beans.Customer;
import dao.CustomerDAO;
import utils.PasswordUtil;
import utils.TokenUtil;
import dao.RememberTokenDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "CustomerLoginServlet", urlPatterns = {"/login"})
public class CustomerLoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        boolean remember = "on".equals(req.getParameter("remember"));
        CustomerDAO dao = new CustomerDAO();
        try {
            Customer c = dao.findByEmail(email);
            if (c != null && PasswordUtil.verify(c.getSalt(), c.getPasswordHash(), password)) {
                HttpSession session = req.getSession(true);
                session.setAttribute("customerId", c.getId());
                if (remember) {
                    try {
                        RememberTokenDAO tokenDAO = new RememberTokenDAO();
                        byte[] selector = TokenUtil.randomBytes(16);
                        byte[] validator = TokenUtil.randomBytes(32);
                        byte[] validatorHash = TokenUtil.sha256(validator);
                        java.time.Instant exp = java.time.Instant.now().plus(java.time.Period.ofDays(30));
                        tokenDAO.create(c.getId(), selector, validatorHash, exp);
                        String cookieVal = TokenUtil.toHex(selector) + ":" + TokenUtil.toHex(validator);
                        TokenUtil.setCookie(req, resp, "remember_customer", cookieVal, 30 * 24 * 60 * 60);
                    } catch (Exception e) {
                        // ignore remember-me failures
                    }
                }
                // ログイン後はユーザーメニューへ
                resp.sendRedirect(req.getContextPath() + "/jsp/userIndex.jsp");
                return;
            }
            req.setAttribute("errorKey", "INVALID_LOGIN");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
