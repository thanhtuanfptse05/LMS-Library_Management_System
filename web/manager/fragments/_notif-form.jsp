<%-- Fragment: _notif-form.jsp — Form tạo mới / chỉnh sửa thông báo + Hướng dẫn phân loại --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="col-12 col-xl-4">

    <%-- Form tạo mới hoặc chỉnh sửa --%>
    <div class="raised-card p-4 mb-4" id="notifFormCard">
        <c:choose>
            <c:when test="${not empty editNotification}">
                <%-- Chế độ CHỈNH SỬA --%>
                <div class="d-flex align-items-center gap-2 mb-4">
                    <div class="rounded-2 d-flex align-items-center justify-content-center"
                         style="width: 36px; height: 36px; background: rgba(0,99,152,0.1);">
                        <span class="material-symbols-outlined"
                              style="color: var(--tertiary); font-size: 20px; font-variation-settings: 'FILL' 1;">edit_note</span>
                    </div>
                    <div>
                        <h5 class="fw-bold mb-0" style="color: var(--on-surface);">Chỉnh sửa thông báo</h5>
                        <p class="mb-0" style="font-size: 11px; color: var(--on-surface-variant);">ID #${editNotification.notificationId}</p>
                    </div>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/manager/notifications" id="notifForm">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="notificationId" value="${editNotification.notificationId}">

                    <div class="mb-3">
                        <label for="editTitle" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">
                            Tiêu đề <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control rounded-3" id="editTitle" name="title"
                               value="<c:out value='${editNotification.title}'/>"
                               placeholder="Tiêu đề thông báo..." required maxlength="500">
                    </div>

                    <div class="mb-3">
                        <label for="editType" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">Phân loại</label>
                        <select class="form-select rounded-3" id="editType" name="type">
                            <option value="general" ${editNotification.type == 'general' ? 'selected' : ''}>📢 Thông tin chung</option>
                            <option value="urgent"  ${editNotification.type == 'urgent'  ? 'selected' : ''}>🔴 Khẩn cấp</option>
                            <option value="event"   ${editNotification.type == 'event'   ? 'selected' : ''}>🎯 Sự kiện / Hoạt động</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="editContent" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">
                            Nội dung <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control rounded-3" id="editContent" name="content"
                                  rows="8"
                                  placeholder="Nhập nội dung thông báo. Xuống dòng sẽ được giữ nguyên khi hiển thị."
                                  style="white-space: pre-line;"
                                  required><c:out value="${editNotification.content}"/></textarea>
                        <small class="text-secondary d-block mt-1" style="font-size:12px;">
                            ✏️ Nhập văn bản thường. Xuống dòng và khoảng trắng sẽ được giữ nguyên.
                        </small>
                    </div>

                    <div class="mb-3">
                        <label for="editTargetRole" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">Đối tượng nhận</label>
                        <select class="form-select rounded-3" id="editTargetRole" name="targetRole">
                            <option value="ALL" ${empty editNotification.targetRole or editNotification.targetRole == 'ALL' ? 'selected' : ''}>👥 Tất cả thành viên</option>
                            <option value="STUDENT"  ${editNotification.targetRole == 'STUDENT'  ? 'selected' : ''}>🎓 Chỉ Sinh viên</option>
                            <option value="LECTURER" ${editNotification.targetRole == 'LECTURER' ? 'selected' : ''}>👨‍🏫 Chỉ Giảng viên</option>
                        </select>
                    </div>

                    <div class="form-check mb-3 d-flex align-items-center gap-2 p-0">
                        <input class="form-check-input m-0" type="checkbox" id="editPinned"
                               name="isPinned" style="width: 18px; height: 18px;"
                               ${editNotification.pinned ? 'checked' : ''}>
                        <label class="form-check-label small fw-semibold ms-2" for="editPinned" style="color: var(--on-surface-variant);">
                            <span class="material-symbols-outlined align-middle me-1" style="font-size: 16px;">push_pin</span>
                            Ghim thông báo lên đầu
                        </label>
                    </div>

                    <c:if test="${editNotification.type == 'general' or editNotification.type == 'event'}">
                        <div class="mb-3 p-2 rounded-3" style="background: rgba(22,163,74,0.06); border: 1px dashed rgba(22,163,74,0.3);">
                            <small style="color: #15803d; font-size: 12px;">
                                🌐 Bài đăng này đang hiển thị trên <strong>trang Tin tức công khai</strong>.
                            </small>
                        </div>
                        <div class="mb-3">
                            <label for="editThumbnail" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">
                                Ảnh minh họa (URL) <span class="text-muted fw-normal">— không bắt buộc</span>
                            </label>
                            <input type="url" class="form-control rounded-3" id="editThumbnail"
                                   name="thumbnailUrl"
                                   placeholder="https://example.com/hinh-su-kien.jpg"
                                   value="<c:out value='${editNotification.thumbnailUrl}'/>"><br>
                            <small class="text-muted" style="font-size:12px;">
                                📸 Dán link ảnh từ Internet. Ảnh sẽ hiển thị trên trang Tin tức công khai.
                            </small>
                        </div>
                    </c:if>

                    <div class="mb-1" style="background: rgba(22,163,74,0.05); border: 1px solid rgba(22,163,74,0.2); border-radius: 8px; padding: 10px 12px;">
                        <div class="form-check d-flex align-items-center gap-2 p-0 mb-0">
                            <input class="form-check-input m-0" type="checkbox" id="editSendEmail"
                                   name="isSendEmail" style="width: 18px; height: 18px;"
                                   onchange="toggleTemplateDropdown('editTemplateWrapper', this)">
                            <label class="form-check-label small fw-semibold ms-2" for="editSendEmail" style="color: #15803d;">
                                <span class="material-symbols-outlined align-middle me-1" style="font-size: 16px; color: #16a34a;">email</span>
                                Gửi kèm Email thông báo tới người dùng
                            </label>
                        </div>
                        <div id="editTemplateWrapper" class="mt-2" style="display:none;">
                            <label for="editTemplateName" class="form-label small fw-semibold mb-1" style="color: var(--on-surface-variant);">
                                Chọn mẫu Email <span class="text-danger">*</span>
                            </label>
                            <select class="form-select form-select-sm rounded-3" id="editTemplateName" name="templateName">
                                <option value="">-- Chọn mẫu email --</option>
                                <c:forEach var="tmpl" items="${emailTemplates}">
                                    <option value="${tmpl.tempName}"><c:out value="${tmpl.tempName}" /></option>
                                </c:forEach>
                            </select>
                            <small class="text-muted" style="font-size:11px;">
                                <span class="material-symbols-outlined" style="font-size:11px; vertical-align:middle;">info</span>
                                Mẫu email sẽ được dùng để gửi tới người dùng. Quản lý mẫu tại <a href="${pageContext.request.contextPath}/manager/email-templates" target="_blank">Quản lý Mẫu Email</a>.
                            </small>
                        </div>
                    </div>
                    <div class="mb-4"></div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary-custom flex-grow-1 rounded-3 fw-bold py-2">
                            <span class="material-symbols-outlined me-1 align-middle">save</span>Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/manager/notifications"
                           class="btn rounded-3 py-2"
                           style="background-color: var(--surface-container-high); color: var(--on-surface-variant);">
                            Hủy
                        </a>
                    </div>
                </form>
            </c:when>

            <c:otherwise>
                <%-- Chế độ TẠO MỚI --%>
                <div class="d-flex align-items-center gap-2 mb-4">
                    <div class="rounded-2 d-flex align-items-center justify-content-center"
                         style="width: 36px; height: 36px; background: linear-gradient(135deg, rgba(157,67,0,0.12), rgba(249,115,22,0.08));">
                        <span class="material-symbols-outlined"
                              style="color: var(--primary); font-size: 20px; font-variation-settings: 'FILL' 1;">campaign</span>
                    </div>
                    <div>
                        <h5 class="fw-bold mb-0" style="color: var(--on-surface);">Đăng thông báo mới</h5>
                        <p class="mb-0" style="font-size: 11px; color: var(--on-surface-variant);">Gửi đến toàn bộ thành viên</p>
                    </div>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/manager/notifications" id="notifForm">
                    <input type="hidden" name="action" value="create">

                    <div class="mb-3">
                        <label for="notifTitle" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">
                            Tiêu đề <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control rounded-3" id="notifTitle" name="title"
                               placeholder="VD: Thư viện nghỉ lễ 30/4 - 1/5" required maxlength="500">
                    </div>

                    <div class="mb-3">
                        <label for="notifType" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">Phân loại</label>
                        <select class="form-select rounded-3" id="notifType" name="type" onchange="onTypeChangeCreate(this)">
                            <option value="general">📢 Thông tin chung</option>
                            <option value="urgent">🔴 Khẩn cấp</option>
                            <option value="event">🎯 Sự kiện / Hoạt động</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="notifContent" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">
                            Nội dung <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control rounded-3" id="notifContent" name="content"
                                  rows="8" placeholder="Nhập nội dung thông báo. Xuống dòng sẽ được giữ nguyên khi hiển thị." required
                                  style="white-space: pre-line;"></textarea>
                        <small class="text-secondary d-block mt-1" style="font-size:12px;">
                            ✏️ Nhập văn bản thường. Xuống dòng và khoảng trắng sẽ được giữ nguyên.
                        </small>
                    </div>

                    <div class="mb-3">
                        <label for="notifTargetRole" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">Đối tượng nhận</label>
                        <select class="form-select rounded-3" id="notifTargetRole" name="targetRole">
                            <option value="ALL">👥 Tất cả thành viên</option>
                            <option value="STUDENT">🎓 Chỉ Sinh viên</option>
                            <option value="LECTURER">👨‍🏫 Chỉ Giảng viên</option>
                        </select>
                    </div>

                    <div class="form-check mb-3 d-flex align-items-center gap-2 p-0">
                        <input class="form-check-input m-0" type="checkbox" id="notifPinned"
                               name="isPinned" style="width: 18px; height: 18px;">
                        <label class="form-check-label small fw-semibold ms-2" for="notifPinned" style="color: var(--on-surface-variant);">
                            <span class="material-symbols-outlined align-middle me-1" style="font-size: 16px;">push_pin</span>
                            Ghim thông báo lên đầu
                        </label>
                    </div>

                    <div id="publicNoteCreate" class="mb-3 p-2 rounded-3"
                         style="background: rgba(22,163,74,0.06); border: 1px dashed rgba(22,163,74,0.3); display:none;">
                        <small style="color: #15803d; font-size: 12px;">
                            🌐 Bài đăng này sẽ tự động hiển thị trên <strong>trang Tin tức công khai</strong> cho tất cả khách truy cập.
                        </small>
                    </div>

                    <div class="mb-3" id="thumbnailSectionCreate" style="display:none;">
                        <label for="notifThumbnail" class="form-label small fw-semibold" style="color: var(--on-surface-variant);">
                            Ảnh minh họa (URL) <span class="text-muted fw-normal">— không bắt buộc</span>
                        </label>
                        <input type="url" class="form-control rounded-3" id="notifThumbnail"
                               name="thumbnailUrl"
                               placeholder="https://example.com/hinh-su-kien.jpg">
                        <small class="text-muted" style="font-size:12px;">
                            📸 Dán link ảnh từ Internet. Ảnh sẽ hiển thị trên trang Tin tức công khai.
                        </small>
                    </div>

                    <div class="mb-1" style="background: rgba(22,163,74,0.05); border: 1px solid rgba(22,163,74,0.2); border-radius: 8px; padding: 10px 12px;">
                        <div class="form-check d-flex align-items-center gap-2 p-0 mb-0">
                            <input class="form-check-input m-0" type="checkbox" id="notifSendEmail"
                                   name="isSendEmail" style="width: 18px; height: 18px;"
                                   onchange="toggleTemplateDropdown('notifTemplateWrapper', this)">
                            <label class="form-check-label small fw-semibold ms-2" for="notifSendEmail" style="color: #15803d;">
                                <span class="material-symbols-outlined align-middle me-1" style="font-size: 16px; color: #16a34a;">email</span>
                                Gửi kèm Email thông báo tới người dùng
                            </label>
                        </div>
                        <div id="notifTemplateWrapper" class="mt-2" style="display:none;">
                            <label for="notifTemplateName" class="form-label small fw-semibold mb-1" style="color: var(--on-surface-variant);">
                                Chọn mẫu Email <span class="text-danger">*</span>
                            </label>
                            <select class="form-select form-select-sm rounded-3" id="notifTemplateName" name="templateName">
                                <option value="">-- Chọn mẫu email --</option>
                                <c:forEach var="tmpl" items="${emailTemplates}">
                                    <option value="${tmpl.tempName}"><c:out value="${tmpl.tempName}" /></option>
                                </c:forEach>
                            </select>
                            <small class="text-muted" style="font-size:11px;">
                                <span class="material-symbols-outlined" style="font-size:11px; vertical-align:middle;">info</span>
                                Mẫu email sẽ được dùng để gửi tới người dùng. Quản lý mẫu tại <a href="${pageContext.request.contextPath}/manager/email-templates" target="_blank">Quản lý Mẫu Email</a>.
                            </small>
                        </div>
                    </div>
                    <div class="mb-4"></div>

                    <button type="submit" class="btn btn-primary-custom w-100 rounded-3 fw-bold py-2">
                        <span class="material-symbols-outlined me-1 align-middle">send</span>
                        Đăng lên Bảng tin
                    </button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- Hướng dẫn phân loại --%>
    <div class="raised-card p-4" style="background: linear-gradient(135deg, var(--surface-container-low), var(--surface-container));">
        <h6 class="fw-bold mb-3" style="color: var(--on-surface); font-size: 13px; text-transform: uppercase; letter-spacing: 0.05em;">
            Hướng dẫn phân loại
        </h6>
        <div class="d-flex flex-column gap-2" style="font-size: 13px;">
            <div class="d-flex align-items-center gap-2">
                <span class="notif-badge-type type-general" style="flex-shrink:0;">Chung</span>
                <span style="color: var(--on-surface-variant);">Lịch hoạt động, thông tin định kỳ</span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="notif-badge-type type-urgent" style="flex-shrink:0;">Khẩn</span>
                <span style="color: var(--on-surface-variant);">Đóng cửa đột xuất, thay đổi khẩn</span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="notif-badge-type type-event" style="flex-shrink:0;">Sự kiện</span>
                <span style="color: var(--on-surface-variant);">Workshop, triển lãm, hoạt động</span>
            </div>
        </div>
    </div>

</div>
