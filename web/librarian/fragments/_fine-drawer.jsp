<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 6. Fine Detail Side Drawer -->
<div class="side-drawer-backdrop" id="drawerBackdrop" onclick="closeDrawer()"></div>
<div class="side-drawer" id="fineDrawer">
    <div class="side-drawer-header">
        <h4 class="mb-0 fw-bold text-primary-custom" style="font-size: 20px;">Chi tiết tiền phạt</h4>
        <button type="button" class="btn-close" onclick="closeDrawer()" aria-label="Đóng"></button>
    </div>
    <div class="side-drawer-body">
        <!-- Fine Summary Header -->
        <div class="p-3 rounded-3 mb-4 d-flex align-items-center justify-content-between" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
            <div>
                <span class="text-muted small">Số tiền phạt</span>
                <h3 class="mb-0 fw-bold text-danger" id="drawerFineAmount">$0.00</h3>
            </div>
            <span class="status-badge" id="drawerFineStatus">UNPAID</span>
        </div>

        <!-- Fine Information -->
        <h5 class="fw-bold text-on-surface-variant border-bottom pb-2 mb-3">Thông tin tiền phạt</h5>
        <div class="row g-2 mb-4 small">
            <div class="col-6"><span class="text-muted">Mã phạt:</span> <span class="fw-bold" id="drawerFineId">FINE-0000</span></div>
            <div class="col-6"><span class="text-muted">Loại phạt:</span> <span class="fw-bold" id="drawerFineType">Late Return</span></div>
            <div class="col-6"><span class="text-muted">Ngày tạo:</span> <span class="fw-bold">Jun 02, 2026</span></div>
            <div class="col-6"><span class="text-muted">Người tạo:</span> <span class="fw-bold">System Daemon</span></div>
        </div>

        <!-- Member Info -->
        <h5 class="fw-bold text-on-surface-variant border-bottom pb-2 mb-3">Thông tin thành viên</h5>
        <div class="row g-2 mb-4 small">
            <div class="col-12"><span class="text-muted">Tên:</span> <span class="fw-bold" id="drawerMemberName">Jordan Vance</span></div>
            <div class="col-6"><span class="text-muted">Mã thành viên:</span> <span class="fw-bold" id="drawerMemberId">230014</span></div>
            <div class="col-6"><span class="text-muted">Loại thành viên:</span> <span class="fw-bold" id="drawerMemberType">Sinh viên</span></div>
        </div>

        <!-- Book Copy Information -->
        <h5 class="fw-bold text-on-surface-variant border-bottom pb-2 mb-3">Chi tiết bản sao sách</h5>
        <div class="row g-2 mb-4 small">
            <div class="col-12"><span class="text-muted">Tiêu đề sách:</span> <span class="fw-bold" id="drawerBookTitle">Introduction to Algorithms</span></div>
            <div class="col-6"><span class="text-muted">Mã vạch:</span> <span class="fw-bold" id="drawerBarcode">LMS-BK-10293</span></div>
            <div class="col-6"><span class="text-muted">ISBN:</span> <span class="fw-bold">978-0262033848</span></div>
        </div>

        <!-- Calculation Detail -->
        <h5 class="fw-bold text-on-surface-variant border-bottom pb-2 mb-3">Chi tiết tính toán & Ngày quá hạn</h5>
        <div class="mb-4 small">
            <p class="mb-1"><span class="text-muted">Trạng thái quá hạn:</span> <span class="fw-bold" id="drawerOverdueDays">4 days</span></p>
            <div class="p-2 rounded-2 mt-2" style="background-color: var(--surface-container-low); font-family: monospace;" id="drawerCalculation">
                4 days × $3.00/day = $12.00
            </div>
        </div>

        <!-- Payment History -->
        <h5 class="fw-bold text-on-surface-variant border-bottom pb-2 mb-3">Lịch sử thanh toán</h5>
        <div class="small" id="drawerPaymentHistory">
            Chưa có thanh toán nào được ghi nhận.
        </div>
    </div>
    <div class="side-drawer-footer" id="drawerFooter">
        <button class="btn btn-primary-custom px-4 py-2 rounded-pill fw-bold" id="drawerCollectBtn">Thu tiền phạt</button>
        <button class="btn btn-outline-secondary px-4 py-2 rounded-pill fw-bold" id="drawerWaiveBtn">Miễn phạt</button>
    </div>
</div>
