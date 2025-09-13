package servlet;

import dao.TableDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "AdminSeatStatusServlet", urlPatterns = {"/admin/seats"})
public class AdminSeatStatusServlet extends HttpServlet {
    private static final SimpleDateFormat DATE_FMT = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat TIME_FMT = new SimpleDateFormat("HH:mm");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        Date at = null;
        if (date != null && time != null && !date.isEmpty() && !time.isEmpty()) {
            try {
                Date d = DATE_FMT.parse(date);
                Date t = TIME_FMT.parse(time);
                Calendar cal = Calendar.getInstance();
                cal.setTime(d);
                Calendar tt = Calendar.getInstance();
                tt.setTime(t);
                cal.set(Calendar.HOUR_OF_DAY, tt.get(Calendar.HOUR_OF_DAY));
                cal.set(Calendar.MINUTE, tt.get(Calendar.MINUTE));
                cal.set(Calendar.SECOND, 0);
                cal.set(Calendar.MILLISECOND, 0);
                at = cal.getTime();
            } catch (ParseException ignored) {}
        }
        if (at != null) {
            try {
                TableDAO dao = new TableDAO();
                req.setAttribute("statuses", dao.findStatusAt(at));
                req.setAttribute("at", at);
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        }
        req.getRequestDispatcher("/jsp/seats.jsp").forward(req, resp);
    }
}

