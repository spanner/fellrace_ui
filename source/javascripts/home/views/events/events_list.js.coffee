class Home.Views.EventsList extends Backbone.Marionette.CollectionView
  itemView: Home.Views.Event
  tagName: "ul"
  el: ".events"
