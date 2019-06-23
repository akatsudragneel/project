$(function(){
  $(".user-approved").change(function(){       // Ajax for changing approval status for a user
  var approval = $(this).is(':checked');
  var url = $(this).attr('data-url');
  if(this.checked){
    alert("checked");
    $.ajax({
      url: url,
      type: 'PATCH',
      data: {"approved":approval}
    });
  }
  else{
    alert("unchecked");
    $.ajax({
      url: url,
      type: 'PATCH',
      data: {"approved":approval}
    });
  }
  });
});