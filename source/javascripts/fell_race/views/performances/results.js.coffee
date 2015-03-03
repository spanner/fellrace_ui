class FellRace.Views.ResultRow extends Backbone.Marionette.ItemView
  template: "performances/result_row"
  tagName: "tr"
  bindings:

    ":el":
      attributes: [
        observe: "cat"
        name: "class"
        onGet: (cat) =>
          "female" if cat?.match /[lfw]/i
      ]

    "span.pos": "position"
    "span.club": "club"
    "span.cat": "cat"

    "span.name":
      observe: ["competitor_id","forename","middlename","surname"]
      onGet: "perfFullName"

    "a.name":
      observe: ["competitor_id","competitor_forename","competitor_middlename","competitor_surname"]
      onGet: "compFullName"
      attributes: [
        # {
        #   name: "href"
        #   observe: ["competitor_id","race_slug","instance_name"]
        #   onGet: "compUrl"
        # },
        {
          observe: "current"
          name: "class"
          onGet: (current) =>
            "current" if current
        }
      ]

    "span.time":
      observe: "time"
      onGet: "time"

  time: (seconds) =>
    _fellrace.secondsToString seconds

  initialize: ({checkpoints:@_checkpoints}) ->
    @$el.on "mouseenter", =>
      @model.trigger "hover"
    @$el.on "mouseleave", =>
      @model.trigger "unhover"
    @model.on "hover", @highlight
    @model.on "unhover", @unhighlight

  highlight: =>
    @$el.addClass "hover"

  unhighlight: =>
    @$el.removeClass "hover"

  onRender: =>
    @stickit()
    _.each @_checkpoints, (cp) =>
      view = new FellRace.Views.CheckpointCell
        model: new Backbone.Model @model.get("checkpoints")?[cp]
      @$el.append view.render().$el

  compFullName: ([id,first,middle,last]=[]) =>
    @fullName([first,middle,last]) if id

  perfFullName: ([id,first,middle,last]=[]) =>
    @fullName([first,middle,last]) unless id

  fullName: ([first,middle,last]=[]) =>
    name = first
    name = "#{name} #{middle}" if middle
    "#{name} #{last}"

  compUrl: ([id,race_slug,instance_name]=[]) =>
    "/runners/#{id}/#{race_slug}/#{instance_name}"


class FellRace.Views.ResultsTable extends Backbone.Marionette.CompositeView
  template: "performances/results_table"
  itemView: FellRace.Views.ResultRow
  itemViewContainer: "tbody"

  itemViewOptions: =>
    checkpoints: @_checkpoints

  initialize: ->
    @_checkpoints = _.without(@model.checkpoints.pluck('name'), 'Start')

  onRender: =>
    _.each @_checkpoints, (cp) =>
      @$el.find("thead tr").append "<th class='checkpoint'>#{cp}</th>"


class FellRace.Views.CheckpointCell extends Backbone.Marionette.ItemView
  template: "performances/checkpoint_cell"
  tagName: "td"
  className: "checkpoint"

  bindings:
    "span.elapsed":
      observe: ["elapsed_time","position"]
      onGet: "timeAndPos"
    "span.split":
      observe: ["interval","split_position"]
      onGet: "timeAndPos"

  timeAndPos: ([time,pos]=[]) ->
    "#{_fellrace.secondsToString(time)} (#{pos})" if pos

  onRender: =>
    @stickit()
