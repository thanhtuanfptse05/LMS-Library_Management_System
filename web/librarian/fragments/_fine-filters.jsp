<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 2. Filters Bento Card -->
<div class="raised-card p-4 border border-outline-variant bg-white mb-4">
    <div class="row g-3">
        <div class="col-12 col-lg-4">
            <div class="position-relative">
                <span class="material-symbols-outlined position-absolute text-muted" style="left: 12px; top: 50%; transform: translateY(-50%);">search</span>
                <input type="text" class="form-control rounded-3 py-2 ps-5" placeholder="Tìm kiếm theo mã thành viên, tên, mã vạch, ISBN hoặc tiêu đề sách..." />
            </div>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <select class="form-select rounded-3 py-2">
                <option value="">Tất cả loại thành viên</option>
                <option value="STUDENT">Sinh viên</option>
                <option value="LECTURER">Giảng viên</option>
            </select>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <select class="form-select rounded-3 py-2">
                <option value="">Tất cả loại phạt</option>
                <option value="LATE">Trả muộn</option>
                <option value="LOST">Mất sách</option>
                <option value="DAMAGE">Hư hỏng sách</option>
                <option value="MANUAL">Phạt thủ công</option>
            </select>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <select class="form-select rounded-3 py-2">
                <option value="">Tất cả trạng thái phạt</option>
                <option value="UNPAID">Chưa thanh toán</option>
                <option value="PAID">Đã thanh toán</option>
                <option value="WAIVED">Đã miễn</option>
                <option value="PARTIAL">Một phần</option>
            </select>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <button class="btn btn-primary-custom w-100 py-2 rounded-3 d-flex align-items-center justify-content-center gap-2">
                <span class="material-symbols-outlined">tune</span>
                Bộ lọc
            </button>
        </div>
    </div>
</div>
