'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/site.webmanifest": "75d261f3a92a8e9743cca40a3ca49e6f",
"icons/favicon-96x96.png": "fb4b04e7ee08e40e6a2ee57796a944cd",
"icons/web-app-manifest-512x512.png": "526f243c8530a94252ef7d819f42a0e5",
"icons/web-app-manifest-192x192.png": "06e61fbfacb452bb2496f51ccd984b82",
"icons/favicon.svg": "c497f21b400bf13265ba94a91508eccd",
"icons/logo_only_light_thin.svg": "1577aa320bbf458f32e5c1fe1c69e988",
"icons/apple-touch-icon.png": "aec75c73282404ee39f0c981f7180877",
"icons/favicon.ico": "d8474ad7f1e58cf8c524260011df00cb",
"manifest.json": "0bccf60aa018c5a7f82ce3188a5bec4f",
"index.html": "e189385acab40e74d4ebc531e60e99f5",
"/": "e189385acab40e74d4ebc531e60e99f5",
"UnityLibrary/index.html": "2dcf7b62398b723071340552f4cfe78c",
"UnityLibrary/Build/UnityLibrary.loader.js": "7646ff0c11c86f9d9f585b6064dbbe3f",
"UnityLibrary/Build/UnityLibrary.framework.js": "a46b50dffda5696aa1181ee083ffd102",
"UnityLibrary/Build/UnityLibrary.data": "b623e0772e48ca8b2b77936bcf90cde4",
"UnityLibrary/Build/UnityLibrary.wasm": "569fbdadea90d4b421512c21707835e3",
"UnityLibrary/StreamingAssets/aa/settings.json": "9151a9cb8895054739dbb3a27c8f9ebb",
"UnityLibrary/StreamingAssets/aa/AddressablesLink/link.xml": "0ceb7eed140f9eaade4f9b946800f6fd",
"UnityLibrary/StreamingAssets/aa/catalog.bin": "fc247fbfff7270f3f3e56267d2a85567",
"UnityLibrary/StreamingAssets/aa/catalog.hash": "b721288e10ad95f535b3c6f7aa954a2b",
"UnityLibrary/TemplateData/unity-logo-title-footer.png": "1ecf1ff2683fbcd4e4525adb1d2cd7a8",
"UnityLibrary/TemplateData/progress-bar-full-light.png": "9524d4bf7c6e05b2aa33d1a330491b24",
"UnityLibrary/TemplateData/style.css": "7f1e0e50db2b6a8c5e8cea29a085c3d6",
"UnityLibrary/TemplateData/progress-bar-empty-dark.png": "781ae0583f8c2398925ecedfa04b62df",
"UnityLibrary/TemplateData/webmemd-icon.png": "e409a6f1c955c2babb36cd2153d418b5",
"UnityLibrary/TemplateData/progress-bar-full-dark.png": "99949a10dbeffcdf39821336aa11b3e0",
"UnityLibrary/TemplateData/unity-logo-light.png": "daf8545f18a102b4fa8f693681c2ffe0",
"UnityLibrary/TemplateData/favicon.ico": "f04ae07ad1b634a4152d2c8175134c56",
"UnityLibrary/TemplateData/progress-bar-empty-light.png": "4412cb4b67a2ae33b3e99cccf8da54c9",
"UnityLibrary/TemplateData/unity-logo-dark.png": "5f00fa907e7c80061485fc64b62ca192",
"UnityLibrary/TemplateData/MemoryProfiler.png": "90178b1c01bd4c66a21b9f2866091783",
"UnityLibrary/TemplateData/fullscreen-button.png": "489a5a9723567d8368c9810cde3dc098",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "eff851423f347ff2eb1585eddb803b03",
"assets/assets/images/team/krzysztof.jpg": "dcb981e9095cd81ae48247f4f3536ab3",
"assets/assets/images/team/mikolaj.jpg": "43bdff0d79345e0fda50bd234811d733",
"assets/assets/images/team/patryk.jpeg": "f6991868e0ee3e4c23040a070c8a81c7",
"assets/assets/images/team/martyna.jpg": "2ad2782c102b3bba75362ef8c443e17e",
"assets/assets/images/logo/logo_dark.svg": "d4eddac2254e139b10117bb087c71252",
"assets/assets/images/logo/logo_only_light.svg": "7ae68414f9bdccbf55521067d25e6085",
"assets/assets/images/logo/logo_light.svg": "5afe08af5b7e66660c0d3206023e40cd",
"assets/assets/images/logo/logo_only_light_thin.svg": "1577aa320bbf458f32e5c1fe1c69e988",
"assets/assets/images/logo/logo_light_thin.svg": "439be31138768bdc99f8b2a2bf1aae35",
"assets/assets/images/logo/logo_dark_thin.svg": "75205bbeb63469d4522e0e66e4be862a",
"assets/assets/images/logo/logo_only_dark_thin.svg": "5772bb546fbe17940164d2d493d699c7",
"assets/assets/images/logo/logo_only_dark.svg": "aa317b3debdd0f8704e6e01b11a77d97",
"assets/fonts/PixelatedEleganceRegular-ovyAA.ttf": "ca442f278627793c0e3879830bf62b03",
"assets/fonts/MaterialIcons-Regular.otf": "2f36b45e068e6c5300d103838400aa14",
"assets/NOTICES": "3208ae3c474c917448962fa0b12bc71d",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "9bafa21399d705b2e20f36fc1f07eddd",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "b7a225eb557dd600e4834771a6b0d16a",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b7f04b3179e31a51d0d657fd63acf820",
"assets/FontManifest.json": "fe3a3486e07ce75abb8b202a0c280dfc",
"assets/AssetManifest.bin": "a049afccc1e5a56dd6019b41d96609df",
"assets/AssetManifest.json": "1f8161e309c912ec17d54b20e5e176f5",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"flutter_bootstrap.js": "cccc871ac3c69e2b0bb6c45ae7e990ba",
"version.json": "ba62d3b010e02570fe95d3a8b6768e95",
"main.dart.js": "a943cab2fa573892c843071d02c64d43"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
