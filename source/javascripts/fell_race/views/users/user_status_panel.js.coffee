class FellRace.Views.UserStatusPanel extends Backbone.Marionette.ItemView
  template: 'users/status_panel'
  className: 'status_panel'

  # The user status panel is our welcome/status/registration space.
  # It welcomes appropriately, whatever the user's current state.
  # Each of these subviews is listening out for auth changes and 
  # will re-render as required.
  #
  initialize: () ->
    @model = _fellrace.currentUser()
  
  onRender: () =>
    @_signup = new FellRace.Views.UserSignupForm
      el: @$el.find('.signup')
    @_confirm = new FellRace.Views.UserConfirmationNotice
      el: @$el.find('.confirm')
    @_signinout = new FellRace.Views.UserSignInOut
      el: @$el.find('.controls')

