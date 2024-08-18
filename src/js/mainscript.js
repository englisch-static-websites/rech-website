const main_url = window.location.pathname.replace('/', '');

const header_css_path = [
    'src/css/elements/header/apple.css',
    'src/css/elements/header/pear.css',
    'src/css/elements/header/plum.css',
    'src/css/elements/header/strawberry.css',
];

$(document).ready(function () {

    $('.site-redirect-elements').click(function() {
        const redirectKey = $(this).data('redirect-key');
        if(redirectKey !== 'active'){
            window.location.replace(redirectKey);
        }
    });

    let header_index = 0;

    switch (main_url) {
        case 'apple' :
            header_index = 0;
            break;
        case 'pear' :
            header_index = 1;
            break;
        case 'home' :
        case 'stonefruit' :
            header_index = 2;
            break;
        case 'strawberry' :
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
