<%-- Fragment: _user_lock_modal.jsp — Modal chọn lý do khóa tài khoản --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="modal fade" id="lockUserModal" tabindex="-1" aria-labelledby="lockUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 raised-card">
            
            <div class="modal-header bg-white border-bottom border-outline-variant py-3 px-4">
                <h5 class="modal-title fw-bold text-danger d-flex align-items-center gap-2" id="lockUserModalLabel">
                    <span class="material-symbols-outlined text-danger">lock</span> Khóa tài khoản
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin/user/update" method="POST" id="lockUserForm">
                <input type="hidden" name="action" value="toggleStatus">
                <input type="hidden" name="status" value="locked">
                <input type="hidden" name="userId" id="lockModalUserId">
                
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <p class="text-on-surface-variant mb-2" style="font-size: 14px;">Bạn có chắc chắn muốn khóa tài khoản sau đây không?</p>
                        <div class="p-3 rounded-3 mb-3" style="background-color: #f8f9fa; border: 1px solid #e9ecef;">
                            <div class="d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined text-muted" style="font-size: 20px;">account_circle</span>
                                <span class="fw-bold text-dark" id="lockModalUserText">—</span>
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <label for="lockModalReason" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Lý do khóa tài khoản <span class="text-danger">*</span></label>
                        <select class="form-select config-input w-100" id="lockModalReason" name="lockReason" required>
                            <option value="adminban" selected>Bị cấm bởi Admin (adminban)</option>
                            <option value="unpaid">Nợ tiền phạt thư viện (unpaid)</option>
                            <option value="securitybreach">Vi phạm bảo mật / Đăng nhập sai nhiều lần (securitybreach)</option>
                        </select>
                    </div>
                </div>
                
                <div class="modal-footer bg-surface-container-low border-top border-outline-variant py-3 px-4">
                    <button type="button" class="btn btn-outline-secondary rounded-3 px-3 fw-bold" style="font-size: 14px;" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger rounded-3 px-4 fw-bold d-flex align-items-center gap-1" style="font-size: 14px;">
                        <span class="material-symbols-outlined" style="font-size: 18px;">lock</span> Khóa tài khoản
                    </button>
                </div>
            </form>

        </div>
    </div>
</div>
