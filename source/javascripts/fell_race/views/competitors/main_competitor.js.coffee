class FellRace.Views.MainCompetitor extends Backbone.Marionette.ItemView
  template: 'competitors/main'
  className: "competitor"
  tagName: "tr"

  bindings:
    ".main_name": 
      observe: ["forename", "surname"]
      onGet: "name"
      attributes: [
        {
          observe: "id"
          name: "href"
          onGet: (val) =>
            "/runners/#{val}"
        }
      ]
    ".main_club": "club_name"
    ".main_dob": "dob"
    ".main_gender": "gender"

  onRender: =>
    @stickit()

  name: (values) =>
    "#{values[0]} #{values[1]}"
