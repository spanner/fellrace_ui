class FellRace.Views.MatchRow extends FellRace.View
  template: 'competitors/match_row'
  className: "competitor"
  tagName: "tr"

  events:
    "click a.merge": "merge"

  bindings:
    "a.name":
      attributes: [
        observe: "id"
        name: "href"
        onGet: (val) ->
          "/runners/#{val}"
      ]

    "span.forename": "forename"
    "span.middlename": "middlename"
    "span.surname": "surname"
    "span.gender": "gender"

    "span.club": "club_name"

  onRender: =>
    @stickit()

  merge: =>
    $.ajax
      url: "#{@model.url()}/request_merge"
      type: "POST"
      dataType: "text"
      data:
        competitor:
          merge_to_id: @model.collection.competitor.id
      success: =>
        @model.collection.remove(@model)
        _fr.broadcast "success", "Merge request sent to admin"

class FellRace.Views.MatchTable extends FellRace.CollectionView
  childView: FellRace.Views.MatchRow
  itemViewContainer: 'tbody'
  template: "competitors/match_table"

  bindings:
    ":el":
      observe: "match_count"
      visible: (count) ->
        count > 0

  initialize: ->
    @stickit()
    @collection = new FellRace.Collections.Competitors([])
    @collection.competitor = @model
    @model.set match_count: 0
    $.getJSON "#{_fr.apiUrl()}/competitors/#{@model.id}/matches", (data) =>
      @collection.reset data
    @collection.on "add remove reset", =>
      @model.set match_count: @collection.length
