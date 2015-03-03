class FellRace.Views.UserControls extends Backbone.Marionette.ItemView
  template: "users/controls"

  events:
    "click a.sign_in": "signInForm"
    "click a.sign_out": "signOut"

  bindings:
    "a.sign_in":
      observe: "state"
      visible: (val) ->
        val isnt FellRace.Models.UserSession.confirmedState
      visibleFn: "inlineBlock"

    "a.sign_out":
      observe: "state"
      visible: (val) ->
        val is FellRace.Models.UserSession.confirmedState
      visibleFn: "inlineBlock"

    "a.me":
      observe: "state"
      visible: (val) ->
        val is FellRace.Models.UserSession.confirmedState
      visibleFn: "inlineBlock"

  initialize: ->
    @model = _fellrace.session

  onRender: =>
    @stickit()

  signOut: =>
    _fellrace.session.reset()
    $.notify "success", "Goodbye"

  signInForm: =>
    _fellrace.user_actions().signIn()

  inlineBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()
