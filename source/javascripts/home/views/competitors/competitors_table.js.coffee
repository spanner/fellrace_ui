class Home.Views.CompetitorsTable extends Backbone.Marionette.CollectionView
  itemView: Home.Views.CompetitorRow

  onRender: =>
    Home.setTitle "Runners"
