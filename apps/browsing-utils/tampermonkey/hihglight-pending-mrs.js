// ==UserScript==
// @name         Highlight Pending MRs
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  This userscript highlights merge requests (MRs) that are pending for approval or merge by reducing their opacity. It helps to quickly identify the MRs that require attention.
// @author       You
// @match        https://gitlab.com/liondesk/ld/-/merge_requests*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=gitlab.com
// @grant        none
// @require https://gist.github.com/raw/2625891/waitForKeyElements.js
// ==/UserScript==

waitForKeyElements('main.content', highlightPendingMRs);

function highlightPendingMRs() {
    'use strict';

    document.querySelectorAll('li.merge-request').forEach(mr => {
        if (mr.querySelector('li.text-success')) {
            mr.style.opacity = '0.3';
        }
    });
}
