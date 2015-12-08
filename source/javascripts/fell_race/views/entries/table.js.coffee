class FellRace.Views.EntryRow extends Backbone.Marionette.ItemView
  template: "entries/row"
  className: "entry"
  tagName: "tr"

  bindings:
    ":el":
      observe: "unmatched"
      visible: "untrue"
      visibleFn: "visibleWithSlide"
    "a.name":
      attributes: [
        {
          observe: "competitor_id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "span.fore":
      observe: "forename"
    "span.sur":
      observe: "surname"
    "td.club": "club_name"
    "td.cat": "category"

  onRender: =>
    @stickit()

  competitorUrl: (id) -> "/runners/#{id}"

  clubUrl: (id) -> "/clubs/#{id}" if id

  rowClass: (value) =>
    cssclass = "entry"
    cssclass << " postal" if value
    cssclass

  untrue: (value) =>
    not value

  visibleWithSlide: ($el, isVisible, options) =>
    if isVisible
      $el.slideDown('fast')
    else
      $el.slideUp('fast')


class FellRace.Views.EntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.EntryRow
  template: "entries/table"
  itemViewContainer: "tbody"

  bindings:
    "input": "term"

  initialize: ->
    @model = new Backbone.Model

  onRender: =>
    @stickit()
    @model.on "change:term", (model, term) =>
      if term
        @collection.each (model) ->
          model.set unmatched: model.unmatches(term)
      else
        @clearMatches()

  clearMatches: =>
    @collection.each (model) -> model.unset "unmatched"

  onBeforeDestroy: =>
    @clearMatches()
