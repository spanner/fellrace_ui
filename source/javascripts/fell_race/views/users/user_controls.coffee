class FellRace.Views.UserControls extends FellRace.View
  template: "users/controls"

  #bindings: avatar image

  events:
    "click a.avatar": "showAction"

  initialize: ->
    @model = _fr.session

  onRender: =>
    #@stickit()
    
  showAction: =>
    if @model.signedIn()
      if @model.confirmed()
        _fr.user_actions().menu()
      else
        _fr.user_actions().requestConfirmation()
    else
      _fr.user_actions().signIn()

  inlineBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()
