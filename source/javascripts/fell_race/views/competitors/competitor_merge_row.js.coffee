class FellRace.Views.CompetitorMergeRow extends Backbone.Marionette.ItemView
  template: 'competitors/merge_row'
  className: "competitor"
  tagName: "tr"

  events:
    "click a.accept": "accept"
    "click a.reject": "reject"

  bindings:
    ".name": 
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
    ".club": "club_name"
    ".dob": "dob"
    ".gender": "gender"
    # ":el":
    #   observe: "main_competitor"
    #   # updateView: false
    #   visible: true
    #   update: (val) =>
    #     @_main_competitor.set val

  onRender: =>
    @_main_competitor = new FellRace.Models.Competitor(@model.get("main_competitor"))
    new FellRace.Views.MainCompetitor(
      model: @_main_competitor
      el: @$el.find(".main_competitor")).render()
    @stickit()

  name: (values) =>
    "#{values[0]} #{values[1]}"

  reject: =>
    @model.save merge_to_id: null,
      success: (data) =>
        @remove()
        $.notify "success", "Merge rejected"

  accept: =>
    $.ajax
      url: "#{@model.url()}/merge"
      type: "POST"
      dataType: "text"
      success: =>
        @remove()
        $.notify "success", "Merge successful"