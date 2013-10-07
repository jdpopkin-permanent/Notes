Notes.Views.ArtistForm = Backbone.View.extend({
  initialize: function() {

  },

  events: {
    "submit form.artist-form": "submit"
  },

  submit: function(event) {
    // TODO: determine if this needs to do anything non-default
    var that = this;
    that.$el.addClass("hidden");
  },

  render: function() {
    var that = this;
    renderedContent = JST["artists/form"]( {
      url: Notes.rootUrl + "/artists/",
      method: "POST",
      artist: { name: "" }
    });

    that.$el.html(renderedContent);
    return that;
  }
})