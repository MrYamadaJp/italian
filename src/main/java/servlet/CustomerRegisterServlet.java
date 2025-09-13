package servlet;

import beans.Customer;
import dao.CustomerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "CustomerRegisterServlet", urlPatterns = {"/register"})
public class CustomerRegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (name == null || email == null || password == null || name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            req.setAttribute("errorKey", "REQUIRED_MISSING");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        try {
            if (dao.findByEmail(email) != null) {
                req.setAttribute("errorKey", "EMAIL_EXISTS");
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
                return;
            }
            Customer c = new Customer();
            c.setName(name);
            c.setAddress(address);
            c.setPhone(phone);
            c.setEmail(email);
            int id = dao.create(c, password);
            HttpSession session = req.getSession(true);
            session.setAttribute("customerId", id);
            resp.sendRedirect(req.getContextPath() + "/reservations");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

