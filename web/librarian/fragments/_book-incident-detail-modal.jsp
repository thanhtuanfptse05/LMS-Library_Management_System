<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty selectedIncident}">
    <div class="modal fade bm-modal" id="incidentDetailModal" tabindex="-1" aria-hidden="true" data-auto-open="true">
        <div class="modal-dialog"><div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/book-management/incidents">
                <input type="hidden" name="incidentId" value="${selectedIncident.incidentId}">
                <div class="modal-header">
                    <div><h5 class="modal-title">Chi tiết sự cố <c:out value="${selectedIncident.barcode}" /></h5><p class="bm-section-note mb-0"><c:out value="${selectedIncident.bookTitle}" /></p></div>
                    <button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <dl class="row mb-0"><dt class="col-sm-4">Loại sự cố</dt><dd class="col-sm-8">${selectedIncident.incidentType == 'damaged' ? 'Hỏng' : 'Mất'}</dd><dt class="col-sm-4">Mô tả</dt><dd class="col-sm-8"><c:out value="${selectedIncident.description}" /></dd><dt class="col-sm-4">Người báo</dt><dd class="col-sm-8"><c:out value="${selectedIncident.reportedByName}" /></dd></dl>
                    <c:choose><c:when test="${canEdit and (selectedIncident.status == 'pending' or selectedIncident.status == 'investigating')}"><div class="mt-3"><label class="form-label">Kết luận xử lý <span class="bm-required">*</span></label><textarea class="form-control" name="resolution" required maxlength="1000" rows="3" placeholder="Nêu căn cứ xác minh và hướng xử lý"></textarea></div></c:when><c:otherwise><div class="bm-rule-note mt-3"><strong>Kết luận:</strong> <c:out value="${empty selectedIncident.resolution ? 'Chưa có kết luận.' : selectedIncident.resolution}" /></div></c:otherwise></c:choose>
                </div>
                <div class="modal-footer"><a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/book-management/incidents">Đóng</a><c:if test="${canEdit and (selectedIncident.status == 'pending' or selectedIncident.status == 'investigating')}"><button class="btn bm-btn-secondary" type="submit" name="action" value="reject">Báo sai, hoàn kho</button><button class="btn btn-primary-custom" type="submit" name="action" value="resolve">Xác nhận hỏng/mất</button></c:if></div>
            </form>
        </div></div>
    </div>
</c:if>
