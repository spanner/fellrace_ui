class Home.Views.UserSignInOut extends Backbone.Marionette.ItemView
  template: 'users/sign_in_out'
  className: 'controls'

  bindings:
    ".first_name": "first_name"
    ".last_name": "last_name"
    
  initialize: () ->
    @model = Home.session
    Home.vent.on "auth.change", @render
    @render()

  onRender: () =>
    if Home.session.signedIn()
      @$el.find('.sign_in').hide()
      @$el.find('.sign_out').show()
    else
      @$el.find('.sign_in').show()
      @$el.find('.sign_out').hide()
