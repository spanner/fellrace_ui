class FellRace.Views.FutureListedInstance extends FellRace.View
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

  onRender: () =>
    @stickit()

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date

  time: (time) =>
    "at #{time}" if time

class FellRace.Views.PastListedInstance extends FellRace.View
  template: 'instances/past_list_item'
  tagName: "li"
  className: "instance"

  bindings:
    ":el":
      observe: ["has_results","summary"]
      onGet: (vals) -> vals[0] or vals[1]
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
    "span.splits":
      observe: "has_splits"
      visible: true

  onRender: () =>
    @stickit()

  summarise: (value, options) =>
    if !value?
      ""
    else
      "#{value} runners"


class FellRace.Views.FutureInstancesList extends FellRace.CollectionView
  itemView: FellRace.Views.FutureListedInstance

class FellRace.Views.PastInstancesList extends FellRace.CollectionView
  itemView: FellRace.Views.PastListedInstance
