package filters;

import dao.RememberTokenDAO;
import utils.TokenUtil;

import javax.servlet.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

// Declared in web.xml to control order
public class RememberMeFilter implements Filter {
    private static final String COOKIE_NAME = "remember_customer";
    private static final int MAX_AGE_DAYS = 30;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        boolean hasCustomer = session != null && session.getAttribute("customerId") != null;
        if (!hasCustomer) {
            Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if (COOKIE_NAME.equals(c.getName()) && c.getValue() != null && !c.getValue().isEmpty()) {
                        String value = c.getValue();
                        try {
                            String[] parts = value.split(":", 2);
                            if (parts.length != 2) {
                                TokenUtil.clearCookie(req, resp, COOKIE_NAME);
                                break;
                            }
                            String selectorHex = parts[0];
                            String validatorHex = parts[1];
                            if (!isEvenHex(selectorHex) || !isEvenHex(validatorHex)) {
                                TokenUtil.clearCookie(req, resp, COOKIE_NAME);
                                break;
                            }
                            RememberTokenDAO tokenDAO = new RememberTokenDAO();
                            RememberTokenDAO.TokenRecord rec = tokenDAO.findBySelector(TokenUtil.fromHex(selectorHex));
                            if (rec != null && rec.expiresAt != null && rec.expiresAt.toInstant().isAfter(Instant.now())) {
                                byte[] validatorHash = TokenUtil.sha256(TokenUtil.fromHex(validatorHex));
                                if (TokenUtil.constantTimeEquals(validatorHash, rec.validatorHash)) {
                                    // Valid: create session and rotate validator
                                    HttpSession newSess = req.getSession(true);
                                    newSess.setAttribute("customerId", rec.customerId);

                                    // Rotate validator to prevent replay
                                    byte[] newValidator = TokenUtil.randomBytes(32);
                                    byte[] newHash = TokenUtil.sha256(newValidator);
                                    tokenDAO.deleteById(rec.id);
                                    Instant exp = Instant.now().plus(MAX_AGE_DAYS, ChronoUnit.DAYS);
                                    tokenDAO.create(rec.customerId, rec.selector, newHash, exp);
                                    String newCookieVal = selectorHex + ":" + TokenUtil.toHex(newValidator);
                                    TokenUtil.setCookie(req, resp, COOKIE_NAME, newCookieVal, MAX_AGE_DAYS * 24 * 60 * 60);
                                } else {
                                    // Mismatch: possible theft, delete token and cookie
                                    tokenDAO.deleteById(rec.id);
                                    TokenUtil.clearCookie(req, resp, COOKIE_NAME);
                                }
                            } else {
                                // Not found or expired
                                if (rec != null) tokenDAO.deleteById(rec.id);
                                TokenUtil.clearCookie(req, resp, COOKIE_NAME);
                            }
                        } catch (Exception e) {
                            // Any error in remember-me should not break requests; clear and continue
                            TokenUtil.clearCookie(req, resp, COOKIE_NAME);
                        }
                        break; // processed remember cookie
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no-op
    }

    @Override
    public void destroy() {
        // no-op
    }

    private boolean isEvenHex(String s) {
        if (s == null || (s.length() % 2) != 0) return false;
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            boolean isHex = (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f') || (ch >= 'A' && ch <= 'F');
            if (!isHex) return false;
        }
        return true;
    }
}
