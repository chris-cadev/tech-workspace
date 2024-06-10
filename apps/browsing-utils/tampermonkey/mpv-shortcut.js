// ==UserScript==
// @name         Open Link in New Tab on Ctrl+Shift+Click
// @version      1
// @description  Open links in new tabs when Ctrl+Shift+Clicking on them
// @match        http://*/*
// @match        https://*/*
// @grant        none
// ==/UserScript==

function searchFirstAnchorTagUp(el) {
  // check if the element itself is an anchor tag
  if (el.tagName === "A") {
    return el;
  }

  // check if any of the parent elements are anchor tags
  var parentEl = el.parentElement;
  while (parentEl) {
    if (parentEl.tagName === "A") {
      return parentEl;
    }
    parentEl = parentEl.parentElement;
  }

  // check if any of the child elements are anchor tags
  var childEls = el.getElementsByTagName("a");
  if (childEls.length > 0) {
    return childEls[0];
  }

  // no anchor tag found
  return null;
}

function playOnMPV(play_url) {
  if (!play_url) {
    console.info("no url found to play");
    return;
  }
  const url = `http://localhost:7531?play_url=${play_url}`;
  const w = window.open(url);
  const t = setTimeout(() => {
    w.close();
    clearTimeout(t);
  }, 100);
}

function getNeartestParent(parentSelector, childElement) {
  // TODO: search why this works, probably because of passing the variable or something like that
  return childElement;
}

(function () {
  "use strict";
  document.body.addEventListener("click", function (event) {
    if (event.ctrlKey && event.shiftKey) {
      event.preventDefault();
      // debugger;

      const ytVideo = getNeartestParent("ytd-video-renderer", event.srcElement);
      let el = searchFirstAnchorTagUp(ytVideo);
      if (!el || !el.href) {
        console.error("No href");
        return;
      }
      playOnMPV(el.href);
    }
  });
  document.addEventListener("keydown", function (event) {
    const isShortcutPressed =
      event.altKey && event.shiftKey && event.key === "O";
    if (!isShortcutPressed) {
      return;
    }
    event.preventDefault();
    const video = document.querySelector("video");
    if (video && !video.paused) {
      video.pause();
    }
    let { currentTime } = video;
    currentTime = Math.floor(currentTime);
    let play_url = window.location.href;
    let sign = "&";
    if (!play_url.includes("?")) {
      sign = "?";
    }
    play_url = `${play_url}${sign}t=${currentTime}`;
    playOnMPV(play_url);
  });
})();
