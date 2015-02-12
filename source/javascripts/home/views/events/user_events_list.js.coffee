class Home.Views.UserEventsList extends Backbone.Marionette.ItemView
  template: 'events/user_events_list'
  className: 'user_events'
  events:
    "click a.add_event": "addEvent"
    
  bindings: 
    '.first_name': 'first_name'
    '.last_name': 'last_name'

  initialize: ->
    @model = Home.session.user
    Home.vent.on "auth.change", @render

  onRender: =>
    state = Home.session.getState()
    if state is Home.Models.UserSession.confirmedState
      @$el.show()
      @_events = new Home.Collections.Events()
      @_events.fetch
        success: () =>
          new Home.Views.EventsList(collection: @_events).render()
    else
      @$el.hide()
    @stickit()

  addEvent: (e) =>
    e.preventDefault()
    $(".add_event").hide()
    new_event_view = new Home.Views.NewEvent(el: @$el.find(".new_event"))
    new_event_view.render()
    event = new_event_view.model
    event.on "created", =>
      $(".add_event").show()
      @_events.add event

