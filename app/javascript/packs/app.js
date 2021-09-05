import $ from 'jquery'
import 'select2'
import 'select2/dist/css/select2.css'

$(function() {
  $('.select2').select2({
    width: '100%',
  });

  $(".btn-click").on("click", function() {
    url = $(this).attr("data-url")
    window.location.href = (url);
  });
});
