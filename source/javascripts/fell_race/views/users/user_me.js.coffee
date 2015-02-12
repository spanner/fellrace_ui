class FellRace.Views.Me extends Backbone.Marionette.ItemView
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
    @model = _fellrace.currentUser()
    @render()

  onRender: =>
    @stickit()
    events_list = new FellRace.Views.EventsList
      collection: _fellrace.events
      el: @$el.find ".events"
    events_list.render()
    if @model.hasCompetitor()
      competitor_view = new FellRace.Views.CompetitorProfile
        model: @model.getCompetitor()
        el: @$el.find "#competitor"
      competitor_view.render()

  newEvent: =>
    _fellrace.events.add(user_id: @model.get("id"))
