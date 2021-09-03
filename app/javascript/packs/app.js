$(".btn-click").on("click", function() {
  url = $(this).attr("data-url")
  window.location.href = (url);
});
