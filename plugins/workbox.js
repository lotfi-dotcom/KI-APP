import { Workbox } from 'workbox-window';

if (process.client && 'serviceWorker' in navigator) {
  const wb = new Workbox('/service-worker.js');

  wb.register().then(() => {
    console.log('Service Worker registered');
  });
}
