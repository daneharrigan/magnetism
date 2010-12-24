jQuery(function($){
  var match_length = 0;
  $('a[href]').each(function(){
    if(window.location.toString().match(this.href) && this.href.length>match_length)
    {
      $('a.active').removeClass('active');
      $(this).addClass('active');
      match_length = this.href.length;
    }
  });

  $('a[data-remote=true][data-type=html]').live('ajax:success',
    function(el, html, status){ $('body').prepend(html) }
  );

  $(document).keyup(function(event){
    if(event.keyCode == 27)
      $('#overlay').remove();
  });

  $('#overlay a.cancel').live('click',function(e){
    $('#overlay').remove();
    e.preventDefault();
  });

  $('h2.toggle-sibling').live('click', function(){
    var $sibling = $(this).next();
    $sibling.is(':hidden') ? $sibling.show() : $sibling.hide();
  });

  $('body').delegate('*', 'click', function(){ $('div.selector ul').hide() });
});
