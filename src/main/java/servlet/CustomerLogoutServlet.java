package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CustomerLogoutServlet", urlPatterns = {"/logout"})
public class CustomerLogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer customerId = null;
        if (session != null) {
            Object id = session.getAttribute("customerId");
            if (id instanceof Integer) customerId = (Integer) id;
            session.invalidate();
        }
        // Clear remember-me cookie and tokens
        try {
            if (customerId != null) {
                new dao.RememberTokenDAO().deleteByCustomer(customerId);
            }
        } catch (Exception ignored) {}
        utils.TokenUtil.clearCookie(req, resp, "remember_customer");
        // After logout, go to home (home.jsp via HomeServlet)
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}


