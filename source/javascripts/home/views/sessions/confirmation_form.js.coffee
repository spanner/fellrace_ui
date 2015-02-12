class Home.Views.SessionConfirmationForm extends Backbone.Marionette.ItemView
  template: 'sessions/confirmation_form'
  className: 'confirmation'

  events:
    'submit form': 'submit'

  bindings:
    "#first_name": "first_name"
    "#last_name": "last_name"
    "#password": "password"
    "#password_confirmation": "password_confirmation"
    ".domain": 
      observe: "desired_slug"
      onGet: "showDomain"
    ".password_confirmation":
      observe: "password"
      update: "showIfPasswordValid"
    '.buttons':
      observe: "password_confirmation"
      update: "showIfPasswordConfirmed"

  initialize: (opts={}) ->
    @model = Home.session.user
    @_uid = opts.uid
    @_tok = opts.token

  onRender: () =>
    state = Home.session.get('state')
    # show 'no need' message if already confirmed.
    @$el.find('.waiter').show()
    @$el.find('form').hide()
    @$el.find('.confirmation').hide()
    @$el.find('.refusal').hide()
    @$el.find('#password').complexify @showComplexity
    @stickit()
    $.ajax
      url: "/api/users/verify"
      type: "POST"
      data: 
        uid: @_uid
        tok: @_tok
      success: @allow
      error: @deny
  
  allow: (json) =>
    Home.session.setUser(json)
    @$el.find('.waiter').hide()
    @$el.find('.password_confirmation').hide()
    @$el.find('form').slideDown()
    
  deny: () =>
    Home.session.reset()
    @$el.find('.waiter').hide()
    @$el.find('.refusal').slideDown()

  submit: (e) =>
    e.preventDefault()
    @$el.find('.error').remove()
    @model.save @model.attributes,
      error: @fail
      success: (json) =>
        Home.navigate("/")
        Home.session.setUser(json)
        #TODO: show friendly starter message, set status to 'new user' somehow

  fail: (err) =>
    console.log "confirmation error", err

  showIfPasswordValid: ($el, val, model, options) =>
    # password security is left to user
    #TODO: add a strength meter
    if val? and val.length >= 6
      $el.slideDown()
    else
      $el.slideUp() 

  showIfPasswordConfirmed: ($el, val, model, options) =>
    if val? and val isnt "" and val is model.get('password')
      $el.enable() 
    else
      $el.disable() 

  showDomain: (value) =>
    "#{value}.fellrace.org.uk"


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
    
    
