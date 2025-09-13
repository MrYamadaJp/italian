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

@WebServlet(name = "ReservationListServlet", urlPatterns = {"/reservations"})
public class ReservationListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        ReservationDAO dao = new ReservationDAO();
        try {
            req.setAttribute("reservations", dao.listByCustomer(customerId));
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/jsp/reserveList.jsp").forward(req, resp);
    }
}
