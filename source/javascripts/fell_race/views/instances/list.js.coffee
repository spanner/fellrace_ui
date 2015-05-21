class FellRace.Views.FutureListedInstance extends Backbone.Marionette.ItemView
  template: 'instances/future_list_item'
  tagName: "li"
  className: "instance"

  bindings:
    "a.name":
      observe: "name"
      attributes: [
        {
          name: "href"
          observe: ["race_slug", "name"]
          onGet: (vals) =>
            "/races/#{vals[0]}/#{vals[1]}"
        }
      ]
    "span.date":
      observe: "date"
      onGet: "date"
    "span.time":
      observe: "time"
      onGet: "time"
    "span.total": 
      observe: ["online_entry","entries_count","entry_limit"]
      onGet: "summarise"

  onRender: () =>
    @stickit()

  summarise: ([online_entry,entries_count,entry_limit]=[]) ->
    string = ""
    if online_entry
      string = entries_count
      if entry_limit and entry_limit > 0
        string = "#{string} / #{entry_limit}"
      string = "#{string} entries"

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date

  time: (time) =>
    "at #{time}" if time

class FellRace.Views.PastListedInstance extends Backbone.Marionette.ItemView
  template: 'instances/past_list_item'
  tagName: "li"
  className: "instance"

  bindings:
    ":el":
      observe: "has_results"
      visible: true
    "a.name":
      observe: "name"
      attributes: [
        name: "href"
        observe: ["race_slug", "name"]
        onGet: (vals) =>
          "/races/#{vals[0]}/#{vals[1]}"
      ,
        name: "class"
        observe: "fetching"
        onGet: (fetching) ->
          "loading" if fetching
      ]
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


class FellRace.Views.FutureInstancesList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.FutureListedInstance

class FellRace.Views.PastInstancesList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.PastListedInstance
