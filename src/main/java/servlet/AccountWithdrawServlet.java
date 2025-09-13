package servlet;

import beans.Customer;
import dao.CustomerDAO;
import utils.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AccountWithdrawServlet", urlPatterns = {"/account/withdraw"})
public class AccountWithdrawServlet extends HttpServlet {
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
        req.getRequestDispatcher("/jsp/account_withdraw.jsp").forward(req, resp);
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

        String p1 = req.getParameter("password");
        String p2 = req.getParameter("passwordConfirm");

        String error = null;
        if (p1 == null || p2 == null || p1.isEmpty() || p2.isEmpty()) {
            error = "パスワードを2回入力してください";
        } else if (!p1.equals(p2)) {
            error = "パスワードが一致しません";
        }

        CustomerDAO dao = new CustomerDAO();
        try {
            Customer c = dao.findById(customerId);
            if (c == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (error == null) {
                boolean ok = PasswordUtil.verify(c.getSalt(), c.getPasswordHash(), p1);
                if (!ok) {
                    error = "パスワードが正しくありません";
                }
            }

            if (error == null) {
                dao.delete(customerId);
                if (session != null) session.invalidate();
                req.setAttribute("deleted", true);
                // 顧客情報はもう無いので表示しない
            } else {
                req.setAttribute("error", error);
                req.setAttribute("customer", c);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/jsp/account_withdraw.jsp").forward(req, resp);
    }
}

