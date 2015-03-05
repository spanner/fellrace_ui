class FellRace.Views.UserActionMenu extends Backbone.Marionette.ItemView
  template: "users/action_menu"

  events:
    "click a.signout": "signout"
    "click a": "closeMenu"

  bindings: 
    ".name": 
      observe: ["first_name", "last_name"]
      onGet: "fullName"

  initialize: ->
    @model = _fellrace.currentUser()

  onRender: =>
    @stickit()

  fullName: ([first_name, last_name]=[]) =>
    [first_name, last_name].join(' ')
  
  signout: () =>
    _fellrace.user_actions().signOut()

  closeMenu: =>
    _fellrace.user_actions().hideAction()
