// Nome do cache
const CACHE_NAME = 'my-site-cache-v1';

// Lista de arquivos a serem armazenados em cache
const urlsToCache = [
    '/',
    '/index.html',
    '/style.css',
    '/script.js',
    '/icon-192x192.png',
    '/icon-512x512.png',
];

// Instalação do Service Worker
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then((cache) => {
                console.log('Cache aberto e arquivos armazenados');
                return cache.addAll(urlsToCache);
            })
    );
});

// Ativação do Service Worker
self.addEventListener('activate', (event) => {
    const cacheWhitelist = [CACHE_NAME];
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheWhitelist.indexOf(cacheName) === -1) {
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
});

// Interceptação de requisições
self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request)
            .then((response) => {
                // Retorna o recurso do cache, se disponível
                return response || fetch(event.request);
            })
    );
});
