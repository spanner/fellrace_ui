class FellRace.Views.Me extends FellRace.View
  template: 'users/me'
  className: 'user'

  events:
    "click a.add": "newEvent"

  bindings:
    "a.me":
      observe: "competitor"
      updateView: false
      visible: (val) =>
        val and !!val.id
      attributes: [
        {
          observe: "competitor"
          name: "href"
          onGet: (val) =>
            if val
              "/runners/#{val.id}"
        }
      ]

  initialize: ->
    @model = _fr.currentUser()
    @render()

  onRender: =>
    @stickit()
    events_list = new FellRace.Views.EventsList
      collection: _fr.events
      el: @$el.find ".events"
    events_list.render()
    if @model.hasCompetitor()
      competitor_view = new FellRace.Views.CompetitorProfile
        model: @model.getCompetitor()
        el: @$el.find "#competitor"
      competitor_view.render()

  newEvent: =>
    _fr.events.add(user_id: @model.get("id"))
