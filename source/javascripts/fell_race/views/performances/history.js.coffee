class FellRace.Views.HistoryRow extends Backbone.Marionette.ItemView
  template: "performances/history_row"
  tagName: "tr"

  bindings:
    ":el":
      attributes: [
        observe: "cat"
        name: "class"
        onGet: (cat) =>
          "female" if cat?.match /[lfw]/i
      ]

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
      observe: "time"
      onGet: "time"

    "span.instance": "instance_name"

  time: (seconds) =>
    _fellrace.secondsToString seconds

  initialize: ->
    @$el.on "mouseenter", =>
      @model.trigger "hover"
    @$el.on "mouseleave", =>
      @model.trigger "unhover"
    @model.on "hover", @highlight
    @model.on "unhover", @unhighlight

  highlight: =>
    @$el.addClass "hover"

  unhighlight: =>
    @$el.removeClass "hover"

  onRender: =>
    @stickit()

  compUrl: (id) =>
    "/runners/#{id}/"

class FellRace.Views.HistoryTable extends Backbone.Marionette.CompositeView
  template: "performances/history_table"
  itemView: FellRace.Views.HistoryRow
  itemViewContainer: "tbody"
