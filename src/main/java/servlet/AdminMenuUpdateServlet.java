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

@WebServlet(name = "AdminMenuUpdateServlet", urlPatterns = {"/admin/menu/maintenance/update"})
public class AdminMenuUpdateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type"); // dish|course
        int id = Integer.parseInt(req.getParameter("id"));
        MenuDAO dao = new MenuDAO();
        req.setAttribute("type", type);
        try {
            if ("dish".equals(type)) {
                req.setAttribute("dish", dao.getDishById(id));
                req.setAttribute("categories", dao.getCategories());
                req.getRequestDispatcher("/jsp/menuUpdate.jsp").forward(req, resp);
                return;
            } else if ("course".equals(type)) {
                req.setAttribute("course", dao.getCourseById(id));
                req.setAttribute("categories", dao.getCategories());
                req.setAttribute("allDishes", dao.getAllDishes());
                req.setAttribute("selectedDishIds", dao.getDishIdsForCourse(id));
                req.getRequestDispatcher("/jsp/courseUpdate.jsp").forward(req, resp);
                return;
            }
        } catch (SQLException e) { throw new ServletException(e); }
        req.getRequestDispatcher("/jsp/menuUpdate.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        MenuDAO dao = new MenuDAO();
        try {
            if ("dish".equals(type)) {
                Dish d = new Dish();
                d.setId(Integer.parseInt(req.getParameter("id")));
                d.setName(req.getParameter("name"));
                d.setDescription(req.getParameter("description"));
                d.setPrice(Integer.parseInt(req.getParameter("price")));
                d.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                d.setActive("on".equals(req.getParameter("active")));
                dao.updateDish(d);
                resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance?section=category&categoryId=" + d.getCategoryId());
                return;
            } else if ("course".equals(type)) {
                Course c = new Course();
                c.setId(Integer.parseInt(req.getParameter("id")));
                c.setName(req.getParameter("name"));
                c.setDescription(req.getParameter("description"));
                c.setPrice(Integer.parseInt(req.getParameter("price")));
                String orderable = req.getParameter("orderable");
                c.setActive("1".equals(orderable));
                dao.updateCourse(c);
                String[] dishIds = req.getParameterValues("dishIds");
                java.util.List<Integer> ids = new java.util.ArrayList<>();
                if (dishIds != null) {
                    for (String s : dishIds) { if (s != null && !s.isEmpty()) ids.add(Integer.parseInt(s)); }
                }
                dao.replaceCourseDishes(c.getId(), ids);
                resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance?section=course");
                return;
            }
        } catch (SQLException e) { throw new ServletException(e); }
        resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance");
    }
}
