<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${not empty selectedBatch}">
<div class="modal fade bm-modal" id="historyModal" tabindex="-1" aria-hidden="true" data-auto-open="true"><div class="modal-dialog modal-lg"><div class="modal-content">
    <div class="modal-header"><div><h5 class="modal-title">Chi tiết phiên IMP-${selectedBatch.importBatchId}</h5><p class="bm-section-note mb-0"><c:out value="${selectedBatch.fileName}" /> · <fmt:formatDate value="${selectedBatch.createdAt}" pattern="dd/MM/yyyy HH:mm" /></p></div><button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Đóng"></button></div>
    <div class="modal-body"><div class="bm-summary-strip mb-3"><span class="bm-summary-strip__item">Tổng dòng: <strong>${selectedBatch.totalRows}</strong></span><span class="bm-summary-strip__item">Thành công: <strong>${selectedBatch.successRows}</strong></span><span class="bm-summary-strip__item">Có lỗi: <strong>${selectedBatch.failedRows}</strong></span></div>
        <c:choose><c:when test="${empty selectedBatch.errors}"><div class="bm-empty-state"><span class="material-symbols-outlined">verified</span><strong>Phiên import thành công</strong><span>Toàn bộ dữ liệu đã được lưu trong một giao dịch.</span></div></c:when><c:otherwise><div class="table-responsive"><table class="table table-lms"><thead><tr><th>Sheet</th><th>Dòng</th><th>Cột</th><th>Nội dung lỗi</th></tr></thead><tbody><c:forEach var="error" items="${selectedBatch.errors}"><tr><td><c:out value="${error.sheetName}" /></td><td>${error.rowNumber}</td><td><c:out value="${empty error.columnName ? 'Cấu trúc' : error.columnName}" /></td><td><c:out value="${error.errorMessage}" /></td></tr></c:forEach></tbody></table></div></c:otherwise></c:choose>
    </div><div class="modal-footer"><a class="btn btn-primary-custom" href="${pageContext.request.contextPath}/book-management/import-history">Đóng</a></div>
</div></div></div>
</c:if>
