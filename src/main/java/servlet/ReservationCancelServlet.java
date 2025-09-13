package servlet;

import dao.ReservationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ReservationCancelServlet", urlPatterns = {"/reservations/cancel"})
public class ReservationCancelServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            new ReservationDAO().cancel(id, customerId);
            resp.sendRedirect(req.getContextPath() + "/reservations");
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException(e);
        }
    }
}


