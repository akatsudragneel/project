// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require_tree .
$(document).ready(function() {

  $('.fa').click(function(){                              // like button color change
    $(this).toggleClass('blue');
  });

  $("#users-table").dataTable({                           // No of items per page in data table is altered
    "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
    "iDisplayLength": 5,
  });

  bJQueryUI: true     
  
  $("#unapproved_status").html('Approved');

  var $item = $('.carousel .item'); 
  var $wHeight = $(window).height();
  $item.eq(0).addClass('active');
  $item.height($wHeight); 
  $item.addClass('full-screen');
  
  $('.carousel img').each(function() {
    var $src = $(this).attr('src');
    var $color = $(this).attr('data-color');
    $(this).parent().css({
      'background-image' : 'url(' + $src + ')',
      'background-color' : $color
    });
    $(this).remove();
  });

  $(window).on('resize', function (){
    $wHeight = $(window).height();
    $item.height($wHeight);
  });

  $('.carousel').carousel({
    interval: 6000,
    pause: "false"  
  });

  $('#EditModal').on('hidden', function () {            // On the exit of Modal, reload is performed
    document.location.reload();
  })

  onclick="javascript:window.location.reload()"
});
