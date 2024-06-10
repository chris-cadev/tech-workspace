// ==UserScript==
// @name         Video Platform to MPV server.
// @namespace    http://localhost:7531/
// @version      1
// @description  Redirect from video platform urls to "http://localhost:7531/" with play_url argument and use the url from you as that query argument
// @match        https://*/*
// ==/UserScript==

(function () {
  "use strict";

  function hasPlayer() {
    return document.querySelector("video") !== null;
  }

  function redirectToURL(url) {
    window.location.replace(url);
  }

  function createPlayUrl() {
    const currentTime = Math.floor(document.querySelector("video").currentTime);
    let play_url = window.location.href;
    let sign = "&";
    if (!play_url.includes("?")) {
      sign = "?";
    }
    play_url = `${play_url}${sign}t=${currentTime}`;
    return play_url;
  }

  function checkPlayerAndRedirect() {
    const url = window.location.href;
    const allowedPlatforms = [
      "youtube",
      "facebook",
      "vimeo",
      "tiktok",
      "piped.kavin.rocks",
    ];

    const isVideoPlatform = allowedPlatforms.some((platform) =>
      url.includes(platform)
    );
    if (!hasPlayer()) {
      return;
    }
    if (!isVideoPlatform) {
      return;
    }
    const allowedToRedirect = ["watch", "shorts", "vimeo", "/video/"];
    const mustRedirect = allowedToRedirect.some((f) => url.includes(f));
    if (!mustRedirect) {
      return;
    }
    clearInterval(intervalId);
    const mpv_url = "http://localhost:7531/?play_url=" + createPlayUrl(url);
    redirectToURL(mpv_url);
  }

  const intervalId = setInterval(checkPlayerAndRedirect, 100);

  console.log("Script is running...");
})();
