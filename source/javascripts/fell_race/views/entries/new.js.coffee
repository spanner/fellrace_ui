class FellRace.Views.NewEntry extends Backbone.Marionette.ItemView
  template: 'entries/new'

  bindings:
    "a.create": "ready"

  initialize: ->
    @_competitor = _fellrace.getCurrentCompetitor()

  onRender: =>
    @stickit()
    console.log @_competitor
    @_competitor_view = new FellRace.Views.EntryCompetitor
      model: @_competitor
      el: @$el.find("section.competitor")
    @_competitor_view.render()
