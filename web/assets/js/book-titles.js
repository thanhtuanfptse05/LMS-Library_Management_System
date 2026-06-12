document.addEventListener('DOMContentLoaded', function () {
    const editModal = document.querySelector('#editBookModal[data-auto-open="true"]');
    if (editModal && window.bootstrap) {
        window.bootstrap.Modal.getOrCreateInstance(editModal).show();
    }

    document.querySelectorAll('[data-cover-input]').forEach(function (input) {
        input.addEventListener('change', function () {
            const file = input.files && input.files[0];
            const upload = input.closest('.bm-cover-upload');
            const preview = upload.querySelector('[data-cover-preview]');
            const placeholder = upload.querySelector('[data-cover-placeholder]');
            if (!file) {
                return;
            }
            preview.src = URL.createObjectURL(file);
            preview.hidden = false;
            if (placeholder) {
                placeholder.hidden = true;
            }
        });
    });
});
