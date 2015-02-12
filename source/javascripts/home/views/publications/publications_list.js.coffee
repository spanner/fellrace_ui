class Home.Views.PublicationsList extends Backbone.Marionette.CollectionView
  itemView: Home.Views.Publication

  initialize: () ->
    @collection = new Home.Collections.Publications()
    @collection.fetch()
