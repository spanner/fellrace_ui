class FellRace.Views.IndexView extends Backbone.Marionette.Layout
  template: "index"
  id: "index"

  events:
    "click a.sign_up_for_event": "signUpForEvent"

  bindings:
    ".getting_started":
      observe: "state"
      visible: (val) =>
        val is FellRace.Models.UserSession.unknownState
    ".confirm":
      observe: "state"
      visible: (val) =>
        val is FellRace.Models.UserSession.unconfirmedState

  initialize: =>
    @model = _fellrace.session
    @collection = _fellrace.race_publications
    @collection.fetch()

  onRender: =>
    _fellrace.setMapOptions()
    @stickit()
    confirmation = new FellRace.Views.UserConfirmationNotice
      el: @$el.find(".confirm")
    confirmation.render()

    future_list = new FellRace.Views.FutureInstances
      template: "instances/future_list"
      el: @$el.find("#future_instances")
    future_list.render()

    past_list = new FellRace.Views.PastInstances
      template: "instances/past_list"
      el: @$el.find("#past_instances")
    past_list.render()

    # future_list = new FellRace.Views.PublicationsList
    #   collection_filter: "future"
    #   collection: @collection
    #   el: @$el.find("#future_publications")
    # future_list.render()
    #
    # past_list = new FellRace.Views.PublicationsList
    #   collection_filter: "past"
    #   collection: @collection
    #   el: @$el.find("#past_publications")
    # past_list.render()

  signUpForEvent: =>
    _fellrace.actionRegion.show(new FellRace.Views.UserSignupFormForEvent())
