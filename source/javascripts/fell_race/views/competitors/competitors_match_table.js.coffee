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
