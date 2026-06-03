<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>UniLib LMS - University Library Guest Portal</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&amp;display=swap"
        rel="stylesheet" />

    <!-- Material Symbols -->
    <link
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
        rel="stylesheet" />

    <style>
        :root {
            --primary-color: #9d4300;
            --primary-container: #f97316;
            --on-surface: #191c1e;
            --secondary: #565e74;
            --bg-background: #f7f9fb;
            --surface-container-low: #f2f4f6;
            --surface-container-highest: #e0e3e5;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-background);
            color: var(--on-surface);
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            vertical-align: middle;
        }

        /* Custom Theme Colors */
        .text-primary-custom {
            color: var(--primary-color) !important;
        }

        .bg-primary-container {
            background-color: var(--primary-container) !important;
        }

        .text-secondary-custom {
            color: var(--secondary) !important;
        }

        .bg-container-low {
            background-color: var(--surface-container-low) !important;
        }

        .bg-container-highest {
            background-color: var(--surface-container-highest) !important;
        }

        /* Navigation link active styling */
        .nav-link-custom {
            color: var(--secondary);
            font-weight: 500;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .nav-link-custom:hover {
            color: var(--primary-color);
        }

        .nav-link-custom.active {
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 2px;
        }

        /* Hero Image Overlay */
        .hero-section {
            position: relative;
            height: 600px;
            overflow: hidden;
        }

        .hero-img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 1;
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to right, rgba(25, 28, 30, 0.6), transparent);
            z-index: 2;
        }

        .hero-content {
            position: relative;
            z-index: 3;
        }

        /* Bento Grid Layout using CSS Grid */
        .bento-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            grid-template-rows: repeat(2, minmax(180px, auto));
            gap: 1.5rem;
        }

        @media (max-width: 768px) {
            .bento-grid {
                grid-template-columns: 1fr;
                grid-template-rows: auto;
            }
        }

        .bento-featured {
            grid-column: span 2;
            grid-row: span 2;
        }

        .bento-wide {
            grid-column: span 2;
        }

        /* Hover animations */
        .img-hover-zoom {
            overflow: hidden;
        }

        .img-hover-zoom img {
            transition: transform 0.5s ease;
        }

        .card-hover:hover .img-hover-zoom img {
            transform: scale(1.05);
        }

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

        .guest-step-num {
            width: 48px;
            height: 48px;
            background-color: var(--surface-container-highest);
            color: var(--primary-color);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .guest-step:hover .guest-step-num {
            background-color: var(--primary-color);
            color: white;
        }

        /* Policies & Regulations Styles */
        .policy-container {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            border: 1px solid var(--surface-container-highest);
            overflow: hidden;
            display: flex;
            min-height: 550px;
        }

        @media (max-width: 991px) {
            .policy-container {
                flex-direction: column;
            }
        }

        .policy-sidebar {
            width: 280px;
            background-color: var(--surface-container-low);
            border-right: 1px solid var(--surface-container-highest);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            flex-shrink: 0;
        }

        @media (max-width: 991px) {
            .policy-sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid var(--surface-container-highest);
                flex-direction: row;
                overflow-x: auto;
                padding: 1rem;
                white-space: nowrap;
                scrollbar-width: none;
            }
            .policy-sidebar::-webkit-scrollbar {
                display: none;
            }
        }

        .policy-btn {
            background: transparent;
            border: none;
            border-radius: 10px;
            padding: 1rem 1.25rem;
            text-align: left;
            font-weight: 600;
            color: var(--secondary);
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.25s ease;
            cursor: pointer;
            width: 100%;
            outline: none;
        }

        @media (max-width: 991px) {
            .policy-btn {
                width: auto;
                padding: 0.75rem 1.25rem;
            }
        }

        .policy-btn:hover {
            background-color: rgba(157, 67, 0, 0.05);
            color: var(--primary-color);
        }

        .policy-btn.active {
            background-color: var(--primary-color);
            color: white;
            box-shadow: 0 4px 12px rgba(157, 67, 0, 0.25);
        }

        .policy-content {
            flex-grow: 1;
            padding: 2.5rem;
            overflow-y: auto;
            max-height: 700px;
        }

        @media (max-width: 768px) {
            .policy-content {
                padding: 1.5rem;
            }
        }

        .policy-pane {
            display: none;
            animation: policyFadeIn 0.4s ease-out forwards;
        }

        .policy-pane.active {
            display: block;
        }

        @keyframes policyFadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .policy-header {
            border-bottom: 2px solid var(--surface-container-low);
            padding-bottom: 1rem;
            margin-bottom: 1.75rem;
        }

        .policy-title {
            color: var(--primary-color);
            font-weight: 800;
            font-size: 24px;
            margin: 0;
        }

        .policy-subtitle {
            color: var(--secondary);
            font-size: 11px;
            margin-top: 0.25rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 700;
        }

        .policy-card {
            background-color: var(--bg-background);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.25rem;
            border: 1px solid var(--surface-container-highest);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .policy-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.03);
            border-color: var(--primary-container);
        }

        .policy-card-title {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 16px;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .policy-list {
            padding-left: 1.25rem;
            margin-bottom: 0;
            color: var(--on-surface);
        }

        .policy-list li {
            margin-bottom: 0.5rem;
            line-height: 1.6;
        }

        .policy-list li:last-child {
            margin-bottom: 0;
        }

        .table-policy {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            margin-bottom: 1.5rem;
        }

        .table-policy th {
            background-color: var(--surface-container-low);
            color: var(--primary-color);
            font-weight: 700;
            text-align: left;
            padding: 1rem;
            border-bottom: 2px solid var(--surface-container-highest);
        }

        .table-policy td {
            padding: 1rem;
            border-bottom: 1px solid var(--surface-container-highest);
            color: var(--on-surface);
        }

        .table-policy tr:hover td {
            background-color: var(--surface-container-low);
        }
    </style>
</head>
