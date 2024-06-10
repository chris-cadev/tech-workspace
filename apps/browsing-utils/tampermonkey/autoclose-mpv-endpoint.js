// ==UserScript==
// @name         close play-on-mpv after 300 milliseconds
// @description  closes the http://localhost:7531 to hit the endpoint correctly
// @namespace    http://localhost
// @version      1.0.1
// @author       chris-cadev
// @match        http://localhost:7531/*
// @grant        window.close
// ==/UserScript==

(function () {
  "use strict";

  if (window.location.port === "7531") {
    setTimeout(() => {
      window.close();
    }, 300);
  }
})();
