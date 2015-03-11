class FellRace.Views.ConfirmationRequired extends Backbone.Marionette.ItemView
  template: 'sessions/confirmation_required'

  events:
    "click": "click"

  bindings:
    "#email": "email"
    "span.email":
      observe: "email"
      update: "checkValidity"

  initialize: ->
    @model = _fellrace.currentUser()

  onRender: =>
    @stickit()

  click: =>
    _fellrace.user_actions().reconfirm()

class FellRace.Views.SessionReconfirmationForm extends Backbone.Marionette.ItemView
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
    @model = _fellrace.session

  onRender: () =>
    @_form = @$el.find('form')
    @_notes = @$el.find('p.note')
    @_confirmation = @$el.find('.confirmation')
    @delegateEvents(@events)
    @stickit()

  request_confirmation: (e) =>
    e.preventDefault()
    @$el.find('.error').remove()
    @_form.find('input[type="submit"]').disable()
    $.ajax
      url: "#{_fellrace.apiUrl()}/users/reconfirm"
      type: "post"
      data:
        user:
          email: @model.get('email')
      success: @succeed
      error: @fail

  succeed: () =>
    $.notify "success", "Reconfirmation instructions sent to #{@model.get "email"}"
    _fellrace.actionRegion.close()
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
    _fellrace.user_actions().requestReset()

  signUp: =>
    _fellrace.user_actions().signUp()
