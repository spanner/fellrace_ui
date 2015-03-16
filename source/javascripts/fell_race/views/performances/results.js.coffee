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

    "span.pos":
      observe: ["position","status"]
      onGet: ([pos,status]=[]) =>
        if status.id != 100
          status.name
        else
          pos
    "span.club": "club"
    "span.cat": "cat"

    "span.name":
      observe: ["competitor_id","forename","middlename","surname"]
      onGet: "perfFullName"

    "a.name":
      observe: ["competitor_id","competitor_forename","competitor_middlename","competitor_surname"]
      onGet: "compFullName"
      attributes: [
        {
          name: "href"
          observe: ["competitor_id","race_slug","instance_name"]
          onGet: "compUrl"
        },
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
    seconds.toSimplestTime()

  initialize: ({checkpoints:@_checkpoints}={}) ->
    #

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

  collectionEvents:
    sort: "sort"

  events:
    "click th a": "sortByColumn"

  itemViewOptions: =>
    checkpoints: @_checkpoints

  initialize: ->
    @_checkpoints = _.without(@model.checkpoints.pluck('name'), 'Start')

  onRender: =>
    _.each @_checkpoints, (cp) =>
      @$el.find("thead tr").append "<th class='checkpoint'>#{cp}</th>"

  sortByColumn: (e) =>
    if attr = e.target.getAttribute("data-sort")
      if @_sort?.attr is attr and @_sort.order is "Asc"
        order = "Desc"
      else
        order = "Asc"
      @collection.comparator = @collection["#{attr}#{order}"] # e.g. "posAsc"
      @collection.sort()
      @_sort =
        attr: attr
        order: order

  sort: =>
    @render()

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
    "#{time?.toSimplestTime()} (#{pos})" if pos

  onRender: =>
    @stickit()
