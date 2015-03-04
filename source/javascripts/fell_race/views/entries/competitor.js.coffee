class FellRace.Views.EntryCompetitor extends Backbone.Marionette.ItemView
  template: 'entries/competitor'

  bindings:
    "input.forename": "forename"
    "input.middlename": "middlename"
    "input.surname": "surname"

    "input[name='gender']": "gender"

  onRender: =>
    @stickit()
