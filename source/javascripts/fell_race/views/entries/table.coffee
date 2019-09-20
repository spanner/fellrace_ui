class FellRace.Views.EntryRow extends FellRace.View
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


class FellRace.Views.EntriesTable extends FellRace.CollectionView
  childView: FellRace.Views.EntryRow
  template: "entries/table"
  itemViewContainer: "tbody"

  onRender: =>
    @_filter = new FellRace.Views.CollectionFilter
      collection: @collection
      el: @$el.find('input')
    @_filter.render()

