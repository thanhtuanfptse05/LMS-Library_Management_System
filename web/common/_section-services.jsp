<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Services Page -->

<!-- ── Page Hero Banner ──────────────────────────────────────────────── -->
<div style="background: linear-gradient(135deg, var(--primary-color) 0%, #b85c00 100%); padding: 56px 0 40px;">
    <div class="container-xl px-4">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0" style="font-size: 13px;">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/" class="text-decoration-none" style="color: rgba(255,255,255,0.7);">Trang chủ</a>
                </li>
                <li class="breadcrumb-item active" style="color: rgba(255,255,255,0.9);">Dịch vụ</li>
            </ol>
        </nav>
        <h1 class="fw-bold text-white mb-1" style="font-size: 36px;">Các dịch vụ thư viện</h1>
        <p class="mb-0" style="color: rgba(255,255,255,0.75); font-size: 16px;">
            Tất cả những gì bạn cần để truy cập, mượn và quản lý tài nguyên thư viện.
        </p>
    </div>
</div>

<!-- ── Main Content ──────────────────────────────────────────────────── -->
<section class="py-5" id="services" style="background-color: var(--bs-body-bg);">
    <div class="container-xl px-4">
        <div class="policy-container shadow-sm">

            <!-- ── Sidebar Tabs ──────────────────────────────────── -->
            <div class="policy-sidebar">
                <p class="fw-bold text-uppercase mb-2 px-1"
                    style="font-size: 10px; letter-spacing: 0.1em; color: var(--text-muted-custom);">Thể loại</p>

                <button class="policy-btn active" onclick="switchServiceTab(event, 'pane-circulation')">
                    <i class="bi bi-arrow-left-right"></i>
                    Dịch vụ Mượn trả
                </button>
                <button class="policy-btn" onclick="switchServiceTab(event, 'pane-renewal')">
                    <i class="bi bi-arrow-clockwise"></i>
                    Dịch vụ Gia hạn
                </button>
                <button class="policy-btn" onclick="switchServiceTab(event, 'pane-fees')">
                    <i class="bi bi-cash-coin"></i>
                    Phí Thư viện
                </button>
            </div>

            <!-- ── Content Area ──────────────────────────────────── -->
            <div class="policy-content">

                <!-- TAB 1: CIRCULATION SERVICES -->
                <div class="policy-pane active" id="pane-circulation">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-arrow-left-right fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Dịch vụ Mượn trả</h3>
                                <p class="policy-subtitle mb-0">Mượn &amp; Trả tài liệu</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-info-circle-fill" style="color: var(--primary-color);"></i>
                            1. Mục đích
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Dịch vụ mượn và trả được thiết kế nhằm hỗ trợ sinh viên, giảng viên và nhân viên trong việc tiếp cận, khai thác và sử dụng hiệu quả tài nguyên học tập của thư viện phục vụ học tập, giảng dạy và nghiên cứu.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-people-fill" style="color: var(--primary-color);"></i>
                            2. Đối tượng phục vụ
                        </h4>
                        <p class="mb-2 text-secondary">Dịch vụ này áp dụng cho:</p>
                        <ul class="policy-list">
                            <li>Sinh viên và học viên đang theo học tại trường.</li>
                            <li>Giảng viên, cán bộ và nhân viên của trường.</li>
                            <li>Các đối tượng hợp lệ khác theo quy định của thư viện.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-journal-check" style="color: var(--primary-color);"></i>
                            3. Quy định Mượn tài liệu
                        </h4>
                        <h6 class="fw-bold mt-3 mb-1" style="color: var(--text-muted-custom);">3.1. Điều kiện mượn</h6>
                        <ul class="policy-list mb-3">
                            <li>Có thẻ sinh viên, thẻ cán bộ hoặc giấy tờ tùy thân hợp lệ.</li>
                            <li>Không sử dụng thẻ của người khác để mượn tài liệu thư viện.</li>
                            <li>Không vi phạm bất kỳ nội quy nào của thư viện.</li>
                        </ul>
                        <h6 class="fw-bold mt-3 mb-1" style="color: var(--text-muted-custom);">3.2. Quy trình mượn</h6>
                        <ul class="policy-list mb-3">
                            <li>Tìm kiếm và lựa chọn tài liệu phù hợp qua hệ thống tra cứu mục lục.</li>
                            <li>Mang tài liệu đến quầy mượn trả hoặc hoàn tất thủ tục mượn theo hướng dẫn.</li>
                            <li>Kiểm tra tình trạng vật lý của tài liệu trước khi hoàn tất thủ tục mượn.</li>
                        </ul>
                        <h6 class="fw-bold mt-3 mb-1" style="color: var(--text-muted-custom);">3.3. Thời hạn mượn</h6>
                        <ul class="policy-list mb-3">
                            <li>Thời hạn mượn thay đổi tùy thuộc vào loại tài liệu và đối tượng sử dụng.</li>
                            <li>Người dùng có thể gia hạn tài liệu nếu tài liệu đó chưa được người khác đặt trước.</li>
                        </ul>
                        <h6 class="fw-bold mt-3 mb-1" style="color: var(--text-muted-custom);">3.4. Trách nhiệm của bạn đọc</h6>
                        <ul class="policy-list">
                            <li>Bảo quản tốt tài liệu đã mượn trong suốt thời gian mượn.</li>
                            <li>Không viết, vẽ, tẩy xóa, xé rời, làm ướt hoặc làm hỏng tài liệu.</li>
                            <li>Thông báo cho thủ thư về bất kỳ hư hỏng nào đã có sẵn khi nhận tài liệu.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-box-arrow-in-left" style="color: var(--primary-color);"></i>
                            4. Quy định Trả tài liệu
                        </h4>
                        <ul class="policy-list">
                            <li>Người dùng phải trả tài liệu đã mượn vào hoặc trước ngày đến hạn.</li>
                            <li>Việc trả tài liệu phải được thực hiện tại quầy thư viện hoặc qua các hộp nhận trả tài liệu được chỉ định.</li>
                            <li>Người dùng có thể ủy quyền cho người khác trả tài liệu, nhưng vẫn phải chịu trách nhiệm.</li>
                        </ul>
                    </div>

                    <div class="policy-card" style="border-left: 4px solid #dc3545;">
                        <h4 class="policy-card-title">
                            <i class="bi bi-exclamation-triangle-fill" style="color: #dc3545;"></i>
                            5. Vi phạm &amp; Hình phạt
                        </h4>
                        <p class="mb-2 text-secondary">Người dùng có thể chịu các hình thức kỷ luật đối với:</p>
                        <ul class="policy-list mb-2">
                            <li>Trả tài liệu thư viện quá hạn.</li>
                            <li>Làm mất tài liệu thư viện.</li>
                            <li>Làm hỏng tài liệu thư viện.</li>
                            <li>Vi phạm các quy định khác của thư viện.</li>
                        </ul>
                        <p class="mb-0 text-muted small fst-italic">
                            * Các hình phạt và mức phạt cụ thể được áp dụng theo các quy định hiện hành của thư viện.
                        </p>
                    </div>

                    <div class="policy-card" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <h4 class="policy-card-title">
                            <i class="bi bi-headset" style="color: var(--primary-color);"></i>
                            6. Thông tin hỗ trợ
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Liên hệ thư viện để được hỗ trợ mượn, trả, gia hạn hoặc tìm kiếm tài liệu thông qua các kênh liên lạc chính thức.
                        </p>
                    </div>
                </div>

                <!-- TAB 2: RENEWAL SERVICES -->
                <div class="policy-pane" id="pane-renewal">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-arrow-clockwise fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Dịch vụ Gia hạn Tài liệu</h3>
                                <p class="policy-subtitle mb-0">Gia hạn thời gian mượn</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-info-circle-fill" style="color: var(--primary-color);"></i>
                            1. Mục đích
                        </h4>
                        <p class="mb-0 text-secondary" style="line-height: 1.7;">
                            Dịch vụ gia hạn hỗ trợ người dùng kéo dài thời gian mượn tài liệu khi cần thêm thời gian cho học tập, giảng dạy hoặc nghiên cứu.
                        </p>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-check2-circle" style="color: var(--primary-color);"></i>
                            2. Điều kiện Gia hạn
                        </h4>
                        <p class="mb-2 text-secondary">Gia hạn được chấp thuận với các điều kiện sau:</p>
                        <ul class="policy-list">
                            <li>Tài liệu hiện đang trong thời gian mượn hợp lệ (chưa quá hạn).</li>
                            <li>Tài liệu không bị hạn chế gia hạn theo quy định của thư viện.</li>
                            <li>Người dùng không có vi phạm nào về việc mượn hoặc trả tài liệu.</li>
                            <li>Tài liệu chưa được người dùng khác đặt trước hoặc yêu cầu.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-journal-text" style="color: var(--primary-color);"></i>
                            3. Quy định Gia hạn
                        </h4>
                        <ul class="policy-list">
                            <li>Số lần và thời gian gia hạn được quy định theo nội quy thư viện.</li>
                            <li>Thời gian gia hạn có thể thay đổi tùy theo loại tài liệu và đối tượng người dùng.</li>
                            <li>Thư viện có quyền từ chối yêu cầu gia hạn trong các trường hợp đặc biệt.</li>
                        </ul>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-grid-1x2" style="color: var(--primary-color);"></i>
                            4. Phương thức Gia hạn
                        </h4>
                        <div class="row g-3 mt-1">
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 h-100" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border: 1px solid var(--primary-light);">
                                    <div class="d-flex align-items-center gap-2 mb-2">
                                        <span class="badge fw-semibold rounded-pill" style="background-color: var(--primary-color); font-size: 11px;">★ Đề xuất</span>
                                    </div>
                                    <h6 class="fw-bold mb-1" style="color: var(--bs-body-color);">
                                        <i class="bi bi-laptop me-1" style="color: var(--primary-color);"></i> Gia hạn trực tuyến
                                    </h6>
                                    <p class="text-secondary small mb-0">Đăng nhập vào Hệ thống Quản lý Thư viện, vào danh sách tài liệu đang mượn và nhấp vào "Gia hạn".</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 h-100" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="color: var(--bs-body-color);">
                                        <i class="bi bi-envelope me-1" style="color: var(--primary-color);"></i> Yêu cầu qua Email
                                    </h6>
                                    <p class="text-secondary small mb-0">Gửi họ tên, Mã số Sinh viên/Cán bộ và thông tin tài liệu tới địa chỉ hỗ trợ của thư viện.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 h-100" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="color: var(--bs-body-color);">
                                        <i class="bi bi-building me-1" style="color: var(--primary-color);"></i> Trực tiếp
                                    </h6>
                                    <p class="text-secondary small mb-0">Đến trực tiếp quầy mượn trả trong giờ làm việc.</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="rounded-3 p-3 h-100" style="background-color: var(--surface-container-low); border: 1px solid rgba(219,194,176,0.3);">
                                    <h6 class="fw-bold mb-1" style="color: var(--bs-body-color);">
                                        <i class="bi bi-chat-dots me-1" style="color: var(--primary-color);"></i> Kênh hỗ trợ
                                    </h6>
                                    <p class="text-secondary small mb-0">Gửi qua fanpage chính thức, cổng hỗ trợ hoặc các nền tảng khác.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card" style="border-left: 4px solid #f97316;">
                        <h4 class="policy-card-title">
                            <i class="bi bi-exclamation-circle-fill" style="color: #f97316;"></i>
                            5. Lưu ý quan trọng
                        </h4>
                        <ul class="policy-list">
                            <li>Gửi yêu cầu gia hạn <strong>trước</strong> ngày đến hạn hiện tại.</li>
                            <li>Gửi yêu cầu gia hạn <strong>không đảm bảo</strong> sẽ được chấp thuận.</li>
                            <li>Xác minh ngày đến hạn mới trên hệ thống hoặc qua xác nhận của thư viện.</li>
                            <li>Nếu gia hạn bị từ chối, tài liệu phải được trả đúng hạn để tránh phí phạt.</li>
                        </ul>
                    </div>
                </div>

                <!-- TAB 3: LIBRARY FEES -->
                <div class="policy-pane" id="pane-fees">
                    <div class="policy-header">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <div class="icon-circle" style="width: 44px; height: 44px;">
                                <i class="bi bi-cash-coin fs-5"></i>
                            </div>
                            <div>
                                <h3 class="policy-title mb-0">Phí Thư viện</h3>
                                <p class="policy-subtitle mb-0">Cơ cấu Phí &amp; Quy định Phạt</p>
                            </div>
                        </div>
                    </div>

                    <div class="policy-card">
                        <h4 class="policy-card-title">
                            <i class="bi bi-clock-history" style="color: var(--primary-color);"></i>
                            Tiền phạt quá hạn
                        </h4>
                        <div class="table-responsive">
                            <table class="table-policy">
                                <thead>
                                    <tr>
                                        <th>Vi phạm</th>
                                        <th>Mức phạt</th>
                                        <th>Ghi chú</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Trả quá hạn</td>
                                        <td><strong style="color: #dc3545;">5,000 VNĐ / tài liệu / ngày</strong></td>
                                        <td>Bao gồm cả cuối tuần &amp; ngày lễ</td>
                                    </tr>
                                    <tr>
                                        <td>Mất tài liệu</td>
                                        <td>Chi phí thay thế</td>
                                        <td>Mua tài liệu thay thế tương đương</td>
                                    </tr>
                                    <tr>
                                        <td>Hỏng tài liệu (có thể sửa)</td>
                                        <td>Tùy thuộc vào mức độ hỏng</td>
                                        <td>Do thủ thư đánh giá</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="policy-card text-center py-4" style="background: linear-gradient(135deg, #fff9f5, #fff3e8); border-color: var(--primary-light);">
                        <i class="bi bi-bell" style="font-size: 48px; color: var(--primary-color);"></i>
                        <h5 class="fw-bold mt-3 mb-2">Bảng Phí Đầy Đủ Sẽ Sớm Ra Mắt</h5>
                        <p class="text-muted mb-3" style="max-width: 400px; margin: 0 auto;">
                            Bảng phí và tiền phạt thư viện đầy đủ đang được hoàn thiện. Liên hệ quầy mượn trả để biết thông tin phí hiện tại.
                        </p>
                        <a href="#contact" class="btn btn-primary-custom px-4 py-2 rounded-3 fw-semibold" style="font-size: 14px;">
                            <i class="bi bi-headset me-1"></i> Liên hệ Thư viện
                        </a>
                    </div>
                </div>

            </div><!-- /.policy-content -->
        </div><!-- /.policy-container -->
    </div>
</section>
