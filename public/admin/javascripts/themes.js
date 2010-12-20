var Template = {
  load: function(link, html){
    var link_id = Template.link_id(link),
        title = $(link).text();

    var attributes = { href: link.href, 'class': 'tab' };
    var $tab = $('<li />', { 'data-template-id': link_id })
      .append( $('<a />', attributes).text(title) );

    $('#tabs').append($tab);
    $('#template-content').append(html);

    var $fields = $('ol.fields');
    $fields.sortable({
      handle: 'a.sort',
      placeholder: 'placeholder',
      stop: Template.sort_fields
    });
    $fields.disableSelection();
  },
  focus: function(link){
    var link_id = Template.link_id(link);

    $('#tabs > li a, #template-content > li').removeClass('active');
    $('#tabs > li[data-template-id=' + link_id + '] a,' +
      '#template-content > li[data-template-id=' + link_id + ']').addClass('active');
  },
  is_opened: function(link){
    var link_id = Template.link_id(link);
    return $('#tabs').find('li[data-template-id='+link_id+']').size();
  },
  link_id: function(link){
    return link.href.match(/(\d+)+(\/edit)$/)[1];
  },
  add_field: function(html){
    $('#template-content > li.active div.form-content ol.fields') .append(html);
  },
  remove_field: function(link){
    $(link).parents('li:first').remove();
  },
  update_field: function(selector, html){
    $(selector).replaceWith(html);
  },
  sort_fields: function(){
    var $ol = $(this),
        params = $ol.sortable('serialize', { key: 'position[]' }),
        $form = $ol.parents('form');
    $.ajax({ url: $form.attr('action'), data: params, type: 'put' });
  }
};

jQuery(function($){
  $sidebar = $('#side-bar > ul a');

  $sidebar.bind('ajax:success',function(el, html, status){
    Template.load(this, html);
    Template.focus(this);
  });

  $sidebar.live('click',function(e){
    if(!Template.is_opened(this))
      $(this).callRemote();
    else
      Template.focus(this);

    e.preventDefault();
  });

  $('#tabs a').live('click',function(e){
    Template.focus(this);
    e.preventDefault();
  });

  $('li.active ol.toggle-content a').live('click', function(e){
    var $li = $('#template-content > li.active');
    // activate tab
    $li.find('ol.toggle-content a').removeClass('active');
    $(this).addClass('active');

    // display appropriate view
    var view = $(this).attr('data-view');
    $li.removeClass('form-active')
      .removeClass('code-active')
      .addClass(view + '-active');

    e.preventDefault();
  });

  $('#new_field').live('ajax:success', function(el, html, status){
    Template.add_field(html);
    $('#overlay').remove();
  });

  $('form[id^=edit_field]').live('ajax:success', function(el, html, status){
    var id = this.id.match(/\d+$/);
    Template.update_field('#field-'+id, html);
    $('#overlay').remove();
  });

  $('a[data-method=delete]').live('ajax:success', function(el, html, status){
    Template.remove_field(this);
  });
});
