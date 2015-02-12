class FellRace.Views.EntryCompetitor extends Backbone.Marionette.ItemView
  template: "competitors/entry"

  initialize: ->
    @setModel()

  onRender: =>
    _fellrace.vent.on "login:changed", =>
      @setModel()
      @stickit()
    @stickit()

  setModel: =>
    @model = _fellrace.getCurrentCompetitor() || new FellRace.Models.Competitor

  show: =>
    @$el.show()

  hide: =>
    @$el.hide()