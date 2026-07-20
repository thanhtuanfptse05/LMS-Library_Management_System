<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${canEdit}">
    <div class="modal fade bm-modal" id="reportModal" tabindex="-1" aria-hidden="true" data-auto-open="${not empty reportCopy}">
        <div class="modal-dialog"><div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/librarian/book-management/incidents">
                <input type="hidden" name="action" value="report">
                <div class="modal-header">
                    <div><h5 class="modal-title">Ghi nhận sự cố bản sao</h5><p class="bm-section-note mb-0">Chỉ bản sao đang tốt và sẵn sàng mới có thể ghi nhận.</p></div>
                    <button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3"><label class="form-label">Mã vạch <span class="bm-required">*</span></label><input class="form-control" name="barcode" required maxlength="50" value="<c:out value="${reportCopy.barcode}" />" placeholder="Quét hoặc nhập mã vạch"></div>
                    <div class="mb-3"><label class="form-label">Loại sự cố <span class="bm-required">*</span></label><select class="form-select" name="incidentType" required><option value="damaged">Hỏng</option><option value="lost">Mất</option></select></div>
                    <div><label class="form-label">Mô tả hiện trạng <span class="bm-required">*</span></label><textarea class="form-control" name="description" required maxlength="1000" rows="3" placeholder="Mô tả dấu hiệu, vị trí phát hiện hoặc hoàn cảnh ghi nhận"></textarea></div>
                </div>
                <div class="modal-footer"><button class="btn bm-btn-secondary" type="button" data-bs-dismiss="modal">Hủy</button><button class="btn btn-primary-custom" type="submit">Ghi nhận sự cố</button></div>
            </form>
        </div></div>
    </div>
</c:if>
