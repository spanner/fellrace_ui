class FellRace.Views.ListedInstance extends Backbone.Marionette.ItemView
  template: 'instances/list_item'
  tagName: "li"
  className: "instance"

  bindings:
    "a.name":
      attributes: [
        {
          name: "href"
          observe: ["race_slug", "name"]
          onGet: (vals) =>
            "/races/#{vals[0]}/#{vals[1]}"
        }
      ]
      observe: "name"
    "span.total": 
      observe: "performances_count"
      onGet: "summarise"

  onRender: () =>
    @stickit()

  summarise: (value, options) =>
    if !value?
      ""
    else
      "#{value} runners"

class FellRace.Views.InstancesList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.ListedInstance
