// ==UserScript==
// @name         (Alt + Shift + S) Gitlab skip todos merged
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://gitlab.com/dashboard/todos
// @icon         https://www.google.com/s2/favicons?sz=64&domain=gitlab.com
// @grant        none
// ==/UserScript==

function getDeleteButton(todo) {
  return todo.querySelector('a[data-method="delete"]');
}

function getTodoState(todo) {
  const badge = todo.querySelector(".todo-target-state .badge");
  if (!badge) {
    return null;
  }
  return badge.innerHTML.toLowerCase();
}

(function () {
  "use strict";
  document.addEventListener("keydown", function (event) {
    const isShortcutPressed =
      event.altKey && event.shiftKey && event.key === "S";
    if (!isShortcutPressed) {
      return;
    }

    let todos = Array.from(document.querySelectorAll("li.todo"));
    todos = todos.filter((todo) =>
      ["merged", "closed"].includes(getTodoState(todo))
    );

    todos.forEach((todo) => {
      const button = getDeleteButton(todo);
      const isHidden =
        Array.from(button.classList).filter((c) => c === "hidden").length > 0;
      if (isHidden) {
        return;
      }

      button.click();
    });
  });
})();
