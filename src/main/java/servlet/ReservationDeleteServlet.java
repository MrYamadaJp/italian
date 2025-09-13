package servlet;

import beans.Reservation;
import beans.Course;
import dao.ReservationDAO;
import dao.MenuDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ReservationDeleteServlet", urlPatterns = {"/reservations/delete"})
public class ReservationDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;
        if (customerId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String idStr = req.getParameter("id");
        if (idStr == null) { resp.sendRedirect(req.getContextPath() + "/reservations"); return; }
        try {
            int id = Integer.parseInt(idStr);
            ReservationDAO rdao = new ReservationDAO();
            Reservation r = rdao.findById(id);
            if (r == null || r.getCustomerId() != customerId) { resp.sendRedirect(req.getContextPath() + "/reservations"); return; }
            Course course = new MenuDAO().getCourseById(r.getCourseId());
            req.setAttribute("reservation", r);
            req.setAttribute("courseName", course != null ? course.getName() : null);
            req.getRequestDispatcher("/jsp/reserveDelete.jsp").forward(req, resp);
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;
        if (customerId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String idStr = req.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            new ReservationDAO().cancel(id, customerId);
            resp.sendRedirect(req.getContextPath() + "/reservations");
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException(e);
        }
    }
}

