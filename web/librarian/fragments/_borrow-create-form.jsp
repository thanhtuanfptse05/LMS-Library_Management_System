<%-- Fragment: _borrow-create-form.jsp — Multi-step form for creating a new borrow record --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Step 1: Member Verification --%>
<section class="custom-card active-step">
    <div class="card-header bg-light py-3 px-4 d-flex justify-content-between align-items-center border-bottom-0">
        <div class="d-flex align-items-center">
            <span class="step-indicator bg-primary-custom text-white">1</span>
            <h5 class="mb-0 fw-semibold">Member Verification</h5>
        </div>
        <span class="badge text-dark fw-bold" style="font-size: 10px; letter-spacing: 0.1em;">REQUIRED</span>
    </div>
    <div class="p-4">
        <div class="row g-3 max-w-lg-custom mb-4">
            <div class="col-8 col-md-9 position-relative">
                <span class="material-symbols-outlined position-absolute top-50 start-0 translate-middle-y ms-3 text-muted">badge</span>
                <input class="form-control py-2 border-light-subtle rounded-3"
                       style="padding-left: 2.75rem;"
                       id="member_id"
                       name="memberId"
                       placeholder="Enter Student/Lecturer ID"
                       type="text" />
            </div>
            <div class="col-4 col-md-3">
                <button class="btn btn-primary-lumina w-100 py-2" type="button" onclick="verifyMember()">Verify</button>
            </div>
        </div>

        <%-- Member Details Display (shown after verification) --%>
        <div class="d-none animate-in p-3 rounded-3 border border-warning-subtle" id="member_profile"
             style="background-color: #ffdbca20;">
            <div class="row align-items-center">
                <div class="col-auto">
                    <div class="rounded-circle overflow-hidden bg-white border border-2 border-white shadow-sm"
                         style="width: 64px; height: 64px;">
                        <img alt="Member Avatar" class="w-100 h-100 object-cover-custom"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCv6FdtnZCFMrLyKoqFF4BDoQR9jKEAqVkt5pprcTkkDxDpK81OO-M64NAmBAuu27Nn6jJ6FvDmNgSyh4VQ7rU8OuzKMe6Xhs96HrYkIemgONU_ZO44LcG513h1fpK2xO85Axr4MzXaTsynKgFF6ZBaQw1G3M7y8SbhfzmV5Q8i9NftzY-i2F5LJX1cBuAmLdCA6Yx3jGl9GQD7980QefVIRgdb7NYxwqG2O4anfXoZxJ3maUpmRokOJjcgMjTtXjOhZIhGGEVaiWk" />
                    </div>
                </div>
                <div class="col">
                    <div class="row g-3">
                        <div class="col-6 col-md-4">
                            <div class="small text-muted text-uppercase fw-bold" style="font-size: 10px;">Name</div>
                            <div class="fw-semibold text-dark" id="display_name">Alex Johnston</div>
                        </div>
                        <div class="col-6 col-md-4">
                            <div class="small text-muted text-uppercase fw-bold" style="font-size: 10px;">Role</div>
                            <div class="fw-semibold text-dark" id="display_role">Undergraduate Student</div>
                        </div>
                        <div class="col-12 col-md-4">
                            <div class="small text-muted text-uppercase fw-bold" style="font-size: 10px;">Status</div>
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2">Active Account</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- Step 2: Book Selection --%>
<section class="custom-card">
    <div class="card-header bg-light py-3 px-4 d-flex align-items-center border-bottom-0">
        <span class="step-indicator bg-secondary text-white">2</span>
        <h5 class="mb-0 fw-semibold">Book Selection</h5>
    </div>
    <div class="p-4">
        <div class="row g-3 max-w-lg-custom mb-4">
            <div class="col-8 col-md-9 position-relative">
                <span class="material-symbols-outlined position-absolute top-50 start-0 translate-middle-y ms-3 text-muted">barcode_scanner</span>
                <input class="form-control py-2 border-light-subtle rounded-3"
                       style="padding-left: 2.75rem;"
                       id="book_barcode"
                       name="bookBarcode"
                       placeholder="Scan Book Copy Barcode"
                       type="text" />
            </div>
            <div class="col-4 col-md-3">
                <button class="btn btn-outline-secondary w-100 py-2 fw-semibold" type="button" onclick="scanBook()">Scan</button>
            </div>
        </div>

        <%-- Book Details Display (shown after scan) --%>
        <div class="d-none animate-in p-3 rounded-3 border border-light-subtle bg-light" id="book_details">
            <div class="d-flex gap-3">
                <img alt="Book Cover" class="rounded shadow-sm object-cover-custom"
                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuAHcV2BFn9G9WjQg26OI_8l4HxWLWdhgRxVE1wnpbS5HGt-JDcc2PasT3y765S5MOI15VJapiN8ihhmzgNoQ4VCFs2iYij_gZc4tjrE2RilH7WH-7fBYhfNedmhW-YgxQyzUdlzVtxkJ2edYASInzFneEaG9_w3Mrkuj8GZHQxG0lUkGywH5vcFGyBT-aE_P7nGSK0NUVjFEW3dqSkTsy95cE2r6ltbpwrMbNFc6TZuuesTwuHo9vDUFWx0lRRH-s29xsVupHuO4kI"
                     style="width: 60px; height: 90px;" />
                <div class="flex-grow-1">
                    <h6 class="fw-bold mb-1" id="book_title">Advanced Computational Fluid Dynamics</h6>
                    <p class="text-muted small mb-2" id="book_isbn_barcode">ISBN: 978-3-16-148410-0 | Barcode: CFD-2023-088</p>
                    <div class="row g-2">
                        <div class="col-auto me-3">
                            <div class="small text-muted text-uppercase fw-bold" style="font-size: 9px;">Author</div>
                            <div class="small fw-medium" id="book_author">Dr. Elena Rodriguez</div>
                        </div>
                        <div class="col-auto">
                            <div class="small text-muted text-uppercase fw-bold" style="font-size: 9px;">Condition</div>
                            <div class="small text-primary-custom fw-bold" id="book_condition">Excellent</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- Policy Footer --%>
<footer class="p-3 rounded-3 border border-light-subtle" style="background-color: var(--surface-container-low);">
    <div class="d-flex align-items-center gap-2 text-primary-custom mb-2">
        <span class="material-symbols-outlined fs-5">info</span>
        <span class="fw-bold small text-uppercase">Standard Policy</span>
    </div>
    <ul class="small text-muted mb-0 ps-3">
        <li>Loan period: 14 days (Students), 30 days (Staff/Lecturers).</li>
        <li>Overdue rate: 5,000 VND per day per book.</li>
        <li>All books must be physically inspected before processing.</li>
    </ul>
</footer>
