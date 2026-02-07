const img_urls = [
    'src/img/obst/apfel/Hintergrund.jpg',
    'src/img/obst/birne/Hintergrund.jpg',
    'src/img/obst/steinobst/Hintergrund.jpg',
    'src/img/obst/erdbeere/Hintergrund.jpeg',
];

const header_index = Math.floor(Math.random() * 4);

$(document).ready(function(){
    $('body').css('background-image', 'url(' + img_urls[header_index] + ')');
});
