---
name: LMS University Library (Modern Scholastic)
description: A premium, academic UI design system built on Bootstrap 5 foundations.
version: 1.0.0
---

# Design System: LMS University Library

## 1. Core Principles
*   **Scholarly & Premium:** High-end academic feel—warm, trustworthy, and organized.
*   **Efficiency First:** Minimal friction for functional tasks (circulation, resource management).
*   **Consistency:** Unified experience across Student, Lecturer, Librarian, and Admin roles.
*   **Framework Strictness:** Built exclusively on **Bootstrap 5.x**. Tailwind CSS is prohibited.
*   **Language Strictness:** All user interfaces, labels, error messages, and elements must be written entirely in **Vietnamese (100% tiếng Việt)**.

---

## 2. Visual Identity

### 2.1 Color Palette
The "Modern Scholastic" palette uses warm tones to reduce eye strain during long research sessions.

| Role | Hex | Usage |
| :--- | :--- | :--- |
| **Primary** | `#d97706` | Actions, active states, brand highlights (Terracotta Orange). |
| **Background** | `#faf9f8` | Primary page background (Warm Off-White). |
| **Surface** | `#ffffff` | Card backgrounds, containers, inputs. |
| **Charcoal** | `#262626` | Primary headings and high-contrast body text. |
| **Secondary** | `#737373` | Labels, metadata, and secondary text. |
| **Success** | `#10b981` | Availability, "Active" status, success toasts. |
| **Danger** | `#ef4444` | Overdue items, "Locked" accounts, critical errors. |
| **Border** | `#e5e5e5` | Subtle dividers and card outlines. |

### 2.2 Typography
*   **Primary Font:** `Inter`, `system-ui`, `-apple-system`, `sans-serif`.
*   **Headings:** Bold weight (`700`), Charcoal color (`#262626`).
*   **Body Text:** Regular weight (`400`), base size `16px`, Charcoal color.
*   **Metadata/Labels:** Small (`14px` or less), often Medium weight (`500`) or Semi-bold.

---

## 3. Component Standards (Bootstrap 5 Implementation)

### 3.1 Grid & Layout
*   **Dashboard Layout:** Sidebar (fixed `280px` or `col-lg-2`) + Main Content Area.
*   **Containers:** Use `.container-fluid` for full-width dashboards; `.container` for public/guest pages.
*   **Spacing:** Follow Bootstrap's spacing scale (e.g., `py-4`, `mb-3`, `gap-3`).

### 3.2 Cards (`.card`)
*   **Background:** White (`#ffffff`).
*   **Border:** `1px solid #e5e5e5`.
*   **Radius:** `12px` (`0.75rem`).
*   **Shadow:** `0 4px 6px -1px rgba(0,0,0,0.05)` (Subtle elevation).

### 3.3 Buttons (`.btn`)
*   **Primary:** `.btn-primary` overridden with `#d97706`.
*   **Secondary:** `.btn-outline-secondary` or `.btn-light`.
*   **Radius:** `8px` (`0.5rem`).
*   **Interaction:** Hover state involves a slight darkening; active state uses a slight scale down (`0.98`).

### 3.4 Tables (`.table`)
*   **Header:** Light gray background (`#f4f3f2`) with semi-bold text.
*   **Hover:** Use `.table-hover` for interactive records.
*   **Alignment:** Text-heavy columns left-aligned; numerical/action columns right-aligned.

---

## 4. Iconography
*   **Primary Set:** Google Material Symbols (Outlined or Rounded).
*   **Alternate:** FontAwesome 6 Free.
*   **Consistency:** Use consistent stroke weights across all interface elements.

---

## 5. Interaction Design
*   **Empty States:** Clear icon + "No items found" message + primary CTA.
*   **Status Indicators:** Small pill-shaped badges (`.badge .rounded-pill`) for status tracking (e.g., "Active", "Borrowed", "Overdue").
*   **Feedback:** Toast notifications for asynchronous actions (e.g., "Book reserved successfully").
