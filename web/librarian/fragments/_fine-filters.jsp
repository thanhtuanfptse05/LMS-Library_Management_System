<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 2. Filters Bento Card -->
<div class="raised-card p-4 border border-outline-variant bg-white mb-4">
    <div class="row g-3">
        <div class="col-12 col-lg-4">
            <div class="position-relative">
                <span class="material-symbols-outlined position-absolute text-muted" style="left: 12px; top: 50%; transform: translateY(-50%);">search</span>
                <input type="text" class="form-control rounded-3 py-2 ps-5" placeholder="Search by member ID, name, barcode, ISBN, or book title..." />
            </div>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <select class="form-select rounded-3 py-2">
                <option value="">All Member Types</option>
                <option value="STUDENT">Student</option>
                <option value="LECTURER">Lecturer</option>
            </select>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <select class="form-select rounded-3 py-2">
                <option value="">All Fine Types</option>
                <option value="LATE">Late Return</option>
                <option value="LOST">Lost Book</option>
                <option value="DAMAGE">Damaged Book</option>
                <option value="MANUAL">Manual Fine</option>
            </select>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <select class="form-select rounded-3 py-2">
                <option value="">All Fine Statuses</option>
                <option value="UNPAID">Unpaid</option>
                <option value="PAID">Paid</option>
                <option value="WAIVED">Waived</option>
                <option value="PARTIAL">Partial</option>
            </select>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <button class="btn btn-primary-custom w-100 py-2 rounded-3 d-flex align-items-center justify-content-center gap-2">
                <span class="material-symbols-outlined">tune</span>
                Filter
            </button>
        </div>
    </div>
</div>
