<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_header.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <jsp:include page="fragments/_sidebar.jsp" />

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto" style="background-color: #faf9f8;">
            <div class="container-xl px-4 py-5" style="max-width: 1400px; margin: 0 auto;">

                <!-- ─── BREADCRUMBS & PAGE HEADER ─── -->
                <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                     aria-label="breadcrumb"
                     style="font-size: 12px; letter-spacing: 0.05em;">
                    <a class="text-decoration-none text-muted link-dark"
                       href="${pageContext.request.contextPath}/student/dashboard">Trang chủ</a>
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                    <span class="text-dark">Hộp thư thông báo</span>
                </nav>

                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                    <div>
                        <h1 class="h3 fw-bold text-dark mb-1">Hộp thư thông báo</h1>
                        <p class="text-secondary mb-0">Cập nhật các nhắc nhở trả sách, thông tin đặt chỗ và thông báo từ thư viện.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-1 py-2 px-3 fw-semibold shadow-sm"
                                onclick="markAllAsRead()">
                            <span class="material-symbols-outlined fs-5">done_all</span> Đánh dấu đã đọc tất cả
                        </button>
                        <button class="btn btn-light btn-sm text-danger border rounded-3 d-flex align-items-center gap-1 py-2 px-3 fw-semibold shadow-sm"
                                onclick="deleteAllNotifications()">
                            <span class="material-symbols-outlined fs-5">delete_sweep</span> Xóa tất cả
                        </button>
                    </div>
                </div>

                <!-- ─── MAIN BENTO GRID LAYOUT ─── -->
                <div class="row g-4">
                    
                    <!-- Left Area: Search, Tabs & Notification List (Wide, 8 Columns) -->
                    <div class="col-12 col-lg-8">
                        <div class="raised-card shadow-sm p-4 mb-4">
                            
                            <!-- Search & Filtering Tools -->
                            <div class="row g-3 mb-4">
                                <div class="col-12 col-md-7">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 rounded-start-3 text-secondary">
                                            <span class="material-symbols-outlined">search</span>
                                        </span>
                                        <input type="text" class="form-control bg-light border-start-0 rounded-end-3" 
                                               id="searchNotifInput" placeholder="Tìm kiếm tiêu đề hoặc nội dung thông báo..."
                                               onkeyup="filterNotifications()">
                                    </div>
                                </div>
                                <div class="col-12 col-md-5">
                                    <select class="form-select bg-light rounded-3" id="filterType" onchange="filterNotifications()">
                                        <option value="all" selected>Tất cả loại thông báo</option>
                                        <option value="warning">Nhắc nhở & Cảnh báo</option>
                                        <option value="success">Giao dịch thành công</option>
                                        <option value="info">Thông tin chung</option>
                                        <option value="error">Hóa đơn phạt</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Category Filter Tabs -->
                            <ul class="nav nav-tabs border-bottom mb-3" id="notifTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active fw-bold text-dark px-3 py-2 border-0 border-bottom border-3 border-transparent" 
                                            id="all-tab" data-bs-toggle="tab" data-bs-target="#tab-content" type="button" 
                                            onclick="changeTab('all')">Tất cả</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link fw-semibold text-secondary px-3 py-2 border-0 border-bottom border-3 border-transparent" 
                                            id="unread-tab" data-bs-toggle="tab" data-bs-target="#tab-content" type="button"
                                            onclick="changeTab('unread')">
                                        Chưa đọc <span class="badge rounded-pill bg-primary-custom ms-1">3</span>
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link fw-semibold text-secondary px-3 py-2 border-0 border-bottom border-3 border-transparent" 
                                            id="read-tab" data-bs-toggle="tab" data-bs-target="#tab-content" type="button"
                                            onclick="changeTab('read')">Đã đọc</button>
                                </li>
                            </ul>

                            <!-- Notification Rows Container -->
                            <div class="tab-content" id="notifTabContent">
                                <div class="tab-pane fade show active" id="tab-content" role="tabpanel">
                                    <div class="d-flex flex-column gap-3" id="notificationsList">
                                        
                                        <!-- Item 1: Warning (Unread) -->
                                        <div class="notif-item p-3 rounded-3 border-start border-4 border-warning d-flex gap-3 position-relative" 
                                             data-status="unread" data-type="warning" id="notif-1" style="background-color: rgba(217, 119, 6, 0.03);">
                                            <div class="notif-icon-box rounded-circle d-flex align-items-center justify-content-center bg-warning-subtle text-warning"
                                                 style="width: 44px; height: 44px; flex-shrink: 0;">
                                                <span class="material-symbols-outlined fs-4">warning</span>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start gap-2">
                                                    <h5 class="notif-title fs-6 fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                                                        Sách mượn sắp hết hạn
                                                        <span class="rounded-circle d-inline-block bg-primary-custom" style="width: 8px; height: 8px;" id="dot-1"></span>
                                                    </h5>
                                                    <span class="text-secondary small font-monospace">10 phút trước</span>
                                                </div>
                                                <p class="notif-summary text-secondary small mb-2 text-truncate" style="max-width: 520px;">
                                                    Cuốn sách "Design Patterns: Elements of Reusable Object-Oriented Software" của bạn sẽ hết hạn vào ngày mai.
                                                </p>
                                                <div class="d-none notif-full-content">
                                                    Chào bạn, sách mượn <strong>"Design Patterns: Elements of Reusable Object-Oriented Software"</strong> (Mã sao chép: DP-88392) của bạn sẽ đến hạn trả vào ngày mai (07/06/2026). <br><br>Vui lòng đăng nhập cổng thông tin để yêu cầu gia hạn trực tuyến thêm 7 ngày hoặc trả lại sách tại quầy thủ thư đúng hẹn để tránh phát sinh phí phạt quá hạn (5,000 VND/ngày).
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-link p-0 text-decoration-none text-primary-custom fw-bold small d-flex align-items-center gap-0.5" 
                                                            onclick="viewDetails(1)">
                                                        Chi tiết <span class="material-symbols-outlined fs-6">arrow_right_alt</span>
                                                    </button>
                                                    <button class="btn btn-link p-0 text-decoration-none text-secondary small" 
                                                            id="btn-read-1" onclick="markAsRead(1)">
                                                        Đánh dấu đã đọc
                                                    </button>
                                                </div>
                                            </div>
                                            <button class="btn btn-link text-secondary p-1 rounded-circle hover-bg-light notif-delete-btn" 
                                                    onclick="deleteNotif(1)" style="position: absolute; right: 12px; bottom: 12px;">
                                                <span class="material-symbols-outlined fs-5">delete</span>
                                            </button>
                                        </div>

                                        <!-- Item 2: Success (Read) -->
                                        <div class="notif-item p-3 rounded-3 border-start border-4 border-success d-flex gap-3 position-relative" 
                                             data-status="read" data-type="success" id="notif-2" style="background-color: #ffffff;">
                                            <div class="notif-icon-box rounded-circle d-flex align-items-center justify-content-center bg-success-subtle text-success"
                                                 style="width: 44px; height: 44px; flex-shrink: 0;">
                                                <span class="material-symbols-outlined fs-4">check_circle</span>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start gap-2">
                                                    <h5 class="notif-title fs-6 fw-semibold mb-1 text-dark">
                                                        Xác nhận trả sách thành công
                                                    </h5>
                                                    <span class="text-secondary small font-monospace">7 giờ trước</span>
                                                </div>
                                                <p class="notif-summary text-secondary small mb-2 text-truncate" style="max-width: 520px;">
                                                    Bạn đã trả cuốn sách "Clean Code" thành công tại quầy thủ thư vào lúc 14:30 hôm nay.
                                                </p>
                                                <div class="d-none notif-full-content">
                                                    Giao dịch trả sách của bạn đã hoàn tất. <br><br>
                                                    - <strong>Tên sách:</strong> Clean Code: A Handbook of Agile Software Craftsmanship<br>
                                                    - <strong>Mã barcode:</strong> CC-0928<br>
                                                    - <strong>Thời gian nhận trả:</strong> 14:30 - 06/06/2026<br>
                                                    - <strong>Người thực hiện:</strong> Thủ thư Nguyễn Văn A<br>
                                                    - <strong>Tình trạng sách khi trả:</strong> Tốt (Good)<br><br>
                                                    Hệ thống không ghi nhận bất kỳ khoản phạt nào cho giao dịch này. Cảm ơn bạn đã hợp tác trả sách đúng hạn!
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-link p-0 text-decoration-none text-primary-custom fw-bold small d-flex align-items-center gap-0.5" 
                                                            onclick="viewDetails(2)">
                                                        Chi tiết <span class="material-symbols-outlined fs-6">arrow_right_alt</span>
                                                    </button>
                                                </div>
                                            </div>
                                            <button class="btn btn-link text-secondary p-1 rounded-circle hover-bg-light notif-delete-btn" 
                                                    onclick="deleteNotif(2)" style="position: absolute; right: 12px; bottom: 12px;">
                                                <span class="material-symbols-outlined fs-5">delete</span>
                                            </button>
                                        </div>

                                        <!-- Item 3: Info (Unread) -->
                                        <div class="notif-item p-3 rounded-3 border-start border-4 border-info d-flex gap-3 position-relative" 
                                             data-status="unread" data-type="info" id="notif-3" style="background-color: rgba(217, 119, 6, 0.03);">
                                            <div class="notif-icon-box rounded-circle d-flex align-items-center justify-content-center bg-info-subtle text-info"
                                                 style="width: 44px; height: 44px; flex-shrink: 0;">
                                                <span class="material-symbols-outlined fs-4">campaign</span>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start gap-2">
                                                    <h5 class="notif-title fs-6 fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                                                        Thông báo lịch nghỉ lễ
                                                        <span class="rounded-circle d-inline-block bg-primary-custom" style="width: 8px; height: 8px;" id="dot-3"></span>
                                                    </h5>
                                                    <span class="text-secondary small font-monospace">1 ngày trước</span>
                                                </div>
                                                <p class="notif-summary text-secondary small mb-2 text-truncate" style="max-width: 520px;">
                                                    Thư viện trường sẽ đóng cửa nghỉ lễ từ ngày 10/06 đến hết ngày 12/06/2026.
                                                </p>
                                                <div class="d-none notif-full-content">
                                                    Kính gửi toàn thể sinh viên và giảng viên, <br><br>
                                                    Thư viện đại học xin thông báo lịch nghỉ lễ Quốc khánh sắp tới của cán bộ nhân viên thư viện:<br>
                                                    - <strong>Thời gian đóng cửa:</strong> Từ thứ Tư ngày 10/06/2026 đến hết thứ Sáu ngày 12/06/2026.<br>
                                                    - <strong>Thời gian mở cửa lại:</strong> 08:00 sáng thứ Bảy ngày 13/06/2026.<br><br>
                                                    Mọi cổng dịch vụ trực tuyến (Đăng ký mượn, gia hạn sách) vẫn hoạt động bình thường. Tuy nhiên, thời hạn trả sách của các phiếu mượn trùng vào những ngày này sẽ tự động gia hạn thêm tới ngày 14/06/2026 mà không tính phí phạt. <br>Xin chân thành cảm ơn!
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-link p-0 text-decoration-none text-primary-custom fw-bold small d-flex align-items-center gap-0.5" 
                                                            onclick="viewDetails(3)">
                                                        Chi tiết <span class="material-symbols-outlined fs-6">arrow_right_alt</span>
                                                    </button>
                                                    <button class="btn btn-link p-0 text-decoration-none text-secondary small" 
                                                            id="btn-read-3" onclick="markAsRead(3)">
                                                        Đánh dấu đã đọc
                                                    </button>
                                                </div>
                                            </div>
                                            <button class="btn btn-link text-secondary p-1 rounded-circle hover-bg-light notif-delete-btn" 
                                                    onclick="deleteNotif(3)" style="position: absolute; right: 12px; bottom: 12px;">
                                                <span class="material-symbols-outlined fs-5">delete</span>
                                            </button>
                                        </div>

                                        <!-- Item 4: Warning (Read) -->
                                        <div class="notif-item p-3 rounded-3 border-start border-4 border-warning d-flex gap-3 position-relative" 
                                             data-status="read" data-type="warning" id="notif-4" style="background-color: #ffffff;">
                                            <div class="notif-icon-box rounded-circle d-flex align-items-center justify-content-center bg-warning-subtle text-warning"
                                                 style="width: 44px; height: 44px; flex-shrink: 0;">
                                                <span class="material-symbols-outlined fs-4">bookmark_check</span>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start gap-2">
                                                    <h5 class="notif-title fs-6 fw-semibold mb-1 text-dark">
                                                        Sách đặt chỗ đã sẵn sàng nhận
                                                    </h5>
                                                    <span class="text-secondary small font-monospace">2 ngày trước</span>
                                                </div>
                                                <p class="notif-summary text-secondary small mb-2 text-truncate" style="max-width: 520px;">
                                                    Cuốn sách "Introduction to Algorithms" mà bạn đặt trước đã có sẵn tại quầy lưu thông.
                                                </p>
                                                <div class="d-none notif-full-content">
                                                    Chào sinh viên,<br><br>
                                                    Yêu cầu đăng ký giữ chỗ sách (Reservation) của bạn đã được hệ thống phê duyệt thành công:<br>
                                                    - <strong>Tên sách:</strong> Introduction to Algorithms, 3rd Edition<br>
                                                    - <strong>Mã bản sao:</strong> ITA-3-B4<br>
                                                    - <strong>Vị trí kho:</strong> Kệ A3, Khu vực Giáo trình Tin học<br>
                                                    - <strong>Thời hạn giữ sách:</strong> 48 tiếng (Hạn chót nhận sách: 17:00 ngày 08/06/2026).<br><br>
                                                    Vui lòng mang theo Thẻ sinh viên đến quầy lưu thông tầng 1 để nhận sách. Sau thời gian trên, nếu bạn không đến nhận, hệ thống sẽ tự động hủy quyền ưu tiên đặt chỗ và chuyển tiếp sách cho bạn đọc tiếp theo trong hàng đợi.
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-link p-0 text-decoration-none text-primary-custom fw-bold small d-flex align-items-center gap-0.5" 
                                                            onclick="viewDetails(4)">
                                                        Chi tiết <span class="material-symbols-outlined fs-6">arrow_right_alt</span>
                                                    </button>
                                                </div>
                                            </div>
                                            <button class="btn btn-link text-secondary p-1 rounded-circle hover-bg-light notif-delete-btn" 
                                                    onclick="deleteNotif(4)" style="position: absolute; right: 12px; bottom: 12px;">
                                                <span class="material-symbols-outlined fs-5">delete</span>
                                            </button>
                                        </div>

                                        <!-- Item 5: Error (Unread) -->
                                        <div class="notif-item p-3 rounded-3 border-start border-4 border-danger d-flex gap-3 position-relative" 
                                             data-status="unread" data-type="error" id="notif-5" style="background-color: rgba(217, 119, 6, 0.03);">
                                            <div class="notif-icon-box rounded-circle d-flex align-items-center justify-content-center bg-danger-subtle text-danger"
                                                 style="width: 44px; height: 44px; flex-shrink: 0;">
                                                <span class="material-symbols-outlined fs-4">gavel</span>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start gap-2">
                                                    <h5 class="notif-title fs-6 fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                                                        Phát sinh hóa đơn tiền phạt quá hạn
                                                        <span class="rounded-circle d-inline-block bg-primary-custom" style="width: 8px; height: 8px;" id="dot-5"></span>
                                                    </h5>
                                                    <span class="text-secondary small font-monospace">3 ngày trước</span>
                                                </div>
                                                <p class="notif-summary text-secondary small mb-2 text-truncate" style="max-width: 520px;">
                                                    Bạn bị phạt 15,000 VND do trả sách quá hạn 3 ngày đối với cuốn "SQL Performance Explained".
                                                </p>
                                                <div class="d-none notif-full-content">
                                                    Chào bạn,<br><br>
                                                    Hệ thống lưu trữ ghi nhận bạn đã phát sinh khoản tiền phạt quá hạn như sau:<br>
                                                    - <strong>Tên sách trả muộn:</strong> SQL Performance Explained<br>
                                                    - <strong>Thời hạn trả ban đầu:</strong> 31/05/2026<br>
                                                    - <strong>Ngày trả thực tế:</strong> 03/06/2026 (Quá hạn 3 ngày)<br>
                                                    - <strong>Mức phạt:</strong> 5,000 VND / ngày quá hạn.<br>
                                                    - <strong>Tổng số tiền phạt phát sinh:</strong> <strong class="text-danger">15,000 VND</strong>.<br><br>
                                                    Vui lòng thực hiện thanh toán hóa đơn này trực tuyến qua cổng VNPAY của thư viện hoặc thanh toán tiền mặt trực tiếp tại quầy lưu thông để khôi phục quyền mượn tài liệu mới.
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-link p-0 text-decoration-none text-primary-custom fw-bold small d-flex align-items-center gap-0.5" 
                                                            onclick="viewDetails(5)">
                                                        Chi tiết <span class="material-symbols-outlined fs-6">arrow_right_alt</span>
                                                    </button>
                                                    <button class="btn btn-link p-0 text-decoration-none text-secondary small" 
                                                            id="btn-read-5" onclick="markAsRead(5)">
                                                        Đánh dấu đã đọc
                                                    </button>
                                                </div>
                                            </div>
                                            <button class="btn btn-link text-secondary p-1 rounded-circle hover-bg-light notif-delete-btn" 
                                                    onclick="deleteNotif(5)" style="position: absolute; right: 12px; bottom: 12px;">
                                                <span class="material-symbols-outlined fs-5">delete</span>
                                            </button>
                                        </div>

                                    </div>
                                    
                                    <!-- Empty State Layout (hidden by default) -->
                                    <div class="text-center py-5 d-none animate-in" id="emptyState">
                                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-light text-secondary mb-3"
                                             style="width: 80px; height: 80px;">
                                            <span class="material-symbols-outlined" style="font-size: 40px;">mail_outline</span>
                                        </div>
                                        <h4 class="fw-bold text-dark mb-1">Không có thông báo nào</h4>
                                        <p class="text-secondary small mb-3">Hộp thư của bạn hiện tại hoàn toàn trống.</p>
                                        <a href="${pageContext.request.contextPath}/student/dashboard" 
                                           class="btn btn-primary-custom rounded-pill px-4 py-2 fw-semibold">
                                            Về bảng điều khiển
                                        </a>
                                    </div>
                                    
                                </div>
                            </div>

                        </div><!-- /.raised-card -->
                    </div><!-- /.col-lg-8 -->

                    <!-- Right Area: Stats & Quick Controls (Narrow, 4 Columns) -->
                    <div class="col-12 col-lg-4">
                        
                        <!-- Mini statistics block widget -->
                        <div class="raised-card shadow-sm p-4 mb-4">
                            <h5 class="fw-bold text-dark mb-3">Trạng thái hộp thư</h5>
                            <div class="d-flex flex-column gap-3">
                                <div class="d-flex justify-content-between align-items-center p-3 rounded-3 bg-light">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="material-symbols-outlined text-primary-custom">drafts</span>
                                        <span class="small fw-semibold text-secondary">Tổng số thông báo</span>
                                    </div>
                                    <span class="fw-bold text-dark" id="totalCountDisplay">5</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center p-3 rounded-3 bg-light">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="material-symbols-outlined text-warning">mail</span>
                                        <span class="small fw-semibold text-secondary">Chưa đọc</span>
                                    </div>
                                    <span class="fw-bold text-dark" id="unreadCountDisplay">3</span>
                                </div>
                            </div>
                        </div>

                        <!-- Notification Settings Card -->
                        <div class="raised-card shadow-sm p-4 mb-4">
                            <h5 class="fw-bold text-dark mb-3">Tùy chọn thông báo</h5>
                            <div class="d-flex flex-column gap-3">
                                <div class="form-check form-switch d-flex justify-content-between align-items-center ps-0">
                                    <label class="form-check-label small fw-semibold text-secondary" for="emailSettings">
                                        Gửi email nhắc nhở trả sách
                                    </label>
                                    <input class="form-check-input ms-2" type="checkbox" role="switch" id="emailSettings" checked>
                                </div>
                                <div class="form-check form-switch d-flex justify-content-between align-items-center ps-0">
                                    <label class="form-check-label small fw-semibold text-secondary" for="fineSettings">
                                        Nhận thông báo hóa đơn phạt
                                    </label>
                                    <input class="form-check-input ms-2" type="checkbox" role="switch" id="fineSettings" checked>
                                </div>
                                <div class="form-check form-switch d-flex justify-content-between align-items-center ps-0">
                                    <label class="form-check-label small fw-semibold text-secondary" for="eventSettings">
                                        Tin tức & hoạt động thư viện
                                    </label>
                                    <input class="form-check-input ms-2" type="checkbox" role="switch" id="eventSettings">
                                </div>
                                <button class="btn btn-outline-primary-custom rounded-pill w-100 py-2 mt-2" onclick="saveSettings()">
                                    Lưu thiết lập
                                </button>
                            </div>
                        </div>

                        <!-- Library policy note card -->
                        <div class="raised-card shadow-sm p-4" style="background-color: rgba(217, 119, 6, 0.05); border: 1px solid rgba(217, 119, 6, 0.1);">
                            <div class="d-flex align-items-start gap-3">
                                <span class="material-symbols-outlined text-primary-custom fs-4">info</span>
                                <div>
                                    <h6 class="fw-bold text-dark mb-1">Chính sách nhắc nhở</h6>
                                    <p class="small text-secondary mb-0" style="line-height: 1.5;">
                                        Hệ thống thư viện tự động gửi cảnh báo qua Email và Hộp thư thông báo cá nhân **3 ngày** trước khi sách hết hạn mượn. 
                                        Độc giả có trách nhiệm kiểm tra hòm thư thường xuyên để tránh phát sinh chi phí quá hạn.
                                    </p>
                                </div>
                            </div>
                        </div>

                    </div><!-- /.col-lg-4 -->

                </div><!-- /.row -->

            </div><!-- /.container-xl -->

            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.main-wrapper -->


    <!-- ════════════════ DETAILS MODAL ════════════════ -->
    <div class="modal fade" id="notifDetailsModal" tabindex="-1" aria-labelledby="notifDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius: 1rem; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header border-bottom px-4 py-3" style="background-color: #f7f9fb;">
                    <div class="d-flex align-items-center gap-2">
                        <div class="modal-icon-box rounded-circle d-flex align-items-center justify-content-center" 
                             id="modalIconContainer" style="width: 36px; height: 36px;">
                            <span class="material-symbols-outlined" id="modalIcon">info</span>
                        </div>
                        <h5 class="modal-title fw-bold text-dark" id="notifDetailsModalLabel">Chi tiết thông báo</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" data-bs-target="#notifDetailsModal" 
                            data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <span class="badge rounded-pill fw-bold" id="modalTypeBadge" style="padding: 6px 12px; font-size: 11px;">LOẠI</span>
                        <span class="text-secondary small font-monospace" id="modalTime">Thời gian</span>
                    </div>
                    <h4 class="fw-bold text-dark mb-3" id="modalTitle">Tiêu đề thông báo</h4>
                    <div class="text-secondary small" id="modalContent" style="line-height: 1.6; font-size: 14.5px;">
                        Nội dung thông báo đầy đủ.
                    </div>
                </div>
                <div class="modal-footer border-top px-4 py-3 bg-light">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                    <a href="#" class="btn btn-primary-custom rounded-pill px-4" id="modalActionBtn">Xử lý ngay</a>
                </div>
            </div>
        </div>
    </div>


    <!-- ════════════════ MICRO-INTERACTION SCRIPTS ════════════════ -->
    <script>
        let currentTab = 'all';

        // View full notification in modal dialog
        function viewDetails(id) {
            const item = document.getElementById('notif-' + id);
            if (!item) return;

            // Get data from row
            const title = item.querySelector('.notif-title').innerText.replace('Sách mượn sắp hết hạn', 'Sách mượn sắp hết hạn').trim();
            const time = item.querySelector('.font-monospace').innerText;
            const fullContent = item.querySelector('.notif-full-content').innerHTML;
            const type = item.getAttribute('data-type');

            // Setup Modal Icons & Badges mapping
            const iconBox = document.getElementById('modalIconContainer');
            const icon = document.getElementById('modalIcon');
            const badge = document.getElementById('modalTypeBadge');
            const actionBtn = document.getElementById('modalActionBtn');

            // Reset classes
            iconBox.className = "modal-icon-box rounded-circle d-flex align-items-center justify-content-center ";
            badge.className = "badge rounded-pill fw-bold ";

            if (type === 'warning') {
                iconBox.classList.add('bg-warning-subtle', 'text-warning');
                icon.innerText = "warning";
                badge.classList.add('bg-warning-subtle', 'text-warning');
                badge.innerText = "CẢNH BÁO";
                actionBtn.innerText = "Gia hạn / Trả sách";
                actionBtn.href = "${pageContext.request.contextPath}/student/loans";
                actionBtn.style.display = "inline-block";
            } else if (type === 'success') {
                iconBox.classList.add('bg-success-subtle', 'text-success');
                icon.innerText = "check_circle";
                badge.classList.add('bg-success-subtle', 'text-success');
                badge.innerText = "THÀNH CÔNG";
                actionBtn.style.display = "none";
            } else if (type === 'error') {
                iconBox.classList.add('bg-danger-subtle', 'text-danger');
                icon.innerText = "gavel";
                badge.classList.add('bg-danger-subtle', 'text-danger');
                badge.innerText = "PHIẾU PHẠT";
                actionBtn.innerText = "Thanh toán ngay";
                actionBtn.href = "${pageContext.request.contextPath}/student/my-fines.jsp";
                actionBtn.style.display = "inline-block";
            } else {
                iconBox.classList.add('bg-info-subtle', 'text-info');
                icon.innerText = "campaign";
                badge.classList.add('bg-info-subtle', 'text-info');
                badge.innerText = "THÔNG TIN CHUNG";
                actionBtn.style.display = "none";
            }

            // Fill text
            document.getElementById('modalTitle').innerText = title;
            document.getElementById('modalTime').innerText = time;
            document.getElementById('modalContent').innerHTML = fullContent;

            // Mark as read when opened
            markAsRead(id);

            // Show modal
            const myModal = new bootstrap.Modal(document.getElementById('notifDetailsModal'));
            myModal.show();
        }

        // Mark single notification as read
        function markAsRead(id) {
            const item = document.getElementById('notif-' + id);
            if (!item || item.getAttribute('data-status') === 'read') return;

            item.setAttribute('data-status', 'read');
            item.style.backgroundColor = '#ffffff';
            
            // Remove unread indicators
            const dot = document.getElementById('dot-' + id);
            if (dot) dot.remove();
            
            const btn = document.getElementById('btn-read-' + id);
            if (btn) btn.remove();

            const title = item.querySelector('.notif-title');
            if (title) title.className = "notif-title fs-6 fw-semibold mb-1 text-dark";

            // Update Counts
            updateCounts();
            
            // Apply filtering in case tab active is 'unread'
            filterNotifications();
        }

        // Delete single notification
        function deleteNotif(id) {
            const item = document.getElementById('notif-' + id);
            if (!item) return;

            item.classList.add('animate-out');
            setTimeout(() => {
                item.remove();
                updateCounts();
                checkEmptyState();
            }, 300);
        }

        // Mark all as read
        function markAllAsRead() {
            document.querySelectorAll('.notif-item[data-status="unread"]').forEach(item => {
                const id = item.id.replace('notif-', '');
                markAsRead(id);
            });
            showToast("Thành công", "Đã đánh dấu tất cả thông báo là đã đọc.");
        }

        // Delete all
        function deleteAllNotifications() {
            if (confirm("Bạn có chắc chắn muốn xóa toàn bộ thông báo trong hộp thư không?")) {
                document.querySelectorAll('.notif-item').forEach(item => {
                    item.remove();
                });
                updateCounts();
                checkEmptyState();
                showToast("Thành công", "Đã dọn dẹp sạch sẽ hộp thư thông báo.");
            }
        }

        // Filter search input & type select
        function filterNotifications() {
            const searchVal = document.getElementById('searchNotifInput').value.toLowerCase().trim();
            const typeVal = document.getElementById('filterType').value;
            let visibleCount = 0;

            document.querySelectorAll('.notif-item').forEach(item => {
                const title = item.querySelector('.notif-title').innerText.toLowerCase();
                const summary = item.querySelector('.notif-summary').innerText.toLowerCase();
                const type = item.getAttribute('data-type');
                const status = item.getAttribute('data-status');

                // Search check
                const matchSearch = title.includes(searchVal) || summary.includes(searchVal);
                // Type select check
                const matchType = (typeVal === 'all') || (type === typeVal);
                // Tab category check
                let matchTab = true;
                if (currentTab === 'unread') matchTab = (status === 'unread');
                else if (currentTab === 'read') matchTab = (status === 'read');

                if (matchSearch && matchType && matchTab) {
                    item.classList.remove('d-none');
                    visibleCount++;
                } else {
                    item.classList.add('d-none');
                }
            });

            const listContainer = document.getElementById('notificationsList');
            const emptyState = document.getElementById('emptyState');
            if (visibleCount === 0) {
                listContainer.classList.add('d-none');
                emptyState.classList.remove('d-none');
            } else {
                listContainer.classList.remove('d-none');
                emptyState.classList.add('d-none');
            }
        }

        // Tab selection change
        function changeTab(tab) {
            currentTab = tab;
            
            // Adjust active tab buttons look
            document.querySelectorAll('#notifTabs .nav-link').forEach(link => {
                link.classList.remove('active', 'fw-bold', 'text-dark');
                link.classList.add('fw-semibold', 'text-secondary');
            });
            
            const activeLink = document.getElementById(tab + '-tab');
            if (activeLink) {
                activeLink.classList.remove('fw-semibold', 'text-secondary');
                activeLink.classList.add('active', 'fw-bold', 'text-dark');
            }

            filterNotifications();
        }

        // Calculate and refresh displays
        function updateCounts() {
            const total = document.querySelectorAll('.notif-item').length;
            const unread = document.querySelectorAll('.notif-item[data-status="unread"]').length;

            document.getElementById('totalCountDisplay').innerText = total;
            document.getElementById('unreadCountDisplay').innerText = unread;
            
            // Update unread tab badge
            const unreadBadge = document.querySelector('#unread-tab .badge');
            if (unreadBadge) {
                unreadBadge.innerText = unread;
                if (unread === 0) {
                    unreadBadge.classList.add('bg-secondary');
                    unreadBadge.classList.remove('bg-primary-custom');
                } else {
                    unreadBadge.classList.add('bg-primary-custom');
                    unreadBadge.classList.remove('bg-secondary');
                }
            }
        }

        // Empty checks
        function checkEmptyState() {
            const total = document.querySelectorAll('.notif-item').length;
            if (total === 0) {
                document.getElementById('notificationsList').classList.add('d-none');
                document.getElementById('emptyState').classList.remove('d-none');
                // Adjust counts tab
                const unreadBadge = document.querySelector('#unread-tab .badge');
                if (unreadBadge) unreadBadge.innerText = "0";
            }
        }

        // Mock Toast Trigger Helper
        function showToast(title, msg) {
            // Check if there is a toast container in the main header, otherwise alert
            alert(title + ": " + msg);
        }

        // Save preferences mockup
        function saveSettings() {
            alert("Đã lưu thiết lập tùy chọn kênh thông báo thành công!");
        }
    </script>

    <style>
        /* Extra styles specific to notifications page */
        .notif-item {
            transition: transform 0.22s ease-out, box-shadow 0.22s ease-out, opacity 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
            border: 1px solid #e5e5e5;
        }
        .notif-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.04);
        }
        .notif-delete-btn {
            opacity: 0;
            transition: opacity 0.2s ease, background-color 0.2s ease;
        }
        .notif-item:hover .notif-delete-btn {
            opacity: 1;
        }
        @keyframes fadeOutShrink {
            to {
                opacity: 0;
                transform: translateX(30px);
                max-height: 0;
                padding: 0 !important;
                margin: 0 !important;
                border: none;
            }
        }
        .animate-out {
            animation: fadeOutShrink 0.3s ease-out forwards;
            pointer-events: none;
        }
        .nav-tabs .nav-link.active {
            border-bottom: 3px solid var(--primary) !important;
        }
    </style>

</body>
</html>
