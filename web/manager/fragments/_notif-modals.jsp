<%-- Fragment: _notif-modals.jsp — Modal xem chi tiết + Modal xác nhận xóa thông báo --%>

<%-- ════════════════ DETAIL MODAL ════════════════ --%>
<div class="modal fade" id="notifDetailModal" tabindex="-1" aria-labelledby="notifDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
        <div class="modal-content border-0 rounded-4 overflow-hidden shadow-lg">
            <div class="modal-header border-0 px-4 py-3" id="modalHeaderBg" style="background-color: #f7f9fb;">
                <div class="d-flex align-items-center gap-3 w-100">
                    <div id="modalTypeIcon" class="notif-type-icon icon-general">
                        <span class="material-symbols-outlined" id="modalTypeIconSymbol"
                              style="font-variation-settings: 'FILL' 1; font-size: 22px;">campaign</span>
                    </div>
                    <div class="flex-grow-1">
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span id="modalTypeBadge" class="notif-badge-type type-general">Thông tin</span>
                            <span id="modalPinBadge" class="d-none material-symbols-outlined"
                                  style="font-size: 14px; color: var(--primary); font-variation-settings: 'FILL' 1;">push_pin</span>
                        </div>
                        <h5 class="modal-title fw-bold" id="notifDetailModalLabel"
                            style="color: #191c1e; font-size: 17px;">Chi tiết thông báo</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
            </div>
            <div class="modal-body px-4 py-3">
                <div class="d-flex align-items-center gap-3 mb-3 pb-3" style="border-bottom: 1px solid #f0f0f0;">
                    <div class="d-flex align-items-center gap-2 text-secondary small">
                        <span class="material-symbols-outlined" style="font-size: 16px;">person</span>
                        <span id="modalAuthor"></span>
                    </div>
                    <div class="d-flex align-items-center gap-2 text-secondary small">
                        <span class="material-symbols-outlined" style="font-size: 16px;">schedule</span>
                        <span id="modalTime"></span>
                    </div>
                </div>
                <div id="modalContent" class="text-secondary" style="line-height: 1.75; font-size: 14.5px;"></div>
            </div>
            <div class="modal-footer border-0 px-4 py-3" style="background-color: #fafafa;">
                <button type="button" class="btn rounded-3 px-4 fw-semibold"
                        style="background: var(--surface-container-high); color: var(--on-surface-variant);"
                        data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<%-- ════════════════ Confirm Delete Modal ════════════════ --%>
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 rounded-4 overflow-hidden shadow-lg">
            <div class="modal-body text-center p-4">
                <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                     style="width: 64px; height: 64px; background: rgba(239,68,68,0.08);">
                    <span class="material-symbols-outlined" style="font-size: 32px; color: #ef4444; font-variation-settings: 'FILL' 1;">delete_forever</span>
                </div>
                <h6 class="fw-bold mb-2" style="color: var(--on-surface);">Xác nhận xóa thông báo?</h6>
                <p class="small mb-4" style="color: var(--on-surface-variant);" id="deleteModalTitle"></p>
                <div class="d-flex gap-2">
                    <button type="button" class="btn flex-grow-1 rounded-3"
                            style="background: var(--surface-container-high); color: var(--on-surface-variant);"
                            data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn flex-grow-1 rounded-3 fw-bold"
                            id="confirmDeleteBtn"
                            style="background: #ef4444; color: white;">Xóa</button>
                </div>
            </div>
        </div>
    </div>
</div>
