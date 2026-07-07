document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.bm-modal[data-auto-open="true"]').forEach(function (modal) {
        if (window.bootstrap) {
            window.bootstrap.Modal.getOrCreateInstance(modal).show();
        }
    });

    initBookAutoFilter();
    initBookTagMergeValidation();

    document.querySelectorAll('#createCopyModal select[name="bookId"]').forEach((select) => {
        enhanceRequiredSelectCombobox(select, {
            placeholder: 'Gõ tên sách hoặc ISBN để chọn',
            clearLabel: 'Xóa đầu sách đã chọn',
            emptyText: 'Không tìm thấy đầu sách phù hợp.',
            errorText: 'Vui lòng chọn một đầu sách trong danh sách gợi ý.'
        });
    });
    document.querySelectorAll('#createInventoryModal select[name="location"]').forEach((select) => {
        enhanceRequiredSelectCombobox(select, {
            placeholder: 'Gõ để tìm khu vực kiểm kê',
            clearLabel: 'Xóa khu vực đã chọn',
            emptyText: 'Không tìm thấy khu vực phù hợp.',
            errorText: 'Vui lòng chọn một khu vực trong danh sách gợi ý.',
            optionLimit: 80
        });
    });
    document.querySelectorAll('#createCopyModal input[name="location"], #editCopyModal input[name="location"]')
        .forEach(enhanceLocationInput);
    initBookManagementPagination();
});

function initBookAutoFilter() {
    document.querySelectorAll('.bm-auto-filter').forEach(function (form) {
        const keywordInput = form.querySelector('[name="q"]');
        const statusSelect = form.querySelector('[name="status"]');
        let timer;

        if (keywordInput) {
            keywordInput.addEventListener('input', function () {
                window.clearTimeout(timer);
                timer = window.setTimeout(function () {
                    form.submit();
                }, 450);
            });
        }

        if (statusSelect) {
            statusSelect.addEventListener('change', function () {
                form.submit();
            });
        }
    });
}

function initBookTagMergeValidation() {
    const mergeForm = document.querySelector('#mergeTagModal form');
    if (!mergeForm) {
        return;
    }
    const source = mergeForm.querySelector('[name="sourceTagId"]');
    const target = mergeForm.querySelector('[name="targetTagId"]');

    mergeForm.addEventListener('submit', function (event) {
        if (!source || !target || source.value !== target.value) {
            return;
        }

        event.preventDefault();
        target.setCustomValidity('Nhãn đích phải khác nhãn nguồn.');
        target.reportValidity();
    });

    mergeForm.querySelectorAll('[name="sourceTagId"], [name="targetTagId"]').forEach(function (field) {
        field.addEventListener('change', function () {
            if (source) {
                source.setCustomValidity('');
            }
            if (target) {
                target.setCustomValidity('');
            }
        });
    });
}

function enhanceRequiredSelectCombobox(select, config = {}) {
    const form = select.closest('form');
    const wrapper = document.createElement('div');
    const control = document.createElement('div');
    const input = document.createElement('input');
    const clearButton = document.createElement('button');
    const menu = document.createElement('div');
    const emptyState = document.createElement('div');
    const error = document.createElement('p');
    const options = Array.from(select.options)
        .filter((option) => option.value)
        .map((option) => ({
            value: option.value,
            label: option.textContent.trim(),
            search: option.textContent.trim().toLowerCase()
        }));

    const settings = {
        placeholder: config.placeholder || 'Gõ để tìm và chọn',
        clearLabel: config.clearLabel || 'Xóa lựa chọn',
        emptyText: config.emptyText || 'Không tìm thấy lựa chọn phù hợp.',
        errorText: config.errorText || 'Vui lòng chọn một mục trong danh sách gợi ý.',
        optionLimit: config.optionLimit || 40
    };

    wrapper.className = 'bm-combobox';
    wrapper.dataset.enhancedSelectCombobox = 'true';

    control.className = 'bm-combobox__control';
    input.type = 'text';
    input.className = 'form-control bm-combobox__input';
    input.placeholder = settings.placeholder;
    input.autocomplete = 'off';
    input.setAttribute('role', 'combobox');
    input.setAttribute('aria-expanded', 'false');
    input.setAttribute('aria-autocomplete', 'list');

    clearButton.type = 'button';
    clearButton.className = 'bm-combobox__clear';
    clearButton.setAttribute('aria-label', settings.clearLabel);
    clearButton.innerHTML = '<span class="material-symbols-outlined" aria-hidden="true">close</span>';

    menu.className = 'bm-combobox__menu';
    menu.setAttribute('role', 'listbox');

    emptyState.className = 'bm-combobox__empty';
    emptyState.textContent = settings.emptyText;

    error.className = 'bm-field-error mb-0';
    error.textContent = settings.errorText;

    select.classList.add('bm-select-fallback');
    select.required = false;
    select.setAttribute('aria-hidden', 'true');

    control.append(input, clearButton);
    wrapper.append(control, menu, emptyState, error);
    select.insertAdjacentElement('afterend', wrapper);

    let activeIndex = -1;
    let visibleOptions = [];

    function openMenu() {
        wrapper.classList.add('is-open');
        input.setAttribute('aria-expanded', 'true');
    }

    function closeMenu() {
        wrapper.classList.remove('is-open');
        input.setAttribute('aria-expanded', 'false');
        activeIndex = -1;
        updateActiveOption();
    }

    function clearSelection() {
        select.value = '';
        input.value = '';
        wrapper.classList.remove('has-selection', 'has-error');
        renderOptions('');
        openMenu();
        input.focus();
    }

    function chooseOption(option) {
        select.value = option.value;
        input.value = option.label;
        wrapper.classList.add('has-selection');
        wrapper.classList.remove('has-error');
        closeMenu();
    }

    function updateActiveOption() {
        menu.querySelectorAll('.bm-combobox__option').forEach((button, index) => {
            button.classList.toggle('is-active', index === activeIndex);
        });
    }

    function renderOptions(keyword) {
        const normalizedKeyword = keyword.trim().toLowerCase();
        visibleOptions = options.filter((option) => !normalizedKeyword || option.search.includes(normalizedKeyword));
        menu.innerHTML = '';

        visibleOptions.slice(0, settings.optionLimit).forEach((option, index) => {
            const button = document.createElement('button');
            const title = document.createElement('span');
            const meta = document.createElement('span');
            const parts = option.label.split('·');

            button.type = 'button';
            button.className = 'bm-combobox__option';
            button.setAttribute('role', 'option');
            button.dataset.value = option.value;

            title.className = 'bm-combobox__option-title';
            title.textContent = parts[0].trim();

            meta.className = 'bm-combobox__option-meta';
            meta.textContent = parts.slice(1).join('·').trim();

            button.append(title);
            if (meta.textContent) {
                button.append(meta);
            }

            button.addEventListener('mousedown', (event) => {
                event.preventDefault();
                chooseOption(option);
            });

            menu.append(button);
            if (index === activeIndex) {
                button.classList.add('is-active');
            }
        });

        emptyState.classList.toggle('is-visible', visibleOptions.length === 0);
        activeIndex = visibleOptions.length ? Math.min(Math.max(activeIndex, 0), visibleOptions.length - 1) : -1;
        updateActiveOption();
    }

    input.addEventListener('input', () => {
        select.value = '';
        wrapper.classList.remove('has-selection', 'has-error');
        activeIndex = 0;
        renderOptions(input.value);
        openMenu();
    });

    input.addEventListener('focus', () => {
        renderOptions(input.value);
        openMenu();
    });

    input.addEventListener('keydown', (event) => {
        if (event.key === 'ArrowDown') {
            event.preventDefault();
            activeIndex = Math.min(activeIndex + 1, visibleOptions.length - 1);
            updateActiveOption();
            openMenu();
        } else if (event.key === 'ArrowUp') {
            event.preventDefault();
            activeIndex = Math.max(activeIndex - 1, 0);
            updateActiveOption();
        } else if (event.key === 'Enter' && wrapper.classList.contains('is-open')) {
            event.preventDefault();
            if (visibleOptions[activeIndex]) {
                chooseOption(visibleOptions[activeIndex]);
            }
        } else if (event.key === 'Escape') {
            closeMenu();
        }
    });

    clearButton.addEventListener('click', clearSelection);

    document.addEventListener('mousedown', (event) => {
        if (!wrapper.contains(event.target)) {
            closeMenu();
        }
    });

    if (form) {
        form.addEventListener('submit', (event) => {
            if (!select.value) {
                event.preventDefault();
                wrapper.classList.add('has-error');
                input.focus();
                renderOptions(input.value);
                openMenu();
            }
        });
    }

    renderOptions('');
}

function enhanceLocationInput(input) {
    const datalistId = input.getAttribute('list');
    const datalist = datalistId ? document.getElementById(datalistId) : null;
    const options = datalist ? Array.from(datalist.options)
        .map((option) => option.value.trim())
        .filter(Boolean)
        .filter((value, index, values) => values.indexOf(value) === index)
        .map((value) => ({
            value,
            search: value.toLowerCase()
        })) : [];

    if (!options.length || input.closest('.bm-combobox')) {
        return;
    }

    const wrapper = document.createElement('div');
    const control = document.createElement('div');
    const toggleButton = document.createElement('button');
    const menu = document.createElement('div');
    const emptyState = document.createElement('div');

    wrapper.className = 'bm-combobox bm-combobox--free';
    control.className = 'bm-combobox__control';
    menu.className = 'bm-combobox__menu';
    menu.setAttribute('role', 'listbox');
    emptyState.className = 'bm-combobox__empty';
    emptyState.textContent = 'Không có vị trí trùng khớp. Bạn vẫn có thể dùng vị trí mới này.';

    toggleButton.type = 'button';
    toggleButton.className = 'bm-combobox__clear bm-combobox__toggle';
    toggleButton.setAttribute('aria-label', 'Mở danh sách vị trí có sẵn');
    toggleButton.innerHTML = '<span class="material-symbols-outlined" aria-hidden="true">expand_more</span>';

    input.classList.add('bm-combobox__input');
    input.removeAttribute('list');
    input.setAttribute('role', 'combobox');
    input.setAttribute('aria-expanded', 'false');
    input.setAttribute('aria-autocomplete', 'list');

    input.parentNode.insertBefore(wrapper, input);
    wrapper.append(control, menu, emptyState);
    control.append(input, toggleButton);

    let activeIndex = -1;
    let visibleOptions = [];

    function openMenu() {
        wrapper.classList.add('is-open');
        input.setAttribute('aria-expanded', 'true');
    }

    function closeMenu() {
        wrapper.classList.remove('is-open');
        input.setAttribute('aria-expanded', 'false');
        activeIndex = -1;
        updateActiveOption();
    }

    function chooseOption(option) {
        input.value = option.value;
        wrapper.classList.remove('has-error');
        closeMenu();
        input.focus();
    }

    function updateActiveOption() {
        menu.querySelectorAll('.bm-combobox__option').forEach((button, index) => {
            button.classList.toggle('is-active', index === activeIndex);
        });
    }

    function renderOptions(keyword) {
        const normalizedKeyword = keyword.trim().toLowerCase();
        visibleOptions = options.filter((option) => !normalizedKeyword || option.search.includes(normalizedKeyword));
        menu.innerHTML = '';

        visibleOptions.slice(0, 40).forEach((option, index) => {
            const button = document.createElement('button');
            const title = document.createElement('span');

            button.type = 'button';
            button.className = 'bm-combobox__option';
            button.setAttribute('role', 'option');

            title.className = 'bm-combobox__option-title';
            title.textContent = option.value;

            button.append(title);
            button.addEventListener('mousedown', (event) => {
                event.preventDefault();
                chooseOption(option);
            });

            menu.append(button);
            if (index === activeIndex) {
                button.classList.add('is-active');
            }
        });

        emptyState.classList.toggle('is-visible', visibleOptions.length === 0);
        activeIndex = visibleOptions.length ? Math.min(Math.max(activeIndex, 0), visibleOptions.length - 1) : -1;
        updateActiveOption();
    }

    input.addEventListener('input', () => {
        activeIndex = 0;
        renderOptions(input.value);
        openMenu();
    });

    input.addEventListener('focus', () => {
        renderOptions(input.value);
        openMenu();
    });

    input.addEventListener('keydown', (event) => {
        if (event.key === 'ArrowDown') {
            event.preventDefault();
            activeIndex = Math.min(activeIndex + 1, visibleOptions.length - 1);
            updateActiveOption();
            openMenu();
        } else if (event.key === 'ArrowUp') {
            event.preventDefault();
            activeIndex = Math.max(activeIndex - 1, 0);
            updateActiveOption();
        } else if (event.key === 'Enter' && wrapper.classList.contains('is-open') && visibleOptions[activeIndex]) {
            event.preventDefault();
            chooseOption(visibleOptions[activeIndex]);
        } else if (event.key === 'Escape') {
            closeMenu();
        }
    });

    toggleButton.addEventListener('click', () => {
        if (wrapper.classList.contains('is-open')) {
            closeMenu();
        } else {
            renderOptions(input.value);
            openMenu();
            input.focus();
        }
    });

    document.addEventListener('mousedown', (event) => {
        if (!wrapper.contains(event.target)) {
            closeMenu();
        }
    });

    renderOptions(input.value);
}

function initBookManagementPagination() {
    function buildPageUrl(page) {
        const url = new URL(window.location.href);
        url.searchParams.set('page', String(page));
        return url.toString();
    }

    document.querySelectorAll('.bm-page-link[data-page]').forEach((link) => {
        const page = Number(link.dataset.page);

        if (link.classList.contains('disabled') || !Number.isInteger(page) || page < 1) {
            link.setAttribute('aria-disabled', 'true');
            link.addEventListener('click', (event) => event.preventDefault());
            return;
        }

        link.href = buildPageUrl(page);
    });

    document.querySelectorAll('[data-bm-page-jump]').forEach((form) => {
        form.addEventListener('submit', (event) => {
            event.preventDefault();
            const input = form.querySelector('input[name="page"]');
            const maxPage = Number(input && input.max);
            let page = Number(input && input.value);

            if (!Number.isInteger(page) || page < 1) {
                page = 1;
            }

            if (Number.isInteger(maxPage) && maxPage > 0) {
                page = Math.min(page, maxPage);
            }

            window.location.href = buildPageUrl(page);
        });
    });
}
