class FellRace.Views.NewEntry extends Backbone.Marionette.ItemView
  template: 'entries/new'

  bindings:
    "a.create":
      observe: "ready"
      onGet: "readyText"
      attributes: [
        observe: "ready"
        name: "class"
        onGet: "readyClass"
      ]

  initialize: ->
    @_competitor = _fellrace.getCurrentCompetitor()

  onRender: =>
    @stickit()
    @_competitor_view = new FellRace.Views.EntryCompetitor
      model: @_competitor
      el: @$el.find("section.competitor")
    @_competitor_view.render()

  readyClass: (ready) ->
    "unavailable" unless ready

  readyText: (ready) ->
    if ready
      "Confirm"
    else
      "incomplete"
