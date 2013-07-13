$(document).ready(function() {
  $('form').submit(function(e) {
    e.preventDefault();

    var url = $(this).attr('action');

    $("#results").html("Loading...");

    $.ajax(url, {data: $(this).serialize(), success: function(response) {
      $("#results").html(response);
    }});
  });
});
