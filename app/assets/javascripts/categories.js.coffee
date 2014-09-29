# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  sub_categories = $('#sub_category_id').html()
  $('#category_id').change ->
    category = $('#category_id :selected').text()
    escaped_category = category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(sub_categories).filter("optgroup[label='#{escaped_category}']").html()
    if options
      $('#sub_category_id').html(options)
    else
      $('#sub_category_id').empty()
