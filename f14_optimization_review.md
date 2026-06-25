# Đánh giá 7 đề xuất tối ưu F14 — Đối chiếu với code hiện tại (v3)

> [!NOTE]
> **Cập nhật v3:**
> - FAQ Template: chuyển từ `DocumentTemp` (bảng email) → **lưu trong Java service** (static Map + placeholder)
> - Tách Books: nâng từ "bỏ qua" → **"nên làm, ưu tiên 5"** vì search = bài toán DB

## Tóm tắt nhanh

| # | Đề xuất | Phán quyết | Chi phí | Lợi ích |
|---|---|---|---|---|
| 1 | Regex-first Intent Classification | ✅ **NÊN LÀM** | ~30 dòng sửa | Giảm ~70% API calls classify |
| 2 | Tách Books: DB Search / AI Advice | ✅ **NÊN LÀM** (ưu tiên 5) | ~40 dòng Servlet + JS | Search = DB, Advice = AI |
| 3 | Cache Rules Context | ✅ **NÊN LÀM** | ~15 dòng thêm | Bỏ query DB mỗi lần hỏi nội quy |
| 4 | Giảm context gửi lên AI | ✅ **NÊN LÀM** | ~10 dòng sửa | Token ít hơn, AI tập trung hơn |
| 5 | Streaming Response (SSE) | ❌ **BỎ QUA** | Lớn (SSE + JS rewrite) | Quá phức tạp cho SWP391 |
| 6 | Candidate Pool thông minh hơn | ❌ **BỎ QUA** | Sửa BookDAO + Service | Lợi ích nhỏ, SQL phức tạp |
| 7 | FAQ Template bằng Java Service | ✅ **NÊN LÀM** | ~50 dòng trong Service | Nội quy FAQ = 0 API call |

---

## ✅ TĐ1: Regex-first Intent Classification — Ưu tiên 🥇

**Hiện trạng:** [classifyIntent()](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/service/AiChatbotService.java#L39-L114) chỉ check regex cho Irrelevant (dòng 46–51), mọi câu còn lại đều gọi Gemini API. Keyword fallback ở dòng 106–111 chỉ chạy khi Gemini lỗi.

**Thay đổi:** Đảo logic — keyword check trước cho **cả 3 nhóm** (Rules/Books/Irrelevant), chỉ gọi Gemini khi không chắc chắn.

```java
public String classifyIntent(String userMessage) {
    String m = userMessage.toLowerCase().trim();
    
    // Lớp 1: Keyword rõ ràng → return ngay (0ms)
    if (m.matches(".*(phạt|nội quy|quy định|giờ mở cửa|quá hạn|gia hạn|bao nhiêu tiền|mấy ngày|mấy cuốn).*"))
        return "Rules";
    if (m.matches(".*(tìm sách|sách về|cuốn sách|tác giả|gợi ý sách|đề xuất sách|tìm cuốn).*"))
        return "Books";
    if (m.matches(".*(xin chào|hello|bạn là ai|cảm ơn|tạm biệt|bye).*"))
        return "Irrelevant";
    
    // Lớp 2: Mơ hồ → gọi Gemini classify (giữ nguyên logic cũ)
    return classifyIntentByAI(userMessage);
}
```

**Chi phí:** ~30 dòng sửa trong 1 file. **Lợi ích:** Giảm ~70% API calls classify.

---

## ✅ TĐ7 (SỬA LẠI): FAQ Template trong Java Service — Ưu tiên 🥈

> [!IMPORTANT]
> **Sửa so với v2:** `DocumentTemp` là bảng chuyên dụng cho **email template** → **không nên nhồi FAQ chatbot** vào đó. Thay vào đó, lưu FAQ templates trực tiếp trong Java service class.

**Cơ chế:** Static Map trong `AiChatbotService` chứa Markdown template với `{{placeholder}}` → runtime replace bằng giá trị từ `SystemConfigurations`.

```java
// Trong AiChatbotService.java — Khai báo FAQ templates
private static final Map<String, String> FAQ_TEMPLATES = new LinkedHashMap<>();
static {
    FAQ_TEMPLATES.put("FINE",
        "📌 **Mức phạt tại thư viện**\n\n"
        + "• Phạt trả sách trễ hạn: **{{FINE_RATE_PER_DAY}} VNĐ/ngày**\n"
        + "• Phạt sách bị hỏng: giá sách × **{{DAMAGED_FINE_MULTIPLIER}}**\n"
        + "• Phạt mất sách: giá sách × **{{LOST_FINE_MULTIPLIER}}**\n"
        + "• Giá sách mặc định: {{DEFAULT_BOOK_PRICE}} VNĐ\n\n"
        + "💡 *Hãy trả sách đúng hạn để tránh phạt nhé!*");

    FAQ_TEMPLATES.put("BORROW_LIMIT",
        "📚 **Giới hạn số sách được mượn**\n\n"
        + "• Sinh viên: tối đa **{{STUDENT_MAX_BORROW_LIMIT}} cuốn** cùng lúc\n"
        + "• Giảng viên: tối đa **{{LECTURER_MAX_BORROW_LIMIT}} cuốn** cùng lúc\n\n"
        + "*Bao gồm cả sách đang mượn và đặt trước.*");

    FAQ_TEMPLATES.put("BORROW_DURATION",
        "📅 **Thời hạn mượn sách**\n\n"
        + "• Sinh viên: **{{STUDENT_MAX_BORROW_DAYS}} ngày**\n"
        + "• Giảng viên: **{{LECTURER_MAX_BORROW_DAYS}} ngày**\n\n"
        + "*Bạn có thể gia hạn nếu đủ điều kiện.*");

    FAQ_TEMPLATES.put("RENEWAL",
        "🔄 **Quy định gia hạn sách**\n\n"
        + "• Số lần gia hạn tối đa: **{{MAX_EXTENSION_COUNT}} lần**/lượt mượn\n"
        + "• Mỗi lần gia hạn thêm: **{{RENEW_DURATION_DAYS}} ngày**\n"
        + "• Điều kiện: đã mượn ít nhất **{{RENEW_THRESHOLD_PERCENT}}%** thời gian\n\n"
        + "*Sách quá hạn hoặc đang có người đặt trước sẽ không được gia hạn.*");

    FAQ_TEMPLATES.put("RESERVATION",
        "🔖 **Quy định đặt trước sách**\n\n"
        + "• Sau khi sách có sẵn, bạn có **{{RESERVATION_HOLD_DAYS}} ngày** để đến nhận\n"
        + "• Quá thời hạn sẽ tự động hủy\n"
        + "• Giới hạn đặt trước tính chung với giới hạn mượn sách");
}
```

**Regex matching → template:**

```java
// Trong AiChatbotService.java
private static final Map<String, String> FAQ_REGEX = new LinkedHashMap<>();
static {
    FAQ_REGEX.put("FINE",            ".*(phạt|trễ hạn|quá hạn|bao nhiêu tiền|tiền phạt).*");
    FAQ_REGEX.put("BORROW_LIMIT",   ".*(bao nhiêu cuốn|mấy cuốn|giới hạn mượn|mượn tối đa|mượn được mấy).*");
    FAQ_REGEX.put("BORROW_DURATION",".*(mấy ngày|bao lâu|thời hạn mượn|hạn trả|mượn trong).*");
    FAQ_REGEX.put("RENEWAL",        ".*(gia hạn|renew|mượn thêm|kéo dài).*");
    FAQ_REGEX.put("RESERVATION",    ".*(đặt trước|giữ sách|reservation|hàng chờ).*");
}

public String matchRulesFAQ(String userMessage) {
    String m = userMessage.toLowerCase();
    for (Map.Entry<String, String> entry : FAQ_REGEX.entrySet()) {
        if (m.matches(entry.getValue())) {
            String template = FAQ_TEMPLATES.get(entry.getKey());
            return (template != null) ? resolvePlaceholders(template) : null;
        }
    }
    return null;
}

private String resolvePlaceholders(String content) {
    Map<String, String> configs = retrieveRulesConfigMap(); // cached
    String result = content;
    for (Map.Entry<String, String> entry : configs.entrySet()) {
        String value = entry.getValue();
        int descIdx = value.indexOf(" (");
        if (descIdx > 0) value = value.substring(0, descIdx);
        result = result.replace("{{" + entry.getKey() + "}}", value);
    }
    return result;
}
```

**Kết hợp với TĐ3 (cache):** `resolvePlaceholders()` dùng cached config → **0 DB query, 0 API call, ~50ms** cho FAQ.

**Chi phí:** ~50 dòng thêm trong `AiChatbotService` + ~10 dòng sửa Servlet. **Không cần sửa DB.**

---

## ✅ TĐ3: Cache Rules Context — Ưu tiên 🥉

**Hiện trạng:** [retrieveRulesContext()](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/service/AiChatbotService.java#L119-L130) query DB mỗi lần hỏi nội quy. Dữ liệu `SystemConfigurations` gần như không thay đổi.

**Thay đổi:**

```java
private static volatile Map<String, String> cachedConfigMap;
private static volatile String cachedRulesContext;
private static volatile long cacheTimestamp = 0;
private static final long CACHE_TTL_MS = 10 * 60 * 1000; // 10 phút

private Map<String, String> retrieveRulesConfigMap() {
    long now = System.currentTimeMillis();
    if (cachedConfigMap != null && (now - cacheTimestamp) < CACHE_TTL_MS) {
        return cachedConfigMap;
    }
    cachedConfigMap = systemConfigDAO.getLibraryConfigurations();
    cacheTimestamp = now;
    // Rebuild text context luôn
    StringBuilder sb = new StringBuilder("Dưới đây là các chính sách...\n");
    for (Map.Entry<String, String> e : cachedConfigMap.entrySet()) {
        sb.append("- ").append(e.getKey()).append(": ").append(e.getValue()).append("\n");
    }
    cachedRulesContext = sb.toString();
    return cachedConfigMap;
}

public String retrieveRulesContext() {
    retrieveRulesConfigMap(); // đảm bảo cache fresh
    return cachedRulesContext;
}
```

**Chi phí:** ~15 dòng. **Lợi ích:** 0 DB query cho 100% câu hỏi Rules sau lần đầu.

---

## ✅ TĐ4: Giảm history + Intent-based reset — Ưu tiên 🏅

**Thay đổi:**

```diff
// AiChatbotServlet.java
- pruneHistory(chatHistory, 9);
+ pruneHistory(chatHistory, 5); // 3 lượt gần nhất

// Thêm intent-based reset:
+ String lastIntent = (String) session.getAttribute("lastChatIntent");
+ if (lastIntent != null && !lastIntent.equals(intent)) {
+     chatHistory.clear();
+     chatHistory.add(new ChatMessage("user", userMessage));
+ }
+ session.setAttribute("lastChatIntent", intent);
```

**Chi phí:** ~10 dòng. **Lợi ích:** Prompt ngắn hơn, token ít hơn, AI tập trung hơn.

---

## ✅ TĐ2 (CẬP NHẬT): Tách Books DB Search / AI Advice — Ưu tiên 5️⃣

> [!NOTE]
> **Sửa so với v2:** Nâng từ "bỏ qua" lên **"nên làm, ưu tiên thấp"**. Lý do: search = bài toán DB, không phải bài toán reasoning. AI không tạo giá trị cho "tìm sách Java".

**Phân tách 2 sub-intent trong nhóm Books:**

| Sub-intent | Ví dụ | Xử lý |
|---|---|---|
| **Search** (tìm kiếm cụ thể) | "Tìm sách Java", "Sách của tác giả Nguyễn Nhật Ánh" | DB query → trả JSON/Markdown trực tiếp |
| **Advice** (cần tư vấn/gợi ý) | "Mình nên đọc gì?", "Gợi ý sách cho người mới" | DB + Gemini reasoning |

**Cách phân biệt (regex):**

```java
// Trong AiChatbotServlet.java — sau khi classify intent = "Books"
boolean isDirectSearch = userMessage.toLowerCase()
    .matches(".*(tìm sách|sách về|cuốn sách|có sách|sách của tác giả|tìm cuốn).*");
boolean isAdvice = userMessage.toLowerCase()
    .matches(".*(gợi ý|đề xuất|khuyên đọc|nên đọc|phù hợp với|đọc gì).*");

if (isDirectSearch && !isAdvice) {
    // Luồng A: DB Search trực tiếp, không qua AI
    String booksContext = aiChatbotService.retrieveBooksContext(userMessage);
    if (booksContext.contains("Không tìm thấy")) {
        responseText = "Không tìm thấy sách phù hợp với từ khóa của bạn. "
                     + "Bạn có thể thử từ khóa khác hoặc hỏi mình gợi ý sách nhé!";
    } else {
        // Format kết quả DB thành Markdown đẹp trực tiếp
        responseText = aiChatbotService.formatBooksAsMarkdown(userMessage, booksContext);
    }
    // → 0 API call, ~100ms
} else {
    // Luồng B: Cần AI tư vấn (giữ nguyên logic hiện tại)
    // ...gọi Gemini...
}
```

**Hàm format kết quả DB:**

```java
// Trong AiChatbotService.java
public String formatBooksAsMarkdown(String query, String rawContext) {
    // rawContext đã có dạng "- ID: 1 | Tên sách: X | Tác giả: Y | ..."
    // Chuyển thành Markdown đẹp hơn
    StringBuilder sb = new StringBuilder();
    sb.append("📚 **Kết quả tìm kiếm**\n\n");
    // Parse từng dòng và format lại
    String[] lines = rawContext.split("\n");
    int count = 0;
    for (String line : lines) {
        if (line.startsWith("- ID:")) {
            count++;
            // Extract fields
            String title = extractField(line, "Tên sách:");
            String author = extractField(line, "Tác giả:");
            String available = extractField(line, "Số lượng khả dụng:");
            sb.append("**").append(count).append(". ").append(title).append("**\n");
            sb.append("   Tác giả: ").append(author);
            sb.append(" · Khả dụng: ").append(available).append(" cuốn\n\n");
        }
    }
    if (count > 0) {
        sb.append("*Bạn có thể đến thư viện để mượn trực tiếp.*");
    }
    return sb.toString();
}
```

**Tại sao ưu tiên 5 (thấp nhất)?**
- TĐ1 + TĐ7 + TĐ3 + TĐ4 đã giảm mạnh latency cho phần lớn câu hỏi
- TĐ2 chỉ tối ưu thêm cho nhóm "tìm sách cụ thể" — lợi ích có nhưng không critical
- Cần thêm logic phân biệt search/advice (regex) + format function → effort nhiều hơn
- Nếu hết thời gian, bỏ qua TĐ2 cũng chấp nhận được

**Chi phí:** ~40 dòng Servlet + Service. **Lợi ích:** "Tìm sách Java" = ~100ms thay vì ~1-2s.

---

## ❌ TĐ5: Streaming (SSE) — BỎ QUA

Cần rewrite AsyncContext + JS EventSource + Gemini stream endpoint. Quá phức tạp cho SWP391.

## ❌ TĐ6: Candidate Pool — BỎ QUA

Lợi ích nhỏ, phải sửa SQL trong BookDAO. F8 integration hiện tại đã đủ tốt.

---

## Tóm tắt: 5 thay đổi nên làm

| Ưu tiên | Thay đổi | File sửa | Thời gian |
|---|---|---|---|
| 🥇 | **Regex-first Intent** | [AiChatbotService.java](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/service/AiChatbotService.java) (~30 dòng) | ~45 phút |
| 🥈 | **FAQ Template (Java static)** | [AiChatbotService.java](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/service/AiChatbotService.java) (~50 dòng) + [AiChatbotServlet.java](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/controllers/AiChatbotServlet.java) (~10 dòng) | ~1 giờ |
| 🥉 | **Cache Rules Context** | [AiChatbotService.java](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/service/AiChatbotService.java) (~15 dòng) | ~20 phút |
| 🏅 | **Giảm history + intent reset** | [AiChatbotServlet.java](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/controllers/AiChatbotServlet.java) (~10 dòng) | ~15 phút |
| 5️⃣ | **Tách Books Search/Advice** | [AiChatbotServlet.java](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/controllers/AiChatbotServlet.java) + [AiChatbotService.java](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/src/java/service/AiChatbotService.java) (~40 dòng) | ~45 phút |

**Tổng effort:** ~3 giờ cho cả 5 thay đổi. Sửa 2 file Java chính.

### Luồng F14 sau khi tối ưu

```
User Message
    │
    ├─ Regex Intent (local, 0ms)
    │
    ├─ IRRELEVANT → phản hồi tĩnh (0 API call)
    │
    ├─ RULES
    │   ├─ FAQ regex match? → Static template + cached config (0 API, ~50ms) ⚡
    │   └─ Không match → Cached rules context + Gemini (1 API call, ~1-2s)
    │
    ├─ BOOKS
    │   ├─ Direct search? → DB query + format Markdown (0 API, ~100ms) ⚡
    │   └─ Advice/gợi ý? → DB + F8 + Gemini reasoning (1 API call, ~1-2s)
    │
    └─ MƠ HỒ → Gemini classify + Gemini answer (2 API, giữ nguyên)
```

### So sánh trước/sau

| Tình huống | Trước | Sau |
|---|---|---|
| "Mức phạt trễ hạn?" | 2 API calls, ~3-4s | **0 API, ~50ms** |
| "Mượn được mấy cuốn?" | 2 API calls, ~3-4s | **0 API, ~50ms** |
| "Tìm sách Java" | 2 API calls, ~3-4s | **0 API, ~100ms** |
| "Gợi ý sách hay cho mình" | 2 API calls, ~3-4s | **1 API, ~1-2s** |
| "Trả trễ 5 ngày phạt bao nhiêu?" | 2 API calls, ~3-4s | **1 API, ~1-2s** |
| "Mình thích khoa học viễn tưởng" | 2 API calls, ~3-4s | 2 API calls (giữ nguyên) |
| Chi phí token/tháng | 100% | **~25-35%** |

> [!IMPORTANT]
> **Bạn muốn tôi triển khai 5 thay đổi này không?** Cả 5 đều backward compatible. Ưu tiên 1–4 có thể làm trước (~2 giờ), ưu tiên 5 làm nếu còn thời gian.
