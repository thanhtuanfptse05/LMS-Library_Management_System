<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Edit Email Template | UniLibrary Admin</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet" />

                <style>
                    body {
                        font-family: 'Inter', sans-serif;
                        background-color: #f7f9fb;
                        color: #191c1e;
                    }

                    /* Sidebar Layout Integration */
                    .sidebar {
                        width: 260px;
                        height: 100vh;
                        position: fixed;
                        left: 0;
                        top: 0;
                        background-color: #eceef0;
                        z-index: 1000;
                        border-right: 1px solid #e0e3e5;
                    }

                    .main-content {
                        margin-left: 260px;
                        min-height: 100vh;
                    }

                    .nav-link-custom {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 10px 16px;
                        color: #565e74;
                        text-decoration: none;
                        border-radius: 8px;
                        font-size: 14px;
                        font-weight: 600;
                        transition: all 0.2s;
                    }

                    .nav-link-custom:hover {
                        background-color: #e0e3e5;
                        color: #191c1e;
                    }

                    .nav-link-custom.active {
                        color: #9d4300;
                        background-color: #e0e3e5;
                        border-right: 4px solid #9d4300;
                    }

                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                    }

                    /* Custom UI Components */
                    .placeholder-pill-btn {
                        background-color: #f2f4f6;
                        color: #584237;
                        font-family: monospace;
                        font-size: 14px;
                        border: 1px solid rgba(224, 192, 177, 0.4);
                        padding: 6px 12px;
                        border-radius: 8px;
                        transition: all 0.2s;
                    }

                    .placeholder-pill-btn:hover {
                        background-color: #f97316;
                        color: white;
                        border-color: #f97316;
                    }

                    .glass-preview-card {
                        background: rgba(255, 255, 255, 0.7);
                        backdrop-filter: blur(10px);
                        border: 1px solid rgba(157, 67, 0, 0.1);
                        border-radius: 12px;
                    }

                    .preview-area-output {
                        background-color: #ffffff;
                        border: 1px solid rgba(226, 228, 230, 0.5);
                        border-radius: 8px;
                        padding: 16px;
                        font-size: 14px;
                        min-height: 150px;
                        box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
                    }

                    .highlight-tag {
                        background-color: rgba(157, 67, 0, 0.1);
                        color: #9d4300;
                        padding: 0 4px;
                        border-radius: 4px;
                        font-weight: 600;
                    }
                </style>
            </head>

            <body>

                <aside class="sidebar d-flex flex-column py-3 px-2">
                    <div class="mb-4 px-3">
                        <h1 class="h4 fw-bold tracking-tight m-0" style="color: #9d4300;">UniLibrary</h1>
                        <p class="small text-secondary m-0 opacity-75">Admin Portal</p>
                    </div>

                    <nav class="nav flex-column flex-grow-1 gap-1">
                        <a class="nav-link-custom" href="dashboard"><span
                                class="material-symbols-outlined">dashboard</span>Dashboard</a>
                        <a class="nav-link-custom" href="catalog"><span
                                class="material-symbols-outlined">menu_book</span>Catalog</a>
                        <a class="nav-link-custom" href="circulation"><span
                                class="material-symbols-outlined">swap_horiz</span>Circulation</a>
                        <a class="nav-link-custom" href="members"><span
                                class="material-symbols-outlined">group</span>Members</a>
                        <a class="nav-link-custom active" href="templates"><span
                                class="material-symbols-outlined">analytics</span>Reports</a>
                        <a class="nav-link-custom" href="settings"><span
                                class="material-symbols-outlined">settings</span>Settings</a>
                    </nav>

                    <div class="p-2 mt-auto">
                        <button class="btn w-100 text-white fw-bold py-2 rounded-3"
                            style="background-color: #f97316;">New Entry</button>
                    </div>
                </aside>

                <div class="main-content d-flex flex-column">

                    <header class="navbar bg-white border-bottom px-4 sticky-top justify-content-between"
                        style="height: 64px;">
                        <div class="d-flex align-items-center bg-light rounded-pill px-3 py-1" style="width: 384px;">
                            <span class="material-symbols-outlined text-secondary me-2">search</span>
                            <input class="form-control bg-transparent border-0 p-0 shadow-none small"
                                placeholder="Search templates..." type="text" />
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <button class="btn btn-link p-1 text-secondary position-relative">
                                <span class="material-symbols-outlined">notifications</span>
                            </button>
                            <div class="d-flex align-items-center gap-2 border-start ps-3">
                                <img alt="Admin" class="rounded-circle border"
                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuBaPynAxMPZ_dyuZMxqeWcY9Lm4T_uosuT9HBdgz_r9B-7RsTX6fgEvNYBzNsohaHClWhK6gH-NajgTiZ5OP2_-8RqsdtfvsWohrprGF7_GpvS5uhbTYj-U9OlGrX2z6foHCPR6O4w2x5GjelE19sjIjJkkJ5PhpaztdfcZH2HlAyirxhcc5JSzlQ8jk3boS2wzxXSBtRyXuTWhtZl6DgrKEnN2hKv1uLoHCw1oiWPmAfSSwBKl187lJ0eryg3GGKzOdwjsIVReU7I"
                                    style="width: 32px; height: 32px;" />
                                <span class="material-symbols-outlined text-secondary">account_circle</span>
                            </div>
                        </div>
                    </header>

                    <main class="container-fluid p-4 flex-grow-1">

                        <div class="mb-4">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-1" style="font-size: 12px; font-weight: 600;">
                                    <li class="breadcrumb-item text-secondary">Library Manager</li>
                                    <li class="breadcrumb-item text-secondary">Document Templates</li>
                                    <li class="breadcrumb-item active" style="color: #9d4300;">Edit</li>
                                </ol>
                            </nav>
                            <h2 class="fw-bold m-0 text-dark">Edit Email Template</h2>
                        </div>

                        <div class="row g-4">
                            <div class="col-12 col-lg-8 d-flex flex-column gap-4">
                                <div class="card border-0 shadow-sm p-4 rounded-3 bg-white border">
                                    <form action="templates/update" method="POST" class="d-flex flex-column gap-3">
                                        <input type="hidden" name="id" value="${template.id}" />

                                        <div class="row g-3">
                                            <div class="col-md-6 d-flex flex-column gap-1">
                                                <label class="fw-semibold text-secondary small">Template Name
                                                    (Read-Only)</label>
                                                <input class="form-control bg-light text-muted font-monospace border"
                                                    readonly type="text" name="name"
                                                    value="${template.name != null ? template.name : 'PICKUP_REMINDER'}" />
                                            </div>
                                            <div class="col-md-6 d-flex flex-column gap-1">
                                                <label class="fw-semibold text-secondary small">Last Modified</label>
                                                <div class="form-control-plaintext text-secondary fst-italic px-2"
                                                    style="font-size: 14px;">
                                                    <c:choose>
                                                        <c:when class="${template.lastUpdated != null}">
                                                            <fmt:formatDate value="${template.lastUpdated}"
                                                                pattern="MMMM dd, yyyy" /> by Admin
                                                        </c:when>
                                                        <c:otherwise>October 24, 2023 by Admin</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex flex-column gap-1">
                                            <label class="fw-semibold text-secondary small">Subject Line</label>
                                            <input class="form-control border shadow-none" type="text" name="subject"
                                                value="${template.subject != null ? template.subject : 'Your reserved items are ready at the front desk!'}" />
                                        </div>

                                        <div class="d-flex flex-column gap-1">
                                            <div class="d-flex justify-content-between align-items-end mb-1">
                                                <label class="fw-semibold text-secondary small">Body Content</label>
                                                <div class="btn-group border rounded bg-light p-0.5">
                                                    <button class="btn btn-sm btn-light border-0 py-0 px-2"
                                                        type="button"><span
                                                            class="material-symbols-outlined fs-6">format_bold</span></button>
                                                    <button class="btn btn-sm btn-light border-0 py-0 px-2"
                                                        type="button"><span
                                                            class="material-symbols-outlined fs-6">format_italic</span></button>
                                                    <button class="btn btn-sm btn-light border-0 py-0 px-2"
                                                        type="button"><span
                                                            class="material-symbols-outlined fs-6">link</span></button>
                                                    <button class="btn btn-sm btn-light border-0 py-0 px-2"
                                                        type="button"><span
                                                            class="material-symbols-outlined fs-6">format_list_bulleted</span></button>
                                                </div>
                                            </div>
                                            <textarea class="form-control border shadow-none font-monospace"
                                                id="templateBody" name="body" rows="11"
                                                style="line-height: 1.6; font-size: 15px;"><c:choose><c:when class="${template.body != null}">${template.body}</c:when><c:otherwise>Dear {{student_name}},

We are pleased to inform you that the following items are now available for pickup at the {{library_name}} front desk:

- {{book_title}}

Please ensure you collect these items by {{pickup_deadline}}. If you are unable to collect them by this date, they will be returned to the main collection or offered to the next patron in line.

Best regards,
UniLibrary Management Team</c:otherwise></c:choose></textarea>
                                        </div>

                                        <div class="d-flex gap-3 pt-2">
                                            <button class="btn text-white px-4 py-2 rounded-3 shadow-sm fw-bold"
                                                style="background-color: #9d4300;" type="submit">Save Changes</button>
                                            <a href="templates"
                                                class="btn btn-outline-secondary px-4 py-2 rounded-3">Cancel</a>
                                        </div>
                                    </form>
                                </div>

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="card border-0 rounded-3 overflow-hidden" style="height: 256px;">
                                            <img alt="Library Design Context"
                                                class="w-100 h-100 object-fit-cover opacity-75"
                                                style="filter: grayscale(30%);"
                                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuDnab0t6J0_bsWAglFgh96mDGdI4CTFCz4N7cn_KWSEovCHVlZxYzuGS90nxEevEwCtjbgBPn0T9LW8ga0NLROB0w_iXmMGnmg5INxpRg5Cv8nPojn3M4xx04w_9nHoAHM9UqA0d8ogfqRTUszMRurR8xA_DVd773IifMjJdzg_fSqsZRVO9gNKO0svy1BSMoB40jXUjbYPfvwDs4iamEuoK2OguJZVnih2SnwpjWgsdYsfCI5tN5m6cZpXt_NmBkYW9nlRX0V2OOc" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="glass-preview-card p-3 h-100 d-flex flex-column shadow-sm">
                                            <h5 class="fw-bold text-uppercase tracking-widest mb-2 small"
                                                style="color: #9d4300;">Live Preview Layout</h5>
                                            <div class="preview-area-output overflow-auto flex-grow-1 custom-scrollbar"
                                                id="previewArea">
                                                <p class="text-muted fst-italic">Loading dynamic rendering compiler
                                                    output...</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-lg-4 d-flex flex-column gap-4">
                                <div class="card border-0 shadow-sm p-4 rounded-3 bg-white border">
                                    <div class="d-flex align-items-center gap-2 mb-3">
                                        <span class="material-symbols-outlined"
                                            style="color: #9d4300;">data_object</span>
                                        <h5 class="fw-bold m-0">Available Placeholders</h5>
                                    </div>
                                    <p class="small text-muted mb-3">Click a tag to insert it into your editor at the
                                        current cursor position.</p>

                                    <div class="d-flex flex-wrap gap-2">
                                        <button class="btn placeholder-pill-btn shadow-none"
                                            onclick="insertTag('{{student_name}}')">{{student_name}}</button>
                                        <button class="btn placeholder-pill-btn shadow-none"
                                            onclick="insertTag('{{book_title}}')">{{book_title}}</button>
                                        <button class="btn placeholder-pill-btn shadow-none"
                                            onclick="insertTag('{{pickup_deadline}}')">{{pickup_deadline}}</button>
                                        <button class="btn placeholder-pill-btn shadow-none"
                                            onclick="insertTag('{{library_name}}')">{{library_name}}</button>
                                        <button class="btn placeholder-pill-btn shadow-none"
                                            onclick="insertTag('{{due_date}}')">{{due_date}}</button>
                                        <button class="btn placeholder-pill-btn shadow-none"
                                            onclick="insertTag('{{librarian_name}}')">{{librarian_name}}</button>
                                    </div>
                                </div>

                                <div class="card border-0 p-4 rounded-3"
                                    style="background-color: rgba(249, 115, 22, 0.1); border: 1px solid rgba(249, 115, 22, 0.2) !important;">
                                    <h5 class="fw-bold d-flex align-items-center gap-2 mb-2" style="color: #582200;">
                                        <span class="material-symbols-outlined">lightbulb</span> Pro-Tip
                                    </h5>
                                    <p class="small m-0 lh-relaxed" style="color: rgba(88, 34, 0, 0.85);">
                                        Personalized emails have a 40% higher open rate. Use the
                                        <strong>{{student_name}}</strong> tag at the beginning of your message to ensure
                                        students recognize the communication.
                                    </p>
                                </div>

                                <div class="card border-0 p-3 bg-light rounded-3">
                                    <h6 class="fw-bold text-muted text-uppercase tracking-wider mb-3"
                                        style="font-size: 11px;">Quick Actions</h6>
                                    <ul class="nav flex-column gap-2 small">
                                        <li class="nav-item">
                                            <a class="nav-link p-0 text-dark d-flex align-items-center gap-2 hover-link-primary"
                                                href="#">
                                                <span
                                                    class="material-symbols-outlined text-secondary fs-5">history</span>
                                                View Revision History
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link p-0 text-dark d-flex align-items-center gap-2" href="#">
                                                <span class="material-symbols-outlined text-secondary fs-5">send</span>
                                                Send Test Email
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link p-0 text-dark d-flex align-items-center gap-2" href="#">
                                                <span
                                                    class="material-symbols-outlined text-secondary fs-5">content_copy</span>
                                                Duplicate Template
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    const templateBody = document.getElementById('templateBody');
                    const previewArea = document.getElementById('previewArea');

                    // Target Simulation Fake Inject Data Mock Values
                    const sampleData = {
                        '{{student_name}}': 'Jordan Henderson',
                        '{{book_title}}': 'The Principles of Academic Research (2nd Ed)',
                        '{{pickup_deadline}}': 'Friday, Nov 3rd, 2023',
                        '{{library_name}}': 'Main Campus North Library',
                        '{{due_date}}': 'Nov 17, 2023',
                        '{{librarian_name}}': 'Dr. Elizabeth Finch'
                    };

                    // Live Real-Time Rendering Engine Driver
                    function updatePreview() {
                        let content = templateBody.value;
                        // Escape bracket sequences and parse layout HTML nodes safely
                        for (const [key, value] of Object.entries(sampleData)) {
                            const regex = new RegExp(key.replace(/\{\{/g, '\\{\\{').replace(/\}\}/g, '\\}\\}'), 'g');
                            content = content.replace(regex, `<span class="highlight-tag">${value}</span>`);
                        }
                        previewArea.innerHTML = content.replace(/\n/g, '<br>');
                    }

                    // Initialize compiler on screen bootup
                    updatePreview();
                    templateBody.addEventListener('input', updatePreview);

                    // Core logic helper to inject tags directly onto selection cursor checkpoints
                    function insertTag(tag) {
                        const start = templateBody.selectionStart;
                        const end = templateBody.selectionEnd;
                        const text = templateBody.value;

                        const before = text.substring(0, start);
                        const after = text.substring(end, text.length);

                        templateBody.value = before + tag + after;
                        templateBody.focus();

                        // Adjust the cursor endpoint to snap directly behind the new token
                        templateBody.selectionStart = templateBody.selectionEnd = start + tag.length;
                        updatePreview();
                    }
                </script>
            </body>

            </html>