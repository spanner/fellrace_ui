class FellRace.Views.UserSignupFormForRace extends FellRace.View
  template: 'users/sign_up_for_race'

  events:
    'submit form': 'signup'
    'click a.sign_in': "signIn"

  bindings:
    "#email": "email"
    "#desired_slug":
      observe: "desired_slug"
      onSet: "slugify"
    ".availability": 
      observe: "desired_slug"
      update: "checkSlug"
    "span.email": 
      observe: "email"
      update: "checkValidity"
    "span.outcome": 
      observe: "desired_slug"
      onGet: "showOutcome"
    
  initialize: () ->
    @model = _fr.currentUser()
    @_radio.on "auth.change", @observeState
    $.getJSON "#{_fr.apiUrl()}/races/taken", (response) =>
      @slugs = response
      @render()

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

  check: () =>
    @checkSlug @$el.find("#slug").val()

  slugify: (value, options) =>
    _.string.slugify value

  checkSlug: ($el, value, model, options) =>
    value = _.string.slugify(value)
    @_flag = @$el.find('.availability')
    if value is ""
      $el.removeClass('ok').removeClass('notok').text("Choose your subdomain:")
      @deny()
    else if @slugs? and value in @slugs
      $el.removeClass('ok').addClass('notok').text("#{value}.fellrace.org.uk is not available.")
      @deny()
    else if value.length < 3
      $el.removeClass('ok').addClass('notok').text("At least three letters, please")
      @deny()
    else if value.length >12
      $el.removeClass('ok').addClass('notok').text("No more than 12 letters, please")
      @deny()
    else
      $el.removeClass('notok').addClass('ok').text("#{value}.fellrace.org.uk is available.")
      @allow()

  showOutcome: (value) =>
    if value and value isnt ""
      "to confirm your address and create #{value}.fellrace.org.uk."
    else
      "to confirm your email address."

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
    @model.save @model.attributes,
      success: (model, data) =>
        _fr.session.setUser(data)
        _fr.actionRegion.close()
        _fr.broadcast "success", "Confirmation email sent to #{@model.get "email"}"
      error: (model, response) =>
        result = $.parseJSON(response.responseText)
        _(result.errors).each (errors,field) =>
          $("input.#{field}").addClass('erratic')
        @$el.find('input[type="submit"]').val('Sign up').removeClass('unavailable')

  signIn: =>
    _fr.user_actions().signIn()
