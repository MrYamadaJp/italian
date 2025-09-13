package servlet;

import beans.Course;
import beans.Category;
import beans.Dish;
import dao.MenuDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminCourseContentServlet", urlPatterns = {"/admin/menu/maintenance/course"})
public class AdminCourseContentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        MenuDAO dao = new MenuDAO();
        try {
            Course course = dao.getCourseById(id);
            req.setAttribute("course", course);
            req.setAttribute("categories", dao.getCategories());
            req.setAttribute("allDishes", dao.getAllDishes());
            req.setAttribute("selectedDishIds", dao.getDishIdsForCourse(id));
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/jsp/courseContent.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String[] dishIds = req.getParameterValues("dishIds");
        List<Integer> ids = new ArrayList<>();
        if (dishIds != null) {
            for (String s : dishIds) ids.add(Integer.parseInt(s));
        }
        MenuDAO dao = new MenuDAO();
        try {
            dao.replaceCourseDishes(id, ids);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance");
    }
}

