package servlet;

import dao.MenuDAO;
import beans.Category;
import beans.Dish;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "MenuPublicServlet", urlPatterns = {"/menu"})
public class MenuPublicServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        MenuDAO menu = new MenuDAO();
        try {
            List<Category> categories = menu.getCategories();
            req.setAttribute("categories", categories);

            Map<Integer, List<Dish>> dishesByCategory = new LinkedHashMap<>();
            for (Category c : categories) {
                dishesByCategory.put(c.getId(), menu.getDishesByCategory(c.getId()));
            }
            req.setAttribute("dishesByCategory", dishesByCategory);

            req.setAttribute("courses", menu.getActiveCourses());
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/jsp/menu.jsp").forward(req, resp);
    }
}

