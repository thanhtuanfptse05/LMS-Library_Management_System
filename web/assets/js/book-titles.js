document.addEventListener('DOMContentLoaded', function () {
    const editModal = document.querySelector('#editBookModal[data-auto-open="true"]');
    if (editModal && window.bootstrap) {
        window.bootstrap.Modal.getOrCreateInstance(editModal).show();
    }
});
