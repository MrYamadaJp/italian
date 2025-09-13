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

@WebServlet(name = "AdminMenuInsertServlet", urlPatterns = {"/admin/menu/maintenance/insert"})
public class AdminMenuInsertServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type"); // dish|course
        req.setAttribute("type", type);
        if ("dish".equals(type)) {
            try {
                req.setAttribute("categories", new MenuDAO().getCategories());
            } catch (SQLException e) { throw new ServletException(e); }
            String cat = req.getParameter("categoryId");
            if (cat != null && !cat.isEmpty()) req.setAttribute("categoryId", Integer.parseInt(cat));
            req.getRequestDispatcher("/jsp/menuInsert.jsp").forward(req, resp);
            return;
        } else if ("course".equals(type)) {
            MenuDAO dao = new MenuDAO();
            try {
                req.setAttribute("categories", dao.getCategories());
                req.setAttribute("allDishes", dao.getAllDishes());
            } catch (SQLException e) { throw new ServletException(e); }
            req.getRequestDispatcher("/jsp/courseInsert.jsp").forward(req, resp);
            return;
        }
        req.getRequestDispatcher("/jsp/menuInsert.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        MenuDAO dao = new MenuDAO();
        try {
            if ("dish".equals(type)) {
                Dish d = new Dish();
                d.setName(req.getParameter("name"));
                d.setDescription(req.getParameter("description"));
                d.setPrice(Integer.parseInt(req.getParameter("price")));
                d.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                d.setActive("on".equals(req.getParameter("active")));
                int id = dao.insertDish(d);
                resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance?section=category&categoryId=" + d.getCategoryId());
                return;
            } else if ("course".equals(type)) {
                Course c = new Course();
                c.setName(req.getParameter("name"));
                c.setDescription(req.getParameter("description"));
                c.setPrice(Integer.parseInt(req.getParameter("price")));
                String orderable = req.getParameter("orderable");
                c.setActive("1".equals(orderable));
                int id = dao.insertCourse(c);
                String[] dishIds = req.getParameterValues("dishIds");
                if (dishIds != null && id > 0) {
                    java.util.List<Integer> ids = new java.util.ArrayList<>();
                    for (String s : dishIds) ids.add(Integer.parseInt(s));
                    dao.replaceCourseDishes(id, ids);
                }
                resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance?section=course");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/menu/maintenance");
    }
}
