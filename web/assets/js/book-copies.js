document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.bm-modal[data-auto-open="true"]').forEach(function (modal) {
        if (window.bootstrap) {
            window.bootstrap.Modal.getOrCreateInstance(modal).show();
        }
    });
});
