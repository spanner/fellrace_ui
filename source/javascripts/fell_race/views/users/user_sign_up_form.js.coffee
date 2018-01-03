class FellRace.Views.UserSignupForm extends Backbone.Marionette.ItemView
  template: 'users/sign_up'

  events:
    'submit form': 'signup'
    'click a.sign_in': "signIn"

  bindings:
    "#email": "email"
    "span.email":
      observe: "email"
      update: "checkValidity"
    
  initialize: (opts={}) ->
    @_opts = opts
    @model = _fr.currentUser()
    _fr.vent.on "auth.change", @observeState

  onRender: () =>
    @_form = @$el.find('form')
    @stickit()

  observeState: () =>
    if _fr.session.signedIn()
      @$el.hide()
    else
      @$el.show()

  allow: () =>
    @_form.find('fieldset.user').slideDown()

  deny: () =>
    @_form.find('fieldset.user').slideUp()

  checkValidity: ($el, value, model, options) =>
    # this is not your most sophisticated email validation
    # but it gives us the right interaction
    @_atter ?= new RegExp('@\\S')
    @_dotter ?= new RegExp('\\.\\S')
    @_submit ?= @_form.find('input[type="submit"]')
    @_notes ?= @_form.find('.note')
    if value and value isnt "" and @_atter.test(value) and @_dotter.test(value)
      @_submit.enable()
      @_notes.show()
      $el.text(value + '.')
    else
      @_notes.hide()
      @_submit.disable()
      $el.text("this address.")
    value

  signup: (e) =>
    e.preventDefault() if e
    @$el.find('input[type="submit"]').disable()
    @$el.find('.error').remove()
    @$el.find('.help').remove()
    @$el.find('.erratic').removeClass('error')

    # Registration is just a user#save, which means token and other properties
    # are set automatically by the response. Interface state is updated in
    # response to auth.* events triggered by the session.
    #
    attrs = _.extend @model.attributes, @_opts
    @model.save attrs,
      success: (model, data) =>
        _fr.session.setUser(data)
        _fr.actionRegion.close()
        $.notify "success", "Confirmation email sent to #{@model.get "email"}"
      error: (model, response) =>
        result = $.parseJSON(response.responseText)
        _(result.errors).each (errors,field) =>
          $("input.#{field}").addClass('erratic')
        @$el.find('input[type="submit"]').val('Sign up').removeClass('unavailable')

  signIn: =>
    _fr.user_actions().signIn(@_opts)
