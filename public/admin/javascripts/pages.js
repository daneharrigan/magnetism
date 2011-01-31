jQuery(function($){
  $('#edit-permalink').click(function(e){
    $(this.parentNode).toggleClass('edit');
    e.preventDefault();
  });

  $('#page_slug').keyup(function(){
    this.value = this.value.replace(/[^A-z0-9\-\_]+/,'');
    $('#permalink-slug').text(this.value);
  });
});
