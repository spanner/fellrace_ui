class FellRace.Views.AdminCompetitor extends Backbone.Marionette.ItemView
  template: 'competitors/admin'
  className: "competitor"

  bindings:
    "span.forename": "forename"
    "span.surname": "surname"
    "span.middlename": "middlename"
    "a.cancel":
      attributes: [
        name: "href"
        observe: "id"
        onGet: (id) => "/runners/#{id}"
      ]

  onRender: =>
    @stickit()
    @$el.find(".editable").editable()

    new FellRace.Views.Picture(model: @model, el: @$el.find(".picture")).render()
