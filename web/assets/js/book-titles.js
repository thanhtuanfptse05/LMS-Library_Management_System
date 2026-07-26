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

    initChoicePickers();
    initBookTitleDrawer();
    initPriceInputs();
});

/**
 * Ô nhập giá sách (VNĐ) hiển thị dấu chấm phân cách hàng nghìn để thủ thư không phải
 * đếm từng số 0. Máy chủ vẫn nhận số thuần: dấu chấm được gỡ ngay trước khi form submit.
 *
 * Giá tiền Việt Nam không dùng phần thập phân nên ô này chỉ nhận số nguyên. Nếu giá trị
 * lấy từ CSDL lại có phần lẻ khác 0, ô được giữ nguyên dạng thô để không làm mất dữ liệu.
 */
function initPriceInputs() {
    document.querySelectorAll('[data-price-input]').forEach(function (input) {
        const raw = (input.value || '').trim();
        const parsed = raw.match(/^(\d+)(?:\.(\d+))?$/);

        if (raw && (!parsed || Number(parsed[2] || 0) !== 0)) {
            return; // giá trị lạ hoặc có phần lẻ khác 0: không đụng vào
        }
        if (parsed) {
            input.value = groupThousands(parsed[1]);
        }

        input.addEventListener('input', function () {
            const digitsBeforeCaret = onlyDigits(input.value.slice(0, input.selectionStart)).length;
            input.value = groupThousands(onlyDigits(input.value));
            const caret = caretAfterNthDigit(input.value, digitsBeforeCaret);
            input.setSelectionRange(caret, caret);
        });

        const form = input.closest('form');
        if (form) {
            form.addEventListener('submit', function () {
                input.value = onlyDigits(input.value);
            });
        }
    });
}

function onlyDigits(value) {
    return (value || '').replace(/\D/g, '');
}

/** "1300000" -> "1.300.000" */
function groupThousands(digits) {
    const trimmed = digits.replace(/^0+(?=\d)/, '');
    return trimmed.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
}

/** Vị trí con trỏ sao cho phía trước nó có đúng "count" chữ số. */
function caretAfterNthDigit(text, count) {
    if (count <= 0) {
        return 0;
    }
    let seen = 0;
    for (let i = 0; i < text.length; i++) {
        if (text[i] >= '0' && text[i] <= '9') {
            seen++;
            if (seen === count) {
                return i + 1;
            }
        }
    }
    return text.length;
}

function initChoicePickers() {
    document.querySelectorAll('[data-choice-picker]').forEach(function (picker) {
        const search = picker.querySelector('[data-choice-search]');
        const items = Array.from(picker.querySelectorAll('[data-choice-item]'));
        const empty = picker.querySelector('[data-choice-empty]');

        function normalize(value) {
            return value.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
        }

        function filterItems() {
            const keyword = normalize(search ? search.value.trim() : '');
            let visibleCount = 0;

            items.forEach(function (item) {
                const matches = !keyword || normalize(item.textContent).includes(keyword);
                item.classList.toggle('is-hidden-by-search', !matches);
                if (matches) {
                    visibleCount += 1;
                }
            });

            if (empty) {
                empty.hidden = visibleCount > 0;
            }
        }

        if (search) {
            search.addEventListener('input', filterItems);
        }

        filterItems();
    });
}

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
