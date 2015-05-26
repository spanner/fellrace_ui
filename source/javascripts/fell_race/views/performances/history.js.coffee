class FellRace.Views.HistoryRow extends Backbone.Marionette.ItemView
  template: "performances/history_row"
  tagName: "tr"

  bindings:
    ":el":
      attributes: [
        observe: ["cat_name","c_pos"]
        name: "class"
        onGet: ([cat,c_pos]=[]) =>
          klass = ""
          klass += "female" if cat?.match /[lfw]/i
          klass += " additional" unless c_pos
          klass
      ]

    "span.pos": "p_pos"
    "span.race_position": "position"

    "span.comp_pos": "c_pos"

    "span.club": "club_name"
    "span.cat": "cat_name"

    "span.forename": "fore"
    "span.middlename": "middle"
    "span.surname": "sur"

    "a.name":
      attributes: [
        name: "href"
        observe: "competitor_id"
        onGet: "compUrl"
      ]

    "span.time":
      observe: "elapsed_time"
      onGet: "time"

    "span.instance": "instance_name"

  time: (seconds) =>
    seconds?.toSimplestTime()

  onRender: =>
    @stickit()

  compUrl: (id) =>
    "/runners/#{id}/"


class FellRace.Views.NoHistory extends Backbone.Marionette.ItemView
  template: "performances/history_loading"
  tagName: "tr"

class FellRace.Views.HistoryTable extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.HistoryRow
  emptyView: FellRace.Views.NoHistory
