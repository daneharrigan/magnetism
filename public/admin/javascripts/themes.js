jQuery(function($){
	$('#side-bar a').unbind('ajax:success'); // NOTE DH: hmm... i'd like to rethink ajax
	$('#side-bar a').bind('ajax:success',function(el, html, status){
		var $tab = $('' +
			'<li>' +
				'<a href="#" class="tab">' + $(this).text() + '</a>' +
			'</li>');
		$('#tabs').append($tab);
	});
});