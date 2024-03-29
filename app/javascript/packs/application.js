// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "core-js/stable"
import "regenerator-runtime/runtime"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Internal Imports
import { initSender } from "../custom/message";
import { initInfiniteScroll } from "../components/init_infinite_scroll";

// Preload Functions
document.addEventListener("turbolinks:load", () => {
  initSender();
  initInfiniteScroll();
})