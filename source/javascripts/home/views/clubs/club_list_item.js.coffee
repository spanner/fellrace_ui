class Home.Views.ClubListItem extends Backbone.Marionette.ItemView
  template: 'clubs/list_item'
  className: "club"
  tagName: "li"

  bindings:
    ".name":
      observe: "name"
      attributes: [
        {
          name: "href"
          observe: "id"
          onGet: "getUrl"
        }
      ]

  getUrl: (id) =>
    "/club/#{id}"
