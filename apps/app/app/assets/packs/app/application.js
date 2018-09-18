/* eslint no-console:0 */

import Rails from 'rails-ujs';

Rails.start();

import 'javascripts/wingman/index'
import 'stylesheets/app/application'

$(function(){
	$('.form-control').on('focus blur', function (e){
    $(this).parents('.form-group').toggleClass('focused',
    	( e.type === 'focus' || this.value.length > 0 ));
	}).trigger('blur');

	$(window).on('load', function(){
	  $('body').removeClass('preload');
	});
});