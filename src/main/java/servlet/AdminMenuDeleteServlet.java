package servlet;

import beans.Dish;
import beans.Course;
import dao.MenuDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AdminMenuDeleteServlet", urlPatterns = {"/admin/menu/maintenance/delete"})
public class AdminMenuDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type"); // dish | course | category
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("type", type);
        MenuDAO dao = new MenuDAO();
        try {
            if ("dish".equals(type)) {
                Dish d = dao.getDishById(id);
                req.setAttribute("dish", d);
            } else if ("course".equals(type)) {
                Course c = dao.getCourseById(id);
                req.setAttribute("course", c);
                // also show current course contents
                req.setAttribute("selectedDishIds", dao.getDishIdsForCourse(id));
                req.setAttribute("allDishes", dao.getAllDishes());
            } else if ("category".equals(type)) {
                // Category confirmation: show id and name
                req.setAttribute("categoryId", id);
                req.setAttribute("category", dao.getCategoryById(id));
            }
        } catch (SQLException e) { throw new ServletException(e); }
        if ("course".equals(type)) {
            req.getRequestDispatcher("/jsp/courseDelete.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/jsp/menuDelete.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        int id = Integer.parseInt(req.getParameter("id"));
        MenuDAO dao = new MenuDAO();
        try {
            if ("dish".equals(type)) {
                // Need categoryId to redirect
                Dish d = dao.getDishById(id);
                if (d != null) {
                    dao.deleteDish(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance?section=category&categoryId=" + d.getCategoryId());
                    return;
                }
            } else if ("course".equals(type)) {
                dao.deleteCourse(id);
                resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance?section=course");
                return;
            } else if ("category".equals(type)) {
                try {
                    dao.deleteCategory(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance?section=category");
                    return;
                } catch (java.sql.SQLIntegrityConstraintViolationException fk) {
                    // Friendly message when dishes remain
                    req.setAttribute("type", "category");
                    req.setAttribute("categoryId", id);
                    try { req.setAttribute("category", new MenuDAO().getCategoryById(id)); } catch (SQLException ignore) {}
                    req.setAttribute("error", "このカテゴリには料理が残っているため削除できません。");
                    req.getRequestDispatcher("/jsp/menuDelete.jsp").forward(req, resp);
                    return;
                }
            }
        } catch (SQLException e) { throw new ServletException(e); }
        resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance");
    }
}

