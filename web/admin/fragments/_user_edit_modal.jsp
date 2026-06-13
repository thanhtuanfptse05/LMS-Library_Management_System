<%-- Fragment: _user_edit_modal.jsp — Modal chi tiết và cập nhật thông tin người dùng --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 raised-card">
            
            <div class="modal-header bg-white border-bottom border-outline-variant py-3 px-4">
                <h5 class="modal-title fw-bold text-primary-custom d-flex align-items-center gap-2" id="editUserModalLabel">
                    <span class="material-symbols-outlined">manage_accounts</span> Chi tiết tài khoản
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin/user/update" method="POST" id="editUserForm">
                <input type="hidden" name="action" value="updateInfo">
                <input type="hidden" name="userId" id="editUserId">
                
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <!-- Cột 1: Thông tin cơ bản -->
                        <div class="col-12 col-md-6">
                            <label for="editEmail" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Địa chỉ Email (Không thay đổi)</label>
                            <input type="email" class="form-control config-input w-100 bg-light" id="editEmail" name="email" readonly>
                        </div>
                        
                        <div class="col-12 col-md-6">
                            <label for="editFullName" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control config-input w-100" id="editFullName" name="fullName" required>
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="editPhone" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control config-input w-100" id="editPhone" name="phoneNumber" required pattern="[0-9]{10}" maxlength="10" title="Số điện thoại phải bao gồm đúng 10 chữ số">
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="editGender" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Giới tính</label>
                            <select class="form-select config-input w-100" id="editGender" name="gender">
                                <option value="Nam">Nam</option>
                                <option value="Nữ">Nữ</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="editDob" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Ngày sinh <span class="text-danger">*</span></label>
                            <input type="date" class="form-control config-input w-100" id="editDob" name="dateOfBirth" required>
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="editRoleDisplay" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Vai trò hệ thống</label>
                            <input type="text" class="form-control config-input w-100 bg-light" id="editRoleDisplay" readonly>
                        </div>

                        <div class="col-12 col-md-6">
                            <label for="editCode" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;" id="editCodeLabel">Mã số định danh <span class="text-danger">*</span></label>
                            <input type="text" class="form-control config-input w-100" id="editCode" name="code" required>
                        </div>

                        <!-- Trạng thái và khóa -->
                        <div class="col-12 col-md-6">
                            <label for="editStatus" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Trạng thái tài khoản</label>
                            <select class="form-select config-input w-100" id="editStatus" name="status">
                                <option value="active">Hoạt động (active)</option>
                                <option value="locked">Bị khóa (locked)</option>
                            </select>
                        </div>

                        <div class="col-12 col-md-6 d-none" id="lockReasonContainer">
                            <label for="editLockReason" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Lý do khóa tài khoản</label>
                            <select class="form-select config-input w-100" id="editLockReason" name="lockReason">
                                <option value="adminban">Bị cấm bởi Admin (adminban)</option>
                                <option value="unpaid">Nợ tiền phạt thư viện (unpaid)</option>
                                <option value="securitybreach">Vi phạm bảo mật / Đăng nhập sai nhiều lần (securitybreach)</option>
                            </select>
                        </div>

                        <!-- Cột 2: Thông tin mở rộng động theo vai trò -->
                        <div class="col-12 d-none" id="editStudentFields">
                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <label for="editMajor" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Chuyên ngành</label>
                                    <input type="text" class="form-control config-input w-100" id="editMajor" name="major">
                                </div>
                                <div class="col-12 col-md-6">
                                    <label for="editEnrollmentYear" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Năm nhập học</label>
                                    <input type="number" class="form-control config-input w-100" id="editEnrollmentYear" name="enrollmentYear" min="1900" max="2100">
                                </div>
                            </div>
                        </div>

                        <div class="col-12 d-none" id="editLecturerFields">
                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <label for="editDepartment" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Khoa / Bộ môn</label>
                                    <input type="text" class="form-control config-input w-100" id="editDepartment" name="department">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer bg-surface-container-low border-top border-outline-variant py-3 px-4">
                    <button type="button" class="btn btn-outline-secondary rounded-3 px-3 fw-bold" style="font-size: 14px;" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary-custom rounded-3 px-4 fw-bold" style="font-size: 14px;">Cập nhật thông tin</button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const editStatus = document.getElementById("editStatus");
    const lockReasonContainer = document.getElementById("lockReasonContainer");
    const editPhoneInput = document.getElementById("editPhone");

    // Ngăn chặn nhập ký tự chữ vào ô số điện thoại
    editPhoneInput.addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
    
    // Lắng nghe sự thay đổi trạng thái trong modal edit
    editStatus.addEventListener("change", function () {
        if (this.value === "locked") {
            lockReasonContainer.classList.remove("d-none");
        } else {
            lockReasonContainer.classList.add("d-none");
        }
    });

    // Hàm load dữ liệu từ nút bấm Sửa vào form Modal
    window.populateEditModal = function (button) {
        const userId = button.getAttribute("data-userid");
        const email = button.getAttribute("data-email");
        const fullName = button.getAttribute("data-fullname");
        const phone = button.getAttribute("data-phone");
        const gender = button.getAttribute("data-gender");
        const dob = button.getAttribute("data-dob");
        const code = button.getAttribute("data-code");
        const role = button.getAttribute("data-role");
        const status = button.getAttribute("data-status");
        const lockReason = button.getAttribute("data-lockreason");
        const major = button.getAttribute("data-major");
        const year = button.getAttribute("data-year");
        const dept = button.getAttribute("data-dept");

        document.getElementById("editUserId").value = userId;
        document.getElementById("editEmail").value = email;
        document.getElementById("editFullName").value = fullName;
        document.getElementById("editPhone").value = phone;
        document.getElementById("editGender").value = gender;
        document.getElementById("editDob").value = dob;
        document.getElementById("editCode").value = code;
        document.getElementById("editRoleDisplay").value = role;
        document.getElementById("editStatus").value = status;

        if (status === "locked") {
            lockReasonContainer.classList.remove("d-none");
            document.getElementById("editLockReason").value = lockReason || "adminban";
        } else {
            lockReasonContainer.classList.add("d-none");
        }

        // Ẩn hiện các trường mở rộng
        const studentFields = document.getElementById("editStudentFields");
        const lecturerFields = document.getElementById("editLecturerFields");
        const editCodeLabel = document.getElementById("editCodeLabel");

        studentFields.classList.add("d-none");
        lecturerFields.classList.add("d-none");

        if (role === "STUDENT") {
            editCodeLabel.innerText = "Mã sinh viên *";
            document.getElementById("editMajor").value = major || "";
            document.getElementById("editEnrollmentYear").value = year || "";
            studentFields.classList.remove("d-none");
        } else if (role === "LECTURER") {
            editCodeLabel.innerText = "Mã giảng viên *";
            document.getElementById("editDepartment").value = dept || "";
            lecturerFields.classList.remove("d-none");
        } else {
            editCodeLabel.innerText = "Mã nhân viên *";
        }
    };
});
</script>
