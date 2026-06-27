document.addEventListener('DOMContentLoaded', function () {
    if (window.bootstrap) {
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function (trigger) {
            window.bootstrap.Tooltip.getOrCreateInstance(trigger);
        });
    }

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

    initBookTitleDrawer();
});

function initBookTitleDrawer() {
    const drawer = document.querySelector('.bm-book-drawer');
    const backdrop = document.querySelector('.bm-drawer-backdrop');
    const content = document.querySelector('[data-book-drawer-content]');

    if (!drawer || !backdrop || !content) {
        return;
    }

    let lastTrigger = null;

    function openDrawer(bookId, trigger) {
        const template = document.getElementById('bookDrawerTemplate-' + bookId);
        if (!template) {
            return;
        }

        lastTrigger = trigger || null;
        content.replaceChildren(template.content.cloneNode(true));
        drawer.classList.add('is-open');
        backdrop.hidden = false;
        requestAnimationFrame(function () {
            backdrop.classList.add('is-visible');
        });
        drawer.setAttribute('aria-hidden', 'false');
        document.body.classList.add('bm-drawer-open');

        const closeButton = drawer.querySelector('[data-book-drawer-close]');
        if (closeButton) {
            closeButton.focus();
        }
    }

    function closeDrawer() {
        drawer.classList.remove('is-open');
        backdrop.classList.remove('is-visible');
        drawer.setAttribute('aria-hidden', 'true');
        document.body.classList.remove('bm-drawer-open');
        window.setTimeout(function () {
            if (!drawer.classList.contains('is-open')) {
                backdrop.hidden = true;
                content.replaceChildren();
            }
        }, 180);

        if (lastTrigger && typeof lastTrigger.focus === 'function') {
            lastTrigger.focus();
        }
    }

    document.querySelectorAll('[data-book-drawer-trigger]').forEach(function (trigger) {
        trigger.addEventListener('click', function (event) {
            const interactive = event.target.closest('a, button, input, select, textarea, [data-bs-toggle]');
            if (interactive && interactive !== trigger && !interactive.hasAttribute('data-book-drawer-trigger')) {
                return;
            }
            event.preventDefault();
            event.stopPropagation();
            openDrawer(trigger.dataset.bookId, trigger);
        });

        trigger.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' || event.key === ' ') {
                event.preventDefault();
                openDrawer(trigger.dataset.bookId, trigger);
            }
        });
    });

    document.querySelectorAll('[data-book-drawer-close]').forEach(function (closeTrigger) {
        closeTrigger.addEventListener('click', closeDrawer);
    });

    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && drawer.classList.contains('is-open')) {
            closeDrawer();
        }
    });
}
