class FellRace.Views.Club extends Backbone.Marionette.ItemView
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
    @_competitors = new FellRace.Collections.Competitors()
    @_competitors.url = "#{@model.url()}/competitors"
    @_competitors.fetch()
    @_competitors_table = new FellRace.Views.CompetitorsList
      collection: @_competitors
      el: @$el.find ".competitors"
    @stickit()
