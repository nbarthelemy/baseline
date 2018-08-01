/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'bootstrap/dist/js/bootstrap';
import 'stylesheets/wingman/index'

import SmoothScroll from 'smooth-scroll';
import scrollMonitor from 'scrollmonitor';
import SmartWizard from 'smartwizard';

function importAll(r) { return r.keys().map(r); }

importAll(require.context('javascripts/wingman/mrare', false, /\.js$/));

const images = importAll(require.context('images/wingman', true, /\.(png|jpe?g|svg)$/));