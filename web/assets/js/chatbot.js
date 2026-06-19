/* chatbot.js — Điều khiển tương tác và giao tiếp API của AI Chatbot */

document.addEventListener('DOMContentLoaded', () => {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';
    const apiEndpoint = `${contextPath}/api/chatbot`;

    const launcher = document.getElementById('chatbot-launcher');
    const container = document.getElementById('chatbot-container');
    const closeBtn = document.getElementById('chatbot-close');
    const msgsBody = document.getElementById('chatbot-messages');
    const chatInput = document.getElementById('chatbot-input');
    const sendBtn = document.getElementById('chatbot-send');

    // ── Toggle Chatbox ──────────────────────────────────────────────
    launcher.addEventListener('click', () => {
        container.classList.toggle('active');
        if (container.classList.contains('active')) {
            chatInput.focus();
            scrollToBottom();
        }
    });

    closeBtn.addEventListener('click', () => {
        container.classList.remove('active');
    });

    // Close when clicking outside on mobile
    window.addEventListener('click', (e) => {
        if (window.innerWidth <= 480) {
            if (!container.contains(e.target) && !launcher.contains(e.target)) {
                container.classList.remove('active');
            }
        }
    });

    // ── Send Message ────────────────────────────────────────────────
    const handleSend = () => {
        const text = chatInput.value.trim();
        if (!text) return;

        // Render User Message
        appendMessage('user', text);
        chatInput.value = '';
        scrollToBottom();

        // Show typing indicator
        showLoadingIndicator();

        // Call API
        fetch(apiEndpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json;charset=UTF-8'
            },
            body: JSON.stringify({ message: text })
        })
        .then(res => {
            if (!res.ok) throw new Error('API Error');
            return res.json();
        })
        .then(data => {
            removeLoadingIndicator();
            if (data.status === 'success') {
                appendMessage('model', data.response);
            } else {
                appendMessage('model', 'Hệ thống AI hiện đang quá tải. Vui lòng thử lại sau ít phút.');
            }
            scrollToBottom();
        })
        .catch(err => {
            removeLoadingIndicator();
            appendMessage('model', 'Hệ thống AI hiện đang quá tải. Vui lòng thử lại sau ít phút.');
            scrollToBottom();
        });
    };

    sendBtn.addEventListener('click', handleSend);
    chatInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            handleSend();
        }
    });

    // ── Fetch Chat History on Load ──────────────────────────────────
    const loadHistory = () => {
        fetch(apiEndpoint)
            .then(res => res.json())
            .then(data => {
                if (data.status === 'success' && data.history && data.history.length > 0) {
                    msgsBody.innerHTML = ''; // Clear default welcome
                    data.history.forEach(msg => {
                        appendMessage(msg.role, msg.content);
                    });
                } else {
                    // Hiển thị câu chào mặc định
                    showWelcomeMessage();
                }
                scrollToBottom();
            })
            .catch(() => {
                showWelcomeMessage();
                scrollToBottom();
            });
    };

    loadHistory();

    // ── Helper Functions ────────────────────────────────────────────
    function showWelcomeMessage() {
        msgsBody.innerHTML = `
            <div class="chat-msg model">
                <div class="chat-bubble">
                    Xin chào! Tôi là trợ lý ảo hỗ trợ đàm thoại của thư viện trường đại học (UniLib). Tôi có thể giúp bạn giải đáp các nội quy thư viện hoặc hỗ trợ tìm kiếm sách nhanh.
                </div>
            </div>
        `;
    }

    function appendMessage(role, text) {
        const msgDiv = document.createElement('div');
        msgDiv.className = `chat-msg ${role}`;

        const bubble = document.createElement('div');
        bubble.className = 'chat-bubble';
        bubble.innerHTML = parseMarkdown(text);

        msgDiv.appendChild(bubble);
        msgsBody.appendChild(msgDiv);
    }

    function showLoadingIndicator() {
        const loadingDiv = document.createElement('div');
        loadingDiv.id = 'chatbot-loading-indicator';
        loadingDiv.className = 'chat-msg model';
        loadingDiv.innerHTML = `
            <div class="chat-bubble chat-loading">
                <span></span>
                <span></span>
                <span></span>
            </div>
        `;
        msgsBody.appendChild(loadingDiv);
        scrollToBottom();
    }

    function removeLoadingIndicator() {
        const indicator = document.getElementById('chatbot-loading-indicator');
        if (indicator) {
            indicator.remove();
        }
    }

    function scrollToBottom() {
        msgsBody.scrollTop = msgsBody.scrollHeight;
    }

    // ── Markdown Parser ─────────────────────────────────────────────
    function parseMarkdown(text) {
        if (!text) return '';
        
        let html = text
            // Escape HTML characters to prevent XSS
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');

        // 1. Heading h4 - h1
        html = html.replace(/^#### (.+)$/gm, '<h5 style="font-weight:700;margin-top:6px;margin-bottom:4px;">$1</h5>');
        html = html.replace(/^### (.+)$/gm, '<h5 style="font-weight:700;margin-top:6px;margin-bottom:4px;">$1</h5>');
        html = html.replace(/^## (.+)$/gm, '<h5 style="font-weight:700;margin-top:6px;margin-bottom:4px;">$1</h5>');
        html = html.replace(/^# (.+)$/gm, '<h5 style="font-weight:700;margin-top:6px;margin-bottom:4px;">$1</h5>');

        // 2. Bold (*** or **)
        html = html.replace(/\*\*\*(.+?)\*\*\*/g, '<strong><em>$1</em></strong>');
        html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');

        // 3. Italic (*)
        html = html.replace(/\*(.+?)\*/g, '<em>$1</em>');

        // 4. Horizontal lines (---)
        html = html.replace(/^---$/gm, '<hr style="border:none;border-top:1px solid rgba(140,98,57,0.2);margin:8px 0;">');

        // 5. Lists (- or * )
        html = html.replace(/^(?:\-|\*)\s+(.+)$/gm, '<li style="margin-left: 12px; margin-bottom: 2px;">$1</li>');
        
        // Group consecutive <li> into <ul>
        html = html.replace(/((?:<li[^>]*>.*?<\/li>\n?)+)/g, '<ul style="padding-left:14px; margin-bottom:6px;">$1</ul>');

        // 6. Paragraphs and Newlines
        // Replace newlines that are not inside block tags with <br>
        html = html.replace(/\n/g, '<br>');

        return html;
    }
});
