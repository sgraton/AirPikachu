// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("bootstrap3/dist/js/bootstrap.min");

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
// jquery

import $ from 'jquery';

global.$ = $
global.jQuery = $

require('jquery-ui');
require("packs/jquery.raty.js.erb");
require("packs/geocomplete.js");

require("fullcalendar/dist/fullcalendar");
window.moment = require("moment/moment");

window.Noty = require("noty");
window.Dropzone = require("dropzone");

require("card/dist/card");

require("chartkick")
require("chart.js")