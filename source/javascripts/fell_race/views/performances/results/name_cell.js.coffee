class FellRace.Views.NameCell extends Backbone.Marionette.ItemView
  template: "performances/name_cell"
  className: "runner"
  tagName: "td"

  bindings:
    "span.name":
      observe: ["forename","middlename","surname"]
      onGet: "fullName"

  competitor_bindings:
    "a.competitor_name":
      observe: ["forename","middlename","surname"]
      onGet: "fullName"
      attributes: [
        {
          name: "href"
          observe: "id"
          onGet: "url"
        }
      ]

  onRender: =>
    if @model.has("competitor")
      @stickit(new FellRace.Models.Competitor(@model.get("competitor")), @competitor_bindings)
    else
      @stickit()

  fullName: ([first,middle,last]=[]) =>
    name = first
    name = "#{name} #{middle}" if middle
    "#{name} #{last}"

  url: (id) =>
    "/runners/#{id}/#{@raceSlug()}/#{@instanceName()}"

  raceSlug: =>
    @model.getRace().get("slug")

  instanceName: =>
    @model.instance.get("name")
