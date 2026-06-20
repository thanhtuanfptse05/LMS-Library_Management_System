<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <jsp:include page="fragments/_head.jsp">
            <jsp:param name="title" value="Cấu hình Hệ thống | Manager" />
        </jsp:include>
    </head>
    <body>
        <!-- SIDEBAR -->
        <jsp:include page="fragments/_sidebar.jsp" />

        <div class="main-wrapper">
            <!-- HEADER -->
            <jsp:include page="fragments/_header.jsp" />

            <main class="content-area p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1">Cấu hình Hệ thống</h4>
                        <p class="text-muted mb-0">Quản lý các thông số chính sách mượn trả của Thư viện</p>
                    </div>
                </div>

                <!-- Flash Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="material-symbols-outlined align-middle me-2">check_circle</i>
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="material-symbols-outlined align-middle me-2">error</i>
                        ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Bảng danh sách cấu hình -->
                <div class="card card-custom border-0 shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col" class="ps-4">Tên Cấu Hình</th>
                                        <th scope="col">Mô Tả</th>
                                        <th scope="col" class="text-center">Giá Trị</th>
                                        <th scope="col">Cập Nhật Bởi</th>
                                        <th scope="col">Lần Cuối</th>
                                        <th scope="col" class="pe-4 text-end">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cfg" items="${configs}">
                                        <tr>
                                            <td class="ps-4 fw-bold">
                                                <c:out value="${cfg.configKey}"/>
                                            </td>
                                            <td>
                                                <c:out value="${cfg.description}"/>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-primary px-3 py-2 fs-6">
                                                    <c:out value="${cfg.configValue}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <c:out value="${cfg.updaterName}"/>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${cfg.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td class="pe-4 text-end">
                                                <button type="button" class="btn btn-sm btn-outline-primary"
                                                        data-bs-toggle="modal" data-bs-target="#editModal"
                                                        onclick="prefillModal('<c:out value="${cfg.configKey}"/>', '<c:out value="${cfg.configValue}"/>', '<c:out value="${cfg.description}"/>')">
                                                    <i class="material-symbols-outlined fs-6 align-middle">edit</i> Sửa
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty configs}">
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">
                                                Không có cấu hình nào.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
            
            <!-- Modal Cập Nhật Cấu Hình -->
            <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <form action="${pageContext.request.contextPath}/manager/system-config" method="POST" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editModalLabel">Cập nhật cấu hình</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="configKey" id="modalConfigKey">
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Mô tả cấu hình</label>
                                <p id="modalConfigDesc" class="text-muted"></p>
                            </div>
                            
                            <div class="mb-3">
                                <label for="modalConfigValue" class="form-label fw-bold">Giá trị mới <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="modalConfigValue" name="configValue" required>
                                <div class="form-text">Vui lòng nhập định dạng số phù hợp (số nguyên hoặc số thực tuỳ cấu hình).</div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- FOOTER -->
            <jsp:include page="fragments/_footer.jsp" />
        </div>

        <script>
            function prefillModal(key, value, desc) {
                document.getElementById('modalConfigKey').value = key;
                document.getElementById('modalConfigValue').value = value;
                document.getElementById('modalConfigDesc').textContent = desc;
            }
        </script>
    </body>
</html>
