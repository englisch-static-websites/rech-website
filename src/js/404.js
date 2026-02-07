const img_urls = [
    'src/img/obst/apfel/Hintergrund.jpg',
    'src/img/obst/birne/Hintergrund.jpg',
    'src/img/obst/steinobst/Hintergrund.jpg',
];

const header_index = Math.floor(Math.random() * 3);

document.addEventListener('DOMContentLoaded', function () {
    document.body.style.backgroundImage = 'url(' + img_urls[header_index] + ')';
});
