var Magnetism = {
  hideFlash: function(){
    setTimeout(function(){
      $('div.notice, div.failure, div.success').animate({ height: 0, opacity: 0 }, 500, function(){ $(this).remove() });
    }, 5000);
  },
  reorder: function(){
    var $ol = $(this),
        params = $ol.sortable('serialize', { key: 'position[]' }),
        $form = $ol.parents('form');
        params += '&' + $form.serialize();
    $.ajax({ url: $form.attr('action'), data: params, type: 'put' });
    var $li = $ol.parents('form').find('li');
    $form.find('ol.ui-sortable').trigger('restripe');
  }
};

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

  $('a.delete').live('click',function(e){
    var data = { authenticity_token: $('meta[name=csrf-token]').attr('content'), _method: 'delete' };
    $.post(this.href, data, false, 'script');
    e.preventDefault();
  });
});

jQuery(window).load(function(){ Magnetism.hideFlash() });
