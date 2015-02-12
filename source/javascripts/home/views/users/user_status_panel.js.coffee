class Home.Views.UserStatusPanel extends Backbone.Marionette.ItemView
  template: 'users/panel'
  className: 'status_panel'

  # The user status panel is our welcome/status/registration space.
  # It welcomes appropriately, whatever the user's current state.
  # Each of these subviews is listening out for auth changes and 
  # will re-render as required.
  #
  initialize: () ->
    @model = Home.session.user
  
  onRender: () =>
    @_signup = new Home.Views.UserSignupForm
      el: @$el.find('.signup')
    @_confirm = new Home.Views.UserConfirmationNotice
      el: @$el.find('.confirm')
    @_signinout = new Home.Views.UserSignInOut
      el: @$el.find('.controls')

