class FellRace.Views.NextRaceInstance extends Backbone.Marionette.ItemView
  template: "races/next_instance"

  bindings:
    "a.date":
      observe: "date"
      onGet: "date"
      attributes: [
        name: "href"
        observe: ["race_slug","name"]
        onGet: "url"
      ]
    ".time":
      observe: "time"
      onGet: "time"

  onRender: =>
    @stickit @getInstance(), @bindings
    @model.future_instances.on "add remove reset check_dates", () =>
      console.log "some sort of change"
      @stickit @getInstance(), @bindings
    @model.past_instances.on "add remove reset check_dates", () =>
      @stickit @getInstance(), @bindings

  getInstance: =>
    @model.nextOrRecentInstance()

  time: (time) =>
    console.debug "time", time
    "at #{time}" if time and time isnt ""

  url: ([race_slug,name]=[]) =>
    "/admin/races/#{race_slug}/#{name}"

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date
