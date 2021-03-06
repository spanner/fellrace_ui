class FellRace.Views.AdminCompetitorLayout extends FellRace.Views.LayoutView
  routes: =>
    "(/)": @default

  initialize: ->
    super
    view = new FellRace.Views.AdminCompetitor
      model: @model
    _fellrace.mainRegion.show view

  default: =>
    _fellrace.closeRight()

class FellRace.Views.AdminCompetitorsLayout extends FellRace.Views.LayoutView
  routes: =>
    ":id(/*path)": @competitor

  competitor: (id, path) =>
    if @_previous.route is "competitor" and @_previous.param is id
      @_previous.view.handle(path)
    else
      model = new FellRace.Models.Competitor(id:id)
      $.getJSON "#{model.url()}/permissions", (data) ->
        if data.permissions?.can_edit
          $.getJSON "#{model.url()}/edit", (data) ->
            model.set data
            view = new FellRace.Views.AdminCompetitorLayout
              model: model
            @_previous =
              route: "competitor"
              view: view
              param: id
        else
          _fellrace.navigate "/runners/#{id}"
