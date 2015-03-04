class FellRace.Views.CompetitorMatchRow extends Backbone.Marionette.ItemView
  template: 'competitors/match_row'
  className: "competitor"
  tagName: "tr"

  events:
    "click a.merge": "merge"

  bindings:
    "a.name":
      observe: ["forename","surname"]
      onGet: "name"
      attributes: [
        {
          observe: "id"
          name: "href"
          onGet: (val) =>
            "/runners/#{val}"
        }
      ]
  clubBindings:
    "span.club": "name"

  initialize: ->
    @_club = new FellRace.Models.Club @model.get("club")

  onRender: =>
    @stickit()
    
    @stickit(@_club, @clubBindings)

  name: (vals) =>
    "#{vals[0]} #{vals[1]}"

  merge: =>
    $.ajax
      url: "#{@model.url()}/request_merge"
      type: "POST"
      dataType: "text"
      data:
        competitor:
          merge_to_id: @model.get("id")
      success: =>
        @model.collection.remove(@model)
        $.notify "success", "Merge request sent to admin"

class FellRace.Views.CompetitorsMatchTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.CompetitorMatchRow
  itemViewOptions: () =>
    {competitor:  @model}
  itemViewContainer: '.matches'
  template: "competitors/match_table"

  onRender: =>
    if @collection.length > 0
      @$el.show()
    else
      @$el.hide()
    @collection.on "add remove", () =>
      if @collection.length > 0
        @$el.show()
      else
        @$el.hide()
