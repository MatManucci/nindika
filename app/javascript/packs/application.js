// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import 'controllers'

Rails.start()

document.addEventListener('DOMContentLoaded', () => {
  halfmoon.onDOMContentLoaded();
  document.getElementById('sidebar-overlay').addEventListener('click', () => halfmoon.toggleSidebar())
  document.getElementById('sidebar-toggle').addEventListener('click', () => halfmoon.toggleSidebar())
})
