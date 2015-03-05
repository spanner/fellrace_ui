class FellRace.Views.UserControls extends Backbone.Marionette.ItemView
  template: "users/controls"

  #bindings: avatar image

  events:
    "click a.avatar": "showAction"

  initialize: ->
    @model = _fellrace.session

  onRender: =>
    #@stickit()
    
  showAction: =>
    if @model.signedIn()
      _fellrace.user_actions().menu()
    else
      _fellrace.user_actions().signIn()

  inlineBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()
