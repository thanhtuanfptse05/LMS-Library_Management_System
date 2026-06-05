<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<jsp:include page="fragments/_head.jsp" />
<body class="d-flex flex-column">
    <jsp:include page="fragments/_header.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">
        <jsp:include page="fragments/_sidebar.jsp" />

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto" style="background-color: #f7f9fb;">
            <div class="container-xl px-4 py-5">
                
                <!-- Page Header -->
                <div class="mb-4">
                    <h2 class="font-headline-lg mb-1" style="color: var(--primary); font-weight: 600;">Tạo khoản phạt thủ công</h2>
                    <p class="font-body-md text-on-surface-variant">Ghi nhận hình phạt đối với sách bị mất, hư hỏng vật lý hoặc vi phạm thư viện khác.</p>
                </div>

                <!-- Form Card -->
                <div class="raised-card p-4 border border-outline-variant bg-white" style="max-width: 720px;">
                    <form action="${pageContext.request.contextPath}/librarian/fine-list.jsp" method="POST" id="fineCreateForm">
                        
                        <!-- Search Member -->
                        <div class="mb-4">
                            <label class="form-label fw-bold text-on-surface-variant" style="font-size: 14px;">1. Tìm kiếm thành viên thư viện</label>
                            <div class="input-group">
                                <input type="text" id="memberSearch" class="form-control rounded-start-3" placeholder="Nhập mã sinh viên/giảng viên hoặc email..." />
                                <button type="button" onclick="lookupMember()" class="btn btn-primary-custom rounded-end-3 px-4 fw-bold">Tìm kiếm</button>
                            </div>
                            <!-- Result Box -->
                            <div id="memberResultBox" class="mt-3 p-3 border rounded-3 bg-light d-none" style="border-color: var(--outline-variant) !important;">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="d-flex align-items-center justify-content-center rounded-circle bg-primary-fixed text-primary-custom fw-bold" style="width: 40px; height: 40px;">
                                            JV
                                        </div>
                                        <div>
                                            <p class="mb-0 fw-bold">Jordan Vance</p>
                                            <small class="text-muted">Sinh viên • ID: 230014 • j.vance@uni.edu</small>
                                        </div>
                                    </div>
                                    <span class="badge rounded-pill bg-success-subtle text-success fw-bold px-3 py-1.5">HOẠT ĐỘNG</span>
                                </div>
                            </div>
                        </div>

                        <!-- Select Borrowed Book -->
                        <div class="mb-4">
                            <label class="form-label fw-bold text-on-surface-variant" style="font-size: 14px;">2. Chọn bản sao vi phạm</label>
                            <select id="bookSelect" class="form-select rounded-3 py-2.5" disabled>
                                <option value="">-- Tìm kiếm và chọn thành viên trước --</option>
                                <option value="LOAN-9902" data-due="2026-05-15">Introduction to Algorithms (Hạn trả: 15/05/2026)</option>
                                <option value="LOAN-0082" data-due="2026-06-01">Design Patterns: Reusable Software (Hạn trả: 01/06/2026)</option>
                            </select>
                        </div>

                        <!-- Fine Category / Reason -->
                        <div class="mb-4">
                            <label class="form-label fw-bold text-on-surface-variant d-block mb-2" style="font-size: 14px;">3. Lý do vi phạm</label>
                            <div class="d-flex flex-column gap-2">
                                <label class="border rounded-3 p-3 d-flex align-items-center gap-3 cursor-pointer" style="border-color: var(--outline-variant) !important;">
                                    <input type="radio" name="violationReason" value="DAMAGED" class="form-check-input" checked />
                                    <div>
                                        <p class="mb-0 fw-bold">Hư hỏng vật lý</p>
                                        <small class="text-muted">Rách trang, vào nước, viết vẽ bậy, làm hỏng</small>
                                    </div>
                                </label>
                                <label class="border rounded-3 p-3 d-flex align-items-center gap-3 cursor-pointer" style="border-color: var(--outline-variant) !important;">
                                    <input type="radio" name="violationReason" value="LOST" class="form-check-input" />
                                    <div>
                                        <p class="mb-0 fw-bold">Bị mất / Cần thay thế</p>
                                        <small class="text-muted">Thành viên báo mất, cần thay thế bản sao</small>
                                    </div>
                                </label>
                                <label class="border rounded-3 p-3 d-flex align-items-center gap-3 cursor-pointer" style="border-color: var(--outline-variant) !important;">
                                    <input type="radio" name="violationReason" value="OTHER" class="form-check-input" />
                                    <div>
                                        <p class="mb-0 fw-bold">Vi phạm khác</p>
                                        <small class="text-muted">Sao chép trái phép, vi phạm nội quy</small>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <!-- Fine Amount -->
                        <div class="mb-4">
                            <label class="form-label fw-bold text-on-surface-variant" style="font-size: 14px;">4. Số tiền phạt ($)</label>
                            <div class="input-group" style="max-width: 240px;">
                                <span class="input-group-text bg-light border-outline-variant">$</span>
                                <input type="number" step="0.01" class="form-control rounded-end-3 py-2 border-outline-variant" placeholder="0.00" value="12.00" required />
                            </div>
                        </div>

                        <!-- Notes -->
                        <div class="mb-4">
                            <label class="form-label fw-bold text-on-surface-variant" style="font-size: 14px;">5. Mô tả thêm</label>
                            <textarea class="form-control rounded-3 py-2 border-outline-variant" rows="4" placeholder="Chi tiết tình trạng hư hỏng hoặc hoàn cảnh mất sách tại đây..."></textarea>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="d-flex align-items-center gap-2 pt-3 border-top">
                            <button type="submit" class="btn btn-primary-custom rounded-pill px-4 py-2.5 fw-bold">Tạo biên bản phạt</button>
                            <a href="${pageContext.request.contextPath}/librarian/fine-list.jsp" class="btn btn-light rounded-pill px-4 py-2.5 fw-bold">Hủy</a>
                        </div>
                    </form>
                </div>

            </div><!-- /.container-xl -->
            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function lookupMember() {
            const searchInput = document.getElementById('memberSearch').value.trim();
            if (searchInput !== '') {
                const box = document.getElementById('memberResultBox');
                box.classList.remove('d-none');
                
                const select = document.getElementById('bookSelect');
                select.disabled = false;
                select.options[0].text = "-- Chọn bản sao đang mượn --";
            }
        }
    </script>
</body>
</html>
