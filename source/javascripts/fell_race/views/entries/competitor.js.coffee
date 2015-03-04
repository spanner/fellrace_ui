class FellRace.Views.EntryCompetitor extends Backbone.Marionette.ItemView
  template: 'entries/competitor'

  bindings:
    "span.forename": "forename"
    "span.middlename": "middlename"
    "span.surname": "surname"

    "input[name='gender']": "gender"

    "span.dob": "dob"

    "span.club": "club"

  onRender: =>
    $.getJSON "#{_fellrace.apiUrl()}/clubs", (data) =>
      console.debug "#{data.length} clubs", data
    @stickit()
    @$el.find(".editable").editable()
