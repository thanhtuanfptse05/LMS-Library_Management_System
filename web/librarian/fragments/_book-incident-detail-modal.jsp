<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${not empty selectedIncident}">
    <div class="modal fade bm-modal" id="incidentDetailModal" tabindex="-1" aria-hidden="true" data-auto-open="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/librarian/book-management/incidents">
                    <input type="hidden" name="incidentId" value="${selectedIncident.incidentId}">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title">Chi tiết sự cố <c:out value="${selectedIncident.barcode}" /></h5>
                            <p class="bm-section-note mb-0"><c:out value="${selectedIncident.bookTitle}" /></p>
                        </div>
                        <button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <dl class="row mb-0">
                            <dt class="col-sm-4">Loại sự cố</dt>
                            <dd class="col-sm-8">${selectedIncident.incidentType == 'damaged' ? 'Hỏng' : 'Mất'}</dd>
                            <dt class="col-sm-4">Mô tả</dt>
                            <dd class="col-sm-8"><c:out value="${selectedIncident.description}" /></dd>
                            <dt class="col-sm-4">Người báo</dt>
                            <dd class="col-sm-8"><c:out value="${selectedIncident.reportedByName}" /></dd>
                        </dl>

                        <c:choose>
                            <c:when test="${canEdit and (selectedIncident.status == 'pending' or selectedIncident.status == 'investigating')}">
                                <div class="mt-3">
                                    <label class="form-label">Kết luận xử lý <span class="bm-required">*</span></label>
                                    <textarea class="form-control" name="resolution" required maxlength="1000" rows="3"
                                              placeholder="Nêu căn cứ xác minh và hướng xử lý"></textarea>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="bm-rule-note mt-3">
                                    <strong>Kết luận:</strong>
                                    <c:out value="${empty selectedIncident.resolution ? 'Chưa có kết luận.' : selectedIncident.resolution}" />
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${canEdit and selectedIncident.status == 'resolved' and selectedIncident.incidentType == 'damaged' and not fn:contains(selectedIncident.resolution, 'Khôi phục lưu thông:')}">
                            <c:choose>
                                <c:when test="${selectedIncident.removedFromInventory}">
                                    <div class="bm-rule-note mt-3">
                                        <strong>Đã loại khỏi kho:</strong>
                                        Bản sao này không còn được tính vào tổng kho phục vụ.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="mt-3">
                                        <label class="form-label">Ghi chú xử lý sau kết luận <span class="bm-required">*</span></label>
                                        <textarea class="form-control" name="postResolutionNote" required maxlength="1000" rows="3"
                                                  placeholder="Ghi chú sửa chữa nếu khôi phục, hoặc lý do loại khỏi kho nếu hỏng nặng."></textarea>
                                        <p class="bm-section-note mt-2 mb-0">
                                            Khôi phục khi bản sao đã sửa xong; loại khỏi kho khi bản sao hỏng nặng không còn khả năng sửa.
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                    <div class="modal-footer">
                        <a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/librarian/book-management/incidents">Đóng</a>
                        <c:if test="${canEdit and (selectedIncident.status == 'pending' or selectedIncident.status == 'investigating')}">
                            <button class="btn bm-btn-secondary" type="submit" name="action" value="reject">Báo sai, hoàn kho</button>
                            <button class="btn btn-primary-custom" type="submit" name="action" value="resolve">Xác nhận hỏng/mất</button>
                        </c:if>
                        <c:if test="${canEdit and selectedIncident.status == 'resolved' and selectedIncident.incidentType == 'damaged' and not selectedIncident.removedFromInventory and not fn:contains(selectedIncident.resolution, 'Khôi phục lưu thông:')}">
                            <button class="btn btn-primary-custom" type="submit" name="action" value="restore">Khôi phục lưu thông</button>
                            <button class="btn bm-btn-secondary" type="submit" name="action" value="removeFromInventory">Loại khỏi kho</button>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:if>
