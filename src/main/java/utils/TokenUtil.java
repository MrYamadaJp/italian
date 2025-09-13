package utils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Locale;

public class TokenUtil {
    private static final SecureRandom RNG = new SecureRandom();

    public static byte[] randomBytes(int len) {
        byte[] b = new byte[len];
        RNG.nextBytes(b);
        return b;
    }

    public static byte[] sha256(byte[] data) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return md.digest(data);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a == null || b == null) return false;
        if (a.length != b.length) return false;
        int res = 0;
        for (int i = 0; i < a.length; i++) res |= a[i] ^ b[i];
        return res == 0;
    }

    public static String toHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte by : bytes) sb.append(String.format(Locale.ROOT, "%02x", by));
        return sb.toString();
    }

    public static byte[] fromHex(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                    + Character.digit(hex.charAt(i + 1), 16));
        }
        return data;
    }

    public static void setCookie(HttpServletRequest req, HttpServletResponse resp, String name, String value, int maxAgeSeconds) {
        Cookie cookie = new Cookie(name, value);
        String path = req.getContextPath();
        cookie.setPath((path == null || path.isEmpty()) ? "/" : path);
        cookie.setHttpOnly(true);
        if (req.isSecure()) cookie.setSecure(true);
        cookie.setMaxAge(maxAgeSeconds);
        resp.addCookie(cookie);
        // SameSite=Lax best-effort: add header (Servlet 3.1 Cookie API lacks it)
        // This will duplicate Set-Cookie; most containers coalesce or use the latter.
        StringBuilder header = new StringBuilder();
        header.append(name).append("=").append(value)
                .append("; Max-Age=").append(maxAgeSeconds)
                .append("; Path=").append(cookie.getPath())
                .append("; HttpOnly; SameSite=Lax");
        if (req.isSecure()) header.append("; Secure");
        resp.addHeader("Set-Cookie", header.toString());
    }

    public static void clearCookie(HttpServletRequest req, HttpServletResponse resp, String name) {
        Cookie cookie = new Cookie(name, "");
        String path = req.getContextPath();
        cookie.setPath((path == null || path.isEmpty()) ? "/" : path);
        cookie.setHttpOnly(true);
        if (req.isSecure()) cookie.setSecure(true);
        cookie.setMaxAge(0);
        resp.addCookie(cookie);
        // Also emit header version
        String header = name + "=; Max-Age=0; Path=" + cookie.getPath() + "; HttpOnly; SameSite=Lax" + (req.isSecure() ? "; Secure" : "");
        resp.addHeader("Set-Cookie", header);
    }
}

