$(document).ready(function() {
  $('form').submit(function(e) {
    e.preventDefault();

    var url = $(this).attr('action');

    $("#results").html("Loading...");

    $.ajax(url, {data: $(this).serialize(), success: function(response) {
      $("#results").html(response);
    }, error: function(response) {
      $("#results").html("We're sorry, but something went wrong.");
    }});
  });
});
