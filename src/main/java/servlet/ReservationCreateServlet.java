package servlet;

import beans.Reservation;
import beans.Customer;
import beans.Course;
import dao.ReservationDAO;
import dao.CustomerDAO;
import dao.MenuDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@WebServlet(name = "ReservationCreateServlet", urlPatterns = {"/reservations/create"})
public class ReservationCreateServlet extends HttpServlet {
    private static final SimpleDateFormat DATE_FMT = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customerId") : null;
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String partyStr = req.getParameter("partySize");
        String courseStr = req.getParameter("courseId");

        try {
            int party = Integer.parseInt(partyStr);
            int courseId = Integer.parseInt(courseStr);
            Date start = DATE_FMT.parse(date + " " + time);

            Calendar startCal = Calendar.getInstance();
            startCal.setTime(start);
            int minute = startCal.get(Calendar.MINUTE);
            if (minute % 15 != 0) {
                req.setAttribute("errorKey", "INVALID_TIME_INCREMENT");
                req.getRequestDispatcher("/jsp/reserveCompletion.jsp").forward(req, resp);
                return;
            }
            int hour = startCal.get(Calendar.HOUR_OF_DAY);
            if (hour < 17 || hour > 21 || (hour == 21 && minute > 0)) {
                req.setAttribute("errorKey", "TIME_OUT_OF_RANGE");
                req.getRequestDispatcher("/jsp/reserveCompletion.jsp").forward(req, resp);
                return;
            }

            Calendar endCal = (Calendar) startCal.clone();
            endCal.add(Calendar.HOUR_OF_DAY, 2);
            endCal.add(Calendar.MINUTE, 59);
            Calendar dayEnd = (Calendar) startCal.clone();
            dayEnd.set(Calendar.HOUR_OF_DAY, 23);
            dayEnd.set(Calendar.MINUTE, 59);
            dayEnd.set(Calendar.SECOND, 59);
            if (endCal.after(dayEnd)) {
                req.setAttribute("errorKey", "END_AFTER_MIDNIGHT");
                req.getRequestDispatcher("/jsp/reserveCompletion.jsp").forward(req, resp);
                return;
            }

            Calendar now = Calendar.getInstance();
            Calendar max = Calendar.getInstance();
            max.add(Calendar.YEAR, 1);
            if (start.before(now.getTime()) || start.after(max.getTime())) {
                req.setAttribute("errorKey", "OUT_OF_BOOKING_WINDOW");
                req.getRequestDispatcher("/jsp/reserveCompletion.jsp").forward(req, resp);
                return;
            }

            Date end = endCal.getTime();

            ReservationDAO dao = new ReservationDAO();
            Integer tableId = dao.findAvailableTableId(start, end, party);
            if (tableId == null) {
                req.setAttribute("errorKey", "FULLY_BOOKED");
                req.getRequestDispatcher("/jsp/reserveCompletion.jsp").forward(req, resp);
                return;
            }

            Reservation r = new Reservation();
            r.setCustomerId(customerId);
            r.setTableId(tableId);
            r.setCourseId(courseId);
            r.setPartySize(party);
            r.setStartTime(start);
            r.setEndTime(end);
            int id = dao.createReservation(r);

            // 表示用の名前・コース名を取得
            Customer customer = new CustomerDAO().findById(customerId);
            Course course = new MenuDAO().getCourseById(courseId);

            req.setAttribute("reservationId", id);
            req.setAttribute("reservation", r);
            if (customer != null) req.setAttribute("customerName", customer.getName());
            if (course != null) req.setAttribute("courseName", course.getName());
            req.getRequestDispatcher("/jsp/reserveCompletion.jsp").forward(req, resp);
        } catch (NumberFormatException | ParseException e) {
            req.setAttribute("errorKey", "INVALID_INPUT");
            req.getRequestDispatcher("/jsp/reserveCompletion.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
