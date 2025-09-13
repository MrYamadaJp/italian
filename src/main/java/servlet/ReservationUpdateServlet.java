package servlet;

import beans.Course;
import beans.Reservation;
import dao.MenuDAO;
import dao.ReservationDAO;

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
import java.util.List;

@WebServlet(name = "ReservationUpdateServlet", urlPatterns = {"/reservations/update"})
public class ReservationUpdateServlet extends HttpServlet {
    private static final SimpleDateFormat DATE_FMT = new SimpleDateFormat("yyyy-MM-dd HH:mm");

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

            List<Course> courses = new MenuDAO().getActiveCourses();
            req.setAttribute("reservation", r);
            req.setAttribute("courses", courses);
            req.getRequestDispatcher("/jsp/reserveUpdate.jsp").forward(req, resp);
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
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String partyStr = req.getParameter("partySize");
        String courseStr = req.getParameter("courseId");
        try {
            int id = Integer.parseInt(idStr);
            int party = Integer.parseInt(partyStr);
            int courseId = Integer.parseInt(courseStr);
            Date start = DATE_FMT.parse(date + " " + time);

            Calendar startCal = Calendar.getInstance();
            startCal.setTime(start);
            int minute = startCal.get(Calendar.MINUTE);
            if (minute % 15 != 0) { // 既存のバリデーションに合わせる
                req.setAttribute("updateError", "開始時刻は15分刻みで入力してください");
                reloadForm(req, resp, id);
                return;
            }
            int hour = startCal.get(Calendar.HOUR_OF_DAY);
            if (hour < 17 || hour > 21 || (hour == 21 && minute > 0)) {
                req.setAttribute("updateError", "開始時刻は17:00〜21:00の間で選択してください");
                reloadForm(req, resp, id);
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
                req.setAttribute("updateError", "終了が24:00を超えるため予約できません");
                reloadForm(req, resp, id);
                return;
            }

            Calendar now = Calendar.getInstance();
            Calendar max = Calendar.getInstance();
            max.add(Calendar.YEAR, 1);
            if (start.before(now.getTime()) || start.after(max.getTime())) {
                req.setAttribute("updateError", "予約可能期間外です（現在は1年以内のみ）");
                reloadForm(req, resp, id);
                return;
            }

            Date end = endCal.getTime();

            ReservationDAO rdao = new ReservationDAO();
            Reservation current = rdao.findById(id);
            if (current == null || current.getCustomerId() != customerId) { resp.sendRedirect(req.getContextPath() + "/reservations"); return; }

            Integer tableId = rdao.findAvailableTableIdForUpdate(start, end, party, id);
            if (tableId == null) {
                req.setAttribute("updateError", "満席のため予約できません");
                reloadForm(req, resp, id);
                return;
            }

            current.setTableId(tableId);
            current.setCourseId(courseId);
            current.setPartySize(party);
            current.setStartTime(start);
            current.setEndTime(end);
            rdao.updateReservation(current);

            resp.sendRedirect(req.getContextPath() + "/reservations");
        } catch (NumberFormatException | ParseException e) {
            req.setAttribute("updateError", "入力値が不正です");
            try { reloadForm(req, resp, Integer.parseInt(req.getParameter("id"))); } catch (NumberFormatException ex) { resp.sendRedirect(req.getContextPath() + "/reservations"); }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void reloadForm(HttpServletRequest req, HttpServletResponse resp, int id) throws ServletException, IOException {
        try {
            Reservation r = new ReservationDAO().findById(id);
            List<Course> courses = new MenuDAO().getActiveCourses();
            req.setAttribute("reservation", r);
            req.setAttribute("courses", courses);
            req.getRequestDispatcher("/jsp/reserveUpdate.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

