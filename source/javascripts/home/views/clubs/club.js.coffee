class Home.Views.Club extends Backbone.Marionette.ItemView
  template: 'clubs/show'
  className: "club"

  bindings:
    ".name": "name"
    ".website":
      observe: "url"
      visible: true
      attributes: [
        {
          observe: "url"
          name: "href"
        }
      ]

  onRender: =>
    @_competitors = new Home.Collections.Competitors()
    @_competitors.url = "#{@model.url()}/competitors"
    @_competitors.fetch()
    @_competitors_table = new Home.Views.CompetitorsTable
      collection: @_competitors
      el: @$el.find ".competitors"
    @stickit()
    Home.setTitle @model.get "name"
