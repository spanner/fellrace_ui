class FellRace.Views.UserPanel extends Backbone.Marionette.ItemView
  template: 'users/panel'
  className: 'status_panel'

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

  # The user status panel is our welcome/status/registration space.
  # It welcomes appropriately, whatever the user's current state.
  # Each of these subviews is listening out for auth changes and 
  # will re-render as required.
  #
  initialize: () ->
    @model = _fellrace.currentUser()
    @render()

  onRender: =>
    @stickit()
    events_list = new FellRace.Views.EventsList
      collection: _fellrace.events
      el: @$el.find ".events"
    events_list.render()

  newEvent: =>
    _fellrace.events.add(user_id: @model.get("id"))
