package service;

/**
 * MarkdownUtil ΓÇö Tiß╗çn ├¡ch chuyß╗ân ─æß╗òi Markdown ─æ╞ín giß║ún sang HTML.
 *
 * <p>Hß╗ù trß╗ú c├íc c├║ ph├íp Markdown phß╗ò biß║┐n m├á Manager d├╣ng trong Bß║úng tin:
 * in ─æß║¡m, in nghi├¬ng, ti├¬u ─æß╗ü, danh s├ích, ─æ╞░ß╗¥ng kß║╗ ngang, v├á xuß╗æng d├▓ng.</p>
 *
 * <p>Kh├┤ng phß╗Ñ thuß╗Öc th╞░ viß╗çn ngo├ái ΓÇö d├╣ng regex thuß║ºn Java ─æß╗â ─æß║úm bß║úo
 * t├¡nh t╞░╞íng th├¡ch trong m├┤i tr╞░ß╗¥ng Servlet kh├┤ng cß║ºn th├¬m dependency.</p>
 *
 * <p>Tu├ón thß╗º: ARCH-01 (kh├┤ng d├╣ng framework ngo├ái ngo├ái danh s├ích ph├¬ duyß╗çt).</p>
 */
public class MarkdownUtil {

    private MarkdownUtil() {
        // Utility class ΓÇö kh├┤ng khß╗ƒi tß║ío
    }

    /**
     * Chuyß╗ân ─æß╗òi chuß╗ùi Markdown sang chuß╗ùi HTML.
     *
     * <p>Thß╗⌐ tß╗▒ xß╗¡ l├╜: heading ΓåÆ bold ΓåÆ italic ΓåÆ danh s├ích ΓåÆ hr ΓåÆ xuß╗æng d├▓ng.</p>
     *
     * @param markdown Chuß╗ùi Markdown ─æß║ºu v├áo (c├│ thß╗â null hoß║╖c rß╗ùng)
     * @return Chuß╗ùi HTML t╞░╞íng ß╗⌐ng, hoß║╖c chuß╗ùi rß╗ùng nß║┐u input l├á null/rß╗ùng
     */
    public static String toHtml(String markdown) {
        if (markdown == null || markdown.trim().isEmpty()) {
            return "";
        }

        String html = markdown;

        // 1. Heading h1ΓÇôh4 (phß║úi xß╗¡ l├╜ tr╞░ß╗¢c bold/italic)
        html = html.replaceAll("(?m)^#### (.+)$", "<h4 style=\"color:#262626;font-weight:700;margin:1rem 0 0.5rem;\">$1</h4>");
        html = html.replaceAll("(?m)^### (.+)$",  "<h3 style=\"color:#262626;font-weight:700;margin:1rem 0 0.5rem;\">$1</h3>");
        html = html.replaceAll("(?m)^## (.+)$",   "<h2 style=\"color:#262626;font-weight:700;margin:1rem 0 0.5rem;\">$1</h2>");
        html = html.replaceAll("(?m)^# (.+)$",    "<h1 style=\"color:#262626;font-weight:700;margin:1rem 0 0.5rem;\">$1</h1>");

        // 2. In ─æß║¡m + in nghi├¬ng (***...***)
        html = html.replaceAll("\\*\\*\\*(.+?)\\*\\*\\*", "<strong><em>$1</em></strong>");

        // 3. In ─æß║¡m (**...**)
        html = html.replaceAll("\\*\\*(.+?)\\*\\*", "<strong>$1</strong>");

        // 4. In nghi├¬ng (*...*)
        html = html.replaceAll("\\*(.+?)\\*", "<em>$1</em>");

        // 5. Danh s├ích gß║ích ─æß║ºu d├▓ng (- item)
        html = html.replaceAll("(?m)^- (.+)$", "<li style=\"margin-bottom:4px;\">$1</li>");
        // Bß╗ìc c├íc <li> liß╗ün kß╗ü v├áo <ul>
        html = html.replaceAll("((?:<li[^>]*>.*?</li>\\n?)+)", "<ul style=\"padding-left:1.5rem;margin-bottom:1rem;\">$1</ul>");

        // 6. Danh s├ích sß╗æ (1. item)
        html = html.replaceAll("(?m)^\\d+\\. (.+)$", "<li style=\"margin-bottom:4px;\">$1</li>");

        // 7. ─É╞░ß╗¥ng kß║╗ ngang (--- hoß║╖c ***)
        html = html.replaceAll("(?m)^(---|\\*\\*\\*)$", "<hr style=\"border:none;border-top:1px solid #e5e5e5;margin:1rem 0;\">");

        // 8. Xuß╗æng d├▓ng: 2 khoß║úng trß║»ng + newline = <br>
        html = html.replaceAll("  \n", "<br>");

        // 9. ─Éoß║ín v─ân (blank line)
        // T├ích c├íc ─æoß║ín ng─ân c├ích bß╗ƒi d├▓ng trß╗æng th├ánh <p>
        String[] paragraphs = html.split("\n\n+");
        if (paragraphs.length > 1) {
            StringBuilder sb = new StringBuilder();
            for (String para : paragraphs) {
                String trimmed = para.trim();
                if (!trimmed.isEmpty()) {
                    // Kh├┤ng bß╗ìc thß║╗ block v├áo <p>
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
