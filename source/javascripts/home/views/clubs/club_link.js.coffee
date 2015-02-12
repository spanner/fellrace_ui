class Home.Views.ClubLink extends Backbone.Marionette.ItemView
  template: 'clubs/link'

  bindings:
    ".name":
      observe: "name"
      attributes: [
        {
          name: "href"
          observe: "id"
          onGet: (val) ->
            "/club/#{val}"
        }
      ]

  onRender: =>
    @stickit()
