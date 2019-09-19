class FellRace.Views.ClubLink extends FellRace.View
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
