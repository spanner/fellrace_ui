class Results.Models.Performance extends Backbone.Model
  urlRoot: =>
    "/api/instances/#{@get "instance_id"}/performances"

  initialize: =>
    if @has "competitor"
      @_competitor = new Results.Models.Competitor(@get "competitor")
    @colour = @collection.colourScale?(@get("position") % 10)

  getCPyValues: (property) =>
    positions = [{y: 0,x: 0}]
    # _.each @collection.checkpoints, (cp,i) =>
    _.each @collection.checkpoints, (cp) =>
      if cp_record = @get("checkpoints")?[cp.name]
        if property is "elapsed_time"
          y = cp_record.elapsed_time - cp.least_elapsed_time
        else
          y = cp_record[property]
        if y
          position =
            y: y
            x: cp.least_elapsed_time
          positions.push position
    positions

  getHighest: (property) =>
    worst = 0
    _.each @collection.checkpoints, (cp) =>
      if val = @get("checkpoints")?[cp.name]?[property]
        if property is "time"
          val = val - cp.least_elapsed_time
        if val > worst
          worst = val
    worst

  # name: =>
  #   if @_competitor
  #     @_competitor.get "name"
  #   else
  #     @get "name"

  # worstPos: =>
  #   worst_pos = 0
  #   for cp, i in @collection.checkpoints
  #     if pos = @get(cp.name)?.position
  #       if split > pos
  #         worst_pos = pos
  #   worst_pos
  # 
  # worstSplitPos: =>
  #   worst_split = 0
  #   for cp, i in @collection.checkpoints
  #     if split = @get(cp.name)?.split_position
  #       if split > worst_split
  #         worst_split = split
  #   worst_split