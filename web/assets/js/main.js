/**
 * main.js — Smart LMS JavaScript
 * Accordion toggle, scroll shadow, mobile menu
 */

/* ---- Accordion Toggle ---- */
function toggleAccordion(button) {
    var content = button.nextElementSibling;
    var icon = button.querySelector('.accordion__trigger-icon');

    /* Toggle current item */
    if (content.style.maxHeight && content.style.maxHeight !== '0px') {
        content.style.maxHeight = '0px';
        icon.style.transform = 'rotate(0deg)';
    } else {
        /* Close all other items first */
        var allContents = document.querySelectorAll('.accordion__content');
        var allIcons = document.querySelectorAll('.accordion__trigger-icon');

        for (var i = 0; i < allContents.length; i++) {
            allContents[i].style.maxHeight = '0px';
        }
        for (var i = 0; i < allIcons.length; i++) {
            allIcons[i].style.transform = 'rotate(0deg)';
        }

        /* Open clicked item */
        content.style.maxHeight = content.scrollHeight + 'px';
        icon.style.transform = 'rotate(180deg)';
    }
}

/* ---- Header Shadow on Scroll ---- */
window.addEventListener('scroll', function () {
    var header = document.querySelector('.main-header');
    if (header) {
        if (window.scrollY > 20) {
            header.classList.add('main-header--scrolled');
        } else {
            header.classList.remove('main-header--scrolled');
        }
    }
});

/* ---- Mobile Menu Toggle ---- */
function toggleMobileMenu() {
    var menu = document.getElementById('mobileMenu');
    var icon = document.getElementById('hamburgerIcon');
    if (menu) {
        menu.classList.toggle('is-open');
        if (menu.classList.contains('is-open')) {
            icon.textContent = 'close';
        } else {
            icon.textContent = 'menu';
        }
    }
}

/* Close mobile menu when clicking a link */
document.addEventListener('DOMContentLoaded', function () {
    var mobileLinks = document.querySelectorAll('.mobile-menu .nav-link');
    for (var i = 0; i < mobileLinks.length; i++) {
        mobileLinks[i].addEventListener('click', function () {
            var menu = document.getElementById('mobileMenu');
            var icon = document.getElementById('hamburgerIcon');
            if (menu) {
                menu.classList.remove('is-open');
                icon.textContent = 'menu';
            }
        });
    }
});
