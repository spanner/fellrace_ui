class FellRace.Views.CompetitorListItem extends FellRace.View
  template: 'competitors/list_item'
  className: "competitor"

  bindings:
    ".name": 
      observe: ["forename", "surname"]
      onGet: "name"
      attributes: [
        name: "href"
        observe: "id"
        onGet: (val) ->
          "/runners/#{val}"
      ]

  onRender: =>
    @stickit()

  name: (values) =>
    "#{values[0]} #{values[1]}"


class FellRace.Views.CompetitorsList extends FellRace.CollectionView
  itemView: FellRace.Views.CompetitorListItem
