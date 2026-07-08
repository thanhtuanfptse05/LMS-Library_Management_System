package util;

public final class IsbnValidator {

    private IsbnValidator() {
    }

    public static String normalize(String isbn) {
        if (isbn == null) {
            return null;
        }
        return isbn.replaceAll("[\\s-]", "").toUpperCase();
    }

    public static boolean isValid(String isbn) {
        String normalized = normalize(isbn);
        if (normalized == null) {
            return false;
        }
        if (normalized.length() == 10) {
            return isValidIsbn10(normalized);
        }
        if (normalized.length() == 13) {
            return isValidIsbn13(normalized);
        }
        return false;
    }

    private static boolean isValidIsbn10(String isbn) {
        int sum = 0;
        for (int i = 0; i < 10; i++) {
            char ch = isbn.charAt(i);
            int value;
            if (i == 9 && ch == 'X') {
                value = 10;
            } else if (Character.isDigit(ch)) {
                value = ch - '0';
            } else {
                return false;
            }
            sum += value * (10 - i);
        }
        return sum % 11 == 0;
    }

    private static boolean isValidIsbn13(String isbn) {
        int sum = 0;
        for (int i = 0; i < 13; i++) {
            char ch = isbn.charAt(i);
            if (!Character.isDigit(ch)) {
                return false;
            }
            int value = ch - '0';
            sum += value * (i % 2 == 0 ? 1 : 3);
        }
        return sum % 10 == 0;
    }
}
