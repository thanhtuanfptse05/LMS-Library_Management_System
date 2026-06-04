<%-- Fragment: _borrow-list-table.jsp — Reservation Queue table for Librarian --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Reservation Queue Table Section --%>
<section class="card border-0 rounded-xl overflow-hidden mb-4" style="box-shadow: 0 4px 15px rgba(0,0,0,0.04);">
    <div class="card-header border-bottom d-flex justify-content-between align-items-center px-4 py-3"
         style="background-color: var(--surface-container-low); border-color: var(--outline-variant) !important;">
        <h3 class="m-0 d-flex align-items-center gap-2 fw-bold" style="font-size: 20px;">
            <span class="material-symbols-outlined">list_alt</span>
            Reservation Queue
        </h3>
        <div class="d-flex gap-2">
            <button class="btn btn-sm d-flex align-items-center gap-1 px-3 py-2 border text-dark"
                    style="border-color: var(--outline) !important; border-radius: 8px;">
                <span class="material-symbols-outlined" style="font-size: 18px;">filter_list</span> Filter
            </button>
            <button class="btn btn-sm d-flex align-items-center gap-1 px-3 py-2 fw-bold border-0"
                    style="background-color: var(--surface-container-highest); color: var(--on-surface); border-radius: 8px;">
                <span class="material-symbols-outlined" style="font-size: 18px;">download</span> Export List
            </button>
        </div>
    </div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0 text-left">
            <thead>
                <tr style="background-color: var(--surface-container-lowest); color: var(--on-surface-variant); font-size: 12px;"
                    class="text-label-md text-uppercase border-bottom">
                    <th class="px-4 py-3 fw-bold border-0">Pos</th>
                    <th class="px-4 py-3 fw-bold border-0">Patron Name</th>
                    <th class="px-4 py-3 fw-bold border-0">Contact Info</th>
                    <th class="px-4 py-3 fw-bold border-0">Reserved Date</th>
                    <th class="px-4 py-3 fw-bold border-0">Status</th>
                    <th class="px-4 py-3 fw-bold text-end border-0">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty reservationQueue}">
                        <c:forEach var="item" items="${reservationQueue}" varStatus="loop">
                            <tr class="queue-row">
                                <td class="px-4 py-3">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                         style="width: 32px; height: 32px;
                                                background-color: ${loop.index == 0 ? 'var(--primary-container)' : 'var(--surface-container-highest)'};
                                                color: ${loop.index == 0 ? '#ffffff' : 'var(--on-surface)'}; font-size: 14px;">
                                        <c:out value="${loop.count}" />
                                    </div>
                                </td>
                                <td class="px-4 py-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">
                                            <c:out value="${fn:substring(item.patronName, 0, 2)}" />
                                        </div>
                                        <div>
                                            <p class="fw-bold mb-0" style="color: var(--on-surface);"><c:out value="${item.patronName}" /></p>
                                            <p class="mb-0 text-muted" style="font-size: 14px;">ID: <c:out value="${item.patronId}" /></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-4 py-3">
                                    <div style="font-size: 14px;">
                                        <p class="mb-0 d-flex align-items-center gap-1">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">mail</span>
                                            <c:out value="${item.email}" />
                                        </p>
                                    </div>
                                </td>
                                <td class="px-4 py-3 text-muted" style="font-size: 14px;">
                                    <fmt:formatDate value="${item.reservedDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td class="px-4 py-3">
                                    <c:choose>
                                        <c:when test="${item.status == 'NOTIFIED'}">
                                            <span class="badge rounded-pill fw-bold d-inline-flex align-items-center gap-1 border"
                                                  style="background-color: var(--primary-fixed); color: var(--on-primary-fixed); font-size: 12px; padding: 4px 8px; border-color: rgba(157,67,0,0.2) !important;">
                                                <span class="material-symbols-outlined" style="font-size: 14px; font-variation-settings: 'FILL' 1;">notifications_active</span>
                                                NOTIFIED
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge rounded-pill fw-bold"
                                                  style="background-color: var(--secondary-container); color: var(--on-secondary-container); font-size: 12px; padding: 4px 8px;">
                                                WAITING
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-4 py-3 actions-cell">
                                    <div class="btn-group-actions d-flex justify-content-end gap-1">
                                        <a href="${pageContext.request.contextPath}/librarian/reservation-detail?id=${item.reservationId}"
                                           class="btn btn-link p-2 border-0" style="color: var(--tertiary);" title="Send Reminder">
                                            <span class="material-symbols-outlined">send</span>
                                        </a>
                                        <button class="btn btn-link p-2 border-0" style="color: var(--on-surface-variant);" title="Move Down">
                                            <span class="material-symbols-outlined">arrow_downward</span>
                                        </button>
                                        <button class="btn btn-link p-2 border-0" style="color: var(--error);" title="Cancel Reservation">
                                            <span class="material-symbols-outlined">cancel</span>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <%-- Sample/Placeholder rows khi chưa có dữ liệu từ DB --%>
                        <tr class="queue-row">
                            <td class="px-4 py-3">
                                <div class="rounded-circle text-white d-flex align-items-center justify-content-center fw-bold"
                                     style="width: 32px; height: 32px; background-color: var(--primary-container); font-size: 14px;">1</div>
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">AR</div>
                                    <div>
                                        <p class="fw-bold mb-0" style="color: var(--on-surface);">Alex Rivera</p>
                                        <p class="mb-0 text-muted" style="font-size: 14px;">ID: LIB-2024-0091</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-4 py-3">
                                <div style="font-size: 14px;">
                                    <p class="mb-0 d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 16px;">mail</span> a.rivera@edu.com
                                    </p>
                                    <p class="mb-0 d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 16px;">call</span> +1 (555) 012-3456
                                    </p>
                                </div>
                            </td>
                            <td class="px-4 py-3 text-muted" style="font-size: 14px;">Oct 12, 2023</td>
                            <td class="px-4 py-3">
                                <span class="badge rounded-pill fw-bold d-inline-flex align-items-center gap-1 border"
                                      style="background-color: var(--primary-fixed); color: var(--on-primary-fixed); font-size: 12px; padding: 4px 8px; border-color: rgba(157,67,0,0.2) !important;">
                                    <span class="material-symbols-outlined" style="font-size: 14px; font-variation-settings: 'FILL' 1;">notifications_active</span>
                                    NOTIFIED
                                </span>
                            </td>
                            <td class="px-4 py-3 actions-cell">
                                <div class="btn-group-actions d-flex justify-content-end gap-1">
                                    <button class="btn btn-link p-2 border-0" style="color: var(--tertiary);" title="Send Reminder">
                                        <span class="material-symbols-outlined">send</span>
                                    </button>
                                    <button class="btn btn-link p-2 border-0" style="color: var(--on-surface-variant);" title="Move Down">
                                        <span class="material-symbols-outlined">arrow_downward</span>
                                    </button>
                                    <button class="btn btn-link p-2 border-0" style="color: var(--error);" title="Cancel Reservation">
                                        <span class="material-symbols-outlined">cancel</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr class="queue-row">
                            <td class="px-4 py-3">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                     style="width: 32px; height: 32px; background-color: var(--surface-container-highest); color: var(--on-surface); font-size: 14px;">2</div>
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">SJ</div>
                                    <div>
                                        <p class="fw-bold mb-0" style="color: var(--on-surface);">Sarah Johnson</p>
                                        <p class="mb-0 text-muted" style="font-size: 14px;">ID: LIB-2024-0412</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-4 py-3">
                                <div style="font-size: 14px;">
                                    <p class="mb-0 d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 16px;">mail</span> s.johnson@edu.com
                                    </p>
                                </div>
                            </td>
                            <td class="px-4 py-3 text-muted" style="font-size: 14px;">Oct 14, 2023</td>
                            <td class="px-4 py-3">
                                <span class="badge rounded-pill fw-bold"
                                      style="background-color: var(--secondary-container); color: var(--on-secondary-container); font-size: 12px; padding: 4px 8px;">
                                    WAITING
                                </span>
                            </td>
                            <td class="px-4 py-3 actions-cell">
                                <div class="btn-group-actions d-flex justify-content-end gap-1">
                                    <button class="btn btn-link p-2 border-0" style="color: var(--on-surface-variant);" title="Move Up">
                                        <span class="material-symbols-outlined">arrow_upward</span>
                                    </button>
                                    <button class="btn btn-link p-2 border-0" style="color: var(--on-surface-variant);" title="Move Down">
                                        <span class="material-symbols-outlined">arrow_downward</span>
                                    </button>
                                    <button class="btn btn-link p-2 border-0" style="color: var(--error);" title="Cancel Reservation">
                                        <span class="material-symbols-outlined">cancel</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr class="queue-row">
                            <td class="px-4 py-3">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                     style="width: 32px; height: 32px; background-color: var(--surface-container-highest); color: var(--on-surface); font-size: 14px;">3</div>
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">MC</div>
                                    <div>
                                        <p class="fw-bold mb-0" style="color: var(--on-surface);">Michael Chen</p>
                                        <p class="mb-0 text-muted" style="font-size: 14px;">ID: LIB-2024-0015</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-4 py-3">
                                <div style="font-size: 14px;">
                                    <p class="mb-0 d-flex align-items-center gap-1">
                                        <span class="material-symbols-outlined" style="font-size: 16px;">mail</span> m.chen@edu.com
                                    </p>
                                </div>
                            </td>
                            <td class="px-4 py-3 text-muted" style="font-size: 14px;">Oct 18, 2023</td>
                            <td class="px-4 py-3">
                                <span class="badge rounded-pill fw-bold"
                                      style="background-color: var(--secondary-container); color: var(--on-secondary-container); font-size: 12px; padding: 4px 8px;">
                                    WAITING
                                </span>
                            </td>
                            <td class="px-4 py-3 actions-cell">
                                <div class="btn-group-actions d-flex justify-content-end gap-1">
                                    <button class="btn btn-link p-2 border-0" style="color: var(--on-surface-variant);" title="Move Up">
                                        <span class="material-symbols-outlined">arrow_upward</span>
                                    </button>
                                    <button class="btn btn-link p-2 border-0" style="color: var(--on-surface-variant);" title="Move Down">
                                        <span class="material-symbols-outlined">arrow_downward</span>
                                    </button>
                                    <button class="btn btn-link p-2 border-0" style="color: var(--error);" title="Cancel Reservation">
                                        <span class="material-symbols-outlined">cancel</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</section>
