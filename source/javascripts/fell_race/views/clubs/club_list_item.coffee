class FellRace.Views.ClubListItem extends FellRace.View
  template: 'clubs/list_item'
  className: "club"
  tagName: "li"

  bindings:
    "a.name":
      observe: "name"
      attributes: [
        {
          name: "href"
          observe: "id"
          onGet: "getUrl"
        }
      ]

  getUrl: (id) =>
    "/clubs/#{id}"

  onRender: =>
    @stickit()
