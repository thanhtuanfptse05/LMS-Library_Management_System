<%-- Fragment: _section-alert.jsp — System alert for overdue / due-soon books --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ── System Alert: Overdue warning ── -->
<c:if test="${not empty dueSoonLoans}">
    <section class="mb-5">
        <div class="d-flex align-items-center gap-3 p-4 rounded-3"
             style="background-color: rgba(186, 26, 26, 0.06); border-left: 4px solid var(--error);">
            <span class="material-symbols-outlined" style="color: var(--error); font-size: 28px;">warning</span>
            <div>
                <p class="fw-bold mb-1 small" style="color: var(--error);">Nhắc nhở trả sách</p>
                <p class="mb-0 small text-on-surface-variant">
                    Bạn có <strong>${dueSoonCount}</strong> sách đến hạn trong vòng 3 ngày.
                    <a href="${pageContext.request.contextPath}/student/loans"
                       class="text-primary-custom fw-semibold text-decoration-none">Xem sách đang mượn &rarr;</a>
                </p>
            </div>
        </div>
    </section>
</c:if>
