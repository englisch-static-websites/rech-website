const main_url = window.location.pathname.replace('/', '');

const header_css_path = [
    'src/css/elements/header/apfel.css',
    'src/css/elements/header/birne.css',
    'src/css/elements/header/pflaume.css',
    'src/css/elements/header/erdbeere.css',
];

$(document).ready(function () {
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

    $("<link/>", {
        rel: "stylesheet",
        type: "text/css",
        href: header_css_path[header_index]
    }).appendTo("head");
});
