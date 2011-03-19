jQuery(function($){
  $('#edit-permalink').click(function(e){
    $(this.parentNode).toggleClass('edit');
    e.preventDefault();
  });

  $('#page_slug').keyup(function(){
    this.value = this.value.replace(/[^A-z0-9\-\_]+/,'');
    $('#permalink-slug').text(this.value);
  });

  $('#page_blog_section').live('click', function(){
    var checked = $(this).is(':checked'),
        $template = $('#page_template_id'),
        $template_set_and_uri = $('#page_template_set_id, #page_uri_format');

    if(checked)
    {
      $template.parent().hide();
      $template.attr('disabled','disabled');

      $template_set_and_uri.removeAttr('disabled');
      $template_set_and_uri.parent().show();
    }
    else
    {
      $template_set_and_uri.parent().hide();
      $template_set_and_uri.attr('disabled', 'disabled');

      $template.removeAttr('disabled');
      $template.parent().show();
    }
  });

  $('a.delete').live('click',function(e){
      var data = { authenticity_token: $('meta[name=csrf-token]').attr('content'), _method: 'delete' };
      $.post(this.href, data, false, 'script');
      e.preventDefault();
    });
});
