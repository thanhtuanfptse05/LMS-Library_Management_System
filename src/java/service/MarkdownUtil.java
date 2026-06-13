package service;

/**
 * MarkdownUtil — Tiện ích chuyển đổi Markdown đơn giản sang HTML.
 *
 * <p>Hỗ trợ các cú pháp Markdown phổ biến mà Manager dùng trong Bảng tin:
 * in đậm, in nghiêng, tiêu đề, danh sách, đường kẻ ngang, và xuống dòng.</p>
 *
 * <p>Không phụ thuộc thư viện ngoài — dùng regex thuần Java để đảm bảo
 * tính tương thích trong môi trường Servlet không cần thêm dependency.</p>
 *
 * <p>Tuân thủ: ARCH-01 (không dùng framework ngoài ngoài danh sách phê duyệt).</p>
 */
public class MarkdownUtil {

    private MarkdownUtil() {
        // Utility class — không khởi tạo
    }

    /**
     * Chuyển đổi chuỗi Markdown sang chuỗi HTML.
     *
     * <p>Thứ tự xử lý: heading → bold → italic → danh sách → hr → xuống dòng.</p>
     *
     * @param markdown Chuỗi Markdown đầu vào (có thể null hoặc rỗng)
     * @return Chuỗi HTML tương ứng, hoặc chuỗi rỗng nếu input là null/rỗng
     */
    public static String toHtml(String markdown) {
        if (markdown == null || markdown.trim().isEmpty()) {
            return "";
        }

        String html = markdown;

        // 1. Heading h1–h4 (phải xử lý trước bold/italic)
        html = html.replaceAll("(?m)^#### (.+)$", "<h4 style=\"color:#262626;font-weight:700;margin:1rem 0 0.5rem;\">$1</h4>");
        html = html.replaceAll("(?m)^### (.+)$",  "<h3 style=\"color:#262626;font-weight:700;margin:1rem 0 0.5rem;\">$1</h3>");
        html = html.replaceAll("(?m)^## (.+)$",   "<h2 style=\"color:#262626;font-weight:700;margin:1rem 0 0.5rem;\">$1</h2>");
        html = html.replaceAll("(?m)^# (.+)$",    "<h1 style=\"color:#262626;font-weight:700;margin:1rem 0 0.5rem;\">$1</h1>");

        // 2. In đậm + in nghiêng (***...***)
        html = html.replaceAll("\\*\\*\\*(.+?)\\*\\*\\*", "<strong><em>$1</em></strong>");

        // 3. In đậm (**...**)
        html = html.replaceAll("\\*\\*(.+?)\\*\\*", "<strong>$1</strong>");

        // 4. In nghiêng (*...*)
        html = html.replaceAll("\\*(.+?)\\*", "<em>$1</em>");

        // 5. Danh sách gạch đầu dòng (- item)
        html = html.replaceAll("(?m)^- (.+)$", "<li style=\"margin-bottom:4px;\">$1</li>");
        // Bọc các <li> liền kề vào <ul>
        html = html.replaceAll("((?:<li[^>]*>.*?</li>\\n?)+)", "<ul style=\"padding-left:1.5rem;margin-bottom:1rem;\">$1</ul>");

        // 6. Danh sách số (1. item)
        html = html.replaceAll("(?m)^\\d+\\. (.+)$", "<li style=\"margin-bottom:4px;\">$1</li>");

        // 7. Đường kẻ ngang (--- hoặc ***)
        html = html.replaceAll("(?m)^(---|\\*\\*\\*)$", "<hr style=\"border:none;border-top:1px solid #e5e5e5;margin:1rem 0;\">");

        // 8. Xuống dòng: 2 khoảng trắng + newline = <br>
        html = html.replaceAll("  \n", "<br>");

        // 9. Đoạn văn (blank line)
        // Tách các đoạn ngăn cách bởi dòng trống thành <p>
        String[] paragraphs = html.split("\n\n+");
        if (paragraphs.length > 1) {
            StringBuilder sb = new StringBuilder();
            for (String para : paragraphs) {
                String trimmed = para.trim();
                if (!trimmed.isEmpty()) {
                    // Không bọc thẻ block vào <p>
                    if (trimmed.startsWith("<h") || trimmed.startsWith("<ul") || trimmed.startsWith("<hr")) {
                        sb.append(trimmed).append("\n");
                    } else {
                        sb.append("<p style=\"margin-bottom:1rem;line-height:1.7;\">")
                          .append(trimmed.replace("\n", "<br>"))
                          .append("</p>\n");
                    }
                }
            }
            html = sb.toString();
        }

        return html;
    }
}
