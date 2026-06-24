<%-- Fragment: _user_import_modal.jsp — Modal nhập tài khoản người dùng hàng loạt --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="modal fade" id="importUserModal" tabindex="-1" aria-labelledby="importUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 raised-card">
            
            <div class="modal-header bg-white border-bottom border-outline-variant py-3 px-4">
                <h5 class="modal-title fw-bold text-primary-custom d-flex align-items-center gap-2" id="importUserModalLabel">
                    <span class="material-symbols-outlined">upload_file</span> Nhập tài khoản hàng loạt
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin/user/import" method="POST" enctype="multipart/form-data" id="importUserForm">
                <div class="modal-body p-4">
                    
                    <!-- ─── Báo lỗi Phase 1 All-or-Nothing ─── -->
                    <c:if test="${not empty sessionScope.importErrors}">
                        <div class="alert alert-danger rounded-3 mb-4" role="alert">
                            <h6 class="fw-bold d-flex align-items-center gap-2 mb-2">
                                <span class="material-symbols-outlined">report</span> Phát hiện lỗi dữ liệu (Hủy bỏ toàn bộ tiến trình)
                            </h6>
                            <div class="custom-scrollbar" style="max-height: 200px; overflow-y: auto; font-size: 13px;">
                                <ul class="mb-0 ps-3">
                                    <c:forEach var="errLine" items="${fn:split(sessionScope.importErrors, '
')}">
                                        <c:if test="${not empty fn:trim(errLine)}">
                                            <li><c:out value="${errLine}" /></li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <c:remove var="importErrors" scope="session" />
                    </c:if>
                    
                    <div class="row g-3">
                        <!-- Chọn vai trò chung -->
                        <div class="col-12 col-md-6">
                            <label for="importRole" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Vai trò áp dụng cho tệp này <span class="text-danger">*</span></label>
                            <select class="form-select config-input w-100" id="importRole" name="role" required>
                                <option value="STUDENT" selected>Độc giả Sinh viên (STUDENT)</option>
                                <option value="LECTURER">Độc giả Giảng viên (LECTURER)</option>
                                <option value="LIBRARIAN">Thủ thư (LIBRARIAN)</option>
                                <option value="MANAGER">Quản lý Thư viện (MANAGER)</option>
                                <option value="ADMIN">Quản trị viên (ADMIN)</option>
                            </select>
                            <div class="form-text" style="font-size: 11px;">Tệp Excel không được định nghĩa vai trò; Admin bắt buộc chọn vai trò chung tại đây (BR-13).</div>
                        </div>

                        <!-- Chọn file Excel -->
                        <div class="col-12 col-md-6">
                            <label for="importFile" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Chọn tệp Excel (.xlsx) <span class="text-danger">*</span></label>
                            <input class="form-control config-input w-100" type="file" id="importFile" name="file" accept=".xlsx" required>
                            <div class="form-text" style="font-size: 11px;">Hỗ trợ tệp Excel chuẩn (.xlsx).</div>
                        </div>
                    </div>

                    <!-- Hướng dẫn cấu trúc cột -->
                    <div class="mt-4 p-3 rounded-3" style="background-color: var(--surface-container-low); border: 1px solid var(--outline-variant);">
                        <h6 class="fw-semibold text-primary-custom mb-2 d-flex align-items-center gap-1" style="font-size: 14px;">
                            <span class="material-symbols-outlined" style="font-size: 18px;">article</span> Hướng dẫn định dạng tệp Excel
                        </h6>
                        <p class="mb-2 text-on-surface-variant" style="font-size: 12px; line-height: 1.5;">
                            Tệp dữ liệu của bạn phải có các cột theo đúng thứ tự sau đây (dòng đầu tiên là dòng tiêu đề):
                        </p>
                        <div class="table-responsive">
                            <table class="table table-sm table-bordered bg-white mb-2 text-center" style="font-size: 11px;">
                                <thead style="background-color: #f4f3f2;">
                                    <tr>
                                        <th>Cột 1</th>
                                        <th>Cột 2</th>
                                        <th>Cột 3</th>
                                        <th>Cột 4</th>
                                        <th>Cột 5</th>
                                        <th>Cột 6</th>
                                        <th>Cột 7</th>
                                        <th>Cột 8</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="fw-bold">Email</td>
                                        <td class="fw-bold">Họ và tên</td>
                                        <td>SĐT</td>
                                        <td>Giới tính</td>
                                        <td class="fw-bold">Ngày sinh</td>
                                        <td class="fw-bold">Mã số</td>
                                        <td>Bổ sung 1</td>
                                        <td>Bổ sung 2</td>
                                    </tr>
                                    <tr class="text-muted">
                                        <td>(Bắt buộc)</td>
                                        <td>(Bắt buộc)</td>
                                        <td>(Tùy chọn)</td>
                                        <td>Nam/Nữ/Khác</td>
                                        <td>yyyy-MM-dd</td>
                                        <td>(Bắt buộc)</td>
                                        <td>Major/Dept</td>
                                        <td>Enroll Year</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <span class="text-on-surface-variant" style="font-size: 11px;">Mật khẩu mặc định sau khi import sẽ là địa chỉ Email.</span>
                            <a href="${pageContext.request.contextPath}/admin/user/import/template" 
                               class="btn btn-sm btn-outline-secondary d-flex align-items-center gap-1 text-decoration-none fw-bold" 
                               style="font-size: 12px; border-radius: 6px;">
                                <span class="material-symbols-outlined" style="font-size: 16px;">download</span> Tải tệp mẫu (.xlsx)
                            </a>
                        </div>
                    </div>

                </div>
                
                <div class="modal-footer bg-surface-container-low border-top border-outline-variant py-3 px-4">
                    <button type="button" class="btn btn-outline-secondary rounded-3 px-3 fw-bold" style="font-size: 14px;" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary-custom rounded-3 px-4 fw-bold" style="font-size: 14px;">Thực hiện Import</button>
                </div>
            </form>

        </div>
    </div>
</div>

<!-- Tự động hiển thị modal nếu phát hiện lỗi import từ session -->
<c:if test="${not empty sessionScope.importErrors or param.showImportModal eq 'true'}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var myModal = new bootstrap.Modal(document.getElementById('importUserModal'), {});
            myModal.show();
        });
    </script>
</c:if>
