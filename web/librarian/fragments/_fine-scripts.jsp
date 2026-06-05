<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Checkboxes & Bulk action logic -->
<script>
    const selectAllCheckbox = document.getElementById('selectAllCheckbox');
    const rowCheckboxes = document.querySelectorAll('.fine-row-checkbox');
    const bulkBar = document.getElementById('bulkBar');
    const selectedCount = document.getElementById('selectedCount');
    const bulkWaiveBtn = document.getElementById('bulkWaiveBtn');

    function updateBulkBar() {
        let selectedRows = [];
        rowCheckboxes.forEach(cb => {
            if (cb.checked) {
                selectedRows.push(cb.closest('tr'));
            }
        });

        const count = selectedRows.length;
        if (count > 0) {
            selectedCount.textContent = `${count} fine${count > 1 ? 's' : ''} selected`;
            bulkBar.classList.remove('d-none');

            const hasPaidOrWaived = selectedRows.some(tr => {
                const status = tr.getAttribute('data-status');
                return status === 'PAID' || status === 'WAIVED';
            });

            if (hasPaidOrWaived) {
                bulkWaiveBtn.disabled = true;
                bulkWaiveBtn.setAttribute('title', 'Cannot waive completed or already waived fines.');
            } else {
                bulkWaiveBtn.disabled = false;
                bulkWaiveBtn.removeAttribute('title');
            }
        } else {
            bulkBar.classList.add('d-none');
        }
    }

    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            rowCheckboxes.forEach(cb => {
                cb.checked = this.checked;
            });
            updateBulkBar();
        });
    }

    rowCheckboxes.forEach(cb => {
        cb.addEventListener('change', function() {
            if (!this.checked) {
                selectAllCheckbox.checked = false;
            } else {
                const allChecked = Array.from(rowCheckboxes).every(c => c.checked);
                selectAllCheckbox.checked = allChecked;
            }
            updateBulkBar();
        });
    });

    function waiveSelected() {
        const count = Array.from(rowCheckboxes).filter(cb => cb.checked).length;
        if (confirm(`Are you sure you want to waive the ${count} selected fine(s)?`)) {
            alert('Selected fines have been successfully waived.');
            location.reload();
        }
    }

    function waiveSingle(fineId) {
        if (confirm(`Are you sure you want to waive fine ${fineId}?`)) {
            alert(`Fine ${fineId} has been successfully waived.`);
            location.reload();
        }
    }

    // Side Drawer logic
    const drawer = document.getElementById('fineDrawer');
    const backdrop = document.getElementById('drawerBackdrop');

    function openDrawer(fineId, memberName, memberType, memberId, bookTitle, barcode, fineType, overdueDays, amount, status, dateDetails, calculation, paymentDetails) {
        document.getElementById('drawerFineId').textContent = fineId;
        document.getElementById('drawerMemberName').textContent = memberName;
        document.getElementById('drawerMemberType').textContent = memberType;
        document.getElementById('drawerMemberId').textContent = memberId;
        document.getElementById('drawerBookTitle').textContent = bookTitle;
        document.getElementById('drawerBarcode').textContent = barcode;
        document.getElementById('drawerFineType').textContent = fineType;
        document.getElementById('drawerOverdueDays').textContent = overdueDays;
        document.getElementById('drawerFineAmount').textContent = amount;
        
        const statusBadge = document.getElementById('drawerFineStatus');
        statusBadge.textContent = status;
        statusBadge.className = 'status-badge';
        if (status === 'UNPAID') statusBadge.classList.add('status-unpaid');
        else if (status === 'PAID') statusBadge.classList.add('status-paid');
        else if (status === 'WAIVED') statusBadge.classList.add('status-waived');
        else if (status === 'PARTIAL') statusBadge.classList.add('status-partial');

        document.getElementById('drawerCalculation').innerHTML = calculation;
        document.getElementById('drawerPaymentHistory').innerHTML = paymentDetails;

        const collectBtn = document.getElementById('drawerCollectBtn');
        const waiveBtn = document.getElementById('drawerWaiveBtn');

        if (status === 'UNPAID' || status === 'PARTIAL') {
            collectBtn.style.display = 'block';
            waiveBtn.style.display = 'block';
            collectBtn.onclick = function() {
                window.location.href = `${pageContext.request.contextPath}/librarian/payment-receipt.jsp?memberId=` + memberId;
            };
            waiveBtn.onclick = function() {
                waiveSingle(fineId);
            };
        } else {
            collectBtn.style.display = 'none';
            waiveBtn.style.display = 'none';
        }

        drawer.classList.add('open');
        backdrop.classList.add('show');
    }

    function closeDrawer() {
        drawer.classList.remove('open');
        backdrop.classList.remove('show');
    }

    window.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeDrawer();
        }
    });

    // Client-side Column Sort logic
    let sortDirections = {};
    function sortTable(colIndex) {
        const table = document.getElementById('finesTable');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));
        
        let dir = sortDirections[colIndex] || 'asc';
        if (dir === 'asc') sortDirections[colIndex] = 'desc';
        else if (dir === 'desc') sortDirections[colIndex] = 'none';
        else sortDirections[colIndex] = 'asc';

        const activeDir = sortDirections[colIndex];

        table.querySelectorAll('.sort-header').forEach(th => th.classList.remove('sort-active'));

        if (activeDir === 'none') {
            rows.sort((a, b) => a.getAttribute('data-id').localeCompare(b.getAttribute('data-id')));
        } else {
            const header = table.querySelectorAll('.sort-header')[colIndex === 4 ? 0 : 1];
            header.classList.add('sort-active');
            const icon = header.querySelector('.sort-icon');
            icon.textContent = activeDir === 'asc' ? 'arrow_upward' : 'arrow_downward';

            rows.sort((a, b) => {
                let valA, valB;
                if (colIndex === 4) {
                    valA = parseInt(a.getAttribute('data-overdue')) || 0;
                    valB = parseInt(b.getAttribute('data-overdue')) || 0;
                } else if (colIndex === 5) {
                    valA = parseFloat(a.getAttribute('data-amount')) || 0;
                    valB = parseFloat(b.getAttribute('data-amount')) || 0;
                }
                return activeDir === 'asc' ? valA - valB : valB - valA;
            });
        }

        tbody.innerHTML = '';
        rows.forEach(row => tbody.appendChild(row));
    }
</script>
