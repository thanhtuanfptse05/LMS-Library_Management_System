document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('.bm-auto-filter');
    let timer;
    form.querySelector('[name="q"]').addEventListener('input', function () {
        window.clearTimeout(timer);
        timer = window.setTimeout(function () { form.submit(); }, 450);
    });
    form.querySelector('[name="status"]').addEventListener('change', function () { form.submit(); });
    document.querySelectorAll('.bm-modal[data-auto-open="true"]').forEach(function (modal) {
        window.bootstrap.Modal.getOrCreateInstance(modal).show();
    });
});
