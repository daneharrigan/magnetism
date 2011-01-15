jQuery(function($){
  $('#edit-permalink').click(function(e){
    $(this.parentNode).toggleClass('edit');
    e.preventDefault();
  });

  $('#page_slug').keyup(function(){
    $('#permalink span').text( $(this).val() )
  });
});
