<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Policies Page -->

<!-- ── Page Hero Banner ──────────────────────────────────────────────── -->
<div style="background: linear-gradient(135deg, var(--primary-color) 0%, #b85c00 100%); padding: 56px 0 40px;">
    <div class="container-xl px-4">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0" style="font-size: 13px;">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/" class="text-decoration-none" style="color: rgba(255,255,255,0.7);">Trang chủ</a>
                </li>
                <li class="breadcrumb-item active" style="color: rgba(255,255,255,0.9);">Chính sách</li>
            </ol>
        </nav>
        <h1 class="fw-bold text-white mb-1" style="font-size: 36px;">Chính sách &amp; Hướng dẫn Thư viện</h1>
        <p class="mb-0" style="color: rgba(255,255,255,0.75); font-size: 16px;">
            Quy tắc, quy định và tiêu chuẩn vận hành dành cho tất cả bạn đọc thư viện.
        </p>
    </div>
</div>

<!-- ── Main Content ──────────────────────────────────────────────────── -->
<section class="py-5" id="policies" style="background-color: var(--bs-body-bg);">
    <div class="container-xl px-4">
        <div class="policy-container shadow-sm">

            <!-- ── Sidebar Tabs ──────────────────────────────────── -->
            <div class="policy-sidebar">
                <p class="fw-bold text-uppercase mb-2 px-1"
                    style="font-size: 10px; letter-spacing: 0.1em; color: var(--text-muted-custom);">Các phần</p>

                <button class="policy-btn active" onclick="switchPolicyTab(event, 'pane-general')">
                    <i class="bi bi-shield-check"></i>
                    Chính sách chung
                </button>
                <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-intro')">
                    <i class="bi bi-building-check"></i>
                    Giới thiệu về Thư viện
                </button>
                <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-rules')">
                    <i class="bi bi-journal-text"></i>
                    Nội quy &amp; Quy định
                </button>
                <button class="policy-btn" onclick="switchPolicyTab(event, 'pane-hours')">
                    <i class="bi bi-clock"></i>
                    Giờ mở cửa
                </button>
            </div>

            <!-- ── Content Area ──────────────────────────────────── -->
            <div class="policy-content">

                <!-- TAB 1: GENERAL POLICY -->
                <div class="policy-pane active" id="pane-general">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-shield-check fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Chính sách chung của Thư viện</h3>
                                <p class="policy-subtitle mb-0">Hướng dẫn &amp; Phạm vi áp dụng</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-people-fill" style="color: var(--primary-color);"></i>
                            1. Phạm vi áp dụng
                        </h4>
                        <p class="mb-2 text-secondary">Chính sách này áp dụng cho tất cả người dùng thư viện hợp lệ, bao gồm:</p>
                        <ul class="policy-list">
                            <li>Sinh viên</li>
                            <li>Giảng viên</li>
                            <li>Cán bộ nhân viên</li>
                            <li>Cựu sinh viên (nếu được phép)</li>
                            <li>Khách hoặc các cá nhân khác được nhà trường cấp phép</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-book-half" style="color: var(--primary-color);"></i>
                            2. Quyền sử dụng thư viện
                        </h4>
                        <div class="row g-3 mt-1">
                            <div class="col-md-6">
                                <div class="rounded-3 p-3" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="font-size: 14px; color: var(--bs-body-color);">
                                        <i class="bi bi-building me-1" style="color: var(--primary-color);"></i> Không gian học tập
                                    </h6>
                                    <p class="text-secondary small mb-0">Sử dụng phòng đọc, phòng học nhóm và các trang thiết bị thư viện theo quy định.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="font-size: 14px; color: var(--bs-body-color);">
                                        <i class="bi bi-wifi me-1" style="color: var(--primary-color);"></i> Internet &amp; Tài nguyên điện tử
                                    </h6>
                                    <p class="text-secondary small mb-0">Truy cập các cơ sở dữ liệu học thuật, tạp chí, sách điện tử và tài nguyên trực tuyến được cấp phép.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="font-size: 14px; color: var(--bs-body-color);">
                                        <i class="bi bi-eye me-1" style="color: var(--primary-color);"></i> Sử dụng tại chỗ
                                    </h6>
                                    <p class="text-secondary small mb-0">Đọc tài liệu tại chỗ và tra cứu thông tin thư mục theo quy định.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="font-size: 14px; color: var(--bs-body-color);">
                                        <i class="bi bi-arrow-left-right me-1" style="color: var(--primary-color);"></i> Mượn &amp; Trả tài liệu
                                    </h6>
                                    <p class="text-secondary small mb-0">Người dùng hợp lệ được mượn tài liệu thư viện theo đặc quyền quy định.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-database-fill" style="color: var(--primary-color);"></i>
                            3. Truy cập tài nguyên học thuật
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Người dùng có thể truy cập các bài báo nghiên cứu, công bố học thuật, luận văn, luận án và kho lưu trữ số. Việc sử dụng phải tuân thủ luật bản quyền hiện hành, quy định sở hữu trí tuệ và thỏa thuận cấp phép.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-calendar-event-fill" style="color: var(--primary-color);"></i>
                            4. Sự kiện và hoạt động thư viện
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Thư viện tổ chức các hoạt động nhằm thúc đẩy văn hóa đọc và gắn kết học thuật, bao gồm hội chợ sách, hội thảo, chuyên đề, triển lãm và các chương trình hỗ trợ nghiên cứu.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-person-check-fill" style="color: var(--primary-color);"></i>
                            5. Trách nhiệm của người dùng
                        </h4>
                        <ul class="policy-list">
                            <li>Tôn trọng và bảo vệ tài sản, tài nguyên của thư viện.</li>
                            <li>Tuân thủ tất cả các quy tắc, chính sách của thư viện và hướng dẫn của nhân viên.</li>
                            <li>Giữ gìn không gian yên tĩnh và văn minh.</li>
                            <li>Không sao chép, phân phối trái phép hoặc lạm dụng các tài liệu có bản quyền.</li>
                            <li>Bồi thường cho các tài liệu thư viện bị mất, hỏng hoặc xử lý sai quy định.</li>
                        </ul>
                    </div>

                    <div class="policy-card" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <h4 class="policy-card-title">
                            <i class="bi bi-shield-fill-check" style="color: var(--primary-color);"></i>
                            6. Điều khoản bổ sung
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Thư viện có quyền sửa đổi chính sách, cập nhật quy định mượn trả và truy cập, và tạm ngừng hoặc giới hạn dịch vụ để bảo trì, nâng cấp hoặc phục vụ yêu cầu vận hành. Chính sách này có hiệu lực kể từ ngày ban hành.
                        </p>
                    </div>
                </div>

                <!-- TAB 2: ABOUT THE LIBRARY -->
                <div class="policy-pane" id="pane-intro">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-building-check fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Giới thiệu Thư viện Đại học</h3>
                                <p class="policy-subtitle mb-0">Về UniLib &amp; Sứ mệnh</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <p class="mb-0 fw-medium" style="font-size: 16px; line-height: 1.7; color: var(--primary-hover);">
                            Thư viện Đại học là trung tâm thông tin và tài nguyên học thuật được thành lập nhằm hỗ trợ hiệu quả cho công tác giảng dạy, học tập, nghiên cứu khoa học và phát triển tri thức của giảng viên, cán bộ và sinh viên.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-gear-fill" style="color: var(--primary-color);"></i>
                            Chức năng của Thư viện
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Thư viện có chức năng thu thập, tổ chức, lưu trữ, bảo quản và cung cấp giáo trình, tài liệu tham khảo cùng thông tin khoa học phục vụ nhu cầu đào tạo, nghiên cứu và học tập trong trường.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-check2-all" style="color: var(--primary-color);"></i>
                            Sứ mệnh của Thư viện
                        </h4>
                        <ul class="policy-list">
                            <li>Thu thập, bổ sung và phát triển nguồn tài nguyên phù hợp với các ngành đào tạo và hướng nghiên cứu.</li>
                            <li>Xử lý, lưu trữ và bảo quản nguồn tài nguyên thông tin dưới dạng vật lý và dạng số.</li>
                            <li>Cung cấp các dịch vụ tra cứu thư mục, mượn trả và hỗ trợ khai thác thông tin.</li>
                            <li>Xây dựng và phát triển các cơ sở dữ liệu học thuật, thư viện số và cổng thông tin tài nguyên điện tử.</li>
                            <li>Thu thập và lưu trữ các công trình công bố, luận văn, luận án, khóa luận tốt nghiệp của trường.</li>
                            <li>Hướng dẫn người dùng khai thác và sử dụng hiệu quả nguồn tài nguyên thông tin.</li>
                            <li>Tư vấn cho ban giám hiệu nhà trường về chiến lược phát triển nguồn tài nguyên.</li>
                            <li>Thiết lập quan hệ hợp tác với các thư viện và tổ chức nghiên cứu bên ngoài.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-collection-fill" style="color: var(--primary-color);"></i>
                            Tài nguyên Thư viện
                        </h4>
                        <div class="row g-2 mt-1">
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-book mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Giáo trình, sách tham khảo và chuyên khảo</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-newspaper mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Tạp chí khoa học trong nước và quốc tế</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-mortarboard mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Luận văn, luận án và khóa luận tốt nghiệp</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-database mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Cơ sở dữ liệu trực tuyến và thư viện số</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-film mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Tài liệu đa phương tiện và học liệu điện tử</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-globe mt-1 flex-shrink-0" style="color: var(--primary-color);"></i>
                                    <span class="small text-secondary">Tài nguyên từ các nhà xuất bản quốc tế và cơ sở dữ liệu toàn cầu</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB 3: RULES & REGULATIONS -->
                <div class="policy-pane" id="pane-rules">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-journal-text fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Nội quy &amp; Quy định Thư viện</h3>
                                <p class="policy-subtitle mb-0">Quy định bắt buộc đối với tất cả bạn đọc</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Điều 1</span>
                            Thẻ thư viện
                        </h4>
                        <p class="mb-0 text-secondary">Thẻ sinh viên cũng chính là thẻ thư viện. Hãy sử dụng thẻ sinh viên hoặc thẻ cán bộ để tiếp cận dịch vụ và tài nguyên thư viện. Thẻ thư viện không được phép cho mượn.</p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Điều 2</span>
                            Giờ mở cửa
                        </h4>
                        <div class="table-responsive">
                            <table class="table-policy">
                                <thead>
                                    <tr>
                                        <th>Ngày</th>
                                        <th>Giờ</th>
                                        <th>Chế độ phục vụ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Thứ Hai – Thứ Sáu</strong></td>
                                        <td>08:15 – 21:00</td>
                                        <td>Đầy đủ dịch vụ</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Thứ Bảy – Chủ Nhật</strong></td>
                                        <td>08:00 – 17:00</td>
                                        <td><span class="badge rounded-pill" style="background-color: #f97316; font-size: 11px;">Chỉ tự học</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Điều 3</span>
                            Các dịch vụ thư viện
                        </h4>
                        <div class="row g-2 mt-1">
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-arrow-left-right" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Mượn / Trả sách</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-search" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Tra cứu thư mục</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-headset" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Tư vấn thông tin</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-wifi" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Tài nguyên điện tử</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-clipboard-check" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Yêu cầu tài liệu</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-4">
                                <div class="d-flex align-items-center gap-2 p-2 rounded-2" style="background-color: var(--surface-container-low);">
                                    <i class="bi bi-people" style="color: var(--primary-color); font-size: 13px;"></i>
                                    <span class="small fw-medium">Phòng làm việc nhóm</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Điều 4</span>
                            Quy định chung
                        </h4>
                        <ul class="policy-list">
                            <li><strong>4.1 Kiểm tra thẻ:</strong> Xuất trình thẻ hợp lệ để vào cửa. Không cho mượn thẻ dưới mọi hình thức.</li>
                            <li><strong>4.2 Giữ yên lặng:</strong> Nghiêm cấm nói chuyện to trong toàn bộ khuôn viên Thư viện.</li>
                            <li><strong>4.3 Giữ vệ sinh:</strong> Giữ gìn vệ sinh chung. Nghiêm cấm hút thuốc, viết vẽ bậy, xả rác.</li>
                            <li><strong>4.4 Đồ ăn &amp; Thức uống:</strong> Nghiêm cấm mang đồ ăn, nước uống và các chất gây cháy nổ vào thư viện.</li>
                            <li><strong>4.5 Thiết bị di động:</strong> Để điện thoại ở chế độ im lặng. Không nghe gọi điện thoại trong phòng tự học.</li>
                            <li><strong>4.6 Bảo quản sách:</strong> Không viết vẽ bậy, dùng bút chì, bút mực hoặc bút đánh dấu vào sách.</li>
                            <li><strong>4.7 Bảo vệ trang sách:</strong> Không gấp mép trang sách, xé trang sách.</li>
                            <li><strong>4.8 Phòng ngừa hư hỏng:</strong> Không để sách bị ẩm ướt, mốc hỏng hoặc rách nát.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: var(--primary-color); font-size: 11px;">Điều 5</span>
                            Chính sách Mượn trả
                        </h4>
                        <ul class="policy-list">
                            <li><strong>5.1 Trả tài liệu:</strong> Để sách đúng nơi quy định. Không tự ý xếp sách lên giá.</li>
                            <li><strong>5.2 Mang sách ra ngoài:</strong> Không mang tài liệu ra khỏi thư viện khi chưa được sự cho phép của thủ thư.</li>
                            <li><strong>5.3 Giáo trình:</strong> Mượn theo lịch học phần. Được gia hạn tối đa 1 tuần nếu có lý do chính đáng.</li>
                            <li><strong>5.4 Sách tham khảo:</strong> Mượn tối đa 10 cuốn. Thời hạn: 1 tuần (tiếng Việt) / 2 tuần (tiếng nước ngoài). Tối đa gia hạn 4 lần.</li>
                            <li><strong>5.5 Kiểm tra khi mượn:</strong> Kiểm tra tình trạng sách khi nhận và báo cho thủ thư các vết rách, hỏng hiện có.</li>
                        </ul>
                    </div>

                    <div class="policy-card" style="border-left: 4px solid #dc3545;">
                        <h4 class="policy-card-title">
                            <span class="badge fw-semibold me-2 rounded-2" style="background-color: #dc3545; font-size: 11px;">Điều 6</span>
                            Tiền phạt &amp; Hình phạt
                        </h4>
                        <ul class="policy-list">
                            <li><strong>6.1 Vi phạm:</strong> Bạn đọc vi phạm Điều 4 và Điều 5 có thể bị nhắc nhở, phạt hành chính hoặc mời ra khỏi thư viện.</li>
                            <li><strong>6.2 Tài liệu bị hỏng:</strong> Tài liệu bị hỏng nhưng vẫn sử dụng được sẽ chịu phí phạt tùy theo mức độ hỏng hóc.</li>
                            <li><strong>6.3 Tiền phạt quá hạn:</strong> <strong style="color: #dc3545;">5,000 VNĐ / tài liệu / ngày</strong> (bao gồm cả cuối tuần và ngày lễ).</li>
                            <li><strong>6.4 Bồi thường:</strong> Bạn đọc phải bồi thường cho bất kỳ hư hỏng tài sản nào theo quy định.</li>
                        </ul>
                    </div>
                </div>

                <!-- TAB 4: OPENING HOURS -->
                <div class="policy-pane" id="pane-hours">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-clock fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Giờ mở cửa Thư viện</h3>
                                <p class="policy-subtitle mb-0">Giờ mở cửa tiêu chuẩn</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-calendar3" style="color: var(--primary-color);"></i>
                            1. Lịch mở cửa hàng tuần
                        </h4>
                        <div class="table-responsive">
                            <table class="table-policy">
                                <thead>
                                    <tr>
                                        <th>Ngày</th>
                                        <th>Giờ mở cửa</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Thứ Hai – Thứ Sáu</strong></td>
                                        <td>08:00 – 20:00</td>
                                        <td><span class="badge rounded-pill" style="background-color: #198754; font-size: 11px;">Mở cửa</span></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Thứ Bảy</strong></td>
                                        <td>08:00 – 17:00</td>
                                        <td><span class="badge rounded-pill" style="background-color: #198754; font-size: 11px;">Mở cửa</span></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Chủ Nhật</strong></td>
                                        <td>—</td>
                                        <td><span class="badge rounded-pill bg-danger" style="font-size: 11px;">Đóng cửa</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-arrow-left-right" style="color: var(--primary-color);"></i>
                            2. Dịch vụ Mượn &amp; Trả
                        </h4>
                        <div class="row g-3 mt-1">
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 text-center" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border: 1px solid var(--primary-light);">
                                    <i class="bi bi-sun" style="font-size: 28px; color: var(--primary-color);"></i>
                                    <h6 class="fw-bold mt-2 mb-1">Ca sáng</h6>
                                    <p class="mb-0 fw-semibold" style="color: var(--primary-color);">08:00 – 12:00</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 text-center" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border: 1px solid var(--primary-light);">
                                    <i class="bi bi-brightness-alt-high" style="font-size: 28px; color: var(--primary-color);"></i>
                                    <h6 class="fw-bold mt-2 mb-1">Ca chiều</h6>
                                    <p class="mb-0 fw-semibold" style="color: var(--primary-color);">13:00 – 17:00</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <h4 class="policy-card-title">
                            <i class="bi bi-info-circle-fill" style="color: var(--primary-color);"></i>
                            3. Lưu ý quan trọng
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Ngoài giờ phục vụ mượn trả chính thức, thư viện chỉ phục vụ phòng tự học và đọc tại chỗ. Quý bạn đọc vui lòng sắp xếp thời gian hợp lý.
                        </p>
                    </div>
                </div>

            </div><!-- /.policy-content -->
        </div><!-- /.policy-container -->
    </div>
</section>
