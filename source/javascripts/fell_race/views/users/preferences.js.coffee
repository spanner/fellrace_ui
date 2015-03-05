class FellRace.Views.UserPrefs extends Backbone.Marionette.ItemView
  template: 'users/preferences'
  id: "user"

  bindings:
    "input#first_name": "first_name"
    "input#last_name": "last_name"
    "input#email": "email"

  onRender: =>
    @stickit()
    console.log "preferences for", @model.get("first_name"), @model.get("last_name")
