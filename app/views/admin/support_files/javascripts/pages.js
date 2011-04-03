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

  var $pages = $('#pages ol');
  $pages.sortable({
    handle: 'a.sort',
    placeholder: 'placeholder item',
    opacity: 0.8,
    stop: Magnetism.reorder,
    axis: 'y'
  });
  $pages.disableSelection();

  var $page_publish = $('#page_publish');
  $page_publish.click(function(){
    var $input = $(this);
    var $date_select = $('#publish').find('select');

    if($input.is(':checked'))
    {
      $date_select.parent().show();
      $date_select.removeAttr('disabled');
    }
    else
    {
      $date_select.parent().hide();
      $date_select.attr('disabled',true);
    }
  });

  $page_publish.triggerHandler('click');

  $('#pages ol.ui-sortable').live('restripe',function(){
    var $div = $(this).find('li div.item');
    $div.removeClass('alt');
    $div.each(function(i, div){
      if( i%2 != 0 )
        $(div).addClass('alt');
    });
  });
});
