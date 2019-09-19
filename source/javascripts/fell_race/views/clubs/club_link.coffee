class FellRace.Views.ClubLink extends Backbone.Marionette.ItemView
  template: 'clubs/link'

  bindings:
    ".name":
      observe: "name"
      attributes: [
        {
          name: "href"
          observe: "id"
          onGet: (val) ->
            "/clubs/#{val}"
        }
      ]

  onRender: =>
    @stickit()
