import { precacheAndRoute } from 'workbox-precaching';
import { registerRoute } from 'workbox-routing';
import { StaleWhileRevalidate } from 'workbox-strategies';

// Precache assets
precacheAndRoute(self.__WB_MANIFEST);

// Cache API requests
registerRoute(
  ({ url }) => url.origin === 'https://example.com', // Beispiel API
  new StaleWhileRevalidate()
);
