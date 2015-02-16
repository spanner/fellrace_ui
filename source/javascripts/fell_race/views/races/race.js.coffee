class FellRace.Views.Race extends Backbone.Marionette.ItemView
  template: 'races/show'
  className: "race"
  modelEvents:
    'change:show_route': 'setRouteVisibility'
    'change:show_checkpoints': 'setCheckpointVisibility'

  events:
    # 'click .opener': 'toggle'
    'click .race_head a.delete': 'destroy'
    'click a.add_attachment': 'addAttachment'
    'click a.add_record': 'addRecord'
    'click a.add_checkpoint': 'addCheckpoint'
    # 'click a.add_instance': 'addInstance'
    'click a.add_link': 'addLink'
    'click a.checkpoint_route': "createRouteThroughCheckpoints"
    'click a.draw_route': "drawRoute"
    # 'click a.extend': "drawRoute"
    'click a.delete_route': 'deleteRoute'
    'keyup span.social': 'showPresence'

  bindings:
    # generally best to bind one element with each declaration:
    # updates are not triggered within a set of bound elements.

    '.race_title':
      observe: 'hide_title'
      updateView: false
      visible: (val) ->
        !val
    '.name':
      observe: 'name'
      events: ['blur']
    '.description':
      observe: 'description'
      updateMethod: 'html'
      events: ['blur']
    '.distance':
      observe: 'distance'
      events: ['blur']
    '.climb':
      observe: "climb"
      events: ['blur']
    '.cat':
      observe: 'cat'
      events: ['blur']
    '.race_start_time':
      observe: 'start_time'
      events: ['blur']

    # external event ids
    'span.fb':
      observe: 'fb_event_id'
      events: ['blur']
    'span.twit':
      observe: 'twitter_id'
      events: ['blur']
    'span.fra':
      observe: 'fra_id'
      events: ['blur']
    'span.shr':
      observe: 'shr_id'
      events: ['blur']

    'span.age_limit': 
      onserve: "age_limit"
      events: ['blur']

    'span.analytics_id': "analytics_id"

    'input.race_show_attachments': "show_attachments"
    'ul.attachments':
      observe: "show_attachments"
      updateView: false
      visible: true

    'input.race_show_checkpoints': "show_checkpoints"
    'ul.checkpoints':
      observe: "show_checkpoints"
      updateView: false
      visible: true

    'input.race_show_route': "show_route"

    '.route_controls':
      observe: "show_route"
      updateView: false
      visible: true

    '.route_elevation': "route_elevation"

    '.route_distance':
      observe: "encoded_route"
      onGet: "getRouteDistance"

    'input.route_colour': "route_colour"

    '.no_route':
      observe: "encoded_route"
      updateView: false
      visible: (value) ->
        !value

    '.route_details':
      observe: "encoded_route"
      updateView: false
      visible: true

    'span.race_profile':
      observe: 'route_profile'
      update: "peify"

    'input.race_show_records': "show_records"
    'ul.records': 
      observe: "show_records"
      updateView: false
      visible: true

    'input.race_show_instances': "show_instances"
    'ul.instances':
      observe: "show_instances"
      updateView: false
      visible: true

    'input.race_show_links': "show_links"
    'ul.links':
      observe: "show_links"
      updateView: false
      visible: true
    'ul.autolinks':
      observe: "show_links"
      updateView: false
      visible: true

    '.organiser_name':
      observe: "organiser_name"
      events: ['blur']
    '.organiser_email':
      observe: "organiser_email"
      events: ['blur']
    '.organiser_phone':
      observe: "organiser_phone"
      events: ['blur']
    '.organiser_address':
      observe: "organiser_address"
      events: ['blur']
      onSet: (val) ->
        val = null if /(\<div\>\<br\>\<\/div\>|\<br\>)/.test(val)
        val
    'input.race_show_organiser': "show_organiser"
    '.show_organiser':
      observe: "show_organiser"
      updateView: false
      visible: true

    '.requirements':
      observe: "requirements"
      events: ['blur']
    'input.race_show_requirements': "show_requirements"
    '.show_requirements': 
      observe: "show_requirements"
      updateView: false
      visible: true
    'a.add_instance':
      attributes: [
        {
          observe: "slug"
          name: "href"
          onGet: "newInstanceUrl"
        }
      ]
    # 'a.opener':
    #   attributes: [
    #     {
    #       observe: "selected"
    #       name: "class"
    #       onGet: (selected) =>
    #         "open" if selected
    #     }
    #   ]

    # ':el':
    #   attributes: [
    #     {
    #       observe: "selected"
    #       name: "class"
    #       onGet: (selected) =>
    #         "small" unless selected
    #     }
    #   ]
  #
  # toggle: (e) =>
  #   e.preventDefault()
  #   unless $(e.target).is("[contenteditable]")
  #     @model.trigger "toggle_select"

  onRender: =>
    @stickit()
    @$el.find('.editable').editable()
    @stickit()

    new FellRace.Views.AttachmentsList(collection: @model.attachments, el: @$el.find("ul.attachments")).render()
    new FellRace.Views.LinksList(collection: @model.links, el: @$el.find("ul.links")).render()
    new FellRace.Views.CheckpointsList(collection: @model.checkpoints, el: @$el.find("ul.checkpoints")).render()
    new FellRace.Views.RecordsList(collection: @model.records, el: @$el.find("ul.records")).render()
    new FellRace.Views.InstancesList(collection: @model.instances, el: @$el.find("ul.instances")).render()

  ## Flash a dom element to show that it has changed

  highlight: ($el, val, options) =>
    $el.signal_confirmation()

  ## Add hooks for each of our main collections.
  # The new empty object in each collection will be picked up by the relevant subview.

  addAttachment: =>
    @model.attachments.create({})

  addCheckpoint: =>
    @model.checkpoints.create({})

  addRecord: =>
    @model.records.create({})

  addLink: =>
    @model.links.create({})

  setRouteVisibility: () =>
    if @model.get('show_route') then @model.trigger('show_route') else @model.trigger('hide_route')

  setCheckpointVisibility: () =>
    if @model.get('show_checkpoints') then @model.checkpoints.trigger('show') else @model.checkpoints.trigger('hide')

  createRouteThroughCheckpoints: =>
    @model.createRouteFromCheckpoints()

  drawRoute: =>
    @model.trigger "extend"

  setRoute: (path) =>
    @model.set encoded_route: path

  deleteRoute: =>
    @setRoute null

  showPresence: (e) =>
    el = $(e.currentTarget)
    val = _.str.trim(el.text())
    if val isnt ""
      el.addClass('present')
    else
      el.removeClass('present')

  getRouteDistance: =>
    @model.getRouteDistance()

  newInstanceUrl: (slug) =>
    "/races/#{slug}/new_instance"

  destroy: (e) =>
    e.preventDefault()
    if confirm "Delete '#{@model.get "name"}' race?"
      @model.destroy()

  error: (args) =>
    $.notify "Error fetching record", args

  peify: ($el, value, model, options) =>
    checkExist = setInterval(() =>
      if $el.length
        clearInterval(checkExist)
        $el.text value
        $el.peity("line")
        @old_peify()
    , 100)

  old_peify: () =>
    @$el.find('span.race_profile').peity "line",
      fill: "#e2e1dd"
      stroke: "#d6d6d4"
      width: 480
      height: 100
