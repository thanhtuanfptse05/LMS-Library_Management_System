<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>UniLib LMS - Cổng thông tin Thư viện Đại học</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />

    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
        rel="stylesheet" />

    <!-- Material Symbols (kept for backward compat with other pages) -->
    <link
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet" />

    <style>
        :root {
            --bs-body-font-family: 'Inter', sans-serif;
            --bs-body-bg: #faf9f8;
            --bs-body-color: #1a1c1c;

            /* Brand Colors — warm brown */
            --primary-color: #8d4b00;
            --primary-hover: #6e3900;
            --primary-light: #ffdcc3;
            --text-muted-custom: #554336;
            --surface-container-high: #e9e8e7;
            --surface-container-low: #f4f3f2;
            --surface-lowest: #ffffff;
            --outline-variant: #dbc2b0;

            /* Legacy aliases (keeps other JSP pages working) */
            --primary-container: #e05a1a;
            --on-surface: #1a1c1c;
            --secondary: #554336;
            --bg-background: #faf9f8;
            --surface-container-highest: #e9e8e7;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bs-body-bg);
            color: var(--bs-body-color);
            overflow-x: hidden;
        }

        /* ─── Material Symbols ─────────────────────────────────── */
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            vertical-align: middle;
        }

        /* ─── Legacy utility aliases ───────────────────────────── */
        .text-primary-custom   { color: var(--primary-color) !important; }
        .bg-primary-container  { background-color: var(--primary-container) !important; }
        .text-secondary-custom { color: var(--secondary) !important; }
        .bg-container-low      { background-color: var(--surface-container-low) !important; }
        .bg-container-highest  { background-color: var(--surface-container-high) !important; }

        /* ─── Navigation ───────────────────────────────────────── */
        .nav-link-custom {
            font-size: 14px;
            letter-spacing: 0.02em;
            font-weight: 500;
            color: var(--text-muted-custom);
            text-decoration: none;
            padding-bottom: 4px;
            transition: color 0.2s;
        }

        .nav-link-custom:hover { color: var(--primary-color); }

        .nav-link-custom.active {
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
        }

        /* ─── Primary CTA Button ────────────────────────────────── */
        .btn-primary-custom {
            background-color: var(--primary-color);
            color: #ffffff;
            border: none;
            box-shadow: inset 0 1px 0 0 rgba(255,255,255,0.2);
            transition: all 0.2s ease-in-out;
        }

        .btn-primary-custom:hover {
            background-color: var(--primary-hover);
            color: #ffffff;
            opacity: 0.9;
        }

        .btn-primary-custom:active { transform: scale(0.98); }

        /* ─── Outline Button ────────────────────────────────────── */
        .btn-custom-outline {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            font-weight: 700;
            transition: all 0.2s ease;
        }

        .btn-custom-outline:hover {
            background-color: var(--primary-color);
            color: white;
        }

        /* ─── Hero ──────────────────────────────────────────────── */
        .hero-section {
            position: relative;
            height: 600px;
            overflow: hidden;
        }

        .hero-img {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            object-fit: cover;
            z-index: 1;
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, rgba(26,28,28,0.4), rgba(26,28,28,0.1));
            z-index: 2;
        }

        .hero-content { position: relative; z-index: 3; }

        .glass-search {
            backdrop-filter: blur(12px);
            background: rgba(255,255,255,0.95);
        }

        /* ─── Pulse Badge ───────────────────────────────────────── */
        .custom-badge-pulse {
            width: 8px; height: 8px;
            background-color: #198754;
            border-radius: 50%;
            display: inline-block;
            position: relative;
        }

        .custom-badge-pulse::after {
            content: '';
            position: absolute;
            width: 100%; height: 100%;
            background-color: #198754;
            border-radius: 50%;
            animation: custom-pulse 1.5s infinite ease-in-out;
            left: 0; top: 0;
        }

        @keyframes custom-pulse {
            0%   { transform: scale(1);   opacity: 0.75; }
            100% { transform: scale(3);   opacity: 0; }
        }

        /* ─── Shortcut / Quick-Link Cards ───────────────────────── */
        .shortcut-card {
            background-color: var(--surface-lowest);
            border: 1px solid rgba(219,194,176,0.3);
            border-radius: 0.75rem;
            padding: 32px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .shortcut-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.08);
        }

        .icon-circle {
            width: 48px; height: 48px;
            border-radius: 50%;
            background-color: var(--primary-light);
            color: var(--primary-color);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.3s ease;
        }

        .shortcut-card:hover .icon-circle { transform: scale(1.1); }

        /* ─── News Cards ────────────────────────────────────────── */
        .img-hover-zoom { overflow: hidden; }
        .img-hover-zoom img { transition: transform 0.5s ease; }
        .card-hover:hover .img-hover-zoom img { transform: scale(1.05); }

        .card-hover {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .card-hover:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.07) !important;
        }

        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* ─── Scroll-fade animation ─────────────────────────────── */
        .animate-item { transition: all 0.7s ease-out; }

        /* ─── Policies / Services (other pages) ─────────────────── */
        .bento-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            grid-template-rows: repeat(2, minmax(180px, auto));
            gap: 1.5rem;
        }

        @media (max-width: 768px) {
            .bento-grid { grid-template-columns: 1fr; grid-template-rows: auto; }
        }

        .bento-featured { grid-column: span 2; grid-row: span 2; }
        .bento-wide     { grid-column: span 2; }

        .guest-step-num {
            width: 48px; height: 48px;
            background-color: var(--surface-container-highest);
            color: var(--primary-color);
            border-radius: 12px;
            display: flex;
            align-items: center; justify-content: center;
            font-weight: bold;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .guest-step:hover .guest-step-num {
            background-color: var(--primary-color);
            color: white;
        }

        /* ─── Policy widget ─────────────────────────────────────── */
        .policy-container {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            border: 1px solid var(--surface-container-highest);
            overflow: hidden;
            display: flex;
            min-height: 550px;
        }

        @media (max-width: 991px) { .policy-container { flex-direction: column; } }

        .policy-sidebar {
            width: 280px;
            background-color: var(--surface-container-low);
            border-right: 1px solid var(--surface-container-highest);
            padding: 1.5rem;
            display: flex; flex-direction: column; gap: 0.5rem;
            flex-shrink: 0;
        }

        @media (max-width: 991px) {
            .policy-sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid var(--surface-container-highest);
                flex-direction: row;
                overflow-x: auto; padding: 1rem;
                white-space: nowrap; scrollbar-width: none;
            }
            .policy-sidebar::-webkit-scrollbar { display: none; }
        }

        .policy-btn {
            background: transparent; border: none;
            border-radius: 10px; padding: 1rem 1.25rem;
            text-align: left; font-weight: 600;
            color: var(--secondary); font-size: 15px;
            display: flex; align-items: center; gap: 0.75rem;
            transition: all 0.25s ease; cursor: pointer;
            width: 100%; outline: none;
        }

        @media (max-width: 991px) { .policy-btn { width: auto; padding: 0.75rem 1.25rem; } }

        .policy-btn:hover { background-color: rgba(141,75,0,0.05); color: var(--primary-color); }
        .policy-btn.active { background-color: var(--primary-color); color: white; box-shadow: 0 4px 12px rgba(141,75,0,0.25); }

        .policy-content { flex-grow: 1; padding: 2.5rem; overflow-y: auto; max-height: 700px; }
        @media (max-width: 768px) { .policy-content { padding: 1.5rem; } }

        .policy-pane { display: none; animation: policyFadeIn 0.4s ease-out forwards; }
        .policy-pane.active { display: block; }

        @keyframes policyFadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .policy-header { border-bottom: 2px solid var(--surface-container-low); padding-bottom: 1rem; margin-bottom: 1.75rem; }
        .policy-title  { color: var(--primary-color); font-weight: 800; font-size: 24px; margin: 0; }
        .policy-subtitle { color: var(--secondary); font-size: 11px; margin-top: 0.25rem; text-transform: uppercase; letter-spacing: 0.05em; font-weight: 700; }

        .policy-card {
            background-color: var(--bg-background); border-radius: 12px;
            padding: 1.5rem; margin-bottom: 1.25rem;
            border: 1px solid var(--surface-container-highest);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .policy-card:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(0,0,0,0.03); border-color: var(--primary-container); }
        .policy-card-title { color: var(--primary-color); font-weight: 700; font-size: 16px; margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.5rem; }
        .policy-list { padding-left: 1.25rem; margin-bottom: 0; color: var(--on-surface); }
        .policy-list li { margin-bottom: 0.5rem; line-height: 1.6; }
        .policy-list li:last-child { margin-bottom: 0; }

        .table-policy { width: 100%; border-collapse: collapse; margin-top: 1rem; margin-bottom: 1.5rem; }
        .table-policy th { background-color: var(--surface-container-low); color: var(--primary-color); font-weight: 700; text-align: left; padding: 1rem; border-bottom: 2px solid var(--surface-container-highest); }
        .table-policy td { padding: 1rem; border-bottom: 1px solid var(--surface-container-highest); color: var(--on-surface); }
        .table-policy tr:hover td { background-color: var(--surface-container-low); }
    </style>
</head>
