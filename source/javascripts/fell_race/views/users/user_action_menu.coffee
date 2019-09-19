class FellRace.Views.UserActionMenu extends Backbone.Marionette.ItemView
  template: "users/action_menu"

  events:
    "click a.signout": "signout"
    "click a": "closeMenu"
    "click a.find_me": "findMe"

  bindings: 
    ".name": 
      observe: ["first_name", "last_name"]
      onGet: "fullName"

    ".find_me":
      observe: "geo_location"
      visible: true

  initialize: ->
    @model = _fr.currentUser()
    unless Modernizr.geolocation
      @$el.find("li.find_me").hide()

  onRender: =>
    @stickit()

  fullName: ([first_name, last_name]=[]) =>
    [first_name, last_name].join(' ')
  
  signout: () =>
    _fr.user_actions().signOut()

  closeMenu: =>
    _fr.user_actions().hideAction()

  findMe: =>
    @model.findUserLocation()
