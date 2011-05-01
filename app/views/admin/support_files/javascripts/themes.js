var Template = {
  load: function(link, html){
    var link_id = Template.link_id(link),
        title = $(link).text();

    var attributes = { href: link.href, 'class': 'tab' };
    var $tab = $('<li />', { id: 'tab-'+link_id, 'data-template-id': link_id })
      .append( $('<a />', attributes).text(title) );
    $tab.append( $('<a />', { href: '#close', 'class': 'close', 'data-template-id': link_id }).text('Close') );

    $('#tabs').append($tab);
    $('#template-content').append(html);

    var $fields = $('ol.fields');
    $fields.sortable({
      handle: 'a.sort, ol.fields label',
      placeholder: 'placeholder',
      opacity: 0.8,
      stop: Magnetism.reorder,
      axis: 'y'
    });
    $fields.disableSelection();
  },
  focus: function(link){
    var link_id = Template.link_id(link);

    $('#tabs > li a, #template-content > li').removeClass('active');
    $('#tabs > li[data-template-id=' + link_id + '] a,' +
      '#template-content > li[data-template-id=' + link_id + ']').addClass('active');
  },
  close: function(link){
    var $link = $(link);
    var $tab = $link.parents('li:first'),
        link_id = $link.attr('data-template-id');
    var $sibling = $tab.next().size() ? $tab.next() : $tab.prev();

    $('li[data-template-id='+link_id+']').remove();

    if( !$('#tabs a.active').size() )
    {
      link = $sibling.find('a.tab')[0];
      if(link)
        Template.focus(link);
    }
  },
  is_opened: function(link){
    var link_id = Template.link_id(link);
    return $('#tabs').find('li[data-template-id='+link_id+']').size();
  },
  link_id: function(link){
    return link.href.match(/(\d+)+(\/edit)$/)[1];
  },
  add_field: function(html){
    $('#template-content > li.active div.form-content ol.fields').append(html);
  },
  remove_field: function(link){
    $(link).parents('li:first').remove();
  },
  update_field: function(selector, html){
    $(selector).replaceWith(html);
  }
};

/******************************************************************/

jQuery(function($){
  var $sidebar = $('aside a.open');

  $sidebar.live('ajax:success',function(el, html, status){
    Template.load(this, html);
    Template.focus(this);
  });

  $sidebar.live('click',function(e){
    if(Template.is_opened(this))
      Template.focus(this);
    else
      $(this).callRemote();

    e.preventDefault();
  });


  // template tabs
  $('#tabs a.tab').live('click',function(e){
    Template.focus(this);
    e.preventDefault();
  });

  $('#tabs a.close').live('click', function(e){
    Template.close(this);
    e.preventDefault();
  });

  // form/code view tabs
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

  $('#new_template').live('ajax:success', function(el, html, status){
    var value = $('#template_template_type_id').attr('value');
    var template_type_id = '#template-type-' + value;
    var $ul = $(template_type_id);
    $ul.append(html);
    $('#overlay').remove();

    var $link = $(template_type_id).find('a.open:last');
    $link.trigger('click');
  });

  $('#new_template_set').live('ajax:success', function(el, html, status){
    $('#template-sets').append(html);
    $('#overlay').remove();
  });

  $('li a[data-method=delete]').live('ajax:success', function(el, html, status){
    Template.remove_field(this);
  });

  $('div.code-content form').live('ajax:success', function(el, json, status){
    var class_name = 'notice';
    if(json.alert)
      class_name = 'alert';

    var message = json.alert ? json.alert : json.notice;
    $('body').prepend( $('<div />', { 'class': class_name}).text(message) );
    Magnetism.hideFlash();
  });
});
