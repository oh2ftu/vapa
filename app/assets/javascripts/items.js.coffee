# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->$('#item-select1').select2({
        placeholder: "Select parent",
        width: "element",
    });
jQuery ->$('#item-select2').select2();
jQuery ->$('#item-select3').select2();
jQuery ->$('#item-select4').select2(
 {
        placeholder: "Select items",
        width: "element",
        });
jQuery ->$('#item-select5').select2(
 {
        placeholder: "Select vendor",
	width: "element",
 	});
jQuery ->$('#item-select6').select2();

