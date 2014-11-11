// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .
//= require chardinjs
//= require bootstrap
//= require bootstrap-datepicker
//= require jquery-ui
//= require autocomplete-rails
//= require underscore
//= require json2
//= require select2
//= require filterrific/filterrific-jquery
var typewatch = (function () {
    var timer = 0;
    return function (ms, callback) {
        clearTimeout(timer);
        timer = setTimeout(callback, ms);
    }
})();
 
$(document).ready(function () {
    $('.watched').on('input', function () {
        var elem = $(this);
        typewatch(500, function () {
            elem.closest("form").submit();
        });
    });
 
    $('.watched2').change(function () {
        var elem = $(this);
        typewatch(500, function () {
            elem.closest("form").submit();
        });
    });
});



