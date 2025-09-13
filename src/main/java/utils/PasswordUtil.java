package utils;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;

public class PasswordUtil {
    private static final int SALT_LEN = 16; // 16 bytes

    public static byte[] generateSalt() {
        byte[] salt = new byte[SALT_LEN];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    public static byte[] hashPassword(byte[] salt, String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            md.update(password.getBytes("UTF-8"));
            return md.digest();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean verify(byte[] salt, byte[] expectedHash, String password) {
        byte[] actual = hashPassword(salt, password);
        return Arrays.equals(actual, expectedHash);
    }
}

