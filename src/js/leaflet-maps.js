const tileUrl = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';
const tileAttr = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="https://carto.com/">CARTO</a>';
const markerIcon = L.divIcon({
    className: 'custom-marker',
    html: '<div style="background:#3b82f6;width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;box-shadow:0 2px 8px rgba(0,0,0,0.3);border:3px solid #fff"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></div>',
    iconSize: [36, 36],
    iconAnchor: [18, 36],
    popupAnchor: [0, -36]
});

function initMap(elementId, lat, lng, zoom, popupHtml) {
    const el = document.getElementById(elementId);
    if (!el) return null;
    const map = L.map(elementId).setView([lat, lng], zoom);
    L.tileLayer(tileUrl, { attribution: tileAttr, maxZoom: 19 }).addTo(map);
    L.marker([lat, lng], { icon: markerIcon }).addTo(map).bindPopup(popupHtml);
    return map;
}

// Kontakt
initMap('map-kontakt', 50.5907, 7.1204, 15,
    '<strong>Obstbau Rech</strong><br>Werthovener Str. 18<br>53501 Niederich');

// Wochenmarkt
initMap('map-godesberg', 50.6856, 7.1561, 16,
    '<strong>Wochenmarkt Bad Godesberg</strong><br>Moltkeplatz, 53173 Bonn');

initMap('map-riehl', 50.9648, 6.9746, 16,
    '<strong>Wochenmarkt Köln-Riehl</strong>');

initMap('map-niehl', 50.9797, 6.9636, 16,
    '<strong>Wochenmarkt Köln-Niehl</strong><br>Waldfriedstraße, 50735 Köln');
