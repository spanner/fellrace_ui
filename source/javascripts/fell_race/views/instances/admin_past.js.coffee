class FellRace.Views.AdminPastInstance extends Backbone.Marionette.ItemView
  template: 'instances/admin_past'
  className: "instance"
  tagName: "section"

  events:
    'click a.delete': "delete"

  bindings:
    ".race_name": "race_name"
    ".instance_name":
      observe: "name"
      onGet: "deSlugify"
    "span.date": "date"
    "span.time": "time"

    "h3.date":
      observe: "date"
      onGet: "date"
    "span.time": "time"

    "p.report": "summary"
    "span.total":
      observe: "performances_count"
      onGet: "summarise"

  onRender: () =>
    new FellRace.Views.ResultsFile(model: @model, el: @$el.find(".results_file")).render()
    new FellRace.Views.ResultsPreview(model: @model, el: @$el.find(".results_preview")).render()
    @$el.find('.editable').editable()
    @stickit()

  filePicked: (e) =>
    if files = @_filefield[0].files
      @model.set file: files.item(0),
        persistChange: true

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  summarise: (value, options) =>
    if !value?
      ""
    else if value == "processing"
      "calculating"
    else
      "#{value} runners"

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date

  deSlugify: (string) ->
    string.split("-").map((w) -> _.str.capitalize(w)).join(" ") if string
