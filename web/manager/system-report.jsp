<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1440px; margin: 0 auto;">

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="lms-alert lms-alert-error mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined" style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">error</span>
                        <span class="flex-grow-1"><c:out value="${requestScope.errorMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>

                <!-- ─── Header ─── -->
                <section class="mb-4">
                    <div class="d-flex justify-content-between align-items-end mb-3">
                        <div>
                            <h2 class="fw-bold mb-1" style="font-size: 22px; color: var(--on-surface);">Báo Cáo Thống Kê</h2>
                            <p class="text-on-surface-variant mb-0" style="font-size: 13px;">
                                Theo dõi và phân tích dữ liệu mượn trả, tài chính và kho sách.
                            </p>
                        </div>
                    </div>
                    
                    <!-- Filters -->
                    <div class="raised-card p-3 mb-4">
                        <form action="${pageContext.request.contextPath}/manager/reports/dashboard" method="GET" class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label" style="font-size: 13px; font-weight: 600;">Từ ngày</label>
                                <input type="date" class="form-control form-control-sm" name="startDate" value="${startDate}">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" style="font-size: 13px; font-weight: 600;">Đến ngày</label>
                                <input type="date" class="form-control form-control-sm" name="endDate" value="${endDate}">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label" style="font-size: 13px; font-weight: 600;">Nhóm theo</label>
                                <select class="form-select form-select-sm" name="groupBy">
                                    <option value="day" ${groupBy == 'day' ? 'selected' : ''}>Ngày</option>
                                    <option value="month" ${groupBy == 'month' ? 'selected' : ''}>Tháng</option>
                                    <option value="year" ${groupBy == 'year' ? 'selected' : ''}>Năm</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex gap-2">
                                <button type="submit" class="btn btn-sm btn-primary-custom w-100 fw-bold">Lọc dữ liệu</button>
                                <div class="dropdown w-100">
                                    <button class="btn btn-sm btn-secondary-custom w-100 fw-bold d-flex align-items-center justify-content-center gap-1 dropdown-toggle" type="button" id="exportDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        <span class="material-symbols-outlined" style="font-size: 16px;">download</span> Xuất Excel
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="exportDropdown" style="font-size: 14px;">
                                        <li><a class="dropdown-item d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/manager/reports/export?exportType=summary&startDate=${startDate}&endDate=${endDate}&groupBy=${groupBy}">
                                            <span class="material-symbols-outlined text-primary" style="font-size: 18px;">analytics</span> Báo cáo Tổng hợp
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/manager/reports/export?exportType=borrow_detail&startDate=${startDate}&endDate=${endDate}">
                                            <span class="material-symbols-outlined text-success" style="font-size: 18px;">menu_book</span> Chi tiết Mượn/Trả sách
                                        </a></li>
                                        <li><a class="dropdown-item d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/manager/reports/export?exportType=finance_detail&startDate=${startDate}&endDate=${endDate}">
                                            <span class="material-symbols-outlined text-danger" style="font-size: 18px;">payments</span> Chi tiết Tài chính
                                        </a></li>
                                    </ul>
                                </div>
                            </div>
                        </form>
                    </div>
                </section>

                <div class="row g-4">
                    <!-- Left Column: Charts -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">
                        
                        <!-- Borrow Trends Chart -->
                        <div class="raised-card p-4">
                            <div class="mb-4">
                                <h3 class="card-title">Xu hướng Mượn/Trả</h3>
                            </div>
                            <canvas id="borrowChart" height="100"></canvas>
                        </div>
                        
                        <!-- Financial Trends Chart -->
                        <div class="raised-card p-4">
                            <div class="mb-4">
                                <h3 class="card-title">Đối chiếu Tài chính (Tiền phạt)</h3>
                            </div>
                            <canvas id="financialChart" height="100"></canvas>
                        </div>
                        
                    </div>
                    
                    <!-- Right Column: Inventory & Summary -->
                    <div class="col-12 col-lg-4 d-flex flex-column gap-4">
                        
                        <!-- Inventory Stats -->
                        <div class="raised-card overflow-hidden">
                            <div class="card-header-row">
                                <h3 class="card-title mb-0">Kiểm kê gần nhất</h3>
                            </div>
                            <div class="p-3 d-flex flex-column gap-3">
                                <c:choose>
                                    <c:when test="${not empty inventoryStats}">
                                        <div class="text-center mb-2">
                                            <span class="badge-pill badge-primary mb-2">Đợt #${inventoryStats.sessionId} - ${inventoryStats.location}</span>
                                            <br>
                                            <small class="text-muted">Hoàn thành: <fmt:formatDate value="${inventoryStats.completedAt}" pattern="dd/MM/yyyy HH:mm" /></small>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span style="font-size: 13px; font-weight: 600;">Sách khớp (Matched):</span>
                                            <span class="badge bg-success">${inventoryStats.totalMatched}</span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span style="font-size: 13px; font-weight: 600;">Thiếu (Missing):</span>
                                            <span class="badge bg-danger">${inventoryStats.totalMissing}</span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span style="font-size: 13px; font-weight: 600;">Sai vị trí (Misplaced):</span>
                                            <span class="badge bg-warning text-dark">${inventoryStats.totalMisplaced}</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <span class="material-symbols-outlined text-muted" style="font-size: 32px;">inventory_2</span>
                                            <p class="text-muted mt-2" style="font-size: 13px;">Chưa có dữ liệu kiểm kê</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </div>
                </div>

            </div>

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        // Prepare data for Borrow Trends
        const borrowLabels = [];
        const dataBorrowed = [];
        const dataReturned = [];
        const dataOverdue = [];
        
        <c:forEach var="item" items="${borrowTrends}">
            borrowLabels.push('${item.periodLabel}');
            dataBorrowed.push(${item.totalBorrowed});
            dataReturned.push(${item.totalReturnedOnTime});
            dataOverdue.push(${item.totalOverdue});
        </c:forEach>
        
        const ctxBorrow = document.getElementById('borrowChart').getContext('2d');
        new Chart(ctxBorrow, {
            type: 'bar',
            data: {
                labels: borrowLabels,
                datasets: [
                    {
                        label: 'Lượt mượn',
                        data: dataBorrowed,
                        backgroundColor: '#3b82f6'
                    },
                    {
                        label: 'Trả đúng hạn',
                        data: dataReturned,
                        backgroundColor: '#10b981'
                    },
                    {
                        label: 'Quá hạn',
                        data: dataOverdue,
                        backgroundColor: '#ef4444'
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });

        // Prepare data for Financial Trends
        const financialLabels = [];
        const dataPaid = [];
        const dataUnpaid = [];
        
        <c:forEach var="item" items="${financialTrends}">
            financialLabels.push('${item.periodLabel}');
            dataPaid.push(${item.totalPaid});
            dataUnpaid.push(${item.totalUnpaid});
        </c:forEach>
        
        const ctxFin = document.getElementById('financialChart').getContext('2d');
        new Chart(ctxFin, {
            type: 'bar',
            data: {
                labels: financialLabels,
                datasets: [
                    {
                        label: 'Tiền đã thu (VND)',
                        data: dataPaid,
                        backgroundColor: '#10b981'
                    },
                    {
                        label: 'Tiền chưa thu (VND)',
                        data: dataUnpaid,
                        backgroundColor: '#ef4444'
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    </script>
</body>
</html>
