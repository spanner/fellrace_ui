class FellRace.Views.SessionResetForm extends Backbone.Marionette.ItemView
  template: 'sessions/reset_form'

  events:
    'submit form': 'request_reset'
    'click a.reconfirm': 'reconfirm'
    'click a.sign_in': 'signIn'

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

  request_reset: (e) =>
    e.preventDefault()
    @$el.find('.error').remove()
    @_form.find('input[type="submit"]').disable()
    $.ajax
      url: "#{_fellrace.apiUrl()}/users/password"
      type: "post"
      data:
        user:
          email: @model.get('email')
      success: @succeed
      error: @fail

  succeed: () =>
    $.notify "success", "Password reset instructions sent to #{@model.get "email"}"
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
    value

  reconfirm: =>
    _fellrace.user_actions().reconfirm()

  signIn: =>
    _fellrace.user_actions().signIn()
