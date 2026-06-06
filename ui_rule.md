# UI/UX Design Guidelines — LMS University Library (Bootstrap Edition)

This document serves as the absolute, single source of truth for all User Interface (UI) and User Experience (UX) standards in the LMS (Library Management System) project. Every page layout, custom component, style sheet, and JSP implementation must strictly comply with these rules.

---

## 1. Core Principles
- **Scholarly & Premium:** The interface must feel like a high-end academic institution—warm, trustworthy, organized, and premium. Avoid generic layouts and colors.
- **Efficiency First:** Dashboards must prioritize core functional tasks (e.g., circulation, resource management) with minimal cognitive load and friction.
- **Framework Strictness:** **Bootstrap 5.x ONLY.** Tailwind CSS and other utility-first frameworks are strictly prohibited. Use Bootstrap's native grid and component architecture.
- **MVC & JSP Standards:** Design and render views using JSP, JSTL, Bootstrap, and Vanilla CSS. Direct Java Scriptlets (`<% %>`) are strictly banned in JSP pages.

---

## 2. Visual Identity

### 2.1 Color Palette
The brand utilizes a curated "Modern Scholastic" palette:
- **Primary:** `#d97706` (Terracotta Orange) - Used for primary actions, active states, and brand highlights.
- **Background:** `#faf9f8` (Warm Off-White) - Soft on the eyes for long research and reading sessions.
- **Surface:** `#ffffff` (Pure White) - Used for cards, tables, and content containers.
- **Typography:** `#262626` (Charcoal) - High contrast for maximum readability.
- **Secondary/Neutral:** `#737373` (Medium Gray) - Used for labels, borders, and secondary text.
- **Success:** `#10b981` (Emerald Green) - System status "Active", "Available", or "Completed".
- **Danger:** `#ef4444` (Rose Red) - "Overdue", "Locked", critical errors, or "Unpaid".

### 2.2 Typography
- **Primary Font:** `Inter` or `System Sans-Serif`.
- **Headings (h1, h2, h3, h4):** Bold weights (`font-weight: 700` or `600`), Charcoal color (`#262626`).
- **Body Text:** Regular weight (`font-weight: 400`), `16px` base size.
- **Labels & Metadata:** Small, uppercase or semi-bold for metadata and form labels.

---

## 3. Component Architecture (Bootstrap Patterns)

### 3.1 Grid & Layout
- Use `.container-fluid` for full-width dashboards.
- Use a standard sidebar-plus-main-content layout for administrative/role screens.
- **Sidebar Width:** Fixed `280px` or `.col-lg-2`.
- **Content Area Offset:** Left margin must be exactly `280px` on desktop viewports to clear the fixed sidebar.

### 3.2 Cards (`.card`)
- **Border Radius:** `12px` (`border-radius: 0.75rem`).
- **Shadow:** Subtle soft shadow (`box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05)`).
- **Background & Border:** Pure white (`#ffffff`) with a 1px border (`border: 1px solid #e5e5e5`).

### 3.3 Buttons (`.btn`)
- **Primary Action (`.btn-primary`):** Customized to Terracotta Orange (`#d97706`).
- **Secondary Action:** `.btn-outline-secondary` or `.btn-light`.
- **Border Radius:** Consistent `8px` (`border-radius: 0.5rem`).
- **States:** 
  - Hover should involve a slight darkening of the primary color.
  - Active should show a scale effect (`transform: scale(0.98)`).

### 3.4 Tables (`.table`)
- Use `.table-hover` for interactive lists.
- Align numeric data (fines, amounts, count values) to the right.
- **Header Style (`thead th`):** Light gray background (`#f4f3f2`) with semi-bold text.

---

## 4. Interaction Rules
- **Empty States:** Always provide a clear "No items found" message with a relevant icon (Google Material Symbols) and a call to action.
- **Loading Indicators:** Use Bootstrap's `.spinner-border` customized with the primary brand color (`#d97706`).
- **Feedback Alerts:** Use toast messages or Bootstrap alert components for operation feedback (e.g., "Book Returned Successfully", "Payment Succeeded").

---

## 5. Development Constraints & CSS Architecture

### 5.1 CSS File Organization
Keep custom styles scoped to a single `custom.css` (or `web/assets/css/custom.css`) file that overrides Bootstrap defaults via CSS Variables where possible. The project CSS structure is organized as:
```
web/assets/css/
├── variables.css      # Custom color variables and tokens
├── custom.css         # Scoped custom overrides for Bootstrap styles
├── auth.css           # Custom split layouts and auth card styles
└── home.css           # Public landing and guest search pages styling
```

### 5.2 Iconography
Use **Google Material Symbols** or **FontAwesome** for consistent iconography across all roles (Student, Lecturer, Librarian, Admin, Library Manager).
- Example: `<span class="material-symbols-outlined">menu_book</span>`

### 5.3 Class Naming
Use BEM (Block, Element, Modifier) or Bootstrap utility conventions for custom classes to prevent styling collision (e.g., `.lms-card-header`, `.brand-primary-text`).

---

## 6. JSP & JSTL Integration Standards

To maintain clean MVC design and prevent server-side styling leakage:
- **No Java Scriptlets:** Direct Java code blocks (`<% ... %>`) are strictly banned in all views.
- **No Expressions output:** Scriptlet outputs (`<%= ... %>`) are prohibited.
- **Standard Inclusions:** Compose pages from reusable templates included via `c:import` or `jsp:include` (e.g., header, sidebar, navbar, footer).

### Sample Base Page Structure
```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>LMS - Tiêu đề</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- CSS imports matching CSS Architecture -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom.css" />
</head>
<body class="bg-light">

    <!-- Persistent Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <div style="margin-left: 280px;">
        <!-- Sticky Navigation -->
        <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

        <main class="container-fluid px-4 py-4">
            <!-- Dynamic Content goes here -->
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
```

---

## 7. Accessibility Rules (WCAG 2.1 Level AA)
- **Keyboard Navigation:** All interactive elements must be accessible via `Tab` and triggers executable via `Space`/`Enter`.
- **Contrast Ratio:** Maintain at least `4.5:1` contrast for body text against backgrounds.
- **Dual-Coding Rule:** Never rely on color alone to communicate state changes (always pair with icons or text labels).
