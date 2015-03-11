class FellRace.Views.SessionPasswordForm extends Backbone.Marionette.ItemView
  template: 'sessions/password_form'
  className: 'reset'

  events:
    'submit form': 'submit'

  bindings:
    "#password": "password"
    "#password_confirmation": "password_confirmation"
    ".first_name": "first_name"
    ".last_name": "last_name"
    ".password_confirmation":
      observe: "password"
      update: "showIfPasswordValid"
    '.buttons':
      observe: "password_confirmation"
      update: "showIfPasswordConfirmed"

  initialize: (opts={}) ->
    @model = _fellrace.session.user
    @_uid = opts.uid
    @_tok = opts.token

  onRender: () =>
    @$el.find('.waiter').show()
    @$el.find('form').hide()
    @$el.find('.confirmation').hide()
    @$el.find('.refusal').hide()
    @$el.find('#password').complexify @showComplexity
    @$el.find("input").checkAndTriggerAutoFillEvent()
    @stickit()
    $.ajax "#{_fellrace.apiUrl()}/users/password/edit.json",
      type: "GET"
      data: 
        id: @_uid
        reset_password_token: @_tok
      success: @allow
      error: @deny

  allow: (json) =>
    @model.set(json)
    @$el.find('.waiter').hide()
    @$el.find('form').slideDown()

  deny: () =>
    @$el.find('.waiter').hide()
    @$el.find('.refusal').slideDown()

  submit: (e) =>
    e.preventDefault()
    @$el.find('.error').remove()
    @model.save {},
      error: @fail
      success: (json) =>        # 
        # @$el.find('form').hide()
        # @$el.find('.confirmation').show()
        _fellrace.actionRegion.close()
        _fellrace.navigate('/')
        $.notify "success", "Password successfully changed"
        _fellrace.session.setUser(json)

  fail: (err) =>
    console.log "reset error", err

  showIfPasswordValid: ($el, val, model, options) =>
    if val? and val.length >= 6
      $el.slideDown()
    else
      $el.slideUp() 

  showIfPasswordConfirmed: ($el, val, model, options) =>
    if val? and val isnt "" and val is model.get('password')
      $el.enable() 
    else
      $el.disable() 

  showComplexity: (valid, complexity) =>
    @_passwords ?= @$el.find('#password')
    @_note ?= @$el.find('span.note')
    @_password_labels ?= ['Not great', 'Quite poor', 'Still pretty weak', 'Getting better', 'Not bad', 'Quite good', 'Good password', 'Very good', 'Super', 'Outstanding', "That's probably enough now"]
    if val = @_passwords.val()
      if val.length < 6
        @_note.text("Too short!").css
          'color': "red"
      else
        h = Math.floor(complexity * 160 / 100)
        color = tinycolor({h: h, s: 80, v: 50 }).toHexString()
        label = @_password_labels[Math.floor(complexity * @_password_labels.length / 100)]
        @_note.text(label ).css
          'color': color
    else
      @_note.text("At least 6 characters please").css
        'color': "#bdbdbd"
      @_passwords.css
        'border-color': "#bdbdbd"
    
    
