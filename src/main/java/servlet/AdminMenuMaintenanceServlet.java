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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminMenuMaintenanceServlet", urlPatterns = {"/admin/menu/maintenance"})
public class AdminMenuMaintenanceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        MenuDAO dao = new MenuDAO();
        String section = req.getParameter("section");
        if (section == null || section.isEmpty()) section = "course"; // default
        try {
            req.setAttribute("categories", dao.getCategories());
            if ("course".equals(section)) {
                req.setAttribute("courses", dao.getAllCourses());
            } else if ("category".equals(section)) {
                String catParam = req.getParameter("categoryId");
                Integer catId = null;
                if (catParam != null && !catParam.isEmpty()) {
                    try { catId = Integer.parseInt(catParam); } catch (NumberFormatException ignored) {}
                }
                req.setAttribute("selectedCategoryId", catId);
                if (catId != null) {
                    req.setAttribute("dishes", dao.getAllDishesByCategory(catId));
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.setAttribute("section", section);
        req.getRequestDispatcher("/jsp/menuMaintenance.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type"); // category|dish|course
        String action = req.getParameter("action"); // add|update|delete
        MenuDAO dao = new MenuDAO();
        // If delete requested, redirect to confirmation page first
        if ("delete".equals(action)) {
            String id = req.getParameter("id");
            String redirect = req.getContextPath() + "/admin/menu/maintenance/delete?type=" + type + "&id=" + id;
            resp.sendRedirect(redirect);
            return;
        }
        try {
            if ("category".equals(type)) {
                if ("add".equals(action)) {
                    String name = req.getParameter("name");
                    if (name != null && !name.isEmpty()) dao.insertCategory(name);
                } else if ("update".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    String name = req.getParameter("name");
                    dao.updateCategory(id, name);
                }
            } else if ("dish".equals(type)) {
                if ("add".equals(action)) {
                    Dish d = new Dish();
                    d.setName(req.getParameter("name"));
                    d.setDescription(req.getParameter("description"));
                    d.setPrice(Integer.parseInt(req.getParameter("price")));
                    d.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                    d.setActive("on".equals(req.getParameter("active")));
                    dao.insertDish(d);
                } else if ("update".equals(action)) {
                    Dish d = new Dish();
                    d.setId(Integer.parseInt(req.getParameter("id")));
                    d.setName(req.getParameter("name"));
                    d.setDescription(req.getParameter("description"));
                    d.setPrice(Integer.parseInt(req.getParameter("price")));
                    d.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                    d.setActive("on".equals(req.getParameter("active")));
                    dao.updateDish(d);
                }
            } else if ("course".equals(type)) {
                if ("add".equals(action)) {
                    Course c = new Course();
                    c.setName(req.getParameter("name"));
                    c.setDescription(req.getParameter("description"));
                    c.setPrice(Integer.parseInt(req.getParameter("price")));
                    c.setActive("on".equals(req.getParameter("active")));
                    dao.insertCourse(c);
                } else if ("update".equals(action)) {
                    Course c = new Course();
                    c.setId(Integer.parseInt(req.getParameter("id")));
                    c.setName(req.getParameter("name"));
                    c.setDescription(req.getParameter("description"));
                    c.setPrice(Integer.parseInt(req.getParameter("price")));
                    c.setActive("on".equals(req.getParameter("active")));
                    dao.updateCourse(c);
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        // Redirect back to relevant section
        String redirect = req.getContextPath() + "/admin/menu/maintenance";
        if ("course".equals(type)) {
            redirect += "?section=course";
        } else if ("category".equals(type) || "dish".equals(type)) {
            String catId = req.getParameter("categoryId");
            if (catId != null && !catId.isEmpty()) {
                redirect += "?section=category&categoryId=" + catId;
            } else {
                redirect += "?section=category";
            }
        }
        resp.sendRedirect(redirect);
    }
}
