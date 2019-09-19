class FellRace.Views.UserPrefs extends FellRace.View
  template: 'users/preferences'
  id: "user"

  events:
    "click a.save": "save"

  bindings:
    "input#first_name": "first_name"
    "input#last_name": "last_name"
    "input#email": "email"

  onRender: =>
    @stickit()

  save: =>
    console.log "saving"
