export var Channels = { run: function() {

  $('.ui.search.dropown').dropdown({
    allowAdditions: true
  });

  $('a#tag-channel').click(function(e) {
    e.preventDefault();

    $('.ui.modal#tag-channel')
      .modal()
      .modal('show');
  })

}}
