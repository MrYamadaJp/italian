package servlet;

import dao.MenuDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ReservationFormServlet", urlPatterns = {"/reservations/form"})
public class ReservationFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        MenuDAO menu = new MenuDAO();
        try {
            req.setAttribute("courses", menu.getActiveCourses());
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/jsp/reserveInsert.jsp").forward(req, resp);
    }
}


