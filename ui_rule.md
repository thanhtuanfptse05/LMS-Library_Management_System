# Global UI/UX Design Constitution — Library Management System (LMS)

This document serves as the absolute, single source of truth for all User Interface (UI) and User Experience (UX) standards in the LMS (Library Management System) project. Every future specification, page layout, custom component, style sheet, and JSP implementation must strictly comply with these rules.

---

## 1. Design Philosophy

The LMS design system balances the academic nature of a university library with the robust operational efficiency of an enterprise administration tool.

*   **Modern & Aesthetic:** Embraces rich aesthetic standards including curated warm color palettes, smooth hover states, progressive shadow depths, visual hierarchy, and polished micro-interactions (e.g., scale transforms, transitions).
*   **Clean & Structured:** Eliminates cognitive load. Group information into logical containers. Use negative space deliberately as a structural layout element.
*   **Academic & Professional:** Implements readable, high-quality typography and clear, non-distracting layouts to facilitate long reading hours, catalog search, and data tracking.
*   **Enterprise Security & Control:** Standardizes elements for high-density administrative views (such as data tables, audit logs, and status dashboards) to give librarians and system administrators total visual control.

---

## 2. Color System

To achieve maximum visual cohesion, the LMS utilizes a curated warm color palette inspired by Material Design 3. The color application follows the **60-30-10 Rule**:
*   **60% Dominant (Neutrals):** Page backgrounds (`--color-background`), main canvas areas, and surface backdrops.
*   **30% Secondary (Structure & Containers):** Card containers, borders, navigation elements, table headers, and sidebar containers.
*   **10% Accent (Primary & Interactions):** Call-to-action buttons, active states, search highlights, key success markers, and vital alerts.

### CSS Custom Properties (`web/assets/css/variables.css`)

```css
:root {
    /* ---- Core Accent / Primary ---- */
    --color-primary:                 #9d4300; /* Terracotta Orange */
    --color-on-primary:              #ffffff;
    --color-primary-container:       #f97316; /* Bright Orange Accent */
    --color-on-primary-container:    #582200;
    --color-primary-fixed:           #ffdbca;
    --color-primary-fixed-dim:       #ffb690;
    --color-surface-tint:            #9d4300;

    /* ---- Supporting / Secondary ---- */
    --color-secondary:               #755935; /* Ochre Brown */
    --color-on-secondary:            #ffffff;
    --color-secondary-container:     #fdd6a9;
    --color-on-secondary-container:  #785c38;
    --color-secondary-fixed:         #ffddb7;
    --color-secondary-fixed-dim:     #e6c095;
    --color-on-secondary-fixed:      #2a1800;
    --color-on-secondary-fixed-variant: #5b4220;

    /* ---- Neutral / Tertiary (Slate Blue for System Info) ---- */
    --color-tertiary:                #006398; /* Slate Blue */
    --color-on-tertiary:             #ffffff;
    --color-tertiary-container:      rgba(0, 99, 152, 0.15);
    --color-tertiary-fixed:          #e9e1d8;
    --color-tertiary-fixed-dim:      #ccc5bc;
    --color-on-tertiary-fixed:       #1e1b15;
    --color-on-tertiary-fixed-variant: #4a463f;

    /* ---- Semantic Tones ---- */
    --color-success:                 #16a34a; /* Emerald Green */
    --color-on-success:              #ffffff;
    
    --color-error:                   #ba1a1a; /* Crimson Red */
    --color-on-error:                #ffffff;
    --color-error-container:         #ffdad6;
    --color-on-error-container:      #93000a;

    --color-warning:                 #eab308; /* Muted Yellow */
    --color-on-warning:              #1e1b4b;
    --color-warning-container:       #fef9c3;
    
    --color-info:                    #0284c7; /* Ocean Blue */
    --color-on-info:                 #ffffff;
    --color-info-container:          #e0f2fe;

    /* ---- Surface & Backgrounds ---- */
    --color-background:              #fff8f6; /* Very soft warm tint */
    --color-on-background:           #251913;
    --color-surface:                 #ffffff;
    --color-on-surface:              #251913;
    
    --color-surface-container-lowest:  #ffffff;
    --color-surface-container-low:     #fff1eb;
    --color-surface-container:         #ffeae0;
    --color-surface-container-high:    #dee9fc;
    --color-surface-container-highest: #d9e3f6;
    
    --color-surface-variant:         #d9e3f6;
    --color-on-surface-variant:      #584237;
    --color-surface-dim:             #d0dbed;
    --color-surface-bright:          #f8f9ff;

    /* ---- Borders & Outlines ---- */
    --color-outline:                 #8c7164;
    --color-outline-variant:         #e0c0b1;

    /* ---- Inverse Layout Tones ---- */
    --color-inverse-surface:         #27313f;
    --color-inverse-on-surface:      #eaf1ff;
    --color-inverse-primary:         #ffb690;
}
```

---

## 3. Typography Rules

LMS uses Google Fonts as its typographic engine. It limits font families to two for absolute consistency:
1.  **Body & UI Controls Font:** `'Inter'`, sans-serif (legible, high readability).
2.  **Headlines & Display Font:** `'Geist'` or `'Inter'`, sans-serif (premium, structured).

### Typography Scale

| Element | CSS Property / Variable | Font Size | Line Height | Weight | Usage |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Display** | `--text-display` | `48px` | `56px` | Bold (`700`) | Hero / landing titles |
| **h1** | `--text-headline-lg` | `32px` | `40px` | Bold (`600`) | Page titles (Only 1 per page) |
| **h2** | `--text-headline-md` | `24px` | `32px` | Semi-Bold (`600`) | Main section panels, modal headers |
| **h3** | `--text-body-lg` | `18px` | `28px` | Semi-Bold (`600`) | Sub-sections, dashboard widget titles |
| **h4** | `--text-label-md` | `14px` | `20px` | Semi-Bold (`600`) | Field labels, small subtitles |
| **body** | `--text-body-md` | `16px` | `24px` | Regular (`400`) | Standard body text, description fields |
| **small** | `--text-body-sm` | `14px` | `20px` | Regular (`400`) | Helper texts, metadata, table content |
| **micro** | `--text-label-sm` | `12px` | `16px` | Medium (`500`) | Badges, status tags, timestamps |

*   **Line length limit:** Body text paragraph width must not exceed `700px` (roughly 45–75 characters per line) to prevent reading fatigue.
*   **Case adjustments:** Uppercase is reserved strictly for badge tags, column headers, and section headers with small font sizes. In those cases, letter spacing must be adjusted by `+0.05em`.

---

## 4. Layout Rules

The application utilizes a persistent master-detail admin panel layout, structured using semantic HTML5 tags: `<aside>` for navigation, `<header>` for global info, and `<main>` for core views.

```
+-----------------------------------------------------------------------------------+
|  LOGO      |  Global Search Bar            |  Role Tag   Notify   Avatar   Logout |  <-- Topbar
+-----------------------------------------------------------------------------------+
|  Sidebar   |  Home / Page / Breadcrumbs                                           |
|  - Dash    |  -----------------------------------------------------------------   |
|  - Users   |  Page Title (H1)                                                     |
|  - Books   |  +--------------------+  +--------------------+  +----------------+  |
|  - Records |  | Metric Card 1      |  | Metric Card 2      |  | Metric Card 3  |  |  <-- 3/4-Col Grid
|  - Fines   |  +--------------------+  +--------------------+  +----------------+  |
|  - Config  |                                                                      |
|            |  +--------------------------------------------+  +----------------+  |
|            |  | Main Data Table (8 cols)                   |  | Side Stack (4) |  <-- Asymmetric Grid
|            |  +--------------------------------------------+  +----------------+  |
+------------+----------------------------------------------------------------------+
```

### 4.1 Sidebar (`.sidebar`)
*   **Width:** `16rem` (`256px`)
*   **Collapsed Width (Mobile):** Hidden by default (`0px`), toggled via menu button as an overlay.
*   **Position:** Fixed to the left (`position: fixed; left: 0; top: 0; height: 100vh`).
*   **Visuals:** White surface (`--color-surface`) with light border-right (`1px solid var(--color-outline-variant)`), box-shadow (`var(--shadow-sm)`). Contains a top brand area (`.sidebar-brand`), a scrollable navigation container (`.sidebar-nav`), and a footer with a search trigger button (`.sidebar-footer`).

### 4.2 Topbar / Header (`.main-header`)
*   **Height:** `4rem` (`64px`).
*   **Behavior:** Sticky top (`position: sticky; top: 0; z-index: 40`).
*   **Visuals:** Glassmorphism overlay backdrop (`background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(12px)`), thin outline bottom (`1px solid var(--color-outline-variant)`).
*   **Layout:** Flex container containing system title (left) and user profile pill, notifications icon, help button, role badge, and logout action (right).

### 4.3 Content Area (`.main-content` / `.container-max`)
*   **Offset:** Left margin must be exactly `16rem` (`256px`) on desktop viewports to clear the fixed sidebar.
*   **Max Width:** `1440px` (centered using `margin: 0 auto;`).
*   **Padding:** Outer gutters must be `40px` (desktop), `24px` (tablet), and `16px` (mobile).

### 4.4 Grid System (`web/assets/css/layout.css`)
*   **Standard Spacing Gap:** `var(--space-gutter)` / `24px` grid gaps.
*   **2-Column Grid:** For dashboards or profile settings (`grid-template-columns: repeat(2, 1fr)`).
*   **3-Column Grid:** For secondary metric configurations or catalog cards (`grid-template-columns: repeat(3, 1fr)`).
*   **4-Column Grid:** Standard for statistics and summary metrics overview (`grid-template-columns: repeat(4, 1fr)`).
*   **Asymmetric Bento Grid:** Large workspace on left (grid column span 8), narrow utility list on right (grid column span 4).

---

## 5. Component Rules

All UI components must be modular and fully styled inside `web/assets/css/components.css`.

### 5.1 Buttons
Buttons must feature a scale-down transition on active click and a scale-up or brightness filter on hover.

```
  +------------------+     +------------------+     +------------------+     +------------------+
  |     PRIMARY      |     |    SECONDARY     |     |     SUCCESS      |     |      DANGER      |
  |  Solid primary   |     |  Outlined brown  |     |  Green background|     |  Red background  |
  |  White text      |     |  Primary text    |     |  White text      |     |  White text      |
  +------------------+     +------------------+     +------------------+     +------------------+
```

*   **Primary Button (`.btn-primary`):** Solid background (`--color-primary`), text color (`--color-on-primary`). Hover scale: `1.02`.
*   **Secondary Button (`.btn-outline`):** Transparent background, outline border (`1px solid var(--color-outline)`), text color (`--color-on-surface-variant`).
*   **Success Button (`.btn-success`):** Solid green background (`--color-success`), text color (`white`).
*   **Danger / Destructive Button (`.btn-danger`):** Solid red background (`--color-error`), text color (`--color-on-error`).
*   **Interaction States:**
    *   `hover`: `:hover { transform: scale(1.02); filter: brightness(110%); }`
    *   `focus`: `:focus-visible { outline: 2px solid var(--color-primary); outline-offset: 2px; }`
    *   `active`: `:active { transform: scale(0.98); }`
    *   `disabled`: `[disabled] { opacity: 0.5; cursor: not-allowed; transform: none; filter: none; }`

### 5.2 Forms
Labels must always sit stacked vertically directly above their corresponding inputs.

*   **Inputs & Textareas (`.form-input`, `.form-textarea`):** White background, border radius `8px` (`--radius-lg`), border (`1px solid var(--color-outline-variant)`). Focus outline creates a clean glow effect using `--color-primary` and a light shadow:
    ```css
    .form-input:focus {
        border-color: var(--color-primary);
        box-shadow: 0 0 0 2px rgba(249, 115, 22, 0.2);
    }
    ```
*   **Select Menus (`.form-select`):** Follows input styling, utilizing default native browser indicators for system compatibility, avoiding custom JS selectors for performance reasons.
*   **Checkboxes & Radios (`.form-checkbox`, `.form-radio`):** Custom border checks with matching terracotta color styles. Tap target width must be a minimum of `20px x 20px`.
*   **Validation States:**
    *   *Invalid:* Input border becomes `--color-error` (red). An error message is rendered immediately below in red text prefixed with a warning icon.
    *   *Valid:* Optional subtle check icon inside the wrapper when fields pass local constraints on blur.

### 5.3 Tables
Tabular components are optimized for maximum visibility of library books, transactions, and users.

```
  +---------------------------------------------------------------------------------+
  | TIMESTAMP     USER           ACTION TYPE          ENTITY NAME                   | <-- Table Head (Gray)
  +---------------------------------------------------------------------------------+
  | 14:23:05      Admin_Sarah    [badge-info:CREATE]  New Library Branch - North    | <-- Rows with border-bottom
  | 14:15:22      Librarian_John [badge-warn:UPDATE]  Book Meta ID #9982            | <-- Hover effect
  +---------------------------------------------------------------------------------+
```

*   **Header Style (`thead th`):** Font size `12px` (`--text-label-sm`), bold, dark text (`--color-on-surface-variant`), background surface container low (`--color-surface-container-low`). Top and bottom borders must be absolute `1px solid var(--color-outline-variant)`.
*   **Row Style (`tbody tr`):** Generous height (`48px` to `56px`), border-bottom (`1px solid var(--color-surface-container)`). Right-align currency and fines, left-align text data, center status badges.
*   **Hover State:** Row background changes smoothly to `--color-surface-container-low` on hover (`transition: background-color var(--transition-fast)`).
*   **Pagination (`.table-pagination`):** Positioned at the bottom-right of the table. Standard navigation arrows (`chevron_left` and `chevron_right`) with active state highlight bubbles and text count (e.g., "Showing 1-10 of 120 results").

### 5.4 Cards
*   **Dashboard Widget Cards (`.dash-card`):** White background, border (`1px solid var(--color-surface-container-highest)`), border radius `16px` (`--radius-2xl`), padding `24px` (`--space-lg`).
*   **Statistics Metrics Cards (`.metric-card`):** Thick left accent color border (`4px solid`) mapping to status severity:
    *   Primary: `--color-primary` (Terracotta)
    *   Secondary: `--color-secondary` (Ochre)
    *   Info / Slate: `--color-tertiary` (Blue)
    *   Error / Locked: `--color-error` (Red)
    *   Success: `--color-success` (Green)
*   **Information Cards (`.info-card`):** Uses card structure but contains a soft background overlay.

### 5.5 Badges
Badges use micro font size (`11px` or `12px`), bold, all-caps spacing. They feature a soft background transparent container and high contrast text:

*   **Primary / Neutral:** Background `rgba(157, 67, 0, 0.1)`, Text color `--color-primary`.
*   **Success (`.badge-success`):** Background `rgba(34, 197, 94, 0.1)`, Text color `#16a34a`.
*   **Warning (`.badge-warning`):** Background `--color-secondary-container`, Text color `--color-on-secondary-container`.
*   **Danger / Error (`.badge-error`):** Background `--color-error-container`, Text color `--color-error`.
*   **Info / Slate (`.badge-info`):** Background `rgba(0, 162, 244, 0.1)`, Text color `#006398`.

### 5.6 Alerts
Banners or inline indicators to announce operations status.

*   **Structure:** Flex row containing icon (left), header + desc body text (center), close button (right).
*   **Semantic Themes:**
    *   *Success:* Green border-left, light green background, emerald icon.
    *   *Warning:* Ochre border-left, light yellow/brown background, warning icon.
    *   *Danger:* Red border-left, light red background (`--color-error-container`), error icon.
    *   *Info:* Blue border-left, light slate background, info icon.

### 5.7 Modal
*   **Structure:** Fixed backdrop (`.modal-backdrop`) covering screen (`background-color: rgba(37, 25, 19, 0.5); backdrop-filter: blur(4px)`). Floating content dialog (`.modal-dialog`) centered vertically and horizontally.
*   **Sizing:** Max widths:
    *   Small (Confirmations, Alerts): `400px`
    *   Medium (Forms, Creation): `600px`
    *   Large (Detail review): `800px`
*   **Spacing:** Modal padding must be `24px` (`--space-lg`), with header and footer separated by a subtle border line.

---

## 6. Dashboard Standards

LMS role dashboards (Admin, Librarian, Member) must adhere to a strict visual sequence to ensure layout predictability.

### 6.1 Page Layout Sequence
1.  **Sidebar (`<aside>`):** Left-aligned, persistent menu showing the role options.
2.  **Topbar Header (`<header>`):** Top alignment, system title, and active user credentials.
3.  **Page Header Area:** Houses the Breadcrumb navigation, primary page title (`H1`), page subtitle, and page action buttons (e.g., "Add User", "Issue Book").
4.  **Statistics Section (`.stats-grid`):** 4-column metric grid displaying primary data indicators.
5.  **Main Content Section (`.bento-grid`):** Asymmetric layout with:
    *   *Left Area (Wide, Span 8):* Main data tables, charts, or recent transactions.
    *   *Right Area (Narrow, Span 4):* Quick action controls, audit alerts stack, system status metrics.

### 6.2 Grid & Chart Area Ratios
*   Primary data panels must occupy **66% (2/3)** of the horizontal content layout space.
*   Supporting feeds and quick-action stacks must occupy **33% (1/3)** of the horizontal workspace.
*   Table rows must show a maximum of **5 to 10 rows** on the dashboard home screen before requiring navigation to the full sub-module.

---

## 7. Responsive Rules

Media queries must utilize absolute break-points corresponding to standard desktop, laptop, tablet, and mobile dimensions.

```
       MOBILE (<768px)                TABLET (768px - 991px)            DESKTOP (>=1200px)
     +-----------------+             +------------------------+      +------------------------+
     | [=]  LOGO   [U] |             |  LOGO  Search      [U] |      | LOGO  Nav1  Nav2   [U] |
     +-----------------+             +------------------------+      +------------------------+
     | Title           |             | Title                  |      | Title                  |
     | +-------------+ |             | +--------+  +--------+ |      | +----+ +----+ +----+   |
     | | Card 1      | |             | | Card 1 |  | Card 2 | |      | |Card| |Card| |Card|   |
     | | (Full)      | |             | +--------+  +--------+ |      | +----+ +----+ +----+   |
     | +-------------+ |             |                        |      |                        |
     +-----------------+             +------------------------+      +------------------------+
```

### Breakpoint Registry

*   **Desktop:** `>= 1200px`
*   **Laptop:** `992px` to `1199px`
*   **Tablet:** `768px` to `991px`
*   **Mobile:** `< 768px`

### Layout Adaptations

*   **Sidebar behavior:**
    *   *>= 992px (Desktop/Laptop):* Persistent, fixed layout, pushes main content margin-left to `16rem`.
    *   *< 992px (Tablet/Mobile):* Completely hidden. Activates as a slide-out drawer overlapping the page canvas from the left when clicking the hamburger icon. Main content margin-left collapses to `0px`.
*   **Grid layout reflow:**
    *   *Desktop:* 4-column metric grids, 12-column bento grids.
    *   *Tablet:* 2-column grids.
    *   *Mobile:* 1-column layouts (`grid-template-columns: 1fr`).
*   **Table responsive wraps:**
    *   On tablet and mobile viewports, tables must wrap inside a container with `overflow-x: auto` to allow horizontal scrolling of columns without breaking the grid canvas layout.
*   **Forms adaptation:**
    *   Form control fields reflow from multiple inline items (e.g. City, ZIP) into single vertical blocks on mobile.

---

## 8. CSS Architecture

To maintain a clean MVC application layout and prevent styles from leaking across views, stylesheet organization is divided into specialized modules:

```
web/assets/css/
├── variables.css      # Design tokens, color hexes, typography scales, shadows
├── base.css           # CSS reset, browser normalization, typography helpers, margins
├── layout.css         # Grid definitions, sidebar placement, topbar positions, flex containers
├── components.css     # Buttons, Cards, Inputs, Tables, Modals, Badges, Alerts styles
├── auth.css           # Custom split layouts, verification boxes, login styles
└── home.css           # Landing page assets, search panels, information grid
```

### File-Level Constraints

1.  **`variables.css`:** Must contain *only* CSS Custom Properties (`:root { --var: val; }`). No visual selectors, no HTML layout styles.
2.  **`base.css`:** Contains global resets, default body styles (such as background `#FFF7ED` and font `'Inter'`), basic font tag overrides (`h1`, `h2`, `h3`, `h4`, `p`, `a`), and accessibility utility classes (such as `.sr-only`).
3.  **`layout.css`:** Contains structural positioning classes only. Handles the `.sidebar`, `.main-header`, grid ratios, flex helper rules, and responsiveness breakpoints.
4.  **`components.css`:** Houses all reusable component styles. No layout styling or page-specific overrides are allowed here.
5.  **`auth.css`:** Restricted to authentication structures (e.g., split screens, reset forms, credential error displays).
6.  **`home.css`:** Houses unique layouts for the guest search engine and landing page dashboard.

---

## 9. Naming Convention

LMS uses the **BEM (Block, Element, Modifier)** CSS naming convention. Generic selectors (e.g. `.title`, `.card`, `.input`) are forbidden to prevent styling collision.

### Naming Grammar

*   **Block:** Represents the standalone component entity.
    *   *Example:* `.dashboard-card`, `.form-group`, `.table-container`
*   **Element:** Parts of the block that perform a specific inner utility. Separated by a double underscore (`__`).
    *   *Example:* `.dashboard-card__title`, `.dashboard-card__value`, `.form-group__label`
*   **Modifier:** Represents state variations or layout shapes. Separated by double hyphens (`--`).
    *   *Example:* `.btn-primary--lg`, `.form-input--invalid`, `.dashboard-card--highlighted`

### BEM Mapping Example

```html
<!-- Proper BEM structure -->
<div class="dashboard-card dashboard-card--highlighted">
    <div class="dashboard-card__header">
        <h3 class="dashboard-card__title">Total Books</h3>
        <span class="material-symbols-outlined dashboard-card__icon">book</span>
    </div>
    <div class="dashboard-card__body">
        <span class="dashboard-card__value">12,050</span>
        <span class="dashboard-card__trend dashboard-card__trend--up">12% this month</span>
    </div>
</div>
```

---

## 10. JSP Standards

To comply with MVC patterns and enforce high-performance page loads, JSP templates must follow strict JSTL/EL constraints.

### 10.1 Forbidden Code Patterns (Cấm tuyệt đối)
*   **No Java Scriptlets:** Java code blocks (`<% ... %>`) are strictly banned in all views.
*   **No Expressions output:** Scriptlet outputs (`<%= ... %>`) are prohibited.
*   **No declarations:** Component declarations (`%! ... %>`) are prohibited.
*   *Alternative:* All operations, list mapping, logical loops, and dynamic outputs must use **JSTL** tags and **EL** expressions.

### 10.2 Recommended Include Structure
Pages must be composed of reusable template parts (segments) included via directive includes. These files are stored in the `/WEB-INF/views/common/` folder:

*   **`header.jspf`:** Houses document HTML top declaration, meta headers, styling links.
*   **`sidebar.jspf`:** Persistent menu drawer containing navigation links matching user session roles.
*   **`navbar.jspf`:** Global topbar containing profile details.
*   **`footer.jspf`:** Script includes, copyright layouts, and closing document elements.

### 10.3 Role Layout Inclusions

All JSP pages must import components using standard servlet scopes. Role views (admin, librarian, student) must consume the same CSS token framework:

```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>LMS - Title</title>
    <!-- CSS imports matching CSS Architecture -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css" />
</head>
<body class="dash-body">

    <!-- Persistent Sidebar Included dynamically -->
    <c:import url="/WEB-INF/views/common/sidebar.jsp" />

    <div class="dash-main-wrapper">
        <!-- Sticky Top Navigation -->
        <c:import url="/WEB-INF/views/common/navbar.jsp" />

        <main class="dash-main">
            <div class="dash-container">
                <!-- Page Title -->
                <div class="page-header">
                    <div>
                        <h1 class="page-title">Page Title</h1>
                        <p class="page-subtitle">Subtext description.</p>
                    </div>
                </div>

                <!-- Core Work Canvas -->
                <!-- Dynamic Content goes here -->

            </div>
        </main>
    </div>

    <c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
```

---

## 11. Accessibility Rules

LMS must pass **WCAG 2.1 Level AA** specifications to ensure all university students, including those with visual or motor impairments, can access library services.

### 11.1 Keyboard Navigation
*   All interactive components (buttons, links, search fields) must be fully reachable and clickable using keyboard controls (`Tab`, `Shift+Tab`, `Space`, `Enter`).
*   Keyboard focus must *never* get trapped within overlays or dialog controls.
*   Pressing the `Escape` key must close active modals and dropdowns instantly, returning keyboard focus to the button that triggered them.

### 11.2 Focus Indicators
*   Focused elements must display a high-contrast focus outline.
*   **Outline standard:** `:focus-visible { outline: 2px solid var(--color-primary); outline-offset: 2px; }`.

### 11.3 Color Contrast Ratio
*   Body text and heading controls must maintain a minimum contrast ratio of `4.5:1` against adjacent background colors.
*   Active icons, borders, and input rings must maintain a minimum contrast ratio of `3:1` against surface backgrounds.
*   **Dual-Coding Rule:** Never rely on color alone to communicate state changes (e.g. green for success, red for error). Text descriptions, alerts, or status icons must always accompany color cues.

### 11.4 ARIA Attributes
*   Non-semantic layout tags that function as buttons or inputs must use `role="button"` or `role="search"`.
*   Interactive dropdown inputs must declare `aria-expanded="false"` (state updates to `true` when clicked) and `aria-haspopup="listbox"`.
*   Decorative graphics must contain empty alternative tags (`alt=""`) so screen readers skip them. Meaningful icons must feature descriptive alternative labels.

---

## 12. Final Folder Structure

To maintain separation of concerns under Java MVC patterns, files must reside inside the following structure:

```
project-root/
├── web/
│   ├── assets/
│   │   ├── css/
│   │   │   ├── variables.css      # Core Design tokens (CSS variables only)
│   │   │   ├── base.css           # Global CSS resets & default tags
│   │   │   ├── layout.css         # Grid system and alignment structures
│   │   │   ├── components.css     # Buttons, cards, forms, tables, badges, modals
│   │   │   ├── auth.css           # Authentication layout styling
│   │   │   └── home.css           # Public landing and guest search pages styling
│   │   └── js/
│   │       ├── main.js            # Global micro-interactions & toast trigger handlers
│   │       └── auth.js            # Login validations and strength indicator logic
│   ├── auth/                      # Native servlet entry handles
│   └── WEB-INF/
│       ├── views/
│       │   ├── admin/             # System config, audit logs, user management JSP
│       │   ├── librarian/         # Book records, borrow lists, check-out forms JSP
│       │   ├── member/            # My loans, digital reservation, profiles JSP
│       │   ├── auth/              # Login, forgot password, reset password JSP
│       │   ├── common/            # Header, sidebar, navbar, footer inclusions JSP
│       │   ├── error/             # 403, 404, and 500 error display views JSP
│       │   └── guest/             # Landing search list, public catalogs JSP
│       └── web.xml                # Context settings and filter mappings
└── src/
    └── java/                      # Standard Controller, Service, DAO pattern backend
```

---

## 13. Enforcement Rules

### 13.1 Design Review Gate
Every pull request introducing new visual modules or page alterations must be verified against this document before being approved by the Frontend/UI Lead.

### 13.2 Exceptions & Discrepancies
No inline styles (`style="..."`) are allowed inside JSP pages. If a unique widget demands custom metrics not represented inside `variables.css`, a dedicated class name must be declared and documented.
