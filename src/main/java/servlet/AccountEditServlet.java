package servlet;

import beans.Customer;
import dao.CustomerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AccountEditServlet", urlPatterns = {"/account/edit"})
public class AccountEditServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        CustomerDAO dao = new CustomerDAO();
        try {
            Customer c = dao.findById(customerId);
            req.setAttribute("customer", c);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/jsp/account_edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String name = req.getParameter("name");
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String passwordConfirm = req.getParameter("passwordConfirm");

        String error = null;
        if (name == null || name.trim().isEmpty()) error = "お名前を入力してください";
        if (email == null || email.trim().isEmpty()) error = (error == null ? "e-mail を入力してください" : error + " / e-mail を入力してください");
        boolean changePassword = false;
        if ((password != null && !password.isEmpty()) || (passwordConfirm != null && !passwordConfirm.isEmpty())) {
            if (password == null || passwordConfirm == null || !password.equals(passwordConfirm)) {
                error = (error == null ? "パスワードが一致しません" : error + " / パスワードが一致しません");
            } else {
                changePassword = true;
            }
        }

        CustomerDAO dao = new CustomerDAO();
        try {
            Customer c = dao.findById(customerId);
            if (c == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (error == null) {
                c.setName(name);
                c.setAddress(address);
                c.setPhone(phone);
                c.setEmail(email);
                dao.updateProfileWithEmail(c);
                if (changePassword) {
                    dao.updatePassword(customerId, password);
                }
                req.setAttribute("success", "更新しました");
            } else {
                req.setAttribute("error", error);
            }
            req.setAttribute("customer", dao.findById(customerId));
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/jsp/account_edit.jsp").forward(req, resp);
    }
}

