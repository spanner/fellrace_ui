class FellRace.Views.IndexView extends Backbone.Marionette.Layout
  template: "index"
  id: "index"

  events:
    "click a.sign_up_for_event": "signUpForEvent"

  bindings:
    ".get_yours":
      observe: "state"
      visible: (val) =>
        val is FellRace.Models.UserSession.unknownState
    ".confirm":
      observe: "state"
      visible: (val) =>
        val is FellRace.Models.UserSession.unconfirmedState

  initialize: =>
    @model = _fellrace.session

  onRender: =>
    _fellrace.setMapOptions()
    @stickit()
    confirmation = new FellRace.Views.UserConfirmationNotice
      el: @$el.find(".confirm")
    confirmation.render()

    future_list = new FellRace.Views.FutureIndexInstances
      collection: _fellrace.future_instances
      template: "instances/future_list"
      el: @$el.find("#future_instances")
    future_list.render()

    past_list = new FellRace.Views.PastIndexInstances
      collection: _fellrace.past_instances
      template: "instances/past_list"
      el: @$el.find("#past_instances")
    past_list.render()

  signUpForEvent: =>
    _fellrace.actionRegion.show(new FellRace.Views.UserSignupFormForRace())
