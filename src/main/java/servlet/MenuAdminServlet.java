package servlet;

// no DAO needed for admin index

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
// no SQL here

@WebServlet(name = "MenuAdminServlet", urlPatterns = {"/admin/menu"})
public class MenuAdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/adminIndex.jsp").forward(req, resp);
    }
}


