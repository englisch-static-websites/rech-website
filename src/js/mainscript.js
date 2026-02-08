const main_url = window.location.pathname.replace('/', '');

const header_css_path = [
    'src/css/elements/header/apfel.css',
    'src/css/elements/header/birne.css',
    'src/css/elements/header/pflaume.css',
    'src/css/elements/header/erdbeere.css',
];

document.addEventListener('DOMContentLoaded', function () {
    let header_index = 0;

    switch (main_url) {
        case 'aepfel':
            header_index = 0;
            break;
        case 'birnen':
            header_index = 1;
            break;
        case 'startseite':
        case 'steinobst':
            header_index = 2;
            break;
        case 'erdbeeren':
            header_index = 3;
            break;
        default:
            header_index = Math.floor(Math.random() * 4);
            break;
    }

    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.type = 'text/css';
    link.href = header_css_path[header_index];
    document.head.appendChild(link);

    /* =============================================
       Touch-Support für Dropdown-Menüs (iPad/iPhone Querformat)
       Auf Touch-Geräten im Desktop-Layout (>768px) funktioniert
       :hover nicht zuverlässig. Deshalb togglen wir per Klick/Touch
       eine CSS-Klasse "dropdown-open" auf dem Parent-<li>.
       ============================================= */
    const dropdownToggles = document.querySelectorAll('.navbar-menu-topic');

    dropdownToggles.forEach(function (toggle) {
        toggle.setAttribute('tabindex', '0');
        toggle.setAttribute('role', 'button');
        toggle.setAttribute('aria-expanded', 'false');
        toggle.setAttribute('aria-haspopup', 'true');

        function toggleDropdown(el) {
            var parentLi = el.closest('li');
            var isOpen = parentLi.classList.contains('dropdown-open');

            document.querySelectorAll('.navbar li.dropdown-open').forEach(function (openLi) {
                openLi.classList.remove('dropdown-open');
                var t = openLi.querySelector('.navbar-menu-topic');
                if (t) t.setAttribute('aria-expanded', 'false');
            });

            if (!isOpen) {
                parentLi.classList.add('dropdown-open');
                el.setAttribute('aria-expanded', 'true');
            }
        }

        toggle.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            toggleDropdown(this);
        });

        toggle.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                e.stopPropagation();
                toggleDropdown(this);
            } else if (e.key === 'Escape') {
                var parentLi = this.closest('li');
                parentLi.classList.remove('dropdown-open');
                this.setAttribute('aria-expanded', 'false');
            }
        });
    });

    // Dropdown schließen wenn außerhalb geklickt wird
    document.addEventListener('click', function () {
        document.querySelectorAll('.navbar li.dropdown-open').forEach(function (openLi) {
            openLi.classList.remove('dropdown-open');
        });
    });
});
