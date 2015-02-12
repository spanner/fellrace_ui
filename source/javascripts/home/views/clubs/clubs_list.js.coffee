class Home.Views.ClubsList extends Backbone.Marionette.CollectionView
  itemView: Home.Views.ClubListItem

  onRender: =>
    Home.setTitle "Clubs"
