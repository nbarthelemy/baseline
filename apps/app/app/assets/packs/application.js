/* eslint no-console:0 */

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

Rails.start();
Turbolinks.start();

import 'javascripts/wingman/index'
import 'stylesheets/application'

$(function(){
	$('.form-control').on('focus blur', function (e){
    $(this).parents('.form-group').toggleClass('focused',
    	( e.type === 'focus' || this.value.length > 0 ));
	}).trigger('blur');

	$(window).on('load', function(){
	  $('body').removeClass('preload');
	});
});