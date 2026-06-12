<%-- Fragment: _user_create_modal.jsp — Modal thêm tài khoản đơn lẻ --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="modal fade" id="createUserModal" tabindex="-1" aria-labelledby="createUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 raised-card">
            
            <div class="modal-header bg-white border-bottom border-outline-variant py-3 px-4">
                <h5 class="modal-title fw-bold text-primary-custom d-flex align-items-center gap-2" id="createUserModalLabel">
                    <span class="material-symbols-outlined">person_add</span> Cấp tài khoản mới
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin/user/create" method="POST" id="createUserForm">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <!-- Cột 1: Thông tin cơ bản -->
                        <div class="col-12 col-md-6">
                            <label for="createEmail" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Địa chỉ Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control config-input w-100" id="createEmail" name="email" required placeholder="example@uni.edu.vn">
                        </div>
                        
                        <div class="col-12 col-md-6">
                            <label for="createFullName" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control config-input w-100" id="createFullName" name="fullName" required placeholder="Nguyễn Văn A">
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="createPhone" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control config-input w-100" id="createPhone" name="phoneNumber" placeholder="09xxxxxxxx" required pattern="[0-9]{10}" maxlength="10" title="Số điện thoại phải bao gồm đúng 10 chữ số">
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="createGender" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Giới tính</label>
                            <select class="form-select config-input w-100" id="createGender" name="gender">
                                <option value="Nam">Nam</option>
                                <option value="Nữ">Nữ</option>
                                <option value="Khác" selected>Khác</option>
                            </select>
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="createDob" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Ngày sinh <span class="text-danger">*</span></label>
                            <input type="date" class="form-control config-input w-100" id="createDob" name="dateOfBirth" required>
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="createRole" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Vai trò hệ thống <span class="text-danger">*</span></label>
                            <select class="form-select config-input w-100" id="createRole" name="role" required>
                                <option value="STUDENT" selected>Độc giả Sinh viên (STUDENT)</option>
                                <option value="LECTURER">Độc giả Giảng viên (LECTURER)</option>
                                <option value="LIBRARIAN">Thủ thư (LIBRARIAN)</option>
                                <option value="MANAGER">Quản lý Thư viện (MANAGER)</option>
                                <option value="ADMIN">Quản trị viên (ADMIN)</option>
                            </select>
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="createCode" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;" id="codeLabel">Mã sinh viên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control config-input w-100" id="createCode" name="code" required placeholder="HE170001">
                        </div>

                        <!-- Cột 2: Thông tin mở rộng động theo vai trò -->
                        <div class="col-12" id="studentFields">
                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <label for="createMajor" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Chuyên ngành</label>
                                    <input type="text" class="form-control config-input w-100" id="createMajor" name="major" placeholder="Kỹ thuật phần mềm">
                                </div>
                                <div class="col-12 col-md-6">
                                    <label for="createEnrollmentYear" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Năm nhập học</label>
                                    <input type="number" class="form-control config-input w-100" id="createEnrollmentYear" name="enrollmentYear" placeholder="2023" min="1900" max="2100">
                                </div>
                            </div>
                        </div>

                        <div class="col-12 d-none" id="lecturerFields">
                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <label for="createDepartment" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Khoa / Bộ môn</label>
                                    <input type="text" class="form-control config-input w-100" id="createDepartment" name="department" placeholder="Công nghệ thông tin">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-info rounded-3 mt-4 mb-0" role="alert" style="font-size: 13px;">
                        <span class="material-symbols-outlined me-1" style="font-size: 18px;">info</span>
                        <strong>Lưu ý:</strong> Mật khẩu mặc định của tài khoản sau khi tạo sẽ được gán bằng chính <strong>địa chỉ Email</strong> (BR-12). Người dùng bắt buộc phải thực hiện thay đổi mật khẩu trong lần đầu tiên truy cập.
                    </div>
                </div>
                
                <div class="modal-footer bg-surface-container-low border-top border-outline-variant py-3 px-4">
                    <button type="button" class="btn btn-outline-secondary rounded-3 px-3 fw-bold" style="font-size: 14px;" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary-custom rounded-3 px-4 fw-bold" style="font-size: 14px;">Lưu tài khoản</button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const roleSelect = document.getElementById("createRole");
    const codeLabel = document.getElementById("codeLabel");
    const codeInput = document.getElementById("createCode");
    const studentFields = document.getElementById("studentFields");
    const lecturerFields = document.getElementById("lecturerFields");
    const phoneInput = document.getElementById("createPhone");

    // Ngăn chặn nhập ký tự chữ vào ô số điện thoại
    phoneInput.addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    roleSelect.addEventListener("change", function () {
        const role = this.value;
        
        // Ẩn tất cả các trường mở rộng trước
        studentFields.classList.add("d-none");
        lecturerFields.classList.add("d-none");

        // Cập nhật nhãn và placeholders dựa vào vai trò
        if (role === "STUDENT") {
            codeLabel.innerHTML = 'Mã sinh viên <span class="text-danger">*</span>';
            codeInput.placeholder = "HE170001";
            studentFields.classList.remove("d-none");
        } else if (role === "LECTURER") {
            codeLabel.innerHTML = 'Mã giảng viên <span class="text-danger">*</span>';
            codeInput.placeholder = "T10001";
            lecturerFields.classList.remove("d-none");
        } else {
            codeLabel.innerHTML = 'Mã nhân viên <span class="text-danger">*</span>';
            codeInput.placeholder = "NV0001";
        }
    });
});
</script>
