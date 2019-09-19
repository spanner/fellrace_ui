class FellRace.Views.ConfirmationRequired extends FellRace.View
  template: 'sessions/confirmation_required'

  events:
    "click": "click"

  bindings:
    "#email": "email"
    "span.email":
      observe: "email"
      update: "checkValidity"

  initialize: ->
    @model = _fr.currentUser()

  onRender: =>
    @stickit()

  click: =>
    _fr.user_actions().reconfirm()

class FellRace.Views.SessionReconfirmationForm extends FellRace.View
  template: 'sessions/reconfirmation_form'

  events:
    'submit form': 'request_confirmation'
    'click a.request_reset': 'requestReset'
    'click a.sign_up': 'signUp'

  bindings:
    "#email": "email"
    "span.email": 
      observe: "email"
      update: "checkValidity"

  initialize: () ->
    @model = _fr.session

  onRender: () =>
    @_form = @$el.find('form')
    @_notes = @$el.find('p.note')
    @_confirmation = @$el.find('.confirmation')
    @delegateEvents(@events)
    @stickit()
    @$el.find("input").checkAndTriggerAutoFillEvent()

  request_confirmation: (e) =>
    e.preventDefault()
    @$el.find('.error').remove()
    @_form.find('input[type="submit"]').disable()
    $.ajax
      url: "#{_fr.apiUrl()}/users/reconfirm"
      type: "post"
      data:
        user:
          email: @model.get('email')
      success: @succeed
      error: @fail

  succeed: () =>
    _fr.broadcast "success", "Reconfirmation instructions sent to #{@model.get "email"}"
    _fr.actionRegion.close()
    # @_form.slideUp () =>
    #   @_confirmation.show()

  fail: () =>
    @_error = $("<p />").insertAfter(@_form)
    @_error.addClass('error').text("Problem!")
    @_form.find('input[type="submit"]').enable()

  checkValidity: ($el, value, model, options) =>
    # this is not your most sophisticated email validation 
    # but it gives us the right interaction
    @_atter ?= new RegExp('@\\S')
    @_dotter ?= new RegExp('\\.\\S')
    @_submit ?= @_form.find('input[type="submit"]')
    if value and value isnt "" and @_atter.test(value) and @_dotter.test(value)
      @_submit.enable()
      @_notes.show()
    else
      @_notes.hide()
      @_submit.disable()
    $el.text(value)

  requestReset: =>
    _fr.user_actions().requestReset()

  signUp: =>
    _fr.user_actions().signUp()
