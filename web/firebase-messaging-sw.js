// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/11.10.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.10.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyBrBrrP8RmHbdj0CA9aXhonShhB10k0ryo",
  authDomain: "graduationproject-3d3b0.firebaseapp.com",
  projectId: "graduationproject-3d3b0",
  storageBucket: "graduationproject-3d3b0.firebasestorage.app",
  messagingSenderId: "425903761784",
  appId: "1:425903761784:web:ce5370b117d9b6a78f808d"
});

const messaging = firebase.messaging();


messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const title = payload.notification?.title || 'Notification';
  const options = {
    body: payload.notification?.body,

  };
  self.registration.showNotification(title, options);
});
