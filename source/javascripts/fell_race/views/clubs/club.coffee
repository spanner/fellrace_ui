class FellRace.Views.Club extends FellRace.View
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
    competitors = @model.competitors
    @_competitors_table = new FellRace.Views.CompetitorsList
      collection: competitors
      el: @$el.find ".competitors"
    @stickit()
