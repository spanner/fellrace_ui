class FellRace.Views.PublicationsList extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.PublicationListItem
  itemViewContainer: ".publications"
  template: "publications/list"

  itemViewOptions: =>
    filter: @filter

  initialize: ({collection_filter:@filter}={}) ->
    @collection.comparator = (model) =>
      1
      # console.log @filter
      # console.log new Date(model.get("date"))
      # new Date(model.get("date")) * if @filter is "past" then -1 else 1
    @collection.sort()
    @render()

  onRender: =>
    if @filter
      @$el.find(".title").text @getTitle()

  getTitle: =>
    if @filter is "past"
      "Recent races"
    else
      "Upcoming races"
