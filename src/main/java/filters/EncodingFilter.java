package filters;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {
    private static final String ENC = "UTF-8";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Ensure request parameters decode as UTF-8 (POST/GET)
        if (request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(ENC);
        }
        // Do NOT force response content type here; static assets like CSS/JS must retain their types
        // JSPs already declare UTF-8 via page directive
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
}
