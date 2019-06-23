$(function(){
  $(".pagination a").click(function(){							// To restrict number of posts per page
    $.getScript(this.href);
    return false;
  });
});