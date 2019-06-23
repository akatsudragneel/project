$(function() {
  $('[data-js-hide-link]').click(function(event){
    console.log('You clicked the Hide link');
    debugger
    $(this).parents('li').fadeOut(2000);
    event.preventDefault(); 
  });
});