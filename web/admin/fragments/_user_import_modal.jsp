<%-- Fragment: _user_import_modal.jsp — Modal nhập tài khoản người dùng hàng loạt --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="modal fade" id="importUserModal" tabindex="-1" aria-labelledby="importUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 raised-card">
            
            <div class="modal-header bg-white border-bottom border-outline-variant py-3 px-4">
                <h5 class="modal-title fw-bold text-primary-custom d-flex align-items-center gap-2" id="importUserModalLabel">
                    <span class="material-symbols-outlined">upload_file</span> Nhập tài khoản hàng loạt
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            
            <c:choose>
                <c:when test="${empty sessionScope.userImportList}">
                    <form action="${pageContext.request.contextPath}/admin/user/import" method="POST" enctype="multipart/form-data" id="importUserForm">
                        <input type="hidden" name="action" value="upload">
                        <div class="modal-body p-4">
                            
                            <!-- Báo lỗi chung từ Controller (nếu có) -->
                            <c:if test="${not empty sessionScope.errorMessage}">
                                <div class="alert alert-danger rounded-3 mb-4 d-flex align-items-center gap-2" role="alert">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">error</span>
                                    <span class="flex-grow-1"><c:out value="${sessionScope.errorMessage}" /></span>
                                </div>
                                <c:remove var="errorMessage" scope="session" />
                            </c:if>
                            
                            <div class="row g-3">
                                <!-- Chọn vai trò chung -->
                                <div class="col-12 col-md-6">
                                    <label for="importRole" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px;">Vai trò áp dụng cho tệp này <span class="text-danger">*</span></label>
                                    <select class="form-select config-input w-100" id="importRole" name="role" required>
                                        <option value="STUDENT" selected>Độc giả Sinh viên (STUDENT)</option>
                                        <option value="LECTURER">Độc giả Giảng viên (LECTURER)</option>
                                        <option value="LIBRARIAN">Thủ thư (LIBRARIAN)</option>
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
                            <button type="submit" class="btn btn-primary-custom rounded-3 px-4 fw-bold" style="font-size: 14px;">Kiểm tra tệp</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="modal-body p-4">
                        
                        <!-- Báo lỗi chung từ Controller (nếu có) -->
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger rounded-3 mb-4 d-flex align-items-center gap-2" role="alert">
                                <span class="material-symbols-outlined" style="font-size: 20px;">error</span>
                                <span class="flex-grow-1"><c:out value="${sessionScope.errorMessage}" /></span>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h6 class="fw-bold text-on-surface mb-1" style="font-size: 15px;">Kết quả kiểm tra tệp dữ liệu</h6>
                                <p class="text-muted mb-0 small" style="font-size: 12.5px;">
                                    Tên tệp: <strong><c:out value="${sessionScope.userImportFileName}"/></strong> · 
                                    Vai trò: <strong><c:out value="${sessionScope.userImportRole}"/></strong> · 
                                    Tổng số: <strong>${sessionScope.userImportList.size()} dòng</strong>
                                </p>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${empty sessionScope.userImportErrors}">
                                        <span class="badge bg-success py-2 px-3 fw-bold rounded-pill" style="font-size: 11px;">Tệp hợp lệ</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger py-2 px-3 fw-bold rounded-pill" style="font-size: 11px;">${sessionScope.userImportErrors.size()} lỗi cần sửa</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Bảng hiển thị lỗi (nếu có) -->
                        <c:if test="${not empty sessionScope.userImportErrors}">
                            <div class="alert alert-danger rounded-3 mb-4" role="alert">
                                <h6 class="fw-bold d-flex align-items-center gap-2 mb-2" style="font-size: 13.5px;">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">report</span> Phát hiện lỗi dữ liệu (Hủy bỏ toàn bộ tiến trình)
                                </h6>
                                <div class="custom-scrollbar border rounded p-2 bg-white" style="max-height: 150px; overflow-y: auto; font-size: 12px; font-family: monospace;">
                                    <ul class="mb-0 ps-3 text-danger">
                                        <c:forEach var="errLine" items="${sessionScope.userImportErrors}">
                                            <li><c:out value="${errLine}" /></li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </c:if>

                        <!-- Xem trước danh sách người dùng (tối đa 10 dòng) -->
                        <h6 class="fw-bold text-on-surface mb-2 mt-3" style="font-size: 13px;">Danh sách dữ liệu xem trước (Tối đa 10 dòng)</h6>
                        <div class="table-responsive border rounded-3 overflow-hidden">
                            <table class="table table-sm table-hover align-middle mb-0" style="font-size: 12px;">
                                <thead class="table-light">
                                    <tr>
                                        <th>Email</th>
                                        <th>Họ và tên</th>
                                        <th>SĐT</th>
                                        <th>Giới tính</th>
                                        <th>Ngày sinh</th>
                                        <th>Mã số</th>
                                        <th>Bổ sung 1</th>
                                        <th>Bổ sung 2</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${sessionScope.userImportList}" varStatus="loop">
                                        <c:if test="${loop.index < 10}">
                                            <tr>
                                                <td><c:out value="${u.email}" /></td>
                                                <td><c:out value="${u.fullName}" /></td>
                                                <td><c:out value="${u.phoneNumber}" /></td>
                                                <td><c:out value="${u.gender}" /></td>
                                                <td>
                                                    <fmt:formatDate value="${u.dateOfBirth}" pattern="yyyy-MM-dd" />
                                                </td>
                                                <td><strong><c:out value="${u.code}" /></strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sessionScope.userImportRole eq 'STUDENT'}"><c:out value="${u.major}" /></c:when>
                                                        <c:when test="${sessionScope.userImportRole eq 'LECTURER'}"><c:out value="${u.department}" /></c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sessionScope.userImportRole eq 'STUDENT'}"><c:out value="${u.enrollmentYear}" /></c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <p class="text-muted mt-2 mb-0" style="font-size: 11px; font-style: italic;">
                            * Quy tắc All-or-Nothing: Nếu có bất kỳ dòng dữ liệu nào lỗi, nút xác nhận nhập sẽ bị vô hiệu hóa.
                        </p>
                    </div>
                    
                    <div class="modal-footer bg-surface-container-low border-top border-outline-variant py-3 px-4 d-flex justify-content-between align-items-center">
                        <form action="${pageContext.request.contextPath}/admin/user/import" method="POST" class="m-0">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" class="btn btn-outline-secondary rounded-3 px-3 fw-bold" style="font-size: 14px;">Bỏ tệp đang kiểm tra</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/user/import" method="POST" class="m-0">
                            <input type="hidden" name="action" value="confirm">
                            <button type="submit" class="btn btn-primary-custom rounded-3 px-4 fw-bold" style="font-size: 14px;" ${empty sessionScope.userImportErrors ? '' : 'disabled'}>
                                Xác nhận nhập ${sessionScope.userImportList.size()} dòng
                            </button>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Tự động hiển thị modal nếu phát hiện lỗi hoặc tệp đang import -->
<c:if test="${not empty sessionScope.userImportList or param.showImportModal eq 'true' or not empty sessionScope.errorMessage}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var myModal = new bootstrap.Modal(document.getElementById('importUserModal'), {});
            myModal.show();
        });
    </script>
</c:if>
