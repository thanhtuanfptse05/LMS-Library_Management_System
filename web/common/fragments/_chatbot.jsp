<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <!-- Link styles và scripts cho Chatbot -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/chatbot.css">

    <!-- Nút Float launcher mở Chatbot -->
    <div id="chatbot-launcher" title="Hỗ trợ AI">
        <i class="bi bi-chat-dots-fill"></i>
    </div>

    <!-- Khung hội thoại Chatbot -->
    <div id="chatbot-container">
        <!-- Header -->
        <div class="chatbot-header">
            <div class="chatbot-info">
                <div class="chatbot-avatar">
                    <i class="bi bi-robot"></i>
                </div>
                <div class="chatbot-title">
                    <h4>Trợ lý ảo UniLib</h4>
                    <span><span class="chatbot-status-dot"></span> Đang hoạt động</span>
                </div>
            </div>
            <button id="chatbot-close" class="chatbot-close" title="Đóng">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <!-- Messages Body -->
        <div id="chatbot-messages" class="chatbot-messages">
            <div class="chat-msg model">
                <div class="chat-bubble">
                    Xin chào! Tôi là trợ lý ảo hỗ trợ đàm thoại của thư viện trường đại học (UniLib). Tôi có thể giúp
                    bạn giải đáp các nội quy thư viện hoặc hỗ trợ tìm kiếm sách nhanh.
                </div>
            </div>
        </div>

        <!-- Footer Input -->
        <div class="chatbot-footer">
            <div class="chatbot-input-wrapper">
                <input type="text" id="chatbot-input" placeholder="Nhập câu hỏi tại đây..." autocomplete="off">
            </div>
            <button id="chatbot-send" class="chatbot-send-btn" title="Gửi">
                <i class="bi bi-send-fill"></i>
            </button>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/chatbot.js"></script>